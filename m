Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD3B397AE4
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557375; cv=none; b=IM8XsOHf1O2Wu5Ty2oQgPquEip/ltV4rb4rkF2PYZ/FaajoRPfu9Y/ZbvoabnOlCEI3g4r3vglCSS6csJeHeYTJzP6nYYzFTeLLxhFO9NT1UlTp9nA3tVqqCwiFyPD0kxEwjaiVTxXGlKtoRRq8DaWwJgsgewFqQbqpXzR++AuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557375; c=relaxed/simple;
	bh=VG2y6S29OcqhEyzNL6dkQQRCuTHz+F6500KmEvhN70w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=arPdex9f5pCzFjxnwID93Gqu6wH857Qmfzdwr5ZKHt9vlPTXaJkbTZ3bq/Vm+VdYUfDU2RQAHOOpUM4tlWOA1MqXeyuO98eltmWgh9yyiEHFigcbuMt3CxGKGmH//6m/9OK3fIvKEO3g5FPD6uDMba0YBTmmmcV1Ulug8kwKFDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=eaFFb+sw; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="eaFFb+sw"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c1712a04ddaso531051466b.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557371; x=1788162171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fjcWIAy7x/ETai6n4CfB8f6nIC+kIzPbY8w6pVYrWR0=;
        b=eaFFb+swYeprmxs2AB1yp+9tnOTjd+SohOnIQZjWKutyAlT1LSHAak8UyF1dYKMi9Q
         j6AikEVniQNKzS6nFPkjo5fX5sKqHF8a82V3qjlo3xyKEA4thw31pe/KEGV/Gjn0hSyT
         Dwq9i95XEhtLQTqno1UbyCOU+ReIVTCG4uFqOzOWSNiatw7khBZYfHJ7BEFzLy772bND
         eoE87PCcQ7rFlfv+D7uaqFLSh74M2jdDqWV/j1dbaOGGqlmkS7L0CQCyF95zDhqO4x0k
         2tkzCFHpnpOu8MN7V3A1HH8xiQQueb4TVvFagbRPdjPdaw+GejIK03RcJ760UVY8Ag58
         EImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557371; x=1788162171;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fjcWIAy7x/ETai6n4CfB8f6nIC+kIzPbY8w6pVYrWR0=;
        b=g4TflNBZT5dBEsBzTKPDi6dxg4B2pyHk3/YxlMNKlWBClPqAONqHlXLfDHN6DKhSCM
         gEuojoTP3uuQOyCwmBNcsFGVN5/QgwRL4YKSvDXnXSZOD/+5ZvhaOHK48BSHt/al/O+2
         dio0Cnj7dk7Lk/6UoM/gTK41egiqq21cYocw+rf68w1Ai6KyeWSwFRF1bIIlRjeEISVZ
         P13bCiwBUUmRtrLXVIvbxP1ao7XjfirTx/6YgEqmgMNwKmu5i9uQKNeh6ulAvgIT7ka9
         gys8BmxwduCl7tZ+LLUf+SRGbr0v1AkLYusG7oftb9S6iB1YgiDo/ZhaPgGiVQHps+C8
         vkZQ==
X-Gm-Message-State: AFuF++loYvqWxaexABxG69esFdwEpS4WaTVX8sX9ddameUUlywblZWrJ
	GUkVohXbUrICfk7MQSEWEPR06PBER9QFN7mB2IrdmQGEpY+z1ZpYM0M4zZt4PJOWlHe9+F3Ewoe
	ESAviiBVW
X-Gm-Gg: AR+sD1394LB2OsuTM8pu42jaI6Rda4Rap1tkAO18QOwyO4UtuC2tpQQpDpdx4m8y0d5
	l8cmsGNa3kOSxyY333UJtGnsu7ZNQ/3LbGTI1h5gyCKEG3chXDs3U88qTgfACwlsmPL+cH1pBR6
	wj08KZ07BNTMX+3Rf7nuB3hSa8LjIQQlKvBUPalPq0Z89gLPxth4HtLKpXqX3MagRm0lomiOVnJ
	tM9KO45bKktRM/vtPniQZ+v5vda94zeSz1zwn1WwXmEVN7mF6KhfbzlAtfPjTwLJzk8qmO+JDtZ
	/lnP1yfzz7fPBbqpCxYWZCVZUgLAQ2d1+ZJV9/HvOyUribKs006y5HAQ0yut0JTMa7DRZkrzqS3
	UNcq5VUUpA55cOwAsdkUFy7u1fdi1AsiNUokURJvS+oyyTRrGnCfqiCQnyNr9mKG12x2/bEaNJI
	ge6h30xKpgb52mTj/ZX4WBVkIo4hwYIsb3nBAJcZ6qmXgtULhmwMF8IjufZ9UCCezmB7KrmgZ8V
	ijCgyko27xj5EGEg0udTduHfuA5e+/3jGQaGGjiLHclB6mggcMlJIVklDHiMA41iA1foU8Nv9QI
	CjkCg56yxzyRhDkSQ9eQAWCbkrICOsmQgYxSaUMW5Obe2MyI1XWZ/gnQWQyLtQcQ6jZWZw5e4DS
	NYWLblXdfZZFtHcUIEZWFrCpQ2K9AQI3U+gzklKRxPr29PvLGyAiE01VzuKeEoxgreF+JA4gJOU
	LCxDquWlyfs8rvBQ==
X-Received: by 2002:a17:906:ba8f:b0:c1c:3b06:ed03 with SMTP id a640c23a62f3a-c24920e2f93mr2097394466b.23.1787557371057;
        Mon, 24 Aug 2026 00:42:51 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:50 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 0/9] wifi: ath11k: airtime queue limits, fairness and a driver TXQ scheduler
Date: Mon, 24 Aug 2026 09:42:19 +0200
Message-ID: <20260824074228.2114579-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k advertises neither NL80211_EXT_FEATURE_AQL nor
NL80211_EXT_FEATURE_AIRTIME_FAIRNESS, and every user of either inside
mac80211 is gated on the corresponding bit. Both mechanisms are inert on
this driver, and the driver keeps no queue of its own, so on a saturated
download every queued byte sits in the hardware TX rings, where there is
no AQM and no flow separation.

Measured on an IPQ8074 access point serving one HE station: saturated TCP
downstream, a 20 Hz probe from that station through the same access
category, arms interleaved, three pairs each.

  stock                             94.6 Mbit/s   155 ms
  series, default limit             94.0 Mbit/s   157 ms
  series, BE aql_txq_limit 500/1000 74.3 Mbit/s    22 ms
  the same, patch 6 reverted        33.7 Mbit/s    21 ms

On stock, mac80211 reports no pending airtime and one frame of FQ-CoDel
backlog, and aql_txq_limit has the same effect at either setting, which
is none. The series puts the queue back under mac80211's control at no
cost where the limit does not bind, and roughly seven times lower latency
where it does. Patch 6, the completion-driven scheduling round, is worth
2.2x throughput at identical latency and nothing at the default limit.

With two stations on one radio, a 1x1 VHT client and a 2x2 HE client both
receiving at once, the slow client takes 65% of the medium on stock for
95 Mbit/s while the fast one gets 35% for 550, and airtime_weight is
refused with -EOPNOTSUPP. With the series and the limit binding, the
split is 43-45/55-57 at equal weights.

No default is changed. The series makes the existing knobs reach the
hardware; where the limit sits is left to whoever configures the access
point, and the curve is a continuous trade rather than a free win: on
this hardware 900/1800 us gives 92 Mbit/s at 127 ms, 550/1100 gives
81 Mbit/s at 31-46 ms, and 500/1000 gives 72 Mbit/s at 19-21 ms.

One result is worth stating because it bears on how the limit should be
chosen. A sweep of 12000, 6000, 3000, 2000, 1000 and 700 us shows pending
airtime tracking the configured limit across the whole range while the
latency through the same queue only responds below roughly 2000 us. At
94 Mbit/s, 155 ms of delay is about 1.8 MB in flight while AQL believes
14 ms of airtime is outstanding, so mac80211's estimate runs about an
order of magnitude under the occupancy the medium shows. Nothing here
changes the estimator; patch 3 exposes the driver-side outstanding MSDU
count so that the two can be compared.

Patch 1 is a prerequisite for patch 2 rather than an unrelated fix, and
the series should not be split on it: the tx completion path it corrects
is also the path that returns the AQL charge, so with the feature bit set
and that path still calling dev_kfree_skb_any(), pending airtime for an
access category rises without bound and no station on the radio is
scheduled in it again.

Patch 2 advertises AQL. Patch 3 reports the outstanding MSDU count.
Patch 4 registers per-station transmit airtime and advertises airtime
fairness, which cannot be set without the reporting because the deficit
has no estimator fallback. Patch 5 moves the scheduling round into the
driver so a second context can drive it, patch 6 drives it from tx
completion, and patch 8 ends it when the hardware has no room. Patch 7
registers the hardware's per-PPDU receive duration into the same deficit.
Patch 9 gives the tx completion handler a budget, which it did not have
and now needs.

Patches 1, 2, 4, 6 and 7 carry a measurement. Patch 5 is a prerequisite
with no behaviour change beyond a narrower lock, patch 3 adds a counter,
patch 8 covers a descriptor-exhaustion path the tested configuration does
not reach, and patch 9 bounds a loop that was unbounded.

Two notes on overlap and prior art.

"wifi: ath11k/ath12k: implement TX flow control" [1] also replaces
.wake_tx_queue in ath11k, to stop -ENOMEM under a full TCL ring. Its
handler serves only the TXQ it is handed and calls neither
ieee80211_txq_schedule_start() nor ieee80211_next_txq(), so it removes
the deficit round robin that ieee80211_handle_wake_tx_queue() performs
today and forecloses airtime fairness on this driver. This series keeps
that scheduling and adds the airtime accounting it needs; patch 8 handles
descriptor exhaustion by ending the round on -ENOSPC or -ENOMEM rather
than by reading the ring pointer once per frame.

An AQL enable with a custom .wake_tx_queue and a tx-completion driven
push was proposed for ath11k in 2023 [2]. The design was right. What it
was asked for and did not have is the measurement above.

A related mac80211 change is posted separately: the airtime queue limit
is the same for every station, so it binds before the deficit does and
airtime_weight has no effect on the airtime a station receives. Scaling
the per-station limit by the weight makes a 4:1 weight produce a 4.5:1
airtime ratio on the pair above, symmetric in both directions.

v2:
 - add the driver TXQ scheduler, the completion-driven round, the receive
   half of the airtime accounting, the round-ending on descriptor
   exhaustion and the completion-handler budget (patches 5 to 9)
 - patch 1: state that it is a prerequisite for patch 2, and why
 - patch 2: correct the claim that the airtime estimator returns zero
   before a rate is known; it falls back to a 4 us floor
 - patch 2: drop the assertion that a driver scheduler is not needed,
   which patches 5 and 6 refute
 - patch 4: take the airtime TID from the completion and rate TLVs when
   the ack/BA status TLV is absent, instead of charging it to best effort
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
  wifi: ath11k: stop a scheduling round when the hardware refuses a frame
  wifi: ath11k: budget the tx completion handler

 drivers/net/wireless/ath/ath11k/core.h    |  5 ++
 drivers/net/wireless/ath/ath11k/debugfs.c | 12 +++++
 drivers/net/wireless/ath/ath11k/dp.c      | 10 +++-
 drivers/net/wireless/ath/ath11k/dp_rx.c   | 42 ++++++++++++++++
 drivers/net/wireless/ath/ath11k/dp_tx.c   | 26 ++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.h   |  3 +-
 drivers/net/wireless/ath/ath11k/mac.c     | 82 ++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/mac.h     |  1 +
 8 files changed, 168 insertions(+), 13 deletions(-)

--
2.51.0

