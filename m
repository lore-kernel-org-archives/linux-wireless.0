Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC90384CC4
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 05:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327073; cv=none; b=Ug0jRtXXrInZdmR5kHO457p524aJ7c3rtuNJ3GXSg8WGpGBKHV5vH2Rs8GJ7d2JJkkeDZv956IhBvx5QoXXkdALnOJo5h0iVOQjU9iOUPZ05554ZxqF8vjj/eHz6SdA8ye1VMxN3OWY0bKnuFIOlp35+uQnH+h4WFyPl8vNnF+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327073; c=relaxed/simple;
	bh=qIjbiuvlx89sPXD0ApHvIW72HWolbFDCiMLhLRru3mI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C587V44E3eTujQI26MrDSKH78oeM3AyCgZbySj2osnd4kaXPp06RB1/Na2NjhROa1RiBggrHWKkop65UrHyVyUHYZlHCSn3RrSZzy5YJh95akFI4/uNiRyNUe71wJmFVGpbuqENdmWq04fhMnKpttubPShL1XxfW50Fcz5qr5gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=o5kYnwjm; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="o5kYnwjm"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6825V9R702368514, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788327069; bh=Gdc23se2Ri77YhxcJorcw8iCgspiXYR5VOYIX6OFS5Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=o5kYnwjm4l2Ci1/6A5Zdko+yrt3y7yfeTi1Aou8URJUCKYKZyVwDeN7UMc2o7G1jw
	 VDMN5/yNviW0rgbpeEHeFQaVK/TWeNcIcqqPZ8ZgfwfaZ3MlFOVrPty/sBs844exUM
	 QZFibAZLYuWtjXOcGjYDDn9jceNGdDii49BT9ou+IyobiiSWnWyjN2g0QHC0TUkE2H
	 HRrGx/+9FMaioFkKQdn2hwaufKEB2ubSLTTa49lPNykwFBWOtoS+XwS1ZnK7tLtiwX
	 nWxMdLqyXWnEyl18amLn9R5bjocTjHTfpUC9XotdAL4vclNyMpQ8PCVdLcQmSykQDc
	 0iiwkvtFJWKzg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6825V9R702368514
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 13:31:09 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 13:31:09 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 13:31:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next v2 10/14] wifi: rtw89: 8922d: correct selection of CCK rate circuit
Date: Wed, 2 Sep 2026 13:29:54 +0800
Message-ID: <20260902052958.50371-11-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The RTL8922D has single one shared CCK rate circuit. When operating on
0+2 mode, the selection should be on RTW89_PHY_1. For 1+1 operating mode,
select RTW89_PHY_1 only if PHY0 isn't on 2GHz band but PHY1 does.

Also, change the operating mode of debugging value from decimal to
hexadecimal to be easier to read.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/chan.c     | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index 6f11335b4968..99b52ca05fe2 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -527,7 +527,7 @@ static void rtw89_entity_recalc_mlo_dbcc_mode(struct rtw89_dev *rtwdev)
 	mode = rtw89_entity_sel_mlo_dbcc_mode(rtwdev, active_hws);
 	rtwdev->mlo_dbcc_mode = mode;
 
-	rtw89_debug(rtwdev, RTW89_DBG_STATE, "recalc mlo dbcc mode to %d\n", mode);
+	rtw89_debug(rtwdev, RTW89_DBG_STATE, "recalc mlo dbcc mode to 0x%x\n", mode);
 }
 
 static void rtw89_entity_recalc_mgnt_roles(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922d.c b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
index 287a9476bb77..75297b39c4d7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922d.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922d.c
@@ -2471,14 +2471,15 @@ static int rtw8922d_ctrl_mlo(struct rtw89_dev *rtwdev, enum rtw89_mlo_dbcc_mode
 		rtw89_write32_mask(rtwdev, reg1, B_BBWRAP_ELMSR_EN_BE4, 0);
 	} else if (mode == MLO_0_PLUS_2_1RF) {
 		rtw89_phy_write32_mask(rtwdev, R_SYS_DBCC_BE4,
-				       B_SYS_DBCC_24G_BAND_SEL_BE4, RTW89_PHY_0);
+				       B_SYS_DBCC_24G_BAND_SEL_BE4, RTW89_PHY_1);
 		rtw89_write32_mask(rtwdev, reg0, B_BBWRAP_ELMSR_EN_BE4, 0);
 		rtw89_write32_mask(rtwdev, reg1, B_BBWRAP_ELMSR_EN_BE4, 0);
 	} else if ((mode == MLO_1_PLUS_1_1RF) || (mode == DBCC_LEGACY)) {
 		struct rtw89_entity_conf conf;
 
 		rtw89_entity_get_conf(rtwdev, &conf);
-		cck_phy_idx = conf.chans[1]->band_type == RTW89_BAND_2G ?
+		cck_phy_idx = conf.chans[0]->band_type != RTW89_BAND_2G &&
+			      conf.chans[1]->band_type == RTW89_BAND_2G ?
 			      RTW89_PHY_1 : RTW89_PHY_0;
 
 		rtw89_phy_write32_mask(rtwdev, R_SYS_DBCC_BE4,
-- 
2.25.1

