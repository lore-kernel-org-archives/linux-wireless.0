Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762792AbXLMG7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:33 -0500
Subject: [PATCH 70/48] libertas: convert DATA_RATE to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2s-0005se-Cz@shinybook.infradead.org> (sfid-20071213_070637_678994_210A4462)
Date: Thu, 13 Dec 2007 01:59:46 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 15:50:59 -0500

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   93 ++++++++++++++++++++++++-------
 drivers/net/wireless/libertas/cmd.h     |    3 +
 drivers/net/wireless/libertas/cmdresp.c |   23 --------
 drivers/net/wireless/libertas/hostcmd.h |    3 +-
 drivers/net/wireless/libertas/main.c    |    8 +--
 drivers/net/wireless/libertas/wext.c    |    9 +--
 6 files changed, 83 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 9d621fe..eff7879 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -706,30 +706,86 @@ static int lbs_cmd_802_11_rate_adapt_rateset(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_802_11_data_rate(struct lbs_private *priv,
-				     struct cmd_ds_command *cmd,
-				     u16 cmd_action)
+/**
+ *  @brief Get the current data rate
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *
+ *  @return 	   	The data rate on success, error on failure
+ */
+int lbs_get_data_rate(struct lbs_private *priv)
 {
-	struct cmd_ds_802_11_data_rate *pdatarate = &cmd->params.drate;
+	struct cmd_ds_802_11_data_rate cmd;
+	int ret = -1;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_data_rate) +
-			     S_DS_GEN);
-	cmd->command = cpu_to_le16(CMD_802_11_DATA_RATE);
-	memset(pdatarate, 0, sizeof(struct cmd_ds_802_11_data_rate));
-	pdatarate->action = cpu_to_le16(cmd_action);
-
-	if (cmd_action == CMD_ACT_SET_TX_FIX_RATE) {
-		pdatarate->rates[0] = lbs_data_rate_to_fw_index(priv->cur_rate);
-		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n",
-		       priv->cur_rate);
-	} else if (cmd_action == CMD_ACT_SET_TX_AUTO) {
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_GET_TX_RATE);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, cmd);
+	if (ret)
+		goto out;
+
+	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof (cmd));
+
+	ret = (int) lbs_fw_index_to_data_rate(cmd.rates[0]);
+	lbs_deb_cmd("DATA_RATE: current rate 0x%02x\n", ret);
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief Set the data rate
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param rate  	The desired data rate, or 0 to clear a locked rate
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_set_data_rate(struct lbs_private *priv, u8 rate)
+{
+	struct cmd_ds_802_11_data_rate cmd;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+
+	if (rate > 0) {
+		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_FIX_RATE);
+		cmd.rates[0] = lbs_data_rate_to_fw_index(rate);
+		if (cmd.rates[0] == 0) {
+			lbs_deb_cmd("DATA_RATE: invalid requested rate of"
+			            " 0x%02X\n", rate);
+			ret = 0;
+			goto out;
+		}
+		lbs_deb_cmd("DATA_RATE: set fixed 0x%02X\n", cmd.rates[0]);
+	} else {
+		cmd.action = cpu_to_le16(CMD_ACT_SET_TX_AUTO);
 		lbs_deb_cmd("DATA_RATE: setting auto\n");
 	}
 
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	ret = lbs_cmd_with_response(priv, CMD_802_11_DATA_RATE, cmd);
+	if (ret)
+		goto out;
+
+	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) &cmd, sizeof (cmd));
+
+	/* FIXME: get actual rates FW can do if this command actually returns
+	 * all data rates supported.
+	 */
+	priv->cur_rate = lbs_fw_index_to_data_rate(cmd.rates[0]);
+	lbs_deb_cmd("DATA_RATE: current rate is 0x%02x\n", priv->cur_rate);
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
 }
 
 static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
@@ -1348,9 +1404,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_802_11_radio_control(priv, cmdptr, cmd_action);
 		break;
 
-	case CMD_802_11_DATA_RATE:
-		ret = lbs_cmd_802_11_data_rate(priv, cmdptr, cmd_action);
-		break;
 	case CMD_802_11_RATE_ADAPT_RATESET:
 		ret = lbs_cmd_802_11_rate_adapt_rateset(priv,
 							 cmdptr, cmd_action);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 950acce..4bd6f56 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -27,4 +27,7 @@ int lbs_update_hw_spec(struct lbs_private *priv);
 int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 		    struct cmd_ds_mesh_access *cmd);
 
+int lbs_get_data_rate(struct lbs_private *priv);
+int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 6ff705b..797c943 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -325,26 +325,6 @@ static int lbs_ret_802_11_rate_adapt_rateset(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_ret_802_11_data_rate(struct lbs_private *priv,
-				     struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_data_rate *pdatarate = &resp->params.drate;
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	lbs_deb_hex(LBS_DEB_CMD, "DATA_RATE_RESP", (u8 *) pdatarate,
-		sizeof(struct cmd_ds_802_11_data_rate));
-
-	/* FIXME: get actual rates FW can do if this command actually returns
-	 * all data rates supported.
-	 */
-	priv->cur_rate = lbs_fw_index_to_data_rate(pdatarate->rates[0]);
-	lbs_deb_cmd("DATA_RATE: current rate 0x%02x\n", priv->cur_rate);
-
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_rf_channel(struct lbs_private *priv,
 				      struct cmd_ds_command *resp)
 {
@@ -565,9 +545,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 		ret = lbs_ret_802_11_enable_rsn(priv, resp);
 		break;
 
-	case CMD_RET(CMD_802_11_DATA_RATE):
-		ret = lbs_ret_802_11_data_rate(priv, resp);
-		break;
 	case CMD_RET(CMD_802_11_RATE_ADAPT_RATESET):
 		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
 		break;
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index d9b151a..d51010c 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -461,6 +461,8 @@ struct PS_CMD_ConfirmSleep {
 };
 
 struct cmd_ds_802_11_data_rate {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 reserved;
 	u8 rates[MAX_RATES];
@@ -659,7 +661,6 @@ struct cmd_ds_command {
 		struct cmd_ds_802_11_rf_tx_power txp;
 		struct cmd_ds_802_11_rf_antenna rant;
 		struct cmd_ds_802_11_monitor_mode monitor;
-		struct cmd_ds_802_11_data_rate drate;
 		struct cmd_ds_802_11_rate_adapt_rateset rateset;
 		struct cmd_ds_mac_multicast_adr madr;
 		struct cmd_ds_802_11_ad_hoc_join adj;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 7f6b3cc..2fe7ad0 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -854,12 +854,8 @@ static int lbs_setup_firmware(struct lbs_private *priv)
 
 	lbs_set_mac_packet_filter(priv);
 
-	/* Get the supported Data rates */
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_DATA_RATE,
-				    CMD_ACT_GET_TX_RATE,
-				    CMD_OPTION_WAITFORRSP, 0, NULL);
-
-	if (ret) {
+	ret = lbs_get_data_rate(priv);
+	if (ret < 0) {
 		ret = -1;
 		goto done;
 	}
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 1e0b224..e44c0ce 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -19,6 +19,7 @@
 #include "join.h"
 #include "wext.h"
 #include "assoc.h"
+#include "cmd.h"
 
 
 static inline void lbs_postpone_association_work(struct lbs_private *priv)
@@ -962,8 +963,7 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		  struct iw_param *vwrq, char *extra)
 {
 	struct lbs_private *priv = dev->priv;
-	u32 new_rate;
-	u16 action;
+	u8 new_rate = 0;
 	int ret = -EINVAL;
 	u8 rates[MAX_RATES + 1];
 
@@ -972,7 +972,6 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 
 	/* Auto rate? */
 	if (vwrq->value == -1) {
-		action = CMD_ACT_SET_TX_AUTO;
 		priv->auto_rate = 1;
 		priv->cur_rate = 0;
 	} else {
@@ -989,12 +988,10 @@ static int lbs_set_rate(struct net_device *dev, struct iw_request_info *info,
 		}
 
 		priv->cur_rate = new_rate;
-		action = CMD_ACT_SET_TX_FIX_RATE;
 		priv->auto_rate = 0;
 	}
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_DATA_RATE,
-				    action, CMD_OPTION_WAITFORRSP, 0, NULL);
+	ret = lbs_set_data_rate(priv, new_rate);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
-- 
1.5.3.4

