Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFF0417BDE
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 05:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142370; cv=none; b=AhJwwIUC8ZSWQFRirrBgFezojvOsakHnOhjFmcxtywQaEwsmNACfQ9VjzybKiBVYwCffNzJwT99mecY3uVCCBeyS7qEr9c2Y4c3IY+qU7xH7gS86afeuCknn8AU0ruc6OfLIG8NhCSxq8thFL7ZzDpc0pLLqqspXJXHY0iVN+VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142370; c=relaxed/simple;
	bh=2wXkyrW8FEAQDK9Q4kkdRUe0+UswOv3hDADEUMtdElo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYEJwfXmp1vtYV91S7VNbBh4Ntq5Gy8ZRsWF310NcGbzISOuJURRriIZH/Dvzbt/eSfk9D3LcN00fmSg/PgpKRQvN25xcXLzRY8CimjVr1tjRv8RqjzyqBopPI/XHBRZulsi4V62ZtcZayxLw+/v4XNkn9IFG6z8U88kn/M00co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=a4XFqiMO; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="a4XFqiMO"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N5k6eE5097470, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790142367; bh=RqJutCqKAW5DKYrwiCpvm6tZ/fXDb0sZWYiTJ67yaEY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=a4XFqiMOhprcToZn+sciEZ2b3D5AMWxAPaWZAdX0BhbGIbJvp+GfbRa70UuJ/wWWi
	 OxV2ptjurROvurFXQHrJFgS8VwUVrsAeijilwVj4Df6C2DhX60XVe/p6LfsYdOrMEM
	 jXRWSQ1jFKQbD+X/4EHmutFB9DQOc3BmhfVwXKpmes7ikcz3EXQBx++ncP0fM3ilpw
	 8V8qyeIQ+yx8reAF3FCMmEHeJu/BifwTJ7v6fXqBBnyCh18rXiF5Kzwsq3l49WAtoH
	 Z2g83mrqwoqE2xG1y8ZWRXQxqFt5Tia7gzjYknPMa5N0Ur+tRwEMPMWur0DQT+9HoO
	 RuGzPfWjgDJkg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N5k6eE5097470
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:46:07 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 13:46:05 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 13:46:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 4/6] wifi: rtw89: led: check if board variant assigns led desc
Date: Wed, 23 Sep 2026 13:45:03 +0800
Message-ID: <20260923054505.43329-5-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260923054505.43329-1-pkshih@realtek.com>
References: <20260923054505.43329-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Zong-Zhe Yang <kevin_yang@realtek.com>

Refine the check logic. The led initializer assumed a board variant must
have led desc, but board variant is going to add a new field, board_id,
for custom FW elements and not all board variants which require custom
FW elements have led desc.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/led.c b/drivers/net/wireless/realtek/rtw89/led.c
index ae74b7075d7c..18bfe626ef50 100644
--- a/drivers/net/wireless/realtek/rtw89/led.c
+++ b/drivers/net/wireless/realtek/rtw89/led.c
@@ -104,7 +104,7 @@ void rtw89_led_init(struct rtw89_dev *rtwdev)
 	/* single-GPIO monochrome LED is the only supported layout */
 	BUILD_BUG_ON(ARRAY_SIZE(rtw89_common_led_gpios) != 1);
 
-	if (board)
+	if (board && board->led_desc)
 		desc = board->led_desc;
 	if (!desc->n_gpio || desc->n_gpio > RTW89_LED_MAX_NUM)
 		return;
-- 
2.25.1

