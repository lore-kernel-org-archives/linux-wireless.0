Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4D435C1A9
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 06:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788072133; cv=none; b=dZkmND8Pfs1/r/ugyOgSCvOFR+HxnE9g5AbpJ+bUnJkFoX5/Vz0He2kJdbLP4tyZvJ5AN1OL+xZHazf88T/MXrbarqULZcxPg4i6w7/N9e8N0hIQJcpEiIXU6akGOoriC7uQ42Y88etewBpcwXsUWpC+ylMOnR5Q7BQ8Rv8v9XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788072133; c=relaxed/simple;
	bh=7MKfCcBndncjeNxWHOxZyoVYJLtzxHUJwjDBGR4CTDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thnu/ahnZE0aT3fL1mgWW+3cRTvTdMKnbvkIBm7xMj3JgKqcvt22G+dZw9QSsG++VBTdljZernO9mLqo0Undtx5y72GL76hiU5KlsEGK7vKMEoDF1SX1sUWX7SntLz4CnMQ+jCKY1tLBrtGhri3XhZDGH/oWKVphdZxOpFGHKQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=mEL6NROG; arc=none smtp.client-ip=95.215.58.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="mEL6NROG"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=7MKfCcBndncjeNxWHOxZyoVYJLtzxHUJwjDBGR4CTDA=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788072129; v=1; x=1788676929;
 b=mEL6NROGtz6yBwONmHHGmGEcQNwXN0Tm1t1JyDHpk81BY6m8tac3aaejKQfgkD30RuPQB96O
 8y65CsJx/IYRbrnEBkhasyGPz58E9n3iXAGL5GvjRQK2ZUXiJEJzlARmtdbFeF/QBBHWNead2Lr
 ZBQmm/BCZ9IbfcJZJeJv+7ks1GbLYshMcgrADbyAjY+xRN5oLCdv+JbvP61rjwHYu6uvtIXMLuQ
 RjHKmsl6ifPp1yzvz1FKn38y1z+KMokGQQYGr2sAa0lZzdhUhFTgvtndlml5FqcbwPC5fSXfhiD
 YmDuNb9azeo0uP4kuFHAwk/qt2gGn2kCQecaOnaNIVaCA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3abbd23f51e05e81;
	Sun, 30 Aug 2026 06:42:09 +0000
X-Mizu-Trace-ID: 3abbd23f51e05e81
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless 2/2] wifi: mt76: mt7925: fix the lock inversion in suspend and resume
Date: Sat, 29 Aug 2026 23:42:01 -0700
Message-ID: <20260830064201.92285-3-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260830064201.92285-1-lucid_duck@justthetip.ca>
References: <20260830064201.92285-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same as the previous patch, other driver.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 84b55f008b3d..44ac2d5e1bdc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1717,10 +1717,10 @@ static int mt7925_suspend(struct ieee80211_hw *hw,
 	mt792x_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7925_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7925_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt792x_mutex_release(dev);
 
@@ -1735,10 +1735,10 @@ static int mt7925_resume(struct ieee80211_hw *hw)
 	mt792x_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7925_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7925_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT792x_WATCHDOG_TIME);
-- 
2.55.0

