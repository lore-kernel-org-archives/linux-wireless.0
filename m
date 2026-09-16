Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD405463B66
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543495; cv=none; b=tH3iJBrTkw0Wheb3q4fLkaq5kbFjS9TdpZPy/Oag2cx4hxdcoHzv8oaNz7mZKATvOEB7wmHzpmXq1S0oOi1qWLIuMGWuaWtzm4Rd+SXLUdtmwGD6McQQA1WOpoM1O1yszzyHt6VIuQCAUkyTIlaBM4kKr/dtY3BLTBIHJ97wlg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543495; c=relaxed/simple;
	bh=9/PZnKOfI88iSxsQrFbOogZ3fz8DsMCNbCYxfvuy2R0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R73pI6yACajNB+tfMTfzIUwNj7RPhKHzdZ59/FItGFOH6DzD8GMMWejExg/rxYqAqX4e2QfXRH5DWqSTlLdOe0ssG3kVKt2V7zZxmYxqC0a5GrmL8+qOnXHLn+AO5r1DFcv9sDTDgHJIvQCZ7In2acATAoJ4NQCmvRNH0F7KB1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=TUwxorA8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="TUwxorA8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7OXekC2168648, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543473; bh=DWim1iAzzct+1DQKHPbPC+aqNcPum32K5kfRvwqw9ME=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=TUwxorA82pfNEZkkDE3y1MRZVF8YmgnRgTF8XJS02exNd8LI60Bevt59K5GrmR3CK
	 ha0/PCW23mPH01w86WUBFQBpPIL0Lma6hRW6fyJIcsx7Vkp0caOdlk+D+WOmpZwfa+
	 QfrEhUdSlTqaWpMtwTUWTLBAN4rG2GYcPlbXJpsGZVj0ntiNA3E8L1P7tLixD+mWJe
	 vJxCjzObStMBCawBGwetcahld6EpY1qDvlB+VqDysUgDr0ezEN52gwBrSEewrfnF+z
	 v9Heg0jpFptU/kIlepdRle4+gFk3TKtWmLych5sikkZ1CYF+gF/BI7U07CPQpMs911
	 zeNjPQHn6HuHA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7OXekC2168648
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:24:33 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:32 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:24:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:24:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 15/15] wifi: rtw89: coex: add AFH conflict detection on BT AFH report
Date: Wed, 16 Sep 2026 15:22:38 +0800
Message-ID: <20260916072238.62574-16-pkshih@realtek.com>
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

Extend the BTC_RPT_TYPE_BT_AFH handler to detect overlap between the BT
AFH channel map and the WL 2.4 GHz channels in use. On each legacy AFH map
update the legacy conflict counter and error flag are reset and the AFH
update counter is advanced, then the 12-byte legacy AFH map is scanned
against wl->ch_map[] to count conflicting and total channels and set the
bt_afh_conflict error flag. The LE path mirrors this: on each LE map
update the LE conflict counter and error flag are reset and the LE
update counter advanced, then the 5-byte LE AFH map is scanned against
wl->ch_map_le[] to set the bt_leafh_conflict error flag.

Both checks are gated by afh_en (WL 2.4 GHz AFH active) and by BT
connection state (legacy: connect, LE: ble_connect or leaudio BIS/CIS).
They are applied in all versioned branches (fcxbtafh 2/7/8) via a shared
helper; fcxbtafh==1 has no map_type field, so conflict detection is
skipped there.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 66 +++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 7cced933688b..305d8edb0d4d 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1604,6 +1604,69 @@ static void _chk_btc_err(struct rtw89_dev *rtwdev, u8 type, u32 cnt)
 	}
 }
 
+static void _update_bt_afh_conflict(struct rtw89_dev *rtwdev,
+				    struct rtw89_btc_bt_info *bt,
+				    u8 map_type)
+{
+	struct rtw89_btc *btc = &rtwdev->btc;
+	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
+	struct rtw89_btc_dm *dm = &btc->dm;
+	struct rtw89_btc_bt_link_info *b = &bt->link_info;
+	struct rtw89_btc_bt_leaudio_desc *leaudio = &b->leaudio_desc;
+	u8 hw_band = wl->role_info.pta_req_band;
+	u32 cnt, cnt_ch, cnt_le, cnt_ch_le;
+	u8 i, omap, xmap, afh_en;
+
+	if (map_type & RPT_BT_AFH_SEQ_LEGACY) {
+		bt->bcnt[BTC_BCNT_AFH_UPDATE]++;
+		bt->bcnt[BTC_BCNT_AFH_CONFLICT] = 0;
+		dm->error.map.bt_afh_conflict = 0;
+	}
+
+	afh_en = wl->afh_info[hw_band][RTW89_BAND_2G].en;
+
+	for (i = 0; i < 12; i++) {
+		if (!(map_type & RPT_BT_AFH_SEQ_LEGACY) ||
+		    !b->status.map.connect)
+			break;
+
+		omap = b->afh_map[i];
+		xmap = omap & wl->ch_map[i];
+		cnt_ch = hweight8(omap);
+		cnt = afh_en ? hweight8(xmap) : 0;
+
+		if (i == 11) {
+			bt->bcnt[BTC_BCNT_AFH_CHN] = cnt_ch;
+			bt->bcnt[BTC_BCNT_AFH_CONFLICT] = cnt;
+			dm->error.map.bt_afh_conflict = !!cnt;
+		}
+	}
+
+	if (map_type & RPT_BT_AFH_SEQ_LE) {
+		bt->bcnt[BTC_BCNT_AFH_LE_UPDATE]++;
+		bt->bcnt[BTC_BCNT_AFH_LE_CONFLICT] = 0;
+		dm->error.map.bt_leafh_conflict = 0;
+	}
+
+	for (i = 0; i < 5; i++) {
+		if (!(map_type & RPT_BT_AFH_SEQ_LE) ||
+		    (!b->status.map.ble_connect &&
+		     !leaudio->bis_exist && !leaudio->cis_exist))
+			break;
+
+		omap = b->afh_map_le[i];
+		xmap = omap & wl->ch_map_le[i];
+		cnt_ch_le = hweight8(omap);
+		cnt_le = afh_en ? hweight8(xmap) : 0;
+
+		if (i == 4) {
+			bt->bcnt[BTC_BCNT_AFH_LE_CHN] = cnt_ch_le;
+			bt->bcnt[BTC_BCNT_AFH_LE_CONFLICT] = cnt_le;
+			dm->error.map.bt_leafh_conflict = !!cnt_le;
+		}
+	}
+}
+
 static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -1704,6 +1767,7 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 				memcpy(&bt_linfo->afh_map_le[0], pafh_v2->afh_le_a, 4);
 				memcpy(&bt_linfo->afh_map_le[4], pafh_v2->afh_le_b, 1);
 			}
+			_update_bt_afh_conflict(rtwdev, bt, pafh_v2->map_type);
 		} else if (ver->fcxbtafh == 7) {
 			pafh_v7 = (struct rtw89_btc_fbtc_btafh_v7 *)pfinfo;
 			if (pafh_v7->map_type & RPT_BT_AFH_SEQ_LEGACY) {
@@ -1715,6 +1779,7 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 				memcpy(&bt_linfo->afh_map_le[0], pafh_v7->afh_le_a, 4);
 				memcpy(&bt_linfo->afh_map_le[4], pafh_v7->afh_le_b, 1);
 			}
+			_update_bt_afh_conflict(rtwdev, bt, pafh_v7->map_type);
 		} else if (ver->fcxbtafh == 8) {
 			struct rtw89_btc_fbtc_btafh_v8 *pafh_v8 =
 				(struct rtw89_btc_fbtc_btafh_v8 *)pfinfo;
@@ -1731,6 +1796,7 @@ static void _update_bt_report(struct rtw89_dev *rtwdev, u8 rpt_type, u8 *pfinfo)
 				memcpy(&tbt_linfo->afh_map_le[0], pafh_v8->afh_le_a, 4);
 				memcpy(&tbt_linfo->afh_map_le[4], pafh_v8->afh_le_b, 1);
 			}
+			_update_bt_afh_conflict(rtwdev, tbt, pafh_v8->map_type);
 		} else if (ver->fcxbtafh == 1) {
 			pafh_v1 = (struct rtw89_btc_fbtc_btafh *)pfinfo;
 			memcpy(&bt_linfo->afh_map[0], pafh_v1->afh_l, 4);
-- 
2.25.1

