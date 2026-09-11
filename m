Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7CA43CE7F
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110285; cv=none; b=lBPLL9ToYk4iM8jJq7h3HL54bu+Kjpp+R190CWtAt+LPxwrwnuIv0fS647E/iy6DNh/uZ8sCsgwo/hUGrywIB3WNOqV9RtKKYGVcxU5IVIhy7XUIXdO/DaOj6sfEDLA661O1q774AobrcuHlRb7dOE+yC0uiS0my17T92rJjShQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110285; c=relaxed/simple;
	bh=+08dk40FChkVztUH6t+7QV1GEbrVLDBX0fqanu93lzU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NhBFHYioNThPa3ZHBIW9WvL402qEHaHJBBCji9+63i3cPSy/Vlx9lZ+sdfm6wB46jjCxTW1mzR3kPE+2b08olIK45c1vcqr9m52aB5e0XpL9cBbq+po97Z11QktS4jlWhJeVBYwYP+ldLPf8VykCS1pEbuFuPo57sLiOUCNZkT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Pw+J5+Is; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Pw+J5+Is"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68B74WlmC2190795, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789110274; bh=vJWB1W/51nUEr/QB+YGDNhF1BM5i5akehrR5nIDGQrA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=Pw+J5+IszeohbVJS4jF5SFyOBFWn+dcAuwsCf4ct32frr1CA22DnNLcC5IlCMNLj1
	 dm1fpbETegW9KOk/jLc8SjIcfCQxouQ1Rg6KlsoFJ4Wh9dyR68Q60S77Kw4yRPfZBm
	 CDzOsDtP3jdp0O+y+3ngtEgik3HerGmtmbYrmc7NTptsmfGZFUe1uCd8l5kMICoBdw
	 9HL7+ajYQYl+GRVaNJcqdszTT0GhSgtJGK6pfINkc8oQuPJjHLouWLTZUCc8yobLvy
	 glhrxOCGALasjem6+c1jdJ3yc3VSp0JCBLx2n4+00dEZeZiAHJ/IYG8pDqahXNxk6x
	 MqQbYePbAk0KA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68B74WlmC2190795
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Sep 2026 15:04:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 15:04:33 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 11 Sep 2026 15:04:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Fri, 11 Sep 2026 15:04:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <error27@gmail.com>, <ku920601@realtek.com>
Subject: [PATCH rtw-next] wifi: rtw89: coex: cancel RF band return condition at _set_bt_tx_power()
Date: Fri, 11 Sep 2026 15:04:07 +0800
Message-ID: <20260911070407.35803-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Ching-Te Ku <ku920601@realtek.com>

Because RF band value 0 means 2 GHz and, if the condition set !rf_band
return, the 2 GHz BT TX power will never been set. Correct the logic.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/aoXrgwyFu851qVNV@stanley.mountain/
Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index e49d75cc55a1..b16af1291b93 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3859,7 +3859,7 @@ static void _set_bt_tx_power(struct rtw89_dev *rtwdev, bool force_exec, u8 bid,
 	u8 buf[2] = {};
 	u8 len = sizeof(*buf);
 
-	if (bt->bcnt[BTC_BCNT_INFOUPDATE] == 0 || !rf_band)
+	if (bt->bcnt[BTC_BCNT_INFOUPDATE] == 0)
 		return;
 
 	if (bt->rf_para.tx_pwr_freerun == level)

base-commit: f71dd599a98182d6bc34dce39977f928068ecd64
-- 
2.25.1

