Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EE91A6836
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726506; cv=none; b=fwRu6QlgKgDlfjKGst68t0ByjPmWPmd/eR10LNvvmDeBoPMPiDW+aIrGF62ckj94Wc5umz03Shr30Kom9fUw2XAmEhBH//oyuwnAn/5hkYLy1KnXLnlQhNRw5Yw4cGj6JRpy4kUeYcwRt+1IE4hyYcSdUP02FFkRo+giqsAhY/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726506; c=relaxed/simple;
	bh=ia7kknaSC481hqxPzd68tpobXpCmWtns80fbdyT6kYg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSEqiKhv7FMeKVEof3lxeCMsomJiz62E8hpSR/ku0PLpEhJ6xDPDRihKwLrYsFmwBETIxE8A93s9OV5bgKgMsOI0Ecc4mPM80UqFk1TaYCtq7d4cVOg584tc+Wx+eY00PN7ciP58Pr6m+FPgCK9m1Nqzyl/PvExsff/9oTM6NeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=S8YLG2wr; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="S8YLG2wr"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fflG7353243, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726501; bh=cN7f0Z8f956wZK0Bg/2BiBP37JyGG1IQSORb+V2mQRs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=S8YLG2wrW+d691EoGUE8BsP8GaxyeMlWO2ZkFg6bzEyfFPZNpezblgk8ORk0Y0az5
	 53zYDBFzHeLDYzxoHYZSFmv3htZdYEYQPhWQg0anOOjB8PJpSc6KtsCCQhJ7duPvjY
	 hU1TUxN9Hf7vXwewxnmsXAwb4/WimJTLw0L+mTZpTmWP3Q13oRBVx0zXXtSVdFiS3L
	 1pPegc2iuwtWuSe40tIJMwy8549Uud09vWbCa46Ipb/v0c81GGO98/ZN6h/3JHVfU3
	 T8APYc0UGy2DsCx5C8sbNgK9C2x81uynrHKiwnaBvQ4OUebdp9UxbxgBjXjSQH3e0W
	 xBD/M2x0U+ssw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fflG7353243
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:41 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:42 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 05/14] wifi: rtw89: 8922d: set BB wrapper settings according to operating channel
Date: Wed, 26 Aug 2026 14:40:52 +0800
Message-ID: <20260826064101.58892-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260826064101.58892-1-pkshih@realtek.com>
References: <20260826064101.58892-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The BB wrapper settings are estimated and filled by operating channel.
Set the values according to channels to yield better performance.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.h      |  6 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c   | 64 +++++++++++--------
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  3 +-
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.h b/drivers/net/wireless/realtek/rtw89/phy.h
index 7fc15e5c5ffc..977cc680ee08 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -1051,9 +1051,9 @@ static inline void rtw89_phy_bb_wrap_init(struct rtw89_dev *rtwdev)
 		phy->bb_wrap_init(rtwdev);
 }
 
-void rtw89_phy_bb_wrap_set_rfsi_ct_opt(struct rtw89_dev *rtwdev,
-				       enum rtw89_rfsi_ctrl_band ctrl_band,
-				       enum rtw89_phy_idx phy_idx);
+void rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan(struct rtw89_dev *rtwdev,
+						 const struct rtw89_chan *chan,
+						 u8 mac_idx);
 void rtw89_phy_bb_wrap_set_rfsi_bandedge_ch(struct rtw89_dev *rtwdev,
 					    const struct rtw89_chan *chan,
 					    enum rtw89_phy_idx phy_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index db33b73ab357..5b32910d4661 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -682,9 +682,9 @@ static u32 rtw89_phy_bb_wrap_be_bandedge_decision(struct rtw89_dev *rtwdev,
 	return val;
 }
 
-void rtw89_phy_bb_wrap_set_rfsi_ct_opt(struct rtw89_dev *rtwdev,
-				       enum rtw89_rfsi_ctrl_band rfsi_band,
-				       enum rtw89_phy_idx phy_idx)
+static void rtw89_phy_bb_wrap_set_rfsi_ct_opt(struct rtw89_dev *rtwdev,
+					      const struct rtw89_chan *chan,
+					      enum rtw89_mac_idx mac_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
 	const u32 *val;
@@ -693,15 +693,14 @@ void rtw89_phy_bb_wrap_set_rfsi_ct_opt(struct rtw89_dev *rtwdev,
 	if (!d || !d->common)
 		return;
 
-	val = d->common->bands[rfsi_band].rfsi_ct_opt;
+	val = d->common->bands[chan->rfsi_band].rfsi_ct_opt;
 
-	reg = rtw89_mac_reg_by_idx(rtwdev, R_RFSI_CT_OPT_0_BE4, phy_idx);
+	reg = rtw89_mac_reg_by_idx(rtwdev, R_RFSI_CT_OPT_0_BE4, mac_idx);
 	rtw89_write32(rtwdev, reg, val[0]);
 
-	reg = rtw89_mac_reg_by_idx(rtwdev, R_RFSI_CT_OPT_8_BE4, phy_idx);
+	reg = rtw89_mac_reg_by_idx(rtwdev, R_RFSI_CT_OPT_8_BE4, mac_idx);
 	rtw89_write32(rtwdev, reg, val[1]);
 }
-EXPORT_SYMBOL(rtw89_phy_bb_wrap_set_rfsi_ct_opt);
 
 void rtw89_phy_bb_wrap_set_rfsi_bandedge_ch(struct rtw89_dev *rtwdev,
 					    const struct rtw89_chan *chan,
@@ -902,13 +901,14 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen3_init(struct rtw89_dev *rt
 }
 
 static void rtw89_phy_bb_wrap_tx_rfsi_scenario_def(struct rtw89_dev *rtwdev,
+						   const struct rtw89_chan *chan,
 						   enum rtw89_mac_idx mac_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
 	u8 pb_tb = 0;
 
 	if (d && d->common)
-		pb_tb = d->common->bands[0].pb_tb;
+		pb_tb = d->common->bands[chan->rfsi_band].pb_tb;
 
 	rtw89_write32_idx(rtwdev, R_RFSI_CT_DEF_BE4, B_RFSI_CT_ER_BE4, 0x0, mac_idx);
 	rtw89_write32_idx(rtwdev, R_RFSI_CT_DEF_BE4, B_RFSI_CT_SUBF_BE4, 0x0, mac_idx);
@@ -925,6 +925,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_scenario_def(struct rtw89_dev *rtwdev,
 }
 
 static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
+						   const struct rtw89_chan *chan,
 						   enum rtw89_mac_idx mac_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
@@ -933,7 +934,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 	if (!d || !d->common)
 		return;
 
-	th = d->bands[0].qam_comp_th0;
+	th = d->bands[chan->rfsi_band].qam_comp_th0;
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, MASKLWORD, th[0], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, MASKHWORD, th[1], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, MASKLWORD, th[2], mac_idx);
@@ -943,7 +944,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, MASKLWORD, th[6], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, MASKHWORD, th[7], mac_idx);
 
-	th = d->bands[0].qam_comp_th1;
+	th = d->bands[chan->rfsi_band].qam_comp_th1;
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH4_BE4, B_QAM_COMP_TH4_L, th[0], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH4_BE4, B_QAM_COMP_TH4_M, th[1], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH4_BE4, B_QAM_COMP_TH4_H, th[2], mac_idx);
@@ -953,7 +954,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH6_BE4, B_QAM_COMP_TH6_L, th[6], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH6_BE4, B_QAM_COMP_TH6_M, th[7], mac_idx);
 
-	th = d->bands[0].qam_comp_th2;
+	th = d->bands[chan->rfsi_band].qam_comp_th2;
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH4_BE4, B_QAM_COMP_TH4_2L, th[0], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH4_BE4, B_QAM_COMP_TH4_2M, th[1], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH4_BE4, B_QAM_COMP_TH4_2H, th[2], mac_idx);
@@ -963,7 +964,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH6_BE4, B_QAM_COMP_TH6_2L, th[6], mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH6_BE4, B_QAM_COMP_TH6_2M, th[7], mac_idx);
 
-	th = d->bands[0].qam_comp_ow;
+	th = d->bands[chan->rfsi_band].qam_comp_ow;
 	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, MASKLWORD, th[0], mac_idx);
 	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, MASKHWORD, th[1], mac_idx);
 	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, MASKLWORD, th[2], mac_idx);
@@ -975,6 +976,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 }
 
 static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
+						  const struct rtw89_chan *chan,
 						  enum rtw89_mac_idx mac_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
@@ -983,7 +985,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	if (!d)
 		return;
 
-	th = d->bands[0].oob_dpd_by_cbw[0];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[0];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_CCK0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_CCK1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_CCK2_BE4, th, mac_idx);
@@ -993,7 +995,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_CCK6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_CCK7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[1];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[1];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_CCK0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_CCK1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_CCK2_BE4, th, mac_idx);
@@ -1003,7 +1005,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_CCK6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_CCK7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[2];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[2];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_TH0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_TH1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_TH2_BE4, th, mac_idx);
@@ -1013,7 +1015,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_TH6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW20_BE4, B_OOB_CBW20_TH7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[3];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[3];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_TH0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_TH1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_TH2_BE4, th, mac_idx);
@@ -1023,7 +1025,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_TH6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_TH7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[4];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[4];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_TH0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_TH1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_TH2_BE4, th, mac_idx);
@@ -1033,7 +1035,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_TH6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_TH7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[5];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[5];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW20_OW0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW20_OW1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW20_OW2_BE4, th, mac_idx);
@@ -1043,7 +1045,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW20_OW6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW20_OW7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[6];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[6];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_OW0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_OW1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_OW2_BE4, th, mac_idx);
@@ -1053,7 +1055,7 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_OW6_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW40_BE4, B_OOB_CBW40_OW7_BE4, th, mac_idx);
 
-	th = d->bands[0].oob_dpd_by_cbw[7];
+	th = d->bands[chan->rfsi_band].oob_dpd_by_cbw[7];
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_OW0_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_OW1_BE4, th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_OOB_CBW80_BE4, B_OOB_CBW80_OW2_BE4, th, mac_idx);
@@ -1095,6 +1097,7 @@ static void rtw89_phy_bb_set_mdpd_qam_comp_val(struct rtw89_dev *rtwdev,
 }
 
 static void rtw89_phy_bb_set_cim3k_val(struct rtw89_dev *rtwdev,
+				       const struct rtw89_chan *chan,
 				       enum rtw89_mac_idx mac_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
@@ -1103,7 +1106,7 @@ static void rtw89_phy_bb_set_cim3k_val(struct rtw89_dev *rtwdev,
 	if (!d || !d->common)
 		return;
 
-	p = &d->common->bands[0].cim3k;
+	p = &d->common->bands[chan->rfsi_band].cim3k;
 
 	rtw89_write32_idx(rtwdev, R_COMP_CIM3K_BE4, B_COMP_CIM3K_TH_BE4, p->th, mac_idx);
 	rtw89_write32_idx(rtwdev, R_COMP_CIM3K_BE4, B_COMP_CIM3K_OW_BE4, p->ow, mac_idx);
@@ -1174,18 +1177,25 @@ static void rtw89_phy_bb_wrap_tx_rfsi_ctrl_init(struct rtw89_dev *rtwdev,
 	rtw89_entity_get_conf(rtwdev, &conf);
 	chan = conf.chans[phy_idx];
 
+	rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan(rtwdev, chan, mac_idx);
+}
+
+void rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan(struct rtw89_dev *rtwdev,
+						 const struct rtw89_chan *chan,
+						 u8 mac_idx)
+{
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(rtwdev, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen2_init(rtwdev, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen3_init(rtwdev, chan, mac_idx);
-	rtw89_phy_bb_wrap_tx_rfsi_scenario_def(rtwdev, mac_idx);
-	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(rtwdev, mac_idx);
-	rtw89_phy_bb_set_oob_dpd_qam_comp_val(rtwdev, mac_idx);
+	rtw89_phy_bb_wrap_tx_rfsi_scenario_def(rtwdev, chan, mac_idx);
+	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(rtwdev, chan, mac_idx);
+	rtw89_phy_bb_set_oob_dpd_qam_comp_val(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_set_mdpd_qam_comp_val(rtwdev, mac_idx);
-	rtw89_phy_bb_set_cim3k_val(rtwdev, mac_idx);
+	rtw89_phy_bb_set_cim3k_val(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_set_cck_cfir_filter_val_gen3(rtwdev, mac_idx);
-	rtw89_phy_bb_wrap_set_rfsi_ct_opt(rtwdev, 0, phy_idx);
-	rtw89_phy_bb_wrap_set_rfsi_bandedge_ch(rtwdev, chan, phy_idx);
+	rtw89_phy_bb_wrap_set_rfsi_ct_opt(rtwdev, chan, mac_idx);
 }
+EXPORT_SYMBOL(rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan);
 
 static void rtw89_phy_bb_wrap_ul_pwr(struct rtw89_dev *rtwdev)
 {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 42bfbc1c99b2..828914ad03af 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2544,7 +2544,8 @@ static void rtw8922d_set_channel_bb(struct rtw89_dev *rtwdev,
 	u8 pri_sb = chan->pri_sb_idx;
 	u32 val;
 
-	rtw89_phy_bb_wrap_set_rfsi_ct_opt(rtwdev, chan->rfsi_band, phy_idx);
+	rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan(rtwdev, chan, phy_idx);
+
 	rtw8922d_ctrl_ch(rtwdev, chan, phy_idx);
 	rtw8922d_ctrl_bw(rtwdev, pri_sb, chan->band_width, phy_idx);
 	rtw89_phy_bb_wrap_set_rfsi_bandedge_ch(rtwdev, chan, phy_idx);
-- 
2.25.1

