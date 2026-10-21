Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.160
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792625982;
	b=Pq9sSA8/Cn9wQ7Vg51ajg06biYnRq3cZquriuDT4OTI7AEWwP/RJKnyO3QnVrBc8JvOo
	 AvhZtnZ7VQ7g+tgb7MaDquo89vZbPme9yWBYMh/uwB/ofhrLrOVOBwKr3MWzSmWmc16eg
	 lt3DfT4dpzzDiqmYVecnMY72UvhdznsbhItfBcvTx+PvH0fCk0A/QLk5lPlfFPrOKZ0ZR
	 WdvUk02vi2ZksZ7PNDsl6r4GWR6SikRRfQm93Oqj19CVzDiK0foO8lHQjk7I7J2FGCz9Y
	 4RfEF32owLOssw+efxGaRBRJ2j8zLEh2BtDV4GiXrNyfkKln+u6KnBnb9/1PTOljGdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792625982;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=n3FwEyIo7Vcx9zYzOnFYxTxgem53y0HAqqjNwh7AJmY=;
	b=JdJX3DTBfikGl/LT0ZX43/xBgqvRRZ9dP19s9gnZf7NNbj29hA0rxj6wutAij0oyWy9v
	 6yDbPBrmBCznkKcpWp4lG4WgKexD+7JPhfVMUR7zAPlpr4qZhb9Qpk/go3B+7oTJFVkKY
	 G4/LBUwVA7LAtxciiBUQLm2eO8L1dH/owFpWtopbSTN89nXFzKC22J4UzyCJrlmpFwGga
	 pMtPYRIRCdrXF2+tadq9qb0YbInWkdr7s3zgWxVdZY54yWF2B/u047x0FwM0GGDdpAWl9
	 NbMr+8lqExtg72pgg5LhlyVbNCkD513RECTLzFsBlik9ReKvN8oK77q529OpJ/WkJ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=aREz7uPs;
	arc=none smtp.remote-ip=95.215.58.160
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFCD606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 23:39:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDFCD606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=aREz7uPs
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5zjnmuNAR3yi/aRKcjj0i+hbo2YtZAeBwV7FRZWUe1w=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792625978; v=1; x=1793230778;
 b=aREz7uPsIag05BPJdaDaphz1Z7/CapPnwqP4GxzIMN07adHxvNUIJTTGfp+v/IcJ78DdzDsx
 z4d+iGUEGOmaDuWyUeqSRa+5EBzNjqUm+iirlEvxon/uE+psrz//yXnoKB1CFmH/9yW44HEMN6L
 z2/jXg7wAlMoU4B1Kl11a2Ugah8lYs26bjVBNJyz83wNusR1RrCXqs9LAs9vu5sTnwyN22U41kC
 H1AvfKT/7N21zeOd2btnvjRcEWIlh+o1+73bVRM0oJvGNXKxdE7az4VUtfgVQqe++b3AthNrAFa
 DCOlc4LmPS2MyKHsY3O583uJaTqvNxuQDnQghazy/1Yjg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0b20f29eccbdc5bf;
	Wed, 21 Oct 2026 23:39:38 +0000
X-Mizu-Trace-ID: 0b20f29eccbdc5bf
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Viktor Pashaiev <w.paszajew@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless] wifi: mt76: usb: keep the tx worker parked through a reset or teardown
Date: Wed, 21 Oct 2026 16:39:35 -0700
Message-ID: <20261021233935.748017-1-lucid_duck@justthetip.ca>
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

The mt792x USB reset and disconnect paths park the tx worker and then
stop tx. If frames are still queued when the wait runs out, stopping tx
parks the worker a second time, which warns. It then unparks the worker,
which runs again during the chip reset or the teardown:

  WARNING: kernel/kthread.c:710 at kthread_park+0x8c/0xc0, CPU#2: kworker/u16:1/100
  Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
  Call Trace:
   mt7925u_mac_reset.part.0+0x73/0x1e0 [mt7925u]
   mt7925u_mac_reset+0x3c/0x50 [mt7925u]
   mt7925_mac_reset_work+0xb5/0x1f0 [mt7925_common]

Remember that a worker is disabled, and leave the worker to the caller
that parked it.

Fixes: 0d2afe09fad5 ("mt76: mt7921: add mt7921u driver")
Fixes: 7910bd565d8b ("wifi: mt76: mt792x: quiesce USB paths on disconnect")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Making the disable call skip an already parked worker is not enough on
its own: stopping tx would still unpark the worker at its end.

Viktor Pashaiev's mt792x USB hardening patch avoided the same warning on
disconnect by not parking the worker there:
https://lore.kernel.org/linux-wireless/20260927180415.1498019-1-w.paszajew@gmail.com/
This keeps the park and fixes the stop path, which also covers the reset.

 drivers/net/wireless/mediatek/mt76/usb.c  | 10 ++++++++--
 drivers/net/wireless/mediatek/mt76/util.h |  9 ++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index be48a88a3ad0..47106ed6bb94 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -1068,6 +1068,7 @@ void mt76u_stop_tx(struct mt76_dev *dev)
 	ret = wait_event_timeout(dev->tx_wait, !mt76_has_tx_pending(&dev->phy),
 				 HZ / 5);
 	if (!ret) {
+		bool parked = mt76_worker_disabled(&dev->tx_worker);
 		struct mt76_queue_entry entry;
 		struct mt76_queue *q;
 		int i, j;
@@ -1083,7 +1084,11 @@ void mt76u_stop_tx(struct mt76_dev *dev)
 				usb_kill_urb(q->entry[j].urb);
 		}
 
-		mt76_worker_disable(&dev->tx_worker);
+		/* The mt792x disconnect and reset paths park the worker
+		 * before they get here. Leave it parked for them.
+		 */
+		if (!parked)
+			mt76_worker_disable(&dev->tx_worker);
 
 		/* On device removal we maight queue skb's, but mt76u_tx_kick()
 		 * will fail to submit urb, cleanup those skb's manually.
@@ -1100,7 +1105,8 @@ void mt76u_stop_tx(struct mt76_dev *dev)
 			}
 		}
 
-		mt76_worker_enable(&dev->tx_worker);
+		if (!parked)
+			mt76_worker_enable(&dev->tx_worker);
 	}
 
 	cancel_work_sync(&dev->usb.stat_work);
diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
index 617966e8de76..71f3aa42bb82 100644
--- a/drivers/net/wireless/mediatek/mt76/util.h
+++ b/drivers/net/wireless/mediatek/mt76/util.h
@@ -21,6 +21,7 @@ struct mt76_worker
 enum {
 	MT76_WORKER_SCHEDULED,
 	MT76_WORKER_RUNNING,
+	MT76_WORKER_DISABLED,
 };
 
 #define MT76_INCR(_var, _size) \
@@ -91,7 +92,7 @@ static inline void mt76_worker_disable(struct mt76_worker *w)
 		return;
 
 	kthread_park(w->task);
-	WRITE_ONCE(w->state, 0);
+	WRITE_ONCE(w->state, BIT(MT76_WORKER_DISABLED));
 }
 
 static inline void mt76_worker_enable(struct mt76_worker *w)
@@ -99,10 +100,16 @@ static inline void mt76_worker_enable(struct mt76_worker *w)
 	if (!w->task)
 		return;
 
+	clear_bit(MT76_WORKER_DISABLED, &w->state);
 	kthread_unpark(w->task);
 	mt76_worker_schedule(w);
 }
 
+static inline bool mt76_worker_disabled(struct mt76_worker *w)
+{
+	return test_bit(MT76_WORKER_DISABLED, &w->state);
+}
+
 static inline void mt76_worker_teardown(struct mt76_worker *w)
 {
 	if (!w->task)
-- 
2.56.0

