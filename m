Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35970 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbbJTGq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:26 -0400
Received: by lffz202 with SMTP id z202so722745lff.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:25 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 09/16] rtl8xxxu: Rename struct struct rtl8723au_tx_power fields
Date: Tue, 20 Oct 2015 08:45:39 +0200
Message-Id: <1445323546-12807-10-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084630_598150_64A22250)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the redundant infix ("tx_power") from field names.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 92 ++++++++++++------------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 18 ++---
 2 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d67c668..992bcda 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1499,27 +1499,27 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 
 	group = rtl8723a_channel_to_group(channel);
 
-	cck[0] = tx_power->cck_tx_power_index_A[group];
-	cck[1] = tx_power->cck_tx_power_index_B[group];
+	cck[0] = tx_power->cck_index_A[group];
+	cck[1] = tx_power->cck_index_B[group];
 
-	ofdm[0] = tx_power->ht40_1s_tx_power_index_A[group];
-	ofdm[1] = tx_power->ht40_1s_tx_power_index_B[group];
+	ofdm[0] = tx_power->ht40_1s_index_A[group];
+	ofdm[1] = tx_power->ht40_1s_index_B[group];
 
-	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_tx_power_index_diff[group].a;
-	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_tx_power_index_diff[group].b;
+	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_index_diff[group].a;
+	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_index_diff[group].b;
 
 	mcsbase[0] = ofdm[0];
 	mcsbase[1] = ofdm[1];
 	if (!ht40) {
-		mcsbase[0] += tx_power->ht20_tx_power_index_diff[group].a;
-		mcsbase[1] += tx_power->ht20_tx_power_index_diff[group].b;
+		mcsbase[0] += tx_power->ht20_index_diff[group].a;
+		mcsbase[1] += tx_power->ht20_index_diff[group].b;
 	}
 
 	if (priv->tx_paths > 1) {
-		if (ofdm[0] > tx_power->ht40_2s_tx_power_index_diff[group].a)
-			ofdm[0] -= tx_power->ht40_2s_tx_power_index_diff[group].a;
-		if (ofdm[1] > tx_power->ht40_2s_tx_power_index_diff[group].b)
-			ofdm[1] -= tx_power->ht40_2s_tx_power_index_diff[group].b;
+		if (ofdm[0] > tx_power->ht40_2s_index_diff[group].a)
+			ofdm[0] -= tx_power->ht40_2s_index_diff[group].a;
+		if (ofdm[1] > tx_power->ht40_2s_index_diff[group].b)
+			ofdm[1] -= tx_power->ht40_2s_index_diff[group].b;
 	}
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_CHANNEL)
@@ -1788,33 +1788,33 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
-	memcpy(tx_power->cck_tx_power_index_A,
+	memcpy(tx_power->cck_index_A,
 	       efuse->cck_tx_power_index_A,
-	       sizeof(tx_power->cck_tx_power_index_A));
-	memcpy(tx_power->cck_tx_power_index_B,
+	       sizeof(tx_power->cck_index_A));
+	memcpy(tx_power->cck_index_B,
 	       efuse->cck_tx_power_index_B,
-	       sizeof(tx_power->cck_tx_power_index_B));
+	       sizeof(tx_power->cck_index_B));
 
-	memcpy(tx_power->ht40_1s_tx_power_index_A,
+	memcpy(tx_power->ht40_1s_index_A,
 	       efuse->ht40_1s_tx_power_index_A,
-	       sizeof(tx_power->ht40_1s_tx_power_index_A));
-	memcpy(tx_power->ht40_1s_tx_power_index_B,
+	       sizeof(tx_power->ht40_1s_index_A));
+	memcpy(tx_power->ht40_1s_index_B,
 	       efuse->ht40_1s_tx_power_index_B,
-	       sizeof(tx_power->ht40_1s_tx_power_index_B));
+	       sizeof(tx_power->ht40_1s_index_B));
 
-	memcpy(tx_power->ht20_tx_power_index_diff,
+	memcpy(tx_power->ht20_index_diff,
 	       efuse->ht20_tx_power_index_diff,
-	       sizeof(tx_power->ht20_tx_power_index_diff));
-	memcpy(tx_power->ofdm_tx_power_index_diff,
+	       sizeof(tx_power->ht20_index_diff));
+	memcpy(tx_power->ofdm_index_diff,
 	       efuse->ofdm_tx_power_index_diff,
-	       sizeof(tx_power->ofdm_tx_power_index_diff));
+	       sizeof(tx_power->ofdm_index_diff));
 
-	memcpy(tx_power->ht40_max_power_offset,
+	memcpy(tx_power->ht40_max_offset,
 	       efuse->ht40_max_power_offset,
-	       sizeof(tx_power->ht40_max_power_offset));
-	memcpy(tx_power->ht20_max_power_offset,
+	       sizeof(tx_power->ht40_max_offset));
+	memcpy(tx_power->ht20_max_offset,
 	       efuse->ht20_max_power_offset,
-	       sizeof(tx_power->ht20_max_power_offset));
+	       sizeof(tx_power->ht20_max_offset));
 
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
 		 efuse->vendor_name);
@@ -1834,36 +1834,36 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
 
-	memcpy(tx_power->cck_tx_power_index_A,
+	memcpy(tx_power->cck_index_A,
 	       efuse->cck_tx_power_index_A,
-	       sizeof(tx_power->cck_tx_power_index_A));
-	memcpy(tx_power->cck_tx_power_index_B,
+	       sizeof(tx_power->cck_index_A));
+	memcpy(tx_power->cck_index_B,
 	       efuse->cck_tx_power_index_B,
-	       sizeof(tx_power->cck_tx_power_index_B));
+	       sizeof(tx_power->cck_index_B));
 
-	memcpy(tx_power->ht40_1s_tx_power_index_A,
+	memcpy(tx_power->ht40_1s_index_A,
 	       efuse->ht40_1s_tx_power_index_A,
-	       sizeof(tx_power->ht40_1s_tx_power_index_A));
-	memcpy(tx_power->ht40_1s_tx_power_index_B,
+	       sizeof(tx_power->ht40_1s_index_A));
+	memcpy(tx_power->ht40_1s_index_B,
 	       efuse->ht40_1s_tx_power_index_B,
-	       sizeof(tx_power->ht40_1s_tx_power_index_B));
-	memcpy(tx_power->ht40_2s_tx_power_index_diff,
+	       sizeof(tx_power->ht40_1s_index_B));
+	memcpy(tx_power->ht40_2s_index_diff,
 	       efuse->ht40_2s_tx_power_index_diff,
-	       sizeof(tx_power->ht40_2s_tx_power_index_diff));
+	       sizeof(tx_power->ht40_2s_index_diff));
 
-	memcpy(tx_power->ht20_tx_power_index_diff,
+	memcpy(tx_power->ht20_index_diff,
 	       efuse->ht20_tx_power_index_diff,
-	       sizeof(tx_power->ht20_tx_power_index_diff));
-	memcpy(tx_power->ofdm_tx_power_index_diff,
+	       sizeof(tx_power->ht20_index_diff));
+	memcpy(tx_power->ofdm_index_diff,
 	       efuse->ofdm_tx_power_index_diff,
-	       sizeof(tx_power->ofdm_tx_power_index_diff));
+	       sizeof(tx_power->ofdm_index_diff));
 
-	memcpy(tx_power->ht40_max_power_offset,
+	memcpy(tx_power->ht40_max_offset,
 	       efuse->ht40_max_power_offset,
-	       sizeof(tx_power->ht40_max_power_offset));
-	memcpy(tx_power->ht20_max_power_offset,
+	       sizeof(tx_power->ht40_max_offset));
+	memcpy(tx_power->ht20_max_offset,
 	       efuse->ht20_max_power_offset,
-	       sizeof(tx_power->ht20_max_power_offset));
+	       sizeof(tx_power->ht20_max_offset));
 
 	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
 		 efuse->vendor_name);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 1a0c88d..23bf4c0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -565,19 +565,19 @@ struct h2c_cmd {
 struct rtl8xxxu_fileops;
 
 struct rtl8723au_tx_power {
-	u8 cck_tx_power_index_A[3];	/* 0x10 */
-	u8 cck_tx_power_index_B[3];
-	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
-	u8 ht40_1s_tx_power_index_B[3];
+	u8 cck_index_A[3];	/* 0x10 */
+	u8 cck_index_B[3];
+	u8 ht40_1s_index_A[3];	/* 0x16 */
+	u8 ht40_1s_index_B[3];
 	/*
 	 * The following entries are half-bytes split as:
 	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
 	 */
-	struct rtl8723au_idx ht40_2s_tx_power_index_diff[3];
-	struct rtl8723au_idx ht20_tx_power_index_diff[3];
-	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
-	struct rtl8723au_idx ht40_max_power_offset[3];
-	struct rtl8723au_idx ht20_max_power_offset[3];
+	struct rtl8723au_idx ht40_2s_index_diff[3];
+	struct rtl8723au_idx ht20_index_diff[3];
+	struct rtl8723au_idx ofdm_index_diff[3];
+	struct rtl8723au_idx ht40_max_offset[3];
+	struct rtl8723au_idx ht20_max_offset[3];
 };
 
 struct rtl8xxxu_priv {
-- 
2.1.0

