Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 082/113] rtl8xxxu: Use size of source pointer when copying efuse data
Date: Mon, 29 Feb 2016 17:05:20 -0500
Message-Id: <1456783551-28315-83-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_234078_271154A8)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Some newer chips have more channel groups in their efuse parameter
tables, so use the size of the source, rather than the destination
when copying them out. This avoids copying garbage when increasing the
common array sizes.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 34 ++++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index f640306..39c6322 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2318,31 +2318,31 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	memcpy(priv->cck_tx_power_index_A,
 	       efuse->cck_tx_power_index_A,
-	       sizeof(priv->cck_tx_power_index_A));
+	       sizeof(efuse->cck_tx_power_index_A));
 	memcpy(priv->cck_tx_power_index_B,
 	       efuse->cck_tx_power_index_B,
-	       sizeof(priv->cck_tx_power_index_B));
+	       sizeof(efuse->cck_tx_power_index_B));
 
 	memcpy(priv->ht40_1s_tx_power_index_A,
 	       efuse->ht40_1s_tx_power_index_A,
-	       sizeof(priv->ht40_1s_tx_power_index_A));
+	       sizeof(efuse->ht40_1s_tx_power_index_A));
 	memcpy(priv->ht40_1s_tx_power_index_B,
 	       efuse->ht40_1s_tx_power_index_B,
-	       sizeof(priv->ht40_1s_tx_power_index_B));
+	       sizeof(efuse->ht40_1s_tx_power_index_B));
 
 	memcpy(priv->ht20_tx_power_index_diff,
 	       efuse->ht20_tx_power_index_diff,
-	       sizeof(priv->ht20_tx_power_index_diff));
+	       sizeof(efuse->ht20_tx_power_index_diff));
 	memcpy(priv->ofdm_tx_power_index_diff,
 	       efuse->ofdm_tx_power_index_diff,
-	       sizeof(priv->ofdm_tx_power_index_diff));
+	       sizeof(efuse->ofdm_tx_power_index_diff));
 
 	memcpy(priv->ht40_max_power_offset,
 	       efuse->ht40_max_power_offset,
-	       sizeof(priv->ht40_max_power_offset));
+	       sizeof(efuse->ht40_max_power_offset));
 	memcpy(priv->ht20_max_power_offset,
 	       efuse->ht20_max_power_offset,
-	       sizeof(priv->ht20_max_power_offset));
+	       sizeof(efuse->ht20_max_power_offset));
 
 	if (priv->efuse_wifi.efuse8723.version >= 0x01) {
 		priv->has_xtalk = 1;
@@ -2403,34 +2403,34 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	memcpy(priv->cck_tx_power_index_A,
 	       efuse->cck_tx_power_index_A,
-	       sizeof(priv->cck_tx_power_index_A));
+	       sizeof(efuse->cck_tx_power_index_A));
 	memcpy(priv->cck_tx_power_index_B,
 	       efuse->cck_tx_power_index_B,
-	       sizeof(priv->cck_tx_power_index_B));
+	       sizeof(efuse->cck_tx_power_index_B));
 
 	memcpy(priv->ht40_1s_tx_power_index_A,
 	       efuse->ht40_1s_tx_power_index_A,
-	       sizeof(priv->ht40_1s_tx_power_index_A));
+	       sizeof(efuse->ht40_1s_tx_power_index_A));
 	memcpy(priv->ht40_1s_tx_power_index_B,
 	       efuse->ht40_1s_tx_power_index_B,
-	       sizeof(priv->ht40_1s_tx_power_index_B));
+	       sizeof(efuse->ht40_1s_tx_power_index_B));
 	memcpy(priv->ht40_2s_tx_power_index_diff,
 	       efuse->ht40_2s_tx_power_index_diff,
-	       sizeof(priv->ht40_2s_tx_power_index_diff));
+	       sizeof(efuse->ht40_2s_tx_power_index_diff));
 
 	memcpy(priv->ht20_tx_power_index_diff,
 	       efuse->ht20_tx_power_index_diff,
-	       sizeof(priv->ht20_tx_power_index_diff));
+	       sizeof(efuse->ht20_tx_power_index_diff));
 	memcpy(priv->ofdm_tx_power_index_diff,
 	       efuse->ofdm_tx_power_index_diff,
-	       sizeof(priv->ofdm_tx_power_index_diff));
+	       sizeof(efuse->ofdm_tx_power_index_diff));
 
 	memcpy(priv->ht40_max_power_offset,
 	       efuse->ht40_max_power_offset,
-	       sizeof(priv->ht40_max_power_offset));
+	       sizeof(efuse->ht40_max_power_offset));
 	memcpy(priv->ht20_max_power_offset,
 	       efuse->ht20_max_power_offset,
-	       sizeof(priv->ht20_max_power_offset));
+	       sizeof(efuse->ht20_max_power_offset));
 
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
 		 efuse->vendor_name);
-- 
2.5.0

