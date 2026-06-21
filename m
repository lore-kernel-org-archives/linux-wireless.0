Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7359841C72
	for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2026 13:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782048339; cv=none; b=IjPFva5rKxW8CzRmqRZ7CkdX10IC98qNRWqRZhBrZsLtDBgCuDFongIpyIhkV8OhQy5xu00WF6eZi4fBwSuB/SRetUopE0D/syNRPP9RxsQeEwmiQufn7QfG0tCfkuIBDjGAZjTTLLYhbppefuOBIHkfi4MiaOhgf8eS3+ur8f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782048339; c=relaxed/simple;
	bh=2IbzxPtlxuKatGmkGNigWUlp5SQFrZG2GJ9GH/1MzzE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sveg9GofyiK8j9XA/BA81Z+JZ3KSmQHkHUUQwTpYYVjsgW33TGThiT+0z7htlFO05ERMfzmGQgVHaePaWp0TvJ2M7UgfuJK9+N8YPDT/iUEAbV7RZI8XB/uHTtnn8/sujc3Kt8dgnedeoQmi9jP9nv+U8+Paoa8F74iZQVTCx9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iV27+AFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iV27+AFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3ABC1F000E9;
	Sun, 21 Jun 2026 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782048338;
	bh=cx5Q7/ku7gsTZmZ3GOU0+vMbh5Q6hh5pyKlmVU1DXCA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iV27+AFpnrbRDKwmWYRHIACsbx313RQtEzN3+GYnhHFTRUnrjyLMlphtVPKBT1PqJ
	 Kv+nBHIYnOynAWJyAKnibDTmHz6TXUu6Sr8ZoeYOpaLsj1pzkf1GT0Aihfp696HT5h
	 CGuRb6H0osvNTZ7wHd9UPt3xw+kaqqhtBD7gHg/Ye0WmY2XgdDNqDT6auVXsnag/xp
	 pE2MTpW5d0vJqAXFqXKttdQ9vaRa1r+3nVV+O7wmOlUsH8HRaf+IzUZ1CyULXrMqV0
	 GYcyKdkmP+mlQSeAu/co14fkOoFX0JLu29xnebG4/2xXq0olKQ2+coeBEnQ5CeUx+F
	 RY12yvpjC8EUQ==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Sun, 21 Jun 2026 15:24:59 +0200
Subject: [PATCH 1/4] wifi: mt76: connac: fix possible NULL-pointer deref in
 mt76_connac_mcu_uni_bss_he_tlv()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260621-mt76_connac_get_he_phy_cap-fix-v1-1-ed4ccf7a0363@kernel.org>
References: <20260621-mt76_connac_get_he_phy_cap-fix-v1-0-ed4ccf7a0363@kernel.org>
In-Reply-To: <20260621-mt76_connac_get_he_phy_cap-fix-v1-0-ed4ccf7a0363@kernel.org>
To: Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>, 
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Leon Yen <leon.yen@mediatek.com>, Hao Zhang <hao.zhang@mediatek.com>, 
 Nelson Yu <nelson.yu@mediatek.com>, Rong Yan <rong.yan@mediatek.com>, 
 Money Wang <Money.Wang@mediatek.com>, Bo Jiao <Bo.Jiao@mediatek.com>, 
 StanleyYP Wang <StanleyYP.Wang@mediatek.com>, 
 Howard Hsu <howard-yh.hsu@mediatek.com>, 
 Evelyn Tsai <evelyn.tsai@mediatek.com>, 
 Lorenzo Bianconi <lorenzo@kernel.org>, 
 Mingyen Hsieh <mingyen.hsieh@mediatek.com>
Cc: linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, Quan Zhou <quan.zhou@mediatek.com>, 
 Deren Wu <deren.wu@mediatek.com>, MeiChia Chiu <meichia.chiu@mediatek.com>
X-Mailer: b4 0.14.3

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: d0e274af2f2e4 ("mt76: mt76_connac: create mcu library")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 6596c9e198f4..58b0b15e4fd6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1458,6 +1458,8 @@ mt76_connac_mcu_uni_bss_he_tlv(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	struct bss_info_uni_he *he;
 
 	cap = mt76_connac_get_he_phy_cap(phy, vif);
+	if (!cap)
+		return;
 
 	he = (struct bss_info_uni_he *)tlv;
 	he->he_pe_duration = vif->bss_conf.htc_trig_based_pkt_ext;

-- 
2.54.0

