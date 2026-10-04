Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66B53E63AE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085638; cv=none; b=pgtvvSPNqWrECTqh+dk2NjPyBEQm4FH1NpIFTBqKL6XnbPhWacepe3nAYaY54Im8oRFpLI22i0Fb+xh75Aw/cSNnNd/UkayVnDC/pM4eTvRH1gcfhZ6jHPe+U6tUt5ZzVSAeVLQFffd/ul9l3IpgNzGv8zvTzbHDz2934wv4WtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085638; c=relaxed/simple;
	bh=fpBcs5UtdziZQj62lnjOCXVK0fDanirD1qrAiDG4Kb0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1lkWWucrk8qelYPa+xz/O25Y3+9ucpaDORAAk21Nz7/TATI90AoRWLlZYuQy3Wt/EATkgh5kcZVXga/plRrWNtto1yaYQvTJwvz0cl7VQAs/LIdey0IAy2p8MW8h9rZTUPzv/Vsgr5DZWm3zYlKm/2qzQMQXeSYdmBnTsd7WGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=lwt4eSKQ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="lwt4eSKQ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943lDwM5829658, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085634; bh=BDEG7XMiFhzYoWVJW50aldKdleF5YC3828uT5rhgrGI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=lwt4eSKQMIVlQ6+RH07D+cNktabMAQuJr4zM4WuveId5LdDns+Jo6qeRq1iPfGtcT
	 0n30jtN1gMAKcKt5ZPK/zCYbIvJfShiYVwkaPDu8wBYPNCX8lhMfvOhVWvOmB9de5p
	 a8otK+7BuZD0vAsdnWvgdn3r8OMLoGkdKuv88CuS/voGoLpq38Ei8/AsaYTQMvGC1V
	 /VXJGwhbGv4l4YHIZ2qXu7p7jvYOuKyQGivL2qrWmjBBfJ7hdKzR4Lxo/717L01hc/
	 Qy85S19lZqkg9Z9LrPw9ncsddlIye0zUHr74aiGJo1AJcwCAhtSx6UiRovlumkoNpb
	 Ygj79b2/UQHSA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943lDwM5829658
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:47:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:47:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 13/15] wifi: rtw89: phy: Implement API to control BTG to turn on/off BT TX/RX
Date: Sun, 4 Oct 2026 11:45:18 +0800
Message-ID: <20261004034520.33695-14-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004034520.33695-1-pkshih@realtek.com>
References: <20261004034520.33695-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The WiFi BE serials chips could disable BT TX/RX by BTG control, with this
control logic, WiFi could lower down the interference signal from BT.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h   |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c     |  2 ++
 drivers/net/wireless/realtek/rtw89/phy.h    | 12 ++++++++++++
 drivers/net/wireless/realtek/rtw89/phy_be.c | 18 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/reg.h    |  2 ++
 5 files changed, 35 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index b1f92c1d0428..d70123602801 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6120,6 +6120,7 @@ enum rtw89_fw_feature {
 	RTW89_FW_FEATURE_LPS_ML_INFO_V1_EXTRA,
 	RTW89_FW_FEATURE_SER_POST_RECOVER_DMAC,
 	RTW89_FW_FEATURE_TX_HISTORY_V1,
+	RTW89_FW_FEATURE_NO_DRV_BT_TXRX_EN,
 
 	NUM_OF_RTW89_FW_FEATURES,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index e9f6dc25b94c..ea7dba077f5d 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -1026,6 +1026,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 109, 1, SCAN_OFFLOAD_BE_V1),
 	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
 	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 119, 0, CH_INFO_BE_V1),
+	__CFG_FW_FEAT(RTL8922A, lt, 0, 35, 119, 3, NO_DRV_BT_TXRX_EN),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 0, 0, 0, MACID_PAUSE_SLEEP),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 75, 2, SCAN_OFFLOAD),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 75, 2, BEACON_FILTER),
@@ -1044,6 +1045,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 2, SCAN_OFFLOAD_BE_V2),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 119, 0, LPS_ML_INFO_V1_EXTRA),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 119, 0, CH_INFO_BE_V1),
+	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 119, 3, NO_DRV_BT_TXRX_EN),
 };
 
 static void rtw89_fw_iterate_feature_cfg(struct rtw89_fw_info *fw,
diff --git a/drivers/net/wireless/realtek/rtw89/phy.h b/drivers/net/wireless/realtek/rtw89/phy.h
index 7bbda2ba5b5c..84eb1defaaf2 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -686,6 +686,7 @@ struct rtw89_phy_gen_def {
 	void (*preinit_rf_nctl)(struct rtw89_dev *rtwdev);
 	void (*bb_wrap_init)(struct rtw89_dev *rtwdev);
 	void (*ch_info_init)(struct rtw89_dev *rtwdev);
+	int (*btc_bttrx_en)(struct rtw89_dev *rtwdev, u8 bt_en_int, bool enable);
 
 	void (*set_txpwr_byrate)(struct rtw89_dev *rtwdev,
 				 const struct rtw89_chan *chan,
@@ -1066,6 +1067,17 @@ static inline void rtw89_phy_ch_info_init(struct rtw89_dev *rtwdev)
 		phy->ch_info_init(rtwdev);
 }
 
+static inline
+int rtw89_phy_btc_bttrx_en(struct rtw89_dev *rtwdev, u8 bt_en_int, bool enable)
+{
+	const struct rtw89_phy_gen_def *phy = rtwdev->chip->phy_def;
+
+	if (!phy->btc_bttrx_en)
+		return 0;
+
+	return phy->btc_bttrx_en(rtwdev, bt_en_int, enable);
+}
+
 static inline
 void rtw89_phy_set_txpwr_byrate(struct rtw89_dev *rtwdev,
 				const struct rtw89_chan *chan,
diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index b94754d38673..42470e868ef4 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -1293,6 +1293,22 @@ static void rtw89_phy_ch_info_init_be_v1(struct rtw89_dev *rtwdev)
 	rtw89_phy_set_phy_regs(rtwdev, R_CHINFO_ALG_BE4, B_CHINFO_ALG_BE4, 0);
 }
 
+static int rtw89_phy_btc_bttrx_en_be(struct rtw89_dev *rtwdev, u8 bt_en_int,
+				     bool enable)
+{
+	if (RTW89_CHK_FW_FEATURE(NO_DRV_BT_TXRX_EN, &rtwdev->fw))
+		return 0;
+
+	rtw89_io_pack(rtwdev);
+
+	rtw89_write_rf(rtwdev, RF_PATH_A, RR_BTG_CONTROL,
+		       RR_BTG_CONTROL_EN << bt_en_int, enable);
+	rtw89_write_rf(rtwdev, RF_PATH_B, RR_BTG_CONTROL,
+		       RR_BTG_CONTROL_EN << bt_en_int, enable);
+
+	return rtw89_io_unpack(rtwdev);
+}
+
 struct rtw89_byr_spec_ent_be {
 	struct rtw89_rate_desc init;
 	u8 num_of_idx;
@@ -2035,6 +2051,7 @@ const struct rtw89_phy_gen_def rtw89_phy_gen_be = {
 	.preinit_rf_nctl = rtw89_phy_preinit_rf_nctl_be,
 	.bb_wrap_init = rtw89_phy_bb_wrap_init_be,
 	.ch_info_init = rtw89_phy_ch_info_init_be,
+	.btc_bttrx_en = rtw89_phy_btc_bttrx_en_be,
 
 	.set_txpwr_byrate = rtw89_phy_set_txpwr_byrate_be,
 	.set_txpwr_offset = rtw89_phy_set_txpwr_offset_be,
@@ -2061,6 +2078,7 @@ const struct rtw89_phy_gen_def rtw89_phy_gen_be_v1 = {
 	.preinit_rf_nctl = rtw89_phy_preinit_rf_nctl_be_v1,
 	.bb_wrap_init = rtw89_phy_bb_wrap_init_be,
 	.ch_info_init = rtw89_phy_ch_info_init_be_v1,
+	.btc_bttrx_en = rtw89_phy_btc_bttrx_en_be,
 
 	.set_txpwr_byrate = rtw89_phy_set_txpwr_byrate_be,
 	.set_txpwr_offset = rtw89_phy_set_txpwr_offset_be,
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 11b30be8f880..4829f9fd8eb5 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -8582,6 +8582,8 @@
 #define RR_MODOPT_M_TXPWR GENMASK(5, 0)
 #define RR_WLSEL 0x02
 #define RR_WLSEL_AG GENMASK(18, 16)
+#define RR_BTG_CONTROL 0x4
+#define RR_BTG_CONTROL_EN BIT(2)
 #define RR_RSV1 0x05
 #define RR_RSV1_RST BIT(0)
 #define RR_BBDC 0x10005
-- 
2.25.1

