Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA49B2F99B8
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901467; cv=none; b=UPYsFDRwLJ2IRz4XNHrJG7jHs2DqGItpX0KLhDbZh/s5YyTkHRoCpHABXWVhHg6FAEITqZoqvxI8/tWeQXOmbL6dd05ReVNR+cqOA12JdPQhJWQ0yVGgid9svZWOMLkpfmkH7xfyGG/Plnw7NPq5IDuKpsdc8e+TcCTHvh4Ki44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901467; c=relaxed/simple;
	bh=1LcKkbQlz5IaQj/IC8RvWGii1jF/04DFE2qGGnQxdIo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ncoBk7doUqoJ65JETxxOA3Kp4u+TLUnPJJGu5qNbBV10Le80AIGdP7VMnrY3Cl0UjwoNqdXU9FvUViCLrDL5wYAIVv3esi7hDUSs0vYDDvBGmlP8FA+Aum7vE0TkkuUnHnJehxyynnTDTezBJ00pp4cavWts13DqSHortz8Xydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=nKOPm18+; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="nKOPm18+"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66ODvhlbF1179823, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784901463; bh=bZeO/0ApXxtE7GRC/eSg0m6wk+9/63lKApaurxay+yk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=nKOPm18+dRhyr1wAiqdx8aKkm8n6K5j3cq5voYtBFDpvFT8gLpPjRFTU9HDUj9pRA
	 0oUS9uMGdDEVOMIWBIq53uCIRzZtjACs0n609C2p4k1iJH+A1bap8gmwhD6V7jvM+d
	 lG7o5X1Usr+cjWK7yQAlcKmELprbPs6PZvrrA0su3a73lR7uZp2cFmpWcCLLs0pex7
	 UrdX/B0NlYmyrv0YWsf2phDl5CwVZvrmLfga5AkoLgYtNU7RvJyb2TrPo+JjLg275v
	 w3mLabWHArB6yXuGcnU07APLZ4OpEsZfEz+/rZNqJhdOxxO8cSGztm2EItDUzTw6Vt
	 um+uvL63tbb3A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66ODvhlbF1179823
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 21:57:43 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 21:57:43 +0800
Received: from [127.0.1.1] (172.21.40.76) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 24 Jul 2026 21:57:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 12/14] wifi: rtw89: coex: Fix TDMA v8 handling to unblock BTC report parsing
Date: Fri, 24 Jul 2026 21:56:38 +0800
Message-ID: <20260724135640.3195044-13-pkshih@realtek.com>
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

fcxtdma=8 was not handled in _chk_btc_report(), causing the parser to
hit 'goto err' and return 0 when processing the TDMA sub-report. This
broke the _parse_btc_report() loop before reaching BT_VER (type=9),
leaving bt->ver_info.fw always zero on RTL8922A/D.

TDMA v8 uses the same struct layout as v3/v4/v7 (rtw89_btc_fbtc_tdma_v3,
12 bytes), so add it to the existing v3/v4/v7 branch in both switch cases.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6a718c54de67..7ab22c60a420 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1769,7 +1769,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_tdma.finfo.v1);
 			fwsubver->fcxtdma = 0;
 		} else if (ver->fcxtdma == 3 || ver->fcxtdma == 4 ||
-			   ver->fcxtdma == 7) {
+			   ver->fcxtdma == 7 || ver->fcxtdma == 8) {
 			pfinfo = &pfwinfo->rpt_fbtc_tdma.finfo.v3;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_tdma.finfo.v3);
 			fwsubver->fcxtdma = pfwinfo->rpt_fbtc_tdma.finfo.v3.fver;
@@ -2300,7 +2300,7 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 					    &pfwinfo->rpt_fbtc_tdma.finfo.v1,
 					    sizeof(dm->tdma_now)));
 		else if (ver->fcxtdma == 3 || ver->fcxtdma == 4 ||
-			 ver->fcxtdma == 7)
+			 ver->fcxtdma == 7 || ver->fcxtdma == 8)
 			_chk_btc_err(rtwdev, BTC_DCNT_TDMA_NONSYNC,
 				     memcmp(&dm->tdma_now,
 					    &pfwinfo->rpt_fbtc_tdma.finfo.v3.tdma,
-- 
2.25.1

