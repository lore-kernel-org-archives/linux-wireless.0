Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0675A2E11D2
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 06:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785391379; cv=none; b=RO70fjQuwlWRWOIgj+q+6UIbnYoznz/0NboZo9JDHGmzK3ehx1ctghzTRxeRv2CMxWI50ZTmvmqzsbgPVWRumeXPfKSbEQNhAm9unHO05NFCtMWuE3IxliqjMGSDHiWj4/YAyXX6WXnF31NSk9NHArE7P1hJRF0AdcJIymb3RMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785391379; c=relaxed/simple;
	bh=uz2UmqbPRwRML94XEqccKcFHEQBLEx4LwiabhM/lASY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L86RGji+SDMPTZfQOhyesUZnbaug7j3wl98hSDIsN1Juag64w0w+t3tVTv474z3sh0OIScF0xNuHtwNq0NtiUUsPfjexSwo5I79VHsuNq5LcN/wENhvw06Ku9HynNe41JqOT+oRKcu+up5845ix73To5okds/ydL7iBY/HmTte4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=FT847fKt; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="FT847fKt"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U62tXmA985942, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785391375; bh=P7Yqrr8pD1gzAR/Z5D+D3uQ0NBuR7WJ9wBbsPKJzuDw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=FT847fKt34ZsdIFoJzKp/RrrdLVRGKIga7NplKOIh63nqgR49Bo/XVgiVJaBf7k2q
	 nf0wwa5trki1OFZn2anl9VOlR5pb9nOeMHz5CfSTQLzZBe+oRSkHBA/7PMABpMTCzX
	 wnUCSs4bXDiUoTXkemS1md1helVRRUM/F6K762ddODfG+iXxdEKbbNCNk9iE8AA0nA
	 PEL23IQVkzF4eqRu9/2j+EpDoDkpQhLc2s5QUlp90/XEdNr6MVglRWfeArqP2nDDTz
	 tz7mdTEHA2joq8a7hUpxb2pYHW176l+b5mJBKkZlJ+Nb7pPiTsJZA7MNrMimoHd9Y0
	 TsVaBSeNEzT0w==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U62tXmA985942
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 14:02:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:55 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 14:02:55 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 14:02:55 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 6/7] wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.1
Date: Thu, 30 Jul 2026 14:02:19 +0800
Message-ID: <20260730060220.55844-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260730060220.55844-1-pkshih@realtek.com>
References: <20260730060220.55844-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

The 9.24.1 coexistence version included firmware 0.35.111.X support for
RTL8922A/D, 0.24.97.X support for RTL8852C, 0.29.133.X support for
RTL8852B chip family.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 39dff9fdc1cd..5a9dc4d8a00b 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -11,7 +11,7 @@
 #include "ps.h"
 #include "reg.h"
 
-#define RTW89_COEX_VERSION 0x09180013
+#define RTW89_COEX_VERSION 0x09180113
 #define FCXDEF_STEP 50 /* MUST <= FCXMAX_STEP and match with wl fw*/
 #define BTC_E2G_LIMIT_DEF 80
 
-- 
2.25.1

