Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7053E7145
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085622; cv=none; b=AaQBkpXas6TFp6+Hy76E0MYwMrMufs3BR+KM7bkreZsv0WH2VZd44YIk2ZOjeNRTPPV27YTWowCKJqTfMeZzsPVEmHqfUzefAaLXgj5sDNjTj+lEIuP0XTX5aR/cksljcQdhmmBnaIhc2FHe+dnakvjlsGypmpo72a86JTqP8tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085622; c=relaxed/simple;
	bh=5Zl3PxRGFkZow8OoAZzjmkVgTO/oYGq4KWYQHRYbnQs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxNNmBwCelwNSUd2rSEazNzvV7evsOY/deRdAIhSLUhPDtq3go3Ls0vKTk4cJekgrXXPgqVL04062Tm6Ew2PqarpfoJEXCeUpFOhKioRsfAORteAVo8yqKWPYJPQKxeLHsJ+9uLgstG3i+1yPBIhdJ7ttLMcZMEL7F/nuertf9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=iSOiviG/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="iSOiviG/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kwyiF829605, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085618; bh=FAxInXZ5Iy9HnGZBDbgPr/EgkczJREw3nU4fKLl4KLw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=iSOiviG/I/vtq/OpUzPvXhFtqEpDpoP5u7gWMLHn5lYCecfZZQ9DRmOcu4FN4bcuO
	 FjmL/LgsKTzKncQW1f12UtL1C2HUmPQEgcc4z5SZaDT1rYjiYnWVQFb+A89EYj8CjH
	 AcQuDPEFZA+IltGWAPzHpT1Xmqw/4UtvqKMyBL7xizijN1kIXfw3iNP81E9YiKXpBk
	 XmyOGoqIKqvPFRzXt3y0sZamdqwhrfveDZ45SjstWwDjShCB8pCOZqvl6xovYM4/5h
	 BM0UM4D+Ur63fjN4Q+n5BcuQjYTJdXMVRLIBUy8DjDAPx86KMWlgUKftzbdA7FyCub
	 bKVqGxm6onNEw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kwyiF829605
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:58 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 10/15] wifi: rtw89: coex: store BT TX power per device and per RF band
Date: Sun, 4 Oct 2026 11:45:15 +0800
Message-ID: <20261004034520.33695-11-pkshih@realtek.com>
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

A BT TX power report identifies which BT device came from, in bit 7
of its second byte, whether it describes that device's 2.4 GHz
or 5/6 GHz link. The handler ignored both and always wrote the first
BT device's 2.4 GHz link info.

On a chip with two BT devices or with 5/6 GHz BT support, the reported
power therefore never reached the second device or the 5/6 GHz link.
The TDD/FDD switch threshold reads exactly those fields when the WL
link is not on 2.4 GHz or when it scores the second BT, so on those
paths it kept comparing against the reset default instead of what BT
actually transmits at.

Select the device from the report's own index and the link from its
band bit, the same way the other BT mailbox reports already do.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index ebc4b1b415c8..c25bc9e619ce 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -8542,14 +8542,23 @@ static void _update_bt_bistdma_info(struct rtw89_dev *rtwdev, u8 bid,
 }
 
 #define BTC_BTINFO_PWR_LEN 5
-static void _update_bt_txpwr_info(struct rtw89_dev *rtwdev, u8 *buf, u32 len)
+static void _update_bt_txpwr_info(struct rtw89_dev *rtwdev, u8 bid, u8 *buf,
+				  u32 len)
 {
-	struct rtw89_btc_bt_info *bt = &rtwdev->btc.cx.bt0;
-	struct rtw89_btc_bt_link_info *b = &bt->link_info;
+	struct rtw89_btc_cx *cx = &rtwdev->btc.cx;
+	struct rtw89_btc_bt_link_info *b;
+	struct rtw89_btc_bt_info *bt;
 
 	if (len != BTC_BTINFO_PWR_LEN)
 		return;
 
+	bt = bid == BTC_BT_1ST ? &cx->bt0 : &cx->bt1;
+
+	if ((buf[BTC_BTINFO_L1] & BIT(7)) && bt->band_56G_support)
+		b = &bt->link_info_56g;
+	else
+		b = &bt->link_info;
+
 	if (!memcmp(bt->txpwr_info, buf, sizeof(bt->txpwr_info))) {
 		rtw89_debug(rtwdev, RTW89_DBG_BTC,
 			    "[BTC], %s return by info duplicate!\n", __func__);
@@ -10594,7 +10603,7 @@ void rtw89_btc_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 		break;
 	case BTF_EVNT_BT_QUERY_TXPWR:
 		bt->bcnt[BTC_BCNT_TXPWR_UPDATE]++;
-		_update_bt_txpwr_info(rtwdev, buf, len);
+		_update_bt_txpwr_info(rtwdev, bid, buf, len);
 	}
 }
 
-- 
2.25.1

