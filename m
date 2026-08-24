Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129F03D3B3
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557380; cv=none; b=ptb7IGAqeFPcNfZzlBI9XrCSKDGC8UlGCIL9ZO6HoN5WOuspxE1XwLcLCUXAoUQmy7i4b5z0UuHWQNbIEeHGsOpesJ6lQPjiv2DR1IKFdPx5LvsiiJTYPm6E84Xxy+27PUQWBmrajI9jMAJsA9RdgUi5t1Mw3ANzDLtKlZAyT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557380; c=relaxed/simple;
	bh=1OODO7pfXUqpgrDJ6jtA3ZccTdhv3s/5zA69zCj9aKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+X7ocLOZD8EA3a0f2XVd+SgPR4iN64SXdxGpwu2Kao+OLB3kSSgJ2zassSeCcdkeU1hx1KYLJhrB5otjPMkO9YV0NjVpdUg0dbSELP2U37vF4yZz7Prig6w6EcomXjTm7n4sf21dgo0+8NCHxf7vEERYNV17Hoe5bTKwUeVnag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=a/s95eI1; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="a/s95eI1"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69c108fee7fso5038618a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557376; x=1788162176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0HX+XBP/q492aCWaLX86g+IhZqWVnOcY+XsmiqZR6Tw=;
        b=a/s95eI1DKeEQAdM0s71IjlhUZpaudaHCMyO05vbhufWIjz2ptPzIu/RW58UVBlyYZ
         smDGCq4r75Momx19BCjGWPL2i2umVu6RFU5wgJVprnRJ6W3SSdc6NyHo+0F7sxPQARi3
         vOBhEpWttviS7ZcbSuZprMZavpI+scQ5UeZkt2oQLoKno6jXeijeBzNrr3P36HOypxPd
         u5XcAJJIos8jTF086uh+nf5Wh7rCdg/+I2oyW8BrZ7+f2/CI2kS/8ndKd8unWGySfLJS
         Bn1t9MESWbaLo93NN4IIaxF78IM8LmZ/CeisRImHvCm2hG0q1tIQb1/lOCjuoIVv98PC
         DCbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557376; x=1788162176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0HX+XBP/q492aCWaLX86g+IhZqWVnOcY+XsmiqZR6Tw=;
        b=SznnvA3xgIJzu261t0Xjc9mbOsMrwDFc17lpGyK2FJTD2UMLbBbRkH3GlIWafPTotV
         S7nnq5lNcodI8pD8Z/gWKpFSMAJBPHk5LL6aSfcv+Do4iy100lmpKP5OfP687LFyRKnv
         o8CMs2zELI/33dpT05LiweQPqartwDmTo+/XlB+YZtaXxfAnHrhRPg/D16d/sRowTihw
         wxo3Bo05pn+LUCvdFoMKmy4OggvCJW1FlvQFjzRETHu0hZiHIzsT0MwuFBZ5hQgdFiQP
         oLIWo8fFSy6Y5mQLjelrkP2M2CWh8tOGg7t8MhYsyLHe8qqHDdXJcjwe9kfQh5I56n4G
         Ot0Q==
X-Gm-Message-State: AFuF++l8wMmJU4TDVxPsOkdrUB9UL1myDZlVTKLDe/dJMh2I+AvHWYaS
	dQ3UnNIk02cH371bcl2QjF6mjVBqq7DxUFZUPTHnkImP4uaFLgexgum7ki4fF1oTiiTmh+Ue68b
	llV0oLwya
X-Gm-Gg: AR+sD135KvrlcnsIrCSJCkBlHcifRd90xtQmMOvRGH9wCKwFnaIEIvHjJH8mdGJeDSW
	R/2iD6eR5yCL1DoROu5fkTIsMANzjwXtTP/TzEDEugZFINam9KTw+wUgGtSSNj7XwPwUzcgb7OV
	p8FLrA8iu4BtqS05JU/c7Yfu0gkztm4CJSICQQrHHh8/XKBZx3S7iiufKvsBB2EBo//TWWl7hZ1
	h6h9maltr6PLqpidzh1+vXuC1OP0H5baEhD3Zgh0kdVVQlKRJvAe1lDBTa20vTtZUPUhaimTPm5
	Wqm4IGe27UaXztXRwynK3oRfoJL6XwC/VSBRHCuAINh519ExIUPfBPzcfakpO4KVpNw8eBcJwQa
	Ecr9NlIoWLu2lLZD3z1NWjujKtvjsFNa8zkiDyYiBOyqMaGxboG/2VC5K2CE8tU2Ul6Q/vmd/Nx
	QpI8dyHWOhcDPYEwaXo3yXvd1246oqHiCci5QxzvHyDKh5CvmltIQ8OH0mdGWicAGZztbl4OYsy
	RxdcmytHlih2cBKek9cRsvvMYTebyde7kkUHM7TD0DHL0NLPVoElZOQnvsPzL0GVw1yujap2l11
	AgZrsqLlwzC2jOg4l8JHrvNjlS1Gz8jLdTTQDlDFgCTGf9Gky8ajNsXlu+5zq8XRrELA3HuhJQD
	8+3OhqP8WAugAZB9E9GT6/z8h+NvxYKkMhDcOJBgsnJrMCC+fl9/PbhCr8doHueP5GBZmGL6E62
	vnsmezLpwLtfOJJg==
X-Received: by 2002:a17:907:948a:b0:c1f:922d:34c3 with SMTP id a640c23a62f3a-c24926a1c3dmr1664099266b.14.1787557375972;
        Mon, 24 Aug 2026 00:42:55 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:55 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 5/9] wifi: ath11k: schedule TXQs from the driver
Date: Mon, 24 Aug 2026 09:42:24 +0200
Message-ID: <20260824074228.2114579-6-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824074228.2114579-1-julius@bairaktaris.de>
References: <20260824074228.2114579-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_handle_wake_tx_queue() has exactly one entry point, the
wake_tx_queue callback, so the only event that can start a scheduling
round is a frame arriving from the network stack, and every round runs
under local->handle_wake_tx_queue_lock, which is shared by all four
access categories of the hardware.

That is the wrong shape for a driver whose only backpressure is the
airtime queue limit. When ieee80211_txq_airtime_check() refuses a
station, ieee80211_tx_dequeue() stops handing out frames and the
station's intermediate queue keeps its backlog until the next enqueue,
not until the airtime it is waiting on comes back from the hardware.
Returning that airtime does not reschedule anything.

Open-code the round in the driver so that a second context can drive
it. The walk is the same deficit round-robin over the active TXQs of
one access category that the generic handler performs, taking a
per-category lock rather than the hardware-wide one, and the burst a
station gets from one selection stays bounded by the airtime already in
flight for it because ieee80211_tx_dequeue() applies the limit itself.

ath10k and mt76 schedule their TXQs the same way. A custom .wake_tx_queue
with a tx-completion driven push was proposed for ath11k once before [1];
the design was right and the measurement that justifies it is in this
series.

Link: https://lore.kernel.org/all/20230501130725.7171-1-quic_tamizhr@quicinc.com/ [1]

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.h |  5 +++
 drivers/net/wireless/ath/ath11k/mac.c  | 43 ++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index a0d725923ef2..40895d276de5 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -709,6 +709,11 @@ struct ath11k {
 	 */
 	spinlock_t data_lock;
 
+	/* serialises one scheduling round per access category against the
+	 * other contexts that drive it
+	 */
+	spinlock_t txq_lock[IEEE80211_NUM_ACS];
+
 	struct list_head arvifs;
 	/* should never be NULL; needed for regular htt rx */
 	struct ieee80211_channel *rx_channel;
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 40a2b6d2f804..e5b2a5e56a28 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6546,6 +6546,42 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
+static void ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
+{
+	struct ieee80211_tx_control control = { .sta = txq->sta };
+	struct sk_buff *skb;
+
+	/* ieee80211_tx_dequeue() applies the airtime queue limit, so the burst
+	 * a station gets from one selection is bounded by the airtime already
+	 * in flight for it rather than by a frame count.
+	 */
+	while ((skb = ieee80211_tx_dequeue(ar->hw, txq)))
+		ath11k_mac_op_tx(ar->hw, &control, skb);
+}
+
+static void ath11k_mac_schedule_txq(struct ath11k *ar, u8 ac)
+{
+	struct ieee80211_hw *hw = ar->hw;
+	struct ieee80211_txq *txq;
+
+	spin_lock_bh(&ar->txq_lock[ac]);
+
+	ieee80211_txq_schedule_start(hw, ac);
+	while ((txq = ieee80211_next_txq(hw, ac))) {
+		ath11k_mac_tx_push_txq(ar, txq);
+		ieee80211_return_txq(hw, txq, false);
+	}
+	ieee80211_txq_schedule_end(hw, ac);
+
+	spin_unlock_bh(&ar->txq_lock[ac]);
+}
+
+static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					struct ieee80211_txq *txq)
+{
+	ath11k_mac_schedule_txq(hw->priv, txq->ac);
+}
+
 void ath11k_mac_drain_tx(struct ath11k *ar)
 {
 	/* make sure rcu-protected mac80211 tx path itself is drained */
@@ -10067,7 +10103,7 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 
 static const struct ieee80211_ops ath11k_ops = {
 	.tx				= ath11k_mac_op_tx,
-	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
+	.wake_tx_queue			= ath11k_mac_op_wake_tx_queue,
 	.start                          = ath11k_mac_op_start,
 	.stop                           = ath11k_mac_op_stop,
 	.reconfig_complete              = ath11k_mac_op_reconfig_complete,
@@ -10757,7 +10793,7 @@ int ath11k_mac_allocate(struct ath11k_base *ab)
 	struct ath11k *ar;
 	struct ath11k_pdev *pdev;
 	int ret;
-	int i;
+	int i, j;
 
 	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
 		return 0;
@@ -10791,6 +10827,9 @@ int ath11k_mac_allocate(struct ath11k_base *ab)
 
 		pdev->ar = ar;
 		spin_lock_init(&ar->data_lock);
+
+		for (j = 0; j < IEEE80211_NUM_ACS; j++)
+			spin_lock_init(&ar->txq_lock[j]);
 		INIT_LIST_HEAD(&ar->arvifs);
 		INIT_LIST_HEAD(&ar->ppdu_stats_info);
 		mutex_init(&ar->conf_mutex);
-- 
2.53.0

