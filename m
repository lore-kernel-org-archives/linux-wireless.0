Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD224E4B4
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2026 06:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774853965; cv=none; b=n0XpJ4ffFc8hMmgIM14vK/j9AeXOrEllq55yr1Eq4da8D0+XVf9i1Odu63Y/s+RnsZZ5FIRYLfeUPUGj3PZn6B0dg8caX97Mg2lXc9efUSgmuHIyK6zF58tqH0Yo08sRrA7tcl3UpHgM29odGN3KxzU6HR+6H0Situa6csGxYvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774853965; c=relaxed/simple;
	bh=79HU/uuPu7/iJvfZUhwRPKtFA2Rvlj1xvqbwHwYLo3o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTDyvwM96ebdTaYh7V2qIT586iD1b272JskMMf5uuJJFfEW5HaEwYgXK5VDXdj3iKSJPwXD5VrJ4UeeGMXoLuNey97OeP2sK39e0Jmn0l0G/wRsFgd5SXnLk94ijojaVAXvL0EJR36HDRXBh1M7haykEDSLaeThu+qybiBM6QhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qIt9hWIH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qIt9hWIH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U6xLjxD673859, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774853962; bh=H9433NyK/a3TwhTLKhUB4G1dNZN/CBIZtb/F+MNeqZA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=qIt9hWIH5pt1tpHz9AEKxR+UeLVCvPLIFC7881JopfbnVHwGAgmmLbKlab9hTaGPm
	 QC1irlR+gTodqOcGOTc01ZNLdLrWBjDtMc7cGoMbJZvZrc8P+8S/u7gBZbcCX1WBhL
	 Pl9DqZLyidiFSZjne9kwkFVPoYBk5DW3yqDYaPuwIHhlDmNA8WDpZmbXvof6UQTRgE
	 XLba8PdPm1H6rJPSwP47svLBzzbkwHb7772zN0kIXS+I5HU+OQZjkg0r3zrjWmbbj9
	 JktUmFMdeVYD5b5jeOBtsMowaJ3CPVPz77kvRCFIxhsTDxHywuBdT3R9Ro+PwDbZL4
	 arl1dg/IOlaMA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U6xLjxD673859
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2026 14:59:21 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 14:59:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 30 Mar 2026 14:59:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next 6/9] wifi: rtw89: 8922d: add RF ops of init hardware and get thermal
Date: Mon, 30 Mar 2026 14:58:44 +0800
Message-ID: <20260330065847.48946-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260330065847.48946-1-pkshih@realtek.com>
References: <20260330065847.48946-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

One is to initialize hardware for RF circuit, and the ops of get thermal
is used to monitor temperature to re-calibrate RF or reduce TX duty to
prevent overheating.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/reg.h      |  6 ++
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 57 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8922d_rfk.c | 24 ++++++++
 .../net/wireless/realtek/rtw89/rtw8922d_rfk.h |  3 +
 4 files changed, 90 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 78f2cf579fa6..e5e689f1bfa3 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -10676,6 +10676,12 @@
 #define B_KTBL1_TBL0 BIT(3)
 #define B_KTBL1_TBL1 BIT(5)
 
+#define R_TC_EN_BE4 0x3c200
+#define B_TC_EN_BE4 BIT(0)
+#define B_TC_TRIG_BE4 BIT(1)
+#define R_TC_VAL_BE4 0x3c208
+#define B_TC_VAL_BE4 GENMASK(7, 0)
+
 /* WiFi CPU local domain */
 #define R_AX_WDT_CTRL 0x0040
 #define B_AX_WDT_EN BIT(31)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index cfe9752abddc..49b84d49ccac 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2562,6 +2562,63 @@ static void rtw8922d_bb_cfg_txrx_path(struct rtw89_dev *rtwdev)
 				   &tx_en1, false);
 }
 
+static u8 rtw8922d_get_thermal(struct rtw89_dev *rtwdev, enum rtw89_rf_path rf_path)
+{
+	u8 val;
+
+	rtw89_phy_write32_mask(rtwdev, R_TC_EN_BE4, B_TC_EN_BE4, 0x1);
+	rtw89_phy_write32_mask(rtwdev, R_TC_EN_BE4, B_TC_TRIG_BE4, 0x0);
+	rtw89_phy_write32_mask(rtwdev, R_TC_EN_BE4, B_TC_TRIG_BE4, 0x1);
+
+	fsleep(100);
+
+	val = rtw89_phy_read32_mask(rtwdev, R_TC_VAL_BE4, B_TC_VAL_BE4);
+
+	return val;
+}
+
+static u32 rtw8922d_chan_to_rf18_val(struct rtw89_dev *rtwdev,
+				     const struct rtw89_chan *chan)
+{
+	u32 val = u32_encode_bits(chan->channel, RR_CFGCH_CH);
+
+	switch (chan->band_type) {
+	case RTW89_BAND_2G:
+	default:
+		break;
+	case RTW89_BAND_5G:
+		val |= u32_encode_bits(CFGCH_BAND1_5G, RR_CFGCH_BAND1) |
+		       u32_encode_bits(CFGCH_BAND0_5G, RR_CFGCH_BAND0);
+		break;
+	case RTW89_BAND_6G:
+		val |= u32_encode_bits(CFGCH_BAND1_6G, RR_CFGCH_BAND1) |
+		       u32_encode_bits(CFGCH_BAND0_6G, RR_CFGCH_BAND0);
+		break;
+	}
+
+	switch (chan->band_width) {
+	case RTW89_CHANNEL_WIDTH_5:
+	case RTW89_CHANNEL_WIDTH_10:
+	case RTW89_CHANNEL_WIDTH_20:
+	default:
+		break;
+	case RTW89_CHANNEL_WIDTH_40:
+		val |= u32_encode_bits(CFGCH_BW_V2_40M, RR_CFGCH_BW_V2);
+		break;
+	case RTW89_CHANNEL_WIDTH_80:
+		val |= u32_encode_bits(CFGCH_BW_V2_80M, RR_CFGCH_BW_V2);
+		break;
+	case RTW89_CHANNEL_WIDTH_160:
+		val |= u32_encode_bits(CFGCH_BW_V2_160M, RR_CFGCH_BW_V2);
+		break;
+	case RTW89_CHANNEL_WIDTH_320:
+		val |= u32_encode_bits(CFGCH_BW_V2_320M, RR_CFGCH_BW_V2);
+		break;
+	}
+
+	return val;
+}
+
 MODULE_FIRMWARE(RTW8922D_MODULE_FIRMWARE);
 MODULE_FIRMWARE(RTW8922DS_MODULE_FIRMWARE);
 MODULE_AUTHOR("Realtek Corporation");
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.c
index 147cf91d2cb0..4e6a8e88a71e 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.c
@@ -9,6 +9,12 @@
 #include "rtw8922d.h"
 #include "rtw8922d_rfk.h"
 
+static const struct rtw89_reg5_def rtw8922d_nctl_post_defs[] = {
+	RTW89_DECL_RFK_WM(0x20c7c, 0x00e00000, 0x1),
+};
+
+RTW89_DECLARE_RFK_TBL(rtw8922d_nctl_post_defs);
+
 static void rtw8922d_tssi_cont_en(struct rtw89_dev *rtwdev, bool en,
 				  enum rtw89_rf_path path, u8 phy_idx)
 {
@@ -239,6 +245,24 @@ void rtw8922d_rfk_mlo_ctrl(struct rtw89_dev *rtwdev)
 	rtw8922d_chlk_reload(rtwdev);
 }
 
+static void rtw8922d_x4k_setting(struct rtw89_dev *rtwdev)
+{
+	u32 val;
+
+	val = rtw89_read_rf(rtwdev, RF_PATH_A, 0xB9, 0xF000);
+	rtw89_write_rf(rtwdev, RF_PATH_A, 0xB9, 0xF000, val);
+	val = rtw89_read_rf(rtwdev, RF_PATH_B, 0xB9, 0xF000);
+	rtw89_write_rf(rtwdev, RF_PATH_B, 0xB9, 0xF000, val);
+
+	rtw89_write_rf(rtwdev, RF_PATH_A, 0xC2, BIT(19), 0x1);
+	rtw89_write_rf(rtwdev, RF_PATH_B, 0xC2, BIT(19), 0x1);
+}
+
+void rtw8922d_rfk_hw_init(struct rtw89_dev *rtwdev)
+{
+	rtw8922d_x4k_setting(rtwdev);
+}
+
 void rtw8922d_pre_set_channel_rf(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx)
 {
 	bool mlo_1_1;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.h b/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.h
index 8a5f4b56b8ce..c5bbe0eb972a 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.h
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d_rfk.h
@@ -7,10 +7,13 @@
 
 #include "core.h"
 
+extern const struct rtw89_rfk_tbl rtw8922d_nctl_post_defs_tbl;
+
 void rtw8922d_tssi_cont_en_phyidx(struct rtw89_dev *rtwdev, bool en, u8 phy_idx);
 void rtw8922d_set_channel_rf(struct rtw89_dev *rtwdev,
 			     const struct rtw89_chan *chan,
 			     enum rtw89_phy_idx phy_idx);
+void rtw8922d_rfk_hw_init(struct rtw89_dev *rtwdev);
 void rtw8922d_rfk_mlo_ctrl(struct rtw89_dev *rtwdev);
 void rtw8922d_pre_set_channel_rf(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx);
 void rtw8922d_post_set_channel_rf(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx);
-- 
2.25.1

