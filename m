Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 030/113] rtl8xxxu: rtl8723bu_parse_efuse(): Use a pointer to the struct rtl8723bu_efuse
Date: Mon, 29 Feb 2016 17:04:28 -0500
Message-Id: <1456783551-28315-31-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231039_084614_8DF22C95)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Likewise for 8723bu, use a pointer to the efuse.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d25536a..d100a99 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2171,29 +2171,25 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 
 static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
-	if (priv->efuse_wifi.efuse8723bu.rtl_id != cpu_to_le16(0x8129))
+	struct rtl8723bu_efuse *efuse = &priv->efuse_wifi.efuse8723bu;
+
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
 
-	ether_addr_copy(priv->mac_addr, priv->efuse_wifi.efuse8723bu.mac_addr);
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
-	memcpy(priv->cck_tx_power_index_A,
-	       priv->efuse_wifi.efuse8723bu.cck_tx_power_index_A,
+	memcpy(priv->cck_tx_power_index_A, efuse->cck_tx_power_index_A,
 	       sizeof(priv->cck_tx_power_index_A));
-	memcpy(priv->cck_tx_power_index_B,
-	       priv->efuse_wifi.efuse8723bu.cck_tx_power_index_B,
+	memcpy(priv->cck_tx_power_index_B, efuse->cck_tx_power_index_B,
 	       sizeof(priv->cck_tx_power_index_B));
 
-	memcpy(priv->ht40_1s_tx_power_index_A,
-	       priv->efuse_wifi.efuse8723bu.ht40_1s_tx_power_index_A,
+	memcpy(priv->ht40_1s_tx_power_index_A, efuse->ht40_1s_tx_power_index_A,
 	       sizeof(priv->ht40_1s_tx_power_index_A));
-	memcpy(priv->ht40_1s_tx_power_index_B,
-	       priv->efuse_wifi.efuse8723bu.ht40_1s_tx_power_index_B,
+	memcpy(priv->ht40_1s_tx_power_index_B, efuse->ht40_1s_tx_power_index_B,
 	       sizeof(priv->ht40_1s_tx_power_index_B));
 
-	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
-		 priv->efuse_wifi.efuse8723bu.vendor_name);
-	dev_info(&priv->udev->dev, "Product: %.41s\n",
-		 priv->efuse_wifi.efuse8723bu.device_name);
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.41s\n", efuse->device_name);
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
 		int i;
-- 
2.5.0

