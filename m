Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jakub Sitnicki <jsitnicki@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 028/113] rtl8xxxu: rtl8192cu: Introduce a pointer to efuse
Date: Mon, 29 Feb 2016 17:04:26 -0500
Message-Id: <1456783551-28315-29-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_231036_714563_8302D93B)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Sitnicki <jsitnicki@gmail.com>

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 29 ++++++++++++------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 4591330..2ca99d0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2218,50 +2218,51 @@ static int rtl8723bu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
+	struct rtl8192cu_efuse *efuse = &priv->efuse_wifi.efuse8192;
 	int i;
 
-	if (priv->efuse_wifi.efuse8192.rtl_id != cpu_to_le16(0x8129))
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
 
-	ether_addr_copy(priv->mac_addr, priv->efuse_wifi.efuse8192.mac_addr);
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
 	memcpy(priv->cck_tx_power_index_A,
-	       priv->efuse_wifi.efuse8192.cck_tx_power_index_A,
+	       efuse->cck_tx_power_index_A,
 	       sizeof(priv->cck_tx_power_index_A));
 	memcpy(priv->cck_tx_power_index_B,
-	       priv->efuse_wifi.efuse8192.cck_tx_power_index_B,
+	       efuse->cck_tx_power_index_B,
 	       sizeof(priv->cck_tx_power_index_B));
 
 	memcpy(priv->ht40_1s_tx_power_index_A,
-	       priv->efuse_wifi.efuse8192.ht40_1s_tx_power_index_A,
+	       efuse->ht40_1s_tx_power_index_A,
 	       sizeof(priv->ht40_1s_tx_power_index_A));
 	memcpy(priv->ht40_1s_tx_power_index_B,
-	       priv->efuse_wifi.efuse8192.ht40_1s_tx_power_index_B,
+	       efuse->ht40_1s_tx_power_index_B,
 	       sizeof(priv->ht40_1s_tx_power_index_B));
 	memcpy(priv->ht40_2s_tx_power_index_diff,
-	       priv->efuse_wifi.efuse8192.ht40_2s_tx_power_index_diff,
+	       efuse->ht40_2s_tx_power_index_diff,
 	       sizeof(priv->ht40_2s_tx_power_index_diff));
 
 	memcpy(priv->ht20_tx_power_index_diff,
-	       priv->efuse_wifi.efuse8192.ht20_tx_power_index_diff,
+	       efuse->ht20_tx_power_index_diff,
 	       sizeof(priv->ht20_tx_power_index_diff));
 	memcpy(priv->ofdm_tx_power_index_diff,
-	       priv->efuse_wifi.efuse8192.ofdm_tx_power_index_diff,
+	       efuse->ofdm_tx_power_index_diff,
 	       sizeof(priv->ofdm_tx_power_index_diff));
 
 	memcpy(priv->ht40_max_power_offset,
-	       priv->efuse_wifi.efuse8192.ht40_max_power_offset,
+	       efuse->ht40_max_power_offset,
 	       sizeof(priv->ht40_max_power_offset));
 	memcpy(priv->ht20_max_power_offset,
-	       priv->efuse_wifi.efuse8192.ht20_max_power_offset,
+	       efuse->ht20_max_power_offset,
 	       sizeof(priv->ht20_max_power_offset));
 
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
-		 priv->efuse_wifi.efuse8192.vendor_name);
+		 efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.20s\n",
-		 priv->efuse_wifi.efuse8192.device_name);
+		 efuse->device_name);
 
-	if (priv->efuse_wifi.efuse8192.rf_regulatory & 0x20) {
+	if (efuse->rf_regulatory & 0x20) {
 		sprintf(priv->chip_name, "8188RU");
 		priv->hi_pa = 1;
 	}
-- 
2.5.0

