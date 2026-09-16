Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970C345040E
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543476; cv=none; b=qUZubS1YiNhRbPyEw1yDKLwQXeON1JaccyYXjSbCCrJzoTfoXoKJwbPKeW5EubT2nnbtmokF7+F0L/dQv3iqizdOcZxUXI/IyjVZzLteCYxIt5F3+CtYNj6wp1tFfWL2de4n2fOKUa7rnZ/NXO3/CKwZbpDpWFviBFjhkh3X9nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543476; c=relaxed/simple;
	bh=57XIKRqPxhhmsszthK7WCiyIcSZ+Y9xakoD4V6BnLRQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CAg8RuSKVi8qU0/KLNXVqjpSQ+yexAvpftZXDtdzhLeb0iXQwnjrNC3Bg1G5bd0UCBJS7vfCqZx9zOxPxxScH3k8XWISR2drmwPsrWIRqV6cB+sgHVpPxvSROHycJJV+gZ7Embxg43l4NeWDzzTbLkVtwqCfwQwV+mfS+wG1kmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=rGeB4qGQ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="rGeB4qGQ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7OBZs82168563, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543451; bh=py/XxCXP3ipJOPfJ8gEKcRZK9Omhh5LQrkLvdHxSqtk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=rGeB4qGQJTcad6kJ59WCZrprAzZN3dx8r3kHCE5JvnBcOQ4iPWpMx5GXAn6ARVisp
	 t5eaeA0/WQdyZllcr1o1aP0tLHU0hdVZjK5SYDOSCMA/nexAgAahkZ3CBuDX/g1eiO
	 HT1p6pmJTIrfSIrfIhQ4P1yjn3M4sXLfHg7rmRCQP+Osg1aBKVGROhh96Uidj+boVc
	 PnN9HCu5pJULBub9awG20Y+tTv8ceL52I1Let/eSQQojRxAjW9d6kpwYxiPoin8b+v
	 pubaYSAM1FUwC17rqscDMmQSQqVqH9ynczw+YJmt+G5CU2CiORO486MjWnDs0EKuc2
	 hvvKsSyTIxofA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7OBZs82168563
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:24:11 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:10 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:24:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 11/15] wifi: rtw89: coex: evaluate CO-RX Hi-LNA request per band
Date: Wed, 16 Sep 2026 15:22:34 +0800
Message-ID: <20260916072238.62574-12-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The CO-RX Hi-LNA request for the 2.4 GHz and 5/6 GHz bands was merged
into a single scoreboard write gated by a combined condition. Once a
co-rx band went away, for example after a 2.4 GHz disconnect, the write
for the remaining band no longer covered the vanished band, so its
Hi-LNA request stayed latched and could never be cleared to zero.

Evaluate and write each band's Hi-LNA request independently against the
BT-mirrored state, so the request for a band is cleared as soon as that
band stops being co-rx.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 29 ++++++++++++++---------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 7ee0bd441f7a..f2cf5bdf65c7 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -4051,8 +4051,8 @@ static void _set_bt_corx_table(struct rtw89_dev *rtwdev, bool en)
 	struct rtw89_btc_cx *cx = &btc->cx;
 	struct rtw89_btc_bt_info *bt = &cx->bt0;
 	struct rtw89_btc_dm *dm = &btc->dm;
-	u8 is_24g, is_56g, i;
-	u32 scbd_bit;
+	bool is_24g, is_56g, en_24g, en_56g;
+	u8 i;
 
 	/*
 	 * true: bt use Hi-LNA rx gain table (f/e/3/2) in -3x~-9xdBm for co-rx
@@ -4063,7 +4063,6 @@ static void _set_bt_corx_table(struct rtw89_dev *rtwdev, bool en)
 		return;
 
 	for (i = BTC_BT_1ST; i <= BTC_BT_2ND; i++) {
-		scbd_bit = 0;
 		if (i == BTC_BT_2ND) {
 			if (!(rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT))
 				continue;
@@ -4074,14 +4073,22 @@ static void _set_bt_corx_table(struct rtw89_dev *rtwdev, bool en)
 			  dm->corx_map[BTC_RF_S1][i]) & BIT(RTW89_BAND_2G);
 		is_56g = (dm->corx_map[BTC_RF_S0][i] ||
 			  dm->corx_map[BTC_RF_S1][i]) & BIT(RTW89_BAND_5G);
-		if (is_24g)
-			scbd_bit |= BTC_WSCB_BT_HILNA;
-		if (is_56g)
-			scbd_bit |= BTC_WSCB_BT_HILNA_56G;
-
-		if ((is_24g && (en != (!!bt->hi_lna_rx))) ||
-		    (is_56g && (en != (!!bt->hi_lna_rx_6g))))
-			_write_scbd(rtwdev, i, scbd_bit, en);
+
+		/*
+		 * Request Hi-LNA only when that band is co-rx and enabled.
+		 * Evaluate each band bit independently against the BT-mirrored
+		 * state so the request can still be cleared once a CO-RX band
+		 * disappears (e.g. 2.4 GHz disconnect), avoiding a latched
+		 * Hi-LNA request.
+		 */
+		en_24g = is_24g && en;
+		en_56g = is_56g && en;
+
+		if (en_24g != (!!bt->hi_lna_rx))
+			_write_scbd(rtwdev, i, BTC_WSCB_BT_HILNA, en_24g);
+
+		if (en_56g != (!!bt->hi_lna_rx_6g))
+			_write_scbd(rtwdev, i, BTC_WSCB_BT_HILNA_56G, en_56g);
 	}
 }
 
-- 
2.25.1

