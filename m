Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6AB3AA9EF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085575; cv=none; b=ArFWgZyaJagjU6FHbSJFDCZDTWOW9rAtAAtgbVtbGcqoW0T8OWeiYxGKQCJWpFm7TF4oizLUvhRWEUV+SzeNU3qs2IvGZMXjB7pzxPFVcfJXUPppeMlMnJID7fcBJ6gCLu9owO1OSJv90fYQ1vLnhZ6NJ+42bssVLj0cd5NNPUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085575; c=relaxed/simple;
	bh=v5IkrDKX/9WBlrxbN/uw1HH6v5pvj8sp0HAvZxoYK8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoYPxZ3U0cX7V8ruRI3bbUOIrORZn6EwBYLzXR5X1Z/5ba3Ps2mI0O3MaUG72fW2c3PISxLCrAFaclVHj+NNAa+rrzfPaIDFGBJLAQOrUwBjIwTJX1x/canBBaLQDWJp0IrvjMzVh3enDpYxS4TIS8n+XFBasbGoeqD8EFJGKxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=NKMGWfDC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="NKMGWfDC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kA1H1829261, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085570; bh=oMWuw17N34mZFaxNvJtvBZvmMboJ1esFW/RUoj6iL7o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=NKMGWfDC4IvyVCuq6Ve84jaLMIST1JiQOwLXRcOJYnQbkeOBN0Zqp593NHWLPwGfB
	 O1bQLdm1/5fVDz/s6MOBUKdkmvaIRXAVk+Vb2CaWRQdDwMzTGftymlkbmUtDmivAeE
	 exYzELxXb9H364hhiWvx4NTqdg0sygopaqrfjMss3YNEE2nVxvGsAf4ZGjdqe2xLF1
	 aorIZQilMtTeuLATro59PW8OzrlVK9w/ktbsic8n8FTC1RGd+ONvkn3VB5q82x0y1F
	 pyqKq5KQ7qaxO5PqVJbiXY7SmNZh+2DOuYf522ePwkoGQnaUgLwrKk093OrkzlFumc
	 uo9qKRKUtJTaQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kA1H1829261
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:10 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 01/15] wifi: rtw89: coex: fix RF band check in _set_rf_trx_para() and its propagation
Date: Sun, 4 Oct 2026 11:45:06 +0800
Message-ID: <20261004034520.33695-2-pkshih@realtek.com>
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

dm->tdd_bind.rf_band holds a bitmask built from BIT(BTC_BT_B2G) and
BIT(BTC_BT_B5G), but _set_rf_trx_para() compared it against the raw
band enum values RTW89_BAND_5G and RTW89_BAND_2G instead of their
BIT() form. Every other site in this file that reads tdd_bind.rf_band
wraps the enum with BIT() before comparing.

Because RTW89_BAND_5G equals 1 and BIT(BTC_BT_B2G) also equals 1, a
Wi-Fi/Bluetooth coexistence session bound to the 2.4 GHz band was
misclassified as BTC_WLINK_V0_5G. This incorrectly skipped the RF
Tx/Rx parameter adjustment for 2.4 GHz STA traffic and kept clearing
wl_stb_chg to 0, so chip->ops->btc_wl_s1_standby() never re-enabled
the Wi-Fi standby workaround for the Bluetooth Tx-to-Rx GNT switch on
RTL8852C, degrading Wi-Fi performance while coexisting with Bluetooth
on 2.4 GHz.

Compare rf_band against BIT(RTW89_BAND_5G) and BIT(RTW89_BAND_2G) to
match its actual bitmask representation.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6b72e2c80d14..271b002a2d40 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -4186,10 +4186,10 @@ static void _set_bt_tx_power(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
 		buf[1] = rf_band;  /* bit-map: bit1->5GHz/6Ghz, bit0->2.4GHz */
 
 		if (!force_exec && !btc->cli_h2c_cmd) {
-			if (rf_band == RTW89_BAND_2G &&
+			if (rf_band == BIT(RTW89_BAND_2G) &&
 			    bt->tx_power_now == level)
 				continue;
-			else if (rf_band != RTW89_BAND_2G &&
+			else if (rf_band != BIT(RTW89_BAND_2G) &&
 				 bt->tx_power_now_6g == level)
 				continue;
 		}
@@ -4199,7 +4199,7 @@ static void _set_bt_tx_power(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
 
 		if (!_send_fw_cmd(rtwdev, BTFC_SET, h2c_func, buf, len)) {
 			btc->dm.rf_trx_para.bt_tx_power[i] = level;
-			if (rf_band == RTW89_BAND_2G)
+			if (rf_band == BIT(RTW89_BAND_2G))
 				bt->tx_power_now = level;
 			else
 				bt->tx_power_now_6g = level;
@@ -4240,7 +4240,7 @@ static void _set_bt_rx_gain(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
 		id_stop = bid;
 	}
 
-	if (rf_band == RTW89_BAND_2G)
+	if (rf_band == BIT(RTW89_BAND_2G))
 		scbd_bit |= BTC_WSCB_RXGAIN;
 	else
 		scbd_bit |= BTC_WSCB_RXGAIN_56G;
@@ -4256,10 +4256,10 @@ static void _set_bt_rx_gain(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
 
 		/* return if same setup */
 		if (!force_exec && !btc->cli_h2c_cmd) {
-			if (rf_band == RTW89_BAND_2G &&
+			if (rf_band == BIT(RTW89_BAND_2G) &&
 			    bt->lna_constrain == level)
 				continue;
-			else if (rf_band != RTW89_BAND_2G &&
+			else if (rf_band != BIT(RTW89_BAND_2G) &&
 				 bt->lna_constrain_6g == level)
 				continue;
 		}
@@ -4400,9 +4400,9 @@ static void _set_rf_trx_para(struct rtw89_dev *rtwdev)
 
 	if (bmode == BTC_WLINK_NOLINK) {
 		return;
-	} else if (rf_band == RTW89_BAND_5G) {
+	} else if (rf_band == BIT(RTW89_BAND_5G)) {
 		mode = BTC_WLINK_V0_5G;
-	} else if (rf_band == RTW89_BAND_2G && bmode == BTC_WLINK_STA) {
+	} else if (rf_band == BIT(RTW89_BAND_2G) && bmode == BTC_WLINK_STA) {
 		mode = BTC_WLINK_V0_2G_STA;
 	}
 
-- 
2.25.1

