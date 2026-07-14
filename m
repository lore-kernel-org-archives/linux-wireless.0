Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150E8364038
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024783; cv=none; b=CY0Kh/6Uyzzox2rVDxrgI4wxotg/UgNDpdC3FU4Kclr4af1HJ3FAy2Ouo2X3X6vslhmPK2qvY/30+jDTyzgbBo4Rlgx4vKdVea9lyykBybVN1lwc1GL1J/k5dol3JqeSRgbmUoCG/1a1KG1/BIOLQZdrh6NSqv4cY+sJWM/0FHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024783; c=relaxed/simple;
	bh=5fpYPNzV0/Z3hccAscI1EqewClqicd+AFzLg3sJNMbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfTFSQu8D7ZpRuP39qSaH3rnQ77ZY7gkY/IftUctJuHQrtlSzX18s3cpiqBsiqiS+K3xuZKN1x58uWDCMDLXLu2oBWsJugGXvdZSQEYWwyZ7ARJx9SDTWSrqSjqCBza1lC+seeizS6jdD/cUyxExPO4XRPmKWSDrYOFj/ea4aWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qtmJUTap; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qtmJUTap"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-475881b9a4bso687016f8f.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 03:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784024780; x=1784629580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sHT/WwMTvMyhNG0R1GTeh0JBDqIUGamHWFNRSDi1Fw4=;
        b=qtmJUTapqC6JLmBjTUuPWeWdadgXrAY+CLATpkhmoX24QYNtAr1AD1C3Mb0sfGdeyg
         Y7MUuEmIa3WNkHyQh87HyyR14+P7pO6yW0XlGHcD6DzL1hgrciAN6D4dQJ+SIO+VSK0U
         8gTtbNYm7NAzbZ9TfAiwompgxXUcMZq+J31g/LI8p4T1yPIltD9Qssmy+aHiwcXkNv+y
         4qj3ltaKqhvHlEFrR51zjsyz3ZSbD1jTXqEHjMbrTOdD2lIVxWcYvMGoYRWmtuIutRlq
         RuSoNA6ry/6WV974lv/nICnveODZGilSZeSjo0CGrjgel3DtsG1LRA/Inx+0L7AVLIAK
         tu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784024780; x=1784629580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sHT/WwMTvMyhNG0R1GTeh0JBDqIUGamHWFNRSDi1Fw4=;
        b=U2vXkajE7KXn4bomPK2nCEXJC975f4BHCPjGZzj0vzpnn66cTteKrN9mjzQr7pIwvg
         ZenWxCmJlpnVGYkd+NJJtsOls174/klxAdkEZgSDpBimD0eoir8wpkw2m971O/U7jqqU
         vWiG1hxDQMpMyl6l1QHJf5+U50VhRLfY7vLZizGMM4D4ch4lnvBeeAbszwU9B/sJwirY
         EoS8BR5surzij5N4tszHPILr28K2xWmTZYnNEGdM2UcuIK99UVYxcmEa6O8TYE/iRr4R
         FQZzX5Ni6PvxK3UzdMAj/6ec8SGgTLuOjAOjaL5QYyhUFok+MgBOXYiazmwYAbMeEtiw
         +cQQ==
X-Forwarded-Encrypted: i=1; AHgh+RosRUewS4aPiF4yfRXx33YsQP5REgM7zrH/hJE1+2yLCo4Rh0TPUp3z7HxjxXudgx3ixhQEt+jn7c4v2D3GzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnf32XFX7xFerv27VLofg62u7z5uGffAv8nAfmaqXqZvnlLedQ
	fp9aj72rRxfIO9zY9JjFzXrpd3x9tg5tPUNZB0Lflj416rhja6Kz2Zi4
X-Gm-Gg: AfdE7ck/F/Mm6ZljtzIdVOEQkyTj2ebEQcQaVeGhN5o7yVPArET5yass/a2Y5VF6m+X
	f9/qUs826tyxYZCWf5NCC7W+soT4tnYedTgSRWJVO5yzLv7h7mIsXrDBw0PS2gwmqo0ySi24I3F
	3eeO4WRjWsNqlJaWZ/TkELEleNAh3ayN2DHWFpXaDQpGVgGInCWxmhO8cWb06C2D5fCyjYKGpY6
	3vu6/UCECBfoYx4eTBxPAMn76S2gtweLnS9Mqv6xz9Z9OQpdFKk+H/Cjz3cu4o1+4nBVEOPRT7P
	ddQ51NJU+T1sUDinSyb83nwNoWh6THXEwXtJjD9JhuX79TB/1j3wQnDJLJRQ6DnnVxHazFuyD6k
	gTHU3eYUEW9d2fRBAYDLNr7v7XG6n82hh4zjZiMkw+CahrR4v10eo0yfz80J3NFJWZS3o5IU6Bk
	NvJjZuVAXu0FLpERU+/ICQh4VR9yvXpSA4xAh2SRAKk1Ow3KJwKBrUCdTGzgWn8Xaf/Zy4uTLV2
	e/9d9A=
X-Received: by 2002:a05:6000:26c9:b0:475:f100:35f3 with SMTP id ffacd0b85a97d-47f2dd2ef0dmr14426836f8f.48.1784024780086;
        Tue, 14 Jul 2026 03:26:20 -0700 (PDT)
Received: from localhost.localdomain (ip-89-176-136-191.bb.vodafone.cz. [89.176.136.191])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464c1f84sm7251991f8f.29.2026.07.14.03.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:26:19 -0700 (PDT)
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
Subject: [PATCH wireless-next v2 1/2] wifi: mt76: share the throughput LED trigger across bands
Date: Tue, 14 Jul 2026 12:26:14 +0200
Message-ID: <20260714102615.2943-2-petr.wozniak@gmail.com>
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

ieee80211_create_tpt_led_trigger() creates one trigger per ieee80211_hw
and returns NULL with a WARN_ON() if called again for the same hw.

Under the single-wiphy MLO model each band registers its own LED classdev
for the same hw, and the bands can be initialised in any order. Create the
trigger on the first mt76_led_init() call, stash it on the primary phy's
classdev and let the other bands reuse it. This avoids the WARN_ON() splat
and gives every band the same throughput trigger regardless of init order.

Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 13c4e8abe..0c6641050 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -228,11 +228,19 @@ static int mt76_led_init(struct mt76_phy *phy)
 		 wiphy_name(hw->wiphy));
 
 	phy->leds.cdev.name = phy->leds.name;
-	phy->leds.cdev.default_trigger =
-		ieee80211_create_tpt_led_trigger(hw,
-					IEEE80211_TPT_LEDTRIG_FL_RADIO,
-					mt76_tpt_blink,
-					ARRAY_SIZE(mt76_tpt_blink));
+	/* The throughput trigger is created once per ieee80211_hw. Under
+	 * single-wiphy MLO every band registers its own LED classdev for the
+	 * same hw and the bands can come up in any order, so create the trigger
+	 * on the first call, stash it on the primary phy and let other bands
+	 * reuse it; calling it again would trip a WARN_ON().
+	 */
+	if (!dev->phy.leds.cdev.default_trigger)
+		dev->phy.leds.cdev.default_trigger =
+			ieee80211_create_tpt_led_trigger(hw,
+				IEEE80211_TPT_LEDTRIG_FL_RADIO,
+				mt76_tpt_blink,
+				ARRAY_SIZE(mt76_tpt_blink));
+	phy->leds.cdev.default_trigger = dev->phy.leds.cdev.default_trigger;
 
 	dev_info(dev->dev,
 		"registering led '%s'\n", phy->leds.name);
-- 
2.51.0

