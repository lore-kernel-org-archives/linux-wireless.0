Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E129BDB1
	for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2026 15:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774367359; cv=none; b=o+ad+fUBmvoG9xTA38J0C1uKggqMsEjd5caqCXlzOUE7jo+E+q4KtJP/7gfiLwoB+Dw5LWtH9koyVajyQHW8Zfuq3F1jENjYzFl0FwQCRUL+aLS2I2sjdGt2aERVFnx5Z8R3RC9RnxZnRXWo7pg8ji1TB1vAU73tw9iiiyabv1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774367359; c=relaxed/simple;
	bh=Q88nHSAQemzWnHNM0BQBKmQswo3NXVDjC5dq4Tn+M/k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEWpRzUhVfd1wp27vdtn8bdClN8E+VVwX5K4vqCZl5DnorvQVEImKG5MQeo/+/KEbhHgVmYG9AlbKuZU68iomSjc5Tq40DvSJIoxgnEqiiYfNTqDxwd8mpXQOpc2BFDW35kUngPvrErdDj18NbthaG/5W6S9ViJcYZFKeFEkcvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=UAtDY8CM; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UAtDY8CM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qm8xzxuHJC54a5Hw//8ZtzEYPjBPtwG/MjnkYt0SkPQ=; b=UAtDY8CMlBAtTXE6pLvSKVygQc
	FfoL0Qw8TogWQgGGtIK1zzT5d3n+syLS1oBkEZuDJHQ1d2OCv16SMBybhgmeSiao/SZbuSZ5tZtXw
	M6vb+MWpex6GEXWs0CxLt4oJ56ogINqYM8iZ2qWqE5Qn/W/NepuUBXaCc6u1PKWLpxZU=;
Received: from p200300cadf3fa900000000000000085c.dip0.t-ipconnect.de ([2003:ca:df3f:a900::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1w540F-00Bfki-06
	for linux-wireless@vger.kernel.org;
	Tue, 24 Mar 2026 16:49:11 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wifi: mt76: mt7996: add missing max_remain_on_channel_duration
Date: Tue, 24 Mar 2026 15:49:04 +0000
Message-ID: <20260324154904.2555603-2-nbd@nbd.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324154904.2555603-1-nbd@nbd.name>
References: <20260324154904.2555603-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Having this unset breaks remain-on-channel and mgmt TX.
Move setting it to mt76 core to keep it in one place.

Fixes: 69d54ce7491d0 ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 4ae5e4715a9c..dd68776ada28 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -449,6 +449,8 @@ mt76_phy_init(struct mt76_phy *phy, struct ieee80211_hw *hw)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AQL);
 
+	if (!wiphy->max_remain_on_channel_duration)
+		wiphy->max_remain_on_channel_duration = 5000;
 	if (!wiphy->available_antennas_tx)
 		wiphy->available_antennas_tx = phy->antenna_mask;
 	if (!wiphy->available_antennas_rx)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 42e11ba1206e..e437e088b2e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -195,7 +195,6 @@ mt7615_check_offload_capability(struct mt7615_dev *dev)
 		ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 
 		wiphy->flags &= ~WIPHY_FLAG_4ADDR_STATION;
-		wiphy->max_remain_on_channel_duration = 5000;
 		wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 				   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
 				   WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 152cfcca2f90..5a5d7534830b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -657,7 +657,6 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_P2P_DEVICE);
-	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_scan_ssids = 4;
 	wiphy->max_sched_scan_plan_interval =
-- 
2.51.0

