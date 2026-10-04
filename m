Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998033E7145
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085596; cv=none; b=B1NCtNTJls+LkPd6PtUzbXA1kPCM1VbklSlJnsH+DtnNT6iiRTU5qM+wAOZr+FfGHZQBhr0cjN+PwzMNKhV7yKY86dKI9fDf0eAnVTKRzWwhDCf0TjHJooA5U9O6xlBoVPlx0KAujVNcoNRVDs71RNKZyv83vRlu4Zy0ck4MLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085596; c=relaxed/simple;
	bh=6Qtw3fpMlWRfWbBH78vzqGZt8/RgtZXdSPmmdTxYJsM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5XmuTxIMa5nhjLjIghgPZ3Jd7h5Ah18yMm7UvAs0HaYWFSPNhuKw8pawAWj7TQh0kktnkmwMWA+9+TjkAo/spMIuyfHUUbb+Z+TQbEbZImaraBsmLYN+odM1CgduTxO2CTT8RDETq3p8XhkTrQaSQbWd37zUdvh5SYbTrKATFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DHrZZTIJ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DHrZZTIJ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kVVH1829320, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085592; bh=tN4oJ415l/oGrOOd/QcSv8G1HLlZiDraby2YvXFXnaI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=DHrZZTIJY60YgFsuDavQ2uhcdk/Hkx7fkmQ5fKnaoxPe/YnM9/2W8juo5I54oEfmy
	 9e5Flm/9AwqfaQnuCppw7JErmIjR1oPGHBNVzvAvwfeClWZ0gQb9i4NkHSZ+pAhF0Y
	 EG2eCNRL7W+AT6cMtjXePj/KqT9I4AQd14ANmJGLjkjSaKxsr8XBtXWsWd3VAvBI+S
	 myTE3ILyl4OwHoYpWpr8rLGBbwhC5RdwaVN2hn2iOvF2lr9Sf/vDwN47FX6sx4Stb1
	 sVMkQP7FPX8hSUIJDpmP56VqN1LMl10mM3pt97IGH0/1if8m06WpvmYaHSCBTVstv1
	 90ysisdTgY0Lw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kVVH1829320
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 05/15] wifi: rtw89: coex: compute WL/BT cross-talk interference maps
Date: Sun, 4 Oct 2026 11:45:10 +0800
Message-ID: <20261004034520.33695-6-pkshih@realtek.com>
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

The TDD/FDD binding logic consumed dm->sit_xmap and dm->xtk_xmap to
decide whether a WL RF-path and a BT device need TDD or FDD
coexistence, but nothing in the driver ever wrote those two maps, so
they stayed all-zero and the binding logic silently fell back to
whatever that implied. Add _update_wl_rssi_status() to track the
minimum WL RSSI across all connected roles and HW-bands and turn it
into a per-BT interference state by comparing it against each BT's
Tx power minus antenna isolation, and _update_sdm_map() to turn that
state plus the existing antenna-sharing map into the cross-talk and
space-interaction maps the binding logic expects.

Call _update_wl_rssi_status() from the per-station notify path where
RSSI is refreshed, and recompute the maps whenever it reports a
change or whenever the BT scoreboard flips the dedicated TRX-active
bit that forces TDD regardless of RSSI. _update_sdm_map() also runs
once during coex init so the maps are populated before the first
coex cycle, and _set_coex_binding() now derives dm->fit_used_path and
a per-path dm->fit_map alongside the existing fit_xmap use, which a
later change will need once it introduces 1SS Rx-path limiting.

Whether the WL path under a 1SS RX limit still co-receives with a BT
device also depends on traffic direction: the limit only confines
RX, so the cross-talk map that feeds the TDD/FDD binding is derived
differently for downlink than for uplink. Also recompute the maps
when the per-station notify path latches a traffic direction flip,
so a downlink-to-uplink switch with a steady RSSI does not leave the
binding running on the previous direction's map until some later
event happens to refresh it.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 289 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/core.h |   4 +
 2 files changed, 283 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index fbd1a6b33cb6..1d3ffde71c07 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -527,6 +527,7 @@ enum btc_b2w_scoreboard {
 	BTC_BSCB_BT_LNAB0_56G = BIT(18),
 	BTC_BSCB_BT_LNAB1_56G = BIT(19),
 	BTC_BSCB_BT_BACKOFF_LNA = BIT(21),
+	BTC_BSCB_BT_15DOT4_TRX = BIT(22),
 	BTC_BSCB_HID_ACT = BIT(23),
 	BTC_BSCB_BT_15DOT4 = BIT(24),
 	BTC_BSCB_BT_PROTECT = BIT(27),
@@ -1013,6 +1014,7 @@ static void _run_coex(struct rtw89_dev *rtwdev,
 static void _write_scbd(struct rtw89_dev *rtwdev, u8 bid, u32 val, bool state);
 static u8 _sned_h2c_w2bscbd(struct rtw89_dev *rtwdev, bool force_exec, u8 bid);
 static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid, bool is_c2h);
+static void _update_sdm_map(struct rtw89_dev *rtwdev);
 static const char *id_to_h2c(u32 id);
 
 static void _reset_h2c_macro(struct rtw89_btc *btc)
@@ -8202,6 +8204,10 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid, bool is_c2h)
 				    !!(val & BTC_BSCB_BT_LNAB1) * 2;
 
 		if (rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT) {
+			if ((val & BTC_BSCB_BT_15DOT4_TRX) !=
+			    (bt->scbd & BTC_BSCB_BT_15DOT4_TRX))
+				_update_sdm_map(rtwdev);
+
 			if (val & BTC_BSCB_BT_15DOT4)
 				bt->func_type |= (BTC_BTF_THREAD | BTC_BTF_ZB);
 			else
@@ -8597,9 +8603,142 @@ static void _set_bind_info(struct rtw89_btc *btc, u8 type)
 		bd->bt_smap.ull_exist = 1;
 }
 
+/*
+ * Get the only WL RF-path that still receives under 1SS MIMO-PS.
+ *
+ * Single source of truth for "is WL Rx confined to one RF-path, and which
+ * one". Both _update_sdm_map() (xtk_xmap) and _set_coex_binding() (fit_map)
+ * must agree, otherwise the two maps describe different WL Rx topologies.
+ *
+ * Conditions:
+ * - rx_limit: the BB/RF was actually programmed to 1SS by _set_trx_nss()
+ * - DL only: rx_limit shrinks the Rx stream, WL Tx still runs 2SS/2TX on both
+ *   paths for UL, so every path stays BT-interactive there
+ * - 2+0/0+2 only: both RF-path serve the same link on one HW-band, so there
+ *   is an unused path. In 1+1/2+2 each RF-path serves its own link on its own
+ *   HW-band and none of them can be dropped
+ *
+ * Return dm->wl_trx_nss.rx_path (RF_PATH_A/B, == BTC_RF_S0/S1) if 1SS
+ * MIMO-PS is active, RF_PATH_AB if WL keeps both Rx paths.
+ */
+static u8 _get_sdm_1ss_path(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc_wl_trx_nss_para *trx_nss = &rtwdev->btc.dm.wl_trx_nss;
+	struct rtw89_btc_wl_info *wl = &rtwdev->btc.cx.wl;
+
+	if (!trx_nss->rx_limit ||
+	    !(wl->status.map.traffic_dir & BIT(RTW89_TFC_DL)))
+		return RF_PATH_AB;
+
+	if (wl->mlo_info.rf_combination != BTC_MLO_RF_2_PLUS_0 &&
+	    wl->mlo_info.rf_combination != BTC_MLO_RF_0_PLUS_2)
+		return RF_PATH_AB;
+
+	/*
+	 * rx_path is what _set_trx_nss() passed to cfg_trx_path(), it must be
+	 * a single path to be used as an RF-path index below
+	 */
+	if (trx_nss->rx_path != RF_PATH_A && trx_nss->rx_path != RF_PATH_B)
+		return RF_PATH_AB;
+
+	return trx_nss->rx_path;
+}
+
+static void _update_sdm_map(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_module *module = &btc->mdinfo;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	struct rtw89_btc_bt_info *bt0 = &cx->bt0;
+	struct rtw89_btc_bt_info *bt1 = &cx->bt1;
+	struct rtw89_btc_wl_info *wl = &cx->wl;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	u8 map[BTC_RF_NUM][BTC_ALL_BT_EZL];
+	bool mlo_1_plus_1 = false;
+	u8 used_path;
+	u8 i, j;
+
+	/*
+	 * xtk_xmap(Cross-talk map)-> 1: interaction, 0: no-interaction
+	 * calculate WL/BT interference by SIR
+	 * ==>1:If WL_RSSI < (BT-Pin -SIR), it means BT-Tx interfer with WL-Rx
+	 * ==>BT-pin = BT-Tx-Power - Ant-isolation
+	 */
+	if (wl->mlo_info.wtype != RTW89_MR_WTYPE_MLD2L1R_NONMLD &&
+	    (wl->mlo_info.rf_combination == BTC_MLO_RF_1_PLUS_1 ||
+	     wl->mlo_info.rf_combination == BTC_MLO_RF_2_PLUS_2))
+		mlo_1_plus_1 = true;
+
+	/*
+	 * WL running 1SS MIMO-PS (CIS LE-audio): WL Rx is confined to a single
+	 * path. The used path co-Rx with its co-ant BT (=1) or follows RSSI vs.
+	 * the other BT; the unused path no longer co-Rx with any BT (=0).
+	 * RF_PATH_AB -> not 1SS, keep the original per-path logic.
+	 *
+	 * Record it: this function also runs at the _set_trx_nss() exit, after
+	 * rx_limit/rx_path changed, so dm->fit_used_path stays the up-to-date
+	 * 1SS state for the _action_common() consumers that run later in the
+	 * same coex cycle (_set_wl_preagc_ctrl, _set_bt_corx_table).
+	 */
+	used_path = _get_sdm_1ss_path(rtwdev);
+	dm->fit_used_path = used_path;
+
+	memset(map, 0, sizeof(map));
+	for (i = 0; i < BTC_RF_NUM; i++) {
+		if (module->ant.num == 1 && i == BTC_RF_S1)
+			break;
+
+		for (j = 0; j < BTC_ALL_BT_EZL; j++) {
+			if ((bt0->scbd_c2h & BTC_BSCB_BT_15DOT4_TRX) ||
+			    (bt1->scbd_c2h & BTC_BSCB_BT_15DOT4_TRX)) {
+				/* 15.4 TRX active: force BT0/BT1 to TDD */
+				if (j < BTC_ALL_BT)
+					dm->xtk_xmap[i][j] = 1;
+				else
+					continue; /* j == EXT: not force TDD */
+			} else if (used_path != RF_PATH_AB && j < BTC_ALL_BT) {
+				/* 1SS MIMO-PS: only the used WL path co-Rx */
+				if (i != used_path)
+					dm->xtk_xmap[i][j] = 0;
+				else if (dm->ant_xmap[i][j] == 1)
+					dm->xtk_xmap[i][j] = 1;
+				else
+					dm->xtk_xmap[i][j] =
+						BTC_RSSI_LOW(dm->sir_state[j]) ? 1 : 0;
+			} else if (dm->ant_xmap[i][j] == 1) {
+				/* if WL RF-pathx co-ant with BTx */
+				dm->xtk_xmap[i][j] = 1;
+			} else if (((j == BTC_BT_1ST &&
+				     module->bt0_sw_type != BTC_SWITCH_V1_NONE) ||
+				    (j == BTC_BT_2ND &&
+				     module->bt1_sw_type != BTC_SWITCH_V1_NONE)) &&
+				   !mlo_1_plus_1) {
+				/*
+				 * if WL RF-pathx not co-ant/path with BTx
+				 * but BTx co-ant/path with the other WL-path
+				 * and WL is 2+0/0+2
+				 * ex: WL-S0 + (WL-S1 & BT0-S1) ->
+				 * BT0-S1 vs. WL-S0 = 1
+				 */
+				dm->xtk_xmap[i][j] = 1;
+			} else if (BTC_RSSI_LOW(dm->sir_state[j])) {
+				/* if WL_RSSI below BT-Tx interference thres */
+				dm->xtk_xmap[i][j] = 1;
+			} else {
+				dm->xtk_xmap[i][j] = 0;
+			}
+
+			map[i][j] = dm->ant_xmap[i][j] | dm->xtk_xmap[i][j];
+		}
+	}
+
+	memcpy(dm->sit_xmap, map, sizeof(map));
+}
+
 #define _bind_is_btonly 0x7
-static void _set_coex_binding(struct rtw89_btc *btc)
+static void _set_coex_binding(struct rtw89_dev *rtwdev)
 {
+	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_cx *cx = &btc->cx;
 	struct rtw89_btc_extsoc_info *bt2 =  &cx->bt_ext;
 	struct rtw89_btc_bt_info *bt0 = &cx->bt0;
@@ -8608,7 +8747,7 @@ static void _set_coex_binding(struct rtw89_btc *btc)
 	struct rtw89_btc_dm *dm = &btc->dm;
 	u8 path_hwb[BTC_RF_NUM] = {RTW89_PHY_0, RTW89_PHY_1};
 	u8 wl_rf_band[RTW89_BAND_NUM] = {};
-	u8 i, j, val = 0;
+	u8 i, j, val = 0, fit, used_path;
 
 	/*
 	 * sit_xmap(Space-Interaction) = ant_xmap | xtk_xmap
@@ -8657,21 +8796,49 @@ static void _set_coex_binding(struct rtw89_btc *btc)
 			path_hwb[BTC_RF_S0] = RTW89_PHY_1; /* 2+0 RF-S0/1->HWB1 */
 	}
 
+	/*
+	 * WL 1SS MIMO-PS: WL Rx is confined to a single path, so the unused
+	 * path has no WL-Rx frequency interference with any BT.
+	 * RF_PATH_AB -> not 1SS, both paths keep their real fit_xmap.
+	 * Same helper as _update_sdm_map(), so xtk_xmap and fit_map always
+	 * agree on which RF-path is the unused one.
+	 * e.g. CIS@BT_2ND -> rx_path=RF_PATH_B, used_path=S1:
+	 *      RF-S1 keeps its real fit_xmap, RF-S0 is cleared.
+	 */
+	used_path = _get_sdm_1ss_path(rtwdev);
+	dm->fit_used_path = used_path; /* record for dbg cmd "xmap" */
+
 	/*
 	 * tdd_map = sit_xmap * fdm_map, 1: WL-RF-Sx vs. BTx take TDD-Action
 	 * fdd_map =(!sit_xmap) * fdm_map, 1: WL-RF-Sx vs.BTx take FDD-Action
 	 * co-rx map = ant_xmap * fdm_map 1:WL/BT co-rx (for halbb-btg-ctrl)
 	 * sit_xmap,ant_xmap = 0 or 1, so tdd/fdd use multiplication (*)
+	 *
+	 * fit: WL-BT freq-interact(2bit band-map) of RF-Sx vs. BTx,
+	 * = fit_xmap[HWB][BTx], the used_path keeps this real band-map,
+	 * the unused path is cleared to 0 if 1SS MIMO-PS.
 	 */
 
 	for (i = 0; i < BTC_RF_NUM; i++)
 		for (j = 0; j < BTC_ALL_BT_EZL; j++) {
-			dm->tdd_map[i][j] = dm->sit_xmap[i][j] *
-					    dm->fit_xmap[path_hwb[i]][j];
-			dm->fdd_map[i][j] = !dm->sit_xmap[i][j] *
-					     dm->fit_xmap[path_hwb[i]][j];
-			dm->corx_map[i][j] = dm->ant_xmap[i][j] *
-					     dm->fit_xmap[path_hwb[i]][j];
+			fit = dm->fit_xmap[path_hwb[i]][j];
+
+			/*
+			 * 1SS MIMO-PS: no WL-Rx on the unused path.
+			 * Only the local fit is dropped, dm->fit_xmap keeps
+			 * the real per-HW-band map: it is indexed by HW-band,
+			 * and both RF-path may map to the same HW-band, so
+			 * clearing it there would also drop used_path's entry
+			 * (and the other MLO link's entry in DB_MCC).
+			 */
+			if (used_path != RF_PATH_AB && i != used_path)
+				fit = 0;
+
+			dm->fit_map[i][j] = fit; /* for dbg cmd "xmap" */
+
+			dm->tdd_map[i][j] = dm->sit_xmap[i][j] * fit;
+			dm->fdd_map[i][j] = !dm->sit_xmap[i][j] * fit;
+			dm->corx_map[i][j] = dm->ant_xmap[i][j] * fit;
 	}
 
 	/* TDD-Binding */
@@ -8794,7 +8961,7 @@ void _run_coex(struct rtw89_dev *rtwdev, enum btc_reason_and_action reason)
 	dm->fddt_train = BTC_FDDT_DISABLE;
 	bt->scan_rx_low_pri = false;
 
-	_set_coex_binding(btc);
+	_set_coex_binding(rtwdev);
 	_update_btc_state_map(rtwdev);
 
 	dm->freerun_chk = _check_freerun(rtwdev); /* check if meet freerun */
@@ -9031,6 +9198,8 @@ static void _set_init_info(struct rtw89_dev *rtwdev)
 	btc_fw_set_monreg(rtwdev);
 	_set_ext_interface(rtwdev);
 	_set_wl_tx_power(rtwdev, RTW89_BTC_WL_DEF_TX_PWR, RTW89_PHY_0);
+
+	_update_sdm_map(rtwdev);
 }
 
 void rtw89_btc_ntfy_init(struct rtw89_dev *rtwdev, u8 mode)
@@ -9970,6 +10139,96 @@ static void rtw89_btc_ntfy_wl_sta_iter(void *data, struct ieee80211_sta *sta)
 
 #define BTC_NHM_CHK_INTVL 20
 
+static bool _update_wl_rssi_status(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	struct rtw89_btc_wl_info *wl = &cx->wl;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_bt_link_info *b;
+	u8 i, j, ant_iso, th, rssi, nxt, bt_enable;
+	u8 wl_rf_band = RTW89_BAND_2G, cnt = 0;
+	bool status_change = false;
+	s8 bt_pin;
+	s32 val;
+
+	/* Update WL RSSI (search the min value between all role/HW-band) */
+	rssi = 110; /* unit: % */
+	for (i = 0; i < RTW89_BE_BTC_WL_MAX_ROLE_NUMBER; i++) {
+		for (j = 0; j < RTW89_MAC_NUM; j++) {
+			if (!wl->rlink_info[i][j].active ||
+			    wl->rlink_info[i][j].connected == MLME_NO_LINK)
+				continue;
+
+			if (wl->rlink_info[i][j].stat.rssi < rssi) { /* find min */
+				rssi = wl->rlink_info[i][j].stat.rssi;
+				wl_rf_band = wl->rlink_info[i][j].band;
+				cnt++;
+			}
+		}
+	}
+
+	if (cnt == 0) /* no wifi link exist */
+		wl->rssi = 0;
+	else
+		wl->rssi = rssi;
+
+	/* SIR state: compare WL_RSSI with each BT-Tx interference */
+	for (i = BTC_BT_1ST; i <= BTC_BT_EXT; i++) {
+		switch (i) {
+		case BTC_BT_1ST:
+		default:
+			bt_enable = cx->bt0.enable.now;
+			ant_iso = cx->bt0.ant_iso_to_wl;
+			if (wl_rf_band != RTW89_BAND_2G) /* find same rf-band */
+				b = &cx->bt0.link_info_56g;
+			else
+				b = &cx->bt0.link_info;
+			if (b->bt_txpwr_desc.le_dbm > b->bt_txpwr_desc.br_dbm)
+				bt_pin = b->bt_txpwr_desc.le_dbm;
+			else
+				bt_pin = b->bt_txpwr_desc.br_dbm;
+			break;
+		case BTC_BT_2ND:
+			bt_enable = cx->bt1.enable.now;
+			ant_iso = cx->bt1.ant_iso_to_wl;
+			if (wl_rf_band != RTW89_BAND_2G) /* find same rf-band */
+				b = &cx->bt0.link_info_56g;
+			else
+				b = &cx->bt0.link_info;
+			if (b->bt_txpwr_desc.le_dbm > b->bt_txpwr_desc.br_dbm)
+				bt_pin = b->bt_txpwr_desc.le_dbm;
+			else
+				bt_pin = b->bt_txpwr_desc.br_dbm;
+			break;
+		case BTC_BT_EXT:
+			bt_enable = !!cx->bt_ext.func_type;
+			ant_iso = cx->bt_ext.ant_iso_to_wl;
+			bt_pin = cx->bt_ext.max_tx_pwr;
+			break;
+		}
+
+		val = 110 + bt_pin - ant_iso - dm->sir_thres;
+		if (!bt_enable || val <= 0)
+			th = 0;
+		else if (val >= 110)
+			th = 110;
+		else
+			th = (u8)val;
+
+		dm->tdd_rssi_thres = th;
+
+		nxt = _update_rssi_state(rtwdev, dm->sir_state[i], wl->rssi, th);
+
+		if (nxt != dm->sir_state[i]) {
+			dm->sir_state[i] = nxt;
+			status_change = true;
+		}
+	}
+
+	return status_change;
+}
+
 void rtw89_btc_ntfy_wl_sta(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -9995,6 +10254,9 @@ void rtw89_btc_ntfy_wl_sta(struct rtw89_dev *rtwdev)
 	if (dm->trx_info.wl_rssi != wl->rssi_level)
 		dm->trx_info.wl_rssi = wl->rssi_level;
 
+	if (_update_wl_rssi_status(rtwdev))
+		_update_sdm_map(rtwdev);
+
 	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], %s(): busy=%d\n",
 		    __func__, !!wl->status.map.busy);
 
@@ -10004,7 +10266,14 @@ void rtw89_btc_ntfy_wl_sta(struct rtw89_dev *rtwdev)
 		_fw_set_drv_info(rtwdev, CXDRVINFO_ROLE);
 	if (data.is_sta_change) {
 		wl->status.map.busy = data.busy_all;
-		wl->status.map.traffic_dir = data.dir_all;
+		if (wl->status.map.traffic_dir != data.dir_all) {
+			wl->status.map.traffic_dir = data.dir_all;
+			/*
+			 * traffic_dir (UL/DL) switch changes the 1SS MIMO-PS
+			 * xtk_xmap, recompute sit_xmap in the same coex cycle
+			 */
+			_update_sdm_map(rtwdev);
+		}
 		_run_coex(rtwdev, BTC_RSN_NTFY_WL_STA);
 	} else if (btc->dm.cnt_notify[BTC_NCNT_WL_STA] >=
 		   btc->dm.cnt_dm[BTC_DCNT_WL_STA_LAST] + BTC_NHM_CHK_INTVL) {
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 30c5822d63b8..340633c42c9f 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2403,6 +2403,7 @@ struct rtw89_btc_wl_info {
 
 	u8 port_id[RTW89_WIFI_ROLE_MLME_MAX];
 	u8 rssi_level;
+	u8 rssi; /* min WL RSSI among all active role/HW-band, 0~110% */
 	u8 cn_report;
 	u8 coex_mode;
 	u8 pta_req_mac;
@@ -4144,6 +4145,9 @@ struct rtw89_btc_dm {
 	u8 tdd_map[BTC_RF_NUM][BTC_ALL_BT_EZL];  /* WL-BT tdd-map */
 	u8 fdd_map[BTC_RF_NUM][BTC_ALL_BT_EZL];  /* WL-BT fdd-map */
 	u8 corx_map[BTC_RF_NUM][BTC_ALL_BT_EZL]; /* WL-BT Co-Rx */
+	/* RF-Sx view of fit_xmap, 1SS MIMO-PS applied */
+	u8 fit_map[BTC_RF_NUM][BTC_ALL_BT_EZL];
+	u8 fit_used_path; /* 1SS MIMO-PS Rx path, RF_PATH_AB if no limit */
 
 	u8 sit_xmap_last[BTC_RF_NUM][BTC_ALL_BT_EZL];
 	u8 fit_xmap_last[RTW89_PHY_NUM][BTC_ALL_BT_EZL];
-- 
2.25.1

