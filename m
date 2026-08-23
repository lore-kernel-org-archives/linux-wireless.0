Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5243AC0FA
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 19:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787515061; cv=none; b=LfC/xtvRMFbllvoxRvVppz55ef1GoCMr84BNz1pd2bU0t7LG4SBsV0BN1lVbO2isyQsbojt+4xrlMp7k1UHvaTtiYY///et8fit238jBTG0R0DeTH+eX/MRgmc/m6OY1RfF6qNCRUOmskKLscS/Q7GTUMk8pGlnC0aTmSn5AUMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787515061; c=relaxed/simple;
	bh=ECiCeCEGuCG58n5twCY+em+G3/ls9RMrU+5VaKIMvUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfNJzn/08Ad17HfUgqyFqs47rDl3AIc43g9CS98VcSNua3WLkZ340keoEKfy6C7crLJJKLT0rftj8jLFPSvfcWOyMqDyETMvp9tIx6Oxl3LpsERhpomBzNxyLKPkeFM19rRI8ZqfRnShlJeUuoOi8jiLU1KbQuv8lrpVxwEyyrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=q/F/JTBn; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="q/F/JTBn"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c197eaaab00so454940266b.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 12:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787515058; x=1788119858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m2t4yG6gfh8pMrdVrUa/k3ybLPI1hNpC6NthZHGNkDo=;
        b=q/F/JTBnZSi7HrVDF7bncqWswwiW/iHL1kWQ/K57CHID4Mg/oJ3eBYTNrct41uEfZW
         YWw7t3Q9e1qS6/kawyoxHsNKNM4KtEX90R49+ekLD68ioyq59MZbrwx4ZSwH8IDQIXAZ
         zYp9+y8aIboylbjZ/eOCAxGH15bKRIAi21zcTxA2+YMW6HP5Cg3f6MMr9BgV6mtk0Ssl
         nCb/Bc/eax/G9Z0Og4JQYSTNvnaetN4jeZwpyc3vTyMGt0DK/4KH0zzicG5qGdrUIU9P
         oFmtp1Ucs9v/CN0NzMFmAthzYSmk7/h6DOhsKhzF5kxXA5wsb5TrwyRSEGIC6K2ktgwk
         jAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787515058; x=1788119858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m2t4yG6gfh8pMrdVrUa/k3ybLPI1hNpC6NthZHGNkDo=;
        b=ON8+fTLs6jee1zMJEvjVrrEy7fnjHEELBefmvRUtNNIuzXFLrfOfj20wJDAAR5wM+1
         xIPUv+Svbg/8xwDfmOgNFsRITDLjJfhZHqZsf/1UYeDye/AynIC8mV/C2TiCaRtmksQC
         0IOmFX0Zv4q0CZcopf1IeuDmGXasP9D0z1z+AoVnacpb37VaaboX5dcbYJaEn0QaS5c1
         ts6NhCvl4E0RrKqlIZ9F0TCgBG09DLAyyKxCf7HgeVz6beDMnPCbactP86fJb1LPsxOB
         AXAH5eW6cX0JBq+sl4HIMf/RoQHaKG0NvLTe+nUhhCWDclH9irCXU5V96CGkcYQw2QOl
         Hs3Q==
X-Gm-Message-State: AFuF++nd58fo39oE2+7NBD0xVHxb1tIbZ55EL0QkGW0UtCMfJtDfJv5A
	MLfvVZogiJGMyVhKXyeXbNYc2yUuu2m4wv/K7UHX3TP4flzGS/TZ9cpH8elxVZ5lzBfIonaX14s
	ozYQRQ66l
X-Gm-Gg: AR+sD13wvMsrdCfyWJvgyZQdsjQB/Ut8KpT3tJxBw5nABsaU2/TsQ7HQy4F5f4Uo/1a
	VQpJ0y9Z/2UHrn1DhkzvhSqwIerpjfZbtKtO+tHdsEfmIlzFnaPJk6yX8lck9V1ItFq6j1jlHZ5
	3Q8+n5YZAsYSYBooBqUGSRLMQ8y8gn7AeoKloMKgN43MLX4ePVlDNzr22naH0tRH2hm0aot2xGP
	sR2UZtGzqXsWWhXJswrkbe4iQDUuPRDLj7gpX/9akd6+oIt99QOmHDkqfvFK1EgmKoLwTSkXo78
	JrTKzHXhiXO+nvDMM6aQyaksls/K7M26gGjFTFnwNJGP1Dx/d9nwJDMk8VTATv+6zeuom4l1GPg
	r20Zv6jPFWx1wYCBrgiK8iJLNIc5GNLl0LfhX9m7FJcGxzKkxulbG9YxVeohP7K6t1bY6y0M7IH
	8LcKRTNNb2ke7PIdR/XlEonreqNr3HIPMs4MOI24yimFiGpwU+BVR6FesT/kXKFzjv0maTSJKoC
	SuC825iEpukc3G+zCDElb4mEZWLFkAEhDki7xiaOVenfc57xRcRut7xSu3JxMmLm7a7ivJP2hb4
	y1dtt7Qn4pl1qZS4x8TEnLL+tMgEmACOV1Vnarmq57BT50la82FDzOjcpJ5CtWW0wrhB11gE7JY
	VHqPfp/9VtaIsxArRgNDkMYYpR30e1FfstwiFNHckuw41AMC7LCzTbrnr2Gc7mkeIZ3pdSsmiIh
	jVaYjSIBxOq+TRcibPW4Fl5VU=
X-Received: by 2002:a17:907:d08c:b0:c16:8931:245c with SMTP id a640c23a62f3a-c246a72fdcdmr2465179066b.21.1787515057687;
        Sun, 23 Aug 2026 12:57:37 -0700 (PDT)
Received: from Desktop (pd9513a95.dip0.t-ipconnect.de. [217.81.58.149])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a8edsm889532666b.6.2026.08.23.12.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:57:37 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v1 4/4] wifi: ath11k: report tx airtime and enable airtime fairness
Date: Sun, 23 Aug 2026 21:57:03 +0200
Message-ID: <20260823195703.49198-5-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260823195703.49198-1-julius@bairaktaris.de>
References: <20260823195703.49198-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211's airtime scheduler charges sta->airtime[ac].deficit from one
place, ieee80211_sta_register_airtime(). Unlike AQL there is no estimator
fallback, and ath11k never calls it, so the ATF feature bit cannot be
advertised on its own: the deficit would only ever be
replenished, every station would stay permanently in credit, and the DRR
would be inert. The bit is not a no-op in that state either, because it
also moves txq insertion to the head of the active list, which
__ieee80211_schedule_txq() documents as safe only because the DRR moves a
station back once its deficit goes negative.

fes_duration_us arrives with every PPDU's stats and is already
accumulated into arsta->tx_duration a few lines above. Register it, and
set the feature bit in the same change so the two cannot be separated.

Measured on an IPQ8074 AP with two stations on one radio, a 1x1 VHT
client at 433 Mbit/s and a 2x2 HE client, both receiving at once. Before,
'iw station set <mac> airtime_weight' is refused with -EOPNOTSUPP and the
per-station airtime file reads zero. After, the weight is accepted and
read back, TX airtime accumulates, and the per-AC deficits move.

The fairness this delivers is coarse. Weighting the fast station 4:1 moves
the slow station's share of airtime from 59.5% to 52.1% and the fast
station's throughput from 315 to 392 Mbit/s: the direction is correct, the
magnitude is not the ratio requested. The granularity is bounded by the
driver's push model, since ieee80211_handle_wake_tx_queue() drains a
selected txq whole into the hardware and the scheduler therefore reorders
only between selections. Tightening the AQL limit to shorten those drains
does not improve it: the share moves by one point and aggregate
throughput falls from 401 to 178 Mbit/s. Finer control would require a TXQ
scheduler in the driver.

Two properties of the source are worth stating. fes_duration_us spans the
frame exchange sequence, so it includes the SIFS and the responding
BlockAck, time the radio spends receiving; the airtime registered is
therefore larger than the airtime transmitted. And it is a per-PPDU field,
so on a downlink MU PPDU each user is charged the whole sequence. No
per-user duration is reported in these stats. On the firmware tested here
every PPDU carried exactly one user, measured over 21051 PPDUs, so the MU
case is latent rather than observed.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 9 +++++++++
 drivers/net/wireless/ath/ath11k/mac.c   | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c084..33c6fd9553a6 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1485,6 +1485,15 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 
 	arsta->txrate.bw = ath11k_mac_bw_to_mac80211_bw(bw);
 	arsta->tx_duration += tx_duration;
+
+	/* tid is HTT_PPDU_STATS_NON_QOS_TID when no ack/BA TLV came with the
+	 * PPDU; mask it so that airtime lands in a real access category rather
+	 * than one chosen by the spare bits.
+	 */
+	if (tx_duration)
+		ieee80211_sta_register_airtime(sta,
+					       tid & IEEE80211_QOS_CTL_TID_MASK,
+					       tx_duration, 0);
 	memcpy(&arsta->last_txrate, &arsta->txrate, sizeof(struct rate_info));
 
 	/* PPDU stats reported for mgmt packet doesn't have valid tx bytes.
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 38f641bbc53c..40a2b6d2f804 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10593,6 +10593,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_AQL);
+	wiphy_ext_feature_set(ar->hw->wiphy,
+			      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 	if (test_bit(WMI_TLV_SERVICE_BSS_COLOR_OFFLOAD,
 		     ar->ab->wmi_ab.svc_map)) {
-- 
2.53.0

