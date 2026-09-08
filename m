Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC9454A7CC
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875623; cv=none; b=LC2QggfqVRN6P8FNuR7YW8BrRmHcNaZxiyTXgNDYGx7pinXZDKXSdG+vgiB/tFV6bRIQP/3IICP+dBHxVzz/4UZ0tf7hynMMDzD1kQNdsmq76K5i1FaRulBX5eDfWZzCf3iIiJLovA6+YtziVvYfa+ZFIFTOFkW4ewYSDcnVx5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875623; c=relaxed/simple;
	bh=7wIfSA7jIgn+YuODqH1Zm4TLzhQihyQIWfos5qWU4Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcXYwS7No28jJeqzt3oehm/evV8SeVSRl5ZTRzDYXlqwcxuWSw7bU0KMO/yAY/Z1zd5ASzrJEPEU5w1NMJyUD0GstTT8g3TmPwvYB63k6dPHyhZi3DEF7Q15pIRKd7CJDihQW5Yfs2GNd5ry1wkUv4NTEg+4bnzulmaSuWPStgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=atY7zy2H; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="atY7zy2H"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c263415982eso355790766b.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875606; x=1789480406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=onv4qoIcCtETFC209nIFagBVXouZZuhs1jFn7+5wWYM=;
        b=atY7zy2HI/b1aqOv0owoHGMS9WiEf9LpNAezUogtvunTG2lQ7Ww/KnS8ELzTU9dZan
         2Zx7LYbfFVNf4EKMkwVukEdAtSW8mlNM5+k2ybOyyGU+clO7vTejW52Z6V+3TkF8lXGx
         ErwisnjHG7ydflVWd2Wl+2WyXWReXRMq36klStLLQKVJIdpUxGLi72k4pgZzmjKpi/Gl
         uG2wRhO1z0u5xDSXJwx2fF2ZcAT74fHh63xetzNk+AfC0SpLEXfhi2DohdOP/y6XaCcE
         27iybP8HZtqKgpoPE/ItvlBg/tkZ7cNcOAAumfyu5Hvrh7FeXk7n5lRhyYy7WUZj/bDs
         +Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875606; x=1789480406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=onv4qoIcCtETFC209nIFagBVXouZZuhs1jFn7+5wWYM=;
        b=ooJtiakZdn1UkeaYR/8Z9hEo4d1hYLB5mbgTPZwmOQuaRo1NlZpyZ8NTj5YQbjzuY9
         pwkZcKjeMVl+ET3xgSCjpte+YuzQ0iasG1/iTTuDkAWPQEMwj0zA3TwFcR1JfbHdOuic
         yv4VOTcLvcjtx2kv0OKF/R8THGCyG2dmz9oEnhN8hgFNnvTgBxvlxxwoe7xcTqxE6oV0
         kf+jIVETpZ1FZ2nfqcOpsRQnYbR4f6PWgwo2CitKB/b7dp3P70WP1Hji7sT1/h3Lrx/V
         Y3a1xP20VE0KJZcjI4Rx0CkJ21fb1JGBYw83UkQdJUK8pg5wQTmGsOO6SWwRzt1nC+In
         QQRg==
X-Gm-Message-State: AFuF++mhWRtlIi4BJa+Zkkf58zTZlnkFmD48OT8ZPm0dj1ZpjOUCAPEd
	+shlCAin5VcL0A4klcYbpKnNw8wD0ZAKNK8pC0TDnyXMvYK1Tmq3QplwZ8UocBkLww==
X-Gm-Gg: AYBFou2b0YpcaH6E8WDjuCLnX1ypPwe6wD7AC86Ms+xqoP5c6FMEyLmSLdihDpTfHD9
	JFtHSg88XGpo6KMmo3BtqIMTl4eVukDc99PWbXaqZOkZPmDhE84gy8mts0SxVMf0u8iBAQKqyPk
	33NC8nJmqALKQNZsc6Quc7DqchwGQxg60CCpk9NgJSdZIXEqgzn6HH6vJQjXrS5Xq8CIi8RF68Q
	JDEY1SuMYIE79G7VgWnweDkWeHhv2FFARnrsW8QB+4mE5iL7NHuhVbwpD0brn6owtIwwZ5s9Wad
	X6QBfMH35m/yPLk5rPtLOKCBY/BN21GCLclMzKtIigeEaSBXasgkORPJcZ81E134Sef902eWtIc
	axgW/188tPPSrcQziB/CwU4x8Zsun7YvPMlZL0/DHGIpl5HepyihCt93IDwlIGP7oXv2ViEp1SZ
	bnEMalmM44jpdPvvxztXtmyW6irkKAVZiwuxwqYIFLWfaMT665Lrbs8Sr+xWHkBLlbNJNzAyMP1
	pAsAvym8fwVbesrC/u4OzWTuMC5wu2MOOURhSsZq/3CNXZdbGxbQE2B4Gt2O4nXUBzSFsbiYP5O
	hL9W5O/UZalRXg4lkd2DyQEhI3tJ0GV55cJ+5TFcNbJIHrutos+dqhXszYsd6jGuY8sz7KcVMEa
	XTUfylTnmSsF48Vchn2jNeDsvwoJywz4QCQsGj+sAcwIts/myBcuYKx9RNbp0vz0IRTCXpvp7Ts
	1jO3YjapWxupyJ
X-Received: by 2002:a17:907:6ea2:b0:c25:8bcb:ea0b with SMTP id a640c23a62f3a-c260c6a0e93mr1982912066b.4.1788875605742;
        Tue, 08 Sep 2026 06:53:25 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:25 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 7/9] wifi: ath11k: charge received airtime to the station deficit
Date: Tue,  8 Sep 2026 15:53:16 +0200
Message-ID: <20260908135319.754140-8-julius@bairaktaris.de>
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

mac80211's airtime scheduler is configured to account both directions:
local->airtime_flags is AIRTIME_USE_TX | AIRTIME_USE_RX, and
ieee80211_sta_register_airtime() adds the received airtime to the same
deficit the transmit side subtracts from. ath11k passes zero for it, so
an access point serving a station that mostly uploads charges that
station nothing for the medium it occupies, and the deficit that decides
whose queue is served next describes half the traffic.

Register the duration the hardware reports for each received PPDU. It
arrives in the RXPCU PPDU end TLV on the monitor status ring, which is
subscribed for every radio, and ath11k already accumulates it as the
station's rx_duration. Charging it once per PPDU matches what the
transmit side registers, whereas an estimate rebuilt per MSDU counts the
preamble and the interframe space once for every subframe of an
aggregate.

The PPDU end user stats TLV that names the TID is not in the default
monitor status filter, so the airtime is charged to best effort, the
access category the deficit arbitrates the bulk of the traffic in. The
call is made after ab->base_lock is dropped, under the rcu read lock the
loop holds, as the tx completion path does; base_lock is contended by
every tx completion. A PPDU from a peer with no station entry is not
charged to anyone.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 68472e1e748a..a7b9bb295728 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5270,6 +5270,7 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 	struct sk_buff_head skb_list;
 	struct ath11k_peer *peer;
 	struct ath11k_sta *arsta;
+	struct ieee80211_sta *sta;
 	int num_buffs_reaped = 0;
 	u32 rx_buf_sz;
 	u16 log_type;
@@ -5324,6 +5325,7 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 			continue;
 		}
 
+		sta = NULL;
 		rcu_read_lock();
 		spin_lock_bh(&ab->base_lock);
 		peer = ath11k_peer_find_by_id(ab, ppdu_info->peer_id);
@@ -5337,12 +5339,25 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 
 		arsta = ath11k_sta_to_arsta(peer->sta);
 		ath11k_dp_rx_update_peer_stats(arsta, ppdu_info);
+		sta = peer->sta;
 
 		if (ath11k_debugfs_is_pktlog_peer_valid(ar, peer->addr))
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
 next_skb:
 		spin_unlock_bh(&ab->base_lock);
+
+		/* The airtime a station spends transmitting is taken from
+		 * the others, so its deficit is charged for it too, with the
+		 * duration the hardware measured for the whole PPDU, as on
+		 * the transmit side. The TLV that names the TID is not in
+		 * the default monitor status filter, so the charge goes to
+		 * BE. Outside base_lock, which tx completion contends for;
+		 * sta is held by the rcu read lock.
+		 */
+		if (sta && ppdu_info->rx_duration)
+			ieee80211_sta_register_airtime(sta, 0, 0,
+						       ppdu_info->rx_duration);
 		rcu_read_unlock();
 
 		dev_kfree_skb_any(skb);
-- 
2.53.0

