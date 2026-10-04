Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65A3E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085643; cv=none; b=pjwheF65Y30rBJjmM9ZJUFOBJGaf8EN65jUT/51DFGdlCvnlTzkS9S36o4wzuDZQZ6bXpQBbAqHawpFiRQTLPZd0gfShXLp1U+mHZjABrINlEl7OypoPRUBc0a8vmpiVncUfOzvV/RykBF672ctgBll90LFjUP02IJcSDIFxhq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085643; c=relaxed/simple;
	bh=w59zYJoGMLiLf9cOz+G11SpY2myYmFl5TgjV1tk1pIE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XTUfjdiDl0/2QmqjSaW5kfyI0u3EjOFX8X8WVj3tUK9BegnpaCDa9BRsMpjvq5kFxYKg9wva9jYHNqjh43jB6g7YAfHSOdKDQIJ9dbsXieF+VkkmoYYIzb+wmqk4MFAclwpKah+P/Az5a7TQJ/Vj/2SJ5TixCaLOu3qqcc+nuB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NoVfkYZH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NoVfkYZH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943lJPi9829671, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085639; bh=WR4QBB3tnZ1T4JBW9cyrJP88FSBDObjoTD0b0wi6r5g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=NoVfkYZHwbF0A2oTYeWGN3+usucCLwgGUn5CHwanJN0QrDNSmxWwSzdWleCI+RTHY
	 hF2J08pxEY6wak0Ylm2oqSksb7B6SpceRvIXDOA0y9cy0ci3S6H8tGTU2Gjh9l2uwL
	 uiUE2vK/+SvykmgdS3uzm3zSVxkCvEoMxtehfMYK5lzFMGmbqcDfh1WmK7lup2AlqW
	 NLWwjycRgfncexze/kYb4nFOc0kPBouuoph5d7YOKOFPlPNGsqaJWSWN+7QuuD+YWl
	 l7qqe97bHOkKIpzh/r2/7JVoc1rW1CJlk8K3DTlxP9xA561fXFV9a3qRX39AEfhM5V
	 uTZmN5TYl5mVg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943lJPi9829671
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:47:19 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:47:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 14/15] wifi: rtw89: coex: turn BT TX/RX on and off through the BTG control
Date: Sun, 4 Oct 2026 11:45:19 +0800
Message-ID: <20261004034520.33695-15-pkshih@realtek.com>
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

Nothing drives the BTG control that turns the BT TX/RX on and off, so the
BT keeps transmitting and receiving even where COEX already knows it is
not in use, and WL takes interference it does not have to.

Program it from the BT enable state coex already maintains, which is the
same value reported to the firmware, so a driver-side write and a
firmware-side one always agree. This matters for the BT-only case, where
that state is forced to enable both BT while the per-BT enable may still
be clear.

That report was not actually reaching the firmware. The control
information is sent only when it differs from what was sent last, but
the comparison is inverted, so an unchanged run sends a redundant
command while a real change is dropped. Drop the inversion, so the
state programmed here is the state the firmware is told about.

Each BT keeps its own shadow of what was programmed and of whether that
is trustworthy, rather than writing on a change of the enable state. A
change is a one-shot edge, so an RF write the lower layer refuses would
never be retried, and an offloaded write can be refused for reasons coex
cannot see. The shadow is dropped on init and on a radio-state change
since the RF may have been re-initialized, and compared on every run so
that a redundant write is suppressed without losing the retry. Skip the
whole thing while the RF is off, and on chips with a single BT, which do
not drive this control from the driver side.

Report the state and the shadow in the coex mechanism-status dump.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 81 +++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/core.h |  2 +
 2 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index c25bc9e619ce..9107a6c8c6fc 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -8910,6 +8910,59 @@ static void _update_sdm_map(struct rtw89_dev *rtwdev)
 	memcpy(dm->sit_xmap, map, sizeof(map));
 }
 
+static void _set_bttrx_en(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_btc_wl_smap *wl_smap = &rtwdev->btc.cx.wl.status.map;
+	struct rtw89_btc_dm *dm = &rtwdev->btc.dm;
+	u8 state = dm->ost_info.bt_enable_state;
+	u8 i, want, done;
+
+	/* only dual-BT chips drive the BT TX/RX enable from the driver */
+	if (!(rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT))
+		return;
+
+	/*
+	 * RF is not accessible, leave the shadow alone. Leaving this state is
+	 * a radio-state run, which drops the shadow and re-programs below.
+	 */
+	if (wl_smap->rf_off || wl_smap->lps == BTC_LPS_RF_OFF)
+		return;
+
+	/*
+	 * RF may have been re-initialized, drop the shadow and re-program.
+	 * Power-off is not listed, it is always followed by an init run
+	 * before the next RF access.
+	 */
+	if (dm->run_reason == BTC_RSN_NTFY_INIT ||
+	    dm->run_reason == BTC_RSN_NTFY_RADIO_STATE)
+		dm->bttrx_en_ack = 0;
+
+	for (i = BTC_BT_1ST; i <= BTC_BT_2ND; i++) {
+		want = !!(state & BIT(i));
+		done = !!(dm->bttrx_en_done & BIT(i));
+
+		if (dm->bttrx_en_ack & BIT(i) && want == done)
+			continue;
+
+		if (rtw89_phy_btc_bttrx_en(rtwdev, i, want)) {
+			/* leave the bit un-acked, the next run retries it */
+			dm->bttrx_en_ack &= ~BIT(i);
+
+			rtw89_debug(rtwdev, RTW89_DBG_BTC,
+				    "[BTC], %s(): BT%d trx_en=%d write fail\n",
+				    __func__, i, want);
+			continue;
+		}
+
+		dm->bttrx_en_ack |= BIT(i);
+
+		if (want)
+			dm->bttrx_en_done |= BIT(i);
+		else
+			dm->bttrx_en_done &= ~BIT(i);
+	}
+}
+
 #define _bind_is_btonly 0x7
 static void _set_coex_binding(struct rtw89_dev *rtwdev)
 {
@@ -8927,7 +8980,7 @@ static void _set_coex_binding(struct rtw89_dev *rtwdev)
 	/*
 	 * sit_xmap(Space-Interaction) = ant_xmap | xtk_xmap
 	 * 1: WL-BT space-interference, always 1 if BTG/BTA/SPDT = 1
-	 * if dedicated-ant, it may be 1 if BT-Tx is bigger than WL-Rx(xtk_xmap)
+	 * if dedicated-ant, it may be 1 if BT-TX is bigger than WL-Rx(xtk_xmap)
 	 *
 	 * ant_xmap(ANT-Division-Multiplexing)
 	 * ==> dedicated-ant->0, BTG/BTA/SPDT->1
@@ -8972,8 +9025,8 @@ static void _set_coex_binding(struct rtw89_dev *rtwdev)
 	}
 
 	/*
-	 * WL 1SS MIMO-PS: WL Rx is confined to a single path, so the unused
-	 * path has no WL-Rx frequency interference with any BT.
+	 * WL 1SS MIMO-PS: WL RX is confined to a single path, so the unused
+	 * path has no WL-RX frequency interference with any BT.
 	 * RF_PATH_AB -> not 1SS, both paths keep their real fit_xmap.
 	 * Same helper as _update_sdm_map(), so xtk_xmap and fit_map always
 	 * agree on which RF-path is the unused one.
@@ -9028,15 +9081,23 @@ static void _set_coex_binding(struct rtw89_dev *rtwdev)
 
 	/* set BT on/off state for GNT_WL Combined-MUX control */
 	if (bt0->enable.now)
-		val |= BIT(0);
+		val |= BIT(BTC_BT_1ST);
 
 	if (bt1->enable.now)
-		val |= BIT(1);
+		val |= BIT(BTC_BT_2ND);
 
 	if (bt2->func_type)
-		val |= BIT(2);
+		val |= BIT(BTC_BT_EXT);
 
 	dm->ost_info.bt_enable_state = dm->bt_only ? _bind_is_btonly : val;
+
+	/*
+	 * Turn the BT TX/RX on/off by the BTG control in WL RF. Driven by
+	 * bt_enable_state shadow instead of its change, so a write the RF
+	 * layer rejects is retried in the next run. Call it every time, the
+	 * shadow compare inside is what suppresses the redundant RF I/O.
+	 */
+	_set_bttrx_en(rtwdev);
 }
 
 static void _update_run_ctrl_info(struct rtw89_dev *rtwdev)
@@ -9063,7 +9124,7 @@ static void _update_run_ctrl_info(struct rtw89_dev *rtwdev)
 		wl_ctrl_info->rf_ch[i] = wl->rf_ch_info[i].center_ch;
 	}
 
-	if (!memcmp(&btc->ctrl, &ctrl, sizeof(struct rtw89_btc_ctrl))) {
+	if (memcmp(&btc->ctrl, &ctrl, sizeof(struct rtw89_btc_ctrl))) {
 		memcpy(&btc->ctrl, &ctrl, sizeof(struct rtw89_btc_ctrl));
 		if (btc->ver->fcxctrl >= 9)
 			_fw_set_drv_info(rtwdev, CXDRVINFO_CTRL);
@@ -11444,6 +11505,12 @@ static int _show_dm_info(struct rtw89_dev *rtwdev, char *buf, size_t bufsz)
 		       " %-15s : pre_agc:%d, btg_rx:%d\n",
 		       "[dm_bb_ctrl]", dm->wl_pre_agc, dm->wl_btg_rx);
 
+	if (rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT)
+		p += scnprintf(p, end - p,
+			       " %-15s : bt_en_state:0x%x, shadow[done:0x%x/ack:0x%x]\n",
+			       "[dm_bttrx_en]", dm->ost_info.bt_enable_state,
+			       dm->bttrx_en_done, dm->bttrx_en_ack);
+
 	p += scnprintf(p, end - p,
 		       " %-15s : wl_tx_limit[en:%d/max_t:%dus/max_retry:%d], bt_slot_reg:%d-TU, bt_scan_rx_low_pri:%d\n",
 		       "[dm_ctrl]", dm->wl_tx_limit.enable,
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index d70123602801..a1e899576582 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4188,6 +4188,8 @@ struct rtw89_btc_dm {
 	u8 client_ps_tdma_on;
 	u8 wl_trx_nss_en;
 	u8 trx_nss_lps_done; /* 1SS re-setup done for this exit-LPS */
+	u8 bttrx_en_done; /* BT TRX enable last programmed to RF */
+	u8 bttrx_en_ack; /* which bttrx_en_done bits are trustworthy */
 
 	u8 wl_pre_agc: 2;
 	u8 wl_lna2: 1;
-- 
2.25.1

