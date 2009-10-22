Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59629 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbZJVSxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:50 -0400
Date: Thu, 22 Oct 2009 20:21:05 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 21/28] mwl8k: rename mwl8k_cmd_get_hw_spec() to mwl8k_cmd_get_hw_spec_sta()
Message-ID: <20091022182105.GW1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the AP version of the command uses a different format.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 38d34ae..5ccea17 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1537,9 +1537,9 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 }
 
 /*
- * GET_HW_SPEC.
+ * CMD_GET_HW_SPEC (STA version).
  */
-struct mwl8k_cmd_get_hw_spec {
+struct mwl8k_cmd_get_hw_spec_sta {
 	struct mwl8k_cmd_pkt header;
 	__u8 hw_rev;
 	__u8 host_interface;
@@ -1558,10 +1558,10 @@ struct mwl8k_cmd_get_hw_spec {
 	__le32 total_rxd;
 } __attribute__((packed));
 
-static int mwl8k_cmd_get_hw_spec(struct ieee80211_hw *hw)
+static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_cmd_get_hw_spec *cmd;
+	struct mwl8k_cmd_get_hw_spec_sta *cmd;
 	int rc;
 	int i;
 
@@ -3210,7 +3210,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
 
 	/* Get config data, mac addrs etc */
-	rc = mwl8k_cmd_get_hw_spec(hw);
+	rc = mwl8k_cmd_get_hw_spec_sta(hw);
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot initialise firmware\n",
 		       wiphy_name(hw->wiphy));
-- 
1.5.6.4
