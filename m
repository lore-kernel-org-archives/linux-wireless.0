Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97884C10DC
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345769; cv=none; b=NQKoUCeVhFIXfk+cbGAVqUr3Ps+rqXfzXjKpznsIDwNRYIgXFWbNNZZsqgi7XQgaMM+ms6VhS4EtPT6VtH5Yv1sMF7QEHRkT1XV5ZfYzlfqCaZ2/wxvx2cxKqGMywp93V8nieiugVHVcgm3tlqYXpsHXnAVAumG/DF9Zp4zvxj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345769; c=relaxed/simple;
	bh=7+zNweFbT1Pd/GaWVvRG3+Ssucb7+gUwPPVaWdMO6aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj/Sq28QX2EukDGmDJ7eM+TRNjb49zK9dKIU7j1q5f9u0vuYbn5MgQM23rQfSTb9L3qrX7ofaao2j8IbPResbYpKIKjPAHds9gCp9hxvWjVzrSqInUKRXLgLfeqJvg+8hsmB9HBK2PxOS/ri61VK2dcIMryg6DA8Nfrou/AoVTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Qw/tOHUq; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Qw/tOHUq"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c423b145922so93152166b.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345766; x=1792950566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mFNtCzvI7gSFb77nFbMde1Lkd9uPbYBLVilPT+Ceo8U=;
        b=Qw/tOHUqzf8GAGviqX48bJ06RhS9A9FLehPQcJTSpYeyfLKVIkXhzlyw00EnF6S88E
         VH6r9th+LjPBoNsF/Kma3yteLZ10B4izXOpfzsDkR6Lx0/IB9VBg/G+1EDa8+zLVgrzU
         4OExZ17zyQcj8zqD/XtRPuk9kM4C4BP8BhikVs6yyE9oLRJ7EYz0eCymWVBW6NhoPovr
         LSnTf7hp3PlbXo6OZRKRXi4l5vXbG2ljgVsET/IvYC936rzJ8ZRnx7WzQvKIaFrz5WFB
         r6pUvw+nGIHPM1VpggrDXNBUQUu14gwkmnXYRgfK/H+Fw6fGpjK0/4WGOf54C+eUWUIo
         ulNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345766; x=1792950566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mFNtCzvI7gSFb77nFbMde1Lkd9uPbYBLVilPT+Ceo8U=;
        b=Cs6wFzdr+8q1C5aXSgmYwdod03ecCq+aQC/0oM1IYtReIL4FMH9fDkAgyF7cJmDDt2
         SddCasP675bOBASYiMlz/0lp8/T9CQvNz2bFM59aTSp4auNNbS8zR6uuGYkhXDs1/lg7
         AWgAreeqzvVMFxiIuUFeSuEK47Aa3vMgGVSgAW/ej7mtXVDz2MpJ+pqMpG8NCVdiEGCg
         7cPjbe0f7sccUmOlFAzArAwEl4mwGa0r0IGLS9WgZkd8CtDaLAjtSGlfPDtZ0nEeh9mj
         M/3shkBvboeIT2cPopiTogIfIqyd/l5f+QbYy2tugg/jDlMbNyyP5UzL9PhF7XFVuIZu
         6oHA==
X-Gm-Message-State: AFq9FYLWjBRxAgLZBaB+DaVs+6wDBJvPashnbgCfkMkRF6hRZ6vHIGj/
	cq7g1XyGIuFZ1GLkJYkhai7OMKo3T/ehi/e6puietsLmqDeTDUPfGjHk3PpXTL1zrQ==
X-Gm-Gg: AYBFou0TxX8PIkEfzjQVDdur8KXOQTMVF6f6ZGb28S6x4g/ZHNN04DYsyJ7zwdQLpb+
	ibjqorQ9+F9Fvppi8al1ZpAqnWtkfXmJqMo4MUXvQT2CY7bYcbfEG/LRVJNg/kdF+UppPjm53ZI
	FMRWUba+pK2B6Mu34wesp9p7rDakpB21mQT+2ueIJMsh3hLmtbTr6CUEW/xHp0Yfx3jIdYbDbYc
	GbQrEeqA1Y2IE8Nw1j7mhHthxTmm8IsUvcAWCxiaLW99JyakuZmGd93Z/7MBs8I7V8PG7niozLd
	VsPUuqJ2COGzvPU+AKlWGcgFPOj5PIg1dY7bIMYeid4CCek15XS7zZvtITJsV2MzelSLr9MTyul
	wjD3HNJYb9d0gGBv0KEorDpxLD33dc1i6ekpx3aMtraLdYfDPQNG9gqqMj1S/I/ioZhVA7kfHoq
	A3Y9Bc+vlziXb6vWAcXKrP7EbRIz1EokVumf1DmhO0c40YhbixzxSWQ2jSqtV+z7P3o+SiA+VX0
	q6YkpdD0jbdsjKvxdrVbAzHQx1DLDRAICEni96znC7avuGBANJv7m0zcqDQFIToVdgBiwXQVYdE
	qowiL2soBQ/YzmPSRWdqNusKRmn7k4RbIJpAnV9DBwc1Bd3fh5Aht6zwcFARt7Q4jd7PFZxJcCL
	KvUvYJQijXWf4CtJKu6OpZDdZluXPVfMYkTc7pYF3NedMozTppFHXgSLp8nhnvDQJNparwFbK+k
	lsofxBJCJN
X-Received: by 2002:a17:906:99c4:b0:c2d:bd87:7fa7 with SMTP id a640c23a62f3a-c419e639f31mr345776866b.24.1792345765950;
        Sun, 18 Oct 2026 10:49:25 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:25 -0700 (PDT)
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
Subject: [PATCH ath-next v5 9/9] wifi: ath11k: budget the tx completion handler
Date: Sun, 18 Oct 2026 19:49:04 +0200
Message-ID: <20261018174904.1757161-10-julius@bairaktaris.de>
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

ath11k_dp_tx_completion_handler() reaps the whole release ring, and
ath11k_dp_service_srng() charges none of it against the NAPI budget,
unlike the receive handlers. Since the handler now ends in a scheduling
round, a full ring gets one round for all of it. Reap at most the budget
per poll and return the count, so a round runs once per budget of
completions; NAPI polls again at once for the rest.

BE aql_txq_limit 500/1000 us, three interleaved runs per arm: both arms
reach 94.4 to 94.8 Mbit/s, and the sender retransmits 4, 6 and 8
segments with this patch against 8, 644 and 296 without.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp.c    | 10 ++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.c | 11 +++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.h |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 3e0a6bdfa0505..5775ad4269393 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -783,8 +783,14 @@ int ath11k_dp_service_srng(struct ath11k_base *ab,
 
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
index fb6a43dc45b81..13c464dce2943 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -692,7 +692,8 @@ static inline void ath11k_dp_tx_status_parse(struct ath11k_base *ab,
 		ts->rate_stats = 0;
 }
 
-void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
+int ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id,
+				    int budget)
 {
 	struct ath11k *ar;
 	struct ath11k_dp *dp = &ab->dp;
@@ -702,6 +703,7 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	struct hal_tx_status ts = {};
 	struct dp_tx_ring *tx_ring = &dp->tx_ring[ring_id];
 	unsigned long push = 0;
+	int done = 0;
 	u32 *desc;
 	u32 msdu_id;
 	u8 mac_id, i;
@@ -730,10 +732,13 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 
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
@@ -789,6 +794,8 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	for_each_set_bit(i, &push, ab->num_radios * IEEE80211_NUM_ACS)
 		ath11k_mac_tx_push_pending(ab->pdevs[i / IEEE80211_NUM_ACS].ar,
 					   i % IEEE80211_NUM_ACS);
+
+	return done;
 }
 
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.h b/drivers/net/wireless/ath/ath11k/dp_tx.h
index 9303b5ba6e012..b5296cda73e30 100644
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

