Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A32A49BB44
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345768; cv=none; b=ZsH+rtuFsytKeqJP7UuCkvlVfBQEzrPS4dxAgrFFN9Som9IbjW/f3YXfX9dsdFuOPn+sYRP/iB8rgg8O1udGdeUjfxyANQ20sNXq6VPrL3tU6oOEPTwmLttnknJ+/u+1Ma7z3HVTPiYDSM9pXa7vFVa+baPLrp5zHtQ2zsnoFqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345768; c=relaxed/simple;
	bh=41/7yKfqOf/Oa8ARKIhU1Gp6nYUwAoDpafmx54YJ6ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYVXr+7QGT6XF0d3Mb0bkJEf97AXuMhoniTzslgQ3m0vRS2S+0rUaSMMDUAluLd3tsVVEFiXWHybfbM+bKuOCfz4+S4peO8N38E8JEteF5ofQvWzIW66NruAvUD+UkZ7o8SdymKGwJdLAm+pXBDfDM3fUus4TYYRlwRUhO0W2dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=YnFbWD7z; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="YnFbWD7z"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2dc8cb0decso97433466b.2
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345764; x=1792950564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TS0RADOWk/YlWZLm9ufvki+kHt2Uzf9z4JtPVKhgy+s=;
        b=YnFbWD7zXtm9M+saGcJL4bluf5mlTmEoaMlQS4PH+VzmEk1Y1znxv0GVQTayj9p776
         7B88xzFxUJSs+obS4ky0A6bfEAEmzKWEukSzNO9EWtBzvziLC6YwGMFs3IR0xs6iCe7u
         w5y6kvE7dXmi6x5IUh1ZyYC0Fa/0UoWUZtejdbEqEBNBAsO2ea1+rG8mn8G6RVNndFSy
         r/lGnQHfF62+Vm1Vz8VgiJmzrJYqntlk4RJm0O7fl9MM3GACGZmPSkWOrc0lA2LM46IC
         lu0D5SNcJ8A8bdH6P5RnSnEPO/JmIjRMWw2r25TS9nLk4qYxayhVeiatnUjQ1mRqvQAy
         WbVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345764; x=1792950564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TS0RADOWk/YlWZLm9ufvki+kHt2Uzf9z4JtPVKhgy+s=;
        b=RLXUcFwYzeXOyYEQ2vdESiT9FwGtnIIixg+3gXfoJYxX0kEugEQYwNIvHSSWvMUMuw
         enWLJ+nFSm8wKiBq/3UfBu/SeGvqqTv1ySdWAIG4b80YBCdIR+rheVwALLkuqrRnq+9m
         LCfhawXlDJvzVxeM8LujZayEY2nOCawo7ZV8V8lEz6shi2pYrUNB1Nn4aDnZPlyBsNDq
         9+Gl5X6fbwsHE8RcXSYilj1eoY++5kNRmvajl4Nv8lgA/GISb5zSgccJImvFWDbEvDnk
         CLG7cFMmM+Da03RVd7auxgNd78KB8KmAfHxYiHs6HbcokWFrVaWkBLXxPgc45ugNTEtw
         uQ8g==
X-Gm-Message-State: AFq9FYJdfx8RBUPLAnpjg3Eh2sM/0ELgg6zqGdq9hl6DXwek0HnM3deB
	CN4I0nB9B3uidSEmiZie43+hqVR3UOLxwh71o8F1zDqWRhGNjleG+i28CbmFJwn4ZA==
X-Gm-Gg: AYBFou1llwhrNVL8J4GaYGFYlH5exVJT3clakJ7ihixedxOnEvQllWxcctB1F/32DwH
	wbnZluO6QbXufF4oS6apburf0q1eE9VSGS6CzzwiGo5q2XFn8hONkqpV8mZySxLlYxIXtZJPpHx
	Vd801Z7kPlBjyt2mMFakGeLSsxl64Z1fvWsUqaAoX/pmdKfl5kUiZIzD0bHKO0Pe+rkCet4of/E
	zfaoOst2TmmXiEoV5PrajNUjAqI1l028xGFrNwQAQSFqiX5qJpRCXqAIq09Qf1aXY3JJZwnPtOF
	2H+F+KNMAvaQHf9qy2GsIymgf6QIzzJCZUa/boZAYXLbJdMUdGXWhcwtwzVpRvv23EnHKN/yHAm
	m/RdjHY5ZZov2PjDnfbH5fXtFREojdG+jMgZyL9PsLXfkW449NwOd3ax+WYfx3378kI81hSKH2+
	OetXSK3I+KXJNPUZcLWb8iw8W5pouzg1QFZMNPzynWluNXiPod3yLhwluYlhId10UT6UpGj4d1Y
	5a8U/islXUqkKusgxaczY74lLgaNdOOflqD2jcuIAUXna4AxeZYcp/Pi4SGx9rOzN8zft8JI2aq
	sf3m0CWvH4n8pxbzmH8EbwzNmJmx/WCExlTY2Kz101kYA5ZD7HKIdhAmzo7WQjabM2wSADWsY6R
	eqK+mD7E6Nw/dayACAf4bCV8P/HUh8DMHbm6BYiIBC0G6Y1Wj0csymuJMFmuTwlxsnlQDiDO5gQ
	VV4sOE9hCf
X-Received: by 2002:a17:907:3e05:b0:c29:7953:6c06 with SMTP id a640c23a62f3a-c41a04f115emr341294666b.49.1792345764353;
        Sun, 18 Oct 2026 10:49:24 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:23 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tamizh.raja@oss.qualcomm.com,
	jtornosm@redhat.com,
	baochen.qiang@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	sriram.ramachandran@oss.qualcomm.com,
	yaojiale02@163.com,
	quic_pradeepc@quicinc.com,
	kvalo@kernel.org,
	sven@narfation.org,
	john@phrozen.org,
	toke@toke.dk
Subject: [PATCH ath-next v5 8/9] wifi: ath11k: stop a scheduling round when the hardware refuses a frame
Date: Sun, 18 Oct 2026 19:49:03 +0200
Message-ID: <20261018174904.1757161-9-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018174904.1757161-1-julius@bairaktaris.de>
References: <20261018174904.1757161-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_dp_tx() returns -ENOSPC when the MSDU idr is full and -ENOMEM
when no TCL descriptor is free or a DMA mapping fails; it frees the
frame, and the round then dequeues and frees the next frame of the same
flow. End the round on those errors and on -ENOSPC from a full
management queue, leaving the frames behind queued; other errors concern
only the frame. A category whose round ended this way or on a full TCL
ring may have nothing in flight, so mark it and start its round from the
next tx completion on the device.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.h  |  2 ++
 drivers/net/wireless/ath/ath11k/dp_tx.c | 10 ++++++++-
 drivers/net/wireless/ath/ath11k/mac.c   | 30 +++++++++++++++++++------
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 40895d276de5f..8b7bfb0cefcf2 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -713,6 +713,8 @@ struct ath11k {
 	 * other contexts that drive it
 	 */
 	spinlock_t txq_lock[IEEE80211_NUM_ACS];
+	/* access categories whose round ended for lack of room */
+	unsigned long txq_starved;
 
 	struct list_head arvifs;
 	/* should never be NULL; needed for regular htt rx */
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 5bcdeeb7e65ad..fb6a43dc45b81 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -776,8 +776,16 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	/* A completion returns the airtime the frame was charged, which is
 	 * what an airtime-limited station in that access category is waiting
 	 * on. The arrivals that would otherwise start a round are themselves
-	 * queued behind that limit.
+	 * queued behind that limit. It also frees the ring space and MSDU ids
+	 * that a round ended early on any radio is waiting on.
 	 */
+	for (i = 0; i < ab->num_radios; i++) {
+		ar = ab->pdevs[i].ar;
+		if (unlikely(READ_ONCE(ar->txq_starved)))
+			push |= xchg(&ar->txq_starved, 0) <<
+				(i * IEEE80211_NUM_ACS);
+	}
+
 	for_each_set_bit(i, &push, ab->num_radios * IEEE80211_NUM_ACS)
 		ath11k_mac_tx_push_pending(ab->pdevs[i / IEEE80211_NUM_ACS].ar,
 					   i % IEEE80211_NUM_ACS);
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index d17f80cbcdb5d..6b9cc54a7f5cb 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6519,9 +6519,9 @@ static int ath11k_mac_mgmt_tx(struct ath11k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
-			     struct ieee80211_tx_control *control,
-			     struct sk_buff *skb)
+static int ath11k_mac_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB(skb);
 	struct ath11k *ar = hw->priv;
@@ -6553,7 +6553,7 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 				    ret);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
-		return;
+		return ret;
 	}
 
 	if (control->sta)
@@ -6564,6 +6564,15 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 		ath11k_warn(ar->ab, "failed to transmit frame %d\n", ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
+
+	return ret;
+}
+
+static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_control *control,
+			     struct sk_buff *skb)
+{
+	ath11k_mac_tx(hw, control, skb);
 }
 
 void ath11k_mac_drain_tx(struct ath11k *ar)
@@ -10090,6 +10099,7 @@ static int ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
 	struct sk_buff *skb;
 	u32 ring_selector;
 	int num_free;
+	int ret;
 	u8 ring_id;
 
 	ring_selector = ar->ab->hw_params.hw_ops->get_ring_selector(txq->ac);
@@ -10099,7 +10109,8 @@ static int ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
 
 	/* ieee80211_tx_dequeue() applies the airtime queue limit, so a
 	 * selection ends where that limit binds or the queue empties. A full
-	 * TCL ring ends the whole round.
+	 * TCL ring ends the whole round, and so does a frame the hardware
+	 * refuses.
 	 */
 	while (1) {
 		if (unlikely(test_bit(ATH11K_FLAG_CRASH_FLUSH,
@@ -10123,9 +10134,12 @@ static int ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
 			break;
 		}
 
-		ath11k_mac_op_tx(hw, &control, skb);
+		ret = ath11k_mac_tx(hw, &control, skb);
 
 		spin_unlock_bh(&tx_ring->wake_tx_lock);
+
+		if (unlikely(ret == -ENOSPC || ret == -ENOMEM))
+			return ret;
 	}
 
 	return 0;
@@ -10143,8 +10157,10 @@ static void ath11k_mac_schedule_txq(struct ath11k *ar, u8 ac)
 		int ret = ath11k_mac_tx_push_txq(ar, txq);
 
 		ieee80211_return_txq(hw, txq, false);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			set_bit(ac, &ar->txq_starved);
 			break;
+		}
 	}
 	ieee80211_txq_schedule_end(hw, ac);
 
-- 
2.53.0

