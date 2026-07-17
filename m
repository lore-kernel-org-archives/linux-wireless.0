Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4563CB90A
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271570; cv=none; b=bs0zCOH9JTC8P7wsSDuq4TqGEEtasOxh5mbyNxh5KS9Q6NfgNDdo2y/3bmz5US+Qv9A1eih14kTUSyT/nKDuod/mwsiHk0yO2xjLR/JxFXNDbfzoa7dTcEkDZcxY36xTWMkkDig2VuF8CzKpKS14fNwMlgCzmihng3f6WrGe2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271570; c=relaxed/simple;
	bh=VStwfgC0Gw4T/BlkFn8UMlJZEWnVMC0dCG9tLkGL7V8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=um95BVj2RunjxPcFg8n08fyzANV+ww3rMPYD2zG0kWtoGekbUcGuNN2q17gLttOigin33a4UHLU9vVavYQiNWk+abDwCEmXax4SRZJv+PvgD9UopOwglI20FhjenoiN+PYbwSr0QIqpvzbLzojV08oHJJuV0Ayv3a0CdAH68BYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=EvBavWPI; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="EvBavWPI"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xOSl94176633, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271564; bh=ngze4Bsux58kk+HVt7qy+NdqXftQmHPIuFOIL8O34iE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=EvBavWPIXyjAd5XRIsL/F9NCA32W3geRhXdqoqEPMMLH57vZWDQJvYwFgQbBuqIVE
	 fnCpz3y/IURyBCGUbOJIKO1/SHocFmT677fKeNrfKdiC3Wcozqo8+z3n29Lj0PVjkK
	 ZRzScTvcQ3xwcl8C2yoKLi5akWr+lgeMh0mF17/+AaZg2uyeYWlipF0O+4jY2Yj2yM
	 k2plEFfAkQ+++uqQ6tCEZvfXCBkuC8sAczbG/2Aqf3FLJ4fyqaQ/Wjm9bcwZUUHfOR
	 rMSZMhTk3iZGAl6hiUKjJc9j7fxI+V7wPARyOzVN5jgNjysNTju3Y6YrVVPjWRRHH0
	 ASptDvIAbQ+PA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xOSl94176633
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:24 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 08/13] wifi: rtw89: coex: Add firmware 0.29.133.X support for RTL8852B family
Date: Fri, 17 Jul 2026 14:57:34 +0800
Message-ID: <20260717065739.64124-9-pkshih@realtek.com>
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

The new firmware modified GPIO setup structure format for third party
chip set I/O control & offloaded Wi-Fi TRX status to firmware for training
traffic RF-Parameters & TDMA mechanism.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 10699c92273a..6bbcc6cd5dae 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -142,6 +142,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
 	 .fcxtrx = 9,
 	},
+	{RTL8852BT, RTW89_FW_VER_CODE(0, 29, 133, 0),
+	 .fcxbtcrpt = 9, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
+	 .fcxstep = 7,   .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 7,  .fcxbtscan = 7,  .fcxbtafh = 7, .fcxbtdevinfo = 7,
+	 .fwlrole = 7,   .frptmap = 5,    .fcxctrl = 7,  .fcxinit = 107,
+	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 103, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
+	 .fcxtrx = 107,
+	},
 	{RTL8852BT, RTW89_FW_VER_CODE(0, 29, 122, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
 	 .fcxstep = 7,   .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 7,
@@ -187,6 +196,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
 	 .fcxtrx = 0,
 	},
+	{RTL8851B, RTW89_FW_VER_CODE(0, 29, 133, 0),
+	 .fcxbtcrpt = 9, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
+	 .fcxstep = 7,   .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 7,  .fcxbtscan = 7,  .fcxbtafh = 7, .fcxbtdevinfo = 7,
+	 .fwlrole = 7,   .frptmap = 5,    .fcxctrl = 7,  .fcxinit = 107,
+	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 103, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
+	 .fcxtrx = 107,
+	},
 	{RTL8851B, RTW89_FW_VER_CODE(0, 29, 29, 0),
 	 .fcxbtcrpt = 105, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 5,
 	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
@@ -223,6 +241,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
 	 .fcxtrx = 0,
 	},
+	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 133, 0),
+	 .fcxbtcrpt = 9, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
+	 .fcxstep = 7,   .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 7,  .fcxbtscan = 7,  .fcxbtafh = 7, .fcxbtdevinfo = 7,
+	 .fwlrole = 7,   .frptmap = 105,  .fcxctrl = 7,  .fcxinit = 107,
+	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 103, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
+	 .fcxtrx = 107,
+	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 122, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
 	 .fcxstep = 7,   .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 7,
-- 
2.25.1

