Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0BC3CF96D
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271558; cv=none; b=hVPTqnHDbZmb/y6BYbq3q/ZCOY9s6ijJHKzqKacRfOb5P24Pq0LCcu+w3Ny5DRtmXKSKfuem3jKiuawr9tZESqv+WX+/GXniXeMbgtYMLMfDY2S4jrDku9BePJUO9AIk4/pmTR3qKGzVz5Ad/olPueF79zLPGJgejYXZcgWwiL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271558; c=relaxed/simple;
	bh=c0wMiVdR0oKlsbuqRrr3Otkb3anP0K39geKa3bobX8A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tiKr+w6GKnKv3sDmJiZTDr5n0FW2P8wA04GaPnOjH6MbHHarrq7wEpHrTgZJA38G/qbrLGQwz7eInpXG57Rc1xvoeTSssEpt7ocAiVgKWNhfhtSJEXf/bmx2GvoVjvexBbg3RgOkNsSevay9Rpkj4P94bx+JUuvCS/c1wdk+1Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CMRuM7w/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CMRuM7w/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xExcD4176592, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271554; bh=PnL2W9amZYgu+aWPQTfNsptlrtwZC+eb5QcQ4rAwdio=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=CMRuM7w/PBAz9GhuUC0Z25CzZGlv6gflBk4j0ZulRV7NFeCqSlfHPdgM6AZNlwQrj
	 49KU7zfBpTOTBAm5sa/6o5iXTQxyJwRIh6r1q/oJk++VV5klbjRl3ig3/WlHMg/oI8
	 lpYVwXRENmMaPA/+O0VBimLte724EupNvmw2vNqialutPXiHvMnSut2h/yniv9ZALT
	 5FVg/xWktayyGmjtgCW+ZrQhyawfAR/4qMq7BjyIdbbPcbxsAmFcbrkU4JTd8OR4D2
	 mLHNfxWlLU8a7Kku8DWupTruUAJeM8+Fivyfn9ri6wq/LOuqn8UPX8uSzPQ1bneiwN
	 xzar56TQo6NQA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xExcD4176592
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:14 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:14 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 06/13] wifi: rtw89: coex: Add driver info H2C command index version 103
Date: Fri, 17 Jul 2026 14:57:32 +0800
Message-ID: <20260717065739.64124-7-pkshih@realtek.com>
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

The 0.29.133.X firmware driver info H2C index maximum is 5, to prevent
switch case fall through and send unexpected H2C commands, add version
code 103 as judgment.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index ad52274a3979..10699c92273a 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3138,7 +3138,7 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 		rtw89_fw_h2c_cxdrv_rfk(rtwdev, index);
 		break;
 	case CXDRVINFO_TXPWR:
-		if (ver->drvinfo_ver == 3)
+		if (ver->drvinfo_ver == 3 || ver->drvinfo_ver == 103)
 			index = 4;
 
 		if (ver->fcxtrx == 7 || ver->fcxtrx == 107)
@@ -3147,26 +3147,27 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 			rtw89_fw_h2c_cxtxpwr_v9(rtwdev, index);
 		break;
 	case CXDRVINFO_FDDT:
-		if (ver->drvinfo_ver == 3)
+		if (ver->drvinfo_ver == 3 || ver->drvinfo_ver == 103)
 			index = 5;
 		else
 			return;
 
-		rtw89_debug(rtwdev, RTW89_DBG_BTC, "drv_info FDDT index=%d\n", index);
 		break;
 	case CXDRVINFO_MLO:
+		if (!ver->fcxmlo || ver->drvinfo_ver == 103)
+			return;
+
 		if (ver->drvinfo_ver == 3)
 			index = 6;
 		else
 			return;
 
-		rtw89_debug(rtwdev, RTW89_DBG_BTC, "drv_info MLO index=%d\n", index);
 		break;
 	case CXDRVINFO_OSI:
-		if (!ver->fcxosi)
+		if (!ver->fcxosi || ver->drvinfo_ver == 103)
 			return;
 
-		if (ver->drvinfo_ver > 1)
+		if (ver->drvinfo_ver == 3)
 			index = 7;
 		else
 			return;
-- 
2.25.1

