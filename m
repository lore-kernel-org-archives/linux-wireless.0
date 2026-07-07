Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DD538F93B
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 09:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415537; cv=none; b=bx9POM9reT3dnlZndctucpgU+oucEjuuHi2EAwYKwrqfbwXX+sOefIpo/tVTYa/AsfaJH0Qf4gWq+xW7EaMv3IahvpoRdIysYuebBA3Bz3/QUdayJFQNCHt/aZ0qaAXk4fbBMnK+WFVKt5d9LwMqw0WpPqPQU+0K0enjbOilGbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415537; c=relaxed/simple;
	bh=DX+ntFTitJOGytYjLnb9gGLsCRHowt90VMiPq7VDslM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eC0DmJw/3QreCVTEJRfnZxfWXK8xFsGGbAmRv9sojH1JjsoOh1HDF9XQRifHMPggTlrzLbKLMVCgCM13Q6xgH1MJ9vGfF88z55PIWGF3MaQajdPBG5GrMZRsNKg68Jt3ZIt8usaSEdQK8DOqOHEWK0u0WO2uBtaOaedyMzqOnv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=UApiNxc0; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="UApiNxc0"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6679CD0A01359505, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1783415533; bh=GXTLCoNiLsla4tPs06C/RPxNtWvejxTbo1TtRf+MXuM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=UApiNxc0zNMxiIuGVJjkLIB438/03WatR+5U6ZsbHF7AqK+10pKNPKD7qqKzV4CEB
	 xJGjGqS/AevtXgKyQlAi6N/LqVFwdNX9qweQ4mLf2c7lob85fEOn7kQP06YckfPBOH
	 ulrCC0Q/GRxEved5F73R8IF8cZUi4MF8S0HA+Wzz9AkwNu7g4vzf2bSrVbHbVOiTFM
	 VXatuFjkJAyYlIG8g0WLKAROxMoviw4lDcuv7YBlNqFLKBhndvQLQ5QmGiaqT6vBqS
	 frhWictWVwk1wY1B9RdtDIAFdfbH6a23mwBkzOUvvPsSUaBHGlwxKoLCt+wQFrsOxJ
	 lc1afk1BqqHEA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6679CD0A01359505
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 7 Jul 2026 17:12:13 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:13 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 7 Jul 2026 17:12:13 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Tue, 7 Jul 2026 17:12:13 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>
Subject: [PATCH rtw-next 04/15] wifi: rtw89: phy: fix bandedge primary channel for 2.4GHz 40MHz and 6GHz
Date: Tue, 7 Jul 2026 17:10:45 +0800
Message-ID: <20260707091056.42771-5-pkshih@realtek.com>
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

Correct 2.4GHz bandwidth 40MHz bandedge check: pri_ch 5/9 instead of 3/11.
Remove stale 6GHz bandedge case; no restricted band borders 6GHz range.

Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy_be.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index 99263355e2f1..ac4ce30445b3 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -623,7 +623,7 @@ static u32 rtw89_phy_bb_wrap_be_bandedge_decision(struct rtw89_dev *rtwdev,
 	case RTW89_BAND_2G:
 		if (pri_ch == 1 || pri_ch == 13)
 			val = BIT(1) | BIT(0);
-		else if (pri_ch == 3 || pri_ch == 11)
+		else if (pri_ch == 5 || pri_ch == 9)
 			val = BIT(1);
 		break;
 	case RTW89_BAND_5G:
@@ -637,8 +637,6 @@ static u32 rtw89_phy_bb_wrap_be_bandedge_decision(struct rtw89_dev *rtwdev,
 			val = BIT(3);
 		break;
 	case RTW89_BAND_6G:
-		if (pri_ch == 233)
-			val = BIT(0);
 		break;
 	}
 
-- 
2.25.1

