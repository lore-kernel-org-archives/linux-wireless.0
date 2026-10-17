Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E7335F619
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 15:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251760; cv=none; b=XZuQBvvv0lZnuiQpwkSQSE2hvePDzBhm8yfyn3Hf1KhlsPoaGSk8k/oR5yJnXLfutlIvC9GEOeHlPbmUMh3w5XAdVcMetJpmYt8uNCdq2YjWHds6wYUc3ej4w2FbqgV+YId9E/LXucD67f2jLREFNHrliPsnxpqE6aMqu1smivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251760; c=relaxed/simple;
	bh=dTpKNY4MZH7g+Ivjj6pWY78uOur/Jt+K2MLhhvrrD9Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=U5shAKBrZgFZqx8Z/aRa5xS6WgZ0+DAIeCeqh4uFodyhPYIv/SwgOvDJRcl9Qaw7T2BnJ8b/wxnokO2CBeJSTs9xAYZz4JrZ0WEG3SrYIKEH0WUHkG1u3ZT6iLTHuhP6Xf7bY2ceRfqiiiZigbHygWxaWBwXllIWqX1kszWGStY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMI2Qb+A; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMI2Qb+A"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a1d484b4a9so11281655e9.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792251757; x=1792856557; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m+YHW2+OfscAb/uB+qvUpTN/vYCgHgURqLPkFHvasWg=;
        b=BMI2Qb+A6zfTTR7tPdwpOW7m/KBITkGXr7zAPFZVZBqT4+9ccD8c+alqzlUzDYOQll
         62sL9QWkr9qVEAtPC6Pw+lW3uH/syKT4G2Gdj8lg/8C/pqeJbkj86XgjbM6d8/J0MbqO
         s5wr9HcSzTT+8X9APrPP3U3c6zTPQPps8ZSzvyX3jy/LonTl2uUmkF8LKtdnUYM7GrTM
         VNKfduWfAha4jiuQ1lC7qrVrbNp6dmzUtn0CDKKYByfJUMTaRPvs65KVDq3o0D2arH8Q
         ZReFltfexofow823b0CYWkHygAUvchMRgM9fk8Pd5ZPaNT0Li+rP2RCblEs+UvtX5Wf4
         7L8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792251757; x=1792856557;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m+YHW2+OfscAb/uB+qvUpTN/vYCgHgURqLPkFHvasWg=;
        b=cL8tcEWU5cKRGLdiCrHqoRVp6+eSe4qfzFdEakkSVXspy3uwgrZLkn9IuI9Hef7VJr
         dtG1WwMXxdgd364gPamB6peoP/iDShlVKXQKgNWhrSmzlPLDRjZwua9LTJ2XZH7ezHHR
         Tf6QQJObdqC8fOCGzLaG8cI7Qyko1zarvohaTtrM78hLeOTN/1X/QZ72qtX5muqxeSAi
         3Fu6p+ugUagezDtvlanjI9rv+YPBf95vPFMi8z/Il/TAiiUwRY0lqX6atkm5hoL6mS3A
         4d43DuXZJaMwnHzWMf1IqZX3p87Brv0QpRFcpvVXWdEYTP7AJS/3CZxcff1fyLlBBgJL
         n8rg==
X-Gm-Message-State: AFq9FYJ/2eo7F4EOGfOvthCGClWlrj12+KXUPfw+xrzDcPna3jwfARK7
	vkP7agDLECgpH0FIIVrtam+F+UFMoJ128MhjLXgMY/eIskHi3zFEbu4nh8OsnQ==
X-Gm-Gg: AYBFou1kaKVLC30toHz1aEru5YDdmVH2QGVVcXKD/vkgYtcjvp6KejYNFO2bXZxsFAz
	Wjk85G7zi9uJfEnpL1EgdNt/qOq3naIbgI7hMPv5dtVR1y9pdI6nGoNbT9AyQmzfcaIha23uS1A
	w/EDMg2fyXscYMf+cpnlTntVu8cqN81daO3qB/zqqWwvLZnpnYC55uwFibffs4HPLFuKGoarOaH
	yBA0HoqgOsP/ft5cUdxywgk7RRB2aEsclC4trputpdIvRlcVnCYfH+dwL4S87vRJrSqS/btFPu7
	U+JbCxI60YEgn01hIcmIfg1Xxymy10a5ij7JmBK0pOKnYvymBdTRonCLhQkVYGagYMpk9dTfHei
	hl/VV6bWGu5nYzcLRaOryZOUNkjVfg6V7/XNmhue09T2gJye85vrACl7E8lsdtbNRJSTQjykXgH
	M+br921Ulb63ig7umSi/xSMxMq2viHPho/ZsxRsEuJbjIb/pV0eJoCbK5B4GYwwa54FPfcSBk4z
	XWTFokKgQK8WJ7U
X-Received: by 2002:a05:600c:1c04:b0:4a1:e0b7:ff0c with SMTP id 5b1f17b1804b1-4a1e0b800a0mr7576295e9.8.1792251756323;
        Sat, 17 Oct 2026 08:42:36 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8ce32absm96098775e9.1.2026.10.17.08.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2026 08:42:35 -0700 (PDT)
Message-ID: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
Date: Sat, 17 Oct 2026 18:42:34 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from efuse
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Some chip package types need different parts of the RF initialisation
table, so read the package type from efuse.

Also disable support for 40 MHz channel width based on some other bits
of the same efuse byte. This is not exactly the package type, but the
vendor driver puts it in the same function.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 35 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |  8 +++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 8bb9c03d769c..fa57900b22fa 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -6,6 +6,7 @@
 
 #include "main.h"
 #include "coex.h"
+#include "efuse.h"
 #include "fw.h"
 #include "mac.h"
 #include "phy.h"
@@ -2349,6 +2350,38 @@ static void rtw8723b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 	fill_txdesc_checksum_common(txdesc, 16);
 }
 
+static void rtw8723b_read_package_type(struct rtw_dev *rtwdev)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 val_1fb;
+
+	rtw8723b_efuse_grant(rtwdev, true);
+	rtw_read8_physical_efuse(rtwdev, 0x1fb, &val_1fb);
+	rtw8723b_efuse_grant(rtwdev, false);
+
+	switch (u8_get_bits(val_1fb, GENMASK(2, 0))) {
+	case 0x4:
+		hal->pkg_type = RTW8723B_PACKAGE_TFBGA79;
+		break;
+	case 0x5:
+		hal->pkg_type = RTW8723B_PACKAGE_TFBGA90;
+		break;
+	case 0x6:
+		hal->pkg_type = RTW8723B_PACKAGE_QFN68;
+		break;
+	case 0x7:
+		hal->pkg_type = RTW8723B_PACKAGE_TFBGA80;
+		break;
+	default:
+		hal->pkg_type = RTW8723B_PACKAGE_DEFAULT;
+		break;
+	}
+
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO &&
+	    u8_get_bits(val_1fb, GENMASK(5, 4)) == 0x2)
+		rtwdev->efuse.hw_cap.bw &= ~BIT(RTW_CHANNEL_WIDTH_40);
+}
+
 static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -2374,6 +2407,8 @@ static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
 			   BIT(RTW_CHANNEL_WIDTH_40);
 
+	rtw8723b_read_package_type(rtwdev);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.h b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
index cf93b93ede81..8201109c18f2 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
@@ -9,6 +9,14 @@
 
 #include "rtw8723x.h"
 
+enum rtw8723b_package_type {
+	RTW8723B_PACKAGE_DEFAULT,
+	RTW8723B_PACKAGE_QFN68,
+	RTW8723B_PACKAGE_TFBGA90,
+	RTW8723B_PACKAGE_TFBGA80,
+	RTW8723B_PACKAGE_TFBGA79,
+};
+
 extern const struct rtw_chip_info rtw8723b_hw_spec;
 
 #endif
-- 
2.55.0

