Received: from mail-ej2-f8.google.com (mail-ej2-f8.google.com [74.125.228.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD9054A7C5
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875614; cv=none; b=ffIVU17a+1lnXGOJtZAQZSmUxB7ARwRmunNKBatty7SUGNjE2sb+adybocI8R0dAlj5qVLI6RsIrTo+bw0VI1fx8715zECfypgNSn9XIaCBJ57cLr6MTDwz+FcdON5G9ID6BYLE3GA4IxHjRyHUMKGBgjFyn1GRVmKIo7ZJHu2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875614; c=relaxed/simple;
	bh=QvGyqqXiz95f/xpJy7sZ5Xl0u9DkpTOSGlLuw2g1NZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jgfyhUz2BMo5qfHYhY1tHB7y2HBf0Scvh6UeBdUzOCWK/r5XG8NdeUgKbtGq/WDn2OOgBhI1D6vHZrmPd34waSf+kOeMszIg1e+sCu+eXsNBIU6P8TUOVUlB+oVwaAC1F8k9NitjWvnWjmKcl4Z/UPQHhSN+a/jYd9Ksk3++oIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Gb3VjDSW; arc=none smtp.client-ip=74.125.228.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Gb3VjDSW"
Received: by mail-ej2-f8.google.com with SMTP id a640c23a62f3a-c2532688fceso192896966b.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875600; x=1789480400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=koyRmR036WyiywhS5c/zgf0ngCK/tJ+nGXVvSS1SMpQ=;
        b=Gb3VjDSWDxTECEgr0JVoXb5RPct12KObdcCJeniQbbowAkRNb4fb+CK2ZDvIVGDVpn
         eYplWLW4t3Kz5enohsMeAwFh4xEAhLDnnXyz67PdIObiwHFx0YWaIum+AACLW1119nGP
         oRHlF4L7rUF4WAUEU92D+EXzsGuL7MuajJMFZ1/NjPDQ5GRUyzpEMEhhTEoMmkjudNWC
         y5QEzDH3YbIURv73rJWd4sqFI2r49F2FivLNyqDE4qeKtlkDYZMnofZ6F27S6Tf5bE5N
         lGLZJso8z/Da8tM4Ob1K0p34xJp0DRlYUQsLxNrQv29o8jWIXeGzakRAAY9K7uy+YvEQ
         Kz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875600; x=1789480400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=koyRmR036WyiywhS5c/zgf0ngCK/tJ+nGXVvSS1SMpQ=;
        b=qM+NNMorgAXmVNImEWS7MU50Fm3m7ftMMhtmeGg8lgVZV2SD7kjYvJ/Kw466FZEGZw
         6z672+15tS07Knm/BZ5NANmv6T30t0X9dl570e0zGHC17SOu+Ai1GfbM3zDUqtys8f4h
         IsR9+77JWhFkftpTFS4hbH10WkTAeB+5rc5S9tfCXit9rdaNt1zEu3tCGY1Zso/IW2x5
         0K787mEKz6We9jkQGDGGCl0iReI98BjWCV4Q+DLeMCEJ35fAm9q5MgwV9i30gbOa0KVn
         mrUlXvfkF6cKL3Nqg8dhoLntKd+b4JdHPlQjmyN92kcIWnIzy7vo12cX7xmowHndpQhY
         dyKg==
X-Gm-Message-State: AFuF++lc5fK4PpoGCjhSQ3Go7t4jiXzFQVDOX/doxknuCNSeC0TrFp7O
	R4MTcbERLzNifsbEL3GejAkHUq6TBPKWW5I8FY9b5j8QNiOTjo8UH381vb/8vv2ciU8Ndj6dGyU
	z4AoDRauXg4Arng==
X-Gm-Gg: AYBFou1VglzFhQ3gRUJ4fuQWuz2NHLKoIBU7V/8qxEjZI0SABMMDgQ9cLZrViFYIIYP
	OZHFL9T8AnY8P44LF+120tLdw5zwiLBn2Ez49aVWWZ8DpGFXGEsZ8MvDEg10G50XPKxUE1fsYtF
	6NjQF3+BG65CovxknbCk2bIVXgjxoPKvXOBJvg6xZ7J/5+Fu08PPKjNLTJv3gNSm9l8fWEqLQO+
	IcELb4E02yoeID7OIAL7U7WmJKpFJFd3THFOdMxMnrwF4b2UKcohknQUx5Df5rpYDEi3NFMjbdm
	AeE6Zyee55kwH9RGHFmAd8siYVjLxu3fLTSuG/ES6DxcBof+ijOvTyIFgMVOADvdJ8tgR8MCeUy
	WXFgnPtQM09gf2jv8CaXArrKhuTWIZY5pexsvj/G64ZA1rb1xzazdzEIdPDCavk1JNDD2bs0gq/
	s6hQ2tONM9y+dMVddW0tylvuR0YYyqs4HUSRBzpSUjLUmLmzOAVm2XOCNemhVBVolrdZILq0+6Z
	4rTKM79RGXihFq7SHUSHPG4MxHL1z+h5Sehzcp3FnZQCRRIboUGjlOk1bKu1jbk6jyjP04zK7FQ
	6A6QVUvS7rTK68mCzYFVEzKfziAkWI2EhqHCbcoC7WlgW1pbTLYIsGdgsAHVmrHGpbPERz5Op9c
	xmlbML6LVj28NBNnReD+26XLvokNhejzceftvikbaUCbJKYz6aWB+W4P/8cRa0126bA4fHZrjnu
	uuGSB/Wb4NyghZ9w==
X-Received: by 2002:a17:907:1c17:b0:c26:19de:9ae4 with SMTP id a640c23a62f3a-c2619dea7ddmr975360566b.35.1788875600085;
        Tue, 08 Sep 2026 06:53:20 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:19 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 0/9] wifi: ath11k: airtime queue limits, fairness and a driver TXQ scheduler
Date: Tue,  8 Sep 2026 15:53:09 +0200
Message-ID: <20260908135319.754140-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k advertises neither NL80211_EXT_FEATURE_AQL nor
NL80211_EXT_FEATURE_AIRTIME_FAIRNESS. Every user of AQL in mac80211 is
gated on its bit, and the airtime scheduler's deficit is charged from
ieee80211_sta_register_airtime(), which ath11k never calls. Both
mechanisms are inert on this driver, and the driver keeps no queue of its
own, so on a saturated download every queued byte sits in the hardware TX
rings, where there is no AQM and no flow separation.

Measured on an IPQ8074 access point with a TCP download forwarded from a
wired host to one 1x1 VHT80 station, 20 s runs, three interleaved runs
per arm. The first column is the download rate, the second the RTT the
sender's TCP sees on that flow, mean and maximum over the run.

  stock                              101 Mbit/s   207-239 ms, max 313-322
  series, default limit              101 Mbit/s    48-55 ms, max 62-64
  series, BE aql_txq_limit 500/1000  101 Mbit/s    26-27 ms, max 31-32

With the access point's rate pinned to VHT MCS0, one stream, the same
frames are twenty times the airtime:

  stock                             23.6 Mbit/s   502-523 ms, max 871-1139
  series, default limit             23.3 Mbit/s    30-32 ms, max 38-41

On stock the download's own RTT is the depth of the hardware queue. With
the series the airtime queue limit bounds that depth, the station's aql
file reads 12024 us at the median against the 12000 us default high
limit and 1008 to 1024 us at 500/1000, and the rest of the backlog stays
in mac80211 where fq_codel manages it. A second flow to the same station,
a 20 Hz ping from the same wired host, reads 8 to 11 ms in every arm
including stock: ath11k spreads frames over three TCL rings by the
sending CPU, so a frame from another path lands in a ring the download
does not fill.

The 500/1000 setting is for a fast station. At MCS0 the station's aql
file reads 1308 us and the download drops to 9.3, 11.8 and 11.8 Mbit/s;
no default is changed, and where the limit sits is left to whoever
configures the access point.

mac80211 skips a txq in every other scheduling round once the access
category is over its airtime limit; "wifi: mac80211: keep the TXQ
scheduling round number across a closed round", posted separately, fixes
that. The downloads above do not depend on it, since the network stack's
arrivals start rounds often enough to cover the loss; a download
generated on the access point does, and reads 35.6 to 44.4 Mbit/s at
500/1000 without it against 95 with it. Everything here is measured
with it applied.

The airtime AQL charges is close to what the hardware reports. Comparing
what mac80211 charges against the radio's own measurement for the same
station, as pending airtime over outstanding MSDUs and as tx_duration
over completed MSDUs, the charge is 47.2, 50.9 and 50.4 us per MSDU
against 90.9, 92.6 and 91.4 measured, a ratio near 1.85. Part of that is
structural rather than estimator error: fes_duration_us spans the frame
exchange sequence including the responding BlockAck, while
ieee80211_rate_expected_tx_airtime() amortises the overhead over an
assumed aggregate. Patch 3 exposes the driver-side outstanding MSDU
count so the two can be compared at all.

With two stations on one radio, a 1x1 VHT client and a 2x2 HE client both
receiving at once, airtime_weight is refused with -EOPNOTSUPP on stock.
With the series and the limit binding, the HE client takes 52 to 60 per
cent of the airtime at every weight setting, nine runs, and the weight
does not move it: the scheduling order never reaches the air on this
driver.

Patch 1 is a prerequisite for patch 2 rather than an unrelated fix, and
the series should not be split on it: the tx completion path it corrects
is also the path that returns the AQL charge, so with the feature bit set
and that path still calling dev_kfree_skb_any(), pending airtime for an
access category rises without bound and no station on the radio is
scheduled in it again. It carries a Fixes tag and no stable Cc, since
the completion statuses it covers were not seen on the tested hardware.

Patch 2 advertises AQL. Patch 3 reports the outstanding MSDU count.
Patch 4 registers per-station transmit airtime and advertises airtime
fairness, which cannot be set without the reporting because the deficit
has no estimator fallback. Patch 5 moves the scheduling round into the
driver so a second context can drive it, patch 6 drives it from tx
completion, and patch 8 ends it when the hardware has no room. Patch 7
registers the hardware's per-PPDU receive duration into the same deficit.
Patch 9 bounds the tx completion handler to the NAPI budget, so that
the round patch 6 adds runs once per budget of completions rather than
once per ring. Patches 6 and 9 carry their own measurements.

Two notes on overlap and prior art.

"wifi: ath11k/ath12k: implement TX flow control" [1] also replaces
.wake_tx_queue in ath11k, to stop -ENOMEM under a full TCL ring. Its
handler serves only the TXQ it is handed and calls neither
ieee80211_txq_schedule_start() nor ieee80211_next_txq(), so it removes
the deficit round robin that ieee80211_handle_wake_tx_queue() performs
today and forecloses airtime fairness on this driver. This series keeps
that scheduling and adds the airtime accounting it needs; patch 8 handles
descriptor exhaustion by ending the round on -ENOSPC or -ENOMEM rather
than by reading the ring pointer once per frame. Both series replace the
same callback, so they conflict textually; if that series lands first,
this one will be rebased onto it and its ring check moved into the
scheduling round.

An AQL enable with a custom .wake_tx_queue and a tx-completion driven
push was proposed for ath11k in 2023 [2]. The design was right. What it
was asked for and did not have is the measurement above.

A related mac80211 change is posted separately, "wifi: mac80211: scale
the airtime queue limit by the station's weight" v2. On this driver
every station keeps its full airtime queue limit in flight and the
firmware picks the next transmitter among them, so the order
ieee80211_next_txq() produces never reaches the air and airtime_weight
has no effect on the split. That posting adds IEEE80211_HW_TX_NO_PUSHBACK,
scales the per-station limit by the weight for a driver that sets it,
and sets it in ath11k as its second patch. With this series, BE
aql_txq_limit 500/1000 us and that change, the HE client's share of the
airtime is 57.8, 57.5 and 55.1 per cent at equal weights, 73.8, 76.7 and
74.4 at 1024:256 and 22.6, 22.7 and 22.4 at 256:1024. The one-line
ath11k patch that sets the flag depends on the mac80211 patch and is
posted with it rather than here.

v4:
 - rebase onto ath-next, commit 1d8e73163ef9 ("wifi: ath11k: unregister
   PM notifier on QMI init failure path")
 - measure with a download forwarded from a wired host and report the
   download's own RTT. v3 measured a download generated on the access
   point, which TCP small queues bound before the hardware queue did,
   and probed from the station, which measured the station's uplink
 - a mac80211 fix posted separately, for a txq skipped every other
   scheduling round once the access category is full; v3 was measured
   with that bug present
 - patch 1: drop the stable Cc, say the statuses were not seen; move
   Tested-on above the tags as the rest of ath11k does
 - patch 2: drop the claim that the TIDs of one station test the limit
   independently; the pending counter is per access category
 - patch 3: the idr bounds the count added here, not the ring-full
   counter
 - patch 4: say why the lock nesting is safe and that each MU user is
   charged the whole PPDU as arsta->tx_duration already is
 - patch 6: start a round only for the access categories a reaped
   completion belonged to, and carry the with/without measurement in
   the message
 - patch 7: the default monitor status filter does not subscribe the
   user stats TLV that names the TID, so charge received airtime to BE
   unconditionally, and register it after ab->base_lock is dropped
 - patch 8: a full management queue also ends the round; the frame that
   met the shortage is still freed, and ath10k and mt76 avoid that by
   checking before they dequeue, which the message now says
 - patch 9: state what the budget does, which is to run the round of
   patch 6 once per budget of completions; the claim that receive rings
   wait behind the handler was wrong for IPQ8074, whose tx completion
   rings share no NAPI poll with them. Measured with and without
 - cover letter: the mac80211 weight change now gates on a hw flag the
   driver sets, the ath11k patch that sets it is posted with that
   change, and the airtime split is remeasured with it
 - v3: https://lore.kernel.org/all/20260824142350.1757379-1-julius@bairaktaris.de/

v3:
 - cover letter: v2 claimed the AQL estimate runs an order of magnitude
   under real occupancy. That was wrong; measured against the hardware's
   own tx_duration the ratio is 1.85, reported above
 - cover letter: v2 described the mac80211 weight change as posted
   separately while it was not; it is posted alongside this version
 - patch 1: state that the AQL half of the rationale needs the feature
   bit patch 2 sets, so the stable backport is not read as describing a
   stall that cannot occur without it
 - patch 2: correct "nothing restarts it until the next frame arrives
   from the network stack"; a round also starts on a block ack session
   change, a station leaving powersave, and a stopped queue restarting
 - patch 2: drop "cannot behave worse", which the same message's note
   about a stale rate contradicts
 - patch 2: say why pending airtime stands above the limit it is tested
   against
 - patch 3: the idr holds one entry short of DP_TX_IDR_SIZE
 - patch 4: drop the assertion about firmware TID markers that no ath11k
   header defines
 - patch 5: correct the claim that only a frame from the network stack
   can start a round, and the claim that mt76 relies on bottom halves
   being disabled; mt76 runs every round from one per-device tx worker
 - patch 5: state the bound conditionally. A selection ends where the
   airtime queue limit binds and drains the station's queue where it does
   not, which is what the generic handler does today
 - patch 6: the comment no longer says nothing else starts a round
 - patch 8: -ENOMEM also covers a DMA mapping failure
 - v2: https://lore.kernel.org/all/20260824074228.2114579-1-julius@bairaktaris.de/
 - v1: https://lore.kernel.org/all/20260823195703.49198-1-julius@bairaktaris.de/

[1] https://lore.kernel.org/all/20260811172435.616200-4-jtornosm@redhat.com/
[2] https://lore.kernel.org/all/20230501130725.7171-1-quic_tamizhr@quicinc.com/

Julius Bairaktaris (9):
  wifi: ath11k: free tx skbs through ieee80211_free_txskb()
  wifi: ath11k: enable airtime queue limits
  wifi: ath11k: report the pending tx MSDU count in soc_dp_stats
  wifi: ath11k: report tx airtime and enable airtime fairness
  wifi: ath11k: schedule TXQs from the driver
  wifi: ath11k: run the TXQ scheduler on tx completion
  wifi: ath11k: charge received airtime to the station deficit
  wifi: ath11k: stop a scheduling round when the hardware refuses a
    frame
  wifi: ath11k: budget the tx completion handler

 drivers/net/wireless/ath/ath11k/core.h    |  5 ++
 drivers/net/wireless/ath/ath11k/debugfs.c | 10 +++
 drivers/net/wireless/ath/ath11k/dp.c      | 10 ++-
 drivers/net/wireless/ath/ath11k/dp_rx.c   | 32 +++++++++
 drivers/net/wireless/ath/ath11k/dp_tx.c   | 28 ++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.h   |  3 +-
 drivers/net/wireless/ath/ath11k/mac.c     | 81 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath11k/mac.h     |  1 +
 8 files changed, 157 insertions(+), 13 deletions(-)

-- 
2.53.0

