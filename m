Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2BC4718F0
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147699; cv=none; b=m8cWXMmfPIHAEStQoPF2MhFyEa6bsdarn7rjRKFXXFWcuE12BPy7LwLK0IJPhiF/1AWhZGN6m+8O55GZvlpc6jAQ0mSo2KCYFnxw4rbwfVNJyLzYCQt8z3LpCJGga9WtQR6cnsh4ZP4/+D+zerTMQ5OalfTZG12ZZP7kB2LCtUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147699; c=relaxed/simple;
	bh=ZvDRNBZCWGx2Kil4iRreLGho7BexXOMlbjbAwObs26g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZ3gNiWs0O4xThzSxCVDRp/kuEltVsOEX0RNfW3tUT1qO64tLsVG24P4ARDUr1YNIvIhmm68LN1Wuvr7PS6uQvRJVBYa5t85mA093mQGsg2GZkRqBiLvZxgG55zjYcnlYn4QbNKZn5GLQc7Sm9H5POOCVaph8iC+yTUcaU1N4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=HRs7EGrU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="HRs7EGrU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7Et8lA132755, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790147695; bh=ny9ymnr57uJCat8Qb7WrMI2WiPPoSbwoee9GeooyTlg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=HRs7EGrUUlinc+zWVcOesZSdjGiLLNbZ3sgO9fyhkPz4pVFaKRAytG9tyk6RDaDpH
	 uwWFDd9wBFSr3ywASmvVP8xmYsBHKlCAnhk4rx8v9/Bo4NrIkm9y8WgFg6Ip1BhWUx
	 TSpYbN/ABGxLIuXmKiL4AFDmMae3a+9cPKcr8VGv4QEdl8LVMA61nGNBRPSOU6j5AI
	 ip/z3O+Kylk/hLYvlkiF8FqRNKK8OvH3ygAcx3IXjTAz5K4ymnkDf3+tOmzlkd7CPQ
	 XpnaOV8Q74vJJGBb2qtBIXTLGArlNlPIxSKHxaeRDZvLLlAN6szPWzYgt6epsWWjU5
	 FfjtnAFewxyIw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7Et8lA132755
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:14:55 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:14:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:14:55 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:14:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 3/7] wifi: rtw89: coex: Add firmware 0.27.130.1 support for RTL8852C
Date: Wed, 23 Sep 2026 15:13:50 +0800
Message-ID: <20260923071354.50864-4-pkshih@realtek.com>
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

Add a new entry in rtw89_btc_ver_defs for RTL8852C firmware version
0.27.130.1, which introduces fcxbtcrpt=205. The new entry activates
the v205 coexistence report path added in the preceding commit.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 0f3347fdbb01..b80e7979a1ae 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -146,7 +146,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
 	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
 	 .fcxbtver = 8,   .fcxbtscan = 8,  .fcxbtafh = 8, .fcxbtdevinfo = 8,
-	 .fwlrole = 10,    .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 10,
+	 .fwlrole = 10,    .frptmap = 5,   .fcxctrl = 9,  .fcxinit = 10,
 	 .fwevntrptl = 1,  .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
 	 .fcxtrx = 9,     .fcxtxpwr = 1,
@@ -224,7 +224,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fcxtrx = 107,  .fcxtxpwr = 0,
 	},
 	{RTL8851B, RTW89_FW_VER_CODE(0, 29, 29, 0),
-	 .fcxbtcrpt = 105, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 5,
+	 .fcxbtcrpt = 105, .fcxtdma = 3,  .fcxslots = 1, .fcxcysta = 5,
 	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
 	 .fcxbtver = 1,  .fcxbtscan = 2,  .fcxbtafh = 2, .fcxbtdevinfo = 1,
 	 .fwlrole = 2,   .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
@@ -232,6 +232,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
 	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
+	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 130, 1),
+	 .fcxbtcrpt = 205, .fcxtdma = 4,  .fcxslots = 2, .fcxcysta = 105,
+	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
+	 .fcxbtver = 1,  .fcxbtscan = 2,  .fcxbtafh = 2, .fcxbtdevinfo = 1,
+	 .fwlrole = 101, .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
+	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
+	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
+	 .fcxtrx = 107,  .fcxtxpwr = 0,
+	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 97, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 4,    .fcxslots = 2, .fcxcysta = 105,
 	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
-- 
2.25.1

