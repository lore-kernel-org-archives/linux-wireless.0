Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B0C256D
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2026 00:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782346791; cv=none; b=gxR+LT03qsmmX6OtnWe2oPZQf7tKtq4cX0mGb/ZB6dvVEWtsjgacpJ4wP8EbDeJMKKKg6lr2u1KsNzQHVxs8E15d371tzAp/3gy0xDahF0dvPKqIUivJ9SnyoihseCIrzFBB74adB3qZtlwGamixHtJkJOloecp/Zr7o9Ni70LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782346791; c=relaxed/simple;
	bh=4NJo3aHxbrzxIVRRmgbFHfe/3KuZ52b8M6iXzD83s9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a873qlJLmE9m6LY1e8L241AzzQBAa4pcr9h9gQ8UIa7BM1/Agv5nnYFN5sEO/uT7BjUor0CMQEJgIDvPQLRQoXkcJj7ree2vUY1Ho9EQ0PyItSXsxoqIFvt16xBqPYo9TXupqlCmk+XYa1zAvFVdQ+ZdDcxTSrWXrOuT6x6WQbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7f123b1acso8998405ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2026 17:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782346790; x=1782951590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N+N2piZwur85rXYTWnbWFwNyJfZ/h5tCavLfujPLtAk=;
        b=g+spcAGBKFEvg/sDacKZVb+yHlWtMdsfOmmnr0RAjygXvdTK8ikIPQGAilP5mWvpit
         BFLzHorL/dUi7BgW1kZSbDcPais/k00wQwL4ZlQJ2w2FQO4dpCTq4R/+E5xYxdq7Bbqw
         gQktUdIdAKsBJGCnnjm8nItnQ5qGroK4JXa3Lhe9zIIIrZMShATvWw+HABu6NqhnJe9X
         5bjSjgUyj/3xchd2SIYcjZLXcssc5TsjJ0RM9nqE1OJOTa+plVT9FV/OrEJAIfItkwIv
         2iyid9xER+5uLEsvgrihbIL92y+IjdBVlDfJel3u85NnXxVO7Wm+HUOQF1kElKxuAhcz
         wgPA==
X-Forwarded-Encrypted: i=1; AFNElJ+ofEkWOJhQEfBPYD5/ETqN/zWJe5egtMTjJ4SVr0vaMB3cXTdMvt52WNVx+lWQDwl9FKSNPMr+weKPjoxyFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYZQuYqyo71aN/gGoTWCkPAV2MbjRrkCr63DnWva35gJ4bwIsa
	AQsaKGNObSUDgdSYj68n7RxNbCwL63ZB26bUHcnvYwIREBq8653vpZlT
X-Gm-Gg: AfdE7clM4VZD9ecC1qdEYEzRHa/NOh2cNBL5RDmEdGkWP6q+7rPNe9p8RJ8DJq/VbZR
	XQMG2yJmwJlk25dCfsrfoijjtbQPMkluHuAKcWfnW4KSKZM7CLRx0GhKWbsxVOcR6MMZQvi98i8
	/URhgJTyXbcwnrT4kHOEMIFPaF2DAdjka5UZg2zp7uKRWFje/KSW7G8k7GC9/hkUr2cF98j0+1t
	b21hEWG/XvmIaorOUMuSpBztn2F5hAoRfUs2wL3HUFWCSjNCQe5qQdAKQ9xlGj4q9YYr3NfQmXA
	c1IH4lFDGO99j1dkDYughPrCXZpPicD6S/GnW89Bamufq9KRGhVnFmgBQQ2EqTT/7Mlw+k5eg6T
	ltdvS2stmz3NY43si/QyTvq23tDmLcz4CP42pAQby19O3X+8Fe4D+NrSUwvXR+EzrwyGE2pCqPB
	cpfxxuFyvABbkRZA5wNkydP64V2lcdK/mNpgaOOVI/gjzVwj+hj8pqh/5dcU2DqBG251x+4Xrmh
	rsTiHvu1mUSOTrT0vRRkwZNVwiyBQ==
X-Received: by 2002:a05:6a20:7f8b:b0:3ba:cd5b:3dca with SMTP id adf61e73a8af0-3bd4af562bcmr337449637.37.1782346789653;
        Wed, 24 Jun 2026 17:19:49 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.. (114-34-228-194.hinet-ip.hinet.net. [114.34.228.194])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bc1e0d10sm586839a12.21.2026.06.24.17.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 17:19:49 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: chengwei.yu@mediatek.com,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v2 6/9] wifi: mt76: add init_wiphy callback
Date: Wed, 24 Jun 2026 19:18:31 -0500
Message-ID: <20260625001834.475094-7-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625001834.475094-1-sean.wang@kernel.org>
References: <20260625001834.475094-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

Add an optional callback for drivers to finalize wiphy state after mt76
has initialized the supported bands and before registration.

Co-developed-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Co-developed-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 13c4e8abe281..c4cbf7195b80 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -681,6 +681,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	dev = hw->priv;
 	dev->hw = hw;
 	dev->dev = pdev;
+	dev->init_wiphy = NULL;
 	dev->drv = drv_ops;
 	dev->dma_dev = pdev;
 
@@ -779,6 +780,12 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	mt76_check_sband(&dev->phy, &phy->sband_5g, NL80211_BAND_5GHZ);
 	mt76_check_sband(&dev->phy, &phy->sband_6g, NL80211_BAND_6GHZ);
 
+	if (dev->init_wiphy) {
+		ret = dev->init_wiphy(dev);
+		if (ret)
+			return ret;
+	}
+
 	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
 		ret = mt76_led_init(phy);
 		if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 07955555f84d..0d185675689a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -940,6 +940,9 @@ struct mt76_dev {
 	const struct mt76_bus_ops *bus;
 	const struct mt76_driver_ops *drv;
 	const struct mt76_mcu_ops *mcu_ops;
+
+	/* Optional callback to finalize wiphy state before registration. */
+	int (*init_wiphy)(struct mt76_dev *dev);
 	struct device *dev;
 	struct device *dma_dev;
 
-- 
2.43.0

