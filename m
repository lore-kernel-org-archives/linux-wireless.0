Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802DF392C39
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 09:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415521; cv=none; b=cZfU7WNVhGu7lTn3FNlzoPPNVGi4+cZBPcTuB+u4d5HkvjFA0ylBzjDUBhkV9kgJQEuk+fJT0xt3Epswqa3fzawGctUpaigmlc2kGEAi1w0HLT1rTia+3yjNzP5uDvoRW3kYPugT/uhdFqCHHjMyvhwNvnlETw6MR0yM1uzZrwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415521; c=relaxed/simple;
	bh=sNT7tXVh70+OSV6tqyqottgJwSnBBjxcsaNkMX0f4EY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AuIvZWsMxJf0sbNBvPdO1mRqqA4LChWicd7ZPrl2BsyeXI89Y0feXfhVpmmjrfxCnzNDLlKyjqjo8pRFRxN62U8cbVmiSOwu6AjERGD9ZFBrK95yAnVb+qPvVThtfiPVmRmY7JVwDMdhPKSbKGmF9u+dqnbfBJlWyAzrps/VtuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vS2Mzopb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vS2Mzopb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6679BvYsA1359415, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783415517; bh=ueBvWC06y8ivF8842ua0w9kObETk8zriAES3/2nHIyM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=vS2MzopbCavf14LLApi+UjdXsrqd70vNCH2+7NklCDdgvVzYWFVfu8jj2z8IGslMB
	 vyk1IPZ5EhoFekoyiu4/+dFTtwtpgQ/xoCb87ARXf00/cQClFzJ6lBqmlEd3lbhvez
	 /NPiyzHEIqWh0rEEeuAce9oRgrbmYNMMNnbrjCiSnMBDdsI+wOqQy5FEX7L+4Zf6c5
	 smbYQMEFYPZF+yY+h7+ngaCCGMVGYUuUNniGZ/32LsMNtwMb2is/ggWe/uunS/K3nj
	 ahRPeXYvDDt4JnduQPfPr7SkxOKd1v+f14BooHhIZp2MXv+gNZE9DwliBCCF3gDCuU
	 kEVwVHJ19DbnQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6679BvYsA1359415
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Jul 2026 17:11:57 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:11:57 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 7 Jul 2026 17:11:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: [PATCH rtw-next 01/15] wifi: rtw89: 8922d: remove CCK bandwidth compensation
Date: Tue, 7 Jul 2026 17:10:42 +0800
Message-ID: <20260707091056.42771-2-pkshih@realtek.com>
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

From: Eric Huang <echuang@realtek.com>

Remove the 40MHz bandwidth compensation from CCK efuse gain calculation.
The design no longer requires the +3dB compensation for 40MHz channels.

Signed-off-by: Eric Huang <echuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index f78d6d46e65f..625f8d675f08 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -1634,10 +1634,6 @@ static void rtw8922d_calc_rx_gain_normal_cck(struct rtw89_dev *rtwdev,
 	s8 rx_gain_offset;
 
 	rx_gain_offset = -rtw8922d_get_rx_gain_by_chan(rtwdev, chan, path, true);
-
-	if (chan->band_width == RTW89_CHANNEL_WIDTH_40)
-		rx_gain_offset += (3 << 2); /* compensate RPL loss of 3dB */
-
 	calc->cck_mean_gain_bias = (rx_gain_offset & 0x3) << 1;
 	calc->cck_rpl_ofst = (rx_gain_offset >> 2) + gain->cck_rpl_base[phy_idx];
 }
-- 
2.25.1

