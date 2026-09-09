Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF24B364926
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937313; cv=none; b=XSofycbAekgg4C/c2e7bx32AljyZ0Bq89YUfoELpCG5epXJlnNobIXH6PmOPmpU8/mp2MEcMKIS5IMBNcChLJ3LB3oC23H8JuONLSWb7im69g4hUT2R6/Y/E1j3fey24hVKaeJl/NA0+tbx1EKp3klq2mPdl2c24O8JxYtotByw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937313; c=relaxed/simple;
	bh=RX8Gzlpj5cO3lXv8/MMWBJW5L0qazCNdzgrVRuzragk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmVyoIpedFKtsdvKYzGId0ST625G6n52R4fJNjY9iVFBqV/KVZ/UYYipSGWuIwir1nocT9BzoDjTpqIiNI5tUdfRZydnmO6kH2KaA+FTDko4S1aeR4POArDGYqxDFoQ/lV8oW+KdQyYsDeor4XejSCre3hTetU+u6OUyHi6TtAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Nf5vObJE; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Nf5vObJE"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971jqT6357094, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937306; bh=uzaoFKR23geUFL20pR9q92J95VsTT6LTyvS6jEmWZrc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Nf5vObJEyI3V0hnXWGCRSmvu3Gz/rHS7Ak5jafy1FbM/hniHRG1QFbM+FtPAo1BvO
	 WWLCu35NUH76my7rp+YzVon190RhtU1Y4S6CDwsiYnQpRpIAafVzFeG1INjTQasBZK
	 751ZMDUqRvo6jZsvGCNoDtQpSvtmetL4ukT9zPEjjxBJQTkAyDQuoLdS/hLg00kuT4
	 b9GAmn4yZpam72gHN2kQ4PmaZ0CUc/S6ZnZNRIRbwxl7pZWGHLc23U9NR34q6nzcHQ
	 j4hs4CEtr/3Cg7MYSg3Q4R/CVCOx4S/dwre92L4vPF0w9BP5KPUt/j2LGLaEqfn3/c
	 8iokY3+RfsLHA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971jqT6357094
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:46 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:46 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 12/15] wifi: rtw89: 8922d: update BA cam format to G7
Date: Wed, 9 Sep 2026 15:00:01 +0800
Message-ID: <20260909070004.35353-13-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

Initially, Wi-Fi 7 chips utilized the V1 format, but the 8922DE
is expected to use the G7 format. This format differs from V1 into
that STD_ENTRY_EN, BAND_SEL, and MLD_EN are moved into W0, and MACID
is widened to 10-bit and relocated to W1.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c       | 80 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/fw.h       | 21 +++++
 drivers/net/wireless/realtek/rtw89/mac.c      |  3 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  4 +-
 5 files changed, 106 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 3caef61b21d3..2e6d1be3a751 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -212,6 +212,7 @@ enum rtw89_cv {
 enum rtw89_bacam_ver {
 	RTW89_BACAM_V0,
 	RTW89_BACAM_V1,
+	RTW89_BACAM_G7,
 
 	RTW89_BACAM_V0_EXT = 99,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 9eaace2d57c4..63dd918b0989 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2820,6 +2820,86 @@ int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw89_fw_h2c_ba_cam_v1);
 
+int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev,
+			   struct rtw89_vif_link *rtwvif_link,
+			   struct rtw89_sta_link *rtwsta_link,
+			   bool valid, struct ieee80211_ampdu_params *params)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	struct rtw89_h2c_ba_cam_g7 *h2c;
+	u16 macid = rtwsta_link->mac_id;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	u8 entry_idx;
+	u8 bmap_size;
+	int ret;
+
+	ret = valid ?
+	      rtw89_core_acquire_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+					      &entry_idx) :
+	      rtw89_core_release_sta_ba_entry(rtwdev, rtwsta_link, params->tid,
+					      &entry_idx);
+	if (ret) {
+		/*
+		 * it still works even if we don't have static BA CAM, because
+		 * hardware can create dynamic BA CAM automatically.
+		 */
+		rtw89_debug(rtwdev, RTW89_DBG_TXRX,
+			    "failed to %s entry tid=%d for h2c ba cam\n",
+			    valid ? "alloc" : "free", params->tid);
+		return 0;
+	}
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c ba cam\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_ba_cam_g7 *)skb->data;
+
+	if (params->buf_size > 512)
+		bmap_size = 10;
+	else if (params->buf_size > 256)
+		bmap_size = 8;
+	else if (params->buf_size > 64)
+		bmap_size = 4;
+	else
+		bmap_size = 0;
+
+	h2c->w0 = le32_encode_bits(valid, RTW89_H2C_BA_CAM_G7_W0_VALID) |
+		  le32_encode_bits(1, RTW89_H2C_BA_CAM_G7_W0_INIT_REQ) |
+		  le32_encode_bits(params->tid, RTW89_H2C_BA_CAM_G7_W0_TID_MASK) |
+		  le32_encode_bits(1, RTW89_H2C_BA_CAM_G7_W0_STD_ENTRY_EN) |
+		  le32_encode_bits(!!rtwvif_link->mac_idx,
+				   RTW89_H2C_BA_CAM_G7_W0_BAND_SEL) |
+		  le32_encode_bits(bmap_size, RTW89_H2C_BA_CAM_G7_W0_BMAP_SIZE_MASK) |
+		  le32_encode_bits(params->ssn, RTW89_H2C_BA_CAM_G7_W0_SSN_MASK);
+
+	entry_idx += chip->bacam_dynamic_num; /* std entry right after dynamic ones */
+	h2c->w1 = le32_encode_bits(macid, RTW89_H2C_BA_CAM_G7_W1_MACID_MASK) |
+		  le32_encode_bits(entry_idx, RTW89_H2C_BA_CAM_G7_W1_ENTRY_IDX_MASK);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_MAC,
+			      H2C_CL_BA_CAM,
+			      H2C_FUNC_MAC_BA_CAM_V1, 0, 1,
+			      len);
+
+	ret = rtw89_h2c_tx(rtwdev, skb, false);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to send h2c\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+EXPORT_SYMBOL(rtw89_fw_h2c_ba_cam_g7);
+
 int rtw89_fw_h2c_init_ba_cam_users(struct rtw89_dev *rtwdev, u8 users,
 				   u8 offset, u8 mac_idx)
 {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index d64435ffbf78..a15a5967cabc 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -1956,6 +1956,23 @@ struct rtw89_h2c_ba_cam_v1 {
 #define RTW89_H2C_BA_CAM_V1_W1_MLD_EN BIT(10)
 #define RTW89_H2C_BA_CAM_V1_W1_ENTRY_IDX_MASK GENMASK(31, 24)
 
+struct rtw89_h2c_ba_cam_g7 {
+	__le32 w0;
+	__le32 w1;
+} __packed;
+
+#define RTW89_H2C_BA_CAM_G7_W0_VALID BIT(0)
+#define RTW89_H2C_BA_CAM_G7_W0_INIT_REQ	BIT(1)
+#define RTW89_H2C_BA_CAM_G7_W0_TID_MASK	GENMASK(7, 4)
+#define RTW89_H2C_BA_CAM_G7_W0_STD_ENTRY_EN BIT(8)
+#define RTW89_H2C_BA_CAM_G7_W0_BAND_SEL	BIT(9)
+#define RTW89_H2C_BA_CAM_G7_W0_MLD_EN BIT(10)
+#define RTW89_H2C_BA_CAM_G7_W0_BMAP_SIZE_MASK GENMASK(19, 16)
+#define RTW89_H2C_BA_CAM_G7_W0_SSN_MASK	GENMASK(31, 20)
+#define RTW89_H2C_BA_CAM_G7_W1_UID_VALUE_MASK GENMASK(7, 0)
+#define RTW89_H2C_BA_CAM_G7_W1_MACID_MASK GENMASK(17, 8)
+#define RTW89_H2C_BA_CAM_G7_W1_ENTRY_IDX_MASK GENMASK(31, 24)
+
 struct rtw89_h2c_ba_cam_init {
 	__le32 w0;
 } __packed;
@@ -5584,6 +5601,10 @@ int rtw89_fw_h2c_ba_cam_v1(struct rtw89_dev *rtwdev,
 			   struct rtw89_vif_link *rtwvif_link,
 			   struct rtw89_sta_link *rtwsta_link,
 			   bool valid, struct ieee80211_ampdu_params *params);
+int rtw89_fw_h2c_ba_cam_g7(struct rtw89_dev *rtwdev,
+			   struct rtw89_vif_link *rtwvif_link,
+			   struct rtw89_sta_link *rtwsta_link,
+			   bool valid, struct ieee80211_ampdu_params *params);
 void rtw89_fw_h2c_init_dynamic_ba_cam_v0_ext(struct rtw89_dev *rtwdev);
 int rtw89_fw_h2c_init_ba_cam_users(struct rtw89_dev *rtwdev, u8 users,
 				   u8 offset, u8 mac_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index df396fbfca26..093291e8854d 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4087,7 +4087,8 @@ static int rtw89_mac_feat_init(struct rtw89_dev *rtwdev)
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	u8 users, offset;
 
-	if (chip->bacam_ver != RTW89_BACAM_V1)
+	if (!(chip->bacam_ver == RTW89_BACAM_V1 ||
+	      chip->bacam_ver == RTW89_BACAM_G7))
 		return 0;
 
 	offset = 0;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 89c1f58d0dc0..2325e646c487 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -3712,7 +3712,7 @@ static const struct rtw89_chip_ops rtw8922d_chip_ops = {
 	.h2c_punctured_cmac_tbl	= rtw89_fw_h2c_punctured_cmac_tbl_be,
 	.h2c_default_dmac_tbl	= rtw89_fw_h2c_default_dmac_tbl_v3,
 	.h2c_update_beacon	= rtw89_fw_h2c_update_beacon_be,
-	.h2c_ba_cam		= rtw89_fw_h2c_ba_cam_v1,
+	.h2c_ba_cam		= rtw89_fw_h2c_ba_cam_g7,
 	.h2c_wow_cam_update	= rtw89_fw_h2c_wow_cam_update_v1,
 
 	.btc_set_rfe		= rtw8922d_btc_set_rfe,
@@ -3807,7 +3807,7 @@ const struct rtw89_chip_info rtw8922d_chip_info = {
 	.scam_num		= 32,
 	.bacam_num		= 24,
 	.bacam_dynamic_num	= 8,
-	.bacam_ver		= RTW89_BACAM_V1,
+	.bacam_ver		= RTW89_BACAM_G7,
 	.addrcam_ver		= 1,
 	.ppdu_max_usr		= 16,
 	.sec_ctrl_efuse_size	= 4,
-- 
2.25.1

