Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BAF3C2BAF
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937319; cv=none; b=AL0sdpZley7PIN6uoiE/Q2uopsx/2GvMh7uvW9yh0ESRFJCjoobOO8HvPdazv4xUG9y/eDqhUTpVsoqeMf6kEr6drZ7IGhuBZ32cpBbjw3A2zQ+dLxfFb+f9/xRbNIh0MYdoWG55/0hgUn244yMWZskoUHhXPIyyDUZU23MaUxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937319; c=relaxed/simple;
	bh=KWoLVqJvRhP1exxx1HQGegwjX/gRC3AtqAoC39DN69I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ViEL3EK/K84qspKIiRIni7l0tE6ZUL0bMU0crt9CmbfLCU+v1fDBRdTCuDzUA1dQCKyp8IoMK6vDWmqablIh9MZxEoEuWqvaWk6rjsWcVxIO6JfECRWVGNzybQ8HoIseTTveTslYPyTkfSn6RMySjpQAe/xcpyOZz7ryeHv25pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qnlexnaG; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qnlexnaG"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68971q5R2357181, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937312; bh=1g+/AtHn8PaEBkHF4ywarConIcPcOKlGzQ/WnCqxl/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=qnlexnaGDArz+NeavX9dPpRJYcVTJRwbDsOFBnZXTTi6GK3O4YSNQK4PwSZj2UP/F
	 Gz9pexaQr5FyU4ViZdVmOoiaiVJDGf/FgdABHi0HwC//oNTE5uomH4sxga3kSV6fXs
	 Xo4CgOPshLNmwm0Ufo7g2Ah+HKDho/pHfhZfXUunXayhuyn4qHGiGKjKBM1pFsEKo2
	 cGmabTFu5gw3iM99tHJAk95J7L5sSEssPMEfX7TSxBukR20lSLB7wW/w6EEUomuIJc
	 EkjkHf6kcf9bHoqTGqpTsPzZtaZFAalhMozi8WSKz8S6Gf4TxVv5CT23Af/TkPwPfZ
	 EIo4BeRzVAPpg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68971q5R2357181
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:01:52 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:52 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:51 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 13/15] wifi: rtw89: 8851b: rfk: set DCK start and delay time
Date: Wed, 9 Sep 2026 15:00:02 +0800
Message-ID: <20260909070004.35353-14-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Modify the DCK delay time and add the TSSI TX start time to bring more
accurate TSSI detection, which helps thermal tracking to compensate output
power correctly.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c
index c5f70c045692..beae5749d07d 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c
@@ -272,7 +272,8 @@ static const struct rtw89_reg5_def rtw8851b_tssi_dck_defs_a[] = {
 	RTW89_DECL_RFK_WM(0x5814, 0x00002000, 0x1),
 	RTW89_DECL_RFK_WM(0x5814, 0x00004000, 0x1),
 	RTW89_DECL_RFK_WM(0x5814, 0x00038000, 0x3),
-	RTW89_DECL_RFK_WM(0x5814, 0x003c0000, 0x5),
+	RTW89_DECL_RFK_WM(0x0620, 0x00003f00, 0x17),
+	RTW89_DECL_RFK_WM(0x5814, 0x003c0000, 0x7),
 	RTW89_DECL_RFK_WM(0x5814, 0x18000000, 0x0),
 };
 
-- 
2.25.1

