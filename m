Received: from mail-qv2-f0.google.com (mail-qv2-f0.google.com [74.125.230.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3420F3BB9EF
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 09:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787735892; cv=none; b=f3lRFVPaxBwHGPZfTPBQyc1zv+ZN9dt9Fzjzch7s+F11H+ngs7X+o7rhKYyibQts/GJiOTnDKl+nXfIVnAMNvIWRL75Q6PjkneQekG9/ilR9YvdxdNqUKD7mNDhChagyYJliWexf/5a12XbYqdueDT6gbNsh9w/zfDy/61WFnxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787735892; c=relaxed/simple;
	bh=Qm4aVEDp5iVYR7W7mVql/Uo6ZLz8pH0sIXRqHNFQJLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ugNmicg1priw2oBHSoor4r3ajyLmiSg2DaZRPyqd+pCl+sHoUHWkKCbXJ0ouF/nDbo6IZvtQbLHWKFHGU96lqw95JFt8s9hgq5wsRkLxeZYR53bGTuzboraZRRngfpDDo9OsMrl9ARMEwce97ow/r7Pge3wuTtQ0toyKldvipnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WaoMOLVR; arc=none smtp.client-ip=74.125.230.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WaoMOLVR"
Received: by mail-qv2-f0.google.com with SMTP id 6a1803df08f44-8ef118ead8eso5780596d6.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 02:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787735888; x=1788340688; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3MKQPh2C4GF9FMSVOY2+ZQfDuvG76VBsD6KML05fJ6E=;
        b=WaoMOLVRdzNYJ9FEjos8GhWRjX3u4bSsvYW6gvmzEWitrMoGILdjEF5+NFihvjbTx5
         faVA2J4kv2yWisNlS+RoJLxUOYKXF6GPlf0RtGvRmkmtJlUk3YhCE42/ghP/3WGkxH48
         Q5luH6nLwiIoyApPxPmUtAqTNP0hUQ11a1MbQo3LAIzdl1oA5PaSwkXmpVAttt6548gR
         Cd0VnxPVGVtPZDEXTQ/p4zQBA7cUi30/dLSAOtZ9vp6jgeoZlleqFg3OiAc7c3ONfS4w
         L6Q+yr4Q8KOVkt+NTGT/JV8InTXmW3Y2mTtpIK6ajkLjVm/++IbdIPs/BpzDhTcP2+Ap
         nkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735888; x=1788340688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3MKQPh2C4GF9FMSVOY2+ZQfDuvG76VBsD6KML05fJ6E=;
        b=ZVk8Qdh7GwzP4U0/+zyW6AymambHTf/O4rOFzs4L/WGCYaRByHVKEXPHqr7q1BE4Nj
         DR6EWBMX/x6uTMEz/9mngnUvp+CLtdLTdPzPx/24CBxJmX3F0ZHTqMacVs0OVGeKr1dz
         DSLPG+wfZ0bpC2Ix+l1AyeOeW26vxYX5Z3wToQJ+DnkX0KU2w08LCkjIHShNV1OSSMtn
         BBXrxK66POwPImJ30GsUmNZMif7F7UdVxElJT+1TjJUZuCt5MswvLfWB2ZrtXIrO24dW
         geqbJmB+7cY0iqAcWu2DldpxnvUXI/Ft4FZazbHp7Nn99tgOJLEoaPWKjqqwk+7AOG8h
         So/g==
X-Gm-Message-State: AFuF++lnCZjrdbbKMBa2G6P8TiCBLnDo+Q85Nh+r9ozQcuxWSNWRogzX
	aB6cyXfhhpxPpIZwnl01TfTJ2KC3IZIs/mPnxfX7SYhPCwiY7PjMQJHLDgrxRS16KNU=
X-Gm-Gg: AR+sD10nFZbDuAjGzxnL84jBs2ykqx5WUwYrrMjTK5ijMJsNfAJZZ7+70WoL2dUfhox
	DXD/25Fl7JEY8p6HxVqvJkO0T/nn7Vy8InUpdyFfsh0nS3XahR0fCq1fIRVrHuHfwq2N+kwTNBA
	hrV6iD6uAGhArvzixW88rUULAjZNqgr/iJtlCNn4ctdl7Sw8jFoH25jW9exvFEF+7bIOYk6Nd2w
	i17syQfwX4zaMtr6LygTO5OblKWudgC7AooW0PAEYgtgdCKpPUc+p7B34LQkAc7N1j88x0GdV5/
	Uxa99IPVkMa48zrE5uJi8urHDDge1l8+/Ub9SbZaAKgC8aA77Xkgxg3xGh1CS899cmm0sZ5J1hN
	Lg8anUxbgmZrZl3fuy116o2MmpIbggbFegTK8Dw/PY4p3wMf256FOdMuxmMGqXO7VkJrmQc4TNm
	tab9+4oJl/Yo5LqMUDsJkl8jvVjviTejMrftMXVoopDJqJaXWRKZFQOO002O93hl0WR6JKWfK7F
	xZkIO+eGy/aUw==
X-Received: by 2002:a05:6214:260d:b0:907:94e6:f8bc with SMTP id 6a1803df08f44-90cc79998c3mr49398766d6.15.1787735888267;
        Wed, 26 Aug 2026 02:18:08 -0700 (PDT)
Received: from localhost.localdomain ([2606:6d00:39f:4500:5acb:2301:2b5a:c076])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc65448f5sm20748926d6.45.2026.08.26.02.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 02:18:07 -0700 (PDT)
From: Mark Anthony Agarro <markanthonyagarro@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-mediatek@lists.infradead.org,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH wireless] wifi: mt76: mt7925: honour mac80211's FIF_FCSFAIL instead of hardcoding drop_err
Date: Wed, 26 Aug 2026 05:17:57 -0400
Message-ID: <20260826091757.469953-1-markanthonyagarro@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7925_mcu_config_sniffer() hardcodes drop_err = 1, ignoring what
mac80211 actually requested via configure_filter(). FIF_FCSFAIL is
computed there but discarded instead of persisted.

Persist the FCSFAIL bit on the phy in mt7925_configure_filter() and
read it back in mt7925_mcu_config_sniffer() to derive drop_err, so the
firmware sniffer only passes through unfiltered/marginal frames when a
monitor listener actually requested them.

mt7925_mcu_config_sniffer() is only reached from mt7925_change_chanctx(),
which is itself only exercised on a monitor-mode chanctx, so this stays
scoped to monitor mode.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   | 7 +++----
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt792x.h        | 1 +
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a9059866b..cfbfd77e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -832,11 +832,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
-#define MT7925_FILTER_FCSFAIL    BIT(2)
-#define MT7925_FILTER_CONTROL    BIT(5)
-#define MT7925_FILTER_OTHER_BSS  BIT(6)
-#define MT7925_FILTER_ENABLE     BIT(31)
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 	u32 flags = MT7925_FILTER_ENABLE;
 
 #define MT7925_FILTER(_fif, _type) do {			\
@@ -848,6 +845,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
 	MT7925_FILTER(FIF_CONTROL, CONTROL);
 	MT7925_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
+	phy->rxfilter = flags;
+
 	mt792x_mutex_acquire(dev);
 	mt7925_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e94fa544f..adc137a0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2251,7 +2251,7 @@ int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 			.len = cpu_to_le16(sizeof(req.tlv)),
 			.control_ch = chandef->chan->hw_value,
 			.center_ch = ieee80211_frequency_to_channel(freq1),
-			.drop_err = 1,
+			.drop_err = !(vif->phy->rxfilter & MT7925_FILTER_FCSFAIL),
 		},
 	};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 4cc259418..8fb8a4c13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -7,6 +7,11 @@
 #include "../mt792x.h"
 #include "regs.h"
 
+#define MT7925_FILTER_FCSFAIL		BIT(2)
+#define MT7925_FILTER_CONTROL		BIT(5)
+#define MT7925_FILTER_OTHER_BSS	BIT(6)
+#define MT7925_FILTER_ENABLE		BIT(31)
+
 #define MT7925_BEACON_RATES_TBL		25
 
 #define MT7925_TX_RING_SIZE		2048
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 70073b43a..75d32a4ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -168,6 +168,7 @@ struct mt792x_phy {
 	s16 coverage_class;
 	u8 slottime;
 
+	u32 rxfilter;
 	u32 rx_ampdu_ts;
 	u32 ampdu_ref;
 
-- 
2.47.3

