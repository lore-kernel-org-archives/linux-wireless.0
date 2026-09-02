Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC343672BF
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327057; cv=none; b=SvOUl6o+0NDbxMARAlLxvDdnIbBVMeojhx0A3hURCAXMmN7i3O/NOptdKxiPcls2S7DC7LXmuM8cx3lXxTXHd4x3qeiC5Yqgu4142G7j4NHvny+FymOpuziGpiGttBipeWcF1I9p+5xh6LV7LkYV/zGZ70f5526lyeZvM587cds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327057; c=relaxed/simple;
	bh=dpJjUhCEntCBuEgiFETaJAvPL/R/SMfdoZuJrs9E4xk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLvPaRs8HJcb+J+lw0/V6weh18Ae5j5z9VbZ50ds7+qISuioaV+RbStvvyYh5V3rOSw/N2/LRtXs20gkEgUdYWTZ/pcySWuzLvKBY214XJLh7W/nZkCo0UrIUIWN9Dt6p2Lq5B4ydV4qa3bqF22P/kh9ryAJeuTxw0s57DxpLkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=UmawRDt8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="UmawRDt8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825Urj562368450, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327053; bh=MkD4eWK5CPZChu0Oa2Y8KgxecdWq0HPAOJlInd0hkvg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=UmawRDt8Bq9GWa4Lq+3zzFK2rb5KPWALyjWfKk1KUs/uyqhGwlPrzYvj/c3XBb1gz
	 GToKeGcHUJdjJxP45BofeeePCPSyXw2sYR6nMZfwfJgnJIpJsCTPJ6jxvBMRtwTL7i
	 oCAGTV1Q0rC0BrhdY4ayD7DeVOvN4REDZ8ktppdmagVhtte1QVIZucs3vd21qNVbHX
	 Tl0y9iigHMci7MRAkohu68WKZ5flRx3FIc77morz0SaH4Dr9BMBoFWn/RloRivxiLo
	 3m8TIKJo50xSSGA++hQxU5bJAnTHLLKnLBp+BsYVX+ZoyVRGLp31UxnL5FxHP1CPVe
	 fVn0b6DmOlFVA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825Urj562368450
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:30:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:53 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:30:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:30:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 07/14] wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v5
Date: Wed, 2 Sep 2026 13:29:51 +0800
Message-ID: <20260902052958.50371-8-pkshih@realtek.com>
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

Update the BB wrapper RFSI control configuration tables for RTL8922D
variants to v5. The major change is to define qam_th[] per band to
optimize performance for RTL8922D_CID7090 variant, and others variants
keep to use the same values for both bands.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy.h      |  2 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c   |  9 +++++----
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 15 +++++++++------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.h b/drivers/net/wireless/realtek/rtw89/phy.h
index 977cc680ee08..7bbda2ba5b5c 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -631,8 +631,8 @@ struct rtw89_bb_wrap_common_data {
 		} cim3k;
 		u32 rfsi_ct_opt[2];
 		u8 pb_tb;
+		u8 qam_th[3];
 	} bands[RFSI_CTRL_BAND_NUM];
-	u8 qam_th[3];
 };
 
 struct rtw89_bb_wrap_common_data_gen2 {
diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index a8fdf22e06c8..b94754d38673 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -732,6 +732,7 @@ void rtw89_phy_bb_wrap_set_rfsi_bandedge_ch(struct rtw89_dev *rtwdev,
 EXPORT_SYMBOL(rtw89_phy_bb_wrap_set_rfsi_bandedge_ch);
 
 static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(struct rtw89_dev *rtwdev,
+						       const struct rtw89_chan *chan,
 						       enum rtw89_mac_idx mac_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
@@ -740,9 +741,9 @@ static void rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(struct rtw89_dev *rtwdev,
 	if (!d || !d->common)
 		return;
 
-	th0 = d->common->qam_th[0];
-	th1 = d->common->qam_th[1];
-	th2 = d->common->qam_th[2];
+	th0 = d->common->bands[chan->rfsi_band].qam_th[0];
+	th1 = d->common->bands[chan->rfsi_band].qam_th[1];
+	th2 = d->common->bands[chan->rfsi_band].qam_th[2];
 
 	/* TH0 */
 	rtw89_write32_idx(rtwdev, R_QAM_TH0_BE4, B_QAM_TH0_0_BE4, th0, mac_idx);
@@ -1222,7 +1223,7 @@ void rtw89_phy_bb_wrap_tx_rfsi_ctrl_init_by_chan(struct rtw89_dev *rtwdev,
 						 const struct rtw89_chan *chan,
 						 u8 mac_idx)
 {
-	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(rtwdev, mac_idx);
+	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_init(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen2_init(rtwdev, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_qam_comp_th_gen3_init(rtwdev, chan, mac_idx);
 	rtw89_phy_bb_wrap_tx_rfsi_scenario_def(rtwdev, chan, mac_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 4d779ebf6121..5f910163163f 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -347,14 +347,15 @@ static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7025
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 3,
+		.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
 		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
+		.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
 	}},
-	.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
 };
 
 static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7090 = {
@@ -364,14 +365,15 @@ static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7090
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
+		.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
 		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
+		.qam_th = {RFSI_QPSK, RFSI_16QAM, RFSI_256QAM},
 	}},
-	.qam_th = {RFSI_BPSK, RFSI_QPSK, RFSI_256QAM},
 };
 
 static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7090_rfe38 = {
@@ -381,14 +383,15 @@ static const struct rtw89_bb_wrap_common_data rtw8922d_bb_wrap_common_data_7090_
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
+		.qam_th = {RFSI_QPSK, RFSI_16QAM, RFSI_256QAM},
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
 		.cim3k = {CIM3K_ON, CIM3K_ON, CIM3K_ENABLE, CIM3K_ENABLE},
 		.rfsi_ct_opt = {_8nibble(2, 2, 2, 2, 1, 1, 1, 1),
 				_8nibble(2, 2, 2, 2, 1, 1, 1, 1)},
 		.pb_tb = 0,
+		.qam_th = {RFSI_QPSK, RFSI_16QAM, RFSI_256QAM},
 	}},
-	.qam_th = {RFSI_QPSK, RFSI_16QAM, RFSI_256QAM},
 };
 
 static const
@@ -474,7 +477,7 @@ static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_default = {
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
 		.qam_comp_th0 = {0x4000, 0x4400, 0x4500, 0, 0, 0, 0, 0, 0, 0},
-		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4500, 0, 0,
+		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4600, 0, 0,
 						  0, 0, 0, 0, 0)},
 		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0, 0,
 						  0, 0, 0, 0, 0)},
@@ -492,7 +495,7 @@ static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_rfe38 = {
 	.bands = {
 	[RFSI_CTRL_BAND_5_6GHZ] = {
 		.qam_comp_th0 = {0x4000, 0x4400, 0x4500, 0, 0, 0, 0, 0, 0, 0},
-		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4500, 0,
+		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4600, 0,
 						  0, 0, 0, 0, 0, 0)},
 		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0,
 						  0, 0, 0, 0, 0, 0)},
@@ -502,7 +505,7 @@ static const struct rtw89_bb_wrap_data rtw8922d_bb_wrap_data_7090_rfe38 = {
 	},
 	[RFSI_CTRL_BAND_2GHZ] = {
 		.qam_comp_th0 = {0x4000, 0x4400, 0x4500, 0, 0, 0, 0, 0, 0, 0},
-		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0, 0,
+		.qam_comp_th1 = {_10qam_comp_code(0x4000, 0x4400, 0x4700, 0, 0,
 						  0, 0, 0, 0, 0)},
 		.qam_comp_th2 = {_10qam_comp_code(0x4000, 0x4400, 0x4400, 0, 0,
 						  0, 0, 0, 0, 0)},
-- 
2.25.1

