Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3646C248873
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784682823; cv=none; b=MWV1uR7QMKC+Xh/Ors6ip4GNKhHzSN3+yDoFvE4BxSxmbg41H1u+kv2yB0/vTaiUyYWt1wwkIaplhPJcGy2nbu7R/jfaGtNPbLrTu/InBsL1AelrYqwye4TBG0x6pTnxd725IDkiWCIIqqwj6Y97vHYMGE3ZOv72n3tlem/dAXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784682823; c=relaxed/simple;
	bh=HEWpjUxqggaV8fibTW8Mqqwa1IwJQ0vzanH2KOJTULY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kMT2BUJWA3+aKK0SdcRWc62REJZ9RMaiAeFnTu+li+WfThaUOhMxwr5gedkufDwetnfemQ6pNHZpCtSngEQf1pOiNQv+Gb9oULIDhnnMPj4PnrOuT/edO0Wd++lM+WZR1k3tYoV8MkhydkdSaqgtiJI2MfMsKWYVe1NsxkjVgzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=sLx8gV4k; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="sLx8gV4k"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1784682815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C5Igl9Lka1wstIIVZdEJA9gvA833QM4S676NLH7TY6Y=;
	b=sLx8gV4kzvxVO+76NMRRN8/MP/bNrRTCQS9whWJDIuffj21CdRn0wg1F/snHIYrV8VW5ur
	BDtWu6SVrXFb4uexiiVeY3YxQBwxiPXVLLGjy/ED9PL4tfNJ7K75v2D76QDUDRuLsCUgTb
	nfW36+800F3aJf4OOeCmbC7T0MEyajYXuLOQPlfPAL3YyncSbtuglCaaRglX0gGP66Ea1F
	xFkxzA4zWDcWmWnZX4RAE+QqQs5gybt7EPlQG5sS4OcgfVMl4BRjg+pFaH6qNQqHa36yiH
	Yp82EMmxXalTUqPEJjPNMuEscTg3aiTFBWuLXAKn9fvizuWvwWK3XzXggH4YTQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt792x: do not advertise active monitor
Date: Tue, 21 Jul 2026 18:13:02 -0700
Message-ID: <20260722011302.113060-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mt76_phy_init() sets NL80211_FEATURE_ACTIVE_MONITOR for every mt76 device,
but mt792x firmware does not honor it: entering active monitor mode stops
RX. Gate the feature behind a new per-phy no_active_monitor flag and set it
for mt792x.

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt76.h        | 1 +
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index c4cbf71..0bf698b 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -439,8 +439,9 @@ mt76_phy_init(struct mt76_phy *phy, struct ieee80211_hw *hw)
 	SET_IEEE80211_DEV(hw, dev->dev);
 	SET_IEEE80211_PERM_ADDR(hw, phy->macaddr);
 
-	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
-			   NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
+	wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
+	if (!phy->no_active_monitor)
+		wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 	wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH |
 			WIPHY_FLAG_SUPPORTS_TDLS |
 			WIPHY_FLAG_AP_UAPSD;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6400612..ab0bad3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -872,6 +872,7 @@ struct mt76_phy {
 	struct cfg80211_chan_def main_chandef;
 	bool offchannel;
 	bool radar_enabled;
+	bool no_active_monitor;
 
 	struct delayed_work roc_work;
 	struct ieee80211_vif *roc_vif;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 837d7af..0ad33f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -820,6 +820,7 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 
 	wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 			   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+	phy->mt76->no_active_monitor = true;
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_BEACON_RATE_HT);
-- 
2.55.0

