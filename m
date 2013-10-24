Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:54428 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3JXWRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 18:17:15 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so90523ead.31
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 15:17:14 -0700 (PDT)
Date: Fri, 25 Oct 2013 01:17:12 +0300
From: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
To: opw-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org
Subject: [Patch v2 2/3] net: wireless: replace printk with netdev_warn in
 adm8211.c
Message-ID: <20131024221712.GA4175@fireworks> (sfid-20131025_001722_027918_6BFA8F56)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...
to printk(KERN_WARNING ...

Signed-off-by: Georgiana Rodica Chelu <georgiana.chelu93@gmail.com>
---
 drivers/net/wireless/adm8211.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 0d0dcba..1910ea7 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -170,13 +170,14 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->bbp_type = ADM8211_TYPE_ADMTEK;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown BBPtype: %d\n",
-		       pci_name(priv->pdev), cr49 >> 3);
+		netdev_warn(priv->pdev, "(adm8211): Unknown BBPtype: %d\n",
+			    pci_name(priv->pdev), cr49 >> 3);
 	}
 
 	if (priv->eeprom->country_code >= ARRAY_SIZE(cranges)) {
-		printk(KERN_WARNING "%s (adm8211): Invalid country code (%d)\n",
-		       pci_name(priv->pdev), priv->eeprom->country_code);
+		netdev_warn(priv->eeprom, "(adm8211): Invalid country code ",
+			    "(%d)\n", pci_name(priv->pdev),
+			    priv->eeprom->country_code);
 
 		chan_range = cranges[2];
 	} else
@@ -210,8 +211,9 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else
 			priv->specific_bbptype = ADM8211_BBP_ADM8011;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown specific BBP: %d\n",
-		       pci_name(priv->pdev), priv->eeprom->specific_bbptype);
+		netdev_warn(priv->pdev, "(adm8211): Unknown specific BBP: %d",
+			    "\n", pci_name(priv->pdev),
+			    priv->eeprom->specific_bbptype);
 	}
 
 	switch (priv->eeprom->specific_rftype) {
@@ -231,8 +233,9 @@ static int adm8211_read_eeprom(struct ieee80211_hw *dev)
 		else if (priv->pdev->revision == ADM8211_REV_AB)
 			priv->transceiver_type = ADM8211_RFMD2948;
 
-		printk(KERN_WARNING "%s (adm8211): Unknown transceiver: %d\n",
-		       pci_name(priv->pdev), priv->eeprom->specific_rftype);
+		netdev_warn(priv->pdev, "(adm8211): Unknown transceiver: %d\n",
+			    pci_name(priv->pdev),
+			    priv->eeprom->specific_rftype);
 
 		break;
 	}
-- 
1.8.1.2

