Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A834B3D1AA2
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271574; cv=none; b=f0GCeRac0UKviPIbMz18P2QrBsJC8P4qyBAyHLAd+YwuaBfR46I8CeNgP64PlOzDRc9Nz2/E83xgahvgsbsq6mfVQ3ey6kh0liH9FPBr2ZQMWGDcZHIXTiIGXT1bXVmxt1gs4A/MySxstmvBrBo1Ayo9a6LD6KT0K5xSuqfMjNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271574; c=relaxed/simple;
	bh=1tIdAD1mLDDpfOFgxvwp5c9nhMlv5rZ+/JXoiPqJtWw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJGiAuRCnMFo3XzgiW0fgdbbMtEcI0wJU5uw413l4mob0EuXm1Pk33F2IMIB8tHshWpiqGv5NGs3rv/PNjGkFISga1w64AmUtErvU0+gmH7MPAnMUkrqsRQHrZliNYspriSIuQHCB5WMhOh3Df4BnfQ4Ak3WsWNAgusou4lunLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=n0Fw2wbX; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="n0Fw2wbX"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6xUfxD4176752, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784271570; bh=cGPtFnwihVaoS2zy7sPpbHjF0nlbnfngDJoLsgpA9a0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=n0Fw2wbXmTMLK1rsgMqd0ESuYm8/EEO9HdBJ9Hgr3vEVacPjPtAtDE2x1SlEdEWvT
	 H4LA7gGcPLtzeUcqh7tPXw3KEQ/+LS8TsjkxrWpfl7P6j5i6lbXM20FoYMEFWQ0y3E
	 fe9rPUxOXLDkCV20wYKDTRnZCy48nBkRZSrXvy78VqMrEMMJHSEOCtPJ5ilK2kpgkg
	 sChhuUvpDL/OwVKeuhRQapXFBMgmnPuVWds6lTz72HarWRQyPZHlMnIlEqh4ZHvjg3
	 nc4IBp+S+Y0fPbtM/LhSJ2sS1FDza8SLorsDOxnk57CLLlWJeB6fHfD6mR/FvfjVMX
	 sjQ5akifIBnbg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6xUfxD4176752
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:59:30 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:30 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:59:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:59:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: [PATCH rtw-next 09/13] wifi: rtw89: coex: Add TDMA version 4
Date: Fri, 17 Jul 2026 14:57:35 +0800
Message-ID: <20260717065739.64124-10-pkshih@realtek.com>
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

TDMA version 4 uses new TLV-Header to package TDMA information,
patch related entry for version 4.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 6bbcc6cd5dae..51108ce5ce31 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1705,7 +1705,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 			pfinfo = &pfwinfo->rpt_fbtc_tdma.finfo.v1;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_tdma.finfo.v1);
 			fwsubver->fcxtdma = 0;
-		} else if (ver->fcxtdma == 3 || ver->fcxtdma == 7) {
+		} else if (ver->fcxtdma == 3 || ver->fcxtdma == 4 ||
+			   ver->fcxtdma == 7) {
 			pfinfo = &pfwinfo->rpt_fbtc_tdma.finfo.v3;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_fbtc_tdma.finfo.v3);
 			fwsubver->fcxtdma = pfwinfo->rpt_fbtc_tdma.finfo.v3.fver;
@@ -2212,7 +2213,8 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 				     memcmp(&dm->tdma_now,
 					    &pfwinfo->rpt_fbtc_tdma.finfo.v1,
 					    sizeof(dm->tdma_now)));
-		else if (ver->fcxtdma == 3 || ver->fcxtdma == 7)
+		else if (ver->fcxtdma == 3 || ver->fcxtdma == 4 ||
+			 ver->fcxtdma == 7)
 			_chk_btc_err(rtwdev, BTC_DCNT_TDMA_NONSYNC,
 				     memcmp(&dm->tdma_now,
 					    &pfwinfo->rpt_fbtc_tdma.finfo.v3.tdma,
@@ -2559,7 +2561,7 @@ static void _append_tdma(struct rtw89_dev *rtwdev)
 		tlv->len = sizeof(*v);
 		*v = dm->tdma;
 		btc->policy_len += BTC_TLV_HDR_LEN + sizeof(*v);
-	} else if (ver->fcxtdma == 7) {
+	} else if (ver->fcxtdma == 7 || ver->fcxtdma == 4) {
 		tlv_v7 = (struct rtw89_btc_btf_tlv_v7 *)&btc->policy[len];
 		tlv_v7->len = sizeof(dm->tdma);
 		tlv_v7->ver = ver->fcxtdma;
-- 
2.25.1

