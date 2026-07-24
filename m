Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080A62FFDFC
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901420; cv=none; b=bQKAPvcDKsP6Ja9YTrCy1Q7gBX9Y4DwfkiYTkW2nWFT6FlqaWEBRfEeGAnz77nGm33tyHqM010UJUz/eih6Y0MB4YaACetthfgIiDbWjrRvBtZDZ4MnNFrcn8wrzcr3FG8rxdgZdW/C+Sp+p1VK4KTXH2Iiz/en7oSmwKOD1zS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901420; c=relaxed/simple;
	bh=cHdnqYU+awkQMkJZ2A1ordwwL7SLK6QV8iIjzU+hbus=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtaPWPdlCzammbL836JUyMjknwSSDoVa8Co3oeUDMA/MkFdf04uaSTELvvvftfhNNrV243ZYxiEDJ9IuHJXvGbFZKzx+vqogDEayEfu3AxLtiyoYwyrSqqOoJoO9qGckurDIPrB5t3wXD5+91otpsMIS3mxnKmc+ncc6Tkh4PVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jeaWtMwp; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jeaWtMwp"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODuujnF1179689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901417; bh=VpjUPhjCQOIIZAT8g66vR9MpIiqLW3OiK3x2DxPITEo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=jeaWtMwpu7lcl20jGYNTKH/H3pBuvyutti5/vkwrK+GkbPz80kc8hi7DY9aZCSDW5
	 jQUkmrh5aaCTGdbDneibA5MIAO99UCBwOAfrAKW5DY9jbW994cD60+yf5mcsMOPL8f
	 qEMZeszvCiRfzmVjrlMp74L9fzDpzuIB0qa6SuZrU+oOpaFthRGFJ7ftQFqcXnibD9
	 7q4YslxW4mgZ14t8DOH5ab91dIcNd0dcaKxNLjLu4yOMGhI6AzQ3qjnAqFHaYtOdNB
	 TxUFZdM6jPB6rMvxWzWh6zxpSHGIqzCnrKc3mO5Q/1bv27GReP+U8DPIPREFCe7ns0
	 1VUXg707io7CA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODuujnF1179689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:56:56 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:57 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:56:56 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:56:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 03/14] wifi: rtw89: coex: Add firmware 0.35.111.X support for RTL8922A/D
Date: Fri, 24 Jul 2026 21:56:29 +0800
Message-ID: <20260724135640.3195044-4-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260724135640.3195044-1-pkshih@realtek.com>
References: <20260724135640.3195044-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Add BTC version table entries for RTL8922A and RTL8922D. The new firmware
need driver provide more chip initial related parameters.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 0c5599a23b4a..d873b9482e49 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -133,6 +133,15 @@ static const u32 cxtbl[] = {
 
 static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	/* firmware version must be in decreasing order for each chip */
+	{RTL8922D, RTW89_FW_VER_CODE(0, 35, 111, 0),
+	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
+	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 8,   .fcxbtscan = 8,  .fcxbtafh = 8, .fcxbtdevinfo = 8,
+	 .fwlrole = 10,   .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 11,
+	 .fwevntrptl = 1, .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
+	 .fcxtrx = 9,
+	},
 	{RTL8922D, RTW89_FW_VER_CODE(0, 35, 94, 0),
 	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
 	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
@@ -169,6 +178,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
 	 .fcxtrx = 0,
 	},
+	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 111, 0),
+	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
+	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 8,   .fcxbtscan = 8,  .fcxbtafh = 8, .fcxbtdevinfo = 8,
+	 .fwlrole = 10,   .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 11,
+	 .fwevntrptl = 1, .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
+	 .fcxtrx = 9,
+	},
 	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 71, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
 	 .fcxstep = 7,   .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 7,
-- 
2.25.1

