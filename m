Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48162 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0GJMed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 08:34:33 -0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@iki.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] adm8211: fix memory leak
Date: Sat, 10 Jul 2010 16:28:57 +0400
Message-Id: <1278764938-9417-1-git-send-email-segooon@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must free priv->eeprom allocated in adm8211_read_eeprom().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/wireless/adm8211.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 880ad9d..bde2fa8 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1903,7 +1903,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "%s (adm8211): Cannot register device\n",
 		       pci_name(pdev));
-		goto err_free_desc;
+		goto err_free_eeprom;
 	}
 
 	printk(KERN_INFO "%s: hwaddr %pM, Rev 0x%02x\n",
@@ -1912,6 +1912,9 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 
 	return 0;
 
+ err_free_eeprom:
+	kfree(priv->eeprom);
+
  err_free_desc:
 	pci_free_consistent(pdev,
 			    sizeof(struct adm8211_desc) * priv->rx_ring_size +
-- 
1.7.0.4

