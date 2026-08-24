Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A102743E07A
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581479; cv=none; b=OJfUQyKUe0i7dLpuBRgJ956FiZ+zBFGV9goJPf1cQfmbYNlDzVhxHNQakyMx0AavaSjOXhmjPFVCcPqzYfKIo+3VPmF6+9/BgXTu2u6OzoRqC1kKpc2Z93qE97nno4N15lR9cR9rFVGJSaMXXv74ZTAXdKBLHRuHaudxkxvr7rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581479; c=relaxed/simple;
	bh=yKBxfIvqmTFV9KFIz24PawDAZW0RtOJmtLbhFdpR+zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1+uj77krWCpXCqQa0OX60KDKu/slFSO473rVq7n0ipPHo8wfwbuccuxf3o9Wnb/8tNlelAsrV5db7N75z+yn6c9v8R5TclluDdhUUeT9ij7MQweIRAx0GEnFkOdgUwjd+H7Q5wFMl0twaNzrQjW55zLmJIpBP7pypIXZm6wT+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Ckd6yJw+; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Ckd6yJw+"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c197e7e4e94so630925266b.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581475; x=1788186275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NrM2RZiWM8sldUeyTNqlmxOQd471ZY1V4UxOl51GWtY=;
        b=Ckd6yJw+xlM5aI2/dV7VkEW0dCzoGb1WNdKyDr6l+5+yGIV5TPK41UwDif3sZALE0x
         YA24TBJMewV64SBWwuR5VfkcKXTYlAvq9HQF1+1aH6tO0Rm6TcvYZIuw2QaRr/Gd/heY
         ZYX4FTdsLiqQ2eyUvaMgL2yhiGxdbZ2hD3aW9AZkMnpYdqTXShnLdB+MsBue65LcV0An
         sSazVWcW+QFaxT+sD7k+HCZzElMNgUvoSz4VEEPhvvf1KxyQI2A8fVbfIMcrK/oO9+lb
         9sWGrEV6pU7EBkjZfHqYPSX5kz8gtzKN8tD3lLKFVuKEbSa8UEnmY9iFPUaaidt+J7Bz
         yOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581475; x=1788186275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NrM2RZiWM8sldUeyTNqlmxOQd471ZY1V4UxOl51GWtY=;
        b=Uen3nSfbRAoMb/Rb1C61M7tN1XSndYBGTEnS6VN8TjSFENEL4fqJYEqpOq4nc4rrHb
         DVAgM/qHD2r3BvET4Y+oZJk6Ni2XsxSP/nXCLTNRkDcHIgMb+mD/T5aRS7uS3h5k/9FS
         hM4jxhHSmU5hFiil1WxtAr3SeToufSnnTL4FcIJiH7fH+8Wrgy5A4ANeZ8dWhKhr1CQo
         pQgMD2DWtsgdcyNhghulBHgS38BLxDJL2F3Tm/oL6NWG/q1Sc11oR9j3wD4qDxeQns8B
         YM3sMRZPy2AXmPlsqTC+/39psxm5wcHATM8PCTcINf+RJBd3L9UgWKQt+QN9ecuDQbGk
         GZBA==
X-Gm-Message-State: AFuF++k91zpcPCrLob3T8hM3PK7EZ+Idwr4xMD2I9TmJj71808Rq8pPf
	7ksppfujFz2aJPmK7v8rnHXhYy0DdJJtBXYidQ1EGUrkD7JuTysagy5plAkAr9dgdg==
X-Gm-Gg: AR+sD13WAevv5J1ekEoShBh1W+j7fheFt6V89UWRH1ytHcQJHxtiSq1K0BKA4tXqrrP
	ACYrAn2RAkdI2umbJblvcMHoJjBzaUBjGbJp3qZKKFDyudBg2TXQxwit4bVTOjwZUztr4KbJZ1E
	esmoO+BtEBHdAEhmVMgNgkziQtuXPnJS2NRb1We1G/4vShA4EXf2o1f7gGRHVJ9teKL2zvVNWuq
	RQzh0jFUlC0CkyXqyII3CVOSngJkBtca+JBy9ZV7A1wY7hKuo3K0vrlsd2Tr4iYj3TjDzG3s6SZ
	j/gxAUb2MszdYdAOVBngrDvM3Oh1s3cUgUaNhWwDOgnSXsW/QPZBUbSkK70PZFn9+OLbM//s41l
	hAKrnAZmqDECWFm90RpJOFPNnj9b10E7krSdmpTmUcoMCu8sfuvH3ERV/HY163ERJogLZzzLb4/
	aGaZfxs5eh9Ojz+D4cHq5/4ZYlHcoeEdF8xS8TdoQZjKJhUFNEO9gSgX2+6s0SagpNbqmyI98fF
	dUBKZ93orASuIgyuACvh2vqjGKPB3aNeKbmeaglxlBbrLfafoo+fG0u7F6WXmc30js7d4lwhvzW
	ztLCT6OpO5s+WkE8nvTdgi2gDXgLKQjyABnREJWl32aCSEWR1RxIp3bsBcLxWiVshzYZrMiT/BK
	S1O4kK0YYzCUie/oBsx/DuLn7mubeQwFcMWJsflQ9B9ZOkH5pc+QgvdEHUbn5EDtDeHT6UGPcAj
	Zqx81ytZlS
X-Received: by 2002:a17:907:930a:b0:c24:680b:3944 with SMTP id a640c23a62f3a-c24925e416dmr1935275666b.13.1787581474570;
        Mon, 24 Aug 2026 07:24:34 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:34 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 9/9] wifi: ath11k: budget the tx completion handler
Date: Mon, 24 Aug 2026 16:23:50 +0200
Message-ID: <20260824142350.1757379-10-julius@bairaktaris.de>
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

ath11k_dp_service_srng() calls ath11k_dp_tx_completion_handler() without a
budget and discards its result, while every receive block below it takes
the NAPI budget as a bound and reports what it consumed. The handler
drains the whole software status FIFO, which holds one entry short of the
32768-entry release ring, and each entry costs a DMA unmap, an idr
removal, a peer lookup under the base lock and a call into
ieee80211_tx_status_ext(). One poll can therefore run for as long as the
hardware has completions to report, with the receive rings behind it
waiting, and the scheduling round the handler now ends with adds to that.

Bound the drain by the budget it is given and account for it the way the
receive blocks do. No new constant is introduced: the bound is the
NAPI weight the poll already carries, so a poll that spends it on
completions returns and is rescheduled rather than running on.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp.c    | 10 ++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.c | 11 +++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.h |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index f389b97acbdd..676440ee742a 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -781,8 +781,14 @@ int ath11k_dp_service_srng(struct ath11k_base *ab,
 
 	for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
 		if (BIT(ab->hw_params.hal_params->tcl2wbm_rbm_map[i].wbm_ring_num) &
-		    ab->hw_params.ring_mask->tx[grp_id])
-			ath11k_dp_tx_completion_handler(ab, i);
+		    ab->hw_params.ring_mask->tx[grp_id]) {
+			work_done =
+				ath11k_dp_tx_completion_handler(ab, i, budget);
+			budget -= work_done;
+			tot_work_done += work_done;
+			if (budget <= 0)
+				goto done;
+		}
 	}
 
 	if (ab->hw_params.ring_mask->rx_err[grp_id]) {
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index e706ba1077eb..b309a97d6ad2 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -685,7 +685,8 @@ static inline void ath11k_dp_tx_status_parse(struct ath11k_base *ab,
 		ts->rate_stats = 0;
 }
 
-void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
+int ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id,
+				    int budget)
 {
 	struct ath11k *ar;
 	struct ath11k_dp *dp = &ab->dp;
@@ -695,6 +696,7 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	struct hal_tx_status ts = {};
 	struct dp_tx_ring *tx_ring = &dp->tx_ring[ring_id];
 	unsigned long push = 0;
+	int done = 0;
 	u32 *desc;
 	u32 msdu_id;
 	u8 mac_id, i;
@@ -723,10 +725,13 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 
 	spin_unlock_bh(&status_ring->lock);
 
-	while (ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail) != tx_ring->tx_status_head) {
+	while (done < budget &&
+	       ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail) !=
+	       tx_ring->tx_status_head) {
 		struct hal_wbm_release_ring *tx_status;
 		u32 desc_id;
 
+		done++;
 		tx_ring->tx_status_tail =
 			ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail);
 		tx_status = &tx_ring->tx_status[tx_ring->tx_status_tail];
@@ -772,6 +777,8 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	 */
 	for_each_set_bit(i, &push, ab->num_radios)
 		ath11k_mac_tx_push_pending(ab->pdevs[i].ar);
+
+	return done;
 }
 
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.h b/drivers/net/wireless/ath/ath11k/dp_tx.h
index 9303b5ba6e01..b5296cda73e3 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.h
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.h
@@ -21,7 +21,8 @@ void ath11k_dp_tx_update_txcompl(struct ath11k *ar, struct hal_tx_status *ts);
 int ath11k_dp_tx_htt_h2t_ver_req_msg(struct ath11k_base *ab);
 int ath11k_dp_tx(struct ath11k *ar, struct ath11k_vif *arvif,
 		 struct ath11k_sta *arsta, struct sk_buff *skb);
-void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id);
+int ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id,
+				    int budget);
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
 			      enum hal_reo_cmd_type type,
 			      struct ath11k_hal_reo_cmd *cmd,
-- 
2.53.0

