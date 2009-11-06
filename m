Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37377 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZKFVpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 16:45:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mwl8k: use integral index instead of pointer for driver_data
Date: Fri,  6 Nov 2009 16:42:07 -0500
Message-Id: <1257543727-5449-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use of an integral index makes adding new device IDs through sysfs more
practical.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwl8k.c |   47 ++++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9fde17b..2ebfee4 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3308,34 +3308,33 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	priv->beacon_skb = NULL;
 }
 
-static struct mwl8k_device_info di_8366 = {
-	.part_name	= "88w8366",
-	.helper_image	= "mwl8k/helper_8366.fw",
-	.fw_image	= "mwl8k/fmimage_8366.fw",
-	.rxd_ops	= &rxd_8366_ops,
-	.modes		= 0,
+enum {
+	MWL8687 = 0,
+	MWL8366,
 };
 
-static struct mwl8k_device_info di_8687 = {
-	.part_name	= "88w8687",
-	.helper_image	= "mwl8k/helper_8687.fw",
-	.fw_image	= "mwl8k/fmimage_8687.fw",
-	.rxd_ops	= &rxd_8687_ops,
-	.modes		= BIT(NL80211_IFTYPE_STATION),
+static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
+	{
+		.part_name	= "88w8687",
+		.helper_image	= "mwl8k/helper_8687.fw",
+		.fw_image	= "mwl8k/fmimage_8687.fw",
+		.rxd_ops	= &rxd_8687_ops,
+		.modes		= BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.part_name	= "88w8366",
+		.helper_image	= "mwl8k/helper_8366.fw",
+		.fw_image	= "mwl8k/fmimage_8366.fw",
+		.rxd_ops	= &rxd_8366_ops,
+		.modes		= 0,
+	},
 };
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
-	{
-		PCI_VDEVICE(MARVELL, 0x2a2b),
-		.driver_data = (unsigned long)&di_8687,
-	}, {
-		PCI_VDEVICE(MARVELL, 0x2a30),
-		.driver_data = (unsigned long)&di_8687,
-	}, {
-		PCI_VDEVICE(MARVELL, 0x2a40),
-		.driver_data = (unsigned long)&di_8366,
-	}, {
-	},
+	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = MWL8687, },
+	{ PCI_VDEVICE(MARVELL, 0x2a30), .driver_data = MWL8687, },
+	{ PCI_VDEVICE(MARVELL, 0x2a40), .driver_data = MWL8366, },
+	{ },
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
 
@@ -3379,7 +3378,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->pdev = pdev;
-	priv->device_info = (void *)id->driver_data;
+	priv->device_info = &mwl8k_info_tbl[id->driver_data];
 	priv->rxd_ops = priv->device_info->rxd_ops;
 	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
-- 
1.6.2.5

