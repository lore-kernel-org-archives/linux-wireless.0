Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722B430D41F
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726510; cv=none; b=ie+Whp5RBZVAaTo1lnRqQR43WMJiyDV06Q70oclrCGPUE3SFkt+Dx04rSD8gCqyTqEqnXWD30MFB6+QvU8Mu2G75t4UevVD3WuED+ie5QilV8LmK9fUFb53SGTWyXUih3E7LZzB52pH+A/r0aGH1PVTAbmprXUpQzWnuuztsAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726510; c=relaxed/simple;
	bh=XUi/r5tNG4yjz4e8s4og7696tuON1J3LFMlmKpdJIpU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AF9k8yiS68S8s8FIBS/Ru358yPL5QSQs6M4kEeUeDv4jxoYVvrlSeiNj10HGtjadqOhqXocbKyy4EHnYWL1YLcnJGCZTOHs8Sq5XPKzfEMRLJTr7XmmFdFnjeZpVd5wLJ9n0nhAowJWDTYZXCcgNI3+f7gUwlxpbmo8kDWobAuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=N7sATpKs; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="N7sATpKs"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fjD63353353, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726506; bh=RVyK8FjJmtmuEkK815d0IdqMXNC6bJNQKYs3O4DBJAU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=N7sATpKsdx2m7a6JgsGLxoBGoaFOPDwGmDcWY/IQ//ci6If4uOeuFi90Q24fmfxJT
	 NXlVLQwdLlWImOPGAsDbeR9rDMCCbQqqkYvwqFNoLIijz8XydIj7YJgYwBixOC+D58
	 xJ0DKpVjzXhNSYjvoFWk3MqnL5TQQCJ7kr9H0D3iUIRzEe3g271Qmu25sW8Y9TcszU
	 pe1C64fouX5EPJKWdT6VMdCE9Dg8YQEbklWQbuwxpP5Y8nFD/r6z5o8+kQJcMxBgEf
	 eYrdvO97Nhy1ueq5U5VWIFIS6k1DSvvxOi/2ULyEw0S3Bw1RGtWv5737Nqkmae+wzB
	 Mx9Z6e8QARCyQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fjD63353353
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:45 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:46 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 06/14] wifi: rtw89: 8922d: move conditionally disabled TX shape to common flow
Date: Wed, 26 Aug 2026 14:40:53 +0800
Message-ID: <20260826064101.58892-7-pkshih@realtek.com>
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

By default, the TX shape settings are written to registers. However, if
TX shape type for current operating band isn't necessary, set the
disable-bit to avoid considering TX shape settings.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy_be.c   | 41 +++++++++++++-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 56 -------------------
 2 files changed, 40 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index 5b32910d4661..a8fdf22e06c8 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -931,7 +931,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
 	const u16 *th;
 
-	if (!d || !d->common)
+	if (!d)
 		return;
 
 	th = d->bands[chan->rfsi_band].qam_comp_th0;
@@ -975,6 +975,44 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, MASKHWORD, th[7], mac_idx);
 }
 
+static void rtw89_phy_trig_spect_tx_shape_disabled(struct rtw89_dev *rtwdev,
+						   const struct rtw89_chan *chan,
+						   enum rtw89_mac_idx mac_idx)
+{
+	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
+	u8 band = chan->band_type;
+	u8 tx_shape_idx;
+
+	/*
+	 * Only needed by chips with d->bands[].{qam_comp_th0, qam_comp_ow} as
+	 * what rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val() does.
+	 */
+	if (!d)
+		return;
+
+	tx_shape_idx = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
+	if (tx_shape_idx)
+		return;
+
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH2_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH2_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, mac_idx);
+
+	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, B_OW_VAL_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, B_OW_VAL_TRIANGULAR_H, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, B_OW_VAL_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, B_OW_VAL_TRIANGULAR_H, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_2_BE4, B_OW_VAL_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_2_BE4, B_OW_VAL_TRIANGULAR_H, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, B_OW_VAL_TRIANGULAR_L, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, B_OW_VAL_TRIANGULAR_H, 0, mac_idx);
+}
+
 static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 						  const struct rtw89_chan *chan,
 						  enum rtw89_mac_idx mac_idx)
@@ -1189,6 +1227,7 @@ void rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan(struct rtw89_dev *rtwdev,
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen3_init(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_scenario_def(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(rtwdev, chan, mac_idx);
+	rtw89_phy_trig_spect_tx_shape_disabled(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_set_oob_dpd_qam_comp_val(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_set_mdpd_qam_comp_val(rtwdev, mac_idx);
 	rtw89_phy_bb_set_cim3k_val(rtwdev, chan, mac_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 828914ad03af..4d779ebf6121 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2946,61 +2946,6 @@ static void rtw8922d_set_txpwr_ref(struct rtw89_dev *rtwdev,
 				     B_BE_PWR_REF_CTRL_CCK, ref_cck);
 }
 
-static void rtw8922d_set_tx_shape(struct rtw89_dev *rtwdev,
-				  const struct rtw89_chan *chan,
-				  enum rtw89_phy_idx phy_idx)
-{
-	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
-	u8 band = chan->band_type;
-	u8 tx_shape_idx;
-	const u16 *th;
-
-	tx_shape_idx = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
-	if (tx_shape_idx == 0)
-		goto disable;
-
-	th = d->bands[chan->rfsi_band].qam_comp_th0;
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, MASKLWORD, th[0], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, MASKHWORD, th[1], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, MASKLWORD, th[2], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, MASKHWORD, th[3], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH2_BE4, MASKLWORD, th[4], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH2_BE4, MASKHWORD, th[5], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, MASKLWORD, th[6], phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, MASKHWORD, th[7], phy_idx);
-
-	th = d->bands[chan->rfsi_band].qam_comp_ow;
-	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, MASKLWORD, th[0], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, MASKHWORD, th[1], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, MASKLWORD, th[2], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, MASKHWORD, th[3], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_2_BE4, MASKLWORD, th[4], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_2_BE4, MASKHWORD, th[5], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, MASKLWORD, th[6], phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, MASKHWORD, th[7], phy_idx);
-
-	return;
-
-disable:
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH0_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH1_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH2_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH2_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, B_QAM_COMP_TH_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_QAM_COMP_TH3_BE4, B_QAM_COMP_TH_TRIANGULAR_H, 0, phy_idx);
-
-	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, B_OW_VAL_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_0_BE4, B_OW_VAL_TRIANGULAR_H, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, B_OW_VAL_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_1_BE4, B_OW_VAL_TRIANGULAR_H, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_2_BE4, B_OW_VAL_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_2_BE4, B_OW_VAL_TRIANGULAR_H, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, B_OW_VAL_TRIANGULAR_L, 0, phy_idx);
-	rtw89_write32_idx(rtwdev, R_OW_VAL_3_BE4, B_OW_VAL_TRIANGULAR_H, 0, phy_idx);
-}
-
 static void rtw8922d_set_txpwr_sar_diff(struct rtw89_dev *rtwdev,
 					const struct rtw89_chan *chan,
 					enum rtw89_phy_idx phy_idx)
@@ -3032,7 +2977,6 @@ static void rtw8922d_set_txpwr(struct rtw89_dev *rtwdev,
 {
 	rtw89_phy_set_txpwr_byrate(rtwdev, chan, phy_idx);
 	rtw89_phy_set_txpwr_offset(rtwdev, chan, phy_idx);
-	rtw8922d_set_tx_shape(rtwdev, chan, phy_idx);
 	rtw89_phy_set_txpwr_limit(rtwdev, chan, phy_idx);
 	rtw89_phy_set_txpwr_limit_ru(rtwdev, chan, phy_idx);
 	rtw8922d_set_txpwr_ref(rtwdev, chan, phy_idx);
-- 
2.25.1

