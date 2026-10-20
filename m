Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529608;
	b=wDL7ptXT9Mdop3/zv1T9WrWziCLZwp2PRctQGcmrdHBo/7wMCtzRcu4HL5V5vOnIjOPU
	 p0isxBBtIIPcTbebqE5jYRtnuGMwv+Xoi1TKFKiDegED4eZno4CB3u2hLH/Y8yMovnzs+
	 E7WebUnBsyGNunTSEbgO2y65dt1DX+d+KAsUXYaAwMai8rq9fIaqH0m5YOSK7i1THBFsK
	 nvS535Tcs6Vrnrjgp4/oDFhyvHH6yLU7i9Lb7zdnO4/avKSxfePR4j7glz4+khCiRi15t
	 3aWoDLJosN+UAFG0dQ3sBuKjwq7Gdx5ht5qBgiKAtCThZHFLYt8UC4t30ZAYp9F1TBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529608;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UYu5MQ22t8KLTQoGmhsjqjoWnGoxfcWXN7qGOx+4Diw=;
	b=IK1cpU3Ui46NdcXgMALuQ81w3BsWtsBoXq0hzKtGXeGnRlxHieFTJfSjjWeOgO1FVxpD
	 plkgKg87LJEKUUB6niRtGnRz4uEo1f5o1N1qXvvrGGDrZq7pZx0yzkHnESUrjIr1YAtj9
	 JVRS3bZ3JDjLsfY4g7lXnwVf6klWbaBMmPRePz6AAe8/vPtTwWPgCKH0lyxuFSGhv2NsD
	 3/ML4eTFmorEA8z0WMKOwB3Yo4PKM3q4YYpPaLUqWBowlmCUwinvaGQs7tS91fy4f0JG1
	 FCQrNSkJy6PAf7swo9mPbdnC5i6RRaz3GbJZS/D/F/zBP3xSLIVuTj1PC3lYnGprXTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=c3VCq8zk;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31243606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31243606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=c3VCq8zk
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e0d1da913so45018f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529606; x=1793134406; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UYu5MQ22t8KLTQoGmhsjqjoWnGoxfcWXN7qGOx+4Diw=;
        b=c3VCq8zkLrFphBo33kH1xxq75z7bC7T0/lLOHr3ub4UtdtMjIMDfAmC2PqoYAc3btv
         v1EvCqMkByZbaz/dGUBXuhARvDfZWdRyhuCDyRoNGBydgbf1UD/hX7ldkV1R5r9r0uka
         LXZEpP5t8bDPG/rNhz8nMEpFjV1Iep76TIFpaSHDEtqwYHjatRjlOctb8Udm8DfETVRC
         okbnreQStmEPVlSOEQw4IHlFTsjg51PuKyZTkWEycNEOEzUZYXEzwMh3O6lNdnedd2X1
         IBJrPabcOVTSMGMsFAdWInvKpC/6xAFFlYToi7QKH8eYGLBQCq1cJfTFVqxK3525HJlf
         QQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529606; x=1793134406;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UYu5MQ22t8KLTQoGmhsjqjoWnGoxfcWXN7qGOx+4Diw=;
        b=NWS9nwPLiRRa260H+Hr/DsPfS+TVz9rNo26O2mUiu/il74hfUSDA/+yeB4pgn2Qrgf
         f7Aw83GOTe6lUwoIKkrgCzxziULOK2VtxkY4yK3flybrV1j7FqjiyXXw0v+3fzcVqb6d
         g1ZqGw4c+JzN7QGbBusl5aqhk9dhYeefbfTsZAI9KIKmvsdVIoMoBjytlYZaWr6VwXc5
         FYmqRcztxnhohGEKwlweac2FUK8MO9UW17nHsYyqiqNUzcz6KMJ6q/y4ucEQ4NcgDRin
         FmMPlbhH3lWXU3w5o8RrSg9yEIoddJcTAAZk8oqva3Ivo59CQg3/2BqimKjfLK6wbqQL
         clqw==
X-Gm-Message-State: AFq9FYIgFLiNhcRvlvL550gtFjvcg3x26XEwTXDsji8iGr1/gAY/pm7+
	N5IAcjG1hdRlECds1EBCf3IW2oVfCGJGgafmm3gqPJkQFGGjXQJSrWlBaB0ybg==
X-Gm-Gg: AYBFou0ODMRPdMEUJ863YFb7Ep/LI40IiXw97VPh/nQi+xxWSrvo+IHptFjs+BOGilP
	Jqz8EYuqtbgqMJ2X9jLclpmKk3DKtLMZpod4516Yqq5ZnaliWSJK5v+vY8E9TJlxsJTLazZtrDJ
	1uCl4xBK8MOqO1vdxDtWxeryahlZoEfM/2dRXYVtv+xrqADZYF19s9t5DcmNcWdDb1Lk+9rw2Bs
	ai2x9kfMRetRTKdjmSPVveCRqIQgfYyGIYZ4nCEEhavGaTArLiGIQVuCSeyTs2GIywHCUctN2g/
	lTzqxeseGV5BXqvabpeev55a4TdKBmT3TYH2vTSpsu7i5FVbXOfmz1JDxxYWN2+tN+yh32j93Jo
	BiUi1kG5ormSgcPA4kmVqnoZTcO3HQDi2RmO0JuAvsY8ZH9/QhPWbc2sVSLLbLvck1B3UYDWKRr
	EGAR4lBQjOd5YwBdR2/p9GC355EI6uyJUhBDVtDIRqGQW0gxZYZAG/89nBESwVIDDAHdjb7GkKU
	3gDaw==
X-Received: by 2002:a05:6000:41c7:b0:48d:f3ec:e818 with SMTP id ffacd0b85a97d-48e1e7a7aeemr8373693f8f.7.1792529606431;
        Tue, 20 Oct 2026 13:53:26 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2583ffa8sm766283f8f.51.2026.10.20.13.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 13:53:25 -0700 (PDT)
Message-ID: <a551ce83-278b-4844-98c5-95e0ada3596a@gmail.com>
Date: Tue, 20 Oct 2026 23:53:23 +0300
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
Subject: [PATCH rtw-next v2 3/3] wifi: rtw88: 8723b: Read the chip variant
 from efuse
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>, Luka Gejak <luka.gejak@linux.dev>
References: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
Content-Language: en-US
In-Reply-To: <8e47daa4-538d-4e0a-84f9-fd4e91613ff8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The RTL8703AS appears to be a variant of RTL8723BS which doesn't support
40 MHz channel width, so read the chip variant from efuse and disable
support for 40 MHz.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
---
v2:
 - Split into a separate patch.
 - Get the byte from the efuse physical map stored in RAM instead of
   reading it again from the chip.
 - Use macros for the address, mask, and chip variants.
---
 drivers/net/wireless/realtek/rtw88/rtw8723b.c | 13 +++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
index f550c8708e01..48102baf66fc 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
@@ -2376,6 +2376,18 @@ static void rtw8723b_read_package_type(struct rtw_dev *rtwdev, u8 *phy_map)
 	}
 }
 
+static void rtw8723b_read_chip_variant(struct rtw_dev *rtwdev, u8 *phy_map)
+{
+	u8 val_1fb, variant;
+
+	val_1fb = phy_map[RTW8723B_EFUSE_PACKAGE_TYPE];
+	variant = u8_get_bits(val_1fb, RTW8723B_VARIANT_MASK);
+
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO &&
+	    variant == RTW8723B_VARIANT_8703AS)
+		rtwdev->efuse.hw_cap.bw &= ~BIT(RTW_CHANNEL_WIDTH_40);
+}
+
 static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -2402,6 +2414,7 @@ static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map, u8 *phy_map)
 			   BIT(RTW_CHANNEL_WIDTH_40);
 
 	rtw8723b_read_package_type(rtwdev, phy_map);
+	rtw8723b_read_chip_variant(rtwdev, phy_map);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.h b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
index f1eaf7ab2a81..39b92ec5153b 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723b.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.h
@@ -19,6 +19,9 @@ enum rtw8723b_package_type {
 
 #define RTW8723B_EFUSE_PACKAGE_TYPE	0x1fb
 #define RTW8723B_PACKAGE_TYPE_MASK	GENMASK(2, 0)
+#define RTW8723B_VARIANT_MASK		GENMASK(5, 4)
+#define RTW8723B_VARIANT_8723BS		0x3
+#define RTW8723B_VARIANT_8703AS		0x2
 
 extern const struct rtw_chip_info rtw8723b_hw_spec;
 
-- 
2.55.0

