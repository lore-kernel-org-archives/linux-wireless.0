Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3D3376BC6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391356; cv=none; b=K9BEScFkfrUWOZFvyEkw3ij5Ge+O/yPpi+mNAz8HLenrw/Af63NoQ4RTgyaCG8g4CZZA7z+jEP1TNk9feNvuAUm0v2Sc3HhzGLeRiyrWFbeKtSZg9z7xbMzbEVrTa/2ZGlbsfz6ELakPPS3yC2+0YB6qkq0cVjR0y9dWn+IbFqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391356; c=relaxed/simple;
	bh=WmnFoWx0nTKRi9YBKOFu2SkTOzE6nH0GWR2baXtgMsw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I6qTep2dewj7ZknbG1MJ3YreBz5IfqG+AUiqT/WklI4OpRJA2/L44+D3BprBJLD8vY7rh4yG5VJqE62Jw/Y8R/cGJsCmZ9ab8AMLUtlQaXVIN2gjcHCYCEKGdsYbznl1WaBt0D4G6gYrh6k6a7xOXdV4CPJpsvVY2bdPBHHl5IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=gots39RX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="gots39RX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62R810985848, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391347; bh=7sF5NbdpFVXf2NUlWU4zpv5yOgcm+KDKFZqut/yx7e8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=gots39RXy/m4XLCVyL81XCYmLk4uu4zsNGZ6BGU1CBIhpTthcosHPxauyJT3mP7bH
	 +L1J0dLRV+pPGGqiZvRu53dFcCgQGXe4araX390m6ErA6zUa1/tN5PiRrZfZsLZ2Ys
	 7MtiWOJwNsApfW9H7UdyTlISqnN5Tb1DiBljyJw3ti65BNxXXiz25PWDWYc/a6uFOa
	 P11FthoIQYwax8gTqKIwvlpP5ufwsJn56bS/UQPekBDJEDnSeilsV+u3/S5E5m/nET
	 2GYc61B9SKUWu2GkAh2ZK8ljKeOS732iWi97hbV+MpOO6EBBlX+i+nE0E0vHQy8+7G
	 3mjJBIwJQdV3A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62R810985848
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:27 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:28 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 1/7] wifi: rtw89: coex: Fix Bluetooth link weight not updated on profile change
Date: Thu, 30 Jul 2026 14:02:14 +0800
Message-ID: <20260730060220.55844-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730060220.55844-1-pkshih@realtek.com>
References: <20260730060220.55844-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

_update_bt_link_cnt() was missing the bt->link_weight[].
Without it, link_weight stays at the initial value of 5
(set on BT re-enable) regardless of the active BT profile.

_set_bind_info() uses link_weight to compute b2g_score/b5g_score, which
determines tdd_bind.rf_band. With a stale weight of 5 (below the active
profile threshold), tdd_bind.rf_band may not reflect the actual RF band,
causing mode_v0 in _run_coex() to remain 0 (BTC_WLINK_NOLINK), which
incorrectly triggers _action_wl_nc() instead of the BT-profile action.

Add the link_weight calculation to _update_bt_link_cnt() using the same
weighting table as Formal (BIS/A2DP-sink: 70, A2DP: 40-60, PAN/active: 30,
no-profile: 5, else: 9) and call _update_bt_link_cnt() from
_update_bt_info() after parsing the profile exist flags, replacing the
open-coded link_cnt increment that omitted le-audio profiles.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 30 ++++++++++++++++++-----
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 0e42c720819a..fd9ddd55c192 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -7973,6 +7973,8 @@ static void _update_bt_link_cnt(struct rtw89_dev *rtwdev,
 	struct rtw89_btc_bt_hfp_desc *hfp = &b->hfp_desc;
 	struct rtw89_btc_bt_hid_desc *hid = &b->hid_desc;
 	struct rtw89_btc_bt_pan_desc *pan = &b->pan_desc;
+	u8 bt_rf_band = b56g ? BTC_BT_B5G : BTC_BT_B2G;
+	u8 val;
 
 	b->link_cnt.last = b->link_cnt.now;
 	b->link_cnt.now = 0;
@@ -7984,6 +7986,27 @@ static void _update_bt_link_cnt(struct rtw89_dev *rtwdev,
 	b->link_cnt.now += pan->exist;
 	b->link_cnt.now += leaudio->bis_exist;
 	b->link_cnt.now += leaudio->cis_exist;
+
+	if (leaudio->bis_exist || a2dp->sink) {
+		val = 70;
+	} else if (a2dp->exist) {
+		val = 40;
+		if (a2dp->vendor_id == 0x4c)
+			val += 10;
+		if (hid->exist)
+			val += 10;
+	} else if (pan->exist || pan->active || a2dp->active ||
+		   b->status.map.inq_pag) {
+		val = 30;
+	} else if (b->link_cnt.now == 0) {
+		val = 5;
+	} else {
+		val = 9;
+	}
+	bt->link_weight[bt_rf_band] = val;
+
+	if (b->link_cnt.last != b->link_cnt.now)
+		b->link_cnt.chg = 1;
 }
 
 static void _update_bt_leaudio_info(struct rtw89_dev *rtwdev, u8 bid,
@@ -9012,8 +9035,6 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 		    "[BTC], %s(): bt_info[2]=0x%02x\n",
 		    __func__, bt->raw_info[2]);
 
-	b->link_cnt.last = b->link_cnt.now;
-	b->link_cnt.now = 0;
 	hid->type = 0;
 
 	/* parse raw info low-Byte2 */
@@ -9026,13 +9047,10 @@ static void _update_bt_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
 	bt->bcnt[BTC_BCNT_INQPAG] += !!(bt->inq_pag.now && !bt->inq_pag.last);
 
 	hfp->exist = btinfo.lb2.hfp;
-	b->link_cnt.now += (u8)hfp->exist;
 	hid->exist = btinfo.lb2.hid;
-	b->link_cnt.now += (u8)hid->exist;
 	a2dp->exist = btinfo.lb2.a2dp;
-	b->link_cnt.now += (u8)a2dp->exist;
 	pan->exist = btinfo.lb2.pan;
-	b->link_cnt.now += (u8)pan->exist;
+	_update_bt_link_cnt(rtwdev, bt, 0);
 	btc->dm.trx_info.bt_profile = u32_get_bits(btinfo.val, BT_PROFILE_PROTOCOL_MASK);
 
 	/* parse raw info low-Byte3 */
-- 
2.25.1

