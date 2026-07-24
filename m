Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD992E06D2
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901452; cv=none; b=afCyh9X2eSvUFhhgR5UzpQq8fttKrDvOLAMFKRpcD5TbvniWkrV03YTNGPIVlVK2bM+rlhTCwTm9UIdeHauxoBtTvPGrJ8dBMThgAYCUTFAj8h8IpbpxAXRpM7ChGqXUNR48iPW810W0jkZvQsWwdapQ1RNgl91tOTEQM9NtrEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901452; c=relaxed/simple;
	bh=WoJ6xJdUHjiJzYW8IlCxM+PWJZxG5Kxj+dL8w7snhFg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qql+AcNniBhpkUY18I8CY7Oz1K1cSyKSyIL3s9Dt4QVrseNMhvLKIcOxbkSV3dEHuRhtNKqcxdE4gJsuo/FhcRMvtmnofWYJgYG8Ozy2mfbC9C0p4ZCQe1iYw7pzBoihHvPOV6p1PtjjSn1EceCU5GVD0YTMCW0hYl7g+arz/6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SebH9Nfx; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SebH9Nfx"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvSi951179773, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901448; bh=1aNYcfmyzNmJ/qWfx0BfqU/CbJox5RfvMACVTb+fJO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=SebH9Nfx/UnFlt6MQgQonDy/RnynokC/Dn+N6FtBNtjb89QXxP6RkSE9pHslf4V7B
	 TuZPBL0AqPQUixr37ba3tv+dBuQzuUBOeSgg+DAY9Kcg0pPtFbA6J4SY9XEXThD6oT
	 DdjN+Y9xgeR+y0KMYcq1h2xeh8CpUY4trWS1ruLRiXdfjGEgmqSmDj9HVuHyor4j4N
	 o020Cfv1cdEL4+vSTp4m2yqp9HbW6mkm0+mu5ndfHKn9WSICiF/P8kD5Ni+OdpffkH
	 YVyfnrh4vo9LAj6wRZb0RkfHL62hq2kvaXuya8q0KDlfnJNnychU8MV3IGo8qc2svm
	 0HD3QAO2jrNSw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvSi951179773
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:28 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:27 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:27 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 09/14] wifi: rtw89: coex: Fix log dump format with proper newline
Date: Fri, 24 Jul 2026 21:56:35 +0800
Message-ID: <20260724135640.3195044-10-pkshih@realtek.com>
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

Fix the log output format in _show_mreg_v7() where the phy-0 gnt_status
line was missing the proper field label and newline. Use the standard
" %-15s : " format with "[gnt_status]" label consistent with the rest
of the dump output.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 167 ++++++++++++----------
 1 file changed, 88 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 187e7e70e86d..5aa06ef430c8 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -9656,8 +9656,10 @@ static int _show_wl_role_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 				       plink->client_cnt - 1, plink->mode,
 				       plink->ch, plink->bw);
 
-			if (plink->connected == MLME_NO_LINK)
+			if (plink->connected == MLME_NO_LINK) {
+				p += scnprintf(p, end - p, "\n");
 				continue;
+			}
 
 			p += scnprintf(p, end - p,
 				       ", mac_id=%d, max_tx_time=%dus, max_tx_retry=%d\n",
@@ -9747,7 +9749,7 @@ static int _show_bt_profile_info(struct rtw89_dev *rtwdev, char *buf, size_t buf
 
 	if (hid.exist) {
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : type:%s%s%s%s%s pair-cnt:%d, sut_pwr:%d, golden-rx:%d\n",
+			       "\n %-15s : type:%s%s%s%s%s pair-cnt:%d, sut_pwr:%d, golden-rx:%d\n",
 			       "[HID]",
 			       hid.type & BTC_HID_218 ? "2/18," : "",
 			       hid.type & BTC_HID_418 ? "4/18," : "",
@@ -10345,7 +10347,7 @@ static int _show_dm_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 			"" : "(Mismatch!!)"));
 
 	p += scnprintf(p, end - p,
-		       " %-15s : wl[rssi_lvl:%d/para:%d/tx_pwr:[%d %d]/rx_lvl:[%d %d]/lna2:%d/stb_chg:%d]\n ",
+		       " %-15s : wl[rssi_lvl:%d/para:%d/tx_pwr:[%d %d]/rx_lvl:[%d %d]/lna2:%d/stb_chg:%d]\n",
 		       "[dm_rf_ctrl]",
 		       wl->rssi_level, dm->trx_para_level,
 		       dm->rf_trx_para.wl_tx_power[RTW89_PHY_0],
@@ -10355,7 +10357,7 @@ static int _show_dm_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       dm->wl_lna2, dm->wl_stb_chg);
 
 	p += scnprintf(p, end - p,
-		       " %-15s : pre_agc:%d, btg_rx:%d\n ",
+		       " %-15s : pre_agc:%d, btg_rx:%d\n",
 		       "[dm_bb_ctrl]", dm->wl_pre_agc, dm->wl_btg_rx);
 
 	p += scnprintf(p, end - p,
@@ -10467,11 +10469,9 @@ static int _show_fbtc_tdma(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       t->bind, t->leak_n, t->ext_ctrl);
 
 	p += scnprintf(p, end - p,
-		       "policy_type:%d",
+		       "policy_type:%d\n",
 		       (u32)btc->policy_type);
 
-	p += scnprintf(p, end - p, "\n");
-
 	return p - buf;
 }
 
@@ -10778,11 +10778,9 @@ static int _show_fbtc_cysta_v3(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 			       le16_to_cpu(pcysta->a2dp_ept.cnt),
 			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout));
 
-		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d",
+		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d\n",
 			       le16_to_cpu(pcysta->a2dp_ept.tavg),
 			       le16_to_cpu(pcysta->a2dp_ept.tmax));
-
-		p += scnprintf(p, end - p, "\n");
 	}
 
 out:
@@ -10917,11 +10915,9 @@ static int _show_fbtc_cysta_v4(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 			       le16_to_cpu(pcysta->a2dp_ept.cnt),
 			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout));
 
-		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d",
+		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d\n",
 			       le16_to_cpu(pcysta->a2dp_ept.tavg),
 			       le16_to_cpu(pcysta->a2dp_ept.tmax));
-
-		p += scnprintf(p, end - p, "\n");
 	}
 
 out:
@@ -11055,11 +11051,9 @@ static int _show_fbtc_cysta_v5(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 			       le16_to_cpu(pcysta->a2dp_ept.cnt),
 			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout));
 
-		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d",
+		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d\n",
 			       le16_to_cpu(pcysta->a2dp_ept.tavg),
 			       le16_to_cpu(pcysta->a2dp_ept.tmax));
-
-		p += scnprintf(p, end - p, "\n");
 	}
 
 out:
@@ -11193,11 +11187,9 @@ static int _show_fbtc_cysta_v105(struct rtw89_dev *rtwdev, char *buf, size_t buf
 			       le16_to_cpu(pcysta->a2dp_ept.cnt),
 			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout));
 
-		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d",
+		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d\n",
 			       le16_to_cpu(pcysta->a2dp_ept.tavg),
 			       le16_to_cpu(pcysta->a2dp_ept.tmax));
-
-		p += scnprintf(p, end - p, "\n");
 	}
 
 out:
@@ -11246,7 +11238,7 @@ static int _show_fbtc_cysta_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 			       le16_to_cpu(pcysta->skip_cnt));
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : avg_t[wl:%d/bt:%d/lk:%d.%03d]",
+		       "\n %-15s : avg_t[wl:%d/bt:%d/lk:%d.%03d]",
 		       "[cycle_stat]",
 		       le16_to_cpu(pcysta->cycle_time.tavg[CXT_WL]),
 		       le16_to_cpu(pcysta->cycle_time.tavg[CXT_BT]),
@@ -11267,7 +11259,7 @@ static int _show_fbtc_cysta_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 
 	if (a2dp->exist) {
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : a2dp_ept:%d, a2dp_late:%d(streak 2S:%d/max:%d)",
+			       "\n %-15s : a2dp_ept:%d, a2dp_late:%d(streak 2S:%d/max:%d)",
 			       "[a2dp_stat]",
 			       le16_to_cpu(pcysta->a2dp_ept.cnt),
 			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout),
@@ -11306,10 +11298,10 @@ static int _show_fbtc_cysta_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 
 		if (cnt % divide_cnt == 1) {
 			if (a2dp->exist)
-				p += scnprintf(p, end - p, "\n\r %-15s : ",
+				p += scnprintf(p, end - p, "\n %-15s : ",
 					       "[slotT_wermtan]");
 			else
-				p += scnprintf(p, end - p, "\n\r %-15s : ",
+				p += scnprintf(p, end - p, "\n %-15s : ",
 					       "[slotT_rxerr]");
 		}
 
@@ -11370,7 +11362,7 @@ static int _show_fbtc_nullsta(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	ns = &pfwinfo->rpt_fbtc_nullsta.finfo;
 	if (ver->fcxnullsta == 1) {
 		for (i = 0; i < 2; i++) {
-			p += scnprintf(p, end - p, " %-15s : ", "\n[NULL-STA]");
+			p += scnprintf(p, end - p, "\n %-15s : ", "[NULL-STA]");
 			p += scnprintf(p, end - p, "null-%d", i);
 			p += scnprintf(p, end - p, "[ok:%d/",
 				       le32_to_cpu(ns->v1.result[i][1]));
@@ -11389,7 +11381,7 @@ static int _show_fbtc_nullsta(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		}
 	} else if (ver->fcxnullsta == 7) {
 		for (i = 0; i < 2; i++) {
-			p += scnprintf(p, end - p, " %-15s : ", "\n[NULL-STA]");
+			p += scnprintf(p, end - p, "\n %-15s : ", "[NULL-STA]");
 			p += scnprintf(p, end - p, "null-%d", i);
 			p += scnprintf(p, end - p, "[Tx:%d/",
 				       le32_to_cpu(ns->v7.result[i][4]));
@@ -11410,7 +11402,7 @@ static int _show_fbtc_nullsta(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		}
 	} else {
 		for (i = 0; i < 2; i++) {
-			p += scnprintf(p, end - p, " %-15s : ", "\n[NULL-STA]");
+			p += scnprintf(p, end - p, "\n %-15s : ", "[NULL-STA]");
 			p += scnprintf(p, end - p, "null-%d", i);
 			p += scnprintf(p, end - p, "[Tx:%d/",
 				       le32_to_cpu(ns->v2.result[i][4]));
@@ -11717,7 +11709,7 @@ static int _show_gpio_dbg(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	if (!en_map)
 		goto out;
 
-	p += scnprintf(p, end - p, "\n\r %-15s : enable_map:0x%08x",
+	p += scnprintf(p, end - p, "\n %-15s : enable_map:0x%08x",
 		       "[gpio_dbg]", en_map);
 
 	for (i = 0; i < BTC_DBG_NUM; i++) {
@@ -11943,7 +11935,7 @@ static int _show_mreg_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	if (!(dm->coex_info_map & BTC_COEX_INFO_MREG))
 		return 0;
 
-	p += scnprintf(p, end - p, "\n\r========== [HW Status] ==========");
+	p += scnprintf(p, end - p, "\n========== [HW Status] ==========\n");
 
 	p += scnprintf(p, end - p,
 		       " %-15s : WL->BT0:0x%08x(cnt:%d), BT0->WL:0x%08x(total:%d, bt_update:%d)\n",
@@ -11965,18 +11957,31 @@ static int _show_mreg_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	dm->pta_owner = rtw89_mac_get_ctrl_path(rtwdev);
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : pta_owner:%s, pta_req_mac:MAC%d, rf_gnt_source: polut_type:%s",
+		       " %-15s : pta_owner:%s, pta_req_mac:MAC%d, rf_gnt_source: polut_type:%s\n",
 		       "[gnt_status]",
 		       rtwdev->chip->para_ver & BTC_FEAT_PTA_ONOFF_CTRL ? "HW" :
 		       dm->pta_owner == BTC_CTRL_BY_WL ? "WL" : "BT",
 		       wl->pta_req_mac,
 		       id_to_polut(wl->bt_polut_type[wl->pta_req_mac]));
 
-	p += scnprintf(p, end - p, ", phy-0[gnt_wl:%s-%d/gnt_bt:%s-%d]",
-		      dm->gnt_set[RTW89_PHY_0].gnt_wl_sw_en ? "SW" : "HW",
-		      dm->gnt_set[RTW89_PHY_0].gnt_wl,
-		      dm->gnt_set[RTW89_PHY_0].gnt_bt0_sw_en ? "SW" : "HW",
-		      dm->gnt_set[RTW89_PHY_0].gnt_bt0);
+	if (rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT)
+		p += scnprintf(p, end - p,
+			       " %-15s : phy-0[gnt_wl:%s-%d/gnt_bt0:%s-%d/gnt_bt1:%s-%d]",
+			       "[gnt_status]",
+			       dm->gnt_set[RTW89_PHY_0].gnt_wl_sw_en ? "SW" : "HW",
+			       dm->gnt_set[RTW89_PHY_0].gnt_wl,
+			       dm->gnt_set[RTW89_PHY_0].gnt_bt0_sw_en ? "SW" : "HW",
+			       dm->gnt_set[RTW89_PHY_0].gnt_bt0,
+			       dm->gnt_set[RTW89_PHY_0].gnt_bt1_sw_en ? "SW" : "HW",
+			       dm->gnt_set[RTW89_PHY_0].gnt_bt1);
+	else
+		p += scnprintf(p, end - p,
+			       " %-15s : phy-0[gnt_wl:%s-%d/gnt_bt:%s-%d]",
+			       "[gnt_status]",
+			       dm->gnt_set[RTW89_PHY_0].gnt_wl_sw_en ? "SW" : "HW",
+			       dm->gnt_set[RTW89_PHY_0].gnt_wl,
+			       dm->gnt_set[RTW89_PHY_0].gnt_bt0_sw_en ? "SW" : "HW",
+			       dm->gnt_set[RTW89_PHY_0].gnt_bt0);
 
 	if (rtwdev->dbcc_en) {
 		p += scnprintf(p, end - p,
@@ -12000,7 +12005,7 @@ static int _show_mreg_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 		if (cnt % 6 == 0)
 			p += scnprintf(p, end - p,
-				       "\n\r %-15s : %s_0x%x=0x%x", "[reg]",
+				       "\n %-15s : %s_0x%x=0x%x", "[reg]",
 				       id_to_regtype(type), offset, val);
 		else
 			p += scnprintf(p, end - p, ", %s_0x%x=0x%x",
@@ -12336,12 +12341,11 @@ static int _show_summary_v5(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
 
 	p += scnprintf(p, end - p,
-		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d",
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
 		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
 		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
 		       cnt[BTC_NCNT_WL_STA]);
 
-	p += scnprintf(p, end - p, "\n");
 	p += scnprintf(p, end - p,
 		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, special_pkt=%d, ",
 		       "[notify_cnt]",
@@ -12457,12 +12461,11 @@ static int _show_summary_v105(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
 
 	p += scnprintf(p, end - p,
-		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d",
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
 		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
 		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
 		       cnt[BTC_NCNT_WL_STA]);
 
-	p += scnprintf(p, end - p, "\n");
 	p += scnprintf(p, end - p,
 		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, special_pkt=%d, ",
 		       "[notify_cnt]",
@@ -12495,7 +12498,7 @@ static int _show_summary_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		return 0;
 
 	p += scnprintf(p, end - p, "%s",
-		       "\n\r========== [Statistics] ==========");
+		       "\n========== [Statistics] ==========\n");
 
 	pcinfo = &pfwinfo->rpt_ctrl.cinfo;
 	if (pcinfo->valid && wl->status.map.lps != BTC_LPS_RF_OFF &&
@@ -12503,7 +12506,7 @@ static int _show_summary_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		prptctrl = &pfwinfo->rpt_ctrl.finfo.v7;
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d),"
+			       " %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d),"
 			       "c2h_cnt=%d(fw_send:%d, len:%d, max:%d), ",
 			       "[summary]", pfwinfo->cnt_h2c,
 			       pfwinfo->cnt_h2c_fail,
@@ -12521,16 +12524,17 @@ static int _show_summary_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 		if (dm->error.map.wl_fw_hang)
 			p += scnprintf(p, end - p, " (WL FW Hang!!)");
+		p += scnprintf(p, end - p, "\n");
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
+			       " %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
 			       "[mailbox]",
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_ok),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_fail),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_recv));
 
 		p += scnprintf(p, end - p,
-			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)",
+			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)\n",
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_empty),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_flowctrl),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_tx),
@@ -12538,7 +12542,7 @@ static int _show_summary_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_nack));
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
+			       " %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
 			       "[RFK/LPS]", wl->wcnt[BTC_WCNT_RFK_REQ],
 			       wl->wcnt[BTC_WCNT_RFK_GO],
 			       wl->wcnt[BTC_WCNT_RFK_REJECT],
@@ -12548,12 +12552,12 @@ static int _show_summary_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		p += scnprintf(p, end - p, ", bt_rfk[req:%d]",
 			       le16_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_REQ]));
 
-		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]",
+		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]\n",
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_on),
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_off));
 	} else {
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)",
+			       " %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)\n",
 			       "[summary]",
 			       pfwinfo->cnt_h2c, pfwinfo->cnt_h2c_fail,
 			       pfwinfo->cnt_c2h,
@@ -12564,19 +12568,19 @@ static int _show_summary_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		cnt_sum += dm->cnt_notify[i];
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
+		       " %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
 		       "[notify_cnt]",
 		       cnt_sum, cnt[BTC_NCNT_SHOW_COEX_INFO],
 		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
 
 	p += scnprintf(p, end - p,
-		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d",
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
 		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
 		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
 		       cnt[BTC_NCNT_WL_STA]);
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
+		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
 		       "[notify_cnt]",
 		       cnt[BTC_NCNT_SCAN_START], cnt[BTC_NCNT_SCAN_FINISH],
 		       cnt[BTC_NCNT_SWITCH_BAND], cnt[BTC_NCNT_SWITCH_CHBW],
@@ -12608,7 +12612,7 @@ static int _show_summary_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		return 0;
 
 	p += scnprintf(p, end - p, "%s",
-		       "\n\r========== [Statistics] ==========");
+		       "\n========== [Statistics] ==========\n");
 
 	pcinfo = &pfwinfo->rpt_ctrl.cinfo;
 	if (pcinfo->valid && wl->status.map.lps != BTC_LPS_RF_OFF &&
@@ -12616,7 +12620,7 @@ static int _show_summary_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		prptctrl = &pfwinfo->rpt_ctrl.finfo.v8;
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d, len:%d, max:fw-%d/drv-%d), ",
+			       " %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d, len:%d, max:fw-%d/drv-%d), ",
 			       "[summary]", pfwinfo->cnt_h2c,
 			       pfwinfo->cnt_h2c_fail,
 			       le16_to_cpu(prptctrl->rpt_info.cnt_h2c),
@@ -12634,16 +12638,17 @@ static int _show_summary_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 		if (dm->error.map.wl_fw_hang)
 			p += scnprintf(p, end - p, " (WL FW Hang!!)");
+		p += scnprintf(p, end - p, "\n");
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
+			       " %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
 			       "[mailbox]",
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_ok),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_fail),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_recv));
 
 		p += scnprintf(p, end - p,
-			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)",
+			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)\n",
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_empty),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_flowctrl),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_tx),
@@ -12651,7 +12656,7 @@ static int _show_summary_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_nack));
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
+			       " %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
 			       "[RFK/LPS]", wl->wcnt[BTC_WCNT_RFK_REQ],
 			       wl->wcnt[BTC_WCNT_RFK_GO],
 			       wl->wcnt[BTC_WCNT_RFK_REJECT],
@@ -12661,12 +12666,12 @@ static int _show_summary_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		p += scnprintf(p, end - p, ", bt_rfk[req:%d]",
 			       le16_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_REQ]));
 
-		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]",
+		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]\n",
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_on),
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_off));
 	} else {
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)",
+			       " %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)\n",
 			       "[summary]",
 			       pfwinfo->cnt_h2c, pfwinfo->cnt_h2c_fail,
 			       pfwinfo->cnt_c2h,
@@ -12677,19 +12682,19 @@ static int _show_summary_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		cnt_sum += dm->cnt_notify[i];
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
+		       " %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
 		       "[notify_cnt]",
 		       cnt_sum, cnt[BTC_NCNT_SHOW_COEX_INFO],
 		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
 
 	p += scnprintf(p, end - p,
-		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d",
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
 		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
 		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
 		       cnt[BTC_NCNT_WL_STA]);
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
+		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
 		       "[notify_cnt]",
 		       cnt[BTC_NCNT_SCAN_START], cnt[BTC_NCNT_SCAN_FINISH],
 		       cnt[BTC_NCNT_SWITCH_BAND], cnt[BTC_NCNT_SWITCH_CHBW],
@@ -12721,7 +12726,7 @@ static int _show_summary_v9(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		return 0;
 
 	p += scnprintf(p, end - p, "%s",
-		       "\n\r========== [Statistics] ==========");
+		       "\n========== [Statistics] ==========\n");
 
 	pcinfo = &pfwinfo->rpt_ctrl.cinfo;
 	if (pcinfo->valid && wl->status.map.lps != BTC_LPS_RF_OFF &&
@@ -12729,7 +12734,7 @@ static int _show_summary_v9(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		prptctrl = &pfwinfo->rpt_ctrl.finfo.v9;
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d, len:%d, ",
+			       " %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d, len:%d, ",
 			       "[summary]", pfwinfo->cnt_h2c,
 			       pfwinfo->cnt_h2c_fail,
 			       le16_to_cpu(prptctrl->rpt_info.cnt_h2c),
@@ -12745,16 +12750,17 @@ static int _show_summary_v9(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 		if (dm->error.map.wl_fw_hang)
 			p += scnprintf(p, end - p, " (WL FW Hang!!)");
+		p += scnprintf(p, end - p, "\n");
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
+			       " %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
 			       "[mailbox]",
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_ok),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_fail),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_recv));
 
 		p += scnprintf(p, end - p,
-			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)",
+			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)\n",
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_empty),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_flowctrl),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_tx),
@@ -12762,7 +12768,7 @@ static int _show_summary_v9(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_nack));
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
+			       " %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
 			       "[RFK/LPS]", wl->wcnt[BTC_WCNT_RFK_REQ],
 			       wl->wcnt[BTC_WCNT_RFK_GO],
 			       wl->wcnt[BTC_WCNT_RFK_REJECT],
@@ -12772,12 +12778,12 @@ static int _show_summary_v9(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		p += scnprintf(p, end - p, ", bt_rfk[req:%d]",
 			       le16_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_REQ]));
 
-		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]",
+		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]\n",
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_on),
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_off));
 	} else {
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)",
+			       " %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)\n",
 			       "[summary]",
 			       pfwinfo->cnt_h2c, pfwinfo->cnt_h2c_fail,
 			       pfwinfo->cnt_c2h,
@@ -12788,19 +12794,19 @@ static int _show_summary_v9(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		cnt_sum += dm->cnt_notify[i];
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
+		       " %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
 		       "[notify_cnt]",
 		       cnt_sum, cnt[BTC_NCNT_SHOW_COEX_INFO],
 		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
 
 	p += scnprintf(p, end - p,
-		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d",
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
 		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
 		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
 		       cnt[BTC_NCNT_WL_STA]);
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
+		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
 		       "[notify_cnt]",
 		       cnt[BTC_NCNT_SCAN_START], cnt[BTC_NCNT_SCAN_FINISH],
 		       cnt[BTC_NCNT_SWITCH_BAND], cnt[BTC_NCNT_SWITCH_CHBW],
@@ -12832,7 +12838,7 @@ static int _show_summary_v11(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		return 0;
 
 	p += scnprintf(p, end - p, "%s",
-		       "\n\r========== [Statistics] ==========");
+		       "\n========== [Statistics] ==========\n");
 
 	pcinfo = &pfwinfo->rpt_ctrl.cinfo;
 	if (pcinfo->valid && wl->status.map.lps != BTC_LPS_RF_OFF &&
@@ -12840,7 +12846,7 @@ static int _show_summary_v11(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		prptctrl = &pfwinfo->rpt_ctrl.finfo.v11;
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d, len:%d, max:fw-%d/drv-%d), ",
+			       " %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d, len:%d, max:fw-%d/drv-%d), ",
 			       "[summary]", pfwinfo->cnt_h2c,
 			       pfwinfo->cnt_h2c_fail,
 			       le16_to_cpu(prptctrl->rpt_info.cnt_h2c),
@@ -12858,16 +12864,17 @@ static int _show_summary_v11(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 
 		if (dm->error.map.wl_fw_hang)
 			p += scnprintf(p, end - p, " (WL FW Hang!!)");
+		p += scnprintf(p, end - p, "\n");
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
+			       " %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
 			       "[mailbox]",
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_ok),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_fail),
 			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_recv));
 
 		p += scnprintf(p, end - p,
-			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)",
+			       "A2DP_empty:%d(stop:%d/tx:%d/ack:%d/nack:%d)\n",
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_empty),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_flowctrl),
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_tx),
@@ -12875,19 +12882,19 @@ static int _show_summary_v11(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_nack));
 
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
+			       " %-15s : wl_rfk[req:%d/go:%d/reject:%d/tout:%d/time:%dms]",
 			       "[RFK/LPS]", wl->wcnt[BTC_WCNT_RFK_REQ],
 			       wl->wcnt[BTC_WCNT_RFK_GO],
 			       wl->wcnt[BTC_WCNT_RFK_REJECT],
 			       wl->wcnt[BTC_WCNT_RFK_TIMEOUT],
 			       wl->rfk_info.proc_time);
 
-		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]",
+		p += scnprintf(p, end - p, ", AOAC[RF_on:%d/RF_off:%d]\n",
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_on),
 			       le16_to_cpu(prptctrl->rpt_info.cnt_aoac_rf_off));
 	} else {
 		p += scnprintf(p, end - p,
-			       "\n\r %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)",
+			       " %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d (lps=%d/rf_off=%d)\n",
 			       "[summary]",
 			       pfwinfo->cnt_h2c, pfwinfo->cnt_h2c_fail,
 			       pfwinfo->cnt_c2h,
@@ -12898,19 +12905,19 @@ static int _show_summary_v11(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		cnt_sum += dm->cnt_notify[i];
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
+		       " %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
 		       "[notify_cnt]",
 		       cnt_sum, cnt[BTC_NCNT_SHOW_COEX_INFO],
 		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
 
 	p += scnprintf(p, end - p,
-		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d",
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
 		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
 		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
 		       cnt[BTC_NCNT_WL_STA]);
 
 	p += scnprintf(p, end - p,
-		       "\n\r %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
+		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, switch_chbw=%d, special_pkt=%d, ",
 		       "[notify_cnt]",
 		       cnt[BTC_NCNT_SCAN_START], cnt[BTC_NCNT_SCAN_FINISH],
 		       cnt[BTC_NCNT_SWITCH_BAND], cnt[BTC_NCNT_SWITCH_CHBW],
@@ -12993,6 +13000,8 @@ ssize_t rtw89_btc_dump_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	else if (ver->fcxbtcrpt == 11)
 		p += _show_summary_v11(rtwdev, p, end - p);
 
+	p += scnprintf(p, end - p, "\n");
+
 	return p - buf;
 }
 
-- 
2.25.1

