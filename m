Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892272F28EA
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269239; cv=none; b=SoaSh8Kq6bvME6jy86YCf3k/IWWue46JSor89FnP/lDVCtVjcD9mk8/JZARB5+sOLlaPb74dFYrzbGJucKtb9JbIfOqq6s+QasBoeOZHotOCUdDAXbmskU5qU80ua2vgUT3NE11K8tUH2pkbqsCHWy4mX0nw7Mj4q80Bu1n2V7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269239; c=relaxed/simple;
	bh=pFDyThlAK4WkLwsBQcmORL1wjUxr7K5LmQ/A6w/u4mI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KgqdzqL9S+S8F85+U9XZnhRjRsQQ8iMLyehOWkDLy8/xJIWI9gnhGbYpBzWIVyJWkmUpoYwhGyd2MOryabZkFQJJz5GpO2lJ661AtvNTVoDJHJoouwk89Sqn4CBPB1elbehUjqjZ7A3Vat1IMT2a4mEs5+oYZRWonpsXWuJP5rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HGI1yE7t; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HGI1yE7t"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KZ7X04163435, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269235; bh=myTsXSvoQjU/zqGS9qslzkcx11L6WPJyEHSHtt0x7cI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=HGI1yE7tiOJCd+UU7yIrzOUFJmM0bKmG3BfFNCTI5ToYeHw7yHi6V3v+4ngl1AaCO
	 5E9K+gGieOsATg0k/3eW3uqa96zS7U/TCoYG6yvzUbuzRcW1DeldNquc1J5dWiZXP0
	 zwMITJjVXSdMiQWg89jV6sWs2wqTSFtN4fYJ7zWvivM0Quv0qKQek5pzyVEETovc7R
	 yI+UjSx6UMqgkBXTHE/myEgBas8wM4rmmxifYTaNXYkvD13AWFPIqlTbu3DfSY5XUL
	 97pI79DYjMhR3LRVx18Q5Yjdm8l8Q5odTYtLCOxkvTjPZnlThNdI0xVKUSHiiPN8WV
	 7C9Tk/rx11MKA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KZ7X04163435
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:35 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:35 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:35 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:35 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 4/9] wifi: rtw89: rfk: update TXIQK H2C command format to v1
Date: Fri, 17 Jul 2026 14:19:05 +0800
Message-ID: <20260717061910.54466-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717061910.54466-1-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Chih-Kang Chang <gary.chang@realtek.com>

TX IQK is a RF calibration, the v1 format adds a field for the thermal
re-calibration parameter for RTL8922D after FW 0.35.113.0. Update the
format accordingly.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   | 35 ++++++++++++++++-------
 drivers/net/wireless/realtek/rtw89/fw.h   |  7 ++++-
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 9d782cbfee70..9b7f197a3af2 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5599,6 +5599,7 @@ enum rtw89_fw_feature {
 	),
 	RTW89_FW_FEATURE_RFK_RXDCK_V0,
 	RTW89_FW_FEATURE_RFK_IQK_V0,
+	RTW89_FW_FEATURE_RFK_TXIQK_V0,
 	RTW89_FW_FEATURE_NO_WOW_CPU_IO_RX,
 	RTW89_FW_FEATURE_NOTIFY_AP_INFO,
 	RTW89_FW_FEATURE_CH_INFO_BE_V0,
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 0db77120298f..ad87484f51a7 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -948,6 +948,7 @@ static const struct __fw_feat_cfg fw_feat_tbl[] = {
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 104, 0, TX_HISTORY_V1),
 	__CFG_FW_FEAT(RTL8922D, ge, 0, 35, 108, 0, SIM_SER_L0L1_BY_HALT_H2C),
 	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 109, 1, SCAN_OFFLOAD_BE_V1),
+	__CFG_FW_FEAT(RTL8922D, lt, 0, 35, 113, 0, RFK_TXIQK_V0),
 };
 
 static void rtw89_fw_iterate_feature_cfg(struct rtw89_fw_info *fw,
@@ -8464,29 +8465,43 @@ int rtw89_fw_h2c_rf_tas_trigger(struct rtw89_dev *rtwdev, bool enable)
 int rtw89_fw_h2c_rf_txiqk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx,
 			  const struct rtw89_chan *chan)
 {
+	struct rtw89_h2c_rf_txiqk_v0 *h2c_v0;
 	struct rtw89_h2c_rf_txiqk *h2c;
 	u32 len = sizeof(*h2c);
 	struct sk_buff *skb;
+	u8 ver = U8_MAX;
 	int ret;
 
+	if (RTW89_CHK_FW_FEATURE(RFK_TXIQK_V0, &rtwdev->fw)) {
+		len = sizeof(*h2c_v0);
+		ver = 0;
+	}
+
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
 		rtw89_err(rtwdev, "failed to alloc skb for h2c RF TXIQK\n");
 		return -ENOMEM;
 	}
 	skb_put(skb, len);
-	h2c = (struct rtw89_h2c_rf_txiqk *)skb->data;
+	h2c_v0 = (struct rtw89_h2c_rf_txiqk_v0 *)skb->data;
+
+	h2c_v0->len = len;
+	h2c_v0->phy = phy_idx;
+	h2c_v0->txiqk_enable = true;
+	h2c_v0->is_wb_txiqk = true;
+	h2c_v0->kpath = RF_AB;
+	h2c_v0->cur_band = chan->band_type;
+	h2c_v0->cur_bw = chan->band_width;
+	h2c_v0->cur_ch = chan->channel;
+	h2c_v0->txiqk_dbg_en = rtw89_debug_is_enabled(rtwdev, RTW89_DBG_RFK);
 
-	h2c->len = len;
-	h2c->phy = phy_idx;
-	h2c->txiqk_enable = true;
-	h2c->is_wb_txiqk = true;
-	h2c->kpath = RF_AB;
-	h2c->cur_band = chan->band_type;
-	h2c->cur_bw = chan->band_width;
-	h2c->cur_ch = chan->channel;
-	h2c->txiqk_dbg_en = rtw89_debug_is_enabled(rtwdev, RTW89_DBG_RFK);
+	if (ver == 0)
+		goto hdr;
+
+	h2c = (struct rtw89_h2c_rf_txiqk *)skb->data;
+	h2c->is_ther_rek = false;
 
+hdr:
 	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
 			      H2C_CAT_OUTSRC, H2C_CL_OUTSRC_RF_FW_RFK,
 			      H2C_FUNC_RFK_TXIQK_OFFOAD, 0, 0, len);
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index a1aab8293c14..2654f8fd0e51 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -5042,7 +5042,7 @@ struct rtw89_h2c_rf_rxdck {
 	u8 is_chl_k;
 } __packed;
 
-struct rtw89_h2c_rf_txiqk {
+struct rtw89_h2c_rf_txiqk_v0 {
 	u8 len;
 	u8 phy;
 	u8 txiqk_enable;
@@ -5054,6 +5054,11 @@ struct rtw89_h2c_rf_txiqk {
 	u8 txiqk_dbg_en;
 } __packed;
 
+struct rtw89_h2c_rf_txiqk {
+	struct rtw89_h2c_rf_txiqk_v0 v0;
+	u8 is_ther_rek;
+} __packed;
+
 struct rtw89_h2c_rf_cim3k {
 	u8 len;
 	u8 phy;
-- 
2.25.1

