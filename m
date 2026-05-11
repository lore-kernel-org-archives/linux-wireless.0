Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FFF310651
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 07:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778482930; cv=none; b=HoU2kQQ1/jqOQwB9+fXtLWY9ZjZXqL4hjs0nqFofMh2I2HJzDQ+aCy6GG3QRxs89wix8Gn2LRmv2ErQPmCLaU8yQvs4GS9Jf0aytV5G0oAO5otx/wSaPbdA9iBqwIQtFscSw1+l+SKcE/3GeZHOQctEE49G1m+m96ed72nRqJnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778482930; c=relaxed/simple;
	bh=F09Sl2sNbv2PPpOy/dagzLb5QpEmFLuwO6zUCxT2yU4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZdGoD9m0+nWuapPiJOcW4f4ur23yfdzcJ9LnQEBzsJRMRCMRwvhGBFnGZHrIgroKcwKPAzIXHbXhkduXXj9tPHkJUFPpZ/LO12cXS4fOt7jPmvLWEMB699JUJcBmGFXdyk+oE1uhlZCufWBfL1BZyvR7G/rZv/hzinaAjgCadb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pV5azALP; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pV5azALP"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64B7233M02540431, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778482923; bh=JD3qWOOCVBMgfZ2mvN+/ADRJJvfsrRqbpM+pfiR8yqU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=pV5azALPNCrbyfnfUqciBBO37XQnXakpaB+hIxkwwLXYpAIvPQOnpDaNCUkIO4cuW
	 XuD6PbofZXHPpJRWq52wf1hkiJmYnAFOhUInjBQtOZFaucaJJRdpLO6chqY87iFjO6
	 DtxgHdKNpLb8ySmnMxq8+gOtE3ucbRfe+nkd5srDGnHHz53yi8tdl//TxYL7gzJuVf
	 QP5ARarm+xjb+EcqYRC4br++xKDjd1hyxbuaU2vFrbl6coZqs21mUZo7XYfKNpbJ5x
	 b8nu/jYtNZW+sRp8yyqTbAtx83Q0oSWoFWk+DDooD4nuUbpsi7mBt0X1L3Eiv5cbrR
	 9cN7eIYbAOFBw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 64B7233M02540431
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 15:02:03 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 11 May 2026 15:02:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Mon, 11 May 2026 15:02:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH rtw-next 02/11] wifi: rtw89: phy: set BB wrap of out-of-band DPD
Date: Mon, 11 May 2026 15:01:39 +0800
Message-ID: <20260511070148.25257-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260511070148.25257-1-pkshih@realtek.com>
References: <20260511070148.25257-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Control the out-of-band DPD (digital pre-distortion) to ensure out-of-band
signal under requirement.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.h      |  6 +++
 drivers/net/wireless/realtek/rtw89/phy_be.c   | 42 +++++++++++--------
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |  3 ++
 3 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.h b/drivers/net/wireless/realtek/rtw89/phy.h
index e4933bd522b2..0851a56cfe61 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -569,7 +569,13 @@ struct rtw89_phy_rfk_log_fmt {
 	const struct rtw89_fw_element_hdr *elm[RTW89_PHY_C2H_RFK_LOG_FUNC_NUM];
 };
 
+enum rtw89_mdpd_onoff {
+	MDPD_ON = 0,
+	MDPD_OFF = 1,
+};
+
 struct rtw89_bb_wrap_data {
+	u8 mdpd_by_dbw[4];
 };
 
 struct rtw89_phy_gen_def {
diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index 5cd298a2c91b..94b977d29518 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -886,23 +886,31 @@ static void rtw89_phy_bb_set_oob_dpd_qam_comp_val(struct rtw89_dev *rtwdev,
 static void rtw89_phy_bb_set_mdpd_qam_comp_val(struct rtw89_dev *rtwdev,
 					       enum rtw89_mac_idx mac_idx)
 {
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH0_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH1_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH2_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH3_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH4_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH5_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH6_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH7_BE4, 0x0, mac_idx);
-
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW0_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW1_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW2_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW3_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW4_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW5_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW6_BE4, 0x0, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW7_BE4, 0x0, mac_idx);
+	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
+	u8 th;
+
+	if (!d)
+		return;
+
+	th = d->mdpd_by_dbw[0];
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH0_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH1_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH2_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH3_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH4_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH5_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH6_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_TH7_BE4, th, mac_idx);
+
+	th = d->mdpd_by_dbw[2];
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW0_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW1_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW2_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW3_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW4_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW5_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW6_BE4, th, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW160_BE4, B_DPD_CBW160_OW7_BE4, th, mac_idx);
 }
 
 static void rtw89_phy_bb_set_cim3k_val(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 66b05aedcf11..326d12da2962 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -287,12 +287,15 @@ static const struct rtw89_efuse_block_cfg rtw8922d_efuse_blocks[] = {
 };
 
 static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7025_default = {
+	.mdpd_by_dbw = {MDPD_ON, MDPD_ON, MDPD_ON, MDPD_ON},
 };
 
 static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_default = {
+	.mdpd_by_dbw = {MDPD_OFF, MDPD_OFF, MDPD_ON, MDPD_ON},
 };
 
 static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_rfe35_41_44 = {
+	.mdpd_by_dbw = {MDPD_OFF, MDPD_OFF, MDPD_ON, MDPD_ON},
 };
 
 static void rtw8922d_sel_bt_rx_path(struct rtw89_dev *rtwdev, u8 val,
-- 
2.25.1

