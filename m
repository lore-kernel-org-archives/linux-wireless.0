Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49168 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZJVShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:10 -0400
Date: Thu, 22 Oct 2009 20:20:04 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 08/28] mwl8k: clear hardware MAC address if no STA interface configured
Message-ID: <20091022182004.GJ1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there is no STA interface configured, clear the hardware MAC
address to prevent ACKing frames sent to our MAC address.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   43 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 53447f6..fcf7139 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -280,6 +280,7 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 #define MWL8K_CMD_MIMO_CONFIG		0x0125
 #define MWL8K_CMD_USE_FIXED_RATE	0x0126
 #define MWL8K_CMD_ENABLE_SNIFFER	0x0150
+#define MWL8K_CMD_SET_MAC_ADDR		0x0202
 #define MWL8K_CMD_SET_RATEADAPT_MODE	0x0203
 #define MWL8K_CMD_UPDATE_STADB		0x1123
 
@@ -309,6 +310,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(MIMO_CONFIG);
 		MWL8K_CMDNAME(USE_FIXED_RATE);
 		MWL8K_CMDNAME(ENABLE_SNIFFER);
+		MWL8K_CMDNAME(SET_MAC_ADDR);
 		MWL8K_CMDNAME(SET_RATEADAPT_MODE);
 		MWL8K_CMDNAME(UPDATE_STADB);
 	default:
@@ -1903,6 +1905,34 @@ static int mwl8k_enable_sniffer(struct ieee80211_hw *hw, bool enable)
 }
 
 /*
+ * CMD_SET_MAC_ADDR.
+ */
+struct mwl8k_cmd_set_mac_addr {
+	struct mwl8k_cmd_pkt header;
+	__u8 mac_addr[ETH_ALEN];
+} __attribute__((packed));
+
+static int mwl8k_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
+{
+	struct mwl8k_cmd_set_mac_addr *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	memcpy(cmd->mac_addr, mac, ETH_ALEN);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+	kfree(cmd);
+
+	return rc;
+}
+
+
+/*
  * CMD_SET_RATEADAPT_MODE.
  */
 struct mwl8k_cmd_set_rate_adapt_mode {
@@ -2527,7 +2557,8 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif = MWL8K_VIF(conf->vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 
-	/* Save the mac address */
+	/* Set and save the mac address */
+	mwl8k_set_mac_addr(hw, conf->mac_addr);
 	memcpy(mwl8k_vif->mac_addr, conf->mac_addr, ETH_ALEN);
 
 	/* Back pointer to parent config block */
@@ -2555,6 +2586,8 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 	if (priv->vif == NULL)
 		return;
 
+	mwl8k_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
+
 	priv->vif = NULL;
 }
 
@@ -3025,6 +3058,14 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_stop_firmware;
 	}
 
+	/* Clear MAC address */
+	rc = mwl8k_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
+	if (rc) {
+		printk(KERN_ERR "%s: Cannot clear MAC address\n",
+		       wiphy_name(hw->wiphy));
+		goto err_stop_firmware;
+	}
+
 	/* Disable interrupts */
 	iowrite32(0, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 	free_irq(priv->pdev->irq, hw);
-- 
1.5.6.4
