Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59623 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZJVSxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:49 -0400
Date: Thu, 22 Oct 2009 20:21:33 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 23/28] mwl8k: implement AP firmware antenna configuration
Message-ID: <20091022182133.GY1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   44 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4a70ce1..0e26a96 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -279,6 +279,7 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 #define MWL8K_CMD_GET_STAT		0x0014
 #define MWL8K_CMD_RADIO_CONTROL		0x001c
 #define MWL8K_CMD_RF_TX_POWER		0x001e
+#define MWL8K_CMD_RF_ANTENNA		0x0020
 #define MWL8K_CMD_SET_PRE_SCAN		0x0107
 #define MWL8K_CMD_SET_POST_SCAN		0x0108
 #define MWL8K_CMD_SET_RF_CHANNEL	0x010a
@@ -310,6 +311,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(GET_STAT);
 		MWL8K_CMDNAME(RADIO_CONTROL);
 		MWL8K_CMDNAME(RF_TX_POWER);
+		MWL8K_CMDNAME(RF_ANTENNA);
 		MWL8K_CMDNAME(SET_PRE_SCAN);
 		MWL8K_CMDNAME(SET_POST_SCAN);
 		MWL8K_CMDNAME(SET_RF_CHANNEL);
@@ -1918,6 +1920,39 @@ static int mwl8k_cmd_802_11_rf_tx_power(struct ieee80211_hw *hw, int dBm)
 }
 
 /*
+ * CMD_RF_ANTENNA.
+ */
+struct mwl8k_cmd_rf_antenna {
+	struct mwl8k_cmd_pkt header;
+	__le16 antenna;
+	__le16 mode;
+} __attribute__((packed));
+
+#define MWL8K_RF_ANTENNA_RX		1
+#define MWL8K_RF_ANTENNA_TX		2
+
+static int
+mwl8k_cmd_rf_antenna(struct ieee80211_hw *hw, int antenna, int mask)
+{
+	struct mwl8k_cmd_rf_antenna *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_RF_ANTENNA);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->antenna = cpu_to_le16(antenna);
+	cmd->mode = cpu_to_le16(mask);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+/*
  * CMD_SET_PRE_SCAN.
  */
 struct mwl8k_cmd_set_pre_scan {
@@ -2831,8 +2866,13 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	if (rc)
 		goto out;
 
-	if (mwl8k_cmd_mimo_config(hw, 0x7, 0x7))
-		rc = -EINVAL;
+	if (priv->ap_fw) {
+		rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_RX, 0x7);
+		if (!rc)
+			rc = mwl8k_cmd_rf_antenna(hw, MWL8K_RF_ANTENNA_TX, 0x7);
+	} else {
+		rc = mwl8k_cmd_mimo_config(hw, 0x7, 0x7);
+	}
 
 out:
 	mwl8k_fw_unlock(hw);
-- 
1.5.6.4
