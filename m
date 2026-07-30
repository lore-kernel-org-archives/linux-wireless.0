Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEDD376BC6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391369; cv=none; b=XbXlOMrqrtW32oWB9QxI4UNAnE2In5SgWZgeeG8+v0miqZVDxfe6DncDMdrT5V5jfWWbzNzx/rm/AJo8Jx91qL+bzVK1WrzJoxXAnLyEtdOY9W3kw/Ri6poWWc1olGupxg3AhV6QJMQ+jeLPlo1Hbkr26UxxnoacWmbeBNZSczU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391369; c=relaxed/simple;
	bh=xfNgHnOB3une+snhc38XtGZ87XkuOEsJqHy1NQB4WEg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lz/fwSUMoRyWNmi+sy8HkfoA56JVgd25h+swYdNWbszToXaaQOMSKvWJfIgk0wcSQzlIX3Pdp2qlg5mGcizzLBmSjlcIdsJfDvNE887wZIFooe8IbYBj6nQn+FPRvJJZDmNz97xfb2IWdbVIrqpDpios4gygSkc1PhyK3ydxrqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=hhC4opYU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="hhC4opYU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62iKpA985906, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391364; bh=GgcJSoUknZIBAvrlPS7pI32u54Q1HebLSoVv/+KFpvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=hhC4opYUQf9KHpMkUwteQ3y7zRYC++YUJS+FYXkaX/XrbcZ55QY05JYxSUnlkVKnr
	 x1vcBzu4aSK+2qG8iBnPDe8glBwpczJPxWxXSgbpu8GEXoEHYzk7HK910CTlFx2sOp
	 9Q5ckb1LOTs2IqrpXISkN+zuwgNTp1NbFSHwLPQfIyaEuYNvEQUo6pCjJK7XQYRfg1
	 JApQTJXtlybYcWWxhGbnQTmt8Id0pDLx9ORcoX+CKqUQbHpZG9G98hlEriCw+WByZl
	 EBUdhteluyzM0se4A6PQ5CYhOj9vWTKdgLhwJ4CZGF/Zq2cRkZMONttH6d6qqX0DjA
	 ljIiTMilH3FqQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62iKpA985906
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:44 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:43 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 4/7] wifi: rtw89: coex: Change Wi-Fi link_mode_v0 translating timing
Date: Thu, 30 Jul 2026 14:02:17 +0800
Message-ID: <20260730060220.55844-5-pkshih@realtek.com>
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

Logic should only get explicit link_mode only, to cover the old branch
link_mode_v0 using (old branch firmware needed) should do translating
after link_mode is settled. And the coexistence logic has already updated
to new branch style, so the logic should use new link_mode, don't need
to consider link_mode_v0. To prevent unexpected logic bug, refine the
related logic.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 247 ++++++++++------------
 1 file changed, 112 insertions(+), 135 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index ac3d0c63f930..2f06fcf0d67f 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -4095,15 +4095,10 @@ static void _set_rf_trx_para(struct rtw89_dev *rtwdev)
 
 	if (bmode == BTC_WLINK_NOLINK) {
 		return;
-	} else if (btc->ver->fwlrole == 10) {
-		if (rf_band == RTW89_BAND_5G) {
-			mode = BTC_WLINK_V0_5G;
-		} else if (rf_band == RTW89_BAND_2G &&
-			   bmode == BTC_WLINK_STA) {
-			mode = BTC_WLINK_V0_2G_STA;
-		}
-	} else {
-		mode = r->link_mode_v0;
+	} else if (rf_band == RTW89_BAND_5G) {
+		mode = BTC_WLINK_V0_5G;
+	} else if (rf_band == RTW89_BAND_2G && bmode == BTC_WLINK_STA) {
+		mode = BTC_WLINK_V0_2G_STA;
 	}
 
 	/* decide trx_para_level */
@@ -6212,14 +6207,15 @@ static void _set_btg_ctrl(struct rtw89_dev *rtwdev)
 	if (btc->ant_type == BTC_ANT_SHARED) {
 		if (!(bt->run_patch_code && bt->enable.now))
 			is_btg = BTC_BTGCTRL_DISABLE;
-		else if (wl_rinfo->link_mode_v0 != BTC_WLINK_V0_5G)
+		else if (wl->rf_band_map[RTW89_MAC_0] & BIT(RTW89_BAND_2G) ||
+			 wl->rf_band_map[RTW89_MAC_1] & BIT(RTW89_BAND_2G))
 			is_btg = BTC_BTGCTRL_ENABLE;
 		else
 			is_btg = BTC_BTGCTRL_DISABLE;
 
 		/* bb call ctrl_btg() in WL FW by slot */
 		if (!btc->ver->fcxosi &&
-		    wl_rinfo->link_mode_v0 == BTC_WLINK_V0_25G_MCC)
+		    wl_rinfo->link_mode == BTC_WLINK_DB_MCC)
 			is_btg = BTC_BTGCTRL_BB_GNT_FWCTRL;
 	}
 
@@ -7107,25 +7103,17 @@ void _update_dbcc_band(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx)
 #define BTC_CHK_HANG_MAX 3
 #define BTC_SCB_INV_VALUE GENMASK(31, 0)
 
-static u8 _get_role_link_mode(struct rtw89_btc_wl_role_info *r, u8 role, bool notv10)
+static u8 _get_role_link_mode(u8 role)
 {
 	switch (role) {
 	case RTW89_WIFI_ROLE_STATION:
 	default:
-		if (notv10)
-			r->link_mode_v0 = BTC_WLINK_V0_2G_STA;
 		return BTC_WLINK_STA;
 	case RTW89_WIFI_ROLE_P2P_GO:
-		if (notv10)
-			r->link_mode_v0 = BTC_WLINK_V0_2G_GO;
 		return BTC_WLINK_GO;
 	case RTW89_WIFI_ROLE_P2P_CLIENT:
-		if (notv10)
-			r->link_mode_v0 = BTC_WLINK_V0_2G_GC;
 		return BTC_WLINK_GC;
 	case RTW89_WIFI_ROLE_AP:
-		if (notv10)
-			r->link_mode_v0 = BTC_WLINK_V0_2G_AP;
 		return BTC_WLINK_AP;
 	}
 }
@@ -7144,13 +7132,12 @@ static bool _chk_role_ch_group(const struct rtw89_btc_chdef *r1,
 }
 
 static u8 _chk_dbcc(struct rtw89_dev *rtwdev, struct rtw89_btc_chdef *ch,
-		    u8 *phy, u8 *role, u8 link_cnt, bool notv10)
+		    u8 *phy, u8 *role, u8 link_cnt)
 {
 	struct rtw89_btc_wl_info *wl = &rtwdev->btc.cx.wl;
 	struct rtw89_btc_wl_role_info *rinfo = &wl->role_info;
 	bool is_2g_ch_exist = false, is_multi_role_in_2g_phy = false;
 	u8 j, k, dbcc_2g_cid = 0, dbcc_2g_cid2 = 0;
-	u8 mode;
 
 	/* find out the 2G-PHY by connect-id ->ch  */
 	for (j = 0; j < link_cnt; j++) {
@@ -7161,12 +7148,8 @@ static u8 _chk_dbcc(struct rtw89_dev *rtwdev, struct rtw89_btc_chdef *ch,
 	}
 
 	/* If no any 2G-port exist, it's impossible because 5G-exclude */
-	if (!is_2g_ch_exist) {
-		mode = BTC_WLINK_SB_MCC;
-		if (notv10)
-			rinfo->link_mode_v0 = BTC_WLINK_V0_5G;
-		return mode;
-	}
+	if (!is_2g_ch_exist)
+		return BTC_WLINK_SB_MCC;
 
 	dbcc_2g_cid = j;
 	rinfo->dbcc_2g_phy = phy[dbcc_2g_cid];
@@ -7178,7 +7161,7 @@ static u8 _chk_dbcc(struct rtw89_dev *rtwdev, struct rtw89_btc_chdef *ch,
 
 	/* connect_cnt <= 2 */
 	if (link_cnt < BTC_TDMA_WLROLE_MAX)
-		return _get_role_link_mode(rinfo, role[dbcc_2g_cid], notv10);
+		return _get_role_link_mode(role[dbcc_2g_cid]);
 
 	/* find the other-port in the 2G-PHY, ex: PHY-0:6G, PHY1: mcc/scc */
 	for (k = 0; k < link_cnt; k++) {
@@ -7194,33 +7177,24 @@ static u8 _chk_dbcc(struct rtw89_dev *rtwdev, struct rtw89_btc_chdef *ch,
 
 	/* Single-role in 2G-PHY */
 	if (!is_multi_role_in_2g_phy)
-		return _get_role_link_mode(rinfo, role[dbcc_2g_cid], notv10);
+		return _get_role_link_mode(role[dbcc_2g_cid]);
 
 	/* 2-role in 2G-PHY */
-	if (ch[dbcc_2g_cid2].center_ch > 14) {
-		if (notv10)
-			rinfo->link_mode_v0 = BTC_WLINK_V0_25G_MCC;
+	if (ch[dbcc_2g_cid2].center_ch > 14)
 		return BTC_WLINK_DB_MCC;
-	} else if (_chk_role_ch_group(&ch[dbcc_2g_cid], &ch[dbcc_2g_cid2])) {
-		if (notv10)
-			rinfo->link_mode_v0 = BTC_WLINK_V0_2G_SCC;
+	else if (_chk_role_ch_group(&ch[dbcc_2g_cid], &ch[dbcc_2g_cid2]))
 		return BTC_WLINK_SCC;
-	} else {
-		if (notv10)
-			rinfo->link_mode_v0 = BTC_WLINK_V0_2G_MCC;
+	else
 		return BTC_WLINK_SB_MCC;
-	}
 }
 
 static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
-	const struct rtw89_btc_ver *ver = btc->ver;
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_wl_mlo_info *mlo_info = &wl->mlo_info;
 	struct rtw89_btc_wl_role_info *r = &wl->role_info;
 	u8 p2p_exist = wl->role_info.p2p_exist;
-	u8 rver = ver->fwlrole;
 
 	if (hw_band == RTW89_PHY_1)
 		p2p_exist = wl->role_info.p2p_exist_hb1;
@@ -7240,20 +7214,6 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		} else {
 			r->link_mode = BTC_WLINK_STA;
 		}
-
-		if (rver >= 10 && rver < 100)
-			break;
-
-		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G) {
-			r->link_mode_v0 = BTC_WLINK_V0_5G;
-		} else if (mlo_info->wmode[hw_band] == RTW89_MR_WMODE_1AP) {
-			r->link_mode_v0 = BTC_WLINK_V0_2G_GO;
-		} else if (mlo_info->wmode[hw_band] == RTW89_MR_WMODE_1CLIENT) {
-			if (wl->role_info.p2p_2g)
-				r->link_mode_v0 = BTC_WLINK_V0_2G_GC;
-			else
-				r->link_mode_v0 = BTC_WLINK_V0_2G_STA;
-		}
 		break;
 	case RTW89_MR_WTYPE_NONMLD_NONMLD: /* Non_MLO 2-role 2+0/0+2 */
 	case RTW89_MR_WTYPE_MLD1L1R_NONMLD: /* MLO only-1 link + P2P 2+0/0+2 */
@@ -7268,36 +7228,12 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		} else {
 			r->link_mode = BTC_WLINK_SCC;
 		}
-
-		if (rver >= 10 && rver < 100)
-			break;
-
-		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G) {
-			r->link_mode_v0 = BTC_WLINK_V0_5G;
-		} else if (mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_2GHZ_5GHZ ||
-			   mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_2GHZ_6GHZ) {
-			r->link_mode_v0 = BTC_WLINK_V0_25G_MCC;
-		} else if (mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_2GHZ) {
-			r->link_mode_v0 = BTC_WLINK_V0_2G_MCC;
-		} else if (mlo_info->ch_type[hw_band] == RTW89_MR_CTX1_2GHZ) {
-			r->link_mode_v0 = BTC_WLINK_V0_2G_SCC;
-		}
 		break;
 	case RTW89_MR_WTYPE_MLD2L1R: /* MLO_MLSR 2+0/0+2 */
 		if (p2p_exist) /* MLO_MLSR only support STA/GC */
 			r->link_mode = BTC_WLINK_GC;
 		else
 			r->link_mode = BTC_WLINK_STA;
-
-		if (rver >= 10 && rver < 100)
-			break;
-
-		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G)
-			r->link_mode_v0 = BTC_WLINK_V0_5G;
-		else if (wl->role_info.p2p_2g)
-			r->link_mode_v0 = BTC_WLINK_V0_2G_GC;
-		else
-			r->link_mode_v0 = BTC_WLINK_V0_2G_STA;
 		break;
 	case RTW89_MR_WTYPE_MLD2L1R_NONMLD: /* MLO_MLSR + P2P 2+0/0+2 */
 	case RTW89_MR_WTYPE_MLD2L2R_NONMLD: /* MLO_MLMR + P2P 1+1/2+2*/
@@ -7306,29 +7242,10 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		 * 5G only -> TDMA slot switch by E5G
 		 */
 		r->link_mode = BTC_WLINK_DB_MCC;
-
-		if (rver >= 10 && rver < 100)
-			break;
-
-		r->link_mode_v0 = BTC_WLINK_V0_25G_MCC;
 		break;
 	case RTW89_MR_WTYPE_MLD2L2R: /* MLO_MLMR  1+1/2+2 */
 		/* MLMR only support STA now (2024) */
 		r->link_mode = BTC_WLINK_STA;
-
-		if (rver >= 10 && rver < 100)
-			break;
-
-		if (mlo_info->hwb_rf_band[hw_band] != RTW89_BAND_2G) {
-			r->link_mode_v0 = BTC_WLINK_V0_5G;
-		} else if (mlo_info->wmode[hw_band] == RTW89_MR_WMODE_1AP) {
-			r->link_mode_v0 = BTC_WLINK_V0_2G_GO;
-		} else if (mlo_info->wmode[hw_band] == RTW89_MR_WMODE_1CLIENT) {
-			if (wl->role_info.p2p_2g)
-				r->link_mode_v0 = BTC_WLINK_V0_2G_GC;
-			else
-				r->link_mode_v0 = BTC_WLINK_V0_2G_STA;
-		}
 		break;
 	}
 }
@@ -7494,8 +7411,6 @@ static void _update_wl_non_mlo_info(struct rtw89_dev *rtwdev)
 	u8 cid_role[RTW89_BE_BTC_WL_MAX_ROLE_NUMBER] = {};
 	u8 cid_phy[RTW89_BE_BTC_WL_MAX_ROLE_NUMBER] = {};
 	bool b2g = false, b5g = false, outloop = false;
-	bool notv10 = rtwdev->btc.ver->fwlrole != 10;
-	u8 mode_v0 = BTC_WLINK_V0_NOLINK;
 	u8 mode = BTC_WLINK_NOLINK;
 	u8 cnt_2g = 0, cnt_5g = 0;
 	u8 i, j, cnt = 0;
@@ -7540,33 +7455,72 @@ static void _update_wl_non_mlo_info(struct rtw89_dev *rtwdev)
 	/* Be careful to change the following sequence!! */
 	if (cnt == 0) {
 		mode = BTC_WLINK_NOLINK;
-		mode_v0 = BTC_WLINK_V0_NOLINK;
 	} else if (wl_rinfo->dbcc_en) {
 		/* update pta_req_band to 2.4GHz HW-BAND for DBCC = 1*/
-		mode = _chk_dbcc(rtwdev, cid_ch, cid_phy, cid_role, cnt, notv10);
-		mode_v0 = wl_rinfo->link_mode_v0;
-	} else if (!b2g && b5g && notv10) {
-		mode = _get_role_link_mode(wl_rinfo, cid_role[0], notv10);
-		mode_v0 = BTC_WLINK_V0_5G;
+		mode = _chk_dbcc(rtwdev, cid_ch, cid_phy, cid_role, cnt);
+	} else if (!b2g && b5g) {
+		mode = _get_role_link_mode(cid_role[0]);
 	} else if (b2g && b5g) {
 		mode = BTC_WLINK_DB_MCC;
-		mode_v0 = BTC_WLINK_V0_25G_MCC;
 	} else if (cnt >= 2) {
-		if (_chk_role_ch_group(&cid_ch[0], &cid_ch[1])) {
+		if (_chk_role_ch_group(&cid_ch[0], &cid_ch[1]))
 			mode = BTC_WLINK_SCC;
-			mode_v0 = BTC_WLINK_V0_2G_SCC;
-		} else {
+		else
 			mode = BTC_WLINK_SB_MCC;
-			mode_v0 = BTC_WLINK_V0_2G_MCC;
-		}
 	} else {
-		mode = _get_role_link_mode(wl_rinfo, cid_role[0], notv10);
-		mode_v0 = wl_rinfo->link_mode_v0;
+		mode = _get_role_link_mode(cid_role[0]);
 	}
 
 	wl_rinfo->link_mode = mode;
 	wl_rinfo->link_mode_hb1 = mode;
-	wl_rinfo->link_mode_v0 = mode_v0;
+}
+
+static void _sync_wl_link_mode_v0(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc_wl_role_info *r = &rtwdev->btc.cx.wl.role_info;
+	bool has_2g = false;
+	int i, j;
+
+	for (i = 0; i < RTW89_BE_BTC_WL_MAX_ROLE_NUMBER && !has_2g; i++)
+		for (j = 0; j < RTW89_MAC_NUM && !has_2g; j++)
+			if (r->rlink[i][j].connected &&
+			    r->rlink[i][j].rf_band == RTW89_BAND_2G)
+				has_2g = true;
+
+	if (!has_2g && r->link_mode != BTC_WLINK_NOLINK) {
+		r->link_mode_v0 = BTC_WLINK_V0_5G;
+		return;
+	}
+
+	switch (r->link_mode) {
+	case BTC_WLINK_NOLINK:
+		r->link_mode_v0 = BTC_WLINK_V0_NOLINK;
+		break;
+	case BTC_WLINK_STA:
+		r->link_mode_v0 = BTC_WLINK_V0_2G_STA;
+		break;
+	case BTC_WLINK_AP:
+		r->link_mode_v0 = BTC_WLINK_V0_2G_AP;
+		break;
+	case BTC_WLINK_GO:
+		r->link_mode_v0 = BTC_WLINK_V0_2G_GO;
+		break;
+	case BTC_WLINK_GC:
+		r->link_mode_v0 = BTC_WLINK_V0_2G_GC;
+		break;
+	case BTC_WLINK_SCC:
+		r->link_mode_v0 = BTC_WLINK_V0_2G_SCC;
+		break;
+	case BTC_WLINK_SB_MCC:
+		r->link_mode_v0 = BTC_WLINK_V0_2G_MCC;
+		break;
+	case BTC_WLINK_DB_MCC:
+		r->link_mode_v0 = BTC_WLINK_V0_25G_MCC;
+		break;
+	default:
+		r->link_mode_v0 = BTC_WLINK_V0_OTHER;
+		break;
+	}
 }
 
 static void _modify_role_link_mode(struct rtw89_dev *rtwdev, u8 hw_band)
@@ -7746,6 +7700,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev, struct rtw89_btc_wl_link_i
 	}
 
 	_modify_role_link_mode(rtwdev, rlink_id);
+	_sync_wl_link_mode_v0(rtwdev);
 
 	if ((rlink_id == RTW89_PHY_0 && wl_rinfo->link_mode != link_mode_ori) ||
 	    (rlink_id == RTW89_PHY_1 && wl_rinfo->link_mode_hb1 != link_mode_ori)) {
@@ -7827,28 +7782,16 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 {
 	struct rtw89_btc_bt_link_info *bt_2g, *bt_56g;
 	struct rtw89_btc *btc = &rtwdev->btc;
-	const struct rtw89_btc_ver *ver = btc->ver;
 	struct rtw89_btc_cx *cx = &btc->cx;
-	struct rtw89_btc_wl_info *wl = &cx->wl;
 	struct rtw89_btc_dm *dm = &btc->dm;
 	struct rtw89_btc_bt_info *bt;
 	u32 val, any_bt_connect, any_bt_6g_connect = 0;
-	u8 id, id_start, id_stop, mode = 0;
-	bool bt_link_change = false;
-	bool lps_ctrl = false;
+	bool bt_link_change = false, lps_ctrl = false;
+	u8 id, id_start, id_stop;
 
 	if (!rtwdev->chip->scbd || bid > BTC_ALL_BT)
 		return;
 
-	if (ver->fwlrole == 10) {
-		if (wl->role_info.link_mode == BTC_WLINK_STA &&
-		    (dm->tdd_en && wl->rf_band_map[RTW89_MAC_0] &
-		     BIT(RTW89_BAND_2G)))
-			mode = BTC_WLINK_V0_2G_STA;
-	} else {
-		mode = wl->role_info.link_mode_v0;
-	}
-
 	if (bid == BTC_ALL_BT) {
 		id_start = BTC_BT_1ST;
 		id_stop = BTC_BT_2ND;
@@ -7937,10 +7880,9 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 		}
 
 		/* if specific profile exist */
-		if (((bt->link_info.a2dp_desc.exist ||
-		      bt->link_info.pan_desc.exist ||
-		      bt->link_info.hfp_desc.exist) &&
-		     mode == BTC_WLINK_V0_2G_STA) ||
+		if (bt->link_info.a2dp_desc.exist ||
+		    bt->link_info.pan_desc.exist ||
+		    bt->link_info.hfp_desc.exist ||
 		    bt->whql_test)
 			lps_ctrl = true;
 
@@ -8468,7 +8410,8 @@ void _run_coex(struct rtw89_dev *rtwdev, enum btc_reason_and_action reason)
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_bt_info *bt = &btc->cx.bt0;
 	u8 mode = btc->dm.tdd_bind.wl_link_mode;
-	u8 mode_v0 = wl->role_info.link_mode_v0;
+	u8 mode_v0 = BTC_WLINK_V0_OTHER;
+	bool has_2ghz;
 
 	lockdep_assert_wiphy(rtwdev->hw->wiphy);
 
@@ -8601,6 +8544,40 @@ void _run_coex(struct rtw89_dev *rtwdev, enum btc_reason_and_action reason)
 			mode_v0 = BTC_WLINK_V0_OTHER;
 			break;
 		}
+	} else {
+		/* No binding (out_of_band): derive mode_v0 from link_mode + rf_band_map */
+		has_2ghz = wl->rf_band_map[RTW89_MAC_0] & BIT(RTW89_BAND_2G) ||
+			   wl->rf_band_map[RTW89_MAC_1] & BIT(RTW89_BAND_2G);
+
+		if (!has_2ghz) {
+			mode_v0 = BTC_WLINK_V0_5G;
+		} else if (mode == BTC_WLINK_DB_MCC) {
+			mode_v0 = BTC_WLINK_V0_25G_MCC;
+		} else {
+			switch (mode) {
+			case BTC_WLINK_STA:
+				mode_v0 = BTC_WLINK_V0_2G_STA;
+				break;
+			case BTC_WLINK_AP:
+				mode_v0 = BTC_WLINK_V0_2G_AP;
+				break;
+			case BTC_WLINK_GO:
+				mode_v0 = BTC_WLINK_V0_2G_GO;
+				break;
+			case BTC_WLINK_GC:
+				mode_v0 = BTC_WLINK_V0_2G_GC;
+				break;
+			case BTC_WLINK_SCC:
+				mode_v0 = BTC_WLINK_V0_2G_SCC;
+				break;
+			case BTC_WLINK_SB_MCC:
+				mode_v0 = BTC_WLINK_V0_2G_MCC;
+				break;
+			default:
+				mode_v0 = BTC_WLINK_V0_OTHER;
+				break;
+			}
+		}
 	}
 
 	switch (mode_v0) {
-- 
2.25.1

