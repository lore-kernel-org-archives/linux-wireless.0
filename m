Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75F23EDACD
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875622; cv=none; b=mYcVegvjWz+1J9dQrszfIyhi76Dt8b6AKVqaiLLaOoppFFOOMCdQkICfBhT9EqNXfjgppFK2NdSuLeyKkl8MijhAmEphbU7TnFThtr5k3PUu4X4cII6qKWTxExE6yxN6BK+jsscKXdCcE1rRIfEtUJiPegBIsUiGNkoeOu0pv1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875622; c=relaxed/simple;
	bh=oxu2BrFXMHQ7tCtzImP6ujIrHiCOhiw6t/tTEFwjPQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2vY01gwWrayxGlxR7cZuyFlYtc6PTWO5CS6B6Bk8lMCan8oSs4pV7bzEM2l2gtMEWL+52qW6DG2c70jqjyp5idE2sLEOdBeNe1tQEmuW5s2bJE/9rZrZiUcD57Ihanqe5y72CScm6Z6Ndk2qBGPBzs9p0aSUXl9vdLiD67iXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=XVtz0xtG; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="XVtz0xtG"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c20e70a0962so592900766b.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875605; x=1789480405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RPdLShOxqlTto6fsSHI/vFszQMvhlliVKlymqNv97DI=;
        b=XVtz0xtGbzG3gzP1Ua/pJtpYhh+aNGUWKZtUaZddiqORYs5saqU0icjQwxrjLBd+ck
         ylX2R3xkm5UNAOglJgEOw9jLn74eVCFDhmD4est61jcUiqDHXMMbWlX0uqcxIvOp92sv
         dGCd4/tnvAkLDzDjUhcpT6vTHzrXvyf+hpGbPGOaLm+Y6kjCNlU23XRl9POUW1Qkt7Lc
         MhcYE25JjDT9/Y+ZL0DXhdBF4LskbrWPE4/tlXIpeGVVo2uxmEkb8/t8IpejSlFIaKzt
         QPZ7OukF4F1olviWf0N38eiBki2ffh3fpC4L1g+mxcJManFVcKTaGDByTA+TfnCbDcWE
         bxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875605; x=1789480405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RPdLShOxqlTto6fsSHI/vFszQMvhlliVKlymqNv97DI=;
        b=sAirrTQDAHV3O31nIQJJ2HpCt4S/iTyjtY3ws+Q9oMeNZnpB4ymMZ7CsqmbWIaatjE
         bL8Be5Q9I5Yrr/gW7qrQ6KJ6Drm6nb4q77vARy9p7gmBVyXOj53ZroLGcOa3y6lWXmYV
         sBiinDpyU6SHfbtMZiqi/1XuzlXWCUJwiQykU/WzBQDhqmRIQT5DNJvtIcJ5r7IROxYW
         ZtYJCNYFaaJbWrlYbIsdL8YU8XOr9aU9otBi3UK+9c9yyigKUDjzXVn6Jr9tI9ebCzGa
         WdxluqBnCFzMK9BPdq33gg1aAjNfFCKW3pIC4bmM0ilI45HN9UqvItjqfPII1MqV0OUt
         JQzw==
X-Gm-Message-State: AFuF++mdR6jkKIDMxFoUSUkVp8bww6dyI4j7l5Sr5EuCbgDR58awEvqH
	8uCnCvR/5UBgRgPc+rYWw9jyeILefKN2tJNRa/Q9s/IOyQq2sKdsNYO2GFVrQSJuwA==
X-Gm-Gg: AYBFou3Okc53FuUiUs6UI7rkOMKHKFv6sfea2oG+Lv2e10Yof/+Jmi4oqCpZBj7Jbi5
	srFuvC8eIGmJeef6q5I2223NGMgWGH7d+R0mtj43GGw/qKpU4Hzp1/AqKquWzRnfWzRRd3ilk3W
	F38FJJ4tavMxD0sfE4HxwT4tCT0Eowq0yqdOv+Kb6RN7ChHoq7UjQIRhIXsQtXpkHar9RmAZCrj
	BgC07nYJqGwOAzQybuUQgTi7o85zNzdvIQplKYSzjWxkfbODA8yHssw1ziZmN7MfK9dF6sLCvUI
	s5BOm1E/IW/d2Zc+HtSo1kX8O6RCIG3VsNNTYOISied6aHN82OpoLMil2NPuLvxfmIUdzY03iC2
	2dTew1rDftgDabDpLJKzhFrDXw3kUeJfLlGvzNAGcQ2K4Rg4vaMdCiy3z4mfarXDkQ6D09EOFBf
	iHoez2N2HWLH8LH/OZQFUdv+qBnOU/za5LiW31lTONPQk2ce3lFPaMphE8UYYGA6ridhNb8rXbw
	mp7ZkLbz34hv/IY4CdGyNtpB2StN63igvAyBPfKgFqiAloEfeY0dlwL6u58IpQi+dSmXQheEem3
	47Z7zN5sOGjH17D1W2qPOs53PTuHq3xd8zCuNX01Iu+PT6lm2wJdQZPd0L4IW6PgX80+M/JzdCJ
	9FDmCVtDxBJYvrjplRczh7E5ALwx/dxBwOs5jd8K21snYJxlPQBOMTUQFj6vPvYbsYZOkp1XQS/
	lB+ALG7btkqTW3
X-Received: by 2002:a17:906:7308:b0:c20:9447:bd5e with SMTP id a640c23a62f3a-c260c8e77fcmr2400016266b.9.1788875604992;
        Tue, 08 Sep 2026 06:53:24 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:24 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 6/9] wifi: ath11k: run the TXQ scheduler on tx completion
Date: Tue,  8 Sep 2026 15:53:15 +0200
Message-ID: <20260908135319.754140-7-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908135319.754140-1-julius@bairaktaris.de>
References: <20260908135319.754140-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A station whose airtime queue limit is reached stops being served by
ieee80211_tx_dequeue(), and the airtime it is waiting on is only returned
when the hardware completes the frames already charged to it. ath11k starts
a scheduling round only where mac80211 calls the wake_tx_queue callback, so
once the limit binds, the backlog moves again only when one of those events
comes round: most often the next frame from the network stack. Under a
saturated download the arrivals keep the round running; a flow that has
just filled the intermediate queue, or one whose sender is waiting on the
acknowledgements behind that queue, stalls for as long as it takes the next
arrival to appear.

Start a round for each access category a reaped completion belonged to,
on that radio, at the point where the airtime has been returned. The
airtime queue limit then bounds a queue that is refilled as it drains,
rather than one that is refilled when the network stack happens to push.
The access category is the queue mapping mac80211 stamped on the frame.

Measured on an IPQ8074 AP with a TCP download forwarded from a wired
host to one 1x1 VHT80 station, BE aql_txq_limit 500/1000 us, 20 s runs,
three interleaved runs per arm, download rate and the RTT the sender's
TCP sees on that flow, mean and maximum:

                    Mbit/s               RTT mean ms   RTT max ms
  with this patch   100.8, 101.5, 100.6  27, 26, 26    32, 31, 32
  without            93.0,  99.1,  76.2  26, 27, 94    66, 36, 347

Without it the download moves only when the network stack pushes, and
a run in three stalls until the sender retransmits. At the default
limit, which binds on this flow as well, this patch reads 101 Mbit/s at
48 to 55 ms and the arm without it 80.7 to 101.1 Mbit/s at 54 to 79 ms.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 14 +++++++++++++-
 drivers/net/wireless/ath/ath11k/mac.c   |  7 +++++++
 drivers/net/wireless/ath/ath11k/mac.h   |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 52c4a9924a31..70d326fe6a1f 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -694,9 +694,10 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	struct sk_buff *msdu;
 	struct hal_tx_status ts = {};
 	struct dp_tx_ring *tx_ring = &dp->tx_ring[ring_id];
+	unsigned long push = 0;
 	u32 *desc;
 	u32 msdu_id;
-	u8 mac_id;
+	u8 mac_id, i;
 
 	spin_lock_bh(&status_ring->lock);
 
@@ -756,12 +757,23 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 		spin_unlock(&tx_ring->tx_idr_lock);
 
 		ar = ab->pdevs[mac_id].ar;
+		__set_bit(mac_id * IEEE80211_NUM_ACS + skb_get_queue_mapping(msdu),
+			  &push);
 
 		if (atomic_dec_and_test(&ar->dp.num_tx_pending))
 			wake_up(&ar->dp.tx_empty_waitq);
 
 		ath11k_dp_tx_complete_msdu(ar, msdu, &ts);
 	}
+
+	/* A completion returns the airtime the frame was charged, which is
+	 * what an airtime-limited station in that access category is waiting
+	 * on. The arrivals that would otherwise start a round are themselves
+	 * queued behind that limit.
+	 */
+	for_each_set_bit(i, &push, ab->num_radios * IEEE80211_NUM_ACS)
+		ath11k_mac_tx_push_pending(ab->pdevs[i / IEEE80211_NUM_ACS].ar,
+					   i % IEEE80211_NUM_ACS);
 }
 
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 342b38308468..ffb6b865c2df 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6583,6 +6583,13 @@ static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 	ath11k_mac_schedule_txq(hw->priv, txq->ac);
 }
 
+void ath11k_mac_tx_push_pending(struct ath11k *ar, u8 ac)
+{
+	rcu_read_lock();
+	ath11k_mac_schedule_txq(ar, ac);
+	rcu_read_unlock();
+}
+
 void ath11k_mac_drain_tx(struct ath11k *ar)
 {
 	/* make sure rcu-protected mac80211 tx path itself is drained */
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 59f83c7175fd..d577c5ca249c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -161,6 +161,7 @@ struct ath11k *ath11k_mac_get_ar_by_vdev_id(struct ath11k_base *ab, u32 vdev_id)
 struct ath11k *ath11k_mac_get_ar_by_pdev_id(struct ath11k_base *ab, u32 pdev_id);
 
 void ath11k_mac_drain_tx(struct ath11k *ar);
+void ath11k_mac_tx_push_pending(struct ath11k *ar, u8 ac);
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
 int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
 u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
-- 
2.53.0

