Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07823E2777
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 03:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085606; cv=none; b=gzgVwdEfSoyN7recy8kMIul0zUm7MA8avXtcqkT5x2eJPgGQ4dTF+oII4LEWqX1Qjaq4ZeJxoINU/ckMLmI2dB1EQgVWal7fQ8sfGEnFtcOubsRu4msfJ3dYbllSnsFpcc23gFegfTCkstUwVyB7OWqDLmMM3KzrGPJCh/xQBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085606; c=relaxed/simple;
	bh=KUBSvF0ShdYD4PwFvDkR1BUwEwiMoR5J8eVN9yJ6yVc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tVXpa30hlhfCbMANE13yLi9lV9pdHNBpbk01zc4koItAorAaqNhyOaFt0AET5BOglidsudAltnbe7/2GvHwVFwQsZzAy3PwAtaBF6lG0g4Z1ViDcI0t/gDdmDbW/qhfFuJxGnSkSV90leiC0DdZN2Unh88PI/0PAXppxnU+iqZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DQL2sLha; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DQL2sLha"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6943kgK73829561, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791085602; bh=f7JBTnpcI1NJGNHHsp/55ifbiSeUwOvRU3pL/ArOKck=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=DQL2sLhasvL8jQnqbjV/OY4pvKPTIj/WJ85Xkxj/Xh+wzu1Xj6rKjJ+LajRVRMtSZ
	 W/ogoyemo8H078swGRqBBzIF95f/GXAsvp5WsqRuH8lgGXEwNMLZ59zM30PkFKUHWT
	 ym7wwCATacUdTStzzanwx353iMN7yKDu6vJzttVp2aRwT9TVNsRx2HdAhStTE8Zb3c
	 mXOuiEYgQKGX3ELNEEK4QLt9fKD1G/zH4Mfl/N/x28SszDJWQhmOmjdAx4ep3wM7LP
	 qXEa+mTT89E1YpR10oTWZF/m9GkSNPq1ho11LNRX0WY/f+IU+DdQ1VJ5XfqqRZ90Iz
	 m23EF1AsRT7hg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6943kgK73829561
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 11:46:42 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 11:46:42 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 11:46:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 07/15] wifi: rtw89: coex: add firmware 0.35.119.3 support for RTL8922A/D
Date: Sun, 4 Oct 2026 11:45:12 +0800
Message-ID: <20261004034520.33695-8-pkshih@realtek.com>
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

Firmware 0.35.119.3 moves both RTL8922A and RTL8922D to coex H2C
role-info version 11 and outsrc-set-info version 7. Add top
ver_defs entries for both chips with the new fwlrole and fcxosi
values; all other scope versions are unchanged from the previous
firmware.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 0b9858d1859a..80c278aa96f0 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -133,6 +133,15 @@ static const u32 cxtbl[] = {
 
 static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	/* firmware version must be in decreasing order for each chip */
+	{RTL8922D, RTW89_FW_VER_CODE(0, 35, 119, 3),
+	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
+	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 8,   .fcxbtscan = 8,  .fcxbtafh = 8, .fcxbtdevinfo = 8,
+	 .fwlrole = 11,   .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 11,
+	 .fwevntrptl = 1, .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 7,   .fcxmlo = 2,   .bt_desired = 8,
+	 .fcxtrx = 9,     .fcxtxpwr = 1,
+	},
 	{RTL8922D, RTW89_FW_VER_CODE(0, 35, 111, 0),
 	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
 	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
@@ -178,6 +187,15 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .max_role_num = 6, .fcxosi = 0,  .fcxmlo = 0,   .bt_desired = 8,
 	 .fcxtrx = 0,    .fcxtxpwr = 0,
 	},
+	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 119, 3),
+	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
+	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
+	 .fcxbtver = 8,   .fcxbtscan = 8,  .fcxbtafh = 8, .fcxbtdevinfo = 8,
+	 .fwlrole = 11,   .frptmap = 5,    .fcxctrl = 9,  .fcxinit = 11,
+	 .fwevntrptl = 1, .fwc2hfunc = 4, .drvinfo_ver = 3, .info_buf = 1800,
+	 .max_role_num = 6, .fcxosi = 7,   .fcxmlo = 2,   .bt_desired = 8,
+	 .fcxtrx = 9,     .fcxtxpwr = 1,
+	},
 	{RTL8922A, RTW89_FW_VER_CODE(0, 35, 111, 0),
 	 .fcxbtcrpt = 11, .fcxtdma = 8,    .fcxslots = 7, .fcxcysta = 8,
 	 .fcxstep = 7,    .fcxnullsta = 7, .fcxmreg = 7,  .fcxgpiodbg = 8,
-- 
2.25.1

