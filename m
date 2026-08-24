Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6331739C637
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557381; cv=none; b=R6E6/FPYxkPvdMl8o8qKKQRC/oZhPj01YtwkcCzLKIaDCU0TZ5tt384Ouf+1HA74SXS1StacxYFWD7x3Aq3R6+TIkUbClU6UboWMVT2PIC5cn65dwVUvSd164c9HU6vYBEPtY48XEGifb7q/RNMOA52W3qHpH9/pDM5RKYpHSKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557381; c=relaxed/simple;
	bh=kDxyaOJu7aGpkE49+5OmKIusqkl0SXPH81m2SnPnk1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxRkeEOlqlMGQkq8hCiWFSoTb5Hvs7LPH6VWw1+31JEZDhfafOIqlccRTXaojcHYjqvVSGga30uYIsZi0KrPM9zjwHf79G2uHlhj6SWO+0AV11lO5E5UJ9uAHx7GeHw/DHZQceGqd1Ambxuep/pfH1kV1Vg35IlpIw1IFgAq8qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=P5cfuZcz; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="P5cfuZcz"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so5363441a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557378; x=1788162178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aeu9v09Dg3phc4FovHKp090dH8CPgvA80R9sY0ggepc=;
        b=P5cfuZcz50msO0ZrU/5nGYHuTkBP7OjPC4Q2Pe6GWbtN2DvdOHcCytVwaozwoBZiPh
         QStAepkaP0Vct7nRYqJjehUGh7rMDnYmOeAUDJ1gTWArOXQoL7UHWTE3cnmlwTpDZVGZ
         6GZRFDZd1RaFbeMjt/aVwkg/3rJ+lPLWazBlycyAkKnKEhhIqXku+G6Hzk1JtDaOmTRi
         pniWdCW7iZ6UW2JOuRBqsQ9q94cVPUFPeyP93/fmEDQdqUx8IusgLQiGrXg85pxQu2U0
         jxO3TS65JbwFUKgNCCk81djP6lgTksnh9CKFUQsjqVORmxJu5BUOMM5o5YC/ClkM0JhH
         FDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557378; x=1788162178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Aeu9v09Dg3phc4FovHKp090dH8CPgvA80R9sY0ggepc=;
        b=r/OwydeuuHui4rUGb67HKrxYjXK5t1yWLOnkR1hhrwd/R9jM2eC9vQZE1KZ1lkBA9M
         rFPGbgq5DxzlDmC8TP5eLeZhI3+kuEOj1cEWGne3ciZv1CQjVWwSNAXsdNC+TIaXsn5j
         mLTmkRAXB2sNuYJ8ImTb63fZaVhsC82f+alKuQBvrdPYPKuY18EV9b/rcwIptyvJkc+K
         esB4S8B/vO8lR9Lnne/5buvcdY4QL6+T0A6hp8mM2wOmrChRvgImirU+ZMkdyUIrYxWn
         wlGJ++Yy6omx9fJM+R9Zj26mVZdwtXdFim35AZ/0LO+I9dmbjnlVI1maV+W36dq3hG6O
         rH0w==
X-Gm-Message-State: AFuF++meHqWbonrj/DJ9h0YnlNGX56AQIoT6759KxAuRQRrpY9V6OHil
	18Z+RoECZdddcGoEATymvnBzI4ZLN2iMbICNrGhb5RQVdj7ydP9K/B9IFc/wcNTrSA==
X-Gm-Gg: AR+sD10LeZ5qaxF06dJquYbtZ5C1K/gX1Po3ClX2Yg8SzzhnFSJng8wQofdEEaEfHuk
	fXdlCN0BxBlq2OrQHZ28DhRJxJXDonej5s5sjy2zwOA+JDTStRycfAsPZuZURKJIKmU7+z6TgwC
	UN2r3Udv0Fki075pCuzm1MH1puiZ9PoOboRopG8spof80d50l54+X/i1Pt3hfcs/vjjq9x4+sYQ
	NPuAEMeM1BPtWg5+tCnuhm8qzqAUQgkMnXPyuvZ0+eafSvEpiyVadLgcJ/kDmJGgBZZniKTMneQ
	mQknf83UTLDVhZTinoX9zPKJqeOjtRFR97VKZfBU2Qe08iHcXVzQcxPTD758ZOLc8bLGhZwZHcC
	koIoI6GZ49J2myq5K3Usv6gZEAWh9CvTWZgEnSDyzDCffaRlN3aQFD5CEkACDQhsQTO8zQFH7M7
	EgAqcadQc0DnJxb9zbBeJhK5D5cg3OFFzmor0WMT1J/G9LH+Q8mvJ3A953pSgmG2aY+U40fakPJ
	YwXrG/LMhAyawNUcCCp3yYzpS4LE33eZDlH4J3iRf8JHsoJLCshGtqJ7c37Xtjz7+XmGxcraPRi
	CSmyJMeMzuj1AFo+4ZTM3UaVOBYGQgqApd/C0W6QuqzHoyBKpx0+g8gjdBqIpr58Ju53JPekEzw
	b4hA3cKKHazGI0NB9p41LbYWSWcitU6NUAkeQyS65Q9YjTV0DPomKDwEU8V7JxYR8tAwn9oEkir
	+kPdX19IIPvUqyAklAFR+494wx
X-Received: by 2002:a17:907:6094:b0:c1f:9c3b:96a7 with SMTP id a640c23a62f3a-c246a6269d2mr2635539266b.17.1787557377479;
        Mon, 24 Aug 2026 00:42:57 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:56 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 6/9] wifi: ath11k: run the TXQ scheduler on tx completion
Date: Mon, 24 Aug 2026 09:42:25 +0200
Message-ID: <20260824074228.2114579-7-julius@bairaktaris.de>
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

A station whose airtime queue limit is reached stops being served by
ieee80211_tx_dequeue(), and the airtime it is waiting on is only
returned when the hardware completes the frames already charged to it.
ath11k starts a scheduling round from the wake_tx_queue callback and
nowhere else, so once the limit binds, the backlog moves again only when
the next frame arrives from the network stack. Under a saturated
download the arrivals keep the round running; a flow that has just
filled the intermediate queue, or one whose sender is waiting on the
acknowledgements behind that queue, stalls for as long as it takes the
next arrival to appear.

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
index 52c4a9924a31..2270b2079297 100644
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
+	 * what an airtime-limited station is waiting on. Nothing else starts a
+	 * scheduling round once the arrivals that would have started one are
+	 * queued behind that limit.
+	 */
+	for_each_set_bit(i, &push, ab->num_radios)
+		ath11k_mac_tx_push_pending(ab->pdevs[i].ar);
 }
 
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index e5b2a5e56a28..996f421b6957 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6582,6 +6582,16 @@ static void ath11k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
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

