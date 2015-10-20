Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34754 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbJTGqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:22 -0400
Received: by lbbwb3 with SMTP id wb3so7787440lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:21 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 06/16] rtl8xxxu: rtl8723au: Introduce a pointer to efuse
Date: Tue, 20 Oct 2015 08:45:36 +0200
Message-Id: <1445323546-12807-7-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084649_715705_3EE92B86)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 26 +++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e892fde..a390d75 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1779,43 +1779,45 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 
 static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 {
-	if (priv->efuse_wifi.efuse8723.rtl_id != cpu_to_le16(0x8129))
+	struct rtl8723au_efuse *efuse = &priv->efuse_wifi.efuse8723;
+
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
 
-	ether_addr_copy(priv->mac_addr, priv->efuse_wifi.efuse8723.mac_addr);
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
 	memcpy(priv->cck_tx_power_index_A,
-	       priv->efuse_wifi.efuse8723.cck_tx_power_index_A,
+	       efuse->cck_tx_power_index_A,
 	       sizeof(priv->cck_tx_power_index_A));
 	memcpy(priv->cck_tx_power_index_B,
-	       priv->efuse_wifi.efuse8723.cck_tx_power_index_B,
+	       efuse->cck_tx_power_index_B,
 	       sizeof(priv->cck_tx_power_index_B));
 
 	memcpy(priv->ht40_1s_tx_power_index_A,
-	       priv->efuse_wifi.efuse8723.ht40_1s_tx_power_index_A,
+	       efuse->ht40_1s_tx_power_index_A,
 	       sizeof(priv->ht40_1s_tx_power_index_A));
 	memcpy(priv->ht40_1s_tx_power_index_B,
-	       priv->efuse_wifi.efuse8723.ht40_1s_tx_power_index_B,
+	       efuse->ht40_1s_tx_power_index_B,
 	       sizeof(priv->ht40_1s_tx_power_index_B));
 
 	memcpy(priv->ht20_tx_power_index_diff,
-	       priv->efuse_wifi.efuse8723.ht20_tx_power_index_diff,
+	       efuse->ht20_tx_power_index_diff,
 	       sizeof(priv->ht20_tx_power_index_diff));
 	memcpy(priv->ofdm_tx_power_index_diff,
-	       priv->efuse_wifi.efuse8723.ofdm_tx_power_index_diff,
+	       efuse->ofdm_tx_power_index_diff,
 	       sizeof(priv->ofdm_tx_power_index_diff));
 
 	memcpy(priv->ht40_max_power_offset,
-	       priv->efuse_wifi.efuse8723.ht40_max_power_offset,
+	       efuse->ht40_max_power_offset,
 	       sizeof(priv->ht40_max_power_offset));
 	memcpy(priv->ht20_max_power_offset,
-	       priv->efuse_wifi.efuse8723.ht20_max_power_offset,
+	       efuse->ht20_max_power_offset,
 	       sizeof(priv->ht20_max_power_offset));
 
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
-		 priv->efuse_wifi.efuse8723.vendor_name);
+		 efuse->vendor_name);
 	dev_info(&priv->udev->dev, "Product: %.41s\n",
-		 priv->efuse_wifi.efuse8723.device_name);
+		 efuse->device_name);
 	return 0;
 }
 
-- 
2.1.0

