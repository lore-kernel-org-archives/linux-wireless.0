Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF86440655
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543448; cv=none; b=IBlvHnBM6uinGXaYw63hLLURSZ8l5hRH+sQVIae/dPweKuokVMwqBXPa2W3nVQ75xWEsWoj3pNZSm/XA7Vvgvo7L8yjoyAeMN8X/a1203Bic55w5Xyi4jJZekCtQIwta3h0teoVDOF+KXCgFGn72qV8VAEYwk10nuApOoLU7QCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543448; c=relaxed/simple;
	bh=pdNgV+SXt2Fz4J+OSgJu/HI7lgCqEBQKe7HBLM9ylIw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/F3vRhnae1BGg/4bE9f7FSpVHsaNJz40Q8Y1A9EVx/UFjwctk/htccsHwp7VZcnr+cytFREeEs3H2sM772C3K9s6rVJ53Oj0vrHkjNhBKBovwkwCYnlPeLUEhL6yu6MiWxvwuftqTPZdOKKinS+PFr7eVoLGx+wXz/X1yXDJzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=S25XuE9E; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="S25XuE9E"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NxUJ22168510, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543439; bh=0H4GY4jI16uaFFxuNnpmFxi8cOHXGVcylgXPb0ZfqKk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=S25XuE9EVebMfNtpT6sm1pvIX+r0DIeHIj4f5HT0g47gM4j9SOUetJttEoz2v6nCR
	 MsUmI/La4iKBqBLqHl6RgNqhwNJATD0gmuBb7aqeGyeOPwIkYxEJtxg2yIcbQVmq3O
	 U0sA7rb7goP6oN/QVW3LFa3z6ELOvkJ5pn7SyiS4lInQ2W5s8SKFRD548bL4dN1h2k
	 sth4Q2aMFBA338i1I0D2zFvgzxb5lcouHyyPC9J3MYb315Bw2dSLXaKDDoEdEecHqy
	 fKq/6/AaS9wdayRK4vpCI9FDQRV1d0/Br8BGcq1BpBD3tbpxdLFujNf1JyuQ6S5/pi
	 5J+s6ytczSWkQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NxUJ22168510
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:59 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:59 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 09/15] wifi: rtw89: coex: add fcxtxpwr version dispatch for CXDRVINFO_TXPWR
Date: Wed, 16 Sep 2026 15:22:32 +0800
Message-ID: <20260916072238.62574-10-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260916072238.62574-1-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Some firmware sends the TXPWR H2C with a version that differs from
the one implied by fcxtrx. Add a dedicated fcxtxpwr field to
rtw89_btc_ver so the TXPWR H2C version can be chosen independently.
It defaults to 0, keeping every existing chip on the fcxtrx-based
selection, and is set to 1 for the firmware that expects the
versioned H2C: RTL8922A 0.35.111.0 and RTL8922D 0.35.94.0 and later.

The ver=1 TXPWR H2C shares the rtw89_h2c_cxtxpwr_v9 layout and only
differs in the header version, so let rtw89_fw_h2c_cxtxpwr_v9() take
the version as an argument instead of adding a near-identical
function. Update the CXDRVINFO_TXPWR dispatch to send ver=1 when
fcxtxpwr is set before falling through to the fcxtrx-based selection.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 52 ++++++++++++-----------
 drivers/net/wireless/realtek/rtw89/core.h |  1 +
 drivers/net/wireless/realtek/rtw89/fw.c   |  6 +--
 drivers/net/wireless/realtek/rtw89/fw.h   |  2 +-
 4 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index b7b06b28009e..1fb4a7176179 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -140,7 +140,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 10,   .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 11,
 	 .fwevntrptl = 1, .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
-	 .fcxtrx = 9,
+	 .fcxtrx = 9,     .fcxtxpwr = 1,
 	},
 	{RTL8922D, RTW89_FW_VER_CODE(0, 35, 94, 0),
 	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
@@ -149,7 +149,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 10,    .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 10,
 	 .fwevntrptl = 1,  .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
-	 .fcxtrx = 9,
+	 .fcxtrx = 9,     .fcxtxpwr = 1,
 	},
 	{RTL8852BT, RTW89_FW_VER_CODE(0, 29, 133, 0),
 	 .fcxbtcrpt = 9, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -158,7 +158,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 7,   .frptmap = 5,    .fcxctrl = 7,  .fcxinit = 107,
 	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 103, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
-	 .fcxtrx = 107,
+	 .fcxtrx = 107,  .fcxtxpwr = 0,
 	},
 	{RTL8852BT, RTW89_FW_VER_CODE(0, 29, 122, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -167,7 +167,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 7,   .frptmap = 3,    .fcxctrl = 7,  .fcxinit = 7,
 	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 1, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852BT, RTW89_FW_VER_CODE(0, 29, 90, 0),
 	 .fcxbtcrpt = 7, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -176,7 +176,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 7,   .frptmap = 3,    .fcxctrl = 7,  .fcxinit = 7,
 	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 1, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 111, 0),
 	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
@@ -185,7 +185,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 10,   .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 11,
 	 .fwevntrptl = 1, .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 6,   .fcxmlo = 2,   .bt_desired = 8,
-	 .fcxtrx = 9,
+	 .fcxtrx = 9,     .fcxtxpwr = 1,
 	},
 	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 71, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -194,7 +194,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 8,   .frptmap = 4,    .fcxctrl = 7,  .fcxinit = 7,
 	 .fwevntrptl = 1, .fwc2hfunc = 3, .drvinfo_ver = 3, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 1,  .fcxmlo = 1,   .bt_desired = 9,
-	 .fcxtrx = 7,
+	 .fcxtrx = 7,    .fcxtxpwr = 0,
 	},
 	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 63, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -203,7 +203,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 8,   .frptmap = 4,    .fcxctrl = 7,  .fcxinit = 7,
 	 .fwevntrptl = 1, .fwc2hfunc = 3, .drvinfo_ver = 2, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 1,  .fcxmlo = 1,   .bt_desired = 9,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 8, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -212,7 +212,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 8,   .frptmap = 3,    .fcxctrl = 7,  .fcxinit = 7,
 	 .fwevntrptl = 1, .fwc2hfunc = 1, .drvinfo_ver = 1, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8851B, RTW89_FW_VER_CODE(0, 29, 133, 0),
 	 .fcxbtcrpt = 9, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -221,7 +221,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 7,   .frptmap = 5,    .fcxctrl = 7,  .fcxinit = 107,
 	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 103, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
-	 .fcxtrx = 107,
+	 .fcxtrx = 107,  .fcxtxpwr = 0,
 	},
 	{RTL8851B, RTW89_FW_VER_CODE(0, 29, 29, 0),
 	 .fcxbtcrpt = 105, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 5,
@@ -230,7 +230,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 2,   .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 97, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 4,    .fcxslots = 2, .fcxcysta = 105,
@@ -239,7 +239,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 101, .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 107,
+	 .fcxtrx = 107,  .fcxtxpwr = 0,
 	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 57, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 3,
@@ -248,7 +248,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 1,   .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 42, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 3,
@@ -257,7 +257,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 1,   .frptmap = 2,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 0, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 3,
@@ -266,7 +266,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 1,   .frptmap = 2,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 133, 0),
 	 .fcxbtcrpt = 9, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -275,7 +275,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 7,   .frptmap = 105,  .fcxctrl = 7,  .fcxinit = 107,
 	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 103, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
-	 .fcxtrx = 107,
+	 .fcxtrx = 107,  .fcxtxpwr = 0,
 	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 122, 0),
 	 .fcxbtcrpt = 8, .fcxtdma = 7,    .fcxslots = 7, .fcxcysta = 7,
@@ -284,7 +284,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 7,   .frptmap = 3,    .fcxctrl = 7,  .fcxinit = 7,
 	 .fwevntrptl = 1, .fwc2hfunc = 2, .drvinfo_ver = 1, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 29, 0),
 	 .fcxbtcrpt = 105, .fcxtdma = 3,  .fcxslots = 1, .fcxcysta = 5,
@@ -293,7 +293,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 2,   .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 14, 0),
 	 .fcxbtcrpt = 5, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 4,
@@ -302,7 +302,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 1,   .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1800,
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 27, 0, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 3,
@@ -311,7 +311,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 1,   .frptmap = 1,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1280,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852A, RTW89_FW_VER_CODE(0, 13, 37, 0),
 	 .fcxbtcrpt = 4, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 3,
@@ -320,7 +320,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 1,   .frptmap = 3,    .fcxctrl = 1,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 0, .drvinfo_ver = 0, .info_buf = 1280,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 	{RTL8852A, RTW89_FW_VER_CODE(0, 13, 0, 0),
 	 .fcxbtcrpt = 1, .fcxtdma = 1,    .fcxslots = 1, .fcxcysta = 2,
@@ -329,7 +329,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 0,   .frptmap = 0,    .fcxctrl = 0,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 0, .drvinfo_ver = 0, .info_buf = 1024,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 
 	/* keep it to be the last as default entry */
@@ -340,7 +340,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fwlrole = 0,   .frptmap = 0,    .fcxctrl = 0,  .fcxinit = 0,
 	 .fwevntrptl = 0, .fwc2hfunc = 1, .drvinfo_ver = 0, .info_buf = 1024,
 	 .max_role_num = 5, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 7,
-	 .fcxtrx = 0,
+	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
 };
 
@@ -3589,10 +3589,12 @@ static void _fw_set_drv_info(struct rtw89_dev *rtwdev, u8 index)
 		if (ver->drvinfo_ver == 3 || ver->drvinfo_ver == 103)
 			index = 4;
 
-		if (ver->fcxtrx == 7 || ver->fcxtrx == 107)
+		if (ver->fcxtxpwr == 1)
+			rtw89_fw_h2c_cxtxpwr_v9(rtwdev, index, 1);
+		else if (ver->fcxtrx == 7 || ver->fcxtrx == 107)
 			rtw89_fw_h2c_cxtxpwr_v7(rtwdev, index);
 		else if (ver->fcxtrx == 9)
-			rtw89_fw_h2c_cxtxpwr_v9(rtwdev, index);
+			rtw89_fw_h2c_cxtxpwr_v9(rtwdev, index, 9);
 		break;
 	case CXDRVINFO_FDDT:
 		if (ver->drvinfo_ver == 3 || ver->drvinfo_ver == 103)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 7fee587a8162..57fa1ce080dd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4390,6 +4390,7 @@ struct rtw89_btc_ver {
 	u8 fcxmlo;
 	u8 bt_desired;
 	u8 fcxtrx;
+	u8 fcxtxpwr;
 };
 
 struct rtw89_btc_btf_fwinfo {
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 33eb09e56f95..5b33bdb5a3e8 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7458,7 +7458,7 @@ int rtw89_fw_h2c_cxtxpwr_v7(struct rtw89_dev *rtwdev, u8 type)
 	return ret;
 }
 
-int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type)
+int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type, u8 ver)
 {
 	struct rtw89_btc *btc = &rtwdev->btc;
 	struct rtw89_btc_dm *dm = &btc->dm;
@@ -7470,14 +7470,14 @@ int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type)
 
 	skb = rtw89_fw_h2c_alloc_skb_with_hdr(rtwdev, len);
 	if (!skb) {
-		rtw89_err(rtwdev, "failed to alloc skb for h2c cxdrv_ctrl\n");
+		rtw89_err(rtwdev, "failed to alloc skb for h2c cxtxpwr\n");
 		return -ENOMEM;
 	}
 	skb_put(skb, len);
 	h2c = (struct rtw89_h2c_cxtxpwr_v9 *)skb->data;
 
 	h2c->hdr.type = type;
-	h2c->hdr.ver = 9;
+	h2c->hdr.ver = ver;
 	h2c->hdr.len = sizeof(*h2c) - H2C_LEN_CXDRVHDR_V7;
 	if (dm->wl_tx_pwr_phy_map == BIT(RTW89_PHY_1))
 		h2c->pwr = rp.wl_tx_power[RTW89_PHY_1] & 0xff;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 294399bf57b1..5df3bb97249a 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -5538,7 +5538,7 @@ int rtw89_fw_h2c_cxdrv_trx_v9(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_trx_v107(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxdrv_rfk(struct rtw89_dev *rtwdev, u8 type);
 int rtw89_fw_h2c_cxtxpwr_v7(struct rtw89_dev *rtwdev, u8 type);
-int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type);
+int rtw89_fw_h2c_cxtxpwr_v9(struct rtw89_dev *rtwdev, u8 type, u8 ver);
 int rtw89_fw_h2c_del_pkt_offload(struct rtw89_dev *rtwdev, u8 id);
 int rtw89_fw_h2c_add_pkt_offload(struct rtw89_dev *rtwdev, u8 *id,
 				 struct sk_buff *skb_ofld);
-- 
2.25.1

