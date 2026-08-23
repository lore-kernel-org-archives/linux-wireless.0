Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4FA279DAD
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 19:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787515060; cv=none; b=Rt2jdGj5i+Z+8Du0sFLhvTd83IfsSAnLT6Vk/Par/EfPwe2lc8QWJMWYEBB8TeOMcaEONRCjCcvQ88xgLYfbEvxzBavd+2rK5NKZLLGX8vRLfPxp1nJbYX9SThkc3hNSue3GO+weBEsVtCioX1+4M9haDem/FNbkysy7DlTBODY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787515060; c=relaxed/simple;
	bh=MurUgjbYoa+iaHpFq7oK29Jqge4F0pkH/Iuz5Wc3ZFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c1sE17kZNft2oYAzLIY7ptPU890HfecOzl4S+kajL2yGF5w0Isvgof+P0TzmK7+fMBoI6TEOyL0ZMT7CxvX6FJq9ZH77HF9OtJvx3ZcNxckdhYN9iubk5+iT3/lssWmTFNNuh2F0bArgc2MEgGClm1DKaS/DkowhYEEusvyRVLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=w0KB1jHX; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="w0KB1jHX"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c207cb16cf5so434398166b.1
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 12:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787515055; x=1788119855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AMG07QQWS+s9tSGkNXtvc6vnCfKc2sWGJhO/gRex6GU=;
        b=w0KB1jHXhoOHh7TgFRIPyYf9mwRITP6liaws0tP3/FQTqE/e/r0SKCinaolKr+4Lpr
         GP0GPncvu1V/ENWTlmCk/fv8lnpTyBoSemh0t8OkuDNK/K+D+0HdyKHy2/HO4Sp1+2uS
         JyL4bOeJKiKi3b/AyUqWwRJkL4WfesiDVTMgI7zyhUhhwpMrlIPdjS3gCt8Qbb4DhdJA
         fS7Bfjy2tThUcXP6KdhP1fZGCo1D/Y2ePko/o9L6SHg5TJX0gfqCHN4MWG0vFlPLe276
         a4B4Q3xM/+z0eR6ccXVrELxg244N3C+nh4+NnVwqWRmxPk40Stv/sUCjkzl8fF1tKduq
         MEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787515055; x=1788119855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AMG07QQWS+s9tSGkNXtvc6vnCfKc2sWGJhO/gRex6GU=;
        b=QNMGuuqYR0LxP5CPJkVlhddtB4OPegaQF9PXE7hK9gwDoxSVdaUzXImmnNwFB1K0vJ
         +6WHPjjEiwOa1E43baFvON15n++UExUZ8UtVW3ujDaJroS7pe8VtzalDP+AQifLrSc9/
         iYXiNr8cUsY4z39n1J9lJwAfYFiaFAtPvmjReG+cw3cFnk+vDan7V0PoArML5ECFG/rZ
         S4fj//+JEpsQBTWuw6ydLXKdMpHJk17TLoQdf1tHyKbdI5ySNydfNzGgtQ7cR6tTCkq/
         wRZlACNoW29+FyIzL9PaUkxfFKndiIWYV6a5JnR+2vIV42LMHKuw9eYEicKvAwE0bGCp
         BEVg==
X-Gm-Message-State: AFuF++nzc9+46vVSpgWakAKLxr4SdriXDST88fWdsLo9Umi1eGa1D0QU
	L6Xg5v0idQxliLPXZMpiLnJv+4Wgv41QH7YxaowYtX2bAohBorV23NrVhB4cR6gilA==
X-Gm-Gg: AR+sD13cqN1xe+XHywAT02+0ANVpRHbj4Z4eYuNT0J7mz92nP+wor9nyzAML2rx0n6d
	s5iA6E5M9JmB9szL4+Ax3hYbTUJZq8Ti//qdtbvMP4D1jFNn+b1IpjJmjbt/k1p+z5NshFuwT1r
	jU1O2i3xColW2snJGO6o0/29daCuc4GRvL4rupOTDK1NumFp2E9mWFZnfA1gNHuXoBDPsU1nFC0
	UYD5KDvT/HmzPOuzQr6roJAiprB3+R5ksv0nsZX6VoSM4gqtHVdQNKiciYdJpiqmfGqXDYarNUF
	eKxstru3vkO5LN2XVU1is0aEJe+PCr+bg1o8AdpOhWQ2OA5IUiniN+qo3tf5KAz7z7ywZnX3AfY
	u133dVIjYLj2/7khPV74VDULYzrSA7DiGGCP6kQV/ditd67y/T92YOkGV51+lbVcVIbnU4V6UwU
	bqWp7I9QcNogdeEGABEPqrFigYoewiHmWa3ILgrZvim+FBGZw1IyhqlGkuW3iq8CdvC+RrkgipE
	Z9eYOvNTrTyDqBRWthaQc2KrnQLCAHe7oLQdaTMY1Svp9GwuTqD+DzO64VGY3xN1J1FvfIgXryB
	oo3yKo0VYowhLA+GFg+IiMQUEY/nzzSQxQ5gMWb+SdXMSEYYFAoAR4oomgoxazS+GG2AlrGk94J
	POZ60GswXVtX5lB1R0nkPKcBo1RDixVdQ6HcPrdnCFabPQwonJjixzdOabg6Ep3x8MhZFLSjiw0
	Z1PIT0hOguoUtt
X-Received: by 2002:a17:907:a49:b0:c21:4393:c41a with SMTP id a640c23a62f3a-c246a606cdamr2258331766b.11.1787515055057;
        Sun, 23 Aug 2026 12:57:35 -0700 (PDT)
Received: from Desktop (pd9513a95.dip0.t-ipconnect.de. [217.81.58.149])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a8edsm889532666b.6.2026.08.23.12.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:57:34 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v1 0/4] wifi: ath11k: enable airtime queue limits and fairness
Date: Sun, 23 Aug 2026 21:56:59 +0200
Message-ID: <20260823195703.49198-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k advertises neither NL80211_EXT_FEATURE_AQL nor the airtime
fairness bit, and every user of either inside mac80211 is gated on the
corresponding feature. Both are inert on this driver.

AQL matters here more than it would for a driver with its own TXQ
scheduler, because it is the only brake. ath11k uses
ieee80211_handle_wake_tx_queue(), whose wake_tx_push_queue() drains a
selected txq whole into the driver, and the check at the top of
ieee80211_tx_dequeue() is what stops that drain. Without the feature bit
mac80211 holds no backlog at all: on a saturated download every queued
byte sits in the hardware TX rings, where there is no AQM and no flow
separation.

Measured on an IPQ8074 AP against one HE 160 MHz station at MCS 11
receiving 280 Mbit/s, read from that station's own aql file: its BE queue
depth reaches 6356 us of the 12000 us default limit, and 2972 us when the
limit is lowered to 500/1000 us. Without patch 2 that file is not created
and the limits are never consulted.

Patch 1 converts the last tx completion path in dp_tx.c that still frees a
frame with dev_kfree_skb_any(), leaking the ack-status clone and its idr
entry. It is independent of the rest and carries Cc: stable.

Patch 2 advertises AQL. The rate its estimator needs is already kept in
arsta->last_txrate and already reaches mac80211.

Patch 3 exposes the outstanding-MSDU count the driver already keeps, so
soc_dp_stats can report how deep the transmit path is and not only when it
overflowed.

Patch 4 registers per-station tx airtime and advertises airtime fairness.
Unlike AQL there is no estimator fallback for the deficit, so the bit
cannot be set without the reporting. The fairness it delivers is coarse
for reasons stated in that patch, and it is last so the first three can be
applied without it.

An AQL enable was proposed once before and left at changes-requested for a
commit message that did not say why or show a measurement. This series
answers both, and needs no custom .wake_tx_queue: ieee80211_tx_dequeue()
performs the check itself. It is orthogonal to the in-flight
"ath11k/ath12k: implement TX flow control" series, which replaces that
callback for an unrelated reason and leaves the check where it is.

ath10k and mt76 set both feature bits.

Julius Bairaktaris (4):
  wifi: ath11k: free tx skbs through ieee80211_free_txskb()
  wifi: ath11k: enable airtime queue limits
  wifi: ath11k: report the pending tx MSDU count in soc_dp_stats
  wifi: ath11k: report tx airtime and enable airtime fairness

 drivers/net/wireless/ath/ath11k/debugfs.c | 12 ++++++++++++
 drivers/net/wireless/ath/ath11k/dp_rx.c   | 10 ++++++++++
 drivers/net/wireless/ath/ath11k/dp_tx.c   |  3 ++-
 drivers/net/wireless/ath/ath11k/mac.c     |  3 +++
 4 files changed, 27 insertions(+), 1 deletion(-)

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.53.0

