Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5123D3CFF
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271595; cv=none; b=NMNqhILzoOb6okqv8G0UD/Z0V+rVeZTNPnXJFduzqGnI9gABiIvJG7Oenqh52eNv5Z9slqwlCzhum4BhYqi98nfUf+SKilKpY8T3c3RcRpmHRxBnlICU07WzHJvc2sLPgARZrG7DXSGbzUPC8L9D8Hs92o6ub3XqGry1mCw9dUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271595; c=relaxed/simple;
	bh=W3fj3eKkZipEBT5aihcRsTXxYEgtUsYbkESBu183E5M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwFQB8r356ibepCTR0tSKafWvrSbki/XLvophNjNs0Bx24TFDaEjKelst3NOvH3PhyeRj9ZtRJvHbA0tjJmqOvWIMPqzQEWI7bglRy/tC5InK84qGF1I3x9E14lqDNoIRQwlFL56fY9MoWEq15IXp7RHYqQrVxwcLApDwVFTEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DJsgF4jv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DJsgF4jv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xpymF4177101, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271591; bh=O/sgSec7xZlAj3HpHB22hlqxf4yJw2RodPXML9mRzak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=DJsgF4jv6U3gqCOMGAiOwfYPiiFEPHRgJZWAN+RkjSdyY1AU8z0GkfeFNiRBKcHhj
	 JU+BzdPf8EttUMeAvPlpy6q4Fn0V/zOtK+xHLf+rgAichjjOXmc/BbOKamlD986tWz
	 Go2BC/m+S7qB0Ti9pMnCAJ5FdP8YEgRLcGQ0peqRDHj/eFmvpUCDsIHrFyTNbQ6zlY
	 VZ+8qqSkaS7EmVAoJ7flUeL9aIM20JO8zlxl/YJE6EQAhYOkEPKbDWk2c4fIasE4Vy
	 CGCXnowUUj/Xewe403VywpWG+mtQHzTvum1dqvardGlvYEtyjxWVTmmXKrVNTPln7m
	 chyk+9YnvrGMw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xpymF4177101
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:51 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:51 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:51 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 13/13] wifi: rtw89: coex: Add firmware 0.27.97.X support for RTL8852C
Date: Fri, 17 Jul 2026 14:57:39 +0800
Message-ID: <20260717065739.64124-14-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717065739.64124-1-pkshih@realtek.com>
References: <20260717065739.64124-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Newer firmware is using the new TLV-Header format, without this patch
it will lead driver run into length mismatch state.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index b95e34cb1567..6a1888d8c476 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -214,6 +214,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
 	 .fcxtrx = 0,
 	},
+	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 97, 0),
+	 .fcxbtcrpt = 4, .fcxtdma = 4,    .fcxslots = 2, .fcxcysta = 105,
+	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
+	 .fcxbtver = 1,  .fcxbtscan = 2,  .fcxbtafh = 2, .fcxbtdevinfo = 1,
+	 .fwlrole = 101, .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
+	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
+	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
+	 .fcxtrx = 107,
+	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 57, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 3,
 	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 1,  .fcxgpiodbg = 1,
-- 
2.25.1

