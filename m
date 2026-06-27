Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D6933C1B7
	for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782587630; cv=none; b=c1ACYU2VfBgW06o11zludvdMUxlQ2sElbb0N35YkBtwSsHHQdQqwV/pBj+JyNRzdE00diwrtmdj/r3LtBD10dechtzLH6vX2e/8PaElgVC6veMy1ZErN6feKFNbLtH3q0e87CkGAJ6GZVCjpLn2/LUY0KH/VkQuuiYb6emptSK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782587630; c=relaxed/simple;
	bh=WZJow2O3xwvZyTmKBmu5kW3kR7/oDfHpN7WvumpKzgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhEoe4TaBCPsuUngnXoyZAp/Cq6fr0WXBrPTaaLT8NMxb983RVfHct4WH4L5fKaHnBjFbdmbdLtkckBCGDFVe45003J1QtGtGTn2A3GHFQ87ZhWRH9d+mpt4wbs5sIEAgSi4s0OX2PIPs8ITWM+B0YKBkF5bnHZ8+s/e2Z6NqxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=SiiYVLnD; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="SiiYVLnD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1782587625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FML57A1kKPWPFqajkC+DnG/O8YGkMs9hj9SAuvnfT7M=;
	b=SiiYVLnDRdggtOmvViFJcBCXB/MN07rqYTah8zSI6gWa3U2JiWqAurCDy+Kr9iCZi/jORp
	RH3DaVQK+HJxGGxbdWhsOlz/UMDwjPqMsb9O3qzo1iw3JnX6t6NRwMWCjEninUJAknYz8U
	wrHe3ZwMg7u5/oePPyJa8cLRq0MP6txfZmHQemuD5cIIT+dXOvFUTSXq8CCgSwGx1fpZY7
	fMHE6EISgKtuebnwOnLVHPsh+E9VQI+j/Smym3Q1jKOuueDtaialdLwqiL21fR7KV/bZuQ
	ik30DEF+bhpadzI0SQ4dgC3TMeg6EbwbC+AYrRKtanpW4LAOM+J2egbd9sCCZw==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] wifi: mt76: mt7925: drop TXRX_NOTIFY on non-mmio buses
Date: Sat, 27 Jun 2026 12:13:35 -0700
Message-ID: <20260627191336.20223-3-lucid_duck@justthetip.ca>
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

PKT_TYPE_TXRX_NOTIFY is an mmio-only event, but mt7925_rx_check() and
mt7925_queue_rx_skb() dispatch it to mt7925_mac_tx_free() on every bus.
mt7925_mac_tx_free() cleans the DMA tx queues with
mt76_queue_tx_cleanup(), which calls queue_ops->tx_cleanup(). Only the
mmio queue ops implement that callback; on USB it is NULL, so a
TXRX_NOTIFY there calls a NULL pointer in the RX worker:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:0x0
  Call Trace:
   mt7925_mac_tx_free+0x58/0x350 [mt7925_common]
   mt7925_rx_check+0xe2/0x130 [mt7925_common]
   mt76u_rx_worker+0x1b9/0x620 [mt76_usb]

Drop the event on non-mmio buses via mt76_is_mmio(), as in
commit 5683e1488aa9 ("wifi: mt76: connac: do not check WED status for
non-mmio devices").

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 0641a7131d7c..2f9871792ea1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1203,8 +1203,9 @@ bool mt7925_rx_check(struct mt76_dev *mdev, void *data, int len)
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
-		mt7925_mac_tx_free(dev, data, len); /* mmio */
+		if (!mt76_is_mmio(mdev))
+			return false;
+		mt7925_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
 		for (rxd += 4; rxd + 12 <= end; rxd += 12)
@@ -1240,7 +1241,10 @@ void mt7925_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
+		if (!mt76_is_mmio(mdev)) {
+			napi_consume_skb(skb, 1);
+			break;
+		}
 		mt7925_mac_tx_free(dev, skb->data, skb->len);
 		napi_consume_skb(skb, 1);
 		break;
-- 
2.54.0

