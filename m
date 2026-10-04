Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B853E63AE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085612; cv=none; b=UZDuEkV3M3P118jRvneoC8WTpeGaWARAl57+gf9pb2uoxMVK28ayhMehOef30m/BxRbEvIoTspxEVK5iTyql+2IWDOIOYdjQfONoZQm6Gz5gD1ZTm5ALhKWKXNX2ThiWBE+1L9jVhV5iTDaLubWj5cXjlXHt1t80CqmyPWHcU44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085612; c=relaxed/simple;
	bh=/RvAxViJa0aHOIi/t/mJEfMyzEIC8p/4d5OJ3IzQFpI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ABTho0PEY4vFl00OwoDBZKK4Z6pm1otgsNDDKTGJiC3SMGqqV0QzIrRgULOdM3nkvlsM1yQlcPUBPRw4NKmu92c/xW5aHaAiMGZTYOGLONfck3IsZale8y38V+nIW7jMTyB3xs3XyJokEyHCyoIE9s33m6VgwTz8gAcOoxJQB9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XMSRE5Vh; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XMSRE5Vh"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943klQY3829576, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085607; bh=Lg8mt9JnYbszt1dOFtf6JsETu+r3kycU1Mb980A7ZFU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=XMSRE5VhNyAJNFwMDPvlNUJJNilxDQ9J6x669rrQoJJ6gfaxacm8NA7/gGG4+tewk
	 0Lwynt2J61rg9gkZRtcyieXEpf3RsE5+N7xvNEfUM9HLasWfRlpA/NTSlTUNzPyz98
	 PGKILPek77JuHyCUYhKhj+ZmI/4lq/E6sW8/iJ11YGBkfVhBizKjkuKWzz9ZLrmor3
	 V3YhADftZNELkq8ygf2Hma4z4eOwmT87FskQUOrQBlG9gYhEXSrrPh/LKK6qsVox5/
	 TgqdKkt29w+QmkGGV6Sgg+ZQpH3Bfr08nzAj7J+eHq1cE73X4o6/v6YZHP7Sll/gY+
	 Xy46j97HLbDQg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943klQY3829576
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:47 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:48 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:47 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 08/15] wifi: rtw89: coex: raise default BT TX power to 10 dBm
Date: Sun, 4 Oct 2026 11:45:13 +0800
Message-ID: <20261004034520.33695-9-pkshih@realtek.com>
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

The TDD/FDD switch threshold is derived as the WL RSSI at which a BT
device's TX power, after antenna isolation, starts to interfere:
110 + bt_pin - ant_iso - sir_thres, in RSSI percent. Before the first
BT TX power report arrives, and on any link whose report never
arrives, bt_pin falls back to the BR/LE defaults, so those defaults
decide where coexistence flips between TDD and FDD.

Both defaults were 4 dBm, which places the threshold about 6 dB below
what the BT side actually transmits at, so the driver stays in FDD
well past the point where BT TX already interferes with WL RX. Raise
both to 10 dBm, which matches the BT TX power these designs report
once their first query completes.

The 8922A ext-SOC path already used a separate 10 dBm define for the
same reason; drop it now that the common default carries that value.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.h     | 5 ++---
 drivers/net/wireless/realtek/rtw89/rtw8922a.c | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 624b8d1b4742..b1f92c1d0428 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2656,10 +2656,9 @@ enum rtw89_btc_bt_func_type {
 
 #define RTW89_BTC_BTC_SCAN_V1_FLAG_ENABLE BIT(0)
 #define RTW89_BTC_BTC_SCAN_V1_FLAG_INTERLACE BIT(1)
-#define RTW89_BTC_BT_DEF_BR_TX_PWR 4
-#define RTW89_BTC_BT_DEF_LE_TX_PWR 4
+#define RTW89_BTC_BT_DEF_BR_TX_PWR 10 /* in dBm */
+#define RTW89_BTC_BT_DEF_LE_TX_PWR 10
 #define RTW89_BTC_DEFAULT_ANISO 10
-#define RTW89_BTC_BT_DEF_LE_TX_PWR_1 10
 
 struct rtw89_btc_bt_scan_info_v1 {
 	__le16 win;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 6402bd4f06aa..e48300287697 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -2796,7 +2796,7 @@ static void rtw8922a_btc_set_rfe(struct rtw89_dev *rtwdev)
 	default:
 	case BTC_ESOC_NONE:
 		memset(&btc->cx.bt_ext, 0, sizeof(struct rtw89_btc_extsoc_info));
-		btc->cx.bt_ext.max_tx_pwr = RTW89_BTC_BT_DEF_LE_TX_PWR_1;
+		btc->cx.bt_ext.max_tx_pwr = RTW89_BTC_BT_DEF_LE_TX_PWR;
 		btc->cx.bt_ext.ant_iso_to_wl = RTW89_BTC_DEFAULT_ANISO;
 		break;
 	case BTC_ESOC_8771:
-- 
2.25.1

