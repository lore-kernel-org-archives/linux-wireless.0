Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0BC3AA9EF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085601; cv=none; b=ViiRYcZAAUbC6zPpcc09sHlf/pkNJfCZWJai3r1I5J7KGp6JobmyTkcivmANieBuK/GqEIOXjlEu/K0QlKr2YGfRh9crxvn+FUvE4AubeUlf1b8AxCsnmjFILNY2iQ9OE8ZN8mLgiai4XTCdQnGHg5ztkutKxPWFtFj1kdfCirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085601; c=relaxed/simple;
	bh=ixGGpW4muSaa0FCOvCuXS9eMS6mcTrtROF4iEerB6ws=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQsDhEt9lSGb7tuJpBYIB6fcxqutspYCVMxXTtHKy9ApwzIXXcIhjhqgitxx8HjzT/Epts+6XhR0lMVSKcaDXGMNGE0jj0lf/ri11MqzsD/5/wv3Oc6WGBXBJBHdex+r2zknHkxoNQdf2wgL6Bbeu8S0MeqYnUGqCtQrKfOZSu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BrqGIgto; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BrqGIgto"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kbXY3829338, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085597; bh=Z43Hsgmm/BXpsmNd6XaY6shPVqTPf7DJPLJYWOk/La0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=BrqGIgtoBQTilkszXbqB0L6dZ4qcVwZKUpfLAkxDojfkgnU3yQDIWA7Ezw9fPA87t
	 VS3lgXDF4jlvl/l1YPlQlcynS+B/W4e/ddmGVn44c1SkH64tIEPLONsQ+cbUlAfaGm
	 pKoUBR4hWX/MSPrH6eUbP4F3GIHMMhZ0P/3bMGLZCyTR/FJuu9fSsFzOtF/wVrm+q+
	 9rbLiqijE19AmBpXz5bTh+slJDLLBbyUPpPzvOcV+gNefb+RQ7g7hzkZp2t5KeLTXE
	 RMQuEQuks06uc66bMiG2l51iQQbQ/10LNarNxklg8w+dsHjKMXRp35oZOidFinPeme
	 hcjA5Ac4fS2Xg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kbXY3829338
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:37 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 06/15] wifi: rtw89: coex: add 1SS MIMO-PS decision for dual-BT CIS
Date: Sun, 4 Oct 2026 11:45:11 +0800
Message-ID: <20261004034520.33695-7-pkshih@realtek.com>
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

When a BT CIS (LE-audio) link exists on a dual-BT, shared-antenna
chip, limiting WL to 1SS on the RF-path that is isolated from that
link protects WL Rx from the CIS traffic without a full freerun
fallback. Add _set_trx_nss() to compute whether that 1SS limit
should apply, which path it should apply to, and what stream count
and path the WL TRX should fall back to when it does not, gated on
a chip-reported MIMO-PS capability flag and limited to Lenovo
designs or dual-BT chips to match the hardware this has been
validated on. The result also re-arms the limit once after a device
exits low-power state, since LPS can clear the BB/RF setup the
previous decision put in place.

The RTL8922D 3-antenna shared configuration also claimed that
capability, but it has no WL path shared with BT to power down, so
the limit there would cost a stream without buying any isolation.
Measurement on that configuration confirms it, so stop reporting
the capability for it and leave the 2-antenna configuration as the
only one that does.

There is currently no driver API to apply the computed stream/path
decision to the BB and RF, so the function stops right after
printing the decision for debug and before it would otherwise update
dm->wl_trx_nss, recompute the cross-talk maps, or call into set_rfe().
Those steps follow once that HW-apply API exists.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c     | 128 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/core.h     |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c |   1 -
 3 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 1d3ffde71c07..0b9858d1859a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -6993,6 +6993,133 @@ static void _set_fw_report_map(struct rtw89_dev *rtwdev)
 	rtw89_btc_fw_en_rpt(rtwdev, false, rpt_map);
 }
 
+static void _set_trx_nss(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_bind_bt_status *btdd = &dm->tdd_bind.bt_smap;
+	struct rtw89_btc_bind_bt_status *bfdd = &dm->fdd_bind.bt_smap;
+	struct rtw89_btc_wl_trx_nss_para *trx_nss = &dm->wl_trx_nss;
+	struct rtw89_btc_module *module = &btc->mdinfo;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	struct rtw89_btc_wl_info *wl = &cx->wl;
+	bool bt0_cis = cx->bt0.link_info.leaudio_desc.cis_exist;
+	bool bt1_cis = cx->bt1.link_info.leaudio_desc.cis_exist;
+	u8 tx_ss, rx_ss, tx_path, rx_path, limit_path;
+	u8 tx_limit = 0, rx_limit = 0;
+
+	/* tx/rx_limit: 1 = 1ss, 0 = HW default */
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s(): wl_rinfo->link_mode=%d, dm->wl_trx_nss_en=%d\n",
+		    __func__, wl->role_info.link_mode[RTW89_MAC_0], dm->wl_trx_nss_en);
+
+	/*
+	 * Skip 1SS MIMO-PS if:
+	 * - manual mode or DBCC enabled
+	 * - !wl_trx_nss_en: no MIMO-PS capability. The RFE configs that share
+	 *   a WL path with BT are selected in ops->set_rfe() (e.g. 8922D only
+	 *   sets it for ant.num=2), so this flag is the single gate here, no
+	 *   extra ant.num/bt1_sw_type check.
+	 * - non-LNV vendor and no DUAL_BT. Dual-BT chips run MIMO-PS for every
+	 *   vendor, single-BT chips only for LNV (LNV: PCIE-12223)
+	 */
+	if (btc->manual_ctrl || wl->role_info.dbcc_en || !dm->wl_trx_nss_en ||
+	    (dm->vid != RTW89_CUSTID_LENOVO &&
+	     !(rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT)))
+		return;
+
+	/*
+	 * Disable 1SS limit when:
+	 * - No WiFi link (WL idle state)
+	 * - Out-of-band scenario (no BT coex needed)
+	 */
+	if (wl->role_info.link_mode[RTW89_MAC_0] == BTC_WLINK_NOLINK ||
+	    wl->role_info.link_mode[RTW89_MAC_1] == BTC_WLINK_NOLINK ||
+	    dm->out_of_band) {
+		tx_limit = 0;
+		rx_limit = 0;
+	} else if (bt0_cis || bt1_cis || btdd->cis_exist || bfdd->cis_exist) {
+		/*
+		 * Enable 2T1R when BT CIS profile exists (low latency audio).
+		 * tx_limit=1 (1T1R full isolation) reserved for future use
+		 * when WL needs to fully isolate Tx from BT on shared antenna.
+		 */
+		tx_limit = 0;
+		rx_limit = 1;
+	}
+
+	/*
+	 * BT1 at S0 has CIS -> WL must use S1 (path B)
+	 * BT0 at S1 has CIS -> WL must use S0 (path A)
+	 */
+	limit_path = bt1_cis ? RF_PATH_B : RF_PATH_A;
+
+	/*
+	 * Re-arm the exit-LPS one-shot once the event is over. lps_exiting is
+	 * held for a while by the LPS-exit timer, so it must not be used as
+	 * the force-exec condition directly.
+	 */
+	if (!wl->status.map.lps_exiting)
+		dm->trx_nss_lps_done = 0;
+
+	if (trx_nss->rx_limit == rx_limit && trx_nss->tx_limit == tx_limit &&
+	    (!rx_limit || trx_nss->rx_path == limit_path)) {
+		/*
+		 * WL just exited LPS: LPS may have cleared the BB/RF 1SS
+		 * setup, so re-issue cfg_1ss/cfg_trx_path/set_rfe once per
+		 * exit-LPS event. They are heavy (set_rfe() re-reads efuse and
+		 * does several RF I/O), so a one-shot flag instead of lps_exiting.
+		 */
+		if (wl->status.map.lps_exiting && !dm->trx_nss_lps_done)
+			goto force_exec;
+
+		return;
+	}
+
+force_exec:
+	/* one-shot consumed, no re-exec until the next exit-LPS event */
+	dm->trx_nss_lps_done = wl->status.map.lps_exiting;
+
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s(): stream_cnt=0x%02x, path_pos=0x%02x\n",
+		    __func__, module->ant.stream_cnt, module->ant.path_pos);
+
+	/*
+	 * Reduce TX to 1SS on the isolated path to avoid BT interference,
+	 * else restore TX to HW default stream count and path.
+	 */
+	if (tx_limit) {
+		tx_ss = 1;
+		tx_path = limit_path;
+	} else {
+		tx_ss = FIELD_GET(BTC_ANT_TX_MASK, module->ant.stream_cnt);
+		tx_path = FIELD_GET(BTC_ANT_TX_MASK, module->ant.path_pos);
+	}
+
+	/*
+	 * Reduce RX to 1SS on the isolated path to protect WL Rx stream,
+	 * else restore RX to HW default stream count and path.
+	 */
+	if (rx_limit) {
+		rx_ss = 1;
+		rx_path = limit_path;
+	} else {
+		rx_ss = FIELD_GET(BTC_ANT_RX_MASK, module->ant.stream_cnt);
+		rx_path = FIELD_GET(BTC_ANT_RX_MASK, module->ant.path_pos);
+	}
+
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], %s(): tx_ss=%d, rx_ss=%d, tx_path=%d, rx_path=%d\n",
+		    __func__, tx_ss, rx_ss, tx_path, rx_path);
+
+	/*
+	 * TODO: no driver API to apply tx_limit/rx_limit/tx_ss/rx_ss/tx_path/
+	 * rx_path to the BB/RF 1SS MIMO-PS HW state yet. Stop here so
+	 * trx_nss/always_freerun/ant.type/set_rfe()/_update_sdm_map() below
+	 * never run from a decision that was never applied to HW.
+	 */
+}
+
 static void _action_common(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -7002,6 +7129,7 @@ static void _action_common(struct rtw89_dev *rtwdev)
 	u8 i;
 
 	_wl_req_mac(rtwdev, rinfo->pta_req_band);
+	_set_trx_nss(rtwdev);
 	_update_zb_coex_tbl(rtwdev);
 	_set_btg_ctrl(rtwdev);
 	_set_wl_preagc_ctrl(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 340633c42c9f..624b8d1b4742 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4188,6 +4188,7 @@ struct rtw89_btc_dm {
 	u8 vid;
 	u8 client_ps_tdma_on;
 	u8 wl_trx_nss_en;
+	u8 trx_nss_lps_done; /* 1SS re-setup done for this exit-LPS */
 
 	u8 wl_pre_agc: 2;
 	u8 wl_lna2: 1;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 41e2aa1c8f78..7ac15a5d949a 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -3336,7 +3336,6 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 			md->bt0_pos = BTC_BT_BTG;
 			md->bt0_sw_type = BTC_SWITCH_V1_INTERNAL;
 			dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
-			dm->wl_trx_nss_en = 1; /* 1ss MIMO-PS capability */
 		} else {
 			md->ant.func[0] = BTC_EFMAP_NONE;
 			md->ant.func[1] = BTC_EFMAP_NONE;
-- 
2.25.1

