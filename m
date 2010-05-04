Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60318 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571Ab0EDUAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 16:00:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: use SET_IEEE80211_PERM_ADDR
Date: Tue,  4 May 2010 15:53:26 -0400
Message-Id: <1273002806-8553-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 4907fef..093b93d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -827,6 +827,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	const char *chip_name, *rf_name = NULL;
 	u32 reg;
 	u16 eeprom_val;
+	u8 mac_addr[ETH_ALEN];
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -987,12 +988,13 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
 	}
 
-	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)dev->wiphy->perm_addr, 3);
-	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
+	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)mac_addr, 3);
+	if (!is_valid_ether_addr(mac_addr)) {
 		printk(KERN_WARNING "%s (rtl8180): Invalid hwaddr! Using"
 		       " randomly generated MAC addr\n", pci_name(pdev));
-		random_ether_addr(dev->wiphy->perm_addr);
+		random_ether_addr(mac_addr);
 	}
+	SET_IEEE80211_PERM_ADDR(dev, mac_addr);
 
 	/* CCK TX power */
 	for (i = 0; i < 14; i += 2) {
@@ -1024,7 +1026,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	}
 
 	printk(KERN_INFO "%s: hwaddr %pM, %s + %s\n",
-	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
+	       wiphy_name(dev->wiphy), mac_addr,
 	       chip_name, priv->rf->name);
 
 	return 0;
-- 
1.6.6.1

