Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6104533508E
	for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782587627; cv=none; b=IchN7+7ke9ciiQufZfgX2sWX3qZ/VCVmJNN7YkHr/cdj/fMq3NFIhrizDYX3OBW8FNAadz4WNbg8MBrWNztkndI1XMvXijkeAlP2I6NTvtwR/v1zjgwhkBvh4VKPIvUvw9DbK4VkfqBClNyAvPkZslCDsxmtKL5kcBl9tlr4PDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782587627; c=relaxed/simple;
	bh=Qfj9XkfE4e4BbIIfe+u5LMWdJAq3Rx5SvyyQlt1A2EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpDoXXMoYwg5fnFzyIUkiEaLkBZ+8axifdOnOiiB+CTyO1KZun26JitxsONVtI5aPzAFfn/cA5E6kZQ+WUocHAJhBKfCBha93aPBpwhMYObeyd79auvqA173pqR/DYr8uVVlMi5KJ+Iag9HNs1CwoINmrDTbyuQoqSydePDJLl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=kxX1DVn7; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="kxX1DVn7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1782587622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwEPrF1Hg86jGTRv0FKtMMASUsr/hG3K5Vpsyc4UX90=;
	b=kxX1DVn7mvxmk6FeHYXkbAbi/1gPQqFTZMwh//+ixZCLy9rxBucPsle76eSl1hNAZDNc0x
	9VZBmIMC17xjnEum/j2xjvjk2UixX5EvjRqQjMZtnEf6nTu1RCyOEo4UC9B8vZhmS4pxR2
	ZGhpezzavwFx0mqNBIphBTtRK6HqMxysjuaHeAVepBtC1Y8DF9uDb9hZMP/RYWm0o5ne9A
	BzKpjQ0alDqzNGQn8c9AAiCqJuK2nvp1J2VrteuIjnMYJFiqNhXJiNq2hlJLExoBlGDekS
	b4LPB9LDqTePdPL4SPiIPlOcOTcLGFad3X7sBvrKljKZ2YCCeel0AoXAcDo0pQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] wifi: mt76: mt7921: drop TXRX_NOTIFY on non-mmio buses
Date: Sat, 27 Jun 2026 12:13:34 -0700
Message-ID: <20260627191336.20223-2-lucid_duck@justthetip.ca>
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

PKT_TYPE_TXRX_NOTIFY is an mmio-only event, but mt7921_rx_check() and
mt7921_queue_rx_skb() dispatch it to mt7921_mac_tx_free() on every bus.
mt7921_mac_tx_free() cleans the DMA tx queues with
mt76_queue_tx_cleanup(), which calls queue_ops->tx_cleanup(). Only the
mmio queue ops implement that callback; on USB and SDIO it is NULL, so
a TXRX_NOTIFY there calls a NULL pointer in the RX worker:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:0x0
  Call Trace:
   mt7921_mac_tx_free+0x64/0x310 [mt7921_common]
   mt7921_rx_check+0x5f/0xf0 [mt7921_common]
   mt76u_rx_worker+0x1b9/0x620 [mt76_usb]

Drop the event on non-mmio buses via mt76_is_mmio(), as in
commit 5683e1488aa9 ("wifi: mt76: connac: do not check WED status for
non-mmio devices").

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 1c2377d0a53d..f7d54472da1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -570,8 +570,9 @@ bool mt7921_rx_check(struct mt76_dev *mdev, void *data, int len)
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
-		mt7921_mac_tx_free(dev, data, len); /* mmio */
+		if (!mt76_is_mmio(mdev))
+			return false;
+		mt7921_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
 		for (rxd += 2; rxd + 8 <= end; rxd += 8)
@@ -600,7 +601,10 @@ void mt7921_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
+		if (!mt76_is_mmio(mdev)) {
+			napi_consume_skb(skb, 1);
+			break;
+		}
 		mt7921_mac_tx_free(dev, skb->data, skb->len);
 		napi_consume_skb(skb, 1);
 		break;
-- 
2.54.0

