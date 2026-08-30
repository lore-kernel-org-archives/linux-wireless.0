Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8B02DCBE3
	for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2026 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788072131; cv=none; b=b6adQxS/kJ+6xk+2r9Wxby/KrDfwa8rCe/uxJxntPvm57z5QesSThNsuafrvCsf+wM/b8/XJb3NZzmFgpz9ImkpDnsunQ0jNHiiDR5WqgXe/t5rEygeQXcRsk20LqkXa8D5jbpSbJDYQ5k3d/AzMU11VVopVU10JF3M+C7vTMkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788072131; c=relaxed/simple;
	bh=lwntEoPEeZ5hIqcQzszGuiaXI6UrB+4Mx0DCavUnjvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIoOB+4URRGU++D911j1qnNlyCtnkl/Uxvc4aLsfOcAmdroESINS4jV76XyB+sxMFQSZjJxjMosiqS/E1dDozihqatXbr7Z9tcE/5npjBjWFbhszrxIWZE41uDRje0NSlPxWcnO77It5w7dNv/phwBX1SJH3pOePpfCzrUPQQ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=UyWQoejH; arc=none smtp.client-ip=91.218.175.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="UyWQoejH"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lwntEoPEeZ5hIqcQzszGuiaXI6UrB+4Mx0DCavUnjvY=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788072127; v=1; x=1788676927;
 b=UyWQoejHSz51qxz9XOBa5R/Xx/X5mQEsJmp+pckQwUXuSmTTw8bECZ7h8LnsXxq/VD9/9bOZ
 ZOy/TjnEsjHYHFAQtpynK6xhYjsXxCsK3ADjGg7FRH4ZbqkiEBGz5mbuyKG5jCXq+w1I9RKmJjt
 UOUMEvwkNmPraa3mBd+w3brdzGcmp9DWaG7SMcefcvRY+V4zyYr1UwZnRy4CBXlV0vXE8EoV5Bj
 P8fcyChULt1r9yv+9Zx6+UQsSGYhToE7d7qf1nLP7OC0w0uhYAvplJR7G9LrF23pz9+p5ay6M3C
 UoaBxYqsnjBI++DEwAj3T1s2jNQuKABuaNyI/9ieomh9A==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a55ad1e27de18dd5;
	Sun, 30 Aug 2026 06:42:06 +0000
X-Mizu-Trace-ID: a55ad1e27de18dd5
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
Subject: [PATCH wireless 1/2] wifi: mt76: mt7921: fix the lock inversion in suspend and resume
Date: Sat, 29 Aug 2026 23:42:00 -0700
Message-ID: <20260830064201.92285-2-lucid_duck@justthetip.ca>
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

Same inversion as the config path, same one word fix, missed the
first time. Both are called with the wiphy mutex held, so the walk
can rely on that instead of taking the list mutex.

No new splat: same class pair as the accepted fix, and lockdep
reports a pair once per boot.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Link: https://patch.msgid.link/20260810045338.118923-2-lucid_duck@justthetip.ca
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 68a059504e83..bd8d969dfee5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1156,10 +1156,10 @@ static int mt7921_suspend(struct ieee80211_hw *hw,
 	mt792x_mutex_acquire(dev);
 
 	clear_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt7921_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt7921_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	mt792x_mutex_release(dev);
 
@@ -1174,10 +1174,10 @@ static int mt7921_resume(struct ieee80211_hw *hw)
 	mt792x_mutex_acquire(dev);
 
 	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
-	ieee80211_iterate_active_interfaces(hw,
-					    IEEE80211_IFACE_ITER_RESUME_ALL,
-					    mt76_connac_mcu_set_suspend_iter,
-					    &dev->mphy);
+	ieee80211_iterate_active_interfaces_mtx(hw,
+						IEEE80211_IFACE_ITER_RESUME_ALL,
+						mt76_connac_mcu_set_suspend_iter,
+						&dev->mphy);
 
 	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
 				     MT792x_WATCHDOG_TIME);
-- 
2.55.0

