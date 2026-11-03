Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712935;
	b=aSFvTnA9sMmixmN1QkZ64ABs9UDOjNPM767RsrMYcMjVCnrnVQfmUEn9Z7t4pbf2a7U+
	 qgACANtdb3yrd3DQiy+BrFVAnGB/LL3run2krChxvngaKMCinBn1i4UwBOK0BAPFc5ufO
	 /WiH/spHt4IeXvomYhX4CA358BZaN+lP4WP3pbiaP8bOoqD9c7kc/TsDR/iZ9QYe2DwMR
	 JEMZzgMvzyNN4LqYGq6FyNLase5MFERpCoD8eZhnNcjFCYfRVrpWgQqM/tyxRJtFy1oPu
	 tD4evl44pTeyVdlTVtBkEVnP2hbTwLY+z/D77974cjfI2H4cCLmxu41XUUZdKiE0XfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712935;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Sz0PIKYs8NuCQn6JiJ89kLrieWO1D2BZeF63W11fao=;
	b=SrY8wZXfgc0Rk9yj4YfDF+4qRuXOU0bJ49vP5H2vraHYtIJVn+bcp50e4ALymmp0+/K6
	 QTk9fS/TbG5+I8V3rhQfMUJykR2ljZZpdHL4Cz9s1VO5rwHHp4Oka2FumRzDcfrgdRrN+
	 0tPgaYOJjoFz+B4OI3sW72F2RLCsnLeDpn4kIdCl4FIarD/NfvKosbDiCdeZHVZ4Kgpvc
	 7T9+il78rWYR19xbZuw/Nq9vttjKoJHEEyiuwOsWojt657KHIPdwSfBuAGsmaApC9hUdH
	 zGe3mF4XxoOZZhWyBFtcwkx5nVPI61QwYepoe03kX+Z8TrKGxOXfumsgWbIJEM7PzRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="mEj/3hLt";
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D8606D839
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 13:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 619D8606D839
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mEj/3hLt
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e0d885929so3356830f8f.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 05:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793712933; x=1794317733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Sz0PIKYs8NuCQn6JiJ89kLrieWO1D2BZeF63W11fao=;
        b=mEj/3hLtb96VY2ULZNiLzvdDfRuQcCryEtrxZD+1CRDHfCb1rKUnjdMvrrDlw4RWMp
         QUoQvv2Gcpe/yZRzRZIMSdmG65eOP9H6ljFehJBKWeqT8SIx2LLVctzXZj5sB914WOZb
         7ZZrLU6/J2DYF+//X/b2AWjMB7mUSrTI4XXCLOd1x8WHzPf4Dgkr9AmVH1qNUrw2T8Jv
         KfGW1VLxgc4ydCq5XsQCwIwrSrGPFdlcHNNlrssSKmOrqgUo0A5HdnClxke+XnfseNMy
         g5sMy50wZoi68eMq0Bp8vTF0I+LSrMcumRcuSTVTSplUbkQ8mnoUuRTy8vAz7R2XL8Q6
         5riQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793712933; x=1794317733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9Sz0PIKYs8NuCQn6JiJ89kLrieWO1D2BZeF63W11fao=;
        b=mGvZ8DCyCnHi1/LQ+8JiFPEtyY8iSuzwypqhxa0BNbdXbAQdeTsJ+g8IBBJGHEB3JL
         KGC+cuf3vU3F5ItDYI1011QYXKKwbbwqwFlxMPxlet9o0ZOhti43Mg+W/yzVJq7W/xQN
         ibH0KuD5pkUHUOmamjlO+EIlM4qyvp9XRP6YMeB6DwUTrCWxRa4gyQEIWOHNXsdz/FsR
         Rnk2abh6FwFGDSDyYGWtluWMAEJqLJhyi6wZktd0R0BPQAAhN4Nwqy7W3tJ6Hm5N5mUB
         TFPMLmGocwaPX7z/i8ALtsKmrLph8DPIy0Z2G2lplfARj1szp+AQV4X6u9bUM4t+KtUT
         cjWA==
X-Forwarded-Encrypted: i=1; AKwUvBxg3YNU4dopWy3UJJXx/WCygY3nxPvlYA/o7auGm/PUAY0DXxUpcl0FlmDCWdl/eGhxQ12qtufqiCRAGqfzoQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8kTtdaXHsZIMiXPnLt6DCaDow7w81PgiaScymUWnEKvY3FdSFy
	0bcbkVbqfGDH4oX5CTGTz7ryzEAuUS4wyiZsxznkVZG0RPF08tPjM8gL
X-Gm-Gg: AYBFou3Ua+1KsXJv+HirGjNSDJKI7LAN5cq9ISFeJX/ROYrmfwOMwvMkeDd+UKvlAYa
	Pidsci9NXAtmXtT1GzugJXfB3gk+nsg+Hva3Dw1JQ+NsvYOwy050DPFUctxCz8cEzsmDdJzTe7l
	XhU+sOb5bvknCchvSHP+KEdvXgqTCRYmxT3IYdy/gyaD2DVRy4IR8xl1kYsWc1XCa5chGafe9/o
	8RYA8BO11AtzzM45zjjh7McLXemJh4zzn2VcBttVGSHQCf7lEztd7qyl+uB+u9IN8Ysx2LNIaId
	qUg/liPOVlAXKxhEUfhApyCCJlTj0X0R1tvh+avsBxfvcPuMM4Ve/zNdtnfESRwMG5xI7jHUocq
	qX8SKgR77FHrmcSabaJgtpDnqXtO3QwLjQcOdApPpe96YaUwjRQFPKJ4Uux89x5RG08yXpcN5Zq
	uTAz9DQCjZSJJcUvrFT8LMnmb+v+xZbHHxF6v95rTU0U61dSafNZUccrl9K8u5S52iF7azKFqjY
	RYz/gswkJ4asLgzXMPo2TLht2ewIcQU4NcGM5JjI9iWiWv616tFxocdFu6YAEN7A3Q1RqUIwQlU
	tBDG8rHdCBVCrZkkuH5XAn0+m1K/SidXdXS1ZyNvnwd+IuraJQT0ZqpIqtgR9ClYEIAfb6EEs8c
	XP8YP2IEGlwEuZSB/u9oPIiKvEDsJor/FOxyHsbRICxexPViAIlJs7o9eG+VS2Di/5VSW55d8n7
	e3BJDSOpT32rlEuwX81ChU/5eEKMOHMbl0Sn/7c/ubDt5dLa/enjI7sVryFy6JdZCCEkx3SDLf5
	2I1
X-Received: by 2002:a05:6000:26c8:b0:48d:f014:63ee with SMTP id ffacd0b85a97d-48e6e3040a3mr28458056f8f.20.1793712932549;
        Tue, 03 Nov 2026 05:35:32 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-d09e-6586-7547-87ae.ipv6.o2.cz. [2a00:1028:8388:a84e:d09e:6586:7547:87ae])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b80eb1sm26661746f8f.34.2026.11.03.05.35.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Nov 2026 05:35:31 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Allan Wang <allan.wang@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 1/2] wifi: mt76: allow LEDs with only brightness_set_blocking
Date: Tue,  3 Nov 2026 14:35:27 +0100
Message-ID: <20261103133528.53197-2-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103133528.53197-1-pepe.schlehofer@gmail.com>
References: <20261103133528.53197-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_led_init() and mt76_led_cleanup() skip the LED unless the driver
sets brightness_set or blink_set. A USB driver that switches its LED
through register writes has to sleep and can only provide
brightness_set_blocking. Accept that callback as well.

Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index c9762082f473..e3eea578a97c 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -193,13 +193,21 @@ static const struct cfg80211_sar_capa mt76_sar_capa = {
 	.freq_ranges = &mt76_sar_freq_ranges[0],
 };
 
+static bool mt76_led_has_ops(struct mt76_phy *phy)
+{
+	struct led_classdev *cdev = &phy->leds.cdev;
+
+	return cdev->brightness_set || cdev->brightness_set_blocking ||
+	       cdev->blink_set;
+}
+
 static int mt76_led_init(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
 	struct ieee80211_hw *hw = phy->hw;
 	struct device_node *np = dev->dev->of_node;
 
-	if (!phy->leds.cdev.brightness_set && !phy->leds.cdev.blink_set)
+	if (!mt76_led_has_ops(phy))
 		return 0;
 
 	np = of_get_child_by_name(np, "led");
@@ -242,7 +250,7 @@ static int mt76_led_init(struct mt76_phy *phy)
 
 static void mt76_led_cleanup(struct mt76_phy *phy)
 {
-	if (!phy->leds.cdev.brightness_set && !phy->leds.cdev.blink_set)
+	if (!mt76_led_has_ops(phy))
 		return;
 
 	led_classdev_unregister(&phy->leds.cdev);
-- 
2.54.0 (Apple Git-157)

