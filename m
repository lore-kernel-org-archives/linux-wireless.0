Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9EC40B0EF
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588178; cv=none; b=XnmdATvUo6sp1fz4eHmpiVt2gkukOyerT99HL4pkGmvDoQr0CZ2gI9WjyoBey1sydbmYlC7vtBEYg5ZRMZy9+HjsOeHgQqKx92YgVjIQQ+hKMrZeo08Zps4MkTA0z190uWgayec8h+DXkfHipzRDbbSwYSlZ+NpPU83VdIUmWs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588178; c=relaxed/simple;
	bh=3ugyrwjt508oa5YRjzpIkbzxhNbpUCqRAwbyo9XjILY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KPYCM01WvLsJVytdsuGYMCACqPuz0aezmwnxYtec/esIcXHhSHuuDhzHGlfvjfmoK1jEOc8/G2JC4sEk0lV7CnTa8WAzrwKVc7EbzbPiR5gksHBbqKjpvxwGLokHRcnjHgwp+b64CTEyTTeig7g7seT23ZTwINykqnfKS3U5Yyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NnRPfFPO; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NnRPfFPO"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6c0fce17so802235e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 12:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789588151; x=1790192951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GPA1DSANSZ2wx5ap9tiYRblcf1dOFfjW+WHihKGkeG4=;
        b=NnRPfFPOsiLZueP4WJr5IUxvA1jxJ+aN5sDDInecTjoluHiw22WSCpAmOrSQXL1kEV
         hP+Nve1vAn3fdmcLLDfJu3vCbSBBkXJT5uxSnMVfQc4Mvw/gMq7zFqb1yhVPg6P0mMCZ
         zhnnsj3lUtpI5Ruj/R7gAmPJF9Ru9n5HenzgN/vGSyYS4r4E/v3iWv1EBXLn4m5hou9o
         aKzBexLXq/X+GvpHKnOLmeqZiLabPQ7+qDHakGaht30PxtkSsk1oEiBIB/ubeXt2zOgz
         Tyy1ugnNmPnadTu5UatWTYac10em9oNCcLa5AUzpNjJ3kNkWBNZAK3ENdPzLnS8UxLlr
         Q6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789588151; x=1790192951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GPA1DSANSZ2wx5ap9tiYRblcf1dOFfjW+WHihKGkeG4=;
        b=BS9mHL9lrAKAmBqUC1nTZLUo0aOyChS7JTX+qtBMPFk77cxY6p49gSSKTK88Rd1+/j
         GMAitCB1BtrG0Jw8Zhg3gDdULOqFAh3a5iDo/MTA6kuD+g2ElnG+TOBAZymg+LjyUu7z
         ATz4OY5rVbJFk1lyyn6uHAPCOVPGAlMUoFQz+6sy84JT5xwNZVZSSVQ9rTyA/QGukCU9
         6jMzsp8ZPySE3sfKkFJrc0VgGEQAIeupU6hVRY2WBLiqVqTV7QWNeHqQMuzK/vGiGyb3
         IQQGGokHu4LbIYm9rqO/Lq0r+Th3A0qZPuV0BO6OQR75R8d1bepPK0uUFqWYzlj3Duk9
         aqQg==
X-Gm-Message-State: AFuF++nur2XxzLSRrgKToriBebl0Dr1SBcFeMDpS7Bl2gAnUVSRuDHHG
	y8+Xe7uzZPs7rRDKcxILXsO/f4MfpAZV9N25jMv9VwmjrWYG6ugcPpNCtPv7nksCRKsZ
X-Gm-Gg: AYBFou2YwdeLl/XLBxdXJesLg90y5CTC0xMzPDXUb+J8VnmeIQYIS9QmXP9FLX6Kz/R
	bQ1qjs61Xnpf2SPSWIKI68G7zrv8gEuzmUmHeDFFuSbaDJqpFQyzzwrEr3wAAuw/hS9LTBM35f5
	/AIrUaPez2u7Ht2w0IsgOLRwfub/ZrZdJLDEZpGNfjU9K6MDMU0mp10JsFAV90NuWG7Cz9LkJN7
	R3JzEQBsyGWtYtqdDM4vwdaYiHMR4saN7cyltBSuZQOiE35tRt4gLan1q0RXHMcne06EghcAvCT
	Nzam8q/e6kPaIcCk2cq2oZJ4iGJZ1qaN6JYNh87SybIg1Ar85qzCv5UaEAtj62NqgQdCl97Bykt
	9BeeAbM27TWfE3I2bPBytXM8fvJEnkKfJMBCpa8qtmyO1N6OaISilPC+e1F3DBVW1vIKcujVB9g
	pO8R5a00+LG/A4k/7B1n2cLrfSCJjXiZFVN5bCD9HQFHnNzBjWt8YSzw5exDHVuBj1mUw3bTDQp
	oSu2Zw6ql9XpyBlZo+cctldOgKPCQ/3e7+5fo4fU3Pu+JzKuAnuIjT2m4ZrSg==
X-Received: by 2002:a05:600c:621a:b0:49d:1d6a:4cfb with SMTP id 5b1f17b1804b1-49eac463a00mr43701435e9.1.1789588150982;
        Wed, 16 Sep 2026 12:49:10 -0700 (PDT)
Received: from localhost.localdomain ([193.160.247.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbda7c461sm1682895e9.4.2026.09.16.12.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 12:49:10 -0700 (PDT)
From: Andrea Pesaresi <andreapesaresi82@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrea Pesaresi <andreapesaresi82@gmail.com>,
	nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: initialize tx_info band for 802.3 offload
Date: Wed, 16 Sep 2026 21:44:12 +0200
Message-ID: <20260916194647.1421848-1-andreapesaresi82@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The failure was first observed in normal use on a GL.iNet GL-MT6000
(MT7986). An iPhone using FT roamed between the 2.4 and 5 GHz BSSes
while generating traffic, then lost connectivity and the router
rebooted. The ramoops record from that reboot shows:

  Unable to handle kernel read from unreadable memory at virtual
  address 0000000000000010
  CPU: 1 PID: 1419 Comm: mt76-tx phy0
  Hardware name: GL.iNet GL-MT6000 (DT)
  pc : rcname_read+0x1ec/0x340 [mac80211]
  lr : ieee80211_get_tx_rates+0x140/0x4cc [mac80211]
  Call trace:
   rcname_read+0x1ec/0x340 [mac80211]
   ieee80211_get_tx_rates+0x140/0x4cc [mac80211]
   __mt76_tx_complete_skb+0x6bc/0x9a8 [mt76]
   mt76_tx_worker+0xb8/0x1f0 [mt76]
  Kernel panic - not syncing: Oops: Fatal exception in interrupt

ieee80211_8023_xmit() clears tx_info before queueing a frame for
hardware encapsulation and does not initialize info->band. This is
normally harmless because mt7915 uses the firmware rate stored in
wcid->tx_info.

During AP-side FT roaming, the WCID rate information can be unset
while an 802.3 skb remains queued. mt76 then falls back to
ieee80211_get_tx_rates() with band 0. On the 5 GHz PHY,
wiphy->bands[NL80211_BAND_2GHZ] is NULL, leading to a NULL pointer
dereference in rate control and a kernel panic.

Set info->band from the resolved PHY while dequeuing hardware-
encapsulated frames. The dequeue caller has already selected the PHY
using wcid->phy_idx.

Temporary diagnostic instrumentation and a same-MAC dual-radio FT
stress test with continuous traffic reproduced the invalid state twice
in 300 cycles on MT7981. Both cases had info->band=0, PHY band 1,
tx_info=0 and HW 802.11 encapsulation enabled.

With this fix applied, three independent 300-cycle runs completed on
MT7981 and MT7986 (900 cycles in total) without a router disconnect,
kernel warning or crash. Continued testing with the original iPhone
also exercised repeated FT roaming without recurrence.

Fixes: 55f7c9b02790 ("mt76: mt7915: add 802.11 encap offload support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Pesaresi <andreapesaresi82@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3707ee19e4..a168851959 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -406,6 +406,8 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
 	info = IEEE80211_SKB_CB(skb);
 	info->hw_queue |= FIELD_PREP(MT_TX_HW_QUEUE_PHY, phy->band_idx);
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		info->band = phy->chandef.chan->band;
 
 	return skb;
 }

base-commit: 1eeca1d5e0920fbdad6449768fd2d4364e714180
-- 
2.43.0

