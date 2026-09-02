Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051321A459
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327041; cv=none; b=iO7pPGUuK1RtPDXb3Kw6DBdt3VajodwP4Ujedfshge8jklqfIDRfAQe9/l3k9Adxr98XYofedLQuCN+ppOlmUzk/a1CFaMsccxh7oUEfw4rOXFTg+m2nrgPHyYSbFdUqR2/T9Btm33m/pqLKeKEUbXKtvIPW3yTItmL2IuyPiMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327041; c=relaxed/simple;
	bh=OFYBl4081sq4NwkLpkuvJmbY4l33YG6LELqlpgivw2o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8K9KRP78BTZaS4VrBnxmZOdZjaykwYbY4+rD02rGLjEFG11KXp7nUWaDnt8o3TSB3P1/2aQx7EVe5+oxCE6lIo5iLOhJE/JKcJ+2oxemsAiU4MG2gyuElkHodksM5y3l+LFcgGBB6VNE5ktwN6h4iPdZh0FaxmI7K1qgv+/MFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GbEkefQ1; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GbEkefQ1"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825Ubf962368392, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327037; bh=Yp29ASBmBxgtJN39GUgehWTE2QFp9ycLFwjdsKYDFys=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=GbEkefQ1u3CnxKX7VHbhkcVXqbH8KaaCU0jM5ioHMUay+5lfyeVPDdwcYajnj9nT+
	 xaPhSQqnnUB7UjUusWd0mwjLImvwLTRwY6sCX74hIRkvkPm63IILBCooKHQVg/l0tx
	 MIIju19K20XVVWKoVx0zJJYc5W1xThNS+dNaFG4l/QxFPJAU4CM1OX2RHKbHU3XjtT
	 vVube7ScwPZ5RN1cXHJbl8B78c6w9Wmnmjzu7LhfLQDubdD0TXeURreSM6K9oc3SwR
	 IWgqHu9cec9bvZNHmt11hisnf/kv6YoAlGKeei4D030KFG3RMQJQ9Lxnn7mz/BW2ww
	 NY63oyiHw6BPg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825Ubf962368392
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:30:37 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:37 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:37 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:30:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 04/14] wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v4
Date: Wed, 2 Sep 2026 13:29:48 +0800
Message-ID: <20260902052958.50371-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Eric Huang <echuang@realtek.com>

Update the BB wrapper RFSI control configuration tables for RTL8922D
variants to v4. Remove the redundant table for RFE types 35/41/44,
which use the default 7090 configuration, and add table for RFE
type 38.

Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.h      |  14 ++-
 drivers/net/wireless/realtek/rtw89/phy_be.c   |  79 +++++++++-----
 drivers/net/wireless/realtek/rtw89/reg.h      |   4 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 103 ++++++++++++------
 4 files changed, 139 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.h b/drivers/net/wireless/realtek/rtw89/phy.h
index 0963cdfb1594..7fc15e5c5ffc 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -632,7 +632,18 @@ struct rtw89_bb_wrap_common_data {
 		u32 rfsi_ct_opt[2];
 		u8 pb_tb;
 	} bands[RFSI_CTRL_BAND_NUM];
-	u8 qam_th[6];
+	u8 qam_th[3];
+};
+
+struct rtw89_bb_wrap_common_data_gen2 {
+	struct {
+		u8 mdpd_160m;
+		u8 mdpd_320m;
+		u8 oob_dpd_20m;
+		u8 oob_dpd_40m;
+		u8 oob_dpd_80m;
+		u8 cim3k;
+	} qam_th;
 };
 
 struct rtw89_bb_wrap_common_data_gen3 {
@@ -644,6 +655,7 @@ struct rtw89_bb_wrap_common_data_gen3 {
 
 struct rtw89_bb_wrap_data {
 	const struct rtw89_bb_wrap_common_data *common;
+	const struct rtw89_bb_wrap_common_data_gen2 *common_gen2;
 	const struct rtw89_bb_wrap_common_data_gen3 *common_gen3;
 	struct {
 		u16 qam_comp_th0[MAX_TX_RFSI_CTRL_OPT];
diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index c06927d1dc78..db33b73ab357 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -772,6 +772,26 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_QAM_TH2_BE4, B_QAM_TH2_2_BE4, th2, mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_TH2_BE4, B_QAM_TH2_5_BE4, th2, mac_idx);
 	rtw89_write32_idx(rtwdev, R_QAM_TH2_BE4, B_QAM_TH2_8_BE4, th2, mac_idx);
+}
+
+static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen2_init(struct rtw89_dev *rtwdev,
+							    enum rtw89_mac_idx mac_idx)
+{
+	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
+	const struct rtw89_bb_wrap_common_data_gen2 *common_gen2;
+	u8 th0, th2, th3, th4, th5;
+
+	if (!d || !d->common_gen2)
+		return;
+
+	common_gen2 = d->common_gen2;
+	th0 = common_gen2->qam_th.mdpd_160m;
+	/* th1 (MDPD 320M) has no RTL8922D wrapper register */
+	th2 = common_gen2->qam_th.oob_dpd_20m;
+	th3 = common_gen2->qam_th.oob_dpd_40m;
+	th4 = common_gen2->qam_th.oob_dpd_80m;
+	th5 = common_gen2->qam_th.cim3k;
+
 	/* DPD 160M */
 	rtw89_write32_idx(rtwdev, R_DPD_DBW160_TH0_BE4, B_DPD_DBW160_TH0_0_BE4, th0, mac_idx);
 	rtw89_write32_idx(rtwdev, R_DPD_DBW160_TH0_BE4, B_DPD_DBW160_TH0_1_BE4, th0, mac_idx);
@@ -782,34 +802,34 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(struct rtw89_dev *rtwdev,
 	rtw89_write32_idx(rtwdev, R_DPD_DBW160_TH1_BE4, B_DPD_DBW160_TH1_6_BE4, th0, mac_idx);
 	rtw89_write32_idx(rtwdev, R_DPD_DBW160_TH1_BE4, B_DPD_DBW160_TH1_7_BE4, th0, mac_idx);
 	/* DPD 20M */
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_0_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_1_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_2_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_3_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_4_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_5_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_6_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW20_TH1_7_BE4, 0x2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_0_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_1_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_2_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_3_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_4_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_5_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH0_BE4, B_DPD_CBW20_TH0_6_BE4, th2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW20_TH1_7_BE4, th2, mac_idx);
 	/* DPD 40M */
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_0_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_1_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_2_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_3_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_4_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW20_TH0_3_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW20_TH0_4_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW20_TH0_5_BE4, 0x2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_0_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_1_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_2_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_3_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_4_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_5_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_6_BE4, th3, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW40_TH1_7_BE4, th3, mac_idx);
 	/* DPD 80M */
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW80_TH1_0_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_1_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_2_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_3_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_4_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_5_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_6_BE4, 0x2, mac_idx);
-	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_7_BE4, 0x2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH1_BE4, B_DPD_CBW80_TH1_0_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_1_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_2_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_3_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_4_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_5_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_6_BE4, th4, mac_idx);
+	rtw89_write32_idx(rtwdev, R_DPD_CBW_TH2_BE4, B_DPD_CBW80_TH2_7_BE4, th4, mac_idx);
 	/* CIM3K */
-	rtw89_write32_idx(rtwdev, R_COMP_CIM3K_BE4, B_COMP_CIM3K_TH2_BE4, 0x2, mac_idx);
+	rtw89_write32_idx(rtwdev, R_COMP_CIM3K_BE4, B_COMP_CIM3K_TH2_BE4, th5, mac_idx);
 }
 
 static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen3_init(struct rtw89_dev *rtwdev,
@@ -1097,6 +1117,14 @@ static void rtw89_phy_bb_set_cim3k_val(struct rtw89_dev *rtwdev,
 
 	rtw89_write32_idx(rtwdev, R_CIM3K_SU_FORCE, B_CIM3K_SU_FORCE_EN, 1, mac_idx);
 	rtw89_write32_idx(rtwdev, R_CIM3K_SU_FORCE, B_CIM3K_SU_FORCE_VAL, 0, mac_idx);
+
+	if (rtwdev->hal.cid == RTL8922D_CID7025)
+		return;
+
+	rtw89_write32_idx(rtwdev, R_CIM3K_SU_FORCE, B_CIM3K_RU26_FORCE_EN, 1, mac_idx);
+	rtw89_write32_idx(rtwdev, R_CIM3K_SU_FORCE, B_CIM3K_RU26_FORCE_VAL, 0, mac_idx);
+	rtw89_write32_idx(rtwdev, R_CIM3K_SU_FORCE, B_CIM3K_RU52_FORCE_EN, 1, mac_idx);
+	rtw89_write32_idx(rtwdev, R_CIM3K_SU_FORCE, B_CIM3K_RU52_FORCE_VAL, 1, mac_idx);
 }
 
 static void rtw89_phy_bb_set_cck_cfir_filter_val_gen3(struct rtw89_dev *rtwdev,
@@ -1147,6 +1175,7 @@ static void rtw89_phy_bb_wrap_tx_rfsi_ctrl_init(struct rtw89_dev *rtwdev,
 	chan = conf.chans[phy_idx];
 
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(rtwdev, mac_idx);
+	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen2_init(rtwdev, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen3_init(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_scenario_def(rtwdev, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_val(rtwdev, mac_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index abeeb61007dc..7a3ca9c82548 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -10696,6 +10696,10 @@
 #define B_FBTB_CT_FTM_BE4 GENMASK(23, 20)
 #define B_FBTB_CT_SENS_BE4 GENMASK(27, 24)
 #define R_CIM3K_SU_FORCE 0x119F8
+#define B_CIM3K_RU26_FORCE_EN BIT(13)
+#define B_CIM3K_RU26_FORCE_VAL BIT(14)
+#define B_CIM3K_RU52_FORCE_EN BIT(15)
+#define B_CIM3K_RU52_FORCE_VAL BIT(16)
 #define B_CIM3K_SU_FORCE_EN BIT(17)
 #define B_CIM3K_SU_FORCE_VAL BIT(18)
 #define R_QAM3_TH0_BE4 0x119FC
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index a9737c674ecb..42bfbc1c99b2 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -343,35 +343,76 @@ static const struct rtw89_efuse_block_cfg rtw8922d_efuse_blocks[] = {
 static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7025 = {
 	.bands = {
 	[RFSI_CTRL_BAND_5_6GHZ] = {
-		.cim3k = {CIM3K_OFF, CIM3K_OFF, CIM3K_ENABLE, CIM3K_ENABLE},
+		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 3,
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
-		.cim3k = {CIM3K_OFF, CIM3K_OFF, CIM3K_ENABLE, CIM3K_ENABLE},
+		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
 	}},
-	.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM, RFSI_MAX, RFSI_MAX, RFSI_MAX},
+	.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
 };
 
 static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7090 = {
 	.bands = {
 	[RFSI_CTRL_BAND_5_6GHZ] = {
-		.cim3k = {CIM3K_OFF, CIM3K_OFF, CIM3K_DISABLE, CIM3K_ENABLE},
+		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
-		.pb_tb = 3,
+		.pb_tb = 0,
+	},
+	[RFSI_CTRL_BAND_2GHZ] = {
+		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
+		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
+				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
+		.pb_tb = 0,
+	}},
+	.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
+};
+
+static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7090_rfe38 = {
+	.bands = {
+	[RFSI_CTRL_BAND_5_6GHZ] = {
+		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
+		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
+				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
+		.pb_tb = 0,
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
-		.cim3k = {CIM3K_OFF, CIM3K_OFF, CIM3K_DISABLE, CIM3K_ENABLE},
+		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
 	}},
-	.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM, RFSI_MAX, RFSI_MAX, RFSI_MAX},
+	.qam_th = {RFSI_QPSK, RFSI_16QAM, RFSI_256QAM},
+};
+
+static const
+struct rtw89_bb_wrap_common_data_gen2 rtw8922d_bb_wrap_common_data_gen2_7025 = {
+	.qam_th = {
+		.mdpd_160m = RFSI_BPSK,
+		.mdpd_320m = RFSI_BPSK,
+		.oob_dpd_20m = RFSI_16QAM,
+		.oob_dpd_40m = RFSI_16QAM,
+		.oob_dpd_80m = RFSI_16QAM,
+		.cim3k = RFSI_16QAM,
+	},
+};
+
+static const
+struct rtw89_bb_wrap_common_data_gen2 rtw8922d_bb_wrap_common_data_gen2_7090 = {
+	.qam_th = {
+		.mdpd_160m = RFSI_16QAM,
+		.mdpd_320m = RFSI_16QAM,
+		.oob_dpd_20m = RFSI_16QAM,
+		.oob_dpd_40m = RFSI_16QAM,
+		.oob_dpd_80m = RFSI_16QAM,
+		.cim3k = RFSI_16QAM,
+	},
 };
 
 static const
@@ -390,6 +431,7 @@ struct rtw89_bb_wrap_common_data_gen3 rtw8922d_bb_wrap_common_data_gen3_7090 = {
 
 static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7025_default = {
 	.common = &rtw8922d_bb_wrap_common_data_7025,
+	.common_gen2 = &rtw8922d_bb_wrap_common_data_gen2_7025,
 	.common_gen3 = NULL,
 	.bands = {
 	[RFSI_CTRL_BAND_5_6GHZ] = {
@@ -417,15 +459,16 @@ static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7025_default = {
 
 static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_default = {
 	.common = &rtw8922d_bb_wrap_common_data_7090,
+	.common_gen2 = &rtw8922d_bb_wrap_common_data_gen2_7090,
 	.common_gen3 = &rtw8922d_bb_wrap_common_data_gen3_7090,
 	.bands = {
 	[RFSI_CTRL_BAND_5_6GHZ] = {
-		.qam_comp_th0 = {0x4000, 0x6420, 0x6520, 0x6000, 0, 0, 0, 0, 0, 0},
-		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x6400, 0x6500, 0x6000,
+		.qam_comp_th0 = {0x4000, 0x4400, 0x4500, 0, 0, 0, 0, 0, 0, 0},
+		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4500, 0,
 						  0, 0, 0, 0, 0, 0)},
-		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0x4000,
+		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0,
 						  0, 0, 0, 0, 0, 0)},
-		.qam_comp_ow = {0x4000, 0x4000, 0x4000, 0x4000, 0, 0, 0, 0, 0, 0},
+		.qam_comp_ow = {0x4000, 0x4000, 0x4000, 0, 0, 0, 0, 0, 0, 0},
 		.oob_dpd_by_cbw = {OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF,
 				   OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF},
 	},
@@ -442,23 +485,24 @@ static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_default = {
 	.mdpd_by_dbw = {MDPD_OFF, MDPD_OFF, MDPD_ON, MDPD_ON},
 };
 
-static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_rfe35_41_44 = {
-	.common = &rtw8922d_bb_wrap_common_data_7090,
+static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_rfe38 = {
+	.common = &rtw8922d_bb_wrap_common_data_7090_rfe38,
+	.common_gen2 = &rtw8922d_bb_wrap_common_data_gen2_7090,
 	.common_gen3 = &rtw8922d_bb_wrap_common_data_gen3_7090,
 	.bands = {
 	[RFSI_CTRL_BAND_5_6GHZ] = {
-		.qam_comp_th0 = {0x4000, 0x6420, 0x6520, 0x6000, 0, 0, 0, 0, 0, 0},
-		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x6400, 0x6500, 0x6000,
+		.qam_comp_th0 = {0x4000, 0x4400, 0x4500, 0, 0, 0, 0, 0, 0, 0},
+		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4500, 0,
 						  0, 0, 0, 0, 0, 0)},
-		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0x4000,
+		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0,
 						  0, 0, 0, 0, 0, 0)},
-		.qam_comp_ow = {0x4000, 0x4000, 0x4000, 0x4000, 0, 0, 0, 0, 0, 0},
+		.qam_comp_ow = {0x4000, 0x4000, 0x4000, 0, 0, 0, 0, 0, 0, 0},
 		.oob_dpd_by_cbw = {OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF,
 				   OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF},
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
 		.qam_comp_th0 = {0x4000, 0x4400, 0x4500, 0, 0, 0, 0, 0, 0, 0},
-		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4500, 0, 0,
+		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0, 0,
 						  0, 0, 0, 0, 0)},
 		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0, 0,
 						  0, 0, 0, 0, 0)},
@@ -466,7 +510,7 @@ static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_rfe35_41_44 =
 		.oob_dpd_by_cbw = {OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF,
 				   OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF, OOB_DPD_OFF},
 	}},
-	.mdpd_by_dbw = {MDPD_OFF, MDPD_OFF, MDPD_ON, MDPD_ON},
+	.mdpd_by_dbw = {MDPD_ON, MDPD_ON, MDPD_ON, MDPD_ON},
 };
 
 static void rtw8922d_sel_bt_rx_path(struct rtw89_dev *rtwdev, u8 val,
@@ -1145,24 +1189,13 @@ static int rtw8922d_data_setup(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_bb_wrap_data *data;
 	struct rtw89_hal *hal = &rtwdev->hal;
-	bool rfe35_41_44 = false;
-
-	switch (rtwdev->efuse.rfe_type) {
-	case 35:
-	case 41:
-	case 44:
-		rfe35_41_44 = true;
-		break;
-	}
 
-	if (hal->cid == RTL8922D_CID7025) {
+	if (hal->cid == RTL8922D_CID7025)
 		data = &rtw8922d_bb_wrap_data_7025_default;
-	} else {
-		if (rfe35_41_44)
-			data = &rtw8922d_bb_wrap_data_7090_rfe35_41_44;
-		else
-			data = &rtw8922d_bb_wrap_data_7090_default;
-	}
+	else if (rtwdev->efuse.rfe_type == 38)
+		data = &rtw8922d_bb_wrap_data_7090_rfe38;
+	else
+		data = &rtw8922d_bb_wrap_data_7090_default;
 
 	rtwdev->phy_info.bb_wrap_data = data;
 
-- 
2.25.1

