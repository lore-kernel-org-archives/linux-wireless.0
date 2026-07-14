Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2179236F901
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 10:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024784; cv=none; b=n/dT1b6jTxFOwlQMGOc88GqXUnfu5QcxcyNROyhgU5cVJYsNxczopvV5soIDZYde5HqtDY+9irj5EG2I0LNnrwXX6/ynifdZgItbXOSZuggqAy7ifB+vy9gfDC4YrTWJ/Ou7pI20R0A628tAwp7zL+EMvChHA0CiDANQRan3q2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024784; c=relaxed/simple;
	bh=vxeNwNjyxP4NFYQarE28gPQNW4bl4FYY9NhLFEhHPxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8yPPNyvfQ8HyTcmL1XUzY5HAw+3eOyYaZWMytKtPxSXdSOgeRHaDPsUtHQFX+i0s4K/pe0/kyOaoWDmLoBHuPaOeiNPq0rkx+Cmaa/xkupEwdI1cMborcVPuug6cfUyJTAn0KsLZjXwgtzvql0yieGG6eOQj1FJCgp6qj0YWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sFbA3WEF; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sFbA3WEF"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso3943099f8f.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 03:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784024781; x=1784629581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cBDMwG9/ky6ssL+TbdSqxt4N2oK3lmPKFilDE6MIEWE=;
        b=sFbA3WEFSQk/1egjueCVNyvbBB+hEIHirREB4w55CM86LJSC3wiLEiF6gay5ryccT0
         BdjvGt5sZlJZ0twX1M0qdaktdK9qKrsjopMOp3DgLUUEICb0V+PE/oV91Xl9jwP/j4RG
         tR9V5QMh1l8g1cEQQ6lYGt//PUhIijhT7+0dZK15/FHf1hOkf24DS/UWBREtsgWYJfRN
         BL93JE7mb9/WItlM6zvkD64FBWsz5c4DdSOdhuvORZ07vUZlfnC8rVAd6/C+YrDVj42K
         UtV7YW4BTpEDsfxLdFgTlEMsaxJVQBKJ/yOESbFjn6aNp+y93xi0icbs8G5s04npkNOr
         CwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784024781; x=1784629581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cBDMwG9/ky6ssL+TbdSqxt4N2oK3lmPKFilDE6MIEWE=;
        b=KV2vLaxHSzj3Y+cdf4xsfwjsnPN9yhmIfrNUlYt3Er8gRLuhvkB/5MpRHlX/yKFXX1
         pVhUzW+pidJrtj5ygFqD5cxvx6wNn8/Z6WNREg+eYp+BMUI4mggSUpq5PZveJ5Ho6aNj
         GR8UFC2jesYsOCzL5WVb/RlcBiAJexjkKSWLrOrXtfBMPda2liOGPUQO8/UZNyG2N9hy
         LK7QZJ2XGwSaegXH8BawYwY6hETHy3uUu1iyeicP4QXQsaRIbXMFKJi5FL/TFCaTu0kl
         8YWA2tGKhpc28PhcDiq+uan0DI4TICYIE/0jxV32RlLJGT0TNtm4embSCkxDYAz/Igo+
         y3Ag==
X-Forwarded-Encrypted: i=1; AHgh+Rr9DCSUkV/o67t2AVaq2p5s49T8EQhTEEY+sJTp840N+71Qm56a0JgL6YHr53YOjJzMvc+YNTqLYhw3in579g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjkpI5RlRCFPH4yqUSwP3qO9aS+gUSJwe+X6MlZS5+3BjiVZ79
	os8orDmJv2pMCqGIedzmrQFkag1oUE6UZ0auJEAQW9FuFPqu3uo0P3oosOUB1ct4
X-Gm-Gg: AfdE7cmN3SejzxZ9rzMLEcIW+YlAV0ixugI5fw0NAKJXB0ameoY0PrmH5f3cnYhAR0F
	A4BNTbK1kTb00mQ48d9FhF3UfJViZm1dsiQk1ZejRz5sC9C5hp/Zge/044OyriutfcvD+nD3GZh
	eUcbHP/d4zaTBS+/VrLhsjGmnoLNalFSVR7zDk0AC0DvW3c4tG5CEhJ8VcB2Ki8yZlsesCs9o97
	/bpjxntTWGmSqNxNXWvN+nTykEQxSMxBIWsepzci4vE16inw1yUCRBcflCnbhOMDUVoPDMjDrZz
	oZXPrDEc319uNQjrE/uh7K+Ks1kNd274JAPuv+nUSpQSJKd8+yMzYYlzSuyJjlJATP8ORCu37n5
	AhPmiHsZJLWN7cToyc1oLUCigx0Uo60VgPEuFKbjgtRfskEqUrgIIvU4iL42afLZFFc31xNgOIN
	qZrucmBUaNvJFJE2OqQOeizvAkJzhGm2J8Pc9X/DPbW3ht/objZikUsMwXDQm1Nr036iEDXGok8
	LF7Qo4=
X-Received: by 2002:a5d:5d0c:0:b0:473:987f:c0ec with SMTP id ffacd0b85a97d-47f2dce7e1amr13941311f8f.36.1784024781255;
        Tue, 14 Jul 2026 03:26:21 -0700 (PDT)
Received: from localhost.localdomain (ip-89-176-136-191.bb.vodafone.cz. [89.176.136.191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c1f84sm7251991f8f.29.2026.07.14.03.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:26:20 -0700 (PDT)
From: Petr Wozniak <petr.wozniak@gmail.com>
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com
Cc: shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	matthias.bgg@gmail.com,
	rex.lu@mediatek.com,
	linux-mediatek@lists.infradead.org,
	angelogioacchino.delregno@collabora.com,
	linux-arm-kernel@lists.infradead.org,
	Petr Wozniak <petr.wozniak@gmail.com>
Subject: [PATCH wireless-next v2 2/2] wifi: mt76: mt7996: register a LED classdev for every band
Date: Tue, 14 Jul 2026 12:26:15 +0200
Message-ID: <20260714102615.2943-3-petr.wozniak@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260714102615.2943-1-petr.wozniak@gmail.com>
References: <20260714102615.2943-1-petr.wozniak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The per-band LED callbacks (brightness_set/blink_set) were only assigned
to the primary PHY (dev->mphy) in mt7996_init_wiphy(). The 5/6 GHz bands
are brought up later through mt7996_register_phy() ->
mt7996_init_wiphy_band(), which never set those callbacks, so
mt76_led_init() bailed out early for them and only the 2.4 GHz LED was
ever registered.

The hardware path is already per band: mt7996_led_set_config() indexes
MT_LED_EN()/MT_LED_CTRL()/MT_LED_TX_BLINK() by mphy->band_idx, so per-band
hardware TX-blink works as soon as the classdev exists.

Move the callback assignment into mt7996_init_wiphy_band(), which runs for
every band, so a LED classdev is registered for each band.

Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
---
 .../net/wireless/mediatek/mt76/mt7996/init.c   | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index d6f9aa1ab..b77b85654 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -472,6 +472,18 @@ mt7996_init_wiphy_band(struct ieee80211_hw *hw, struct mt7996_phy *phy)
 	mt7996_set_stream_vht_txbf_caps(phy);
 	mt7996_set_stream_he_eht_caps(phy);
 	mt7996_init_txpower(phy);
+
+	/* Register a LED classdev for every band, not just the primary one.
+	 * Under single-wiphy MLO the 5/6 GHz bands are brought up through
+	 * mt7996_register_phy(); without these callbacks mt76_led_init() skips
+	 * them and only the 2.4 GHz LED is exposed. The hardware TX-blink path
+	 * is already indexed by band_idx, so per-band blink works once the
+	 * classdev exists.
+	 */
+	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+		phy->mt76->leds.cdev.brightness_set = mt7996_led_set_brightness;
+		phy->mt76->leds.cdev.blink_set = mt7996_led_set_blink;
+	}
 }
 
 static void
@@ -542,12 +554,6 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	hw->max_tx_fragments = 4;
 	wiphy->txq_memory_limit = 32 << 20; /* 32 MiB */
 
-	/* init led callbacks */
-	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
-		dev->mphy.leds.cdev.brightness_set = mt7996_led_set_brightness;
-		dev->mphy.leds.cdev.blink_set = mt7996_led_set_blink;
-	}
-
 	wiphy->max_scan_ssids = 4;
 	wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 
-- 
2.51.0

