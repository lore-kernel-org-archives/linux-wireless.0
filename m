Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D3C4E80D1
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450252; cv=none; b=U8ioFhfJdmgkbqnOCDfC0uazEs5gqliB5ATP6neN3GLQ0wk+/gSgMtPKP2lstuGF/h4UhDNSi0FaXLasEcXexR90Lzb8HnikmAXSVqAPdDG1zc6UC2ek+Mb7SzPGmRrNHCfzM8HFShAxqBFSG5QEcrz8rLM0L+xkkSgrStXjmwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450252; c=relaxed/simple;
	bh=V6nah0thlCYDVKr67EXMA19FoQoM8eKaKF4GgRzztzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=E1d9Yn49Ivts0wLY6OEguYFUBNwZH0UxnqH9yv93q8VNgRZ5tPGo2Rc36/P8hqsiz7MfuEjGxdlKotu8mzY5TMyFzpagRklp3WYnWHA9R+jSw2Rh6pJ2D5ErYb6vSjnCkjyBMfx5yv/tdvGgtCEZ4yPoegEbKtWDOqL76d7bUKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bs3fQS80; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bs3fQS80"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so2295e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 08:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788450249; x=1789055049; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mry3nYNEPrZxqkxatWuTZFq3w4sR1ZqgrHlSjI3OqFs=;
        b=bs3fQS80VrhImXtKDaFPWd8i82XKcQ0TpcKVII4a3qkpVr0kwAtGBmc44xUef9fFvJ
         v9511dsT2ZeQ8GDIoLPY97iKV1R2vxGsc+XftGI68TwRN/joKHhXI5vYcxmduaN3By1v
         w6o3ykQ1+juLJX1eyPE8lGbUU2R32GmKkgrfqFIePRAswmZ5D5Q4tw+Y+0uZo2jLNE+3
         2p3Erd+ZESl+Q7Hu/VzEvDrhe68Ov9ywpKVl5XV2nv4xi+debjjAPWwjTvonx417KjKF
         6gNxDRexIXgSzgztlDewzhpgCkw0BRKF/PPP7Rsn1tni68VK9mBpBXEaSDwdcZgOPhXP
         5hxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788450249; x=1789055049;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mry3nYNEPrZxqkxatWuTZFq3w4sR1ZqgrHlSjI3OqFs=;
        b=Hbchm7s/RaOEI0YM7xO+G/w0MzU+mktGardhw8zLQfLX2LfXDVHHad8dUs7QXttbDp
         rZhUMDYoavhFPxEzdVnkzKAi7z2z6UE59MHSdfhP4zWh+3XQ8+Z3daY0+w1tQ09BD+68
         hQxv6r8RCybFepBPtNmnFGK8E3NeGxvqca4gyLHSGdLb/HRTgaRXpMQIj8RNIJdHomPY
         1HcwAj3m3rFXg3uPXjBdg6QfrIR24SK+fuQUI3Nn2EzSfuX/OtiFnRY0EBL4qoERQSEe
         ZFLsRqBCOf0AyETI12HxgninJhQMHJ0/eMRLtwEWbzoT9iflym4n7hLLS2yR8to3hO13
         7QZA==
X-Forwarded-Encrypted: i=1; AKwUvByNh+l8FBqDZpdNcFJkhyvts+lVwsCS/RW7/w+fNvKaRNH22fQzthACiSsMwQl7zudepAssEzX6dXBFywx3FA==@vger.kernel.org
X-Gm-Message-State: AFuF++mBdzwTwYYTO1JKxRY75phCUu5Ak42NTGcktCMpqVGLzag44/yx
	nLeu5bTIIzWRG0I3HXTjTqJJt5wWAg3+r/NUgpCxW5Oi2OVoLdcN/V8N
X-Gm-Gg: AYBFou35wbXo+qMsRRvHD8EDzEfoSSGuEOOgv25NB1jSPABNvdlEbEDHIscLPrekjFa
	SO0wIyi7O7tU36DMiD0oKRNVeBcXTc7c5xWoPuHRolLhDXgfW9OlfWK6EAnWtL26tRCQnbz50gA
	3fozIhTcabRKTROoxdV6Cgd7HmwT9zjOXkcTlLRCXW0i9NsE02s8UsFvrhFV2wG00B7nlHlONiQ
	+NC97pThtwKCcD5Cfwjcaf8mU+GkkUGdnt77HkeZa3BafyYIvGTwMyAIxlhCdzBz45zVMVdbBwP
	22tSt6uptVDFgVNftptxor4XHgGDm1PWAUJGHSmd5UBZ8KkReXHfmLRkpQjfDWE8oJ2LnSlXxVh
	zZe0ko6d9m6TXKDWmOpF12aJnBr8CFwS2yJbAdF7GXhFRyCPyaA9ZTWbGkZIHkFOe88EerFs/DN
	rf/1csHLFpCXxCp5n7dFdNecE2VR1M21ZvZRJXwn3P5Ygpfso5Y1FZK3Xr19Q=
X-Received: by 2002:a05:600c:6c4a:b0:49c:edd8:ba35 with SMTP id 5b1f17b1804b1-49cf5baafc7mr14910805e9.6.1788450248541;
        Thu, 03 Sep 2026 08:44:08 -0700 (PDT)
Received: from localhost ([5.83.201.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce47b9817sm121063135e9.1.2026.09.03.08.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:44:07 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: mt76: mt7996: Fix spelling mistake "retriving" -> "retrieving"
Date: Thu,  3 Sep 2026 16:42:04 +0100
Message-ID: <20260903154204.20872-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There are multiple spelling mistakes in dev_warn messages. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/npu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/npu.c b/drivers/net/wireless/mediatek/mt76/mt7996/npu.c
index b8006b8729a1..3fb9f39c2f61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/npu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/npu.c
@@ -283,7 +283,7 @@ static int mt7996_npu_rxd_init(struct mt7996_dev *dev, struct airoha_npu *npu)
 			       &val, GFP_KERNEL);
 	if (err) {
 		dev_warn(dev->mt76.dev,
-			 "failed retriving NPU wlan rx ring0 addr\n");
+			 "failed retrieving NPU wlan rx ring0 addr\n");
 		return err;
 	}
 	writel(val, &dev->mt76.q_rx[MT_RXQ_RRO_BAND0].regs->desc_base);
@@ -292,7 +292,7 @@ static int mt7996_npu_rxd_init(struct mt7996_dev *dev, struct airoha_npu *npu)
 			       &val, GFP_KERNEL);
 	if (err) {
 		dev_warn(dev->mt76.dev,
-			 "failed retriving NPU wlan rx ring2 addr\n");
+			 "failed retrieving NPU wlan rx ring2 addr\n");
 		return err;
 	}
 	writel(val, &dev->mt76.q_rx[MT_RXQ_RRO_BAND2].regs->desc_base);
@@ -302,7 +302,7 @@ static int mt7996_npu_rxd_init(struct mt7996_dev *dev, struct airoha_npu *npu)
 			       &val, GFP_KERNEL);
 	if (err) {
 		dev_warn(dev->mt76.dev,
-			 "failed retriving NPU wlan msdu pg ring addr\n");
+			 "failed retrieving NPU wlan msdu pg ring addr\n");
 		return err;
 	}
 	writel(val, &dev->mt76.q_rx[MT_RXQ_MSDU_PAGE_BAND0].regs->desc_base);
@@ -311,7 +311,7 @@ static int mt7996_npu_rxd_init(struct mt7996_dev *dev, struct airoha_npu *npu)
 			       &val, GFP_KERNEL);
 	if (err) {
 		dev_warn(dev->mt76.dev,
-			 "failed retriving NPU wlan msdu pg ring addr\n");
+			 "failed retrieving NPU wlan msdu pg ring addr\n");
 		return err;
 	}
 	writel(val, &dev->mt76.q_rx[MT_RXQ_MSDU_PAGE_BAND1].regs->desc_base);
@@ -320,7 +320,7 @@ static int mt7996_npu_rxd_init(struct mt7996_dev *dev, struct airoha_npu *npu)
 			       &val, GFP_KERNEL);
 	if (err) {
 		dev_warn(dev->mt76.dev,
-			 "failed retriving NPU wlan msdu pg ring addr\n");
+			 "failed retrieving NPU wlan msdu pg ring addr\n");
 		return err;
 	}
 	writel(val, &dev->mt76.q_rx[MT_RXQ_MSDU_PAGE_BAND2].regs->desc_base);
@@ -330,7 +330,7 @@ static int mt7996_npu_rxd_init(struct mt7996_dev *dev, struct airoha_npu *npu)
 			       &val, GFP_KERNEL);
 	if (err) {
 		dev_warn(dev->mt76.dev,
-			 "failed retriving NPU wlan ind_cmd ring addr\n");
+			 "failed retrieving NPU wlan ind_cmd ring addr\n");
 		return err;
 	}
 	writel(val, &dev->mt76.q_rx[MT_RXQ_RRO_IND].regs->desc_base);
-- 
2.55.0

