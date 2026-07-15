Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEC140EBA9
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128884; cv=none; b=ImkUdj+LksNiBWsUCiMRic4aoo7i+5ImQ3SKlIqF219/ehML2YW0tNgjsanY2m6trTn/eOh12RNoDu0A7XO7IJugiL+ZmoDArAHZPGdkddnCkl5rPwsBPUzOw3FLUxg3159usWmi2/rmWdfyuE4yvmGFySOR5Sdy7idYYpIRYZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128884; c=relaxed/simple;
	bh=DA1KbqJhRIQjF6L4QYXqU8y9WV8tqCmFDyEh4aScSFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esPNNKUlZva9TJLQrXGM5DLDqm4cVhh491WlHJks6Cg0bEiBcGf0su+RRjNpvvVggKqLIwn87+0t/npdPodwfsXUyc1SBhaJzfHVbfc2397/70M3TqY3UjTSwbvFKF/JK7c2y8P8HEsSy6KAQjiL13GCL4d7aLVVpH8oZGmphHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GFopdtlM; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GFopdtlM"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848595b338cso6570924b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 08:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784128882; x=1784733682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EFw8XSdJCXuT7tU+Yd9AUWSw14+CKbWtPO+VaqQRC40=;
        b=GFopdtlMFejnymdqMYo3rIU3ospnJPwcHQtW4q2Frk/Ya0ZYDJr6IZXOZyCbogz4AN
         vEzAvioavO+tXo4XskDuLJZS8lSmugKR6ANG3LW9X0BHm0UQ+rkGxbsMr00t1E+sWanO
         E5o6Ske95wWR+K4naxciZRrRhXrSH8FkNJG5uH+qq8ZsdmFsMSIdy4ipLpl3iho8R0jR
         xZI8jh0XsDagmClQSAScENi8zQiiz1bGFd7twHoEzY6iUJEUMNA56ztjKIB7LX1k6u7V
         B/d96d0TN3o1pEeyYM5Ya7ONTjhJtWI+QlbEn3WMBXDixCoh5kHnKl+6FBgDeYrlefg7
         L0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784128882; x=1784733682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EFw8XSdJCXuT7tU+Yd9AUWSw14+CKbWtPO+VaqQRC40=;
        b=SCD+V12//3GEyvmQ9JZMngYy0DhcYn4ZqSqNCOsLYLkWZzmeAFz+1OlptGlaj4n6Rb
         WojuJj1GYK4N323vc0tgFVvPnutQtNSMZ1Ftial4sEToNyYQ0xldAXMVxl/wbKttR4iZ
         GkftOb5cNUzpHVwG/64MYtN3oOShNTXsw2y7w2swmYcFyAwVySL3CvpXJT+M58TOTehT
         snxLuHe0zl49KEE3eKwz2MM891yykJaZH6y8brpBsthMRKe1UAGP1mcyltpwPKV+dZj6
         FxUs7y109qtEIoVjLhE4LoPP2YLX/8Pi+G53OQXRARIxBRqmaMPds1Y0UMs+oAZB1FBa
         qCjg==
X-Forwarded-Encrypted: i=1; AHgh+RoZUUk72oh17z9LGtM8zQ9Wa91xlKrxzN4MxxftLmcu07HbKDqkVNjevhgGQrRuhHvxUnqaBAbIhwZCiUmKZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHtRK88Mq16zfWivHIWfjitI+qSEp/wJ6Lmc1yQObkMu7lMTpb
	82nt2/NyDSJO3BQYz8uEFCevzKyM1jpy1BdhDV6GbmS/0XRIcIN8dtDU
X-Gm-Gg: AfdE7cnV7wmNDMUJWbMYhNhI3dWLri646r5AdovZ6xpDq9HcKXWqUR3QmfC4WQxNWkD
	drtezvxb4hWRl9UCWackxeia2Aswa3O3xAOuB0Vlb/dcH0y5qr6ji3v0ucpRe8QDTxrTZjKKa02
	my0uBhSHuH3B2udw8H5GjxQsI/qyt8P8LZB0Xy7rvTA3zdInggKDu/GOKckIbOKWQU2ck8uPF3X
	rw4kelbqw3BbJJhEsOn3C6M33kviYCt6zpKFEGNdjvXrX8hQ5cjKqNWotEZzS23VlHXQ9Ocr2aS
	Ymes+1EnoqmBu8IExP4/O2JspD7CuNEr8pk0kq3orIJw9siEgXAJZ6h/9szyQXUTSYfjmlmm5A1
	P+R+BVRLITIssb9nsajS6mjLn3dS/g1vLqCHaLlA9LTqIup+XnXuLM/kGbw8G5y9C1HlPSZWiRt
	h9crRkj/+SLlXkaKvkWaJJY8MhEnOO4097TfO/fd3WbFpBOWLmRzIo7JD9LOm+8alI
X-Received: by 2002:a05:6a00:9467:b0:845:e3e4:9702 with SMTP id d2e1a72fcca58-84a55820631mr5597742b3a.47.1784128882203;
        Wed, 15 Jul 2026 08:21:22 -0700 (PDT)
Received: from DESKTOP-VNSSJ2S.lan (59-127-145-64.hinet-ip.hinet.net. [59.127.145.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a5c699440sm2268842b3a.34.2026.07.15.08.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 08:21:21 -0700 (PDT)
From: Zhi-Jun You <hujy652@gmail.com>
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com
Cc: shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Zhi-Jun You <hujy652@gmail.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>
Subject: [PATCH mt76 v2 2/2] wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986
Date: Wed, 15 Jul 2026 23:21:13 +0800
Message-ID: <20260715152113.553-2-hujy652@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715152113.553-1-hujy652@gmail.com>
References: <20260715152113.553-1-hujy652@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current implementation assumes that the hardware supports DBDC or single
band and binds to band0.

This causes net_fill_forward_path to select the wrong queue for non-DBDC
mt7986 because it binds to band1 and getting the following in dmesg:

ieee80211 phy2: WA: --> drop by reaseon:1, msdu id = 0xc002 but failed!
mtk_wed1: error status=00000002
ieee80211 phy2: WA: txblk
10324e00
len = 128
DW0 : 10 00 00 00
DW1 : 00 00 00 00
DW2 : 00 00 00 00
DW3 : 72 0f 94 68
DW4 : 00 00 00 00
DW5 : ff 03 00 00
DW6 : 00 00 3c 40
DW7 : 00 17 dd 14
DW8 : 79 6f 00 00
DW9 : 02 c0 00 00
DW10 : 58 c5 34 10
DW11 : 00 00 00 00
DW12 : 00 06 3e 00
DW13 : 00 00 00 80
DW14 : 10 8c 00 00
DW15 : 00 00 00 00
DW16 : 00 00 00 00
DW17 : 00 00 00 00
DW18 : 00 00 00 00
DW19 : 00 00 00 00
DW20 : 00 00 00 00
DW21 : 00 00 00 00
DW22 : 00 00 00 00
DW23 : 00 00 00 00
DW24 : 00 00 00 00
DW25 : 00 00 00 00
DW26 : 00 00 00 00
DW27 : 00 00 00 00
DW28 : 00 00 00 00
DW29 : 00 00 00 00
DW30 : 00 00 00 00
DW31 : 00 00 00 00

Fix it by using phy->mt76->band_idx for queue which works for both
non-DBDC and DBDC devices.

Fixes: f68d67623dec ("mt76: mt7915: add Wireless Ethernet Dispatch support")
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
---
Changes in v2
- Use band_idx for all cases.
- Link to v1: https://lore.kernel.org/linux-wireless/20260630150649.1629-2-hujy652@gmail.com
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 51643a48ed15..044b592efe28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1743,7 +1743,7 @@ mt7915_net_fill_forward_path(struct ieee80211_hw *hw,
 	path->mtk_wdma.wdma_idx = wed->wdma_idx;
 	path->mtk_wdma.bss = mvif->mt76.idx;
 	path->mtk_wdma.wcid = is_mt7915(&dev->mt76) ? msta->wcid.idx : 0x3ff;
-	path->mtk_wdma.queue = phy != &dev->phy;
+	path->mtk_wdma.queue = phy->mt76->band_idx;
 
 	ctx->dev = NULL;
 
-- 
2.47.3

