Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB5343BDA1
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581477; cv=none; b=YbV40IWmay0yHKvsZfKJlgETa+tbUL6zqHuc4EQBX/ENcXllCPYBMhD6/2S0hCFdapjgVDmrCJ69XBn7ofo6HLMkiRlFlHza0Q8i/r+UGj5FL+maChDKAcRGsuvUnWsipiwof/U6otdZZF/VVA/e61GPSMsLS4GS5iEBCXIK6uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581477; c=relaxed/simple;
	bh=YN6Koz+u9VujQLvhAZxVbZHkNBDhoWuJgZ7WalFj2hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAFZEH78tcM15eDoy+vjo8yFxwRi3Yf/ZDb2m4LBPEx/UJeYr4VQ2Ay/CUYAS17S8TWplMzzBSUjrf/CqnVLe2icwwZnx2fEfD/lxNOjTEozHgppKpKmEgHT9AmxDF65CwyqjbsdRWcBwhqFzq0+qVVkbLGPeg7qL9SCxC3tWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=lahSE0ni; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="lahSE0ni"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a157f90752so5981957a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581473; x=1788186273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TEHKshZ50VF+vld2tceM1/dTFTvHUFhobWJ0AfZzzco=;
        b=lahSE0niRdUINgeY5Te7RLS0fCybUrgmVBFQ7a6iYa5YLVLlolmWD2kSxcRCT3xdpW
         v4LnsypTHCGuRPKjo3zvFJD3Wuh1y8kbretgCGg3lpGk4+0D17KS1bRIbwA5tpw+4xbX
         rFojiKC06ra/qjo5+fLh6o4oagZxsN/iNmB9FsLUakOR2rjhXaa45zFNVKdc0BVf5Ndb
         +72EosDIuCfP6EY+aHtRVSuJoW4yG9Su+d54+inq+iilmxpQmz3Joe9IqKFiSWwtn1rm
         BaJN+BceIjEos9FWsI/G2zAtxRtZ0M1c+WdPM0dslgoMgp9Y3ar9zalVhHU1qCTTpD0i
         1JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581473; x=1788186273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TEHKshZ50VF+vld2tceM1/dTFTvHUFhobWJ0AfZzzco=;
        b=q3gx6EkPxYlfrzo1/o5PXHm7FSW18noe/vBDPPtthVKpateUCRmqbg/UnaH58a8dsg
         r/epoXracwX3xy8FKcAlOPMjlaRoFKMg7lQzRx5WCHI1gNy6HINIKkoBtwkPQRQBWgV1
         SEXr1ODTpNem3dFnVb2EnUsJIf1Cdu2GDU0ikqh6iaaFBAk5xNO3KtelYoGgY+I0nq4Y
         YuqslE+TPbCD4oROgREp86jLa0zxzsovdZKn1urqw6/noY0SZ/8FiRuPyiP+yDBTrXuA
         +QADTo0SU/UssfphGs7Gh8E9bojp6TPFGQyJ941OTuiUjhrh964JezeyGF96ZVpyoy73
         HNwQ==
X-Gm-Message-State: AFuF++mTl1AMesBMOgEu8HTY/B1PSzaidCGWodYtzzUx4tbjI81zM0R1
	V9dJkEVR5z+K25Y2ueJAjW4NtYnfcf+uiCMLn66EbBlZaQX4Pz4vTWbj6BvkgYo0fw==
X-Gm-Gg: AR+sD11mng5po7WSzSvHVj+NNyKi+1t+Krjr3h7FnAp+HXPYmARjrNUqKFr/mswAkXQ
	glNGZHLP7LH0Wa8Vhv9N/x4TNQH3uSbIdEAUnSpecMlXVm/bp+dSQAOnoWYyzCUAvjLZ63DjwQs
	HnwpDNz87yJHhigvNEI7wKcSWpY9EdGZEKEfW+L6Je52mQvrVNOHB2sciw1WoZ8lN5QWoTgKC24
	UPk0wd8xA/nFKZTaOWmavfpMPHtQboT9SXO3YyXadLCsXu1Kwo/cNmI/r56x8gsnwu8zWpJP0q3
	vChbiUaGRCgjWECW4M0GWj6XkXc8+xM7N2VbPsp/JUdVQ68VKxaZq1mA5ptH4SvobIFdZ5G780Q
	bxhAOIw5ocUMDU9UzdCGBrJ3d42lzZG5Enu06HQhPRQ4Vc+LoBG7XY67AKdV3JS76qhFsmTb19x
	yRcZDP8SpXHWF0fONH1/hOabw01n22k903PSLI9TDc4Mo/x3pZoftGQiXP6Hr8aS20Dvln2Nbr0
	QHnt3RdqMF8E9yRXNlIEGqwdteljQ+hZS5O+1jimBVi+qQGaBk3cVIavXfs8rbTbmHIJ+hqDs9X
	EapdIa6Mtd6M5AimRAiINlpFNhJ9oztvhB8rtHU/UxZRHGwhYSigquxUNJ6yN1UcLgvvPyu0JjK
	2Ad8UIcbyQt+nOGZl/xKdq34BjB2A5f4dwRvyR/CRqvCyE/LXsjLcb4jxQWQM5y/Nm8GSBpsZpq
	UutqhVE3U=
X-Received: by 2002:a17:907:c706:b0:c20:f913:9337 with SMTP id a640c23a62f3a-c246a657f9fmr3239680366b.20.1787581471726;
        Mon, 24 Aug 2026 07:24:31 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:31 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 5/9] wifi: ath11k: schedule TXQs from the driver
Date: Mon, 24 Aug 2026 16:23:46 +0200
Message-ID: <20260824142350.1757379-6-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824142350.1757379-1-julius@bairaktaris.de>
References: <20260824142350.1757379-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_handle_wake_tx_queue() has exactly one entry point, the
wake_tx_queue callback, so a round starts only where mac80211 calls that
callback: a frame arriving from the network stack, a block ack session
starting or stopping, a station leaving powersave, or a stopped hardware
queue restarting. Every round runs under
local->handle_wake_tx_queue_lock, which is shared by all four access
categories of the hardware.

That is the wrong shape for a driver whose only backpressure is the
airtime queue limit. When ieee80211_txq_airtime_check() refuses a
station, ieee80211_tx_dequeue() stops handing out frames and the
station's intermediate queue keeps its backlog until the next enqueue,
not until the airtime it is waiting on comes back from the hardware.
Returning that airtime does not reschedule anything.

Open-code the round in the driver so that a second context can drive it.
The walk is the same deficit round-robin over the active TXQs of one
access category that the generic handler performs. A selection ends
where the airtime queue limit binds, because ieee80211_tx_dequeue()
applies the limit itself, and drains the station's queue where it does
not, which is what the generic handler does today.

mac80211 documents that a driver must not run concurrent scheduling rounds,
and the next patch adds a second context that starts one. The round
therefore takes a per-category lock rather than the hardware-wide one.
ath10k and mt76 also drive the round from the driver; ath10k takes its
per-category lock on the wake path alone, and mt76 serialises instead by
running its rounds from one per-device tx worker.

A custom .wake_tx_queue with a tx-completion driven push was proposed for
ath11k once before [1]; the design was right and the measurement that
justifies it is in this series.

Link: https://lore.kernel.org/all/20230501130725.7171-1-quic_tamizhr@quicinc.com/ [1]

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.h |  5 +++
 drivers/net/wireless/ath/ath11k/mac.c  | 44 ++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

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
index 40a2b6d2f804..342b38308468 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6546,6 +6546,43 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
+static void ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
+{
+	struct ieee80211_tx_control control = { .sta = txq->sta };
+	struct sk_buff *skb;
+
+	/* ieee80211_tx_dequeue() applies the airtime queue limit itself, so a
+	 * selection ends where that limit binds, where the hardware queue is
+	 * stopped, or when the queue empties, as the generic handler does
+	 * today.
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
@@ -10067,7 +10104,7 @@ static int ath11k_mac_op_sta_state(struct ieee80211_hw *hw,
 
 static const struct ieee80211_ops ath11k_ops = {
 	.tx				= ath11k_mac_op_tx,
-	.wake_tx_queue			= ieee80211_handle_wake_tx_queue,
+	.wake_tx_queue			= ath11k_mac_op_wake_tx_queue,
 	.start                          = ath11k_mac_op_start,
 	.stop                           = ath11k_mac_op_stop,
 	.reconfig_complete              = ath11k_mac_op_reconfig_complete,
@@ -10757,7 +10794,7 @@ int ath11k_mac_allocate(struct ath11k_base *ab)
 	struct ath11k *ar;
 	struct ath11k_pdev *pdev;
 	int ret;
-	int i;
+	int i, j;
 
 	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
 		return 0;
@@ -10791,6 +10828,9 @@ int ath11k_mac_allocate(struct ath11k_base *ab)
 
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

