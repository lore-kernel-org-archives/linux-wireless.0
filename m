Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55935 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762787AbXLMG7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:37 -0500
Subject: [PATCH 71/48] libertas: convert RF_CHANNEL to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2t-0005sj-Fh@shinybook.infradead.org> (sfid-20071213_065959_541100_59CF2DBA)
Date: Thu, 13 Dec 2007 01:59:47 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 16:54:15 -0500

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c   |   23 ++++++----
 drivers/net/wireless/libertas/cmd.c     |   71 +++++++++++++++++++++++--------
 drivers/net/wireless/libertas/cmd.h     |    3 +
 drivers/net/wireless/libertas/cmdresp.c |   25 -----------
 drivers/net/wireless/libertas/hostcmd.h |   10 +++--
 5 files changed, 75 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 63bd692..bd9cfe1 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -9,6 +9,7 @@
 #include "decl.h"
 #include "hostcmd.h"
 #include "host.h"
+#include "cmd.h"
 
 
 static const u8 bssid_any[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -165,11 +166,14 @@ done:
 static int update_channel(struct lbs_private *priv)
 {
 	int ret;
+
 	/* the channel in f/w could be out of sync, get the current channel */
 	lbs_deb_enter(LBS_DEB_ASSOC);
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_RF_CHANNEL,
-				    CMD_OPT_802_11_RF_CHANNEL_GET,
-				    CMD_OPTION_WAITFORRSP, 0, NULL);
+
+	ret = lbs_get_channel(priv);
+	if (ret > 0)
+		priv->curbssparams.channel = (u8) ret;
+
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
@@ -203,17 +207,16 @@ static int assoc_helper_channel(struct lbs_private *priv,
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
 	       priv->curbssparams.channel, assoc_req->channel);
 
-	ret = lbs_prepare_and_send_command(priv, CMD_802_11_RF_CHANNEL,
-				CMD_OPT_802_11_RF_CHANNEL_SET,
-				CMD_OPTION_WAITFORRSP, 0, &assoc_req->channel);
-	if (ret < 0) {
+	ret = lbs_set_channel(priv, assoc_req->channel);
+	if (ret < 0)
 		lbs_deb_assoc("ASSOC: channel: error setting channel.");
-	}
 
+	/* FIXME: shouldn't need to grab the channel _again_ after setting
+	 * it since the firmware is supposed to return the new channel, but
+	 * whatever... */
 	ret = update_channel(priv);
-	if (ret < 0) {
+	if (ret < 0)
 		lbs_deb_assoc("ASSOC: channel: error getting channel.");
-	}
 
 	if (assoc_req->channel != priv->curbssparams.channel) {
 		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d",
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index eff7879..32f9f88 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -810,25 +810,65 @@ static int lbs_cmd_mac_multicast_adr(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_cmd_802_11_rf_channel(struct lbs_private *priv,
-				      struct cmd_ds_command *cmd,
-				      int option, void *pdata_buf)
+/**
+ *  @brief Get the radio channel
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *
+ *  @return 	   	The channel on success, error on failure
+ */
+int lbs_get_channel(struct lbs_private *priv)
 {
-	struct cmd_ds_802_11_rf_channel *rfchan = &cmd->params.rfchannel;
+	struct cmd_ds_802_11_rf_channel cmd;
+	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_CMD);
-	cmd->command = cpu_to_le16(CMD_802_11_RF_CHANNEL);
-	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_rf_channel) +
-				S_DS_GEN);
 
-	if (option == CMD_OPT_802_11_RF_CHANNEL_SET) {
-		rfchan->currentchannel = cpu_to_le16(*((u16 *) pdata_buf));
-	}
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_GET);
 
-	rfchan->action = cpu_to_le16(option);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, cmd);
+	if (ret)
+		goto out;
 
-	lbs_deb_leave(LBS_DEB_CMD);
-	return 0;
+	lbs_deb_cmd("current radio channel is %d\n", cmd.channel);
+	ret = (int) cmd.channel;
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
+}
+
+/**
+ *  @brief Set the radio channel
+ *
+ *  @param priv    	A pointer to struct lbs_private structure
+ *  @param channel  	The desired channel, or 0 to clear a locked channel
+ *
+ *  @return 	   	0 on success, error on failure
+ */
+int lbs_set_channel(struct lbs_private *priv, u8 channel)
+{
+	struct cmd_ds_802_11_rf_channel cmd;
+	u8 old_channel = priv->curbssparams.channel;
+	int ret = 0;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_OPT_802_11_RF_CHANNEL_SET);
+	cmd.channel = cpu_to_le16(channel);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_RF_CHANNEL, cmd);
+	if (ret)
+		goto out;
+
+	priv->curbssparams.channel = cmd.channel;
+	lbs_deb_cmd("channel switch from %d to %d\n", old_channel, cmd.channel);
+
+out:
+	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
+	return ret;
 }
 
 static int lbs_cmd_802_11_rssi(struct lbs_private *priv,
@@ -1390,11 +1430,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_reg_access(priv, cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_RF_CHANNEL:
-		ret = lbs_cmd_802_11_rf_channel(priv, cmdptr,
-						 cmd_action, pdata_buf);
-		break;
-
 	case CMD_802_11_RF_TX_POWER:
 		ret = lbs_cmd_802_11_rf_tx_power(priv, cmdptr,
 						  cmd_action, pdata_buf);
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 4bd6f56..5b02d73 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -30,4 +30,7 @@ int lbs_mesh_access(struct lbs_private *priv, uint16_t cmd_action,
 int lbs_get_data_rate(struct lbs_private *priv);
 int lbs_set_data_rate(struct lbs_private *priv, u8 rate);
 
+int lbs_get_channel(struct lbs_private *priv);
+int lbs_set_channel(struct lbs_private *priv, u8 channel);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 797c943..bf9941e 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -325,28 +325,6 @@ static int lbs_ret_802_11_rate_adapt_rateset(struct lbs_private *priv,
 	return 0;
 }
 
-static int lbs_ret_802_11_rf_channel(struct lbs_private *priv,
-				      struct cmd_ds_command *resp)
-{
-	struct cmd_ds_802_11_rf_channel *rfchannel = &resp->params.rfchannel;
-	u16 action = le16_to_cpu(rfchannel->action);
-	u16 newchannel = le16_to_cpu(rfchannel->currentchannel);
-
-	lbs_deb_enter(LBS_DEB_CMD);
-
-	if (action == CMD_OPT_802_11_RF_CHANNEL_GET
-	    && priv->curbssparams.channel != newchannel) {
-		lbs_deb_cmd("channel switch from %d to %d\n",
-		       priv->curbssparams.channel, newchannel);
-
-		/* Update the channel again */
-		priv->curbssparams.channel = newchannel;
-	}
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	return 0;
-}
-
 static int lbs_ret_802_11_rssi(struct lbs_private *priv,
 				struct cmd_ds_command *resp)
 {
@@ -548,9 +526,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 	case CMD_RET(CMD_802_11_RATE_ADAPT_RATESET):
 		ret = lbs_ret_802_11_rate_adapt_rateset(priv, resp);
 		break;
-	case CMD_RET(CMD_802_11_RF_CHANNEL):
-		ret = lbs_ret_802_11_rf_channel(priv, resp);
-		break;
 
 	case CMD_RET(CMD_802_11_RSSI):
 		ret = lbs_ret_802_11_rssi(priv, resp);
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index d51010c..7acb651 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -386,11 +386,13 @@ struct cmd_ds_802_11_inactivity_timeout {
 };
 
 struct cmd_ds_802_11_rf_channel {
+	struct cmd_header hdr;
+
 	__le16 action;
-	__le16 currentchannel;
-	__le16 rftype;
-	__le16 reserved;
-	u8 channellist[32];
+	__le16 channel;
+	__le16 rftype;      /* unused */
+	__le16 reserved;    /* unused */
+	u8 channellist[32]; /* unused */
 };
 
 struct cmd_ds_802_11_rssi {
-- 
1.5.3.4

