Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69BB1A6836
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 06:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726515; cv=none; b=ba5mi3fpq1IIK3JRQqzF7hOU00IBfFaUwdxbGrJT5n8rAd+rvW+1OyBd1q4BuRWABFrSaJ8mDmybvPtSc5Kvjvoq7/iIKpyz17B3TlNLmlUFYXTY1Ao1bbSGmynszTNaFZnTr68pzEaW2SGKdrS8jRdXwSXHNA3aIGGlL4vyOsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726515; c=relaxed/simple;
	bh=dpJjUhCEntCBuEgiFETaJAvPL/R/SMfdoZuJrs9E4xk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d+rHB0beu1x+4I912Jr426tIed2cYSqUpc/K+VMFuC1u8YAS+VGN/8dL4hQEgshxYY8Kh/wv+yTojO/XcEyGhc3z8InySD5fkBwfeXrFekst1soJ6JBVuv82LxQ5MiqMmRfABAwBEyTjXXfSK/2eqgmH46PbjfOQ9SWorQ6W0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=uCjijWOt; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="uCjijWOt"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67Q6fprbF353404, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787726511; bh=MkD4eWK5CPZChu0Oa2Y8KgxecdWq0HPAOJlInd0hkvg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=uCjijWOtqXZEkgM89hUKc1pC7iw26ZvxASsdkubyAUyZcC5SZdhoJI5VUvb0ZpJE4
	 6yTe3kvQFdGJfeCOsJRC3HrZneq9k50/L9Zf98AevTJc+x/dJZiVXgBI7xK9irmPKa
	 Ejun6cI4WV4nkIDz+kzE0m7yYdpmyRrqDWbwdWim56q8OcxJJBBA8bG36Tmg60BxUl
	 ThoIYCyhy/tLOLn5gcXrS2iszzslFfnGVYoNli9QV/dw5c8ssnv64jT7VXzul66rZ+
	 EoLIlxKhGa5+93EUOsPXZ77YoyhdBsvxI+hjWEZAS3rmOob733n6XaHOIAGBM70j0v
	 NM5NmtlMjXthQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67Q6fprbF353404
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 14:41:51 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 26 Aug 2026 14:41:51 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 26 Aug 2026 14:41:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 07/14] wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v5
Date: Wed, 26 Aug 2026 14:40:54 +0800
Message-ID: <20260826064101.58892-8-pkshih@realtek.com>
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

