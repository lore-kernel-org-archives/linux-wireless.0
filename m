Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906C925782D
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901462; cv=none; b=fRoX+jZqSsxcqzsTl4uL7Ixg2QUnyayvI4xAaLA0YPEfrzZtJNFRaHovPDWFsxNsf1NYehuvCQqZkVRWmGA73Cx3LMtu4O5fMtXDji368Tj197F8ksuIGrvdbatgnMK6sbntgqxL9ihgGmNEwlENOIPDHDl002bGcDUM+VZjOF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901462; c=relaxed/simple;
	bh=TM48z/Hjxze8qTMWhRXNiTDTg1NBUYrqCxZRZlAen4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCf25vqLROKqpevvvrsaoc1n64CrAhasj+YKoR46HhfCesP8CovBCkBj1OXlCNFfIcbrlCz3E4nwQ/4FLFK5+2wWfLLE47Z6Mpr/kSmcgMcWw3oCKJxC/3chc44e8AgxYc5W5YmBkH8fx80SeUrTtktQcvOZ+c6H0YLtO0uycwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tD4s4NhB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tD4s4NhB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvci671179810, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901458; bh=rs9UAr9AnKrJc+ieyHI8rtdFA2oaDbMQDj98QTKFjwE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=tD4s4NhBM42wIjYAr2mAmxsvIjFvKNWtfvxQTdYvTBTkdIOhXJ4qY33fTMPlLx89k
	 rRUmhsR+F2KunRBjA2aSL6rPPy1/yTwK0STZ70GlUMtTNeJ2anqE3lqZ8c4fVa3R59
	 NziRa0Bng2lzwE9tlHPgnoAxtV8MA8j9xH1mQaAIFPJezNndXvHQIRGFOrCPkAoOv8
	 zFWjiuVQ0aeywRWva+0NCgW7hoksCh5WMV1RHzEHutbQubP8VUO76/raCoDGx2ZKXs
	 3LjLDatHkYvtetACPEUsVxNipFvrjUHRmZEdSdEwuqL31viyr9H+hWLODlNjHnDjPj
	 NQ8ARXp+gXEwQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvci671179810
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:38 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:38 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 11/14] wifi: rtw89: coex: Add dual Bluetooth debug info dump
Date: Fri, 24 Jul 2026 21:56:37 +0800
Message-ID: <20260724135640.3195044-12-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724135640.3195044-1-pkshih@realtek.com>
References: <20260724135640.3195044-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

As RTL8922D support dual Bluetooth, add BT debug info dump for it.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 51 ++++++++++++++++-------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 96bb68f09a01..6a718c54de67 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -9779,10 +9779,13 @@ enum btc_bt_a2dp_type {
 	BTC_A2DP_TWS_RELAY = 2,
 };
 
-static int _show_bt_profile_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
+static int _show_bt_profile_info(struct rtw89_dev *rtwdev, char *buf,
+				 size_t bufsz, u8 bid)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
-	struct rtw89_btc_bt_link_info *bt_linfo = &btc->cx.bt0.link_info;
+	struct rtw89_btc_bt_info *bt = (bid == BTC_BT_1ST) ?
+				       &btc->cx.bt0 : &btc->cx.bt1;
+	struct rtw89_btc_bt_link_info *bt_linfo = &bt->link_info;
 	struct rtw89_btc_bt_hfp_desc hfp = bt_linfo->hfp_desc;
 	struct rtw89_btc_bt_hid_desc hid = bt_linfo->hid_desc;
 	struct rtw89_btc_bt_a2dp_desc a2dp = bt_linfo->a2dp_desc;
@@ -9835,15 +9838,16 @@ static int _show_bt_profile_info(struct rtw89_dev *rtwdev, char *buf, size_t buf
 	return p - buf;
 }
 
-static int _show_bt_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
+static int _show_bt_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz, u8 bid)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
 	const struct rtw89_btc_ver *ver = btc->ver;
 	struct rtw89_btc_cx *cx = &btc->cx;
-	struct rtw89_btc_bt_info *bt = &cx->bt0;
+	struct rtw89_btc_bt_info *bt = (bid == BTC_BT_1ST) ? &cx->bt0 : &cx->bt1;
 	struct rtw89_btc_wl_info *wl = &cx->wl;
 	struct rtw89_btc_bt_link_info *bt_linfo = &bt->link_info;
 	struct rtw89_btc_module *md = &btc->mdinfo;
+	u8 bt_pos = (bid == BTC_BT_1ST) ? md->bt0_pos : md->bt1_pos;
 	s8 br_dbm = bt->link_info.bt_txpwr_desc.br_dbm;
 	s8 le_dbm = bt->link_info.bt_txpwr_desc.le_dbm;
 	u8 hw_band = wl->role_info.pta_req_band;
@@ -9855,13 +9859,21 @@ static int _show_bt_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	if (!(btc->dm.coex_info_map & BTC_COEX_INFO_BT))
 		return 0;
 
-	p += scnprintf(p, end - p, "========== [BT Status] ==========\n");
+	if (bid == BTC_BT_2ND) {
+		if (!(rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT))
+			return 0;
+		if (!bt->enable.now)
+			return 0;
+	}
+
+	p += scnprintf(p, end - p, "========== [BT_%s Status] ==========\n",
+		       bid == BTC_BT_1ST ? "1ST" : "2ND");
 
 	p += scnprintf(p, end - p,
 		       " %-15s : enable:%s, btg:%s%s, connect:%s, ",
 		       "[status]", bt->enable.now ? "Y" : "N",
 		       bt->btg_type ? "Y" : "N",
-		       (bt->enable.now && (bt->btg_type != md->bt0_pos) ?
+		       (bt->enable.now && (bt->btg_type != bt_pos) ?
 			"(efuse-mismatch!!)" : ""),
 		       (bt_linfo->status.map.connect ? "Y" : "N"));
 
@@ -9927,7 +9939,7 @@ static int _show_bt_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       bt->bcnt[BTC_BCNT_INQPAG], bt->bcnt[BTC_BCNT_INQ],
 		       bt->bcnt[BTC_BCNT_PAGE], bt->bcnt[BTC_BCNT_IGNOWL]);
 
-	p += _show_bt_profile_info(rtwdev, p, end - p);
+	p += _show_bt_profile_info(rtwdev, p, end - p, bid);
 
 	p += scnprintf(p, end - p,
 		       " %-15s : raw_data[%02x %02x %02x %02x %02x %02x] (type:%s/cnt:%d/same:%d)\n",
@@ -12034,12 +12046,22 @@ static int _show_mreg_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 			       dm->gnt_set[RTW89_PHY_0].gnt_bt0);
 
 	if (rtwdev->dbcc_en) {
-		p += scnprintf(p, end - p,
-			       ", phy-1[gnt_wl:%s-%d/gnt_bt:%s-%d]",
-			       dm->gnt_set[RTW89_PHY_1].gnt_wl_sw_en ? "SW" : "HW",
-			       dm->gnt_set[RTW89_PHY_1].gnt_wl,
-			       dm->gnt_set[RTW89_PHY_1].gnt_bt0_sw_en ? "SW" : "HW",
-			       dm->gnt_set[RTW89_PHY_1].gnt_bt0);
+		if (rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT)
+			p += scnprintf(p, end - p,
+				       ", phy-1[gnt_wl:%s-%d/gnt_bt0:%s-%d/gnt_bt1:%s-%d]",
+				       dm->gnt_set[RTW89_PHY_1].gnt_wl_sw_en ? "SW" : "HW",
+				       dm->gnt_set[RTW89_PHY_1].gnt_wl,
+				       dm->gnt_set[RTW89_PHY_1].gnt_bt0_sw_en ? "SW" : "HW",
+				       dm->gnt_set[RTW89_PHY_1].gnt_bt0,
+				       dm->gnt_set[RTW89_PHY_1].gnt_bt1_sw_en ? "SW" : "HW",
+				       dm->gnt_set[RTW89_PHY_1].gnt_bt1);
+		else
+			p += scnprintf(p, end - p,
+				       ", phy-1[gnt_wl:%s-%d/gnt_bt:%s-%d]",
+				       dm->gnt_set[RTW89_PHY_1].gnt_wl_sw_en ? "SW" : "HW",
+				       dm->gnt_set[RTW89_PHY_1].gnt_wl,
+				       dm->gnt_set[RTW89_PHY_1].gnt_bt0_sw_en ? "SW" : "HW",
+				       dm->gnt_set[RTW89_PHY_1].gnt_bt0);
 	}
 
 	pcinfo = &pfwinfo->rpt_fbtc_mregval.cinfo;
@@ -13020,7 +13042,8 @@ ssize_t rtw89_btc_dump_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 	p += _show_cx_info(rtwdev, p, end - p);
 	p += _show_wl_info(rtwdev, p, end - p);
-	p += _show_bt_info(rtwdev, p, end - p);
+	p += _show_bt_info(rtwdev, p, end - p, BTC_BT_1ST);
+	p += _show_bt_info(rtwdev, p, end - p, BTC_BT_2ND);
 	p += _show_dm_info(rtwdev, p, end - p);
 	p += _show_fw_dm_msg(rtwdev, p, end - p);
 
-- 
2.25.1

