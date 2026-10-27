Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131100;
	b=ZW4zqYezK5is4Uot0M58VjR3YghXkuieD66IwKWzeoU2aUg5HMdHqE4Jvr2+G0a40ym8
	 wXkd7xX9hLDo50ngDfSxrGxnhTT36vB4On8fjJt/HW2K7lvh4ayIkaBy5bGpg9cZNhxAz
	 HfsCbtzHa/PY26mRVqCUwq8IZENkJSo5PITmnHiVR/0TT5t7O3yjviYiX6vtJX0Tw+/fl
	 id8VofQpX+KTzpyx0+ejZzRxqsSZ2CcL6H0YMDdYc+oAWmtglUxVC3ATcjYT7breNAvIT
	 +z4hv20WX9azaHPkansmleE/l0TpXiy42gQvq7mcm9uZJqcUQdihOv0TRYzZ989U7nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131100;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YmSeWrLDHug5hmREEl4v75tbJwuivcm3EZ4Ale97CmY=;
	b=LcS2AhXZQQHS8rFex1YUNkx7t0zcAwONRxPgo7U7fnJafTd9XQuy6rKZOA3RhAJgge7v
	 sN1DMZwIQD6TWUgfD2QHXxcXQt7khEa4SzBlcP8CLCE62u0imOrmd+KvBELlTDHE7bJjo
	 yiX8Vn4H4mfbFzi69mO47a73/AVxBnNfe1QTN6/Jt2edJ7jSPKiX6v9PGyKwYbU7RFtyE
	 xAZVqb9yeQKJcCzU6pBhR/T3JY1l0XOyHGDBhQBa+ObEO3WrUkMZJ9PbBnBChe/B00F82
	 w/wqt9ou0hvH6FU30owEhp+P7ElOljDjO/MUQn9otnL6oPE7k+HE/CrJdZ3g7b2oUGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=UssE6PxP;
	arc=none smtp.remote-ip=91.218.175.227
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E172606A324
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E172606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=UssE6PxP
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JU7SOCtUHUHndWZYZOTVOVh2PhRQ269t0wVq8ONFpg4=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793131098; v=1; x=1793735898;
 b=UssE6PxPzMBvFhdg1JSHI3jxhXpgMN+WoAUCBzlR8gOabgp8ONZuhR8tykBdlI/1b0qfme8n
 kFCff/mWhKCKN/lnlRSB9KLAG30l+0lidqBDL9cGaQgA8LtFEmcDbh2AvcufBfVm6Q9gzARrrep
 0+96/A22JJAnCgqPg0HYD9+jpzhBKDqSIJ2ct4wj5hLoiFRRURbyCmxDLkuq7JBaR8Vr3/1xcve
 3zwzmckvXctUdYefoV+wZB6INXhVZfRBs9COtbSySnmb+JXb3zMcTp0VnyD6pdEzN8aMgZGnLFg
 UALMI05dz/Wxjjx/4LcsIyDMI8gXv4xnWMDlScyGx1nYw==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f57e996020db06b4;
	Tue, 27 Oct 2026 19:58:17 +0000
X-Mizu-Trace-ID: f57e996020db06b4
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Alex Gavin <a_gavin@icloud.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless 4/4] Revert "wifi: mt76: mt792x: do not advertise active monitor"
Date: Tue, 27 Oct 2026 12:58:03 -0700
Message-ID: <20261027195803.711995-5-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027195803.711995-1-lucid_duck@justthetip.ca>
References: <20261027195803.711995-1-lucid_duck@justthetip.ca>
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

This reverts commit 6f6c9800e54c ("wifi: mt76: mt792x: do not advertise
active monitor").

That commit hid active monitor, saying the firmware stops receiving in
that mode. The monitor was missing a channel, which the previous commit
gives it. Since 7.3, tools that ask for one, like owly and hcxdumptool
-A, are refused.

Advertise it again. Without the previous commits a lone active monitor
is accepted but hears nothing.

Fixes: 6f6c9800e54c ("wifi: mt76: mt792x: do not advertise active monitor")
Link: https://github.com/t4t5/owly/pull/24
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 5 ++---
 drivers/net/wireless/mediatek/mt76/mt76.h        | 1 -
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 89f289ac57a9..08876ed2dfe4 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -440,9 +440,8 @@ mt76_phy_init(struct mt76_phy *phy, struct ieee80211_hw *hw)
 	SET_IEEE80211_DEV(hw, dev->dev);
 	SET_IEEE80211_PERM_ADDR(hw, phy->macaddr);
 
-	wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
-	if (!phy->no_active_monitor)
-		wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
+	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
+			   NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
 	wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH |
 			WIPHY_FLAG_SUPPORTS_TDLS |
 			WIPHY_FLAG_AP_UAPSD;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9e851dea71d9..b591fb3e3b7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -871,7 +871,6 @@ struct mt76_phy {
 	struct cfg80211_chan_def main_chandef;
 	bool offchannel;
 	bool radar_enabled;
-	bool no_active_monitor;
 
 	struct delayed_work roc_work;
 	struct ieee80211_vif *roc_vif;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index dcb244a3f8ea..674007dc4266 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -821,7 +821,6 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 
 	wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 			   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
-	phy->mt76->no_active_monitor = true;
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_BEACON_RATE_HT);
-- 
2.56.0

