Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6100843C7DB
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581477; cv=none; b=t69YJqUn2FCrU86kofuIdAI5TNuK8EWpz2VVKnDT/tFFu+UlLa8uduPH5U8RAOeoFsUWnZh+dySktJ80nQw0rSLOs+VLmU2EXUjLPU8ZGaGo9vFVJ1iblgeZASh1hCP3TcXDDrpaaK4CsgwD3nN786zpbUprJBzlq9OWuP/3EtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581477; c=relaxed/simple;
	bh=TiUk/tasqKoFFi5Y1rsnE8znx96wYepL7S5EiQjZ0To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHfoVvvHM8iLwm12tUSNdGRmxEhv9OJL9YtEpa/qfxa74/Dn1qnGsxlLYuf/gckoB9MDMJ3dO8HvCJLddwNot+g0qwiwetQyMtQaQJbMk9V4daygmdScatli5aXJjay1GejeVjUa7TM6wMIAWrrea5t5SUrQSYSt+cUt8PFO3cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=wcke25Io; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="wcke25Io"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c20e70a0962so533762166b.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581473; x=1788186273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oY7bftUz/AICMv2zegq1aZcyBsBdoVDaK+uvy3SJacQ=;
        b=wcke25IoUUwMDzQc4wgO0Qr7jPk2bq5pQeJMIeWvZj4rYt7PXAOr07nbM6OzXXoYgk
         QSmXJbytKgn7mpJEHgOOuR4Esiih22xUXjsDkeEUtM2Hyxni7nWpwO7wS7yaBBLabudG
         SWWVjXS/AGeyG/+YMJT6OulpQag9Wn58olZ6xk2HUCC93eaqM9UbU4YxU8pPxeilwER5
         m3TYM6cm+kKl1YyPb+f5opzJLCWnW4INF3E8pcMP9x8PZQ3HZmhH4FlRPGgWPyqO1AvM
         zRPo9fWtAofbZRidmEcZp8sGnQ/B4EV9ANUpsTqi3bjHScHU4s9lKUo5OG1OArh/NKc2
         scbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581473; x=1788186273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oY7bftUz/AICMv2zegq1aZcyBsBdoVDaK+uvy3SJacQ=;
        b=Y4xxhS5M0QNFSB8CKL7WL6HZOW4B7SKNi1IvJZUWqFH7N+pcZ/UVvVo8uuL15gcMbC
         5bLMFKyde47WqTse8AV5/GfI3yCAShOnql9mrMQKZ0EsjcFdhutc30W/pun8u5bLuXGl
         iTUBEYBq1ey+ZS5tU+wrd0IGTxNfVSfpP8ykTzTEa2Lvy0c9RjDuX7OYvony/VKtRKGG
         VASBIYkL1aaTHzK5sj2WWnYT35O1bP3oSofoRlhqjUN7W+qIcbZH3S7+txlflYQB/d9/
         RocF4/v3V9dIAQuFV+djYvDN3FBF9FuGOtg2IKqO2apzPNrtWkK4FRQM2ZbcS6bWaPrw
         KwtA==
X-Gm-Message-State: AFuF++kUIDWkG4tcWnXF3PaSt3Novbj2NMoxp3cuNLmAo87+oTRUm3VD
	b6ISYg1HAoOUBjquePwgsV75EscfL80fLOiUchcFeenHBkopaf9/FVRXsQmJUvDlNA==
X-Gm-Gg: AR+sD13OPXrYnLnVWBmCF7nmPu8duFRnMWcCkVBv/xIrjoW/4Bxr5XfNF8cZVnDWSvD
	BcLp5p40XFCFRU4FkHOy+pRHsLE59MmDLSg25Yk3fw0xZpQR4AGAwSADRcwbX/XsupTZHvLr6+T
	pKukTiKEKkpLYjgeYvxxv9dLG1DlrVcFQzYVfculC01ElKWXeSEC7KMJOITrh1eVdr5m2UdZScC
	e90KrSP04raaBPnqD5pyeYyXuq5mPU0yqCayBnffNYA8yC1Dl3apFgjIjNTX7BG7BUlQJ225Bwu
	5trqmHkQ2cPm3qhWKWTEVCqQUC3iKGcO8LhS+M+tPqL1/ZwW6u328M48XjHU74BRHq+1F7PBCYK
	jkXxxmIyvQmK4lSmywRyfDW9osxJ+MCDYL3lF89kzpKYP4NWOlu1qjq0XcUIyeuH0S15iSFmSqv
	DAqByS8kzV1W/tSqzWcoS03xgBZOfN/BAOrBtpw5S8YnTtaKa0juQSZjamdAOpHVyvJIWUFgqKz
	bRLQml1FTzCWCV7GWBj6EAIEfxy6XAqpwa/BBrpWqR9p12z+OQG0BUhZ+otoW5J/pNMw2VSRK8A
	c3b1zNPA2iZjK/XMys4RR3cd12MtmEwlUmoItZGfApH8GJ0nDAdZrucJovB5ZxVAN9Os95yPmUJ
	QZohkhdTgDUauodyDhyMB0r4TAinvcIQP84kHZ0vHpFrV38RZofNdlYk7+Qiq5wBqmczsg6GR
X-Received: by 2002:a17:906:9f8e:b0:c19:5572:d234 with SMTP id a640c23a62f3a-c246a4ac801mr3371725566b.1.1787581472385;
        Mon, 24 Aug 2026 07:24:32 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:32 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 6/9] wifi: ath11k: run the TXQ scheduler on tx completion
Date: Mon, 24 Aug 2026 16:23:47 +0200
Message-ID: <20260824142350.1757379-7-julius@bairaktaris.de>
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

Start a round for every radio whose completions were reaped, at the
point where the airtime has been returned. The airtime queue limit then
bounds a queue that is refilled as it drains, rather than one that is
refilled when the network stack happens to push.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 12 +++++++++++-
 drivers/net/wireless/ath/ath11k/mac.c   | 10 ++++++++++
 drivers/net/wireless/ath/ath11k/mac.h   |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 52c4a9924a31..e706ba1077eb 100644
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
 
@@ -756,12 +757,21 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 		spin_unlock(&tx_ring->tx_idr_lock);
 
 		ar = ab->pdevs[mac_id].ar;
+		__set_bit(mac_id, &push);
 
 		if (atomic_dec_and_test(&ar->dp.num_tx_pending))
 			wake_up(&ar->dp.tx_empty_waitq);
 
 		ath11k_dp_tx_complete_msdu(ar, msdu, &ts);
 	}
+
+	/* A completion returns the airtime the frame was charged, which is
+	 * what an airtime-limited station is waiting on. The arrivals that
+	 * would otherwise start a round are themselves queued behind that
+	 * limit.
+	 */
+	for_each_set_bit(i, &push, ab->num_radios)
+		ath11k_mac_tx_push_pending(ab->pdevs[i].ar);
 }
 
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 342b38308468..150b3a1a9c19 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6583,6 +6583,16 @@ static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 	ath11k_mac_schedule_txq(hw->priv, txq->ac);
 }
 
+void ath11k_mac_tx_push_pending(struct ath11k *ar)
+{
+	u8 ac;
+
+	rcu_read_lock();
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		ath11k_mac_schedule_txq(ar, ac);
+	rcu_read_unlock();
+}
+
 void ath11k_mac_drain_tx(struct ath11k *ar)
 {
 	/* make sure rcu-protected mac80211 tx path itself is drained */
diff --git a/drivers/net/wireless/ath/ath11k/mac.h b/drivers/net/wireless/ath/ath11k/mac.h
index 59f83c7175fd..4012155dddb6 100644
--- a/drivers/net/wireless/ath/ath11k/mac.h
+++ b/drivers/net/wireless/ath/ath11k/mac.h
@@ -161,6 +161,7 @@ struct ath11k *ath11k_mac_get_ar_by_vdev_id(struct ath11k_base *ab, u32 vdev_id)
 struct ath11k *ath11k_mac_get_ar_by_pdev_id(struct ath11k_base *ab, u32 pdev_id);
 
 void ath11k_mac_drain_tx(struct ath11k *ar);
+void ath11k_mac_tx_push_pending(struct ath11k *ar);
 void ath11k_mac_peer_cleanup_all(struct ath11k *ar);
 int ath11k_mac_tx_mgmt_pending_free(int buf_id, void *skb, void *ctx);
 u8 ath11k_mac_bw_to_mac80211_bw(u8 bw);
-- 
2.53.0

