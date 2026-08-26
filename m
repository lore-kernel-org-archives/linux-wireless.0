Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A863911C6
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 23:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785837; cv=none; b=EuJA+ex1PPw9xCrXvxcv/0YRmLRkHWZ/OrLpGuE+wI4T6qn1cjV6nMORC2DL4JSy6gW9EXyb9PhfvrVyDZIlD+LBX+8vGjG3tZd8mPYM5/UhZjLgv297HZdjjvCtArXPOFzqdI0EUE85hvmMwBVHdiOOp8p8B73n8qMWClqFPko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785837; c=relaxed/simple;
	bh=21mH2w05RhttlqCfTjbNE8XuWsn5+7CCGKT6qfTQtqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=knDoK89usJkWm77rRQ/MpAqvnot9j4k+55Z9+y5fXHAcAfnEaOAW6ILZHlLhdLKh5c+DPSCFN9Fv1UR2xogKaad5Eb9V3BoBjH4OMre6UsiXMXDMEIdyqmFrPra57iUU82mbb/ZnEo2EithVdLUE/SggIl4wGY1cl8kyoJlIpoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=CkQCF8Ox; arc=none smtp.client-ip=95.215.58.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="CkQCF8Ox"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=21mH2w05RhttlqCfTjbNE8XuWsn5+7CCGKT6qfTQtqM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787785832; v=1; x=1788390632;
 b=CkQCF8Oxoh7kuO+Bzw9m9SmsKDdqcgthZ49e2OOMQrl8MBtKKFpkR/c/gaBxguT8JZZJZ+i3
 R+q8yPTYON21q+zLuMnbzAd7Nl+Yv2Pf3InUf05zJWQS6wNX35Ct75eXInu5Xxa2jp1Hqog+12/
 xVdtTvCU3oXeEWTBVXp4wkNgE7Vg0X5cUc7tlw8DObYBMWt+yX6w+Mb0IzdifHcuOzyWxhM5p0n
 3BvQwxiOgpHkeSTTEEdgVJMXCQKNzX6ZbM66r/7jX8CJ2FBdTbE24PSV/tNJkx2HZtMrmOzJbpb
 xxelUJyluYFGydpDTprzl0h08BP4DGCXErrjhTE2xzXYg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 03c0f21bc6a38391;
	Wed, 26 Aug 2026 23:10:32 +0000
X-Mizu-Trace-ID: 03c0f21bc6a38391
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: mt7921: honour FIF_FCSFAIL instead of hardcoding drop_err
Date: Wed, 26 Aug 2026 16:10:29 -0700
Message-ID: <20260826231029.39632-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a monitor interface asks to see frames that failed their checksum,
mac80211 passes the request down to the driver. mt7921 works out the
answer, sends it to the firmware as a receive filter, and then configures
the sniffer with a hardcoded byte telling it to drop those frames anyway.
The answer is used once and never kept, so the sniffer never gets to see
it.

That matters to anyone using monitor mode to judge a link honestly, which
is most of the reason to be in monitor mode at all.

Mark Anthony Agarro posted the same change for mt7925: keep what mac80211
asked for on the phy, and read it back when the sniffer is configured.
This does that for mt7921, and applies on top of it, since that patch is
what adds the field.

https://lore.kernel.org/linux-wireless/20260826091757.469953-1-markanthonyagarro@gmail.com/

The stored value is read in one place only, configuring the sniffer, which
has a single caller, and that call sits inside a branch reached only by a
monitor interface. Nothing else changes.

Measured on an MT7922 with a read-only probe on the command as the driver
sends it, so these are the driver's own bytes rather than an inference
from what came back:

  request  arm      drop_err
  none     stock    1 1 1 1
  none     patched  1 1 1 1
  fcsfail  stock    1 1
  fcsfail  patched  0 0

Stock sends the drop byte whether or not anyone asked for it. Patched
sends it only when nobody did. Withdrawing the request and making it again
inside one driver load moves the byte back and forth, 0 then 1 then 0
across three changes, so nothing sticks once set.

If it does appear to stick when trying this against an MT7927, that is
mac80211 rather than the driver. It raises the filter count
unconditionally when a monitor comes up, but skips lowering it again for
drivers that set NO_VIRTUAL_MONITOR, and that is the only chip in this
family which does.

Fixes: 914189af23b8 ("wifi: mt76: mt7921: fix channel switch fail in monitor mode")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Not standalone. This needs the mt7925 patch linked above, which is what
adds rxfilter to struct mt792x_phy. Without it this will not build.

 drivers/net/wireless/mediatek/mt76/mt7921/main.c   | 8 +++-----
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 5 +++++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 68a059504e83..95f7f56125ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -668,12 +668,8 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
-#define MT7921_FILTER_FCSFAIL    BIT(2)
-#define MT7921_FILTER_CONTROL    BIT(5)
-#define MT7921_FILTER_OTHER_BSS  BIT(6)
-#define MT7921_FILTER_ENABLE     BIT(31)
-
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 	u32 flags = MT7921_FILTER_ENABLE;
 
 #define MT7921_FILTER(_fif, _type) do {			\
@@ -685,6 +681,8 @@ static void mt7921_configure_filter(struct ieee80211_hw *hw,
 	MT7921_FILTER(FIF_CONTROL, CONTROL);
 	MT7921_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
+	phy->rxfilter = flags;
+
 	mt792x_mutex_acquire(dev);
 	mt7921_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index a118a301564c..7abd1d98feed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1226,7 +1226,7 @@ int mt7921_mcu_config_sniffer(struct mt792x_vif *vif,
 			.len = cpu_to_le16(sizeof(req.tlv)),
 			.control_ch = chandef->chan->hw_value,
 			.center_ch = ieee80211_frequency_to_channel(freq1),
-			.drop_err = 1,
+			.drop_err = !(vif->phy->rxfilter & MT7921_FILTER_FCSFAIL),
 		},
 	};
 	if (chandef->chan->band < ARRAY_SIZE(ch_band))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index fb8654b7c5e7..f7ed11353d28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -7,6 +7,11 @@
 #include "../mt792x.h"
 #include "regs.h"
 
+#define MT7921_FILTER_FCSFAIL		BIT(2)
+#define MT7921_FILTER_CONTROL		BIT(5)
+#define MT7921_FILTER_OTHER_BSS		BIT(6)
+#define MT7921_FILTER_ENABLE		BIT(31)
+
 #define MT7921_MAX_AID                  20
 
 #define MT7921_TX_RING_SIZE		2048
-- 
2.55.0

