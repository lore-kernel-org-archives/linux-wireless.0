Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269C4432E60
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790750806; cv=none; b=ccaFFQDdWy9gf/+N6L0of7kTRVT5pED94jcsdUr9pjPKtKmkD5lTbpYZlt/RgdpjMv58eyz3spW/LL361dfpR7dvFSruL1yJf8+oAkssJN85weTZSiZcpe6WGlGIwtzUlHuUIqTkWI1dFT9+yM/DO3zEF7zMC+4vkZMTWk9YSRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790750806; c=relaxed/simple;
	bh=yRj1t8wr0lryMmdM2fs8ruskbl3eOS8RTdVoQ0SmTf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mCFmyxXOgTN4r4eUoRy28zxpO3lKUWK+lT3czFM/xGjiMct/9chsHNTP0GxdOblTWSDJ4VUx7VG4Wluah5f+Tnx507eIIZnZffIb3oTlaZf86CjTDqQMSVKvfbGryDn/qCUX4t5GlSh3gcgyaG6fxMOVkA758GtJEafptT9h15A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=wy0PmLMn; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="wy0PmLMn"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U6kYzhD1883042, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790750794; bh=Sce+NpdQQO/J0lPHiYmLFwOJ/yP5evLIu4GeEQfXW4I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=wy0PmLMnFGZYfSRUhYZ7YJpEYnJPfBSYbG9a9HoHIrDG3plR3K+NiAP5Z+0EOah80
	 Be26ZP2A14+9Js853OqBaFZjByHLtuaqBTIMyb/nLN/nzet76K68B+uZUhNyxO9mJ3
	 BVs+BWyLUCKaC9EFBcxBz/vXKfwLLmoD5fHaaswVJwUFNp2JMXlpEPBdOfCB5h+OHm
	 nTSe+UmYMYxxZKnA5HskJ+v+a19DphQRlI43bb4g1rQ66x26aQIuPZ+Wp27q8DQSt2
	 K3Mo1lhS+yWWvI3IGiySQpP/ax7UVrwXkS4SCr9HRvJi0bGfkMFUDP/9BF4IXEKQQd
	 OwV6EbcxNnVeQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U6kYzhD1883042
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 14:46:34 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:34 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 14:46:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 14:46:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 5/6] wifi: rtw89: phy: write full data for BB gain table type 15
Date: Wed, 30 Sep 2026 14:45:23 +0800
Message-ID: <20260930064524.39403-6-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260930064524.39403-1-pkshih@realtek.com>
References: <20260930064524.39403-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Eric Huang <echuang@realtek.com>

Type 15 gain-table records now encode the FEM index in bits 31:16 and
the gain-table version in bits 15:0.

Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy_be.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index b94754d38673..73c98ae358ad 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -434,7 +434,7 @@ static void rtw89_phy_config_bb_gain_be(struct rtw89_dev *rtwdev,
 		rtw89_phy_cfg_bb_gain_op1db_be(rtwdev, arg, reg->data);
 		break;
 	case 15:
-		rtw89_phy_write32_idx(rtwdev, reg->addr & 0xFFFFF, MASKHWORD,
+		rtw89_phy_write32_idx(rtwdev, reg->addr & 0xFFFFF, MASKDWORD,
 				      reg->data, RTW89_PHY_0);
 		break;
 	case 4:
-- 
2.25.1

