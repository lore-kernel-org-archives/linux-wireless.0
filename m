Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0173D34BB
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271584; cv=none; b=HNeWz2/kJZkxRwoXwM+goZ4FrZxiscavkEtnQneW0FGyLkCHYDDVGG8WtwsZrwbcvvRRmfxV1u5QDBM9FyDI8Madr6fLlIlMxAx01APDKZkd9UsbY7DpY2AGQT8dgjEVGH2LNo2QzAEso7HvRluMiWkxhqxLgBl2KZeuqMtKuaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271584; c=relaxed/simple;
	bh=TujXmUa0gTBdsKoT953EYDrG1CqFPX84ApmghTbIvkg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tW318TkDQXtkGkGgOEBmc3uTpr/0JwLvoo/EkFAIqHve9c15cQHqiw7/DPequF1SEPVbbnAbO2gcgLtWlrfQ3c0BP9u6t6nlqdMcuwb4scdt4DrZtGInKTmTWuYo8nEyGRgFRzCeUIr6EGHj2aBqcpwEILUZ+RZNvzkyf9OapEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=FZ1FFGIN; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="FZ1FFGIN"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xeG034177016, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271580; bh=8ttAZeyDi+PKVaon3ddtnuMsKYzUOlUI9ZT+xG1gg+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=FZ1FFGIN4j8RkCZI1yfyqBLqNH3PHPxB6xQKdN0F7mNzXb0zYgOfwCwuOaLmqkVz8
	 l04gjyoEDcGHJxz/fmyKJVXee2JzZnKRhfLXPDnRXqJJdAVFzub79fExxUMG+F4WM7
	 wdHTGcPAkvmScBVN4LG/DGATb6z3M3yKSwCvp+2ZLMR150DGPuH8Dd3k5WnByZbVDX
	 Xu0SfMEqqTSccp+56UJVYOZOKi7yit0jUTUOTAcetJ0JcDj2ySQNqH9Oo9RIzgvJpV
	 xuIUBJoCKoynAq+/hpvI1smJ75zSjoOW0g09NiaeYccN6czj1yuzD6vgQKfw0HCdNU
	 Hg4Ztl6CchW3A==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xeG034177016
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:40 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:40 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:40 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 11/13] wifi: rtw89: coex: Add cycle status report version 105
Date: Fri, 17 Jul 2026 14:57:37 +0800
Message-ID: <20260717065739.64124-12-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717065739.64124-1-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The exists version 5 format has FDDT(frequency divided training) related
information. But the feature wasn't support for RTL8852C now, so firmware
will not send the related reference value.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 197 ++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/core.h |  21 +++
 2 files changed, 218 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 65d4e9139342..54c11af46f8d 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1757,6 +1757,11 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pcysta->v5 = pfwinfo->rpt_fbtc_cysta.finfo.v5;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_cysta.finfo.v5);
 			fwsubver->fcxcysta = pfwinfo->rpt_fbtc_cysta.finfo.v5.fver;
+		} else if (ver->fcxcysta == 105) {
+			pfinfo = &pfwinfo->rpt_fbtc_cysta.finfo.v105;
+			pcysta->v105 = pfwinfo->rpt_fbtc_cysta.finfo.v105;
+			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_cysta.finfo.v105);
+			fwsubver->fcxcysta = pfwinfo->rpt_fbtc_cysta.finfo.v105.fver;
 		} else if (ver->fcxcysta == 7) {
 			pfinfo = &pfwinfo->rpt_fbtc_cysta.finfo.v7;
 			pcysta->v7 = pfwinfo->rpt_fbtc_cysta.finfo.v7;
@@ -2434,6 +2439,58 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 				     le16_to_cpu(pcysta->v5.slot_cnt[CXST_B1]));
 			_chk_btc_err(rtwdev, BTC_DCNT_CYCLE_HANG,
 				     le16_to_cpu(pcysta->v5.cycles));
+		} else if (ver->fcxcysta == 105) {
+			if (dm->fddt_train == BTC_FDDT_ENABLE)
+				break;
+
+			cnt_leak_slot = le16_to_cpu(pcysta->v105.slot_cnt[CXST_LK]);
+			cnt_rx_imr = le32_to_cpu(pcysta->v105.leak_slot.cnt_rximr);
+
+			/* Check Leak-AP */
+			if (cnt_leak_slot != 0 && cnt_rx_imr != 0 &&
+			    dm->tdma_now.rxflctrl) {
+				if (le16_to_cpu(pcysta->v5.cycles) >= BTC_CYSTA_CHK_PERIOD &&
+				    cnt_leak_slot < BTC_LEAK_AP_TH * cnt_rx_imr)
+					dm->leak_ap = 1;
+			}
+
+			/* Check diff time between real WL slot and W1 slot */
+			if (dm->tdma_now.type == CXTDMA_OFF) {
+				if (ver->fcxslots == 1)
+					wl_slot_set = le16_to_cpu(dm->slot_now.v1[CXST_W1].dur);
+				else if (ver->fcxslots == 7)
+					wl_slot_set = le16_to_cpu(dm->slot_now.v7[CXST_W1].dur);
+				wl_slot_real = le16_to_cpu(pcysta->v105.cycle_time.tavg[CXT_WL]);
+
+				if (wl_slot_real > wl_slot_set)
+					diff_t = wl_slot_real - wl_slot_set;
+				else
+					diff_t = wl_slot_set - wl_slot_real;
+			}
+			_chk_btc_err(rtwdev, BTC_DCNT_WL_SLOT_DRIFT, diff_t);
+
+			/* Check diff time between real BT slot and EBT/E5G slot */
+			bt_slot_set = btc->bt_req_len[RTW89_PHY_0];
+			bt_slot_real = le16_to_cpu(pcysta->v105.cycle_time.tavg[CXT_BT]);
+			diff_t = 0;
+			if (dm->tdma_now.type == CXTDMA_OFF &&
+			    dm->tdma_now.ext_ctrl == CXECTL_EXT &&
+			    bt_slot_set != 0) {
+				if (bt_slot_set > bt_slot_real)
+					diff_t = bt_slot_set - bt_slot_real;
+				else
+					diff_t = bt_slot_real - bt_slot_set;
+			}
+
+			_chk_btc_err(rtwdev, BTC_DCNT_BT_SLOT_DRIFT, diff_t);
+			_chk_btc_err(rtwdev, BTC_DCNT_E2G_HANG,
+				     le16_to_cpu(pcysta->v105.slot_cnt[CXST_E2G]));
+			_chk_btc_err(rtwdev, BTC_DCNT_W1_HANG,
+				     le16_to_cpu(pcysta->v105.slot_cnt[CXST_W1]));
+			_chk_btc_err(rtwdev, BTC_DCNT_B1_HANG,
+				     le16_to_cpu(pcysta->v105.slot_cnt[CXST_B1]));
+			_chk_btc_err(rtwdev, BTC_DCNT_CYCLE_HANG,
+				     le16_to_cpu(pcysta->v105.cycles));
 		} else if (ver->fcxcysta == 7) {
 			if (dm->fddt_train == BTC_FDDT_ENABLE)
 				break;
@@ -10690,6 +10747,144 @@ static int _show_fbtc_cysta_v5(struct rtw89_dev *rtwdev, char *buf, size_t bufsz
 	return p - buf;
 }
 
+static int _show_fbtc_cysta_v105(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_bt_a2dp_desc *a2dp = &btc->cx.bt0.link_info.a2dp_desc;
+	struct rtw89_btc_btf_fwinfo *pfwinfo = &btc->fwinfo;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_fbtc_a2dp_trx_stat_v4 *a2dp_trx;
+	struct rtw89_btc_fbtc_cysta_v105 *pcysta;
+	struct rtw89_btc_rpt_cmn_info *pcinfo;
+	u8 i, cnt = 0, slot_pair, divide_cnt;
+	u16 cycle, c_begin, c_end, store_index;
+	char *p = buf, *end = buf + bufsz;
+
+	pcinfo = &pfwinfo->rpt_fbtc_cysta.cinfo;
+	if (!pcinfo->valid)
+		return 0;
+
+	pcysta = &pfwinfo->rpt_fbtc_cysta.finfo.v105;
+	p += scnprintf(p, end - p,
+		       " %-15s : cycle:%d, bcn[all:%d/all_ok:%d/bt:%d/bt_ok:%d]",
+		       "[cycle_cnt]",
+		       le16_to_cpu(pcysta->cycles),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_ALL]),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_ALL_OK]),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_BT_SLOT]),
+		       le16_to_cpu(pcysta->bcn_cnt[CXBCN_BT_OK]));
+
+	for (i = 0; i < CXST_MAX; i++) {
+		if (!le16_to_cpu(pcysta->slot_cnt[i]))
+			continue;
+
+		p += scnprintf(p, end - p, ", %s:%d", id_to_slot(i),
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
+	if (le16_to_cpu(pcysta->skip_cnt))
+		p += scnprintf(p, end - p, ", skip:%d",
+			       le16_to_cpu(pcysta->skip_cnt));
+
+	p += scnprintf(p, end - p, "\n");
+
+	p += scnprintf(p, end - p, " %-15s : avg_t[wl:%d/bt:%d/lk:%d.%03d]",
+		       "[cycle_time]",
+		       le16_to_cpu(pcysta->cycle_time.tavg[CXT_WL]),
+		       le16_to_cpu(pcysta->cycle_time.tavg[CXT_BT]),
+		       le16_to_cpu(pcysta->leak_slot.tavg) / 1000,
+		       le16_to_cpu(pcysta->leak_slot.tavg) % 1000);
+	p += scnprintf(p, end - p,
+		       ", max_t[wl:%d/bt:%d/lk:%d.%03d]\n",
+		       le16_to_cpu(pcysta->cycle_time.tmax[CXT_WL]),
+		       le16_to_cpu(pcysta->cycle_time.tmax[CXT_BT]),
+		       le16_to_cpu(pcysta->leak_slot.tmax) / 1000,
+		       le16_to_cpu(pcysta->leak_slot.tmax) % 1000);
+
+	cycle = le16_to_cpu(pcysta->cycles);
+	if (cycle <= 1)
+		goto out;
+
+	/* 1 cycle record 1 wl-slot and 1 bt-slot */
+	slot_pair = BTC_CYCLE_SLOT_MAX / 2;
+
+	if (cycle <= slot_pair)
+		c_begin = 1;
+	else
+		c_begin = cycle - slot_pair + 1;
+
+	c_end = cycle;
+
+	if (a2dp->exist)
+		divide_cnt = 3;
+	else
+		divide_cnt = BTC_CYCLE_SLOT_MAX / 4;
+
+	if (c_begin > c_end)
+		goto out;
+
+	for (cycle = c_begin; cycle <= c_end; cycle++) {
+		cnt++;
+		store_index = ((cycle - 1) % slot_pair) * 2;
+
+		if (cnt % divide_cnt == 1)
+			p += scnprintf(p, end - p, " %-15s : ",
+				       "[cycle_step]");
+
+		p += scnprintf(p, end - p, "->b%02d",
+			       le16_to_cpu(pcysta->slot_step_time[store_index]));
+		if (a2dp->exist) {
+			a2dp_trx = &pcysta->a2dp_trx[store_index];
+			p += scnprintf(p, end - p, "(%d/%d/%dM/%d/%d/%d)",
+				       a2dp_trx->empty_cnt,
+				       a2dp_trx->retry_cnt,
+				       a2dp_trx->tx_rate ? 3 : 2,
+				       a2dp_trx->tx_cnt,
+				       a2dp_trx->ack_cnt,
+				       a2dp_trx->nack_cnt);
+		}
+		p += scnprintf(p, end - p, "->w%02d",
+			       le16_to_cpu(pcysta->slot_step_time[store_index + 1]));
+		if (a2dp->exist) {
+			a2dp_trx = &pcysta->a2dp_trx[store_index + 1];
+			p += scnprintf(p, end - p, "(%d/%d/%dM/%d/%d/%d)",
+				       a2dp_trx->empty_cnt,
+				       a2dp_trx->retry_cnt,
+				       a2dp_trx->tx_rate ? 3 : 2,
+				       a2dp_trx->tx_cnt,
+				       a2dp_trx->ack_cnt,
+				       a2dp_trx->nack_cnt);
+		}
+		if (cnt % divide_cnt == 0 || cnt == c_end)
+			p += scnprintf(p, end - p, "\n");
+	}
+
+	if (a2dp->exist) {
+		p += scnprintf(p, end - p,
+			       " %-15s : a2dp_ept:%d, a2dp_late:%d",
+			       "[a2dp_t_sta]",
+			       le16_to_cpu(pcysta->a2dp_ept.cnt),
+			       le16_to_cpu(pcysta->a2dp_ept.cnt_timeout));
+
+		p += scnprintf(p, end - p, ", avg_t:%d, max_t:%d",
+			       le16_to_cpu(pcysta->a2dp_ept.tavg),
+			       le16_to_cpu(pcysta->a2dp_ept.tmax));
+
+		p += scnprintf(p, end - p, "\n");
+	}
+
+out:
+	return p - buf;
+}
+
 static int _show_fbtc_cysta_v7(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 {
 	struct rtw89_btc_bt_info *bt = &rtwdev->btc.cx.bt0;
@@ -11081,6 +11276,8 @@ static int _show_fw_dm_msg(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		p += _show_fbtc_cysta_v4(rtwdev, p, end - p);
 	else if (ver->fcxcysta == 5)
 		p += _show_fbtc_cysta_v5(rtwdev, p, end - p);
+	else if (ver->fcxcysta == 105)
+		p += _show_fbtc_cysta_v105(rtwdev, p, end - p);
 	else if (ver->fcxcysta == 7)
 		p += _show_fbtc_cysta_v7(rtwdev, p, end - p);
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 5018c642dba0..7627b5ebabda 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -3352,6 +3352,26 @@ struct rtw89_btc_fbtc_cysta_v5 { /* statistics for cycles */
 	__le32 except_map;
 } __packed;
 
+struct rtw89_btc_fbtc_cysta_v105 {
+	u8 fver;
+	u8 rsvd;
+	u8 collision_cnt;
+	u8 except_cnt;
+	u8 wl_rx_err_ratio[BTC_CYCLE_SLOT_MAX];
+
+	__le16 skip_cnt;
+	__le16 cycles;
+
+	__le16 slot_step_time[BTC_CYCLE_SLOT_MAX];
+	__le16 slot_cnt[CXST_MAX];
+	__le16 bcn_cnt[CXBCN_MAX];
+	struct rtw89_btc_fbtc_cycle_time_info_v5 cycle_time;
+	struct rtw89_btc_fbtc_cycle_leak_info leak_slot;
+	struct rtw89_btc_fbtc_cycle_a2dp_empty_info a2dp_ept;
+	struct rtw89_btc_fbtc_a2dp_trx_stat_v4 a2dp_trx[BTC_CYCLE_SLOT_MAX];
+	__le32 except_map;
+} __packed;
+
 struct rtw89_btc_fbtc_cysta_v7 { /* statistics for cycles */
 	u8 fver;
 	u8 rsvd;
@@ -3381,6 +3401,7 @@ union rtw89_btc_fbtc_cysta_info {
 	struct rtw89_btc_fbtc_cysta_v3 v3;
 	struct rtw89_btc_fbtc_cysta_v4 v4;
 	struct rtw89_btc_fbtc_cysta_v5 v5;
+	struct rtw89_btc_fbtc_cysta_v105 v105;
 	struct rtw89_btc_fbtc_cysta_v7 v7;
 };
 
-- 
2.25.1

