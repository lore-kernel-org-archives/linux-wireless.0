Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27844071E5
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543491; cv=none; b=DdTsmFWYhnJEkawBn6SCSAGFtsL1hawz6HLqGmIY0SyFvhlq3Lhr7lbMejEkG3wxCGtfNQOosMJMJ9bdKtl7t4f5gh0VLP+qVbUq5dwlj+/UsJUlBl3Xj94q3nLaZK2VL7F9HA6Om4kL2KnJelIh10FncMAhYK3l6jM1QJhgcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543491; c=relaxed/simple;
	bh=KvMfu2kvsAUrk1Yjw5yF/yxH39WUvieFW6AmFM5ZHBI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=joZjOy9CKOJ5kpKs1AVwufCpD7CeHIeu/avA1+N12h5gusYfv3tQ050VK+lE7FHv//yTyhLy5jn2O/Ioa+awg51bGVx8cU++TTSWTKJSRfAdk/rF7rUG+9gfOtY3jLehp9TdzB8e5eL6NX97UNN3wyDkA2FAZQ478P7M+QpFLyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=kfn9pMwS; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="kfn9pMwS"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7ORJh82168630, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543467; bh=FXo0JzmacIrhYLMi+tO6s5xSXTa+lTfl6zb+WTzQHkY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=kfn9pMwSd+BGU2/ehlN7XLF0vn6EZ7POP2o2p114u4kTkahHdDhabprLwBAvgSStZ
	 ZnYD8+jD9eaJWFYUAxRC+vUcl1qOO9TfmXT5xAoApsCOzd39uQW5NxGN3Oj46n9nC/
	 6EjjjRZF7vU54pcsO76PoQArcEnRYtWIH9+wzPcHpOMQyWlWfEPm2axKaHou4SDPIV
	 aJsFBpP9p+I5bWmqg7ibBdpxSQQV1OdgVdlWVrnISSlv9AaJ4cI1jIxJJ3NqnM6lOn
	 NSNo2COUHOdH4hWZyT8Kyjoofk+D+LhpIjsprx4YVzmlc7C2rIG2DaDhdjW1qTwyGk
	 Y3HilC2p4/Szg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7ORJh82168630
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:24:27 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:27 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:24:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 14/15] wifi: rtw89: coex: detect BT slot flood via A2DP empty-streak in cysta
Date: Wed, 16 Sep 2026 15:22:37 +0800
Message-ID: <20260916072238.62574-15-pkshih@realtek.com>
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

Add a BTC_DCNT_BT_SLOT_FLOOD error check driven from the cysta
(fcxcysta v7) report. It walks the most recent TDMA cycles, bounded to
one BTC_CYCLE_SLOT_MAX window of wl/bt slot pairs, and is only evaluated
in AUTO/AUTO2 or ext-control TDMA modes once enough cycles have
accumulated; otherwise the counters and error flag are cleared.

For each cycle the BT slot step time is compared against the
dm->bt_slot_flood threshold, increasing BTC_DCNT_BT_SLOT_FLOOD and
raising the bt_slot_flood error flag when BT monopolises the medium. In
the same pass the run of consecutive slots with no A2DP empty count is
measured and stored in the a2dp descriptor as no_empty_streak_2s, with
the running maximum kept in no_empty_streak_max.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 51 +++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index f88431a0db87..7cced933688b 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1324,11 +1324,15 @@ static void _chk_btc_err(struct rtw89_dev *rtwdev, u8 type, u32 cnt)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
 	union rtw89_btc_fbtc_cynullsta_info *ns = &btc->fwinfo.rpt_fbtc_nullsta.finfo;
+	union rtw89_btc_fbtc_cysta_info *pcysta = &btc->fwinfo.rpt_fbtc_cysta.finfo;
 	struct rtw89_btc_cx *cx = &btc->cx;
 	struct rtw89_btc_bt_info *bt = &cx->bt0;
+	struct rtw89_btc_bt_a2dp_desc *a2dp = &bt->link_info.a2dp_desc;
 	struct rtw89_btc_wl_info *wl = &cx->wl;
 	struct rtw89_btc_dm *dm = &btc->dm;
 	const struct rtw89_btc_ver *ver = btc->ver;
+	u32 empty_streak = 0, empty_streak_max = 0;
+	u32 slot_pair, c_begin, c_end, cycle, s_id;
 	u32 tx_cnt, late, ok;
 
 	rtw89_debug(rtwdev, RTW89_DBG_BTC,
@@ -1485,6 +1489,53 @@ static void _chk_btc_err(struct rtw89_dev *rtwdev, u8 type, u32 cnt)
 			dm->error.map.bt_slot_drift = false;
 
 		break;
+	case BTC_DCNT_BT_SLOT_FLOOD:
+		if (!btc->fwinfo.rpt_fbtc_cysta.cinfo.valid ||
+		    dm->cnt_dm[BTC_DCNT_CYCLE] == cnt)
+			break;
+
+		if (cnt < BTC_CYCLE_SLOT_MAX ||
+		    (dm->tdma_now.type != CXTDMA_AUTO &&
+		     dm->tdma_now.type != CXTDMA_AUTO2 &&
+		     dm->tdma_now.ext_ctrl != CXECTL_EXT)) {
+			dm->error.map.bt_slot_flood = false;
+			dm->cnt_dm[BTC_DCNT_BT_SLOT_FLOOD] = 0;
+			a2dp->no_empty_streak_2s = 0;
+			a2dp->no_empty_streak_max = 0;
+			break;
+		}
+
+		/* 1 cycle = 1 wl-slot + 1 bt-slot */
+		slot_pair = BTC_CYCLE_SLOT_MAX / 2;
+		if (cnt - dm->cnt_dm[BTC_DCNT_CYCLE] > slot_pair)
+			c_begin = cnt - slot_pair + 1;
+		else
+			c_begin = dm->cnt_dm[BTC_DCNT_CYCLE] + 1;
+
+		c_end = cnt;
+		for (cycle = c_begin; cycle <= c_end; cycle++) {
+			s_id = ((cycle - 1) % slot_pair) * 2;
+			if (le16_to_cpu(pcysta->v7.slot_step_time[s_id]) >=
+			    dm->bt_slot_flood)
+				dm->cnt_dm[BTC_DCNT_BT_SLOT_FLOOD]++;
+			/* calculate no-A2DP-empty streak count */
+			if (pcysta->v7.a2dp_trx[s_id].empty_cnt == 0 &&
+			    pcysta->v7.a2dp_trx[s_id + 1].empty_cnt == 0) {
+				empty_streak++;
+				if (empty_streak > empty_streak_max)
+					empty_streak_max = empty_streak;
+			} else {
+				empty_streak = 0;
+			}
+		}
+
+		a2dp->no_empty_streak_2s = empty_streak_max;
+		if (a2dp->no_empty_streak_2s > a2dp->no_empty_streak_max)
+			a2dp->no_empty_streak_max = a2dp->no_empty_streak_2s;
+
+		dm->error.map.bt_slot_flood =
+			!!dm->cnt_dm[BTC_DCNT_BT_SLOT_FLOOD];
+		break;
 	case BTC_DCNT_WL_STA_NTFY:
 		cnt = dm->cnt_notify[BTC_NCNT_WL_STA] -
 		      dm->cnt_notify[BTC_NCNT_WL_STA_LAST];
-- 
2.25.1

