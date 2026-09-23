Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F3D39FCD7
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147704; cv=none; b=aShcDiNks3fG68gWDWsSso4F03RG/cXGpDf+yRLPwQTrt3oWXx3oQUB1LeNAWiu1D1VvOnhJv+5XACVu+w2apnc7m9nzuKw2rLh7iiEyWd2IO9mrzjXbPo/0qaxvS0p7dcCi6HABPIwzLt7AkU98aIV3o4hGwowkkxQw8bUQ4+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147704; c=relaxed/simple;
	bh=3ywraU3ODKsGzFB/2x40y2OS5nm8JjougYBhDIjlpr8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GDj3ayrU5tpihFYFx+ZR/0VVGP9apaEFw2ztl+5g3LF87210Vs4JFkwgdy6U6oTRME/qlZhU/G9dBnrjvstpKvER/J9uGjeH27yCX8qWZAqOybzKhYxsNSs/i52ygjQ5wkqIH86fB6xipMoMhNBwH7m2rC9dvWiPfxrEWGzBovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=wQ3ImVTh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="wQ3ImVTh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7F0ukC132812, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147700; bh=j4pwP20wISEWmnR5KRzVaa5R6SNZzbvHF0A+FSrAxN8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=wQ3ImVThUe/Vn1z2LPfbukyTWh4V5USc9Z2lODFn+nQQWv0xbhffdzY3QmJNoOHRG
	 f3/AQgeDtWQyoC8ISgSUcSOsCbI4IbDb4ntibmxgLQ27VWdWV7FFNdCvaxQlExFFpQ
	 lC5NTfELqyvSv7R3HsVFXKdudGmWWdKrK4Hd/wiaA8kQibCEPnE+3PY70XuiJXNwyB
	 kaeGAVHhwaXsHzPVXzMzwIgNiJxQ9W7RQTCSJ14nrCmD+OrX+HXlvI6vNPHIYiDW/j
	 uEJyArCm6r6jmV7d9FiNTMF/KwPvr5hHKKxwcBvpVQBHkT1GbonilCzK9y3QiTlxOA
	 NH5n3gqJZ/uIA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7F0ukC132812
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:15:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:15:00 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:15:00 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 4/7] wifi: rtw89: coex: fix BT scoreboard update for non-C2H paths
Date: Wed, 23 Sep 2026 15:13:51 +0800
Message-ID: <20260923071354.50864-5-pkshih@realtek.com>
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

The scoreboard update function was changed to always read from
scbd_c2h, which is populated only by BTF_EVNT_BT_SCBD C2H events from
the BT firmware. This caused two problems.

First, calling _update_bt_scbd at the NTFY_INIT notification with
scbd_c2h still zero would set bt->enable.now to 0, overwriting the
bt-on assumption that _ntfy_init_coex establishes for all chips. Remove
the NTFY_INIT call to preserve that default.

Second, chips whose BT firmware does not send BTF_EVNT_BT_SCBD events
have scbd_c2h stuck at zero indefinitely, making scoreboard updates
non-functional. Restore a hardware register read path by adding
_read_scbd() and an is_c2h flag to _update_bt_scbd. The
NTFY_RADIO_STATE path passes is_c2h=false to read the hardware
scoreboard register directly, ensuring correct BT state even without
C2H support. Pass BTC_ALL_BT so both BT devices are refreshed on
dual-BT chips.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 28 +++++++++++++++++------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index b80e7979a1ae..6b72e2c80d14 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1010,7 +1010,7 @@ static void _run_coex(struct rtw89_dev *rtwdev,
 		      enum btc_reason_and_action reason);
 static void _write_scbd(struct rtw89_dev *rtwdev, u8 bid, u32 val, bool state);
 static u8 _sned_h2c_w2bscbd(struct rtw89_dev *rtwdev, bool force_exec, u8 bid);
-static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid);
+static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid, bool is_c2h);
 static const char *id_to_h2c(u32 id);
 
 static void _reset_h2c_macro(struct rtw89_btc *btc)
@@ -3902,7 +3902,7 @@ void btc_fw_event(struct rtw89_dev *rtwdev, u8 evt_id, void *data, u32 len)
 				    "[BTC], %s() bt%d:c2h->0x%08x, rb->0x%08x\n",
 				    __func__, i, bt->scbd_c2h, bt->scbd_rb);
 			bt->scbd_c2h = bt->scbd_rb;
-			_update_bt_scbd(rtwdev, i);
+			_update_bt_scbd(rtwdev, i, true);
 			btc->dm.scbd_b2w_update = false;
 		}
 	}
@@ -8116,7 +8116,21 @@ static void _update_bt_ctrl_lps(struct rtw89_dev *rtwdev)
 	}
 }
 
-static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
+static u32 _read_scbd(struct rtw89_dev *rtwdev, u8 id)
+{
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	u32 val;
+
+	if (!chip->scbd)
+		return 0;
+
+	val = rtw89_read32(rtwdev, chip->btc_sb.n[id].get);
+	rtw89_debug(rtwdev, RTW89_DBG_BTC,
+		    "[BTC], read scbd bt%d: 0x%08x\n", id, val);
+	return val;
+}
+
+static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid, bool is_c2h)
 {
 	struct rtw89_btc_bt_link_info *bt_2g, *bt_56g;
 	struct rtw89_btc *btc = &rtwdev->btc;
@@ -8149,7 +8163,7 @@ static void _update_bt_scbd(struct rtw89_dev *rtwdev, u8 bid)
 		if (!(rtwdev->chip->para_ver & BTC_FEAT_DUAL_BT) && id == BTC_BT_2ND)
 			break;
 
-		val = bt->scbd_c2h;
+		val = is_c2h ? bt->scbd_c2h : _read_scbd(rtwdev, id);
 
 		if (val == 0xffffffff) {
 			rtw89_debug(rtwdev, RTW89_DBG_BTC,
@@ -8785,8 +8799,8 @@ void _run_coex(struct rtw89_dev *rtwdev, enum btc_reason_and_action reason)
 
 	_update_run_ctrl_info(rtwdev);
 
-	if (reason == BTC_RSN_NTFY_INIT || reason == BTC_RSN_NTFY_RADIO_STATE)
-		_update_bt_scbd(rtwdev, false);
+	if (reason == BTC_RSN_NTFY_RADIO_STATE)
+		_update_bt_scbd(rtwdev, BTC_ALL_BT, false);
 
 	dm->freerun = false;
 	dm->cnt_dm[BTC_DCNT_RUN]++;
@@ -10131,7 +10145,7 @@ void rtw89_btc_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 		rtw89_debug(rtwdev, RTW89_DBG_BTC,
 			    "[BTC], handle C2H BT%d SCBD with data 0x%08x\n",
 			    bid, bt->scbd_c2h);
-		_update_bt_scbd(rtwdev, bid);
+		_update_bt_scbd(rtwdev, bid, true);
 		_run_coex(rtwdev, BTC_RSN_UPDATE_BT_SCBD);
 		break;
 	case BTF_EVNT_BT_PSD:
-- 
2.25.1

