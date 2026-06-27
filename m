Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECB233B6C4
	for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 19:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782587632; cv=none; b=RxBSHcnKO1Fw3oWkrSMSLX3tG9QEN8kf19W26A9uvPrPlKd0pIT2YfMyESToPsf8YMYwy0cFiCKU4SDxdm513BgQGxbUc/79zrNMAMbdV/hNT7gpr3Te06VnVUae9BJbLC3kIqbCK7uA99bGJCnZKTrYMZDwv8Kyqn23y5kPEKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782587632; c=relaxed/simple;
	bh=FGC/zP+YF/PQQkGwZPuaeuoGfCHAlRt9DMUDA3jqKmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOoVa6SLyAavEWhzavPD6f9jWw5pTkXS/LY6yPhxCcs5lhjbokRPN/gtRWIX4kZ88wM9lC+ca93Klx7FGg2rjPYD/yPis4MgcETNn9ZfF6EB75ySUY8WxcDY3+EbgD5mmUcf8qb/3PjOGqbDoFZ/1OHvzcqKGq4zYnVW2BrFXfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=o0YtgnpS; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="o0YtgnpS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1782587628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/LbuPLV8G+3ghp9tHGo/cT7j2hO0ahRag2fTXp2F+Y=;
	b=o0YtgnpSWnMPCB6NNfFjt/RbAeBgcvkCoyugP/Kkz/E4TfDCW+ZSgBzwISTGISCY1FTW8u
	yezC7xY76xYIYqI0mfGsm0Aq0kGpdT8M5u55cOYMiAtEfh5Kz+yHxvcg7CRjgGCdFUBfDW
	uOpn+eUCsiQ8z1GmB0WAmXy0g1ND7UatFEmiPxn8+Sd1BQzhFH2kcVVt2opHVVNeJzNUgD
	5LKevYtqi2ZredZr85yNHMKfOEDnW09c/E5YCBvH5eDB3jmWbnH74WGrQbyYONKeHnkY3u
	/PKSxHj8oMF0cF8ip3FFAn0HkBUEO+miavp/IGnQQLDqaeFbQJr0himn1sLbcA==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses
Date: Sat, 27 Jun 2026 12:13:36 -0700
Message-ID: <20260627191336.20223-4-lucid_duck@justthetip.ca>
In-Reply-To: <20260627191336.20223-1-lucid_duck@justthetip.ca>
References: <20260627191336.20223-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

PKT_TYPE_TXRX_NOTIFY is an mmio-only event, but mt7615_rx_check() and
mt7615_queue_rx_skb() dispatch it to mt7615_mac_tx_free() on every bus.
mt7615_mac_tx_free() cleans the DMA tx queues with
mt76_queue_tx_cleanup(), which calls queue_ops->tx_cleanup(). Only the
mmio queue ops implement that callback; on the mt7663 USB and SDIO
buses it is NULL, so a TXRX_NOTIFY there calls a NULL pointer in the RX
worker. Same defect as the mt7921 and mt7925 patches in this series.

Drop the event on non-mmio buses via mt76_is_mmio(), as in
commit 5683e1488aa9 ("wifi: mt76: connac: do not check WED status for
non-mmio devices").

Fixes: eb99cc95c3b6 ("mt76: mt7615: introduce mt7663u support")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index ce0051468501..aad232c5a6fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1601,6 +1601,8 @@ bool mt7615_rx_check(struct mt76_dev *mdev, void *data, int len)
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
+		if (!mt76_is_mmio(mdev))
+			return false;
 		mt7615_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
@@ -1634,6 +1636,10 @@ void mt7615_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 		dev_kfree_skb(skb);
 		break;
 	case PKT_TYPE_TXRX_NOTIFY:
+		if (!mt76_is_mmio(mdev)) {
+			dev_kfree_skb(skb);
+			break;
+		}
 		mt7615_mac_tx_free(dev, skb->data, skb->len);
 		dev_kfree_skb(skb);
 		break;
-- 
2.54.0

