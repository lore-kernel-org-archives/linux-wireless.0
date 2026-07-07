Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C071D390CA6
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 09:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415547; cv=none; b=emdZ9hqRN9C+Lc0kpI+p1OeVPUjfYvAKLHFbNN5PyPdc9G+lN53H1/LMNOQO1pKcFQXZjnylwmj18JPGgD2Pk6HNZNFuHAKzAI70oVkK+am90dzgdwICD3q7MuV8GySZmJWS5p6AsHPzVakJj/k2H3Cvf96idGeovcnVXm3KrQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415547; c=relaxed/simple;
	bh=wdNAppFna3gtR/WGkJJFLRr0bxmQXrZeN916qACdrXw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Knn8EMLTfe10BIz/lUBspH4zvcFplup4jkPBxBal4My+MyDCdkPyeY2ayTTlk/SOlJKFNNj3e07Tt/H5g7hZRnw8AAjcCwofc31bj+Pvcn6dK8ATb8YL9C0chi9g+wQU8UujketT/VfjnavRrtnzlpaowqslv0eNazWCkm+3kec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=aYVowwoU; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="aYVowwoU"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6679CNEO01359541, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783415543; bh=bZsoNA263znpWumsJwSnx/c6B6uqQ6E83zLN+5K6pGc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=aYVowwoUMp9Cqzist6C8MUfNiooH3LK80fUGJLdoBRBUiu2WNRPwU4xJtChlKtLt2
	 cahJmv9YvQsiHGYwC78GuOSq/4qUZE9jA48FCUwPXYxSSdFbAbnx/v2zBjpXJ3ykgl
	 E9dykyoVQ2aiHRk9ShMaYDeH/PX+wcjfyYAFM1bU7oyVO4G1WnAGp9q7aFJrvOCzp6
	 e8rlVcBuia18pTp6ZtDFNN//UD/wUt+b160jEmRxfsgNEfxGOhJr0J0R3V7QPyBaNx
	 w5aJTk0QlwjDxiHKZ566rkbXm0fcvkAalHpa7Nod+YHAiT6p78EqeMWOaUCKfbuBHW
	 GUrSC6H7wvKYw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6679CNEO01359541
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Jul 2026 17:12:23 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 7 Jul 2026 17:12:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: [PATCH rtw-next 06/15] wifi: rtw89: efuse: no need to export rtw89_efuse_read_ecv_be()
Date: Tue, 7 Jul 2026 17:10:47 +0800
Message-ID: <20260707091056.42771-7-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707091056.42771-1-pkshih@realtek.com>
References: <20260707091056.42771-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The consumer of rtw89_efuse_read_ecv_be() is in the same ko. No need to
export it.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/efuse_be.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/efuse_be.c b/drivers/net/wireless/realtek/rtw89/efuse_be.c
index 70c1b8be662e..a716ad54fce5 100644
--- a/drivers/net/wireless/realtek/rtw89/efuse_be.c
+++ b/drivers/net/wireless/realtek/rtw89/efuse_be.c
@@ -537,4 +537,3 @@ int rtw89_efuse_read_ecv_be(struct rtw89_dev *rtwdev)
 
 	return 0;
 }
-EXPORT_SYMBOL(rtw89_efuse_read_ecv_be);
-- 
2.25.1

