Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83753E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085581; cv=none; b=X952hB//k5GCXa4CVNt9EzR1B3n+W0AosQERQdlc9Z43IM3WWGB0bApfN35MoclOt2JeZyIpQfeNzd7wmmmXfA931JAPV+u7oSiyVn1m/sQici9YcMe599+Q1Eng+vRAh4Gje3vGjo88z1K5k6Q8aDKvtSxJrOc71PGTGbMwtJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085581; c=relaxed/simple;
	bh=9n/7GY0x8nWqFpJlkIhdcVTs4LLprPDZYn9Uj/vQHvI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CbtnhkEmrUqC7U4uEdIIQT0hgi9kxX0BtZNSBcrsbgtvobN5EXncn0aqO8OBE6nRJGZF2uWgSRrtyAOwERrNIRnaCLHXxHbAl1ujgV006WOQ9CQ00zcgTDcPaLUfI7d9MdKGXGf8RzA0IJg9oxCLQ2fd4xw2JOz5qoQYov8b6eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=l+JdPRaX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="l+JdPRaX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kG6v9829275, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085576; bh=VCva3BspI9b1UoGO36xQyoDl91nWAcDYjiqjQXBs5w4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=l+JdPRaXVn331Pkk3B+vlhfXvhLDL2RQKenSUbE+6M+APNOBm1B/nUbzWg/QUf6mJ
	 UPs4CBN4CjGVBnJqBmsypNLEcYeri/PmnJVj20tfLSpN13tf2tRLpvioutK7gpEp2P
	 PskutzK93zBkODsakMzA1FyhVSvNjj9Uc+oI+jdBZ/V0pu8Dq1CPz1Z7YcVxr5yyGs
	 klPhfu1MZpgVO4b7SPsMTPZNGVWzVl+pOUamd2F4xknNQmMCRXlZTFee0BfzvR0Bxd
	 E90wy6h04IoLg8j+6RAsY0OqARh+iVg9UX3sVriHxbDCm/dCzE6HPMqR+NSx9aJUGQ
	 rNzrhojOCIPag==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kG6v9829275
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:16 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:16 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 02/15] wifi: rtw89: coex: track per-HW-band WL role fields with arrays
Date: Sun, 4 Oct 2026 11:45:07 +0800
Message-ID: <20261004034520.33695-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004034520.33695-1-pkshih@realtek.com>
References: <20261004034520.33695-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The role info fields that distinguish HW-band 0 from HW-band 1 were
kept as separate scalar members with a "_hb1" suffix for the second
band, which forced every caller to branch on hw_band and duplicate
the same logic for each member. Convert link_mode, p2p_exist and
role_map in the role info, plus is_5g_hi_ch, go_client_exist,
noa_exist and bg_mode in the WL info, into RTW89_MAC_NUM-indexed
arrays so a single hw_band index addresses both bands.

This lets _update_wl_link_mode(), _update_wl_mlo_info(),
_modify_role_link_mode() and _update_wl_info() drop their
hw_band == RTW89_PHY_1 branches in favor of direct array indexing,
and removes the duplicated per-band assignments at every call site.
The firmware-facing H2C formats are unchanged; only the internal
representation moved from named pairs to an array. Add v11 of the
role info H2C structure and its sender so a later firmware version
bump has a destination to send to. And it should not sharing layout
with the existing v10 structure.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 138 ++++++++++------------
 drivers/net/wireless/realtek/rtw89/core.h |  38 +++---
 drivers/net/wireless/realtek/rtw89/fw.c   | 113 +++++++++++++++---
 drivers/net/wireless/realtek/rtw89/fw.h   |   6 +
 4 files changed, 186 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 271b002a2d40..8412c082ddc8 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3793,6 +3793,8 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 			rtw89_fw_h2c_cxdrv_role_v8(rtwdev, index);
 		else if (ver->fwlrole == 10)
 			rtw89_fw_h2c_cxdrv_role_v10(rtwdev, index);
+		else if (ver->fwlrole == 11)
+			rtw89_fw_h2c_cxdrv_role_v11(rtwdev, index);
 		break;
 	case CXDRVINFO_CTRL:
 		if (ver->drvinfo_ver != 0)
@@ -5244,7 +5246,7 @@ void rtw89_btc_set_policy(struct rtw89_dev *rtwdev, u16 policy_type)
 	case BTC_CXP_PFIX: /* PS-TDMA Fix-Slot */
 		tdma_on = true;
 		*t = t_def[CXTD_PFIX];
-		if (btc->cx.wl.role_info.role_map  & BIT(RTW89_WIFI_ROLE_AP))
+		if (btc->cx.wl.role_info.role_map[RTW89_MAC_0] & BIT(RTW89_WIFI_ROLE_AP))
 			_tdma_set_flctrl(btc, CXFLC_QOSNULL);
 
 		switch (policy_type) {
@@ -5449,7 +5451,7 @@ void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type)
 		tbl_b1 = cxtbl[17];
 		tbl_b4 = cxtbl[17];
 
-		if (wl->bg_mode)
+		if (wl->bg_mode[RTW89_MAC_0])
 			tbl_w1 = cxtbl[8];
 		else if ((wl->status.map.traffic_dir & BIT(RTW89_TFC_UL)) &&
 			 hid->exist)
@@ -5925,7 +5927,7 @@ static void _set_ant(struct rtw89_dev *rtwdev, bool force_exec,
 	    dm->run_reason == BTC_RSN_CMD_SET_COEX)
 		force_exec = FC_EXEC;
 
-	if (wl_rinfo->link_mode != BTC_WLINK_DB_MCC &&
+	if (wl_rinfo->link_mode[RTW89_MAC_0] != BTC_WLINK_DB_MCC &&
 	    btc->dm.wl_btg_rx == 2)
 		force_exec = FC_EXEC;
 
@@ -6141,7 +6143,7 @@ static void _action_bt_hfp(struct rtw89_dev *rtwdev)
 			_set_policy(rtwdev, BTC_CXP_OFF_BWB1, BTC_ACT_BT_HFP);
 		}
 	} else {
-		if (wl->bg_mode)
+		if (wl->bg_mode[RTW89_MAC_0])
 			_set_policy(rtwdev, BTC_CXP_OFF_BWB1, BTC_ACT_BT_HFP);
 		else if (wl->status.map.traffic_dir & BIT(RTW89_TFC_UL))
 			_set_policy(rtwdev, BTC_CXP_OFF_EQ5, BTC_ACT_BT_HFP);
@@ -6179,7 +6181,7 @@ static void _action_bt_hid(struct rtw89_dev *rtwdev)
 			policy_type = BTC_CXP_OFF_BWB1;
 		}
 	} else { /* dedicated-antenna */
-		if (wl->bg_mode)
+		if (wl->bg_mode[RTW89_MAC_0])
 			policy_type = BTC_CXP_OFF_BWB1;
 		else if (wl->status.map.traffic_dir & BIT(RTW89_TFC_UL))
 			policy_type = BTC_CXP_OFF_EQ4;
@@ -6520,7 +6522,7 @@ static void _set_btg_ctrl(struct rtw89_dev *rtwdev)
 
 		/* bb call ctrl_btg() in WL FW by slot */
 		if (!btc->ver->fcxosi &&
-		    wl_rinfo->link_mode == BTC_WLINK_DB_MCC)
+		    wl_rinfo->link_mode[RTW89_MAC_0] == BTC_WLINK_DB_MCC)
 			is_btg = BTC_BTGCTRL_BB_GNT_FWCTRL;
 	}
 
@@ -6580,7 +6582,7 @@ static void _set_wl_preagc_ctrl(struct rtw89_dev *rtwdev)
 		is_preagc = BTC_PREAGC_DISABLE;
 	} else if (dm->tdd_bind.rf_band == BIT(RTW89_BAND_5G)) {
 		is_preagc = BTC_PREAGC_DISABLE;
-	} else if (rinfo->link_mode == BTC_WLINK_NOLINK ||
+	} else if (rinfo->link_mode[RTW89_MAC_0] == BTC_WLINK_NOLINK ||
 		 btc->cx.bt0.link_info.link_cnt.now == 0) {
 		is_preagc = BTC_PREAGC_DISABLE;
 	} else if (dm->tdma_now.type != CXTDMA_OFF &&
@@ -6596,7 +6598,7 @@ static void _set_wl_preagc_ctrl(struct rtw89_dev *rtwdev)
 		is_preagc = BTC_PREAGC_ENABLE;
 	}
 
-	if (!btc->ver->fcxosi && rinfo->link_mode == BTC_WLINK_DB_MCC)
+	if (!btc->ver->fcxosi && rinfo->link_mode[RTW89_MAC_0] == BTC_WLINK_DB_MCC)
 		is_preagc = BTC_PREAGC_BB_FWCTRL;
 
 	if (dm->wl_pre_agc_rb != dm->wl_pre_agc &&
@@ -6743,7 +6745,7 @@ static void _set_wl_tx_limit(struct rtw89_dev *rtwdev)
 
 	if (btc->dm.freerun || btc->ctrl.igno_bt || b->link_cnt.now == 0 ||
 	    dm->tdd_bind.rf_band == BIT(RTW89_BAND_5G) ||
-	    wl_rinfo->link_mode == BTC_WLINK_NOLINK) {
+	    wl_rinfo->link_mode[RTW89_MAC_0] == BTC_WLINK_NOLINK) {
 		enable = 0;
 		tx_time = BTC_MAX_TX_TIME_DEF;
 		tx_retry = BTC_MAX_TX_RETRY_DEF;
@@ -6852,7 +6854,7 @@ static void _set_bt_rx_agc(struct rtw89_dev *rtwdev)
 	struct rtw89_btc_bt_info *bt = &btc->cx.bt0;
 	bool bt_hi_lna_rx = false;
 
-	if (wl_rinfo->link_mode != BTC_WLINK_NOLINK && btc->dm.wl_btg_rx)
+	if (wl_rinfo->link_mode[RTW89_MAC_0] != BTC_WLINK_NOLINK && btc->dm.wl_btg_rx)
 		bt_hi_lna_rx = true;
 
 	if (bt_hi_lna_rx == bt->hi_lna_rx)
@@ -6903,7 +6905,7 @@ static void _update_zb_coex_tbl(struct rtw89_dev *rtwdev)
 	struct rtw89_btc *btc = &rtwdev->btc;
 	u32 zb_tbl0 = 0xda5a5a5a, zb_tbl1 = 0xda5a5a5a;
 	u8 link_mode_chg = btc->cx.wl.link_mode_chg;
-	u8 mode = btc->cx.wl.role_info.link_mode;
+	u8 mode = btc->cx.wl.role_info.link_mode[RTW89_MAC_0];
 
 	if (btc->dm.run_reason != BTC_RSN_NTFY_INIT && !link_mode_chg)
 		return;
@@ -7501,46 +7503,43 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_wl_mlo_info *mlo_info = &wl->mlo_info;
 	struct rtw89_btc_wl_role_info *r = &wl->role_info;
-	u8 p2p_exist = wl->role_info.p2p_exist;
-
-	if (hw_band == RTW89_PHY_1)
-		p2p_exist = wl->role_info.p2p_exist_hb1;
+	u8 p2p_exist = wl->role_info.p2p_exist[hw_band];
 
 	/* MLD: nLmR --> 2L1R: 2-Link by 1-RF,  2L2R: 2-link by 2-RF */
 	switch (type) {
 	case RTW89_MR_WTYPE_NONE: /* no-link */
-		r->link_mode = BTC_WLINK_NOLINK;
+		r->link_mode[hw_band] = BTC_WLINK_NOLINK;
 		break;
 	case RTW89_MR_WTYPE_NONMLD:  /* Non_MLO 1-role 2+0/0+2 */
 	case RTW89_MR_WTYPE_MLD1L1R: /* MLO only-1 link 2+0/0+2 */
 		if (mlo_info->wmode[hw_band] == RTW89_MR_WMODE_1AP) {
-			r->link_mode = BTC_WLINK_GO;
+			r->link_mode[hw_band] = BTC_WLINK_GO;
 		} else if (mlo_info->wmode[hw_band] == RTW89_MR_WMODE_1CLIENT &&
 			   p2p_exist) {
-			r->link_mode = BTC_WLINK_GC;
+			r->link_mode[hw_band] = BTC_WLINK_GC;
 		} else {
-			r->link_mode = BTC_WLINK_STA;
+			r->link_mode[hw_band] = BTC_WLINK_STA;
 		}
 		break;
 	case RTW89_MR_WTYPE_NONMLD_NONMLD: /* Non_MLO 2-role 2+0/0+2 */
 	case RTW89_MR_WTYPE_MLD1L1R_NONMLD: /* MLO only-1 link + P2P 2+0/0+2 */
 		if (mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_2GHZ_5GHZ ||
 		    mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_2GHZ_6GHZ) {
-			r->link_mode = BTC_WLINK_DB_MCC;
+			r->link_mode[hw_band] = BTC_WLINK_DB_MCC;
 		} else if (mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_2GHZ ||
 			   mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_5GHZ ||
 			   mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_6GHZ ||
 			   mlo_info->ch_type[hw_band] == RTW89_MR_CTX2_5GHZ_6GHZ) {
-			r->link_mode = BTC_WLINK_SB_MCC;
+			r->link_mode[hw_band] = BTC_WLINK_SB_MCC;
 		} else {
-			r->link_mode = BTC_WLINK_SCC;
+			r->link_mode[hw_band] = BTC_WLINK_SCC;
 		}
 		break;
 	case RTW89_MR_WTYPE_MLD2L1R: /* MLO_MLSR 2+0/0+2 */
 		if (p2p_exist) /* MLO_MLSR only support STA/GC */
-			r->link_mode = BTC_WLINK_GC;
+			r->link_mode[hw_band] = BTC_WLINK_GC;
 		else
-			r->link_mode = BTC_WLINK_STA;
+			r->link_mode[hw_band] = BTC_WLINK_STA;
 		break;
 	case RTW89_MR_WTYPE_MLD2L1R_NONMLD: /* MLO_MLSR + P2P 2+0/0+2 */
 	case RTW89_MR_WTYPE_MLD2L2R_NONMLD: /* MLO_MLMR + P2P 1+1/2+2*/
@@ -7548,11 +7547,11 @@ static void _update_wl_link_mode(struct rtw89_dev *rtwdev, u8 hw_band, u8 type)
 		 * 2G+5G   -> TDMA slot switch by E2G/E5G
 		 * 5G only -> TDMA slot switch by E5G
 		 */
-		r->link_mode = BTC_WLINK_DB_MCC;
+		r->link_mode[hw_band] = BTC_WLINK_DB_MCC;
 		break;
 	case RTW89_MR_WTYPE_MLD2L2R: /* MLO_MLMR  1+1/2+2 */
 		/* MLMR only support STA now (2024) */
-		r->link_mode = BTC_WLINK_STA;
+		r->link_mode[hw_band] = BTC_WLINK_STA;
 		break;
 	}
 }
@@ -7647,7 +7646,7 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 	case MLO_2_PLUS_0_1RF: /* 2+0 */
 	case MLO_2_PLUS_0_2RF:
 		_update_wl_link_mode(rtwdev, RTW89_MAC_0, type);
-		wl_rinfo->link_mode_hb1 = wl_rinfo->link_mode;
+		wl_rinfo->link_mode[RTW89_MAC_1] = wl_rinfo->link_mode[RTW89_MAC_0];
 		wl_rinfo->pta_req_band = RTW89_MAC_0;
 		wl_rinfo->dbcc_2g_phy = RTW89_PHY_0;
 		wl_rinfo->dbcc_en = 0;
@@ -7659,7 +7658,7 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 	case MLO_0_PLUS_2_1RF: /* 0+2 */
 	case MLO_0_PLUS_2_2RF:
 		_update_wl_link_mode(rtwdev, RTW89_MAC_1, type);
-		wl_rinfo->link_mode_hb1 = wl_rinfo->link_mode;
+		wl_rinfo->link_mode[RTW89_MAC_0] = wl_rinfo->link_mode[RTW89_MAC_1];
 		wl_rinfo->pta_req_band = RTW89_MAC_1;
 		wl_rinfo->dbcc_2g_phy = RTW89_PHY_1;
 		wl_rinfo->dbcc_en = 0;
@@ -7686,7 +7685,6 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 		if (hw_band == RTW89_MAC_0) {
 			mlo_info->path_rf_band[BTC_RF_S0] = rf_band;
 		} else {
-			wl_rinfo->link_mode_hb1 = wl_rinfo->link_mode;
 			mlo_info->path_rf_band[BTC_RF_S1] = rf_band;
 		}
 
@@ -7706,8 +7704,10 @@ static void _update_wl_mlo_info(struct rtw89_dev *rtwdev, u8 hw_band)
 		break;
 	}
 
-	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], %s(), mode=%s, pta_band=%d",
-		    __func__, id_to_linkmode(wl_rinfo->link_mode),
+	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], %s(), link_mode(HWB0=%s/HWB1=%s), pta_band=%d",
+		    __func__,
+		    id_to_linkmode(wl_rinfo->link_mode[RTW89_MAC_0]),
+		    id_to_linkmode(wl_rinfo->link_mode[RTW89_MAC_1]),
 		    wl_rinfo->pta_req_band);
 }
 
@@ -7780,8 +7780,8 @@ static void _update_wl_non_mlo_info(struct rtw89_dev *rtwdev)
 		mode = _get_role_link_mode(cid_role[0]);
 	}
 
-	wl_rinfo->link_mode = mode;
-	wl_rinfo->link_mode_hb1 = mode;
+	wl_rinfo->link_mode[RTW89_MAC_0] = mode;
+	wl_rinfo->link_mode[RTW89_MAC_1] = mode;
 }
 
 static void _sync_wl_link_mode_v0(struct rtw89_dev *rtwdev)
@@ -7796,12 +7796,12 @@ static void _sync_wl_link_mode_v0(struct rtw89_dev *rtwdev)
 			    r->rlink[i][j].rf_band == RTW89_BAND_2G)
 				has_2g = true;
 
-	if (!has_2g && r->link_mode != BTC_WLINK_NOLINK) {
+	if (!has_2g && r->link_mode[RTW89_MAC_0] != BTC_WLINK_NOLINK) {
 		r->link_mode_v0 = BTC_WLINK_V0_5G;
 		return;
 	}
 
-	switch (r->link_mode) {
+	switch (r->link_mode[RTW89_MAC_0]) {
 	case BTC_WLINK_NOLINK:
 		r->link_mode_v0 = BTC_WLINK_V0_NOLINK;
 		break;
@@ -7837,18 +7837,12 @@ static void _modify_role_link_mode(struct rtw89_dev *rtwdev, u8 hw_band)
 	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_wl_role_info *wl_rinfo = &wl->role_info;
-	u8 go_cleint_exist = wl->go_client_exist;
-	u8 *link_mode = &wl_rinfo->link_mode;
-	u32 role_map = wl_rinfo->role_map;
-	u8 noa_exist = wl->noa_exist;
+	u8 go_cleint_exist = wl->go_client_exist[hw_band];
+	u8 *link_mode = &wl_rinfo->link_mode[hw_band];
+	u32 role_map = wl_rinfo->role_map[hw_band];
+	u8 noa_exist = wl->noa_exist[hw_band];
 	u32 mrole = BTC_WLMROLE_NONE;
 
-	if (hw_band == RTW89_PHY_1) {
-		*link_mode = wl_rinfo->link_mode_hb1;
-		role_map = wl_rinfo->role_map_hb1;
-		go_cleint_exist = wl->go_client_exist_hb1;
-	}
-
 	/* if no client_joined, don't care P2P-GO/AP role */
 	if (((role_map & BIT(RTW89_WIFI_ROLE_P2P_GO)) ||
 	      (role_map & BIT(RTW89_WIFI_ROLE_AP))) && !go_cleint_exist) {
@@ -7892,7 +7886,7 @@ static void _modify_role_link_mode(struct rtw89_dev *rtwdev, u8 hw_band)
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
 		    "[BTC], %s(): link_mode=%s, mrole_type=%d\n", __func__,
-		    id_to_linkmode(wl_rinfo->link_mode), wl_rinfo->mrole_type);
+		    id_to_linkmode(*link_mode), wl_rinfo->mrole_type);
 }
 
 static void _update_wl_info(struct rtw89_dev *rtwdev, struct rtw89_btc_wl_link_info *wl_linfo)
@@ -7981,23 +7975,13 @@ static void _update_wl_info(struct rtw89_dev *rtwdev, struct rtw89_btc_wl_link_i
 			bg_mode = 1;
 	}
 
-	if (rlink_id == RTW89_PHY_0) {
-		link_mode_ori = wl_rinfo->link_mode;
-		wl->is_5g_hi_ch = is_5g_hi_ch;
-		wl->bg_mode = bg_mode;
-		wl->go_client_exist = go_client_exist;
-		wl->noa_exist = noa_exist;
-		wl_rinfo->p2p_exist = p2p_exist;
-		wl_rinfo->role_map = role_map;
-	} else {
-		link_mode_ori = wl_rinfo->link_mode_hb1;
-		wl->is_5g_hi_ch_hb1 = is_5g_hi_ch;
-		wl->bg_mode_hb1 = bg_mode;
-		wl->go_client_exist_hb1 = go_client_exist;
-		wl->noa_exist_hb1 = noa_exist;
-		wl_rinfo->p2p_exist_hb1 = p2p_exist;
-		wl_rinfo->role_map_hb1 = role_map;
-	}
+	link_mode_ori = wl_rinfo->link_mode[rlink_id];
+	wl->is_5g_hi_ch[rlink_id] = is_5g_hi_ch;
+	wl->bg_mode[rlink_id] = bg_mode;
+	wl->go_client_exist[rlink_id] = go_client_exist;
+	wl->noa_exist[rlink_id] = noa_exist;
+	wl_rinfo->p2p_exist[rlink_id] = p2p_exist;
+	wl_rinfo->role_map[rlink_id] = role_map;
 
 	dbcc_en_ori = wl_rinfo->dbcc_en;
 
@@ -8011,8 +7995,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev, struct rtw89_btc_wl_link_i
 	_modify_role_link_mode(rtwdev, rlink_id);
 	_sync_wl_link_mode_v0(rtwdev);
 
-	if ((rlink_id == RTW89_PHY_0 && wl_rinfo->link_mode != link_mode_ori) ||
-	    (rlink_id == RTW89_PHY_1 && wl_rinfo->link_mode_hb1 != link_mode_ori)) {
+	if (wl_rinfo->link_mode[rlink_id] != link_mode_ori) {
 		wl_rinfo->link_mode_chg = 1;
 		wl->link_mode_chg = 1;
 	}
@@ -8487,7 +8470,7 @@ static void _set_bind_info(struct rtw89_btc *btc, u8 type)
 	 * HW-Band is decided by wl->mlo_info.mrcx_act_hwb_map
 	 */
 	if (wl->mlo_info.wtype == RTW89_MR_WTYPE_MLD2L1R_NONMLD) {
-		if (wl->role_info.link_mode != BTC_WLINK_DB_MCC) { /* mode chg */
+		if (wl->role_info.link_mode[RTW89_MAC_0] != BTC_WLINK_DB_MCC) { /* mode chg */
 			if (wl->mlo_info.mrcx_act_hwb_map == BIT(RTW89_MAC_1))
 				path_hwb[BTC_RF_S0] = RTW89_PHY_1; /* S0/1->HWB1 */
 			else
@@ -8527,19 +8510,19 @@ static void _set_bind_info(struct rtw89_btc *btc, u8 type)
 
 	if (wl->mlo_info.wtype == RTW89_MR_WTYPE_MLD2L2R &&
 	    (bd->wl_hwb_sel == (BIT(RTW89_MAC_1) | BIT(RTW89_MAC_0)))) {
-		if (wl->role_info.link_mode == BTC_WLINK_AP ||
-		    wl->role_info.link_mode_hb1 == BTC_WLINK_AP)
+		if (wl->role_info.link_mode[RTW89_MAC_0] == BTC_WLINK_AP ||
+		    wl->role_info.link_mode[RTW89_MAC_1] == BTC_WLINK_AP)
 			bd->wl_link_mode = BTC_WLINK_DB_MCC;
 		else
 			bd->wl_link_mode = BTC_WLINK_STA;
-		bd->wl_bg_mode = wl->bg_mode | wl->bg_mode_hb1;
+		bd->wl_bg_mode = wl->bg_mode[RTW89_MAC_0] | wl->bg_mode[RTW89_MAC_1];
 	} else if (bd->wl_hwb_sel == (BIT(RTW89_MAC_1))) {
-		bd->wl_link_mode = wl->role_info.link_mode_hb1;
-		bd->wl_bg_mode = wl->bg_mode_hb1;
+		bd->wl_link_mode = wl->role_info.link_mode[RTW89_MAC_1];
+		bd->wl_bg_mode = wl->bg_mode[RTW89_MAC_1];
 	} else {/* HW-BAND-0 or no-hw-band */
 		bd->wl_hwb_sel = BIT(RTW89_MAC_0);
-		bd->wl_link_mode = wl->role_info.link_mode;
-		bd->wl_bg_mode = wl->bg_mode;
+		bd->wl_link_mode = wl->role_info.link_mode[RTW89_MAC_0];
+		bd->wl_bg_mode = wl->bg_mode[RTW89_MAC_0];
 	}
 
 	/* update Bind-BT status map for BT0/BT1 */
@@ -8657,7 +8640,7 @@ static void _set_coex_binding(struct rtw89_btc *btc)
 	 * In this case, BTC_RF_S0->HWB0, BTC_RF_S1->HWB1
 	 */
 	if (wl->mlo_info.wtype == RTW89_MR_WTYPE_MLD2L1R_NONMLD) {
-		if (wl->role_info.link_mode != BTC_WLINK_DB_MCC) {/* mode chg */
+		if (wl->role_info.link_mode[RTW89_MAC_0] != BTC_WLINK_DB_MCC) {/* mode chg */
 			if (wl->mlo_info.mrcx_act_hwb_map == BIT(RTW89_PHY_1))
 				path_hwb[BTC_RF_S0] = RTW89_PHY_1;/* S0/1->HWB1 */
 			else
@@ -10317,10 +10300,11 @@ static int _show_wl_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 	p += scnprintf(p, end - p, "========== [WL Status] ==========\n");
 
-	mode = wl_rinfo->link_mode;
+	mode = wl_rinfo->link_mode[RTW89_MAC_0];
 
-	p += scnprintf(p, end - p, " %-15s : link_mode:%s, ", "[status]",
-		       id_to_linkmode(mode));
+	p += scnprintf(p, end - p, " %-15s : link_mode:%s(HWB0)/%s(HWB1), ", "[status]",
+		       id_to_linkmode(mode),
+		       id_to_linkmode(wl_rinfo->link_mode[RTW89_MAC_1]));
 
 	p += scnprintf(p, end - p,
 		       "rf_off:%d, power_save:%d, scan:%s(band:%d/phy_map:0x%x), ",
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7e74b5c9ed49..d66a1febb85c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2055,6 +2055,23 @@ struct rtw89_btc_wl_role_info_v10 { /* H2C info, struct size must be n*4 bytes *
 	__le32 mrole_type; /* btc_wl_mrole_type: [31:16]:band1, [15:0]:band0 */
 } __packed;
 
+struct rtw89_btc_wl_role_info_v11 { /* H2C info, struct size must be n*4 bytes */
+	struct rtw89_btc_wl_rlink_v10 rlink[RTW89_BE_BTC_WL_MAX_ROLE_NUMBER][RTW89_MAC_NUM];
+	u8 link_mode;
+	u8 link_mode_hb1;
+	u8 p2p_exist;
+	u8 p2p_exist_hb1;
+
+	u8 pta_req_band;
+	u8 dbcc_en; /* 1+1 and 2.4G-included */
+	u8 dbcc_2g_phy; /* which phy operate in 2G, HW_PHY_0 or HW_PHY_1 */
+	u8 rsvd;
+
+	__le32 role_map;
+	__le32 role_map_hb1;
+	__le32 mrole_type; /* btc_wl_mrole_type: [31:16]:band1, [15:0]:band0 */
+} __packed;
+
 struct rtw89_btc_wl_rlink { /* Logic dynamic using */
 	u8 connected;
 	u8 pid;
@@ -2089,18 +2106,15 @@ struct rtw89_btc_wl_rlink { /* Logic dynamic using */
 
 struct rtw89_btc_wl_role_info { /* Logic dynamic using */
 	struct rtw89_btc_wl_rlink rlink[RTW89_BE_BTC_WL_MAX_ROLE_NUMBER][RTW89_MAC_NUM];
-	u8 link_mode;
-	u8 link_mode_hb1;
-	u8 p2p_exist;
-	u8 p2p_exist_hb1;
+	u8 link_mode[RTW89_MAC_NUM];
+	u8 p2p_exist[RTW89_MAC_NUM];
 
 	u8 pta_req_band;
 	u8 dbcc_en; /* 1+1 and 2.4G-included */
 	u8 dbcc_2g_phy; /* which phy operate in 2G, HW_PHY_0 or HW_PHY_1 */
 	u8 rsvd;
 
-	u32 role_map;
-	u32 role_map_hb1;
+	u32 role_map[RTW89_MAC_NUM];
 	u32 mrole_type; /* btc_wl_mrole_type: [31:16]:band1, [15:0]:band0 */
 
 	/* Before v10 use this linkmode */
@@ -2397,15 +2411,11 @@ struct rtw89_btc_wl_info {
 	u8 ch_map[12];
 	u8 ch_map_le[5];
 
-	bool is_5g_hi_ch;
-	bool is_5g_hi_ch_hb1;
-	bool go_client_exist;
-	bool go_client_exist_hb1;
-	bool noa_exist;
-	bool noa_exist_hb1;
+	bool is_5g_hi_ch[RTW89_MAC_NUM];
+	bool go_client_exist[RTW89_MAC_NUM];
+	bool noa_exist[RTW89_MAC_NUM];
 	bool pta_reg_mac_chg;
-	bool bg_mode;
-	bool bg_mode_hb1;
+	bool bg_mode[RTW89_MAC_NUM];
 	bool he_mode;
 	bool scbd_chg[BTC_ALL_BT];
 	bool fw_ver_mismatch;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 4ac2fd117b95..886d7c32d2ef 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6456,7 +6456,7 @@ int rtw89_fw_h2c_cxdrv_role(struct rtw89_dev *rtwdev, u8 type)
 	const struct rtw89_btc_ver *ver = btc->ver;
 	struct rtw89_btc_wl_rlink *rl;
 	struct sk_buff *skb;
-	u32 rmap = r->role_map;
+	u32 rmap = r->role_map[RTW89_MAC_0];
 	u8 offset = 0;
 	u32 len;
 	u8 *cmd;
@@ -6477,7 +6477,7 @@ int rtw89_fw_h2c_cxdrv_role(struct rtw89_dev *rtwdev, u8 type)
 	RTW89_SET_FWCMD_CXHDR_LEN(cmd, len - H2C_LEN_CXDRVHDR);
 
 	RTW89_SET_FWCMD_CXROLE_CONNECT_CNT(cmd, r->connect_cnt);
-	RTW89_SET_FWCMD_CXROLE_LINK_MODE(cmd, r->link_mode);
+	RTW89_SET_FWCMD_CXROLE_LINK_MODE(cmd, r->link_mode[RTW89_MAC_0]);
 
 	RTW89_SET_FWCMD_CXROLE_ROLE_NONE(cmd, !!(rmap & BIT(RTW89_WIFI_ROLE_NONE)));
 	RTW89_SET_FWCMD_CXROLE_ROLE_STA(cmd, !!(rmap & BIT(RTW89_WIFI_ROLE_STATION)));
@@ -6538,7 +6538,7 @@ int rtw89_fw_h2c_cxdrv_role_v1(struct rtw89_dev *rtwdev, u8 type)
 	struct rtw89_btc_wl_role_info *r = &wl->role_info;
 	struct rtw89_btc_wl_rlink *rl;
 	struct sk_buff *skb;
-	u32 rmap = r->role_map;
+	u32 rmap = r->role_map[RTW89_MAC_0];
 	u8 *cmd, offset;
 	u32 len;
 	int ret;
@@ -6558,7 +6558,7 @@ int rtw89_fw_h2c_cxdrv_role_v1(struct rtw89_dev *rtwdev, u8 type)
 	RTW89_SET_FWCMD_CXHDR_LEN(cmd, len - H2C_LEN_CXDRVHDR);
 
 	RTW89_SET_FWCMD_CXROLE_CONNECT_CNT(cmd, r->connect_cnt);
-	RTW89_SET_FWCMD_CXROLE_LINK_MODE(cmd, r->link_mode);
+	RTW89_SET_FWCMD_CXROLE_LINK_MODE(cmd, r->link_mode[RTW89_MAC_0]);
 
 	RTW89_SET_FWCMD_CXROLE_ROLE_NONE(cmd, !!(rmap & BIT(RTW89_WIFI_ROLE_NONE)));
 	RTW89_SET_FWCMD_CXROLE_ROLE_STA(cmd, !!(rmap & BIT(RTW89_WIFI_ROLE_STATION)));
@@ -6643,8 +6643,8 @@ int rtw89_fw_h2c_cxdrv_role_v101(struct rtw89_dev *rtwdev, u8 type)
 	h2c->hdr.len = len - H2C_LEN_CXDRVHDR;
 
 	h2c->connect_cnt = role_info->connect_cnt;
-	h2c->link_mode = role_info->link_mode;
-	h2c->role_map = cpu_to_le16(role_info->role_map);
+	h2c->link_mode = role_info->link_mode[RTW89_MAC_0];
+	h2c->role_map = cpu_to_le16(role_info->role_map[RTW89_MAC_0]);
 
 	for (i = 0; i < RTW89_PORT_NUM; i++) {
 		active = &role_info->rlink[i][0];
@@ -6712,7 +6712,7 @@ int rtw89_fw_h2c_cxdrv_role_v2(struct rtw89_dev *rtwdev, u8 type)
 	struct rtw89_btc_wl_role_info *r = &wl->role_info;
 	struct rtw89_btc_wl_rlink *rl;
 	struct sk_buff *skb;
-	u32 rmap = r->role_map;
+	u32 rmap = r->role_map[RTW89_MAC_0];
 	u32 len;
 	u8 *cmd, offset;
 	int ret;
@@ -6732,7 +6732,7 @@ int rtw89_fw_h2c_cxdrv_role_v2(struct rtw89_dev *rtwdev, u8 type)
 	RTW89_SET_FWCMD_CXHDR_LEN(cmd, len - H2C_LEN_CXDRVHDR);
 
 	RTW89_SET_FWCMD_CXROLE_CONNECT_CNT(cmd, r->connect_cnt);
-	RTW89_SET_FWCMD_CXROLE_LINK_MODE(cmd, r->link_mode);
+	RTW89_SET_FWCMD_CXROLE_LINK_MODE(cmd, r->link_mode[RTW89_MAC_0]);
 
 	RTW89_SET_FWCMD_CXROLE_ROLE_NONE(cmd, !!(rmap & BIT(RTW89_WIFI_ROLE_NONE)));
 	RTW89_SET_FWCMD_CXROLE_ROLE_STA(cmd, !!(rmap & BIT(RTW89_WIFI_ROLE_STATION)));
@@ -6813,7 +6813,7 @@ int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type)
 	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
 
 	h2c->r.connect_cnt = r->connect_cnt;
-	h2c->r.link_mode = r->link_mode;
+	h2c->r.link_mode = r->link_mode[RTW89_MAC_0];
 	h2c->r.link_mode_chg = r->link_mode_chg;
 	h2c->r.p2p_2g = r->p2p_2g;
 
@@ -6834,7 +6834,7 @@ int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type)
 		h2c->r.active_role[i].client_cnt = rl->client_cnt;
 	}
 
-	rm = cpu_to_le32(r->role_map);
+	rm = cpu_to_le32(r->role_map[RTW89_MAC_0]);
 	memcpy(&h2c->r.role_map, &rm, sizeof(h2c->r.role_map));
 	h2c->r.mrole_type = cpu_to_le32(r->mrole_type);
 	h2c->r.mrole_noa_duration = cpu_to_le32(r->mrole_noa_duration);
@@ -6883,7 +6883,7 @@ int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type)
 	h2c->hdr.ver = 8;
 	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
 	h2c->r.connect_cnt = r->connect_cnt;
-	h2c->r.link_mode = r->link_mode;
+	h2c->r.link_mode = r->link_mode[RTW89_MAC_0];
 	h2c->r.link_mode_chg =  r->link_mode_chg;
 	h2c->r.p2p_2g = r->p2p_2g;
 	h2c->r.pta_req_band = r->pta_req_band;
@@ -6911,7 +6911,7 @@ int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type)
 		}
 	}
 
-	rm = cpu_to_le32(r->role_map);
+	rm = cpu_to_le32(r->role_map[RTW89_MAC_0]);
 	memcpy(&h2c->r.role_map, &rm, sizeof(h2c->r.role_map));
 	h2c->r.mrole_type = cpu_to_le32(r->mrole_type);
 	h2c->r.mrole_noa_duration = cpu_to_le32(r->mrole_noa_duration);
@@ -6978,18 +6978,95 @@ int rtw89_fw_h2c_cxdrv_role_v10(struct rtw89_dev *rtwdev, u8 type)
 		}
 	}
 
-	h2c->r.link_mode = r->link_mode;
-	h2c->r.link_mode_hb1 = r->link_mode_hb1;
-	h2c->r.p2p_exist = r->p2p_exist;
-	h2c->r.p2p_exist_hb1 = r->p2p_exist_hb1;
+	h2c->r.link_mode = r->link_mode[RTW89_MAC_0];
+	h2c->r.link_mode_hb1 = r->link_mode[RTW89_MAC_1];
+	h2c->r.p2p_exist = r->p2p_exist[RTW89_MAC_0];
+	h2c->r.p2p_exist_hb1 = r->p2p_exist[RTW89_MAC_1];
 
 	h2c->r.pta_req_band = r->pta_req_band;
 	h2c->r.dbcc_en = r->dbcc_en;
 	h2c->r.dbcc_2g_phy = r->dbcc_2g_phy;
 
-	rm = cpu_to_le32(r->role_map);
+	rm = cpu_to_le32(r->role_map[RTW89_MAC_0]);
 	memcpy(&h2c->r.role_map, &rm, sizeof(h2c->r.role_map));
-	rm = cpu_to_le32(r->role_map_hb1);
+	rm = cpu_to_le32(r->role_map[RTW89_MAC_1]);
+	memcpy(&h2c->r.role_map_hb1, &rm, sizeof(h2c->r.role_map_hb1));
+	h2c->r.mrole_type = cpu_to_le32(r->mrole_type);
+
+	rtw89_h2c_pkt_set_hdr(rtwdev, skb, FWCMD_TYPE_H2C,
+			      H2C_CAT_OUTSRC, BTFC_SET,
+			      SET_DRV_INFO, 0, 0,
+			      len);
+
+	ret = rtw89_h2c_tx(rtwdev, skb, false);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to send h2c\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+int rtw89_fw_h2c_cxdrv_role_v11(struct rtw89_dev *rtwdev, u8 type)
+{
+	struct rtw89_btc_wl_role_info *r = &rtwdev->btc.cx.wl.role_info;
+	struct rtw89_h2c_cxrole_v11 *h2c;
+	struct rtw89_btc_wl_rlink *rl;
+	u32 len = sizeof(*h2c);
+	struct sk_buff *skb;
+	__le32 rm;
+	int ret;
+	u8 i, j;
+
+	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
+	if (!skb) {
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxdrv_role\n");
+		return -ENOMEM;
+	}
+	skb_put(skb, len);
+	h2c = (struct rtw89_h2c_cxrole_v11 *)skb->data;
+
+	h2c->hdr.type = type;
+	h2c->hdr.ver = 11;
+	h2c->hdr.len = len - H2C_LEN_CXDRVHDR_V7;
+
+	for (j = RTW89_MAC_0; j <= RTW89_MAC_1; j++) {
+		for (i = 0; i < RTW89_BE_BTC_WL_MAX_ROLE_NUMBER; i++) {
+			rl = &r->rlink[i][j];
+			h2c->r.rlink[i][j].connected = rl->connected;
+			h2c->r.rlink[i][j].pid = rl->pid;
+			h2c->r.rlink[i][j].phy = rl->phy;
+			h2c->r.rlink[i][j].noa = rl->noa;
+
+			h2c->r.rlink[i][j].rf_band = rl->rf_band;
+			h2c->r.rlink[i][j].active = rl->active;
+			h2c->r.rlink[i][j].bw = rl->bw;
+			h2c->r.rlink[i][j].role = rl->role;
+
+			h2c->r.rlink[i][j].ch = rl->ch;
+			h2c->r.rlink[i][j].noa_dur = rl->noa_dur;
+			h2c->r.rlink[i][j].client_cnt = rl->client_cnt;
+			h2c->r.rlink[i][j].mode = rl->mode;
+			h2c->r.rlink[i][j].mac_id = rl->mac_id;
+		}
+	}
+
+	h2c->r.link_mode = r->link_mode[RTW89_MAC_0];
+	h2c->r.link_mode_hb1 = r->link_mode[RTW89_MAC_1];
+	h2c->r.p2p_exist = r->p2p_exist[RTW89_MAC_0];
+	h2c->r.p2p_exist_hb1 = r->p2p_exist[RTW89_MAC_1];
+
+	h2c->r.pta_req_band = r->pta_req_band;
+	h2c->r.dbcc_en = r->dbcc_en;
+	h2c->r.dbcc_2g_phy = r->dbcc_2g_phy;
+
+	rm = cpu_to_le32(r->role_map[RTW89_MAC_0]);
+	memcpy(&h2c->r.role_map, &rm, sizeof(h2c->r.role_map));
+	rm = cpu_to_le32(r->role_map[RTW89_MAC_1]);
 	memcpy(&h2c->r.role_map_hb1, &rm, sizeof(h2c->r.role_map_hb1));
 	h2c->r.mrole_type = cpu_to_le32(r->mrole_type);
 
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 9b616ec9323b..b0f1d51d67d9 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2507,6 +2507,11 @@ struct rtw89_h2c_cxrole_v10 {
 	struct rtw89_btc_wl_role_info_v10 r;
 } __packed;
 
+struct rtw89_h2c_cxrole_v11 {
+	struct rtw89_h2c_cxhdr_v7 hdr;
+	struct rtw89_btc_wl_role_info_v11 r;
+} __packed;
+
 struct rtw89_h2c_cxmlo_v2 {
 	struct rtw89_h2c_cxhdr_v7 hdr;
 	struct rtw89_btc_wl_mlo_info_v2 mlo;
@@ -5545,6 +5550,7 @@ int rtw89_fw_h2c_cxdrv_role_v2(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v7(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v8(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_role_v10(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxdrv_role_v11(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_init_v11(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_mlo_v2(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_osi_info(struct rtw89_dev *rtwdev, u8 type);
-- 
2.25.1

