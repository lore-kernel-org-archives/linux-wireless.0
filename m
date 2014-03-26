Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61607 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaCZUC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:02:56 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so2106123eei.28
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:02:55 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 18/20] rtl8180: detect rtl8187se card
Date: Wed, 26 Mar 2014 21:04:05 +0100
Message-Id: <1395864245-5132-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210300_804867_35DBFF24)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add case to detect the rtl8187se card and its RF frontend.
In this case set also accordingly mac80211 queue number.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index a14dfd9..2046fe2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1740,6 +1740,12 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		chip_name = "RTL8185vD";
 		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8185;
 		break;
+
+	case RTL818X_TX_CONF_RTL8187SE:
+		chip_name = "RTL8187SE";
+		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8187SE;
+		break;
+
 	default:
 		printk(KERN_ERR "%s (rtl8180): Unknown chip! (0x%x)\n",
 		       pci_name(pdev), reg >> 25);
@@ -1753,7 +1759,10 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	 * with mac80211, however the beacon queue is an exception and it
 	 * is mapped on the highst tx ring IDX.
 	 */
-	dev->queues = RTL8180_NR_TX_QUEUES - 1;
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+		dev->queues = RTL8187SE_NR_TX_QUEUES - 1;
+	else
+		dev->queues = RTL8180_NR_TX_QUEUES - 1;
 
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
 		priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
@@ -1773,7 +1782,11 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		break;
 	case 5:	priv->rf = &grf5101_rf_ops;
 		break;
-	case 9:	priv->rf = rtl8180_detect_rf(dev);
+	case 9:
+		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+			priv->rf = rtl8187se_detect_rf(dev);
+		else
+			priv->rf = rtl8180_detect_rf(dev);
 		break;
 	case 10:
 		rf_name = "RTL8255";
-- 
1.8.3.2

