Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41221 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbcAYHod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:44:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 24/26] staging: wilc1000: add ops tx power in cfg80211
Date: Mon, 25 Jan 2016 16:35:28 +0900
Message-ID: <1453707330-13526-25-git-send-email-glen.lee@atmel.com> (sfid-20160125_084436_414299_F4AEC62E)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements set_tx_power and get_tx_power of cfg80211_ops.
In addition, Id of HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS is changed with 37.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
Changes in V2:
 - changes s32 type of ret with int and do not initialize with bogus value
 - remove unneeded print statement
 - remove unneeded type casting
 - fix checkpatch ERROR: space required before the open parenthesis
 - fix checkpatch ERROR: space required after that ','
 - fix checkpatch ERROR: space prohibited before that ','
---
 drivers/staging/wilc1000/host_interface.c         | 88 ++++++++++++++++++++++-
 drivers/staging/wilc1000/host_interface.h         |  2 +
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 35 +++++++++
 drivers/staging/wilc1000/wilc_wlan_if.h           |  1 +
 4 files changed, 125 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6072d8f..9112f6d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -46,7 +46,9 @@
 #define HOST_IF_MSG_DEL_BA_SESSION              34
 #define HOST_IF_MSG_Q_IDLE                      35
 #define HOST_IF_MSG_DEL_ALL_STA                 36
-#define HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS      34
+#define HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS      37
+#define HOST_IF_MSG_SET_TX_POWER		38
+#define HOST_IF_MSG_GET_TX_POWER		39
 #define HOST_IF_MSG_EXIT                        100
 
 #define HOST_IF_SCAN_TIMEOUT                    4000
@@ -166,6 +168,10 @@ struct sta_inactive_t {
 	u8 mac[6];
 };
 
+struct tx_power {
+	u8 tx_pwr;
+};
+
 union message_body {
 	struct scan_attr scan_info;
 	struct connect_attr con_info;
@@ -191,6 +197,7 @@ union message_body {
 	struct reg_frame reg_frame;
 	char *data;
 	struct del_all_sta del_all_sta_info;
+	struct tx_power tx_power;
 };
 
 struct host_if_msg {
@@ -2787,6 +2794,40 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	return result;
 }
 
+static void handle_set_tx_pwr(struct wilc_vif *vif, u8 tx_pwr)
+{
+	int ret;
+	struct wid wid;
+
+	wid.id = (u16)WID_TX_POWER;
+	wid.type = WID_CHAR;
+	wid.val = &tx_pwr;
+	wid.size = sizeof(char);
+
+	ret = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+			     wilc_get_vif_idx(vif));
+	if (ret)
+		netdev_err(vif->ndev, "Failed to set TX PWR\n");
+}
+
+static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
+{
+	s32 ret = 0;
+	struct wid wid;
+
+	wid.id = (u16)WID_TX_POWER;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)tx_pwr;
+	wid.size = sizeof(char);
+
+	ret = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+			     wilc_get_vif_idx(vif));
+	if (ret)
+		netdev_err(vif->ndev, "Failed to get TX PWR\n");
+
+	up(&hif_sema_wait_response);
+}
+
 static int hostIFthread(void *pvArg)
 {
 	u32 u32Ret;
@@ -2990,6 +3031,13 @@ static int hostIFthread(void *pvArg)
 			Handle_DelAllSta(msg.vif, &msg.body.del_all_sta_info);
 			break;
 
+		case HOST_IF_MSG_SET_TX_POWER:
+			handle_set_tx_pwr(msg.vif, msg.body.tx_power.tx_pwr);
+			break;
+
+		case HOST_IF_MSG_GET_TX_POWER:
+			handle_get_tx_pwr(msg.vif, &msg.body.tx_power.tx_pwr);
+			break;
 		default:
 			PRINT_ER("[Host Interface] undefined Received Msg ID\n");
 			break;
@@ -4608,3 +4656,41 @@ static s32 host_int_get_ipaddress(struct wilc_vif *vif,
 
 	return result;
 }
+
+int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power)
+{
+	int ret = 0;
+	struct host_if_msg msg;
+
+	memset(&msg, 0, sizeof(struct host_if_msg));
+
+	msg.id = HOST_IF_MSG_SET_TX_POWER;
+	msg.body.tx_power.tx_pwr = tx_power;
+	msg.vif = vif;
+
+	ret = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (ret)
+		netdev_err(vif->ndev, "wilc_mq_send fail\n");
+
+	return ret;
+}
+
+int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power)
+{
+	int ret = 0;
+	struct host_if_msg msg;
+
+	memset(&msg, 0, sizeof(struct host_if_msg));
+
+	msg.id = HOST_IF_MSG_GET_TX_POWER;
+	msg.vif = vif;
+
+	ret = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
+	if (ret)
+		netdev_err(vif->ndev, "Failed to get TX PWR\n");
+
+	down(&hif_sema_wait_response);
+	*tx_power = msg.body.tx_power.tx_pwr;
+
+	return ret;
+}
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2893b2e..7724ade 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -371,6 +371,8 @@ void wilc_free_join_params(void *pJoinParams);
 s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
+int wilc_set_tx_power(struct wilc_vif *vif, u8 tx_power);
+int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_power);
 
 extern bool wilc_optaining_ip;
 extern u8 wilc_connected_ssid[6];
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5f7f5e5..dbfcb3b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2504,6 +2504,39 @@ static void wilc_set_wakeup(struct wiphy *wiphy, bool enabled)
 	netdev_info(vif->ndev, "cfg set wake up = %d\n", enabled);
 }
 
+static int set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
+			enum nl80211_tx_power_setting type, int mbm)
+{
+	int ret;
+	s32 tx_power = MBM_TO_DBM(mbm);
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+
+	if (tx_power < 0)
+		tx_power = 0;
+	else if (tx_power > 18)
+		tx_power = 18;
+	ret = wilc_set_tx_power(vif, tx_power);
+	if (ret)
+		netdev_err(vif->ndev, "Failed to set tx power\n");
+
+	return ret;
+}
+
+static int get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
+			int *dbm)
+{
+	int ret;
+	struct wilc_priv *priv = wiphy_priv(wiphy);
+	struct wilc_vif *vif = netdev_priv(priv->dev);
+
+	ret = wilc_get_tx_power(vif, (u8 *)dbm);
+	if (ret)
+		netdev_err(vif->ndev, "Failed to get tx power\n");
+
+	return ret;
+}
+
 static struct cfg80211_ops wilc_cfg80211_ops = {
 	.set_monitor_channel = set_channel,
 	.scan = scan,
@@ -2542,6 +2575,8 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.suspend = wilc_suspend,
 	.resume = wilc_resume,
 	.set_wakeup = wilc_set_wakeup,
+	.set_tx_power = set_tx_power,
+	.get_tx_power = get_tx_power,
 
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index d306ec1a..c446af6 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -761,6 +761,7 @@ typedef enum {
 	WID_DEL_BEACON			= 0x00CA,
 
 	WID_LOGTerminal_Switch		= 0x00CD,
+	WID_TX_POWER			= 0x00CE,
 	/*  EMAC Short WID list */
 	/*  RTS Threshold */
 	/*
-- 
1.9.1

