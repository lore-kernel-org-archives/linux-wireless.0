Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A33744C4E8
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543446; cv=none; b=QXxR0NNdsGPMZGiHhgWL9Ci1mU1cIxM5A7FIob56o+1wbDah7Yv6WEnraBdDRbiv44lTqEhxvnmJPsIv8VCYbwUbN4wvf+qdbmhgv0qLLud0+mLAan2UsaKhKHryBLENMBzvDSCU4pyjVSQ2Db5tDvj2o8wSMgMhcAg1ipkBG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543446; c=relaxed/simple;
	bh=02KujcfhuFjJ2JRWhjujsEVROur08Hm3ptK5iEj3BDE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bs4kG98sjBMtPflCMd8s1MDlbzft885AJk8vYvLHDdvZy7o1I3M1uXwrh5m62CRUUXxOwEb5pa2Ducy+eeDzoB5cS8TbTdzHjy7K8HyPqHMUN3fAZ4P6ETgFKTcCd2orN8YUb6r//H8XwwSqo9hqAo6A7ZoSfeKBfIlEgLBbhk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=leBeNK5h; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="leBeNK5h"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NhZ322168454, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543423; bh=Sv9TGBlPXfIB5pGrsWJAtPKjiITlrI1C9FJL9X3Uwxw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=leBeNK5hHOpjxAArG7SdD9GlomOj3MLoVzbh20NdVirMolQMITouzcbTGx5PeW4T+
	 QZyF2XMm+/XXSr0Z05nnN1oPs6VAaJnKG1K+dWdF8HledQ/sSex0WXoPVif6avGg5L
	 gErNlPCHp5nmFtZDZho+6ltxA21vaYZUk2Z6mt4NcqmO5PrXMtsKqkgUlThK7AMCRP
	 1XJH7q9UCUFwyyTVqLllXDUWUfKf894R5j6u/7Z4h0KfWqbk3VFd48c7Wc1XXY/tEb
	 0Fppr9ZL9hvpNTAIZj+2QOrZBm69cPqkrrUYBuVfzwFnMLbcgd5gqZmdf7MdYGViOo
	 vX4z/C2LoGjsg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NhZ322168454
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:42 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 06/15] wifi: rtw89: coex: add fcxcysta v8 report support
Date: Wed, 16 Sep 2026 15:22:29 +0800
Message-ID: <20260916072238.62574-7-pkshih@realtek.com>
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

The firmware introduces coexistence cycle statistics report version 8
(fcxcysta v8). The v8 struct layout diverges from v7: it adds a per-slot
WL RX error ratio array, a new CXBCN_BT_PROTECT_OK beacon counter, and
extended slot step time tracking. Because of these layout differences, the
v7 and v8 parsing paths in _chk_btc_report are now separate branches
rather than sharing one handler.

The v8 error-checking path adds hang detection for E2G, W1, and B1 slot
counts in addition to the BT_SLOT_FLOOD and CYCLE_HANG checks carried over
from v7. A dedicated _show_fbtc_cysta_v8 display function is added to
expose the new fields through the debugfs coex dump.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 199 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/core.h |  26 +++
 2 files changed, 225 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 3a5219fcc7b9..785060acf508 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1841,6 +1841,11 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pcysta->v7 = pfwinfo->rpt_fbtc_cysta.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_cysta.finfo.v7);
 			fwsubver->fcxcysta = pfwinfo->rpt_fbtc_cysta.finfo.v7.fver;
+		} else if (ver->fcxcysta == 8) {
+			pfinfo = &pfwinfo->rpt_fbtc_cysta.finfo.v8;
+			pcysta->v8 = pfwinfo->rpt_fbtc_cysta.finfo.v8;
+			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_cysta.finfo.v8);
+			fwsubver->fcxcysta = pfwinfo->rpt_fbtc_cysta.finfo.v8.fver;
 		} else {
 			goto err;
 		}
@@ -2628,6 +2633,49 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 				     le16_to_cpu(pcysta->v7.cycles));
 			_chk_btc_err(rtwdev, BTC_DCNT_CYCLE_HANG,
 				     le16_to_cpu(pcysta->v7.cycles));
+		} else if (ver->fcxcysta == 8) {
+			if (dm->fddt_train == BTC_FDDT_ENABLE)
+				break;
+
+			pcysta = &pfwinfo->rpt_fbtc_cysta.finfo;
+
+			if (dm->tdma_now.type != CXTDMA_OFF) {
+				val16 = le16_to_cpu(pcysta->v8.cycle_time.tavg[CXT_WL]);
+				_chk_btc_err(rtwdev, BTC_DCNT_WL_SLOT_DRIFT, val16);
+
+				val1 = le32_to_cpu(pcysta->v8.leak_slot.cnt_rximr) *
+				       BTC_LEAK_AP_TH;
+				val2 = le16_to_cpu(pcysta->v8.slot_cnt[CXST_LK]);
+
+				val16 = le16_to_cpu(pcysta->v8.cycles);
+				if (dm->tdma_now.rxflctrl &&
+				    val16 >= BTC_CYSTA_CHK_PERIOD && val1 > val2)
+					dm->leak_ap = 1;
+			} else if (dm->tdma_now.ext_ctrl == CXECTL_EXT) {
+				val16 = le16_to_cpu(pcysta->v8.cycle_time.tavg[CXT_BT]);
+				_chk_btc_err(rtwdev, BTC_DCNT_BT_SLOT_DRIFT, val16);
+
+				val1 = le16_to_cpu(pcysta->v8.a2dp_ept.cnt_timeout) *
+				       BTC_SLOT_REQ_TH;
+				val2 = le16_to_cpu(pcysta->v8.a2dp_ept.cnt);
+
+				val16 = le16_to_cpu(pcysta->v8.cycles);
+				if (val16 >= BTC_CYSTA_CHK_PERIOD && val1 > val2)
+					dm->slot_req_more = 1;
+				else if (bt->link_info.status.map.connect == 0)
+					dm->slot_req_more = 0;
+			}
+
+			_chk_btc_err(rtwdev, BTC_DCNT_E2G_HANG,
+				     le16_to_cpu(pcysta->v8.slot_cnt[CXST_E2G]));
+			_chk_btc_err(rtwdev, BTC_DCNT_W1_HANG,
+				     le16_to_cpu(pcysta->v8.slot_cnt[CXST_W1]));
+			_chk_btc_err(rtwdev, BTC_DCNT_B1_HANG,
+				     le16_to_cpu(pcysta->v8.slot_cnt[CXST_B1]));
+			_chk_btc_err(rtwdev, BTC_DCNT_BT_SLOT_FLOOD,
+				     le16_to_cpu(pcysta->v8.cycles));
+			_chk_btc_err(rtwdev, BTC_DCNT_CYCLE_HANG,
+				     le16_to_cpu(pcysta->v8.cycles));
 		} else {
 			goto err;
 		}
@@ -10710,6 +10758,10 @@ static int _show_error(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		pcysta->v7 = pfwinfo->rpt_fbtc_cysta.finfo.v7;
 		except_cnt = pcysta->v7.except_cnt;
 		exception_map = le32_to_cpu(pcysta->v7.except_map);
+	} else if (ver->fcxcysta == 8) {
+		pcysta->v8 = pfwinfo->rpt_fbtc_cysta.finfo.v8;
+		except_cnt = pcysta->v8.except_cnt;
+		exception_map = le32_to_cpu(pcysta->v8.except_map);
 	} else {
 		return 0;
 	}
@@ -11652,6 +11704,151 @@ static int _show_fbtc_cysta_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 	return p - buf;
 }
 
+static int _show_fbtc_cysta_v8(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
+{
+	struct rtw89_btc_bt_info *bt = &rtwdev->btc.cx.bt0;
+	struct rtw89_btc_bt_a2dp_desc *a2dp = &bt->link_info.a2dp_desc;
+	struct rtw89_btc_btf_fwinfo *pfwinfo = &rtwdev->btc.fwinfo;
+	struct rtw89_btc_fbtc_cysta_v8 *pcysta = NULL;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
+	struct rtw89_btc_rpt_cmn_info *pcinfo;
+	char *p = buf, *end = buf + bufsz;
+	u16 cycle, c_begin, c_end, s_id;
+	u8 i, cnt = 0, divide_cnt;
+	u8 slot_pair;
+
+	pcinfo = &pfwinfo->rpt_fbtc_cysta.cinfo;
+	if (!pcinfo->valid)
+		return 0;
+
+	pcysta = &pfwinfo->rpt_fbtc_cysta.finfo.v8;
+	p += scnprintf(p, end - p, "\n %-15s : cycle:%d", "[slot_stat]",
+		       le16_to_cpu(pcysta->cycles));
+
+	for (i = 0; i < CXST_MAX; i++) {
+		if (!le16_to_cpu(pcysta->slot_cnt[i]))
+			continue;
+		p += scnprintf(p, end - p, ", %s:%d",
+			       id_to_slot(i),
+			       le16_to_cpu(pcysta->slot_cnt[i]));
+	}
+
+	if (dm->tdma_now.rxflctrl)
+		p += scnprintf(p, end - p, ", leak_rx:%d",
+			       le32_to_cpu(pcysta->leak_slot.cnt_rximr));
+
+	if (pcysta->collision_cnt)
+		p += scnprintf(p, end - p, ", collision:%d",
+			       pcysta->collision_cnt);
+
+	if (pcysta->skip_cnt)
+		p += scnprintf(p, end - p, ", skip:%d",
+			       le16_to_cpu(pcysta->skip_cnt));
+
+	p += scnprintf(p, end - p,
+		       "\n %-15s : avg_t[wl:%d/bt:%d/lk:%d.%03d]",
+		       "[cycle_stat]",
+		       le16_to_cpu(pcysta->cycle_time.tavg[CXT_WL]),
+		       le16_to_cpu(pcysta->cycle_time.tavg[CXT_BT]),
+		       le16_to_cpu(pcysta->leak_slot.tavg) / 1000,
+		       le16_to_cpu(pcysta->leak_slot.tavg) % 1000);
+	p += scnprintf(p, end - p,
+		       ", max_t[wl:%d/bt:%d(>%dms:%d)/lk:%d.%03d]",
+		       le16_to_cpu(pcysta->cycle_time.tmax[CXT_WL]),
+		       le16_to_cpu(pcysta->cycle_time.tmax[CXT_BT]),
+		       dm->bt_slot_flood, dm->cnt_dm[BTC_DCNT_BT_SLOT_FLOOD],
+		       le16_to_cpu(pcysta->leak_slot.tamx) / 1000,
+		       le16_to_cpu(pcysta->leak_slot.tamx) % 1000);
+	p += scnprintf(p, end - p, ", bcn[all:%d/ok:%d/in_bt:%d/in_bt_ok:%d]",
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_ALL]),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_ALL_OK]),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_BT_SLOT]),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_BT_OK]));
+
+	if (a2dp->exist) {
+		p += scnprintf(p, end - p,
+			       "\n %-15s : a2dp_ept:%d, a2dp_late:%d(streak 2S:%d/max:%d)",
+			       "[a2dp_stat]",
+			       le16_to_cpu(pcysta->a2dp_ept.cnt),
+			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout),
+			       a2dp->no_empty_streak_2s,
+			       a2dp->no_empty_streak_max);
+
+		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d",
+			       le16_to_cpu(pcysta->a2dp_ept.tavg),
+			       le16_to_cpu(pcysta->a2dp_ept.tmax));
+	}
+
+	if (le16_to_cpu(pcysta->cycles) <= 1)
+		goto out;
+
+	slot_pair = BTC_CYCLE_SLOT_MAX / 2;
+
+	if (le16_to_cpu(pcysta->cycles) <= slot_pair)
+		c_begin = 1;
+	else
+		c_begin = le16_to_cpu(pcysta->cycles) - slot_pair + 1;
+
+	c_end = le16_to_cpu(pcysta->cycles);
+
+	if (a2dp->exist)
+		divide_cnt = 2;
+	else
+		divide_cnt = 6;
+
+	if (c_begin > c_end)
+		goto out;
+
+	for (cycle = c_begin; cycle <= c_end; cycle++) {
+		cnt++;
+		s_id = ((cycle - 1) % slot_pair) * 2;
+
+		if (cnt % divide_cnt == 1) {
+			if (a2dp->exist)
+				p += scnprintf(p, end - p, "\n %-15s : ",
+					       "[slotT_wermtan]");
+			else
+				p += scnprintf(p, end - p, "\n %-15s : ",
+					       "[slotT_rxerr]");
+		}
+
+		p += scnprintf(p, end - p, "->b%d",
+			       le16_to_cpu(pcysta->slot_step_time[s_id]));
+
+		if (a2dp->exist)
+			p += scnprintf(p, end - p, "(%d/%d/%d/%dM/%d/%d/%d)",
+				       pcysta->wl_rx_err_ratio[s_id],
+				       pcysta->a2dp_trx[s_id].empty_cnt,
+				       pcysta->a2dp_trx[s_id].retry_cnt,
+				       (pcysta->a2dp_trx[s_id].tx_rate ? 3 : 2),
+				       pcysta->a2dp_trx[s_id].tx_cnt,
+				       pcysta->a2dp_trx[s_id].ack_cnt,
+				       pcysta->a2dp_trx[s_id].nack_cnt);
+		else
+			p += scnprintf(p, end - p, "(%d)",
+				       pcysta->wl_rx_err_ratio[s_id]);
+
+		p += scnprintf(p, end - p, "->w%d",
+			       le16_to_cpu(pcysta->slot_step_time[s_id + 1]));
+
+		if (a2dp->exist)
+			p += scnprintf(p, end - p, "(%d/%d/%d/%dM/%d/%d/%d)",
+				       pcysta->wl_rx_err_ratio[s_id + 1],
+				       pcysta->a2dp_trx[s_id + 1].empty_cnt,
+				       pcysta->a2dp_trx[s_id + 1].retry_cnt,
+				       (pcysta->a2dp_trx[s_id + 1].tx_rate ? 3 : 2),
+				       pcysta->a2dp_trx[s_id + 1].tx_cnt,
+				       pcysta->a2dp_trx[s_id + 1].ack_cnt,
+				       pcysta->a2dp_trx[s_id + 1].nack_cnt);
+		else
+			p += scnprintf(p, end - p, "(%d)",
+				       pcysta->wl_rx_err_ratio[s_id + 1]);
+	}
+
+out:
+	return p - buf;
+}
+
 static int _show_fbtc_nullsta(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -11901,6 +12098,8 @@ static int _show_fw_dm_msg(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		p += _show_fbtc_cysta_v105(rtwdev, p, end - p);
 	else if (ver->fcxcysta == 7)
 		p += _show_fbtc_cysta_v7(rtwdev, p, end - p);
+	else if (ver->fcxcysta == 8)
+		p += _show_fbtc_cysta_v8(rtwdev, p, end - p);
 
 	p += _show_fbtc_nullsta(rtwdev, p, end - p);
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 2e6d1be3a751..d1678a8b5872 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3665,6 +3665,31 @@ struct rtw89_btc_fbtc_cysta_v7 { /* statistics for cycles */
 	__le32 except_map;
 } __packed;
 
+struct rtw89_btc_fbtc_cysta_v8 { /* statistics for cycles */
+	u8 fver;
+	u8 rsvd;
+	u8 collision_cnt; /* counter for event/timer at the same time */
+	u8 except_cnt;
+
+	u8 wl_rx_err_ratio[BTC_CYCLE_SLOT_MAX];
+
+	struct rtw89_btc_fbtc_a2dp_trx_stat_v4 a2dp_trx[BTC_CYCLE_SLOT_MAX];
+
+	__le16 skip_cnt;
+	__le16 cycles; /* total cycle number */
+	__le16 rsvd1;
+
+	__le16 slot_step_time[BTC_CYCLE_SLOT_MAX]; /* record the wl/bt slot time */
+	__le16 slot_cnt[CXST_MAX]; /* slot count */
+	__le16 bcn_cnt[5]; /* CXBCN_BT_PROTECT_OK added in v8 */
+
+	struct rtw89_btc_fbtc_cycle_time_info_v5 cycle_time;
+	struct rtw89_btc_fbtc_cycle_a2dp_empty_info a2dp_ept;
+	struct rtw89_btc_fbtc_cycle_leak_info_v7 leak_slot;
+
+	__le32 except_map;
+} __packed;
+
 union rtw89_btc_fbtc_cysta_info {
 	struct rtw89_btc_fbtc_cysta_v2 v2;
 	struct rtw89_btc_fbtc_cysta_v3 v3;
@@ -3672,6 +3697,7 @@ union rtw89_btc_fbtc_cysta_info {
 	struct rtw89_btc_fbtc_cysta_v5 v5;
 	struct rtw89_btc_fbtc_cysta_v105 v105;
 	struct rtw89_btc_fbtc_cysta_v7 v7;
+	struct rtw89_btc_fbtc_cysta_v8 v8;
 };
 
 struct rtw89_btc_fbtc_cynullsta_v1 { /* cycle null statistics */
-- 
2.25.1

