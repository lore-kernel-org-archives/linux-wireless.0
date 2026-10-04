Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487C73E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085632; cv=none; b=JhJAmLBxc+qw4tlM+FGCQAQ3Fjc/5NNYPBCwe7Syrb6ZUNM1gdJERhJjs7fxlx6YxNjaj0enKG3WShhIoiHjcxCW1kOGJ0Nfu46GaFlEKobtQNzeJrbMUQX5PC+4y+9yvQVRAlDa9TKn1H4au7Bugx38SifP2KOChkEQIA8v46s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085632; c=relaxed/simple;
	bh=ifdjeRXfuvdbVa+I5Lur6coFM24T18hJpfBZhoDCswE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1Wwe9KI1YJe9EQlXeQU33GY34+a093iDQO13QrBWFUsk3AYyePra2flZ2EYSMZY1GUvoVLRgXqVBaNBkOJHZAiKW9w0HWO4Yw3TrtaypyN14lyfhUab0zVBqxy2Q37PRScw+DJwKkQSBDnjE82d0Zw/2uRtho9syKA8n4iTPTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=u/bkZOOc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="u/bkZOOc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943l8jcD829643, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085628; bh=Hox1KOOhomTAXpeRG/egq4k2t6/ZYR6onrSrgBDAHK0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=u/bkZOOcpAY1ofVfKdxGTQufMipI1C+2lmASypGgpVlxiiXXWNo3guClUIW1JcyoS
	 BaedMZG5JaJBc5kcsr+HEWYnqEDvFo8t4ibvTfYA9Sycwqe0xdZbva444WXvfNyCul
	 bZQw8uw+WAIilPwCo5ruNqaDHmdi154ivUcnEZqYITTqGAS4XAAMh0vPCoJxCZFV9R
	 yIsa46momgtPOxBdUmrWcKnY1U5rDTN/8GJmpj+64i6lJqPTUBdJytIEmoT5WR1Wk6
	 DA1X6kGPk/ZwJosgEg4r+UAYOvtqjVOu9KPvv8yAe7IfDia1psh7Rw1ZCGuKKYwPa8
	 JrM2Tt66OxBxQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943l8jcD829643
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:47:08 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:09 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:47:08 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:47:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 12/15] wifi: rtw89: coex: use the right switch-type enum on RTL8922D
Date: Sun, 4 Oct 2026 11:45:17 +0800
Message-ID: <20261004034520.33695-13-pkshih@realtek.com>
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

Two unrelated enumerations describe a BT antenna switch type. The one
the RTL8922D antenna configuration uses numbers the absent switch as
zero and the internal switch as one, while the older one numbers the
internal switch as zero. The shared 2-antenna case picked the internal
value from the older enumeration, so it stored zero and claimed no
switch at all.

A BT whose switch type says there is no switch is treated as not sharing
an antenna with the WL RF-path that the other RF-path shares with it,
which drops the cross-talk entry for that path. Store the value from the
enumeration this field is read with. The 1-antenna and 3-antenna cases
in the same function already do.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 7ac15a5d949a..271a92123158 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -3305,7 +3305,7 @@ static void rtw8922d_btc_set_rfe(struct rtw89_dev *rtwdev)
 		if (is_bt_share) { /* WL-S0 + (WL-S1 & BT0-S1) */
 			md->ant.type = BTC_ANT_SHARED;
 			md->bt0_pos = BTC_BT_BTG;
-			md->bt0_sw_type = BTC_SWITCH_INTERNAL;
+			md->bt0_sw_type = BTC_SWITCH_V1_INTERNAL;
 			dm->ant_xmap[BTC_RF_S1][BTC_BT_1ST] = 1;
 		} else { /* WL-S0 + BT0-S1 */
 			md->ant.type = BTC_ANT_DEDICATED;
-- 
2.25.1

