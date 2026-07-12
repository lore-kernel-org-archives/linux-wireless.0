Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C385DDA9
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 03:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783827989; cv=none; b=hWxQoMdPLXpqrAfvee4WXBGjbMEzwuWxsitZ+naXhe0X7PH33o1SH7RwRnrnfRmbBQf9ngFriN/pwoL1Tobl7/59UrY2a1g+8aAJpf59elD9NNJQALnF6SLLKv1eCOSyT9Lobzw9KB68xSCeiEaOxcLTwB0Rfv4SpICbEFhu8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783827989; c=relaxed/simple;
	bh=1U68azhRjy5YHer/6TlMBRXgeB+LcCRN8j7HVAXD9Gw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxTUCet2/ZnyRi2PW83/jsf2sKFxD+MfljKPYhpBxfQiNRcl9Iuiqqdf/HBNHZ1df7JmAseoMmGljSRt+fDlAGUoTmqqfNw1MPwOpOemIJ6sFOuErszYKGYb8gYXjiSY3OxTgBdTsPR331gE59FYta5UB/tESiFvAMeaspnEeLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=KLXhWdBV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="KLXhWdBV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66C3kP641535640, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783827985; bh=cNFELYJgoKU+Y+y0aE65ZsqvSqfpFClWG21jDOh/K5s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=KLXhWdBVcw2kKDjUgWJ5VQ/BYMCVkLYciG04ckh10aeFvlB7jxZ5CnT82oVSSbGj0
	 M2NvCcEadbM54xXBfHtMHL9nRuT2OP5ASif3AN7LNzr05LqMbwc2+Ok+q7cUuBCeZC
	 baH8443hrTHGR5HJfb1dVWth58BwjyBv0AL9AyD33Wlgki0eFCrTLaJes/RrGszJ8z
	 7U+H6+i6ub0Y9D9kDjS7JuseovwTqHpo9UrlhRDTONLqpIw5vHFKyVcIwE4WdmRhFg
	 1eHRrRga3xLy0TG83lHgxzLtBksSukWV12eCqGnvbj9oXNgfwb/QU+TQuRQs+I+Iyl
	 PlggCpKLldkbw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66C3kP641535640
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2026 11:46:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 12 Jul 2026 11:46:25 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 12 Jul 2026 11:46:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <echuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 4/8] wifi: rtw89: introduce helper to get tx shape index
Date: Sun, 12 Jul 2026 11:45:02 +0800
Message-ID: <20260712034506.53209-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260712034506.53209-1-pkshih@realtek.com>
References: <20260712034506.53209-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

TX shape has a set of parameters inside RFE (RF Front End) parameters.
It also depends on regulation and even will depend on regulatory 6 GHz
power type afterwards. Introduce a helper to encapsulate the access to
TX shape index.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h           | 13 +++++++++++++
 drivers/net/wireless/realtek/rtw89/rtw8851b.c       |  6 ++----
 .../net/wireless/realtek/rtw89/rtw8852b_common.c    |  6 ++----
 drivers/net/wireless/realtek/rtw89/rtw8852c.c       |  6 ++----
 drivers/net/wireless/realtek/rtw89/rtw8922a.c       |  9 ++-------
 drivers/net/wireless/realtek/rtw89/rtw8922d.c       |  9 ++-------
 6 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index b7536288c084..1e323007421c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -8042,6 +8042,19 @@ static inline u8 rtw89_regd_get(struct rtw89_dev *rtwdev, u8 band)
 	return txpwr_regd;
 }
 
+static inline u8 rtw89_get_tx_shape_idx(struct rtw89_dev *rtwdev, u8 band,
+					enum rtw89_rate_section rs)
+{
+	const struct rtw89_rfe_parms *rfe_parms = rtwdev->rfe_parms;
+	const struct rtw89_tx_shape *tx_shape = &rfe_parms->tx_shape;
+	u8 regd = rtw89_regd_get(rtwdev, band);
+
+	if (unlikely(rs >= RTW89_RS_TX_SHAPE_NUM))
+		rs = RTW89_RS_OFDM;
+
+	return (*tx_shape->lmt)[band][rs][regd];
+}
+
 static inline void rtw89_ctrl_btg_bt_rx(struct rtw89_dev *rtwdev, bool en,
 					enum rtw89_phy_idx phy_idx)
 {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b.c b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
index 8dd909fc4754..38592504b4d0 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
@@ -1918,11 +1918,9 @@ static void rtw8851b_set_tx_shape(struct rtw89_dev *rtwdev,
 				  const struct rtw89_chan *chan,
 				  enum rtw89_phy_idx phy_idx)
 {
-	const struct rtw89_rfe_parms *rfe_parms = rtwdev->rfe_parms;
 	u8 band = chan->band_type;
-	u8 regd = rtw89_regd_get(rtwdev, band);
-	u8 tx_shape_cck = (*rfe_parms->tx_shape.lmt)[band][RTW89_RS_CCK][regd];
-	u8 tx_shape_ofdm = (*rfe_parms->tx_shape.lmt)[band][RTW89_RS_OFDM][regd];
+	u8 tx_shape_cck = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_CCK);
+	u8 tx_shape_ofdm = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
 
 	if (band == RTW89_BAND_2G)
 		rtw8851b_bb_set_tx_shape_dfir(rtwdev, chan, tx_shape_cck, phy_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b_common.c b/drivers/net/wireless/realtek/rtw89/rtw8852b_common.c
index 7d409a64869f..7c68260dce70 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b_common.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b_common.c
@@ -1321,11 +1321,9 @@ static void rtw8852bx_set_tx_shape(struct rtw89_dev *rtwdev,
 				   const struct rtw89_chan *chan,
 				   enum rtw89_phy_idx phy_idx)
 {
-	const struct rtw89_rfe_parms *rfe_parms = rtwdev->rfe_parms;
 	u8 band = chan->band_type;
-	u8 regd = rtw89_regd_get(rtwdev, band);
-	u8 tx_shape_cck = (*rfe_parms->tx_shape.lmt)[band][RTW89_RS_CCK][regd];
-	u8 tx_shape_ofdm = (*rfe_parms->tx_shape.lmt)[band][RTW89_RS_OFDM][regd];
+	u8 tx_shape_cck = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_CCK);
+	u8 tx_shape_ofdm = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
 
 	if (band == RTW89_BAND_2G)
 		rtw8852bx_bb_set_tx_shape_dfir(rtwdev, chan, tx_shape_cck, phy_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index 54425d707bc6..c7d64fe9c2bc 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2193,11 +2193,9 @@ static void rtw8852c_set_tx_shape(struct rtw89_dev *rtwdev,
 				  const struct rtw89_chan *chan,
 				  enum rtw89_phy_idx phy_idx)
 {
-	const struct rtw89_rfe_parms *rfe_parms = rtwdev->rfe_parms;
 	u8 band = chan->band_type;
-	u8 regd = rtw89_regd_get(rtwdev, band);
-	u8 tx_shape_cck = (*rfe_parms->tx_shape.lmt)[band][RTW89_RS_CCK][regd];
-	u8 tx_shape_ofdm = (*rfe_parms->tx_shape.lmt)[band][RTW89_RS_OFDM][regd];
+	u8 tx_shape_cck = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_CCK);
+	u8 tx_shape_ofdm = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
 
 	if (band == RTW89_BAND_2G)
 		rtw8852c_bb_set_tx_shape_dfir(rtwdev, chan, tx_shape_cck, phy_idx);
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 900aa20cf6ac..86a756f51026 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -2502,15 +2502,10 @@ static void rtw8922a_set_tx_shape(struct rtw89_dev *rtwdev,
 				  const struct rtw89_chan *chan,
 				  enum rtw89_phy_idx phy_idx)
 {
-	const struct rtw89_rfe_parms *rfe_parms = rtwdev->rfe_parms;
-	const struct rtw89_tx_shape *tx_shape = &rfe_parms->tx_shape;
+	u8 band = chan->band_type;
 	u8 tx_shape_idx;
-	u8 band, regd;
-
-	band = chan->band_type;
-	regd = rtw89_regd_get(rtwdev, band);
-	tx_shape_idx = (*tx_shape->lmt)[band][RTW89_RS_OFDM][regd];
 
+	tx_shape_idx = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
 	if (tx_shape_idx == 0)
 		rtw8922a_bb_tx_triangular(rtwdev, false, phy_idx);
 	else
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 27e148b4213a..462165bc2485 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2854,16 +2854,11 @@ static void rtw8922d_set_tx_shape(struct rtw89_dev *rtwdev,
 				  enum rtw89_phy_idx phy_idx)
 {
 	const struct rtw89_bb_wrap_data *d = rtwdev->phy_info.bb_wrap_data;
-	const struct rtw89_rfe_parms *rfe_parms = rtwdev->rfe_parms;
-	const struct rtw89_tx_shape *tx_shape = &rfe_parms->tx_shape;
+	u8 band = chan->band_type;
 	u8 tx_shape_idx;
-	u8 band, regd;
 	const u16 *th;
 
-	band = chan->band_type;
-	regd = rtw89_regd_get(rtwdev, band);
-	tx_shape_idx = (*tx_shape->lmt)[band][RTW89_RS_OFDM][regd];
-
+	tx_shape_idx = rtw89_get_tx_shape_idx(rtwdev, band, RTW89_RS_OFDM);
 	if (tx_shape_idx == 0)
 		goto disable;
 
-- 
2.25.1

