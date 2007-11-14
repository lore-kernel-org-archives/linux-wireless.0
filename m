Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:17097 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbXKNWVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 17:21:39 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] rtl8180: fix compilation with print_mac changes
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 14 Nov 2007 17:19:52 -0500
Message-ID: <20071114221951.10490.9118.stgit@tetra.sourmilk.net> (sfid-20071114_222143_688727_78C3C052)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes compilation of rtl8180 after the print_mac changes.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_dev.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 517927d..620ebb1 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -727,6 +727,7 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	const char *chip_name, *rf_name;
 	u32 reg;
 	u16 eeprom_val;
+	DECLARE_MAC_BUF(mac);
 
 	err = pci_enable_device(pdev);
 	if (err) {
@@ -939,8 +940,8 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	printk(KERN_INFO "%s: hwaddr " MAC_FMT ", %s + %s\n",
-	       wiphy_name(dev->wiphy), MAC_ARG(dev->wiphy->perm_addr),
+	printk(KERN_INFO "%s: hwaddr %s, %s + %s\n",
+	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
 	       chip_name, rf_name);
 
 	return 0;


