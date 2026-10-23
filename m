Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720117;
	b=u76ziHTI/VnThNcYuvi7jtQiYn4qj9lv2S35ZxBtK38ZbAZp8Rnznzv7emq2IrMbz1iB
	 k/7fmH1P3NAz4xB2BDH07N7J9USn6z9nl/7r0KUqZelA5GX/gpZLUxuV6/05+VeJUbxJk
	 aIgGlrGJVqqY2E8V8xxkAQRvRFFxeXLrl8hgQT1vvHMsYLmRSwfYXW96onZr7lPWhGQef
	 6KA91NNrXLPq1fvU2c9MjtuSuEgCVbrt1p4hXS7LtH90eVEgrjoc4gIzQD7lZTnmI5b/l
	 +HB7HGSp5bhTNc1l3XfIyUABG1xCp5xSL4KWpzvsgiMNx5uFuY4kVPw9YnFzQ6coOsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720117;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=y7hmqCw1gCI3F+lKJo+60hsoMoL3Lp/xNtSnOd4UKmo=;
	b=oONJDBXT+izP3PJOBQBL23bfEgpW0AZEl+wp6L/NyU+qX70bTr/O9nkjFy7B9WIsXq+2
	 T8IT6ZyxuenYF6ujfkrD16eXhNvRjl6auD3IhPYH78bcQV+aH6magRAjuLehNZPsblLvP
	 di0LqJvzoCcpfVO8O1i123cDlj5q4X0k39fuGzvG4CeCSPwBaquBw2pUM38znlAAOkP6D
	 w+4JdaSw1ntsrrza6wzfZXhQS51VU/jeZYc7MB3YH7GVH368LWGxSg9Q0hdf17WiBLAKm
	 CP+SCLdgSB9PyUMrXNiF0DNoKyMLN7McpNf8/hmY2KFylBbaNfc7FGhWJb8aRz84pIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=R3KqssjK;
	arc=none smtp.remote-ip=91.218.175.18
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EE606A319
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 01:48:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 892EE606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=R3KqssjK
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=UzeWU/Wa88XK/oJoJqM7yCGkUyFCG9Jv8jwwR7Jh4V0=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792720114; v=1; x=1793324914;
 b=R3KqssjK6+XybNJ4OM/khG6oaAtp4lpCKTbjDx17e2Jd96Jy+dgpovpZ+SHVowZHxAt1ze5v
 yBUdpjcwIRibRDsPXLF/SZNEPMnsX/Z7yYiR0+tRTaAnyVC/s/m8EeVhjlPXZ0G0VOyos8v2C4E
 qFaoZIt6RMkM2WzTrW1AVVNSPiplVKO/9PhirycEWXwc/9uNxyfHYrNWHX/4afr7Skc1lcpTCsz
 ZkTOCAdsOsDdHoXsKFfe45JOvrxk3trrMfqhFSN27CVs18cwdoh9NW+puOHCfrW2H6nokakDjtY
 E21VMEBwm12qqz8qNrwTdfa43JduExMU4nQx0vyPi3exA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 173adff547ff4ada;
	Fri, 23 Oct 2026 01:48:34 +0000
X-Mizu-Trace-ID: 173adff547ff4ada
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Michael Lo <michael.lo@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: mt792x: tell mac80211 when a disconnect cancels its ROC
Date: Thu, 22 Oct 2026 18:48:27 -0700
Message-ID: <20261023014827.57411-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
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

A disconnect during a remain-on-channel (ROC) cancels the ROC in
firmware without telling mac80211, which then waits for a ROC that is
already gone. Scans stall, and after an AP deauth the station does not
reconnect.

Tell mac80211 when the driver cancels a ROC that mac80211 started.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Fixes: 5ed54896b6bd ("wifi: mt76: mt7921: fix a potential scan no APs")
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Fixes: 45064d19fd3a ("wifi: mt76: mt7925: fix a potential association failure upon resuming")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Tested on an MT7922 and an MT7925U: without this, scans stall after a
disconnect during a ROC. With it they work, and the station is back
about 4 s after an AP deauth. mac80211's own cancel stays silent, since
it ends that ROC itself.

 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 14 +++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 15 ++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt792x.h      |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 09574d4417cd..019c1ff5b0a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -381,6 +381,9 @@ void mt7921_roc_abort_sync(struct mt792x_dev *dev)
 	ieee80211_iterate_interfaces(mt76_hw(dev),
 				     IEEE80211_IFACE_ITER_RESUME_ALL,
 				     mt7921_roc_iter, (void *)phy);
+
+	if (phy->roc_mac80211)
+		ieee80211_remain_on_channel_expired(mt76_hw(dev));
 }
 EXPORT_SYMBOL_GPL(mt7921_roc_abort_sync);
 
@@ -405,16 +408,21 @@ void mt7921_roc_work(struct work_struct *work)
 
 static int mt7921_abort_roc(struct mt792x_phy *phy, struct mt792x_vif *vif)
 {
+	bool aborted;
 	int err = 0;
 
 	timer_delete_sync(&phy->roc_timer);
 	cancel_work_sync(&phy->roc_work);
 
 	mt792x_mutex_acquire(phy->dev);
-	if (test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
+	aborted = test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state);
+	if (aborted)
 		err = mt7921_mcu_abort_roc(phy, vif, phy->roc_token_id);
 	mt792x_mutex_release(phy->dev);
 
+	if (aborted && phy->roc_mac80211)
+		ieee80211_remain_on_channel_expired(phy->mt76->hw);
+
 	return err;
 }
 
@@ -430,6 +438,7 @@ static int mt7921_set_roc(struct mt792x_phy *phy,
 		return -EBUSY;
 
 	phy->roc_grant = false;
+	phy->roc_mac80211 = type == MT7921_ROC_REQ_ROC;
 
 	err = mt7921_mcu_set_roc(phy, vif, chan, duration, type,
 				 ++phy->roc_token_id);
@@ -471,6 +480,9 @@ static int mt7921_cancel_remain_on_channel(struct ieee80211_hw *hw,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 
+	/* mac80211 ends this ROC itself */
+	phy->roc_mac80211 = false;
+
 	return mt7921_abort_roc(phy, mvif);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 22cc5b49da0a..0394250d46e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -527,6 +527,9 @@ void mt7925_roc_abort_sync(struct mt792x_dev *dev)
 	ieee80211_iterate_interfaces(mt76_hw(dev),
 				     IEEE80211_IFACE_ITER_RESUME_ALL,
 				     mt7925_roc_iter, (void *)phy);
+
+	if (phy->roc_mac80211)
+		ieee80211_remain_on_channel_expired(mt76_hw(dev));
 }
 EXPORT_SYMBOL_GPL(mt7925_roc_abort_sync);
 
@@ -551,16 +554,21 @@ void mt7925_roc_work(struct work_struct *work)
 static int mt7925_abort_roc(struct mt792x_phy *phy,
 			    struct mt792x_bss_conf *mconf)
 {
+	bool aborted;
 	int err = 0;
 
 	timer_delete_sync(&phy->roc_timer);
 	cancel_work_sync(&phy->roc_work);
 
 	mt792x_mutex_acquire(phy->dev);
-	if (test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state))
+	aborted = test_and_clear_bit(MT76_STATE_ROC, &phy->mt76->state);
+	if (aborted)
 		err = mt7925_mcu_abort_roc(phy, mconf, phy->roc_token_id);
 	mt792x_mutex_release(phy->dev);
 
+	if (aborted && phy->roc_mac80211)
+		ieee80211_remain_on_channel_expired(phy->mt76->hw);
+
 	return err;
 }
 
@@ -576,6 +584,7 @@ static int mt7925_set_roc(struct mt792x_phy *phy,
 		return -EBUSY;
 
 	phy->roc_grant = false;
+	phy->roc_mac80211 = type == MT7925_ROC_REQ_ROC;
 
 	err = mt7925_mcu_set_roc(phy, mconf, chan, duration, type,
 				 ++phy->roc_token_id);
@@ -604,6 +613,7 @@ static int mt7925_set_mlo_roc(struct mt792x_phy *phy,
 		return -EBUSY;
 
 	phy->roc_grant = false;
+	phy->roc_mac80211 = false;
 
 	err = mt7925_mcu_set_mlo_roc(phy, mconf, sel_links, 5, ++phy->roc_token_id);
 	if (err < 0) {
@@ -645,6 +655,9 @@ static int mt7925_cancel_remain_on_channel(struct ieee80211_hw *hw,
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 
+	/* mac80211 ends this ROC itself */
+	phy->roc_mac80211 = false;
+
 	return mt7925_abort_roc(phy, &mvif->bss_conf);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index a7d71e007da0..1cc8475dc608 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -240,6 +240,7 @@ struct mt792x_phy {
 	wait_queue_head_t roc_wait;
 	u8 roc_token_id;
 	bool roc_grant;
+	bool roc_mac80211;
 };
 
 struct mt792x_irq_map {
-- 
2.56.0

