Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A233A9612
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 17:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786902531; cv=none; b=a+2zxWtFlrlqe7CeXSILmVzMYfshk0w9BmW8Q+WrjEvA35k7K6sA+J1M3bycdAti+GkQl6qvdIBZZCqT/5edSW9S+iRPU4lec3r39LSVcjFfjXMHxNuJJ8IoLNAxvWe9hr+d1GBsfa7OGse0qmKoseeLNlMwnLdEG1tXuReRn0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786902531; c=relaxed/simple;
	bh=REzPd5tdBRbGao7/2vlngZA2mtzJ+akj5jfwnqD9A4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OISkiG7SlMVeGk16XmJsuCfjgnBZbNHbkiIbljxU4Ic6WGWVcaphzlhGW5HDK5tOMA1pr7uWJoxKCtSRvzQhyal0WIFVroxyJZf+br2jhJSbicrVlrSrPWTcyBchTJ3kuinp233uDCQARSWqyapGy8gY3hOvmnFztwl4QHibPJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELHDaGOt; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELHDaGOt"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ced3386430so27704365ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 10:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786902529; x=1787507329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FflrZPo0SzDXc4fxWnUV1IFsVK9UvRmYYioklHORaLU=;
        b=ELHDaGOtHxfT6++jk/gN3LDuD0N2ou0C55sK3zzwUKSVoZ46xaCzZsKKkw4UmR2DBt
         LR7DSXG8S7s29MHv4R3vJ5lDLu/EnGH0kVfjwKblLMhfKlPu9NtGFUKv8Po/QOqeBZCL
         sB0T5bAlxNkX4we8gMyCwHq152bT6Y/frtO0vRqUwW255XWdIhkwSGtLSq5M3IvnXcOu
         pai93QDy3Z2X/uruIuDwTTkMCEEVLthua+LJcGrIlx68F1SwoifqIWJGBbHRvgjE7jvV
         B6BpdKPt7LIcIYHrxmB1fIr15Bq43fW9yIcKfpo0LSwEs2nXfbSkAw1np8K+WOLidQSX
         xHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786902529; x=1787507329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FflrZPo0SzDXc4fxWnUV1IFsVK9UvRmYYioklHORaLU=;
        b=ZckI0KnEs5rqLJEm+7cgQ9CREg7kt43kGSqsMNAvJ54rqU47OUwoMSqT/xwNRlr1F4
         FIBYXVoCID4Ih81Ciqw2ZZUP378rdBM8ABTa/ZFtgxPkpHSgCb55X5EmkUa1PWcx7jY+
         qXLqkqEX6TmpvHDTSPatDmfetnHVKpHXyG8+WnISjJl3hbEaEhhah37/mI3K8G7Vowga
         t4aL3AErbt8SNdrBAD1AaIA+CRPS1AiqcGT2BFyobdQuZku1Sjs5a7vvX15aQPAdexxS
         fRUH7X97pFa+7jUQAsYAu52300Y8g+PCLGgkeM4Ol92um3Nfdw5XGHT4yfF7Fx3RyV6Q
         Snwg==
X-Forwarded-Encrypted: i=1; AHgh+Rq4+8AKc8cfGegRetKclbkrKrCf3zWhaztwvp4k5ujmob2Kv+EUtoMIwItUmHxC6c5GZ/pcyD48g5aDHwDHlg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8PQuGzROuymrQiE/8IzIinXIFj9i9QjG4/poBlmZ16ms5jpwz
	r2eDlvaTCNNA/UwzuStrrta+MmDTT2VyweGYGdjVanxj2Obr7T27rym7
X-Gm-Gg: AR+sD13g4yCq4Bp1Yz6fTYW54Gutx5YYcl6FiHmY0reYe7UaK+VROL1KeQOj6qLRw3M
	KH9GYFkDPeGdNgaHU8q1G1ZpRyqZcQBj1UyHMQF05mfdPiKNqm86aoZzHXomidxt/mKXoEpgLks
	7m+mNN5HILrd0U9lPK3XJnYYSV/2qjHjvCqCiNcgvOngIZxjorfGR9wTgpdgGmXDpJhE0PY1QLf
	yHYJ03ZMl764SG0XNeNdFFQF0xCBB4uFh0FiQlWC4FlbpAyMpfyTXuOYb6pZowydufLIkD6n7NB
	KxpvQ+F5pTPwk9IOtJYRSO1EEsyP0GLEUOdiPbvIB5mmEyh9cM5K952EfV/UhxppGXkS1Kyknvv
	WpWUbNRo64ke3pm+i7TDkEEan17HTpe6nLufd4NJx9A+kY1FPhcHvG8qnAXsZwuFbqs1M2W3mQJ
	BubROxBTk0GNCdRCigiGMxFCB/pCCTgCFUyiMMfpMDFN3Hu4IWg+oj7OPUHzavizYZuD35Vwhkq
	OR3o0+W1/Zkk/7Ig+hRxhbvWXHJLj3njUeXNtyvH0V5YQlmCbWgiAGO5sSquunaEQfinfJO9L//
	uVkeJMUM/f2ZmPDfLlPJ61deGrAhQqFHiEIVgbg8ihdBcJeBskXHDYmi6QdjpvlIel/5p0Q5/+z
	i47+wqjTKD8G5agp26md8y5v3N2nnENdS4VM3uuYRRhQRU5Fq
X-Received: by 2002:a05:6a21:3384:b0:3c3:64cb:9b99 with SMTP id adf61e73a8af0-3cc719c78e4mr25685428637.6.1786902528936;
        Sun, 16 Aug 2026 10:48:48 -0700 (PDT)
Received: from localhost.localdomain ([101.251.7.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413889bca5sm46408707c88.12.2026.08.16.10.48.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 16 Aug 2026 10:48:48 -0700 (PDT)
From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7921: skip unknown CLC firmware records
Date: Sun, 16 Aug 2026 23:33:40 +0545
Message-ID: <20260816174841.1918-1-acharyalaxman8848@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <CAMyXUJmh=WfwC4_KHupNxYR5e2Gy5QhBDL5TSG6XEW-XLa+X4Q@mail.gmail.com>
References: <CAMyXUJmh=WfwC4_KHupNxYR5e2Gy5QhBDL5TSG6XEW-XLa+X4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Treat an out-of-range CLC index as newer firmware rather than a
malformed image. linux-firmware 20260810 ships MT7922 records with
idx 3, and rejecting them made mt7921e fail to probe.

Keep the record-length checks, and report those as errors so a
truncated table is visible instead of a silent retry loop.

Fixes: 9417c5818a01 ("wifi: mt76: mt7921: validate CLC firmware records")
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index a118a301564c..40546005c743 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -477,18 +477,23 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 
 	for (offset = 0; offset < len; offset += clc_len) {
 		if (len - offset < sizeof(*clc)) {
+			dev_err(mdev->dev, "Invalid CLC record\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
 		clc = (const struct mt7921_clc *)(clc_base + offset);
 		clc_len = le32_to_cpu(clc->len);
-		if (clc_len < sizeof(*clc) || clc_len > len - offset ||
-		    clc->idx >= ARRAY_SIZE(phy->clc)) {
+		if (clc_len < sizeof(*clc) || clc_len > len - offset) {
+			dev_err(mdev->dev, "Invalid CLC record\n");
 			ret = -EINVAL;
 			goto out;
 		}
 
+		/* Newer firmware may add records this driver does not use yet */
+		if (clc->idx >= ARRAY_SIZE(phy->clc))
+			continue;
+
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
 			continue;
-- 
2.51.2

