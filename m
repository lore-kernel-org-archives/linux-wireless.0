Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3956439CD0E
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557382; cv=none; b=O0iL8sz4lz1iLu0MNVe5n5JJgmB7OxIrzo51CL7KsXahzLGXf26K9m0abw4AGB5AxLgL60r6CrTlokvYpioT6ZRMnerlGkLtWydPO/D69LpZPvxmKb2nj6AbHYQeWrf+rmbDKl8P2P5hZDe2Jnp9jiUhMZh+etiUQaQ2ggqMHbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557382; c=relaxed/simple;
	bh=5Hn9vrXHrtMzrUC/0YhR95XQb9FD2bjJDMcnXNQ/WXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMbFYEv3i23iDbON/eRCW3j2bf1Vx6kzWuhFJGnZ2owWCH+Q5zZsGQYF/TItOE7snyz27cUcO3LPpaLl8yy/rMCTFLribY88w+MFmysGrKikD5NmXHAsqYsSXFOnW7MTS4LFw38M9/vDQzCNREAGe6h4P7BZNvE406+AXfzAPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=W4iqxAP3; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="W4iqxAP3"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15e2dab83eso591792466b.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557378; x=1788162178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4iOAeD/vez7o1BoFsDFbdz2zh1sUHtZ1x5O3PJ3hJw=;
        b=W4iqxAP3sMaK4uTRfeCMpzh+PTzm3XYmW3klItknRc+YyI4tMkqMKWJ1wQBFpj1nWj
         8zMUmkB/SI4gxFco8by91fXVIPNIIVsnrgE8ZuIEbmvQQELjABsjscliqCj2D1JhdGGw
         kR+jSgjaXx46A3WG6bZC6KA6P0dWdO8tpa/I/E9cFPbHXffBKGA38LhZHg3+9efjmMG/
         rJTmKes0nt4mRmhxn76M2paOQBY1qH9on0umR9G/2ySzAfhnxHgsiwS6lchY4nrILYod
         84PpDEjFQsp6qLAGo+AQgnmzGxDUUTseMgQC0op4xsHlauehTO0LQsSEiPbgTpRPq11R
         PHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557378; x=1788162178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b4iOAeD/vez7o1BoFsDFbdz2zh1sUHtZ1x5O3PJ3hJw=;
        b=afp8o0gCZuDfzQi52qEvAE8jRgyU/pT75BiJmMpWrD2eBT4eM5bGvmEKmayUW8srNs
         BbqKmuCNgbiF9bv5txTlEaHPHkc8VqctqOTrw2zZUszSLikfYmC0kd/YSbDn/t0wPaof
         /RxkL5Tw/hoMLdl8UXJWjfmSUXU0IwoqTtJzWMvw7SIIbg0ZZ6lshzcjULxomLhPkGv3
         MKy5vv7HIOQnc8CriXVArIVsI9HcTcqxgnjJwaxtK+m6ioiPvCzA+SipTNxnVdd8+BzS
         3cmd3nKxpmpYPcbYmjLLnnjd/2UOFwIaYVTU+fpXbAu6tKEfmDAkiOgoM5/Ylck197R4
         MYgw==
X-Gm-Message-State: AFuF++nZkmiWlk5mswJlQkoyUU13+REYqojO3AWKqV+7kFM/FNoo7xrx
	W4UUdVTE2AqXOIcOM/M7MuChG336fUYh4DOZxjPDFVTU9OwEqawImc3zhdC6/PydaQ==
X-Gm-Gg: AR+sD10RoOXTRquGXZPJW8dHv9VwdqU/1Fsvoe+ED1f0Imf55LDTX6JfCXq2ug20Due
	Qa/7W/yAmcVxYbNdDZJj5ni2VS1s5gcjHFS3qN5Vh/nmJga+YGpaeIUDOW7Zb6eK1eZg7DtEzEH
	FaCKHjaACSftpCcvdj9+hXDghIinZdzqy4xLqxceH6p/6Din+PGfD3Jtym8NjOX17PX9xqJG6hW
	61HQPz34dlRYyC2m5ii65VjRPmeGocpj5ClqJxd+jp85f6fvWnkA4XKT1mDHV7NBMQ9hHDx7nRS
	STetvawEAsCDXwQUhhlHaCVMyRXA/KHR5T2oCMmcxwkYZUhrrfMJf5zEwWxZmv0Ms9Md8nhn6oh
	/xGBD6MIvEpuIig/eLW8ncvrrMebgdOFK/WinDvLRzldLutDr1rPWG4qowQlF89vkSAgy7wiLJ9
	hQxFKdwUF9EI5UKYWFZmMM4nAjUql4txxnY+GwnfR/GcqVT5CwAOmczVq60+326iSUI2tDQTvZj
	5EoEH6IGmzTEmqQ7jxLLTvH0AcIn2dTtFWwq/vJ5R2HVla5/Zd59fJTD5rlfnGMEvGuX8Jo+WmY
	9v4UGTRnXQUredQnne2KAoX/EC8G7XrUnMhoON0ySZBdesMk6faYUk4LvtAv7KU3+2V+lEl0P1X
	Q/YCI3nyZjbH+wEhNxyf7zZcp2EP4xa3pbkBZBGsRfCtXhRRbAdge2MxlQWdpuCAQgPXQYJVtjj
	UsVpyKvySzZgWjig==
X-Received: by 2002:a17:907:3d56:b0:c1f:e9d6:2a6f with SMTP id a640c23a62f3a-c2469f9991dmr2918228666b.0.1787557378200;
        Mon, 24 Aug 2026 00:42:58 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:57 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 7/9] wifi: ath11k: charge received airtime to the station deficit
Date: Mon, 24 Aug 2026 09:42:26 +0200
Message-ID: <20260824074228.2114579-8-julius@bairaktaris.de>
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
aggregate: measured against one HE station, the per-MSDU estimate from
ieee80211_calc_rx_airtime() reports 16.9 s of receive airtime where the
hardware measured 6.8 s.

A PPDU that reports no TID is charged to BE, matching what the transmit
side does with a frame carrying no QoS control field; the value cannot be
masked into range because ppdu_info->tid is ffs() of the TID bitmap less
one, so a PPDU reporting none leaves 65535 and masking would select VO. A
PPDU from a peer with no station entry is not charged to anyone.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 05fb34e70889..d0da72b04aec 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5343,6 +5343,26 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		arsta = ath11k_sta_to_arsta(peer->sta);
 		ath11k_dp_rx_update_peer_stats(arsta, ppdu_info);
 
+		/* The airtime a station spends transmitting is airtime it takes
+		 * from the others, so the fairness deficit is charged for it as
+		 * well. This is the duration the hardware measured for the
+		 * whole PPDU, which is what the transmit side registers too.
+		 *
+		 * ppdu_info->tid is ffs() of the TID bitmap less one, so a PPDU
+		 * that reports no TID leaves it at 65535; charge that airtime to
+		 * the same access category the transmit side gives a frame with
+		 * no QoS TID.
+		 */
+		if (ppdu_info->rx_duration) {
+			u8 tid = 0;
+
+			if (ppdu_info->tid < IEEE80211_NUM_TIDS)
+				tid = ppdu_info->tid;
+
+			ieee80211_sta_register_airtime(peer->sta, tid, 0,
+						       ppdu_info->rx_duration);
+		}
+
 		if (ath11k_debugfs_is_pktlog_peer_valid(ar, peer->addr))
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
-- 
2.53.0

