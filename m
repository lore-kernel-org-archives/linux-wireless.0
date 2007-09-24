Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34443 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750918AbXIXWNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:17 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/6] adm8211: kill version printks
Date: Mon, 24 Sep 2007 18:10:25 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20070924221025.6870.61008.stgit@magic.sourmilk.net>
In-Reply-To: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
References: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

No need to pollute dmesg with copyright info.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 4c43cdb..ce1f8e3 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -39,11 +39,6 @@ static unsigned int rx_ring_size __read_mostly = 16;
 module_param(tx_ring_size, uint, 0);
 module_param(rx_ring_size, uint, 0);
 
-static const char version[] = KERN_INFO "adm8211: "
-"Copyright 2003, Jouni Malinen <j@w1.fi>; "
-"Copyright 2004-2007, Michael Wu <flamingice@sourmilk.net>\n";
-
-
 static struct pci_device_id adm8211_pci_id_table[] __devinitdata = {
 	/* ADMtek ADM8211 */
 	{ PCI_DEVICE(0x10B7, 0x6000) }, /* 3Com 3CRSHPW796 */
@@ -1794,12 +1789,6 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	u8 perm_addr[ETH_ALEN];
 	DECLARE_MAC_BUF(mac);
 
-#ifndef MODULE
-	static unsigned int cardidx;
-	if (!cardidx++)
-		printk(version);
-#endif
-
 	err = pci_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "%s (adm8211): Cannot enable new PCI device\n",
@@ -2051,10 +2040,6 @@ static struct pci_driver adm8211_driver = {
 
 static int __init adm8211_init(void)
 {
-#ifdef MODULE
-	printk(version);
-#endif
-
 	return pci_register_driver(&adm8211_driver);
 }
 

