Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37075 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3JZTo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Oct 2013 15:44:58 -0400
Received: by mail-ee0-f45.google.com with SMTP id c50so3421333eek.4
        for <linux-wireless@vger.kernel.org>; Sat, 26 Oct 2013 12:44:57 -0700 (PDT)
Date: Sat, 26 Oct 2013 22:44:53 +0300
From: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: [Patch v3 2/3] net: wireless: replace printk with pr_warn in
 adm8211.c
Message-ID: <20131026194453.GA11494@fireworks> (sfid-20131026_214528_347661_448C1758)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
to printk(KERN_WARNING ...

Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
---
 drivers/net/wireless/adm8211.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index e36d54d..0392b52 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -169,13 +169,13 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->bbp_type = ADM8211_TYPE_ADMTEK;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown BBPtype: %d\n",
-		       pci_name(priv->pdev), cr49 >> 3);
+		pr_warn("%s (adm8211): Unknown BBPtype: %d\n",
+			pci_name(priv->pdev), cr49 >> 3);
 	}
 
 	if (priv->eeprom->country_code >= ARRAY_SIZE(cranges)) {
-		printk(KERN_WARNING "%s (adm8211): Invalid country code (%d)\n",
-		       pci_name(priv->pdev), priv->eeprom->country_code);
+		pr_warn("%s (adm8211): Invalid country code (%d)\n",
+			pci_name(priv->pdev), priv->eeprom->country_code);
 
 		chan_range = cranges[2];
 	} else
@@ -209,8 +209,8 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->specific_bbptype = ADM8211_BBP_ADM8011;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown specific BBP: %d\n",
-		       pci_name(priv->pdev), priv->eeprom->specific_bbptype);
+		pr_warn("%s (adm8211): Unknown specific BBP: %d\n",
+			pci_name(priv->pdev), priv->eeprom->specific_bbptype);
 	}
 
 	switch (priv->eeprom->specific_rftype) {
@@ -230,8 +230,8 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else if (priv->pdev->revision == ADM8211_REV_AB)
 			priv->transceiver_type = ADM8211_RFMD2948;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown transceiver: %d\n",
-		       pci_name(priv->pdev), priv->eeprom->specific_rftype);
+		pr_warn("%s (adm8211): Unknown transceiver: %d\n",
+			pci_name(priv->pdev), priv->eeprom->specific_rftype);
 
 		break;
 	}
-- 
1.8.1.2

