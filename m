Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2533C4565
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 07:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937334; cv=none; b=HF5arl6i0mGrnYee66jHkZ8H1GCeHlq/KFLA12bsXdCT47nc0iqMrGjSeyxTmAi0ljj0KU9zmbfl7JsgBafQZJlpE3F+4PB7AK6JcSPCDO9YOQ4gkYZVFvXsq7pXW+5jkSWSPMthIRHwA0m895SnHF5+VaUYQKN4Ob2vHfwkIME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937334; c=relaxed/simple;
	bh=6l7DFrpJ/hnBMxBD/ZA17+T41iwcdls7v/Hc0n5c6XA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HbY1FP7nQYLZAg1VuUSxafKhJVzNFz+/bt1LcDipiJiRpT63gkz6KgnrVBxySYG4jF01f2fltNFhIMXFccpFICWVskQtujBcLGqRVRds1/kgmknp6orDFJhpx4J0jJ0i+urQDX04eyOuNoKxiyv9mOP3H8I/UW2C11CIm2Rf41k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SDmAdali; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SDmAdali"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6897255R0357181, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788937326; bh=n/bUlT0r6mMgGV/wiBS5zcTjsIuF5xWFzg6DqJbQRpU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=SDmAdali0vbT+3WZQ/uzxxRu6UfoYckjVo3Gm2QI5et0m7k/gx57loadlzZA5A392
	 kEea+DLJnNMneIjC/GyoJI0R1GNkByXjRGl3iguJErXKV1Vdofuzre89+zEtMW+duM
	 Qk7Jbkuz+CgIzqit0lOUhTvWpLqj47Tjqjo3tdKS0ye4loa2qQ7wFTBLoCjwDKKO7m
	 xYURBSjtMg5Cl7oR96OFwDtSBTx5HbFiQinO3GYzjK8weBYUK8XCxMX7HLKL5VaJac
	 FLKUdRUy/MafOLG7LN1RRLUxRz9/SOr+kJIkXqpoCiiTZyJ/o+gZghZfPbp34ZCf8H
	 4HEgUtWVYODGA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6897255R0357181
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Sep 2026 15:02:05 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 9 Sep 2026 15:01:58 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 9 Sep 2026 15:01:57 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 14/15] wifi: rtw89: 8852b: update default value for ANA SWR
Date: Wed, 9 Sep 2026 15:00:03 +0800
Message-ID: <20260909070004.35353-15-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260909070004.35353-1-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

The RTL8852BE randomly card drops on certain platforms. Adjust ANA_SWR
behavior by compensation parameters to stabilize the switching regulator
output to prevent unwanted drop.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/reg.h      | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index e85af8713777..11b30be8f880 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -265,7 +265,7 @@
 #define R_AX_SPSANA_ON_CTRL1 0x0224
 
 #define R_AX_SPS_ANA_ON_CTRL2 0x0228
-#define RTL8852B_RFE_05_SPS_ANA 0x4A82
+#define RTL8852B_DEFAULT_SPS_ANA 0x4F42
 
 #define R_AX_WLAN_XTAL_SI_CTRL 0x0270
 #define B_AX_WL_XTAL_SI_CMD_POLL BIT(31)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index 356623341f65..c3c53a6b8119 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -355,10 +355,7 @@ static const u8 rtw89_btc_8852b_bt_rssi_thres[BTC_BT_RSSI_THMAX] = {50, 40, 30,
 
 static void rtw8852b_pwr_sps_ana(struct rtw89_dev *rtwdev)
 {
-	struct rtw89_efuse *efuse = &rtwdev->efuse;
-
-	if (efuse->rfe_type == 0x5)
-		rtw89_write16(rtwdev, R_AX_SPS_ANA_ON_CTRL2, RTL8852B_RFE_05_SPS_ANA);
+	rtw89_write16(rtwdev, R_AX_SPS_ANA_ON_CTRL2, RTL8852B_DEFAULT_SPS_ANA);
 }
 
 static void rtw8852b_pwr_sps_dig_off(struct rtw89_dev *rtwdev)
-- 
2.25.1

