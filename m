Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:49867 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZHXNsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 09:48:06 -0400
Date: Mon, 24 Aug 2009 15:48:07 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mwl8k: separate driver and device info reporting during probe
Message-ID: <20090824134807.GF6102@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only print the driver version once, and condense all per-PHY
information to a single line.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 6e017db..746532e 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -164,7 +164,7 @@ struct mwl8k_priv {
 
 	u16 num_mcaddrs;
 	u8 hw_rev;
-	__le32 fw_rev;
+	u32 fw_rev;
 
 	/*
 	 * Running count of TX packets in flight, to avoid
@@ -2825,11 +2825,16 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 static int __devinit mwl8k_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
+	static int printed_version = 0;
 	struct ieee80211_hw *hw;
 	struct mwl8k_priv *priv;
 	int rc;
 	int i;
-	u8 *fw;
+
+	if (!printed_version) {
+		printk(KERN_INFO "%s version %s\n", MWL8K_DESC, MWL8K_VERSION);
+		printed_version = 1;
+	}
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
@@ -3004,13 +3009,11 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		goto err_stop_firmware;
 	}
 
-	fw = (u8 *)&priv->fw_rev;
-	printk(KERN_INFO "%s: 88W%u %s\n", priv->name, priv->part_num,
-		MWL8K_DESC);
-	printk(KERN_INFO "%s: Driver Ver:%s  Firmware Ver:%u.%u.%u.%u\n",
-		priv->name, MWL8K_VERSION, fw[3], fw[2], fw[1], fw[0]);
-	printk(KERN_INFO "%s: MAC Address: %pM\n", priv->name,
-		hw->wiphy->perm_addr);
+	printk(KERN_INFO "%s: 88w%u v%d, %pM, firmware version %u.%u.%u.%u\n",
+	       wiphy_name(hw->wiphy), priv->part_num, priv->hw_rev,
+	       hw->wiphy->perm_addr,
+	       (priv->fw_rev >> 24) & 0xff, (priv->fw_rev >> 16) & 0xff,
+	       (priv->fw_rev >> 8) & 0xff, priv->fw_rev & 0xff);
 
 	return 0;
 
-- 
1.5.6.4
