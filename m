Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B2280CC1
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269234; cv=none; b=K1fRFAk7gVTJzUqHRCcY/nHHQo+sXcZm5WoLrOTu8fYuHvhsivW5xFielKs1yiHAP1Gb0OnpW94uO0Ah55krcu2KeybIzkukzMxiFqOkqFxOUM3cO3+v8wGNexpgwDm3DcOHSuAybvuyk1UNLfiGBA+cAGhgh4xs+uXoRfMOVCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269234; c=relaxed/simple;
	bh=qLu0Fi0noGbsqUNSV1RMRI9mTV0TXGWHeEQoP2i3IaQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MR28XFOCdz5SQtvXLRD98q2S3sY1Zd5MkEajqZb3eh0m/LfoAYb/d0auOpyBElL4Wu1ojk6xIo+nlv/8bdZX0IMGXtmCTZOaUSpBWh6j5WoO3tQpzt47hPEVJjiiSrK7VAzmwBWCS6ifTvUNlOuAxyOE7duJ3szcY01kWmIpWWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=sqhFcwkE; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="sqhFcwkE"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KTr444163411, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269229; bh=rPreDSqnlFDnypKP/pkhal7/fI/q3wCz7Q/sI413onk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=sqhFcwkEXy/Yef+z7ExvjJsWK16Y/nLGPc/1ArVFZCRvWCw87/w0o5aO3+PCcERkF
	 ErgzoNZ1vhHpd5IIkr8Xdkdofl7ZNJLIsCuubz/iypbhBPW2sZHV92nogKxIcqCc6T
	 eJxefY7Zozlcv1lZt5vV5Fu0aBVMKVXwaRYT/kCeEDFc9/NpzxKIttnGXuTY3QcA5X
	 F5Yfqa3VwDEUyt8z8Uvl0tx5oe8pGr4GwYsKj136jyDwaAO3wShMWJME17wS3n5N6U
	 vaiwOIpnrfMRUsRXQmO5v/SXK4mCerye88zCCVgM+m7Fk0PD3pd00kZdH0EdEIYjcE
	 Ss7kbqc+VTaIg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KTr444163411
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:29 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:30 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 3/9] wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band
Date: Fri, 17 Jul 2026 14:19:04 +0800
Message-ID: <20260717061910.54466-4-pkshih@realtek.com>
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

From: David Lee <sc.lee@realtek.com>

Add RTW89_QUIRK_DISABLE_2GHZ to the rtw89_quirks enum to allow
per-device suppression of the 2.4 GHz band.

Apply the quirk only for the 0x28de:0x2432 (VID:PID) USB device,
which operates only in 5/6 GHz bands.

Signed-off-by: David Lee <sc.lee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/core.c      | 3 +++
 drivers/net/wireless/realtek/rtw89/core.h      | 1 +
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c | 3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index b87a72700b99..77a0e2582dbe 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -6418,6 +6418,9 @@ static int rtw89_core_set_supported_band(struct rtw89_dev *rtwdev)
 	u8 support_bands = rtwdev->chip->support_bands;
 	int ret;
 
+	if (test_bit(RTW89_QUIRK_DISABLE_2GHZ, rtwdev->quirks))
+		support_bands &= ~BIT(NL80211_BAND_2GHZ);
+
 	if (support_bands & BIT(NL80211_BAND_2GHZ)) {
 		sband = rtw89_core_sband_dup(rtwdev, &rtw89_sband_2ghz);
 		if (!sband)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 70cf6cbf4e8a..9d782cbfee70 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6057,6 +6057,7 @@ enum rtw89_quirks {
 	RTW89_QUIRK_THERMAL_PROT_120C,
 	RTW89_QUIRK_THERMAL_PROT_110C,
 	RTW89_QUIRK_HW_INFO_SYSFS,
+	RTW89_QUIRK_DISABLE_2GHZ,
 
 	NUM_OF_RTW89_QUIRKS,
 };
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
index 51dd8fb05366..2dec9b845481 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
@@ -97,7 +97,8 @@ static const struct rtw89_driver_info rtw89_8852cu_valve_info = {
 	.variant = NULL,
 	.board = &rtw89_8852cu_valve_board,
 	.quirks = NULL,
-	.dev_id_quirks = BIT(RTW89_QUIRK_HW_INFO_SYSFS),
+	.dev_id_quirks = BIT(RTW89_QUIRK_HW_INFO_SYSFS) |
+			 BIT(RTW89_QUIRK_DISABLE_2GHZ),
 	.bus = {
 		.usb = &rtw8852c_usb_info,
 	},
-- 
2.25.1

