Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36888390990
	for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781391125; cv=none; b=WQNVxGzmFyD2KTzz6IxTYkdmlY3fIHqQb1b0WkS97XevLxoczX3P3M6u2ISIR7/tF6MJFLh+6afEWONy4D6Aka7PaokuW2KDspJOSgZHc3VCCFYW6Suh3v1G4rYINI5sU2risrfKVwEw536uhbLhuGJeHa8GMemLntYbnl2aGNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781391125; c=relaxed/simple;
	bh=AHxuyJ8gB93n0AqBcKA4xLoJu03MturvJweddqOqZ24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGX/DVX81NydL3iaZgtCjGG014YNZJvVCU4B2TxDpEvxitb922jM8O0qWWeh7bIIzJeyYy3tNRLB4h7v8bCEnlpm0QVjI6Ge4SfwJmttDofOVEPoG0l8aRiEujO9yG4//RaeA6CfbU2IZH4LWhICd6t6mpqwrG2ckbU+a+RkZ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36b95eb4bb4so1329920a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jun 2026 15:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781391122; x=1781995922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EoGi64+Gj9TgVIoAAJDW1KkqWIWQ9MNir22gN9jKS9w=;
        b=rnX+u+x/A1YYZubF6oda5yLFkA65nemW0bgvsC/BwWqPvZTfiL98Az7PpN+bihNynx
         OQhfBZVo7d6RIcr7WI9an0qvDZqWL/NysDSAcH1nZQ8BvS+5AYmMHaSbjljW08uiuLGQ
         5ZwSGGi7RteUra2bTSEUcIEhdvAMN7ZZ1pbRumSRseyqL5eRHlxDezhTtXHZR0khLNfH
         1f46GqdSk8q7gOrHE9l2m/evAkoA02pC15h31JOQEqQ3J+ucmtQtghAowy0ONWMxP3c8
         NJUFp8jUbuk3cYGh/4HRKdYdMJnrOz6h3yi8do8m1ENks09SJjftp/Y/pF9kSI2hIze9
         H5zQ==
X-Gm-Message-State: AOJu0YyfHFRkUErePJSPdS1T24IAu4Eba0mEC4XNvUU9Fb9JvrPIfRPG
	cSGloXK/b8ozaEZiIS9ct9l8y1jA0xrp7XGUPEirhVmrq/5vcKoJeRIR
X-Gm-Gg: Acq92OGG9tGJb92XEhD5F4/9ERLQy3rcH9L5FbdwjRtgOBqte3MoZCT60WfwkvdUCvo
	GjmULCOsjXvv0HklsxWwoEBGedXDVQk0UFsVtT7ieGFcGOgN8p1FXWXRS0UoTgZtvK+X08NqKdE
	5qc+wJ3rgdVPHI0xHQ0T9yUXBTC0S8PYTuzThyS5e4pGauKkRgBIcscTvOQIi11WaDzGumTcrPw
	YuQPC1FcnFrgpxlFEOamW5pNpvbAOT+8HLzVJmnSlSee6AvsR8ibvH/7OCdfq0GOuL6BmRk1YOt
	t71bpqcYEu2rhhH9HeNBbnpbhwIuYMl8FQgAEoGEE3k80cMOzstuHt+TnE86t6GiBAnaG2yRcFX
	2/CpQscsZu/lTtIroDmCddTOgoMOGCF41jlpSVr108zopZFofWjTT3CUsgf5WwOtgOfx4I1SU0a
	Z2wE0qKwTYbr975GGGtaI/gFf+c9TN3F9/kqv4SdB6W4AI4TRqWkqIw4vlo+JlEgx20Fop9vpdB
	5DPWKOrG1iYjnp0bQ3U3vD4X5BDQDv+xNEYNhYYlJMIsu8jFzE=
X-Received: by 2002:a17:90b:48cd:b0:369:7421:b376 with SMTP id 98e67ed59e1d1-37a03ad61c1mr8783542a91.19.1781391122554;
        Sat, 13 Jun 2026 15:52:02 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.. (114-34-228-194.hinet-ip.hinet.net. [114.34.228.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-379c333c43asm4215770a91.0.2026.06.13.15.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:52:00 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 2/2] wifi: mt76: mt7927: use real monitor vifs for dual-band monitors
Date: Sat, 13 Jun 2026 17:51:44 -0500
Message-ID: <20260613225144.2414283-2-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260613225144.2414283-1-sean.wang@kernel.org>
References: <20260613225144.2414283-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Wang <sean.wang@mediatek.com>

MT7927 needs monitor interfaces to be passed to the driver as real vifs
so each monitor interface can be configured with its own band context.

This is required to support concurrent 2 GHz and 5 GHz monitor operation
on the same hw.

Keep the existing virtual monitor behavior for older chips.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index b50825eccdaf..16afc90b7422 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -724,7 +724,10 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, SUPPORTS_TX_ENCAP_OFFLOAD);
 	ieee80211_hw_set(hw, SUPPORTS_RX_DECAP_OFFLOAD);
-	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
+	if (is_mt7927(&dev->mt76))
+		ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
+	else
+		ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
-- 
2.43.0

