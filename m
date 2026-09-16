Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FB144AB94
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789543433; cv=none; b=OEKPl/WwfX9tjJ3MOR+ZZdSXHW9/p96Wb0hyBNYRVkdhi/ksOceuGT2l+3Zu//S+eu+vE3LHttJpJYQHNkyrR6ptSX5bCh3XoKLejd3mX80hOPfJ3vZa0tm55scnTLDsz3ZNJu2Lz0FgFGmgP1MEyWjzOszDKMi4jQ2OYnjQh1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789543433; c=relaxed/simple;
	bh=c2P27ThDEiA+9Fc2xIIymwg5yBPt+hN8JUIj3GN0tJo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KTROUNetbQvBsl/4l2onUuai1U4UoaZwBm1KA9Ma3kwaKdEC5H7EzSzbKEFcH10NHVqq3whj5VFvstuxM3EPb3Ix9ygSvNl8vUrqbIUVLybvonoh9xIObLbm2gUjlvPafHk/s0UdyLwexja0Xvvl9Ldl354mUdbOktAnEyZFn00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Uh29ia9Q; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Uh29ia9Q"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G7NUtyC2168395, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789543411; bh=imcXMSOPk/SpxKfzqCf0Jb6U5DFD/vm6QkAhJBoX0TA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Uh29ia9Qhc0cqYDoV3uaQ23Dbc7Q2n2FgUqesbfiTPXeeG2eWcuFwbOw1ZT8pgZGC
	 PNz12cXL6y6E6N1A6mdWtrcfv+VPgmt1Nf6/quLZ4Qr5412iZOPFFOKh9vwgEW+sjC
	 sU2J6FlKYnOKRNRrVB2ystYEO44NaDo0NEoM5FeAsNWIiAbDsQfosjwjF2wsjbEORs
	 uYAHshyw0SBYn0p1siYGA0B7KB1Jt/Rjxbht1Jjeg8GhJf1ZY1jXG6rjpPzlMMzl43
	 4NbTelKKjmEfhvwDTA/EnSEU3gQJrKa/EiSVO97sLsO0rDVmUgDnOmM1aKILTqxShK
	 FHwF1fuC/OKtQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G7NUtyC2168395
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 15:23:31 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 15:23:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 15:23:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 04/15] wifi: rtw89: coex: support version 8 for gpio_dbg FCX report
Date: Wed, 16 Sep 2026 15:22:27 +0800
Message-ID: <20260916072238.62574-5-pkshih@realtek.com>
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

RTL8852C (FW >= 0.27.130) and RTL8922A/D (FW >= 0.35.94/0.35.111) set
fcxgpiodbg to 8, but _chk_btc_report only handled version 7, causing it
to fall through to goto err.

The gpio_dbg v8 struct is layout-compatible with v7, so extend the guard
to accept version 8 using the existing v7 parsing path.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 279b75461fe2..62b86dc40e87 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1908,7 +1908,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 		break;
 	case BTC_RPT_TYPE_GPIO_DBG:
 		pcinfo = &pfwinfo->rpt_fbtc_gpio_dbg.cinfo;
-		if (ver->fcxgpiodbg == 7) {
+		if (ver->fcxgpiodbg == 7 || ver->fcxgpiodbg == 8) {
 			pfinfo = &pfwinfo->rpt_fbtc_gpio_dbg.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_gpio_dbg.finfo.v7);
 			fwsubver->fcxgpiodbg = pfwinfo->rpt_fbtc_gpio_dbg.finfo.v7.fver;
-- 
2.25.1

