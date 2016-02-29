Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 029/113] rtl8xxxu: rtl8192eu_parse_efuse(): Use a pointer to the struct rtl8192eu_efuse
Date: Mon, 29 Feb 2016 17:04:27 -0500
Message-Id: <1456783551-28315-30-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231034_112846_9C5F5CB1)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Make the code easier to read and less error prone by using a pointer
to the efuse.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 26 +++++++++---------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 2ca99d0..d25536a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2288,33 +2288,27 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
+	struct rtl8192eu_efuse *efuse = &priv->efuse_wifi.efuse8192eu;
 	int i;
 
-	if (priv->efuse_wifi.efuse8192eu.rtl_id != cpu_to_le16(0x8129))
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
 
-	ether_addr_copy(priv->mac_addr, priv->efuse_wifi.efuse8192eu.mac_addr);
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
-	memcpy(priv->cck_tx_power_index_A,
-	       priv->efuse_wifi.efuse8192eu.cck_tx_power_index_A,
+	memcpy(priv->cck_tx_power_index_A, efuse->cck_tx_power_index_A,
 	       sizeof(priv->cck_tx_power_index_A));
-	memcpy(priv->cck_tx_power_index_B,
-	       priv->efuse_wifi.efuse8192eu.cck_tx_power_index_B,
+	memcpy(priv->cck_tx_power_index_B, efuse->cck_tx_power_index_B,
 	       sizeof(priv->cck_tx_power_index_B));
 
-	memcpy(priv->ht40_1s_tx_power_index_A,
-	       priv->efuse_wifi.efuse8192eu.ht40_1s_tx_power_index_A,
+	memcpy(priv->ht40_1s_tx_power_index_A, efuse->ht40_1s_tx_power_index_A,
 	       sizeof(priv->ht40_1s_tx_power_index_A));
-	memcpy(priv->ht40_1s_tx_power_index_B,
-	       priv->efuse_wifi.efuse8192eu.ht40_1s_tx_power_index_B,
+	memcpy(priv->ht40_1s_tx_power_index_B, efuse->ht40_1s_tx_power_index_B,
 	       sizeof(priv->ht40_1s_tx_power_index_B));
 
-	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
-		 priv->efuse_wifi.efuse8192eu.vendor_name);
-	dev_info(&priv->udev->dev, "Product: %.11s\n",
-		 priv->efuse_wifi.efuse8192eu.device_name);
-	dev_info(&priv->udev->dev, "Serial: %.11s\n",
-		 priv->efuse_wifi.efuse8192eu.serial);
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.11s\n", efuse->device_name);
+	dev_info(&priv->udev->dev, "Serial: %.11s\n", efuse->serial);
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
 		unsigned char *raw = priv->efuse_wifi.raw;
-- 
2.5.0

