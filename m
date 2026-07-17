Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B5C280CC1
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269265; cv=none; b=FcKeSkVop/EAPI3OPHRNTmj1iMdKzj7X4ItV169cAy5Kr/8421eJhHK7WKjdUF2SlHrcATylF4Af7IN81gssoVrMNvVcUPhCS5b4MivKldUc1ToioZLHOSJH+EpmtoqnlkuFOxYICOFIcBMVkQv7Qu36P8YO2kggD0P0c9hAtkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269265; c=relaxed/simple;
	bh=mW3uA2YeK/HBe8SIj/EVSZ2Q6cRwHHhByH5Xht5B/l4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I03u2+XQ/EsmPeQe63Lzhzmo0Icb2gd/sK58JXXcmkjIgcvHp3EEbigDES4j6b72IqL5iJpXS2p7r5XhXRGt6BiLeTO+7nkPz7sr5Fz6IVazjOt8rwEaEVJTwlCkBvIhPt+SN05AYCSL4kPuxCImbcZxCLiTo5xAdNN4/zzh3sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ufBpWjS4; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ufBpWjS4"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6L1Jw84163732, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269261; bh=7UWzMUPB6VXJ/rMOvkKjNeRt38QTdymT8DsGue7md0U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=ufBpWjS4H7PEy1N8FGD7ZEeIoavnziMixNg/hMJJDcv8ZlNJ1ltBHYUlsYm8/Ra98
	 KkKsp0hDiE/yq0SPqiOvOebvKtoGxonk/biY1sdxtHful44zvEURCbtNWat4X7ojqr
	 dFGrF0fovkgRf+7rRvw2pK7w/up0YK5QUZBLlMgYzZlNcmwb1Fmsan6MUR8IexpeMd
	 fb6HiWs5GT4jPVm2vNhffV3l2032Fvrl2unx182GNk8U5r/Iotkiwz6gzH2AdD6nVP
	 VE8QnZAkROLhC9Gb9zp47a2lH+KkBl4OjR5/hXpx+P8Lc6dsmIghqUwPd0kLYhjgL9
	 yQAlNCMlZtYIA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6L1Jw84163732
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:21:01 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:21:02 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:21:01 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:21:01 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 9/9] wifi: rtw89: phy: set CFR to manual mode for some 2GHz channels
Date: Fri, 17 Jul 2026 14:19:10 +0800
Message-ID: <20260717061910.54466-10-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717061910.54466-1-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The CFR (Channel Frequency Response) manual mode condition for 2GHz is
missing to limit on bandwidth for specific channels, which are channel
13 with 20MHz bandwidth and channel 11 with 40MHz bandwidth. Also add
a band check to avoid affecting 5GHz/6GHz bands.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/phy_be.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy_be.c b/drivers/net/wireless/realtek/rtw89/phy_be.c
index e471409a4b8f..c06927d1dc78 100644
--- a/drivers/net/wireless/realtek/rtw89/phy_be.c
+++ b/drivers/net/wireless/realtek/rtw89/phy_be.c
@@ -707,13 +707,19 @@ void rtw89_phy_bb_wrap_set_rfsi_bandedge_ch(struct rtw89_dev *rtwdev,
 					    const struct rtw89_chan *chan,
 					    enum rtw89_phy_idx phy_idx)
 {
+	bool cfr_manual_en = false;
 	u32 reg;
 	u32 val;
 
 	val = rtw89_phy_bb_wrap_be_bandedge_decision(rtwdev, chan);
 
+	if (chan->band_type == RTW89_BAND_2G &&
+	    ((chan->primary_channel == 13 && chan->band_width == RTW89_CHANNEL_WIDTH_20) ||
+	     (chan->primary_channel == 11 && chan->band_width == RTW89_CHANNEL_WIDTH_40)))
+		cfr_manual_en = true;
+
 	rtw89_phy_write32_idx(rtwdev, R_TX_CFR_MANUAL_EN_BE4, B_TX_CFR_MANUAL_EN_BE4_M,
-			      chan->primary_channel == 13, phy_idx);
+			      cfr_manual_en, phy_idx);
 
 	reg = rtw89_mac_reg_by_idx(rtwdev, R_BANDEDGE_DBWX_BE4, phy_idx);
 	rtw89_write32_mask(rtwdev, reg, B_BANDEDGE_DBW20_BE4, val & BIT(0));
-- 
2.25.1

