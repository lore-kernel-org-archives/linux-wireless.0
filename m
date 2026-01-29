Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA623EA8E
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2026 23:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.172.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729419; cv=none; b=MVAW8bvX0QfTeQAWXISS+uvQGV31rCYENOR+H0ULn/OGK/DlxldKVhQbadxwALhDj9QDPiacXaXb7TWhLRvOzMHRv9lE0HmRAdn0aisUnLg25xpEwONU744AwDOZ6iXYVb6+KkaGXmSBorCy8MBXQny1RYDg2Sh6tteTDejIO/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729419; c=relaxed/simple;
	bh=cYV+S1poLG3zOhpK3v5Vt81YSGQXzrx6B1Ag/C8c48g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qE6mFkCgdxcuJVbqVZTENiLJM5G6AcVsBnYlu1SOKtkC4XDI2L2CSNWee3Bsc4wWn+zLsuAXUhvHShRrC5I1kayKtz1ALBdaUNBFChp4mkXiXRluSCb2sd/SNp3u3SmYdkGYiytHbKw28OOHnB2WGnVyCXEsNAQOsaa6pX8locI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=david-bauer.net; spf=pass smtp.mailfrom=david-bauer.net; dkim=pass (4096-bit key) header.d=david-bauer.net header.i=@david-bauer.net header.b=ndYNbSDQ; arc=none smtp.client-ip=95.143.172.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=david-bauer.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=david-bauer.net header.i=@david-bauer.net header.b="ndYNbSDQ"
Received: from mailgate02.uberspace.is (mailgate02.uberspace.is [185.26.156.114])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 85D4E61714
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2026 00:23:51 +0100 (CET)
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
	by mailgate02.uberspace.is (Postfix) with ESMTPS id 72D3D17F747
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2026 00:23:51 +0100 (CET)
Received: (qmail 32761 invoked by uid 988); 29 Jan 2026 23:23:51 -0000
Authentication-Results: perseus.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unkown) (::1)
	by perseus.uberspace.de (Haraka/3.1.1) with ESMTPSA; Fri, 30 Jan 2026 00:23:51 +0100
From: David Bauer <mail@david-bauer.net>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH mt76] wifi: mt76: don't return TXQ when exceeding max non-AQL packets
Date: Fri, 30 Jan 2026 00:23:20 +0100
Message-ID: <20260129232321.276575-1-mail@david-bauer.net>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: SUSPICIOUS_RECIPS(1.5) BAYES_HAM(-2.999999) MID_CONTAINS_FROM(1) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -0.099999
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=david-bauer.net; s=uberspace;
	h=from:to:cc:subject:date;
	bh=cYV+S1poLG3zOhpK3v5Vt81YSGQXzrx6B1Ag/C8c48g=;
	b=ndYNbSDQrNwf7xGt82nlrHof8y4t/AgBZh4xQb7NYSFYb9ZEJ4Hgu8wZdPxDrAnsmsEYf+7ljX
	cRuRwJkHHnmOdV3YA38wo3cE6NkbdozK/T1FRKulgf8XWUubf0veIF8pOzGkIJeHCpvJIESsax8u
	6Utc+9hhVW53MAJXL8h4x6cwoizLt4gZ1Q9DiMdtp2mbnH+4+37GuO5r+OgRQf4A5urQAfyxesb9
	6K8E/Zf1WpUErPf/dExUrde31xDB84T0TrQdVNX7/PumcINXJLIzPLfi1hwYxGwh/WITPb2vJttk
	M1ejI9DyHa3rOy6lGDIq39tcZaRb/GC0sz0BsCWxpTHp0f5FhVIlqtLIPOtKq6BA281DO1ej/4vW
	+IrZJ6WJoRTFE4hu3MGm47hZGLe68S0NlBxjLK4PDF/BwJHsrF5PPBXCkd3gVVa6xBaKE6aUj/N8
	dOwEwrwdc7h7S9fgipUI1l3YHj6KJs46bR2/2CEGTLT9+WNcDY3ZABfXiy//f2mnuJfBilPQ4REw
	G1nQjW1vvNbQa67fY46dlIU6R4LUP8Ur7NG6uhVMS+USBgzNaJyIOHi+2bh3nobggb1qHyvBIsSU
	+NZoX7k7AUoO9KhwPbYzXa5+45nMZlEwSw3bI3MpPfq0jO0KjsZ4ZJliT2Zwo2q9sODYajl6KVCF
	8=

mt76_txq_send_burst does check if the number of non-AQL frames exceeds
the maximum. In this case the queue is returned to ieee80211_return_txq
when iterating over the scheduled TXQs in mt76_txq_schedule_list.

This has the effect of inserting said TXQ at the head of the list. This
means the loop will get the same TXQ again, which will terminate the
scheduling round. TXQs following in the list thus never get scheduled
for transmission.

This can manifest in high latency low throughput or broken connections
for said STAs.

Check if the non-AQL packet count exceeds the limit and not return the
TXQ in this case.
Schedule all TXQs for the STA in case the non-AQL limit can be satisfied
again.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 9ec6d0b53a84a..0753acf2eccb8 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -227,7 +227,9 @@ mt76_tx_check_non_aql(struct mt76_dev *dev, struct mt76_wcid *wcid,
 		      struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta;
 	int pending;
+	int i;
 
 	if (!wcid || info->tx_time_est)
 		return;
@@ -235,6 +237,17 @@ mt76_tx_check_non_aql(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	pending = atomic_dec_return(&wcid->non_aql_packets);
 	if (pending < 0)
 		atomic_cmpxchg(&wcid->non_aql_packets, pending, 0);
+
+	sta = wcid_to_sta(wcid);
+	if (!sta || pending != MT_MAX_NON_AQL_PKT - 1)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		if (!sta->txq[i])
+			continue;
+
+		ieee80211_schedule_txq(dev->hw, sta->txq[i]);
+	}
 }
 
 void __mt76_tx_complete_skb(struct mt76_dev *dev, u16 wcid_idx, struct sk_buff *skb,
@@ -542,6 +555,9 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 		if (!wcid || test_bit(MT_WCID_FLAG_PS, &wcid->flags))
 			continue;
 
+		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+			continue;
+
 		phy = mt76_dev_phy(dev, wcid->phy_idx);
 		if (test_bit(MT76_RESET, &phy->state) || phy->offchannel)
 			continue;
-- 
2.51.0

