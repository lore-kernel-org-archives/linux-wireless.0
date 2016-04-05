Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11437 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbcDEIK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 04:10:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3586x1Y020644
	for <linux-wireless@vger.kernel.org>; Tue, 5 Apr 2016 01:10:56 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 222bekhwmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 01:10:56 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH RESEND 1/7] mwifiex: add support for GTK rekey offload
Date: Tue, 5 Apr 2016 01:04:34 -0700
Message-ID: <1459843480-25956-1-git-send-email-akarwar@marvell.com> (sfid-20160405_101102_488438_ECCB94E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

Added driver functionality to offload GTK rekey to firmware. When
AP sends new GTK, firmware will update it.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 13 +++++++++-
 drivers/net/wireless/marvell/mwifiex/fw.h          | 10 ++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 28 ++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  2 ++
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |  3 +++
 5 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 108e641..ca8cdd2 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3416,6 +3416,16 @@ static void mwifiex_cfg80211_set_wakeup(struct wiphy *wiphy,
 
 	device_set_wakeup_enable(adapter->dev, enabled);
 }
+
+static int mwifiex_set_rekey_data(struct wiphy *wiphy, struct net_device *dev,
+				  struct cfg80211_gtk_rekey_data *data)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	return mwifiex_send_cmd(priv, HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG,
+				HostCmd_ACT_GEN_SET, 0, data, true);
+}
+
 #endif
 
 static int mwifiex_get_coalesce_pkt_type(u8 *byte_seq)
@@ -3938,6 +3948,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.suspend = mwifiex_cfg80211_suspend,
 	.resume = mwifiex_cfg80211_resume,
 	.set_wakeup = mwifiex_cfg80211_set_wakeup,
+	.set_rekey_data = mwifiex_set_rekey_data,
 #endif
 	.set_coalesce = mwifiex_cfg80211_set_coalesce,
 	.tdls_mgmt = mwifiex_cfg80211_tdls_mgmt,
@@ -3954,7 +3965,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support mwifiex_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT |
-		WIPHY_WOWLAN_NET_DETECT,
+		WIPHY_WOWLAN_NET_DETECT | WIPHY_WOWLAN_SUPPORTS_GTK_REKEY,
 	.n_patterns = MWIFIEX_MEF_MAX_FILTERS,
 	.pattern_min_len = 1,
 	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index c134cf8..8703d24 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -372,6 +372,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_COALESCE_CFG                      0x010a
 #define HostCmd_CMD_MGMT_FRAME_REG                    0x010c
 #define HostCmd_CMD_REMAIN_ON_CHAN                    0x010d
+#define HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG             0x010f
 #define HostCmd_CMD_11AC_CFG			      0x0112
 #define HostCmd_CMD_HS_WAKEUP_REASON                  0x0116
 #define HostCmd_CMD_TDLS_CONFIG                       0x0100
@@ -2183,6 +2184,14 @@ struct host_cmd_ds_wakeup_reason {
 	u16  wakeup_reason;
 } __packed;
 
+struct host_cmd_ds_gtk_rekey_params {
+	__le16 action;
+	u8 kck[NL80211_KCK_LEN];
+	u8 kek[NL80211_KEK_LEN];
+	__le32 replay_ctr_low;
+	__le32 replay_ctr_high;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2256,6 +2265,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_multi_chan_policy mc_policy;
 		struct host_cmd_ds_robust_coex coex;
 		struct host_cmd_ds_wakeup_reason hs_wakeup_reason;
+		struct host_cmd_ds_gtk_rekey_params rekey;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 30f1526..8cb895b 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1558,6 +1558,30 @@ static int mwifiex_cmd_robust_coex(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_cmd_gtk_rekey_offload(struct mwifiex_private *priv,
+					 struct host_cmd_ds_command *cmd,
+					 u16 cmd_action,
+					 struct cfg80211_gtk_rekey_data *data)
+{
+	struct host_cmd_ds_gtk_rekey_params *rekey = &cmd->params.rekey;
+	u64 rekey_ctr;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG);
+	cmd->size = cpu_to_le16(sizeof(*rekey) + S_DS_GEN);
+
+	rekey->action = cpu_to_le16(cmd_action);
+	if (cmd_action == HostCmd_ACT_GEN_SET) {
+		memcpy(rekey->kek, data->kek, NL80211_KEK_LEN);
+		memcpy(rekey->kck, data->kck, NL80211_KCK_LEN);
+		rekey_ctr = be64_to_cpup((__be64 *)data->replay_ctr);
+		rekey->replay_ctr_low = cpu_to_le32((u32)rekey_ctr);
+		rekey->replay_ctr_high =
+			cpu_to_le32((u32)((u64)rekey_ctr >> 32));
+	}
+
+	return 0;
+}
+
 static int
 mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *cmd,
@@ -2094,6 +2118,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_robust_coex(priv, cmd_ptr, cmd_action,
 					      data_buf);
 		break;
+	case HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG:
+		ret = mwifiex_cmd_gtk_rekey_offload(priv, cmd_ptr, cmd_action,
+						    data_buf);
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 96732cb..d18c797 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1233,6 +1233,8 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 	case HostCmd_CMD_ROBUST_COEX:
 		ret = mwifiex_ret_robust_coex(priv, resp, data_buf);
 		break;
+	case HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG:
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
 			    "CMD_RESP: unknown cmd response %#x\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 070bce4..0104108 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -147,6 +147,9 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 	if (netif_carrier_ok(priv->netdev))
 		netif_carrier_off(priv->netdev);
+
+	mwifiex_send_cmd(priv, HostCmd_CMD_GTK_REKEY_OFFLOAD_CFG,
+			 HostCmd_ACT_GEN_REMOVE, 0, NULL, false);
 }
 
 static int mwifiex_parse_tdls_event(struct mwifiex_private *priv,
-- 
1.8.1.4

