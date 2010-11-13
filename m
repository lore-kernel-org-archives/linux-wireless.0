Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47580 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab0KMBYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:24:16 -0500
Received: by mail-gw0-f46.google.com with SMTP id 17so250698gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:24:16 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH V2 2/7] mwl8k: rf_tx_power cmd not supported by AP firmware APIv1
Date: Fri, 12 Nov 2010 17:23:48 -0800
Message-Id: <1289611433-5119-3-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

APIv1 AP firmware does not support the RF_TX_POWER command.  It
supports the similar TX_POWER command.

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   78 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f152a25..cfda87a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -285,8 +285,9 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 };
 
 /* Set or get info from Firmware */
-#define MWL8K_CMD_SET			0x0001
 #define MWL8K_CMD_GET			0x0000
+#define MWL8K_CMD_SET			0x0001
+#define MWL8K_CMD_SET_LIST		0x0002
 
 /* Firmware command codes */
 #define MWL8K_CMD_CODE_DNLD		0x0001
@@ -296,6 +297,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_GET_STAT		0x0014
 #define MWL8K_CMD_RADIO_CONTROL		0x001c
 #define MWL8K_CMD_RF_TX_POWER		0x001e
+#define MWL8K_CMD_TX_POWER		0x001f
 #define MWL8K_CMD_RF_ANTENNA		0x0020
 #define MWL8K_CMD_SET_BEACON		0x0100		/* per-vif */
 #define MWL8K_CMD_SET_PRE_SCAN		0x0107
@@ -333,6 +335,7 @@ static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(GET_STAT);
 		MWL8K_CMDNAME(RADIO_CONTROL);
 		MWL8K_CMDNAME(RF_TX_POWER);
+		MWL8K_CMDNAME(TX_POWER);
 		MWL8K_CMDNAME(RF_ANTENNA);
 		MWL8K_CMDNAME(SET_BEACON);
 		MWL8K_CMDNAME(SET_PRE_SCAN);
@@ -2084,7 +2087,7 @@ mwl8k_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
 /*
  * CMD_RF_TX_POWER.
  */
-#define MWL8K_TX_POWER_LEVEL_TOTAL	8
+#define MWL8K_RF_TX_POWER_LEVEL_TOTAL	8
 
 struct mwl8k_cmd_rf_tx_power {
 	struct mwl8k_cmd_pkt header;
@@ -2092,7 +2095,7 @@ struct mwl8k_cmd_rf_tx_power {
 	__le16 support_level;
 	__le16 current_level;
 	__le16 reserved;
-	__le16 power_level_list[MWL8K_TX_POWER_LEVEL_TOTAL];
+	__le16 power_level_list[MWL8K_RF_TX_POWER_LEVEL_TOTAL];
 } __packed;
 
 static int mwl8k_cmd_rf_tx_power(struct ieee80211_hw *hw, int dBm)
@@ -2116,6 +2119,65 @@ static int mwl8k_cmd_rf_tx_power(struct ieee80211_hw *hw, int dBm)
 }
 
 /*
+ * CMD_TX_POWER.
+ */
+#define MWL8K_TX_POWER_LEVEL_TOTAL      12
+
+struct mwl8k_cmd_tx_power {
+	struct mwl8k_cmd_pkt header;
+	__le16 action;
+	__le16 band;
+	__le16 channel;
+	__le16 bw;
+	__le16 sub_ch;
+	__le16 power_level_list[MWL8K_TX_POWER_LEVEL_TOTAL];
+} __attribute__((packed));
+
+static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
+				     struct ieee80211_conf *conf,
+				     unsigned short pwr)
+{
+	struct ieee80211_channel *channel = conf->channel;
+	struct mwl8k_cmd_tx_power *cmd;
+	int rc;
+	int i;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_TX_POWER);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le16(MWL8K_CMD_SET_LIST);
+
+	if (channel->band == IEEE80211_BAND_2GHZ)
+		cmd->band = cpu_to_le16(0x1);
+	else if (channel->band == IEEE80211_BAND_5GHZ)
+		cmd->band = cpu_to_le16(0x4);
+
+	cmd->channel = channel->hw_value;
+
+	if (conf->channel_type == NL80211_CHAN_NO_HT ||
+	    conf->channel_type == NL80211_CHAN_HT20) {
+		cmd->bw = cpu_to_le16(0x2);
+	} else {
+		cmd->bw = cpu_to_le16(0x4);
+		if (conf->channel_type == NL80211_CHAN_HT40MINUS)
+			cmd->sub_ch = cpu_to_le16(0x3);
+		else if (conf->channel_type == NL80211_CHAN_HT40PLUS)
+			cmd->sub_ch = cpu_to_le16(0x1);
+	}
+
+	for (i = 0; i < MWL8K_TX_POWER_LEVEL_TOTAL; i++)
+		cmd->power_level_list[i] = cpu_to_le16(pwr);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_RF_ANTENNA.
  */
 struct mwl8k_cmd_rf_antenna {
@@ -3377,15 +3439,19 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (conf->power_level > 18)
 		conf->power_level = 18;
-	rc = mwl8k_cmd_rf_tx_power(hw, conf->power_level);
-	if (rc)
-		goto out;
 
 	if (priv->ap_fw) {
+		rc = mwl8k_cmd_tx_power(hw, conf, conf->power_level);
+		if (rc)
+			goto out;
+
 		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x7);
 		if (!rc)
 			rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_TX, 0x7);
 	} else {
+		rc = mwl8k_cmd_rf_tx_power(hw, conf->power_level);
+		if (rc)
+			goto out;
 		rc = mwl8k_cmd_mimo_config(hw, 0x7, 0x7);
 	}
 
-- 
1.7.1.1

