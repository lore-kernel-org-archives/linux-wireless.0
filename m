Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529514;
	b=tpVtEciPIEDc3BkqC6WYs/S4uum0nOnZqmC/AjEQPBpG8mv3mEzK+v4P+qZibSbJDvxZ
	 3t6ZDK92f6IGBIvqIE66BqPtxdgFyxP3iZMp5M4P+NDGSelu2iOxHcllEWAM75pSw+xsh
	 ZuVbl0Qjc5KC/39S0Oiwm2ZdhZJi9D3QSCyESxyNK4eCLZCk7Yv/aldK0HNrtEaHQsBYl
	 akzCFCnsUmfct5msAIypSutXwel6eCR8gHxFVEB/2/kk/ZiYM2liD4d0yOGPbvPctAtLu
	 W7aNtZCyhqjO39AwgLSSqX9kec4uwwvC4yU/X3uSBQM/q39F1wSQxknk8lfw4bRP8SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=uvG8gm23Ib8BEgCQFLrjoxs/wJVmsx/j5eNtdQF94ro=;
	b=yysOy7TylcUv/D/Vk8hJ2MgoY4NCS1ZOoaSOhw4SrQSY+X5Ie2Ih3SIPd/nF9I2hE2Ak
	 h39z5CjiKfFDQkUFbrMizMlnw2TU7ZLGZOR36EwJvQUq+TFFNyo5L3gGUFrstzznsS9ie
	 PtZZneZDmSi/2hL2RLq3VwWSwrq3ZcL2zhYc7fxCFrMbM+QYZTbBZSzeTW83MD11tkVoe
	 OYNVM53ZxP/ZAYuQgLn3iRqzXzT7kNqpmh8t/t5Rx6wEcGgLeOMEz3f60ZiAfRh1LbnQG
	 xT920khIlm2YqCZWhkfUApcfGOVLeHqTFEAVhUOZqWOyBK7yyIFWJH0sGu6a0PtuoLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NCjxjj35;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A75D606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A75D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NCjxjj35
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a01933b584so322335e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529512; x=1793134312; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uvG8gm23Ib8BEgCQFLrjoxs/wJVmsx/j5eNtdQF94ro=;
        b=NCjxjj35S2wNBRdSIijX/dF51nO2hIuwb3yBCoq6AiBBe3B51aLlxvqJ6H+/S0mMVz
         y2HpqlhzAYeii9IKkqLfHThSQTUmCU6Xtln7FqnVajUx6viGvWaoqVYV45/7Itm6batM
         UTZe/RP+kmygfcvCjcfg1svT5QEozxZoeRP6NsMwdCoEtUXpnBvFbfnKS0u1XV9eozF/
         qlz4GlGSJkc1RdDQPgT3+7bmY5cJ8oB+/MkOTVIFIh7VWibmVTIyMmWIdhbQ/dkfAR2g
         i8pvbFMeaI5YwqUJrJvtzPKGIQb93OoEGiPtxzww/k9z8E9ws82SgyX8220FC796ZiCO
         mLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529512; x=1793134312;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uvG8gm23Ib8BEgCQFLrjoxs/wJVmsx/j5eNtdQF94ro=;
        b=HdWbx6Gw9VAi3ldEaQiCMS60xTKGGDtxKOjVBaqTP33uQkn68Wz0kGLcKvhAaQEnr8
         VjognlfXb1/30R45N++72vpBY6LzSt0QacgwXxDfkiACYNFiBc8f8wP4fZ77LY5iMkKe
         d/3+/vi26gE5EQK8X4NKJu40oaXNBReqgbEHedYSfjG11Y2FyBYvgeI3T77Nygv2rpDH
         CljYVDwO1/H2RRs6jC779vEulp2yEBWUMxe7ABgi9fBCKYeJlMs6Yyw/wGGrLr54ee52
         NUwQSbnowRyFQShy4nXXzN3jkUS9WI8uTMc5MyMyUfw3A6aYqsr92slAr9XyfwpXDzkY
         4SAQ==
X-Gm-Message-State: AFq9FYI6awoJPbHRV1IILmlg/3hjssdyGwL1Dn3X6OR+tG6tqnQndJF3
	rZcX9X3KwBU3POeP/B//swIpX+JIOZK44VfF2Zgjc0O87H63xBFUZX464/nWNA==
X-Gm-Gg: AYBFou3fcZlh7E3F2stlOE+MMtwb+kG2vfiB+wWzTcCHO2jgETpQP98RLOgQ5h8qVvW
	BgwTfnCOxqAAdX9Z0Qwd2/AhliyYE/RJy7IMDShM1WNV5hi4eEkNc5vjtzy4IjahBj4jGACoLB7
	/Q3dPJf6UAWq+//uznWiNlbRrslVYHKhdSroi372GNJZUKXqNWHXFE/G8XMwOPeGqx+MJwJC59N
	czkaYoj8HjKTsH5QfaoLRCaVvrIrO3X3YtiHjAuNGrrJDw+KGuxcHS5h/nSEOEuPs3pCuSh2Tg2
	lfNgP0HjRt5MMRtirnrVNJ1Ud8WA/1dz7boqB/+Ux0it9lxBBblq6HJYR1q3BdzSBeMWSBsEBYR
	MhzuEf8JLE0m9ydMze4yS85Qt+DOZUMXFXeJ10S/osgYcoOkYairE8RRutEHTlgn9q1oVqIDBul
	2nNXfXqIl7Chb+fpYd8/Jqx4VrwryS5lT7yNjvCgkkOXxVpEdKQwsL/rpl2eCeI8VqhP4mYQY5g
	9tJdA==
X-Received: by 2002:a05:600c:b99:b0:4a1:d36f:1ba0 with SMTP id 5b1f17b1804b1-4a1d76227b4mr249591145e9.35.1792529512348;
        Tue, 20 Oct 2026 13:51:52 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2d569d4sm102810755e9.10.2026.10.20.13.51.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 13:51:51 -0700 (PDT)
Message-ID: <2d1f9c05-4837-4c62-ba27-4275d2cc5d0c@gmail.com>
Date: Tue, 20 Oct 2026 23:51:49 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH rtw-next v2 2/3] wifi: rtw88: 8723b: Read the package type
 from efuse
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
Content-Language: en-US
In-Reply-To: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Some chip package types need different parts of the RF initialisation
table, so read the package type from efuse.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
v2:
 - Get the byte from the efuse physical map stored in RAM instead of
   reading it again from the chip.
 - Use macros for the address and the mask.
 - Read only the package type. The chip variant is now in patch 3.
---
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 29 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h | 11 +++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index 0179f09140ef..f550c8708e01 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -2349,6 +2349,33 @@ static void rtw8723b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
 	fill_txdesc_checksum_common(txdesc, 16);
 }
 
+static void rtw8723b_read_package_type(struct rtw_dev *rtwdev, u8 *phy_map)
+{
+	struct rtw_hal *hal = &rtwdev->hal;
+	u8 val_1fb, package;
+
+	val_1fb = phy_map[RTW8723B_EFUSE_PACKAGE_TYPE];
+	package = u8_get_bits(val_1fb, RTW8723B_PACKAGE_TYPE_MASK);
+
+	switch (package) {
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
+}
+
 static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -2374,6 +2401,8 @@ static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 	efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
 			   BIT(RTW_CHANNEL_WIDTH_40);
 
+	rtw8723b_read_package_type(rtwdev, phy_map);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.h b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
index cf93b93ede81..f1eaf7ab2a81 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
@@ -9,6 +9,17 @@
 
 #include "rtw8723x.h"
 
+enum rtw8723b_package_type {
+	RTW8723B_PACKAGE_DEFAULT,
+	RTW8723B_PACKAGE_QFN68,
+	RTW8723B_PACKAGE_TFBGA90,
+	RTW8723B_PACKAGE_TFBGA80,
+	RTW8723B_PACKAGE_TFBGA79,
+};
+
+#define RTW8723B_EFUSE_PACKAGE_TYPE	0x1fb
+#define RTW8723B_PACKAGE_TYPE_MASK	GENMASK(2, 0)
+
 extern const struct rtw_chip_info rtw8723b_hw_spec;
 
 #endif
-- 
2.55.0

