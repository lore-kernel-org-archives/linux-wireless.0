Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E63746C851
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147690; cv=none; b=DXSJZ2fjDm1s9QUrzf+9bPTPZdGW8ilg8UvPvHTOECMD6Eg91pXF2+c80zBfB+EM/O2oxWKYIMy8omzszlhdOlF2FA/xzNipvgDuwRQFi3N4sA4wOfINpvI64oqpVq/rfCbQurVC0yxgIKCUTuY2txwJofVbSMNOlBIdvvliBpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147690; c=relaxed/simple;
	bh=1Qz0V+8v3u3BbymScM9k2uCE19ZlxmKNk+w1v6jhCek=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/oeR0DKlAyXrpwYPzdh0oUz/7NY9fNCnSDNwEbS64Dbi0MqS8TIvfZ2SvG/cdaeso0NqhNs3Z11mv+pbHgHwFeAT7nMPM/e6M8/p4GIF2UT6hlc3jEqOZ27vy0KSk2284kVRh5DGTQzj54qFuSpQeQ2/5m/4uzy4vg6QdIrRfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NuRgHzlN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NuRgHzlN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7EjIlA132736, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147685; bh=uESsLcWwUQzUycPFiaFc6sTTGKMO3l/J6QB9l8D947A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=NuRgHzlNoYRQveOK4mo/ysiDRygv6m+q0vAe4fnacUQ/oS3T+FRsf4Z89s3N/nWkW
	 Ts4V3/+AnP3QMSUhPfBMxjwr/QykAA0F3QoEZdgBRYD3+ZwMgy4pFng6l2CjIcahyY
	 OoFjBs6HS1mAUUmXyqn1s4co2u3ImWIKSY1KZyiZ1H4VnKuEX8avGGiHLoevgTSYuV
	 fpdJnqDZAMt0zwmT6TD73HepXJKyWbrFXqTvoSzlh7SxEr6t7ZxQ7Ri5kdzTFWM2M4
	 ccLz5dzsH2t+mSOj+t1OyCY3KR+5TY/hnQWaOSGA94SClmx/Iuc1KEHdbbKknN9mwE
	 Z/A2mX2WdfqgA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7EjIlA132736
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:14:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:14:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:14:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 2/7] wifi: rtw89: coex: add fbtc_rpt_ctrl v205 report struct and handling
Date: Wed, 23 Sep 2026 15:13:49 +0800
Message-ID: <20260923071354.50864-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923071354.50864-1-pkshih@realtek.com>
References: <20260923071354.50864-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Define struct rtw89_btc_fbtc_rpt_ctrl_v205 and add it to the
rtw89_btc_fbtc_rpt_ctrl_ver_info union. Wire up the v205 dispatch
path in _chk_btc_report() including req_len, fver extraction, and
rsp_fver assignment (H2C fver=5). Decode the v205 report block for
rpt_en_map, fw_coex/fw version, cx_offload, build timestamps, gnt_val,
and BT counters. Add fw_ver_match checking for fcxbtcrpt=205, and add
BTTX_HANG detection in the v205 error-check block.

Also add _show_summary_v205() and wire it into the coex info dump so
the fcxbtcrpt=205 statistics block is printed instead of skipped.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 179 +++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/core.h |  14 ++
 2 files changed, 191 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index d3f9ef02e982..0f3347fdbb01 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1910,6 +1910,14 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			fwsubver->fcxbtcrpt = pfwinfo->rpt_ctrl.finfo.v105.fver;
 			pcinfo->req_fver = 5;
 			break;
+		} else if (ver->fcxbtcrpt == 205) {
+			pfinfo = &pfwinfo->rpt_ctrl.finfo.v205;
+			pcinfo->req_len =
+				sizeof(pfwinfo->rpt_ctrl.finfo.v205);
+			fwsubver->fcxbtcrpt =
+				pfwinfo->rpt_ctrl.finfo.v205.fver;
+			pcinfo->req_fver = 5;
+			break;
 		} else if (ver->fcxbtcrpt == 8) {
 			pfinfo = &pfwinfo->rpt_ctrl.finfo.v8;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_ctrl.finfo.v8);
@@ -2304,6 +2312,52 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			_chk_btc_err(rtwdev, BTC_DCNT_RPT_HANG,
 				     pfwinfo->event[BTF_EVNT_RPT]);
 
+			dm->error.map.bt_rfk_timeout = bt->rfk_info.map.timeout;
+		} else if (ver->fcxbtcrpt == 205) {
+			prpt->v205 = pfwinfo->rpt_ctrl.finfo.v205;
+			pfwinfo->rpt_en_map =
+				le32_to_cpu(prpt->v205.rpt_info.en);
+			wl->ver_info.fw_coex =
+				le32_to_cpu(prpt->v205.wl_fw_info.cx_ver);
+			wl->ver_info.fw =
+				le32_to_cpu(prpt->v205.wl_fw_info.fw_ver);
+			dm->wl_fw_cx_offload =
+				!!le32_to_cpu(prpt->v205.wl_fw_info.cx_offload);
+
+			memcpy(wl->ver_info.build_time,
+			       prpt->v205.build_time,
+			       sizeof(wl->ver_info.build_time));
+			memcpy(wl->ver_info.build_date,
+			       prpt->v205.build_date,
+			       sizeof(wl->ver_info.build_date));
+
+			for (i = RTW89_PHY_0; i < RTW89_PHY_NUM; i++)
+				memcpy(&dm->gnt_val[i],
+				       &prpt->v205.gnt_val[i],
+				       sizeof(prpt->v205.gnt_val[i]));
+
+			bt->bcnt[BTC_BCNT_HIPRI_TX] =
+				le32_to_cpu(prpt->v205.bt_cnt[BTC_BCNT_HI_TX]);
+			bt->bcnt[BTC_BCNT_HIPRI_RX] =
+				le32_to_cpu(prpt->v205.bt_cnt[BTC_BCNT_HI_RX]);
+			bt->bcnt[BTC_BCNT_LOPRI_TX] =
+				le32_to_cpu(prpt->v205.bt_cnt[BTC_BCNT_LO_TX]);
+			bt->bcnt[BTC_BCNT_LOPRI_RX] =
+				le32_to_cpu(prpt->v205.bt_cnt[BTC_BCNT_LO_RX]);
+			bt->bcnt[BTC_BCNT_POLLUTED] =
+				le32_to_cpu(prpt->v205.bt_cnt[BTC_BCNT_POLLUTED]);
+
+			_chk_btc_err(rtwdev, BTC_DCNT_BTCNT_HANG, 0);
+			_chk_btc_err(rtwdev, BTC_DCNT_RPT_HANG,
+				     pfwinfo->event[BTF_EVNT_RPT]);
+			_chk_btc_err(rtwdev, BTC_DCNT_WL_FW_VER_MATCH, 0);
+			_chk_btc_err(rtwdev, BTC_DCNT_BTTX_HANG, 0);
+
+			if (le32_to_cpu(prpt->v205.bt_cnt[BTC_BCNT_RFK_TIMEOUT]) > 0)
+				bt->rfk_info.map.timeout = 1;
+			else
+				bt->rfk_info.map.timeout = 0;
+
 			dm->error.map.bt_rfk_timeout = bt->rfk_info.map.timeout;
 		} else if (ver->fcxbtcrpt == 7) {
 			prpt->v7 = pfwinfo->rpt_ctrl.finfo.v7;
@@ -3332,9 +3386,13 @@ static void rtw89_btc_fw_en_rpt(struct rtw89_dev *rtwdev,
 	if (btc->ver->fcxbtcrpt == 7 ||
 	    btc->ver->fcxbtcrpt == 8 ||
 	    btc->ver->fcxbtcrpt == 9 ||
-	    btc->ver->fcxbtcrpt == 11) {
+	    btc->ver->fcxbtcrpt == 11 ||
+	    btc->ver->fcxbtcrpt == 205) {
 		r.v8.type = SET_REPORT_EN;
-		r.v8.fver = btc->ver->fcxbtcrpt;
+		if (btc->ver->fcxbtcrpt == 205)
+			r.v8.fver = 5;
+		else
+			r.v8.fver = btc->ver->fcxbtcrpt;
 		r.v8.len = sizeof(r.v8.map);
 		r.v8.map = cpu_to_le32(rpt_map);
 		ret = _send_fw_cmd(rtwdev, BTFC_SET, SET_REPORT_EN, &r.v8,
@@ -13644,6 +13702,121 @@ static int _show_summary_v11(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 	return p - buf;
 }
 
+static int _show_summary_v205(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_btf_fwinfo *pfwinfo = &btc->fwinfo;
+	struct rtw89_btc_fbtc_rpt_ctrl_v205 *prptctrl;
+	struct rtw89_btc_rpt_cmn_info *pcinfo;
+	struct rtw89_btc_cx *cx = &btc->cx;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_wl_info *wl = &cx->wl;
+	struct rtw89_btc_bt_info *bt = &cx->bt0;
+	u32 cnt_sum = 0, *cnt = btc->dm.cnt_notify;
+	char *p = buf, *end = buf + bufsz;
+	u8 i;
+
+	if (!(dm->coex_info_map & BTC_COEX_INFO_SUMMARY))
+		return 0;
+
+	p += scnprintf(p, end - p, "========== [Statistics] ==========\n");
+
+	pcinfo = &pfwinfo->rpt_ctrl.cinfo;
+	if (pcinfo->valid && !wl->status.map.lps && !wl->status.map.rf_off) {
+		prptctrl = &pfwinfo->rpt_ctrl.finfo.v205;
+
+		p += scnprintf(p, end - p,
+			       " %-15s : h2c_cnt=%d(fail:%d, fw_recv:%d), c2h_cnt=%d(fw_send:%d), ",
+			       "[summary]", pfwinfo->cnt_h2c,
+			       pfwinfo->cnt_h2c_fail,
+			       le32_to_cpu(prptctrl->rpt_info.cnt_h2c),
+			       pfwinfo->cnt_c2h,
+			       le32_to_cpu(prptctrl->rpt_info.cnt_c2h));
+
+		p += scnprintf(p, end - p,
+			       "rpt_cnt=%d(fw_send:%d), rpt_map=0x%x, dm_error_map:0x%x",
+			       pfwinfo->event[BTF_EVNT_RPT],
+			       le32_to_cpu(prptctrl->rpt_info.cnt),
+			       le32_to_cpu(prptctrl->rpt_info.en),
+			       dm->error.val);
+
+		if (dm->error.map.wl_fw_hang)
+			p += scnprintf(p, end - p, " (WL FW Hang!!)");
+		p += scnprintf(p, end - p, "\n");
+		p += scnprintf(p, end - p,
+			       " %-15s : send_ok:%d, send_fail:%d, recv:%d, ",
+			       "[mailbox]",
+			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_ok),
+			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_send_fail),
+			       le32_to_cpu(prptctrl->bt_mbx_info.cnt_recv));
+
+		p += scnprintf(p, end - p,
+			       "A2DP_empty:%d(stop:%d, tx:%d, ack:%d, nack:%d)\n",
+			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_empty),
+			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_flowctrl),
+			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_tx),
+			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_ack),
+			       le32_to_cpu(prptctrl->bt_mbx_info.a2dp.cnt_nack));
+
+		p += scnprintf(p, end - p,
+			       " %-15s : wl_rfk[req:%d/go:%d/reject:%d/timeout:%d]",
+			       "[RFK]", wl->wcnt[BTC_WCNT_RFK_REQ],
+			       wl->wcnt[BTC_WCNT_RFK_GO],
+			       wl->wcnt[BTC_WCNT_RFK_REJECT],
+			       wl->wcnt[BTC_WCNT_RFK_TIMEOUT]);
+
+		p += scnprintf(p, end - p,
+			       ", bt_rfk[req:%d/go:%d/reject:%d/timeout:%d/fail:%d]\n",
+			       le32_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_REQ]),
+			       le32_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_GO]),
+			       le32_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_REJECT]),
+			       le32_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_TIMEOUT]),
+			       le32_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_FAIL]));
+
+		if (le32_to_cpu(prptctrl->bt_cnt[BTC_BCNT_RFK_TIMEOUT]) > 0)
+			bt->rfk_info.map.timeout = 1;
+		else
+			bt->rfk_info.map.timeout = 0;
+
+		dm->error.map.wl_rfk_timeout = bt->rfk_info.map.timeout;
+	} else {
+		p += scnprintf(p, end - p,
+			       " %-15s : h2c_cnt=%d(fail:%d), c2h_cnt=%d, rpt_cnt=%d, rpt_map=0x%x",
+			       "[summary]", pfwinfo->cnt_h2c,
+			       pfwinfo->cnt_h2c_fail, pfwinfo->cnt_c2h,
+			       pfwinfo->event[BTF_EVNT_RPT],
+			       btc->fwinfo.rpt_en_map);
+		p += scnprintf(p, end - p, " (WL FW report invalid!!)\n");
+	}
+
+	for (i = 0; i < BTC_NCNT_NUM; i++)
+		cnt_sum += dm->cnt_notify[i];
+
+	p += scnprintf(p, end - p,
+		       " %-15s : total=%d, show_coex_info=%d, power_on=%d, init_coex=%d, ",
+		       "[notify_cnt]", cnt_sum, cnt[BTC_NCNT_SHOW_COEX_INFO],
+		       cnt[BTC_NCNT_POWER_ON], cnt[BTC_NCNT_INIT_COEX]);
+
+	p += scnprintf(p, end - p,
+		       "power_off=%d, radio_state=%d, role_info=%d, wl_rfk=%d, wl_sta=%d\n",
+		       cnt[BTC_NCNT_POWER_OFF], cnt[BTC_NCNT_RADIO_STATE],
+		       cnt[BTC_NCNT_ROLE_INFO], cnt[BTC_NCNT_WL_RFK],
+		       cnt[BTC_NCNT_WL_STA]);
+
+	p += scnprintf(p, end - p,
+		       " %-15s : scan_start=%d, scan_finish=%d, switch_band=%d, special_pkt=%d, ",
+		       "[notify_cnt]", cnt[BTC_NCNT_SCAN_START],
+		       cnt[BTC_NCNT_SCAN_FINISH], cnt[BTC_NCNT_SWITCH_BAND],
+		       cnt[BTC_NCNT_SPECIAL_PACKET]);
+
+	p += scnprintf(p, end - p,
+		       "timer=%d, control=%d, customerize=%d\n",
+		       cnt[BTC_NCNT_TIMER], cnt[BTC_NCNT_CONTROL],
+		       cnt[BTC_NCNT_CUSTOMERIZE]);
+
+	return p - buf;
+}
+
 ssize_t rtw89_btc_dump_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -13704,6 +13877,8 @@ ssize_t rtw89_btc_dump_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		p += _show_summary_v5(rtwdev, p, end - p);
 	else if (ver->fcxbtcrpt == 105)
 		p += _show_summary_v105(rtwdev, p, end - p);
+	else if (ver->fcxbtcrpt == 205)
+		p += _show_summary_v205(rtwdev, p, end - p);
 	else if (ver->fcxbtcrpt == 7)
 		p += _show_summary_v7(rtwdev, p, end - p);
 	else if (ver->fcxbtcrpt == 8)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 3a6099386b09..fc51419a1782 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3006,6 +3006,19 @@ struct rtw89_btc_fbtc_rpt_ctrl_v11 {
 	__le32 scbd_b2w[2];
 } __packed;
 
+struct rtw89_btc_fbtc_rpt_ctrl_v205 {
+	u8 fver;
+	u8 rsvd;
+	u8 build_time[RTW89_BTC_TIME_DATE_FMT];
+	u8 build_date[RTW89_BTC_TIME_DATE_FMT];
+	__le16 rsvd1;
+	struct rtw89_btc_fbtc_rpt_ctrl_info rpt_info;
+	struct rtw89_btc_fbtc_rpt_ctrl_wl_fw_info wl_fw_info;
+	struct rtw89_btc_fbtc_rpt_ctrl_bt_mailbox bt_mbx_info;
+	__le32 bt_cnt[BTC_BCNT_STA_MAX];
+	u8 gnt_val[RTW89_PHY_NUM][4];
+} __packed;
+
 union rtw89_btc_fbtc_rpt_ctrl_ver_info {
 	struct rtw89_btc_fbtc_rpt_ctrl_v1 v1;
 	struct rtw89_btc_fbtc_rpt_ctrl_v4 v4;
@@ -3015,6 +3028,7 @@ union rtw89_btc_fbtc_rpt_ctrl_ver_info {
 	struct rtw89_btc_fbtc_rpt_ctrl_v8 v8;
 	struct rtw89_btc_fbtc_rpt_ctrl_v9 v9;
 	struct rtw89_btc_fbtc_rpt_ctrl_v11 v11;
+	struct rtw89_btc_fbtc_rpt_ctrl_v205 v205;
 };
 
 enum rtw89_fbtc_ext_ctrl_type {
-- 
2.25.1

