Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58355 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0AHR2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:28:01 -0500
Date: Fri, 8 Jan 2010 18:27:59 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] mwl8k: minor cleanups
Message-ID: <20100108172752.GU1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a048636..cc16041 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -208,10 +208,7 @@ struct mwl8k_priv {
 
 /* Per interface specific private data */
 struct mwl8k_vif {
-	/* Local MAC address.  */
-	u8 mac_addr[ETH_ALEN];
-
-	/* Non AMPDU sequence number assigned by driver */
+	/* Non AMPDU sequence number assigned by driver.  */
 	u16 seqno;
 };
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
@@ -2287,8 +2284,8 @@ struct mwl8k_cmd_set_rts_threshold {
 	__le16 threshold;
 } __attribute__((packed));
 
-static int mwl8k_cmd_set_rts_threshold(struct ieee80211_hw *hw,
-				       u16 action, u16 threshold)
+static int
+mwl8k_cmd_set_rts_threshold(struct ieee80211_hw *hw, int rts_thresh)
 {
 	struct mwl8k_cmd_set_rts_threshold *cmd;
 	int rc;
@@ -2299,8 +2296,8 @@ static int mwl8k_cmd_set_rts_threshold(struct ieee80211_hw *hw,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_RTS_THRESHOLD);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = cpu_to_le16(action);
-	cmd->threshold = cpu_to_le16(threshold);
+	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
+	cmd->threshold = cpu_to_le16(rts_thresh);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -2955,14 +2952,13 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 		return -EINVAL;
 	}
 
+	/* Set the mac address.  */
+	mwl8k_cmd_set_mac_addr(hw, vif->addr);
+
 	/* Clean out driver private area */
 	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
 
-	/* Set and save the mac address */
-	mwl8k_cmd_set_mac_addr(hw, vif->addr);
-	memcpy(mwl8k_vif->mac_addr, vif->addr, ETH_ALEN);
-
 	/* Set Initial sequence number to zero */
 	mwl8k_vif->seqno = 0;
 
@@ -2977,9 +2973,6 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 {
 	struct mwl8k_priv *priv = hw->priv;
 
-	if (priv->vif == NULL)
-		return;
-
 	mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
 
 	priv->vif = NULL;
@@ -3252,7 +3245,7 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 
 static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	return mwl8k_cmd_set_rts_threshold(hw, MWL8K_CMD_SET, value);
+	return mwl8k_cmd_set_rts_threshold(hw, value);
 }
 
 struct mwl8k_sta_notify_item
@@ -3669,7 +3662,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	/*
 	 * Temporarily enable interrupts.  Initial firmware host
-	 * commands use interrupts and avoids polling.  Disable
+	 * commands use interrupts and avoid polling.  Disable
 	 * interrupts when done.
 	 */
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
-- 
1.5.6.4
