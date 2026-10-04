Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D174761FCE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 04:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791086447; cv=none; b=D0nEojf/cIGelpfAy1cZsUETcPPh8XzyBSrBA8XH6M8ZG0kKYUYcjgjuPpFbzLGFIY3pS5PX3cSmnwTO2XFk5uenYswgdsyxoYAYX7w81iZ0ziLmG63N2afNtsk1KaWyOAvMEUBrs0jrqXuqJKO0S/qCnwFzngIDwm4vF+FmmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791086447; c=relaxed/simple;
	bh=suwiPohBRktnE9xdlc5oXYKsDgAIRDJhyN2KUZS8F+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYYf+C7DCSGZau3+GOBHO+jPAL7KcGmMw8KHeXbE0z3Bvp97n+iZHmyQ63qXCV8XYcq4q66YqBTK2uKmI17uyxQ3dVIrIwIX9jgxXa3JpHtLLTmSnljGTvjWlFc/wODd9Gjpc1OV2FBsYXIB7MTMMMMjmcJ0fbyFk73Swqt+Nn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=j7NwAOqD; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="j7NwAOqD"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69440hStA833979, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791086443; bh=0b150Tr8eEv84xgW/MwpyAZAFaAv4ZNGEadHhVKyZ6Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=j7NwAOqDl+SI1/P8x9NXCnzvwskxl/gUwJj6O7rEnejURYy57ya+iPpH34Mfce/qa
	 teDZ7C9/W8O5lTOCB5ODA3tX7bvDLubGUqnuyoSe3ng8QrMInucCa2Ap9BAJ6/yRPq
	 5pA+d4BmEZDsYy4sPUYLAq/0Ap5ZMDOjVnPw6b7nBp7IfCISSwNMjISTvxJSOCycXV
	 XA+b18/hhSrYvESVR4QRY0eB/ZDlSUSvtUhppc08HtXp+rEkwfamjYvuD/ddZWilC3
	 mPDhmb8HOwYK3kYkKXWsqi73nzoOSRapCQWlh1cFrgk7z/qDaBeUKpHHXfNg6a8tNZ
	 htVtkatwCXykw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69440hStA833979
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 4 Oct 2026 12:00:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 12:00:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 12:00:43 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Sun, 4 Oct 2026 12:00:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 1/2] wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.2
Date: Sun, 4 Oct 2026 11:59:52 +0800
Message-ID: <20261004035953.36785-2-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261004035953.36785-1-pkshih@realtek.com>
References: <20261004035953.36785-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Update 0.35.119.3 Wi-Fi firmware support. Fix dual BT, dual MAC,
MLO mechanism binding control not working issue. Fix AX/BE serial
chips logic mixing error.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6b72e2c80d14..4fa9632649d1 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -11,7 +11,7 @@
 #include "ps.h"
 #include "reg.h"
 
-#define RTW89_COEX_VERSION 0x09180113
+#define RTW89_COEX_VERSION 0x09180213
 #define FCXDEF_STEP 50 /* MUST <= FCXMAX_STEP and match with wl fw*/
 #define BTC_E2G_LIMIT_DEF 80
 
-- 
2.25.1

