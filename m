Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E42F361952
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345752; cv=none; b=BlG3kp9J+hX4XjKz2Z5OBkb2ZhKfup2VKVBofQMkkePfeHjIROE5xfk9oNLDuDNbJEeD8PlhgMDwvYMlPLlGRu8FkdMoAd/y5XQu8+Fw7vzb/LAOL4Il0vwLoh/+h4/Wkr2zp5VL7G+/ENki6Nt0qK1Xw0DYgHTZQd387NzNkXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345752; c=relaxed/simple;
	bh=BwWMyvrKeF1oP82YqETjYoJP9xag1JdR0itv32xJpVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L2UKTUkZtUW1ujii7eu1b3jj+vZudpSHFZYPXVl1H2VHPiXfC92gg+Q06m3FxndWmzHV7iv1fkWdETHC0f33QyJfKDclp1AgUSvLfZ9R1akLyACRvEBmqIYFbK0F6VJCEhvzCY3KMoZ95By9Q7jo3lw5NwY5EqZYSV7acsm53e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PWhiDE+Z; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PWhiDE+Z"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4086e892a4so163981566b.2
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345749; x=1792950549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=S4WyeWiluWZ/Mjjk4RgwTvDiC7qiMUMmbWBorO5RZpc=;
        b=PWhiDE+Z5iWLd9DsNTY5+s32SqQBCm4ACIanhxre9TxqGiL16QtQa/yKBzCSmNJUCb
         Q7aEnddzHR9WrLt3hxU9LvXsyHiJKPhpQzf0u5U78MyL5iGcoz8lWmQFKiNRdxrWG3U9
         vsBmf/P3y9q1BJaDGT789060Bz7ZemBk1XEbqQyS3t2+/kTWk5UajRiBXCxRCmilzQDC
         aBbrPqn/Bu6Pl+8XTK5nThF4um4bHrUS9W1wf0tFICHfA8z0pO4vT4Sdi01bj2SBQ2QT
         +pLPgZkOZad9U/58LxQpa8PxhGrprTra4bW35qJg8pEQ1V1flU9gMKeACSIP7CAWqLnw
         58FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345749; x=1792950549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S4WyeWiluWZ/Mjjk4RgwTvDiC7qiMUMmbWBorO5RZpc=;
        b=N10DtZBNU1Xh8jgJcM7xSdviHknWYPWPZIH6qzt1zEg5ZXIFp+D5JIcgbL+202dK7s
         +9u7pzu0cdRXbgXAl45eiptQJDArEM3R/f12LjdnRKksENTJh/utqthe6ns5NAZnLNJ+
         IWQ5ozh9qTUJqscpRk984mBu4AGQIhFmouGM2l9u/rEPbgPA3YqUStf65DXXJtQxht1g
         4tphn8hiY7UzXWMR85lJoi9p5qPJN4zdpwgt+QfaHlTfbVq+38G9NCuIuNZ0SMjDEl4z
         CG0dkzKs1LQFrv4tT8fSmVpqgsRHHKoNDFFow/xfBrdZZ3eslcz0EldKbY41PksGpUB5
         6a4A==
X-Gm-Message-State: AFq9FYLr+9QhgtBXbmsmUnip37NLpzSPnqs9yPlCIWHTmsfeMViHXeaX
	CWn2FPz+L+bZHtypPN7R0pNpbMSIFxZAaKGBgAT+Txm/l4i5o1/4SztOS4iPlvqnBA==
X-Gm-Gg: AYBFou2x8EBXt9xj0ZUfgzD7TfytMtJF9pX+21ukwIgu9ac2LzOf5vBzw73Z/pxrkD7
	5gpcnduojjWShXhW2QhmNmkKggd53a9TAHMQEu1AB7Ks21eUsKPlbrTrGNOlXE9e8Mq3RcQpVDX
	f/WDyjFeTQ0O0mJJCESBRWtp2wF+IepBLd1UZjPIefLzOYbqG3eWCGrqDHcM5b0BkxmOVC+P8lg
	hHvPpmKB7IA1IGw2ePYvaznUK2xUnt5O2xy8cuCNCuI7TyiHU1dYZm4aXZpXzhprxvAwYdpzFAq
	p7Jz1ukxaLz3MkzyBnWEIkLHwZdiXEu9NdIDLB3Zw0ckbCni4MMOpJB54Cxi/o/44onY0TlY/KT
	mIMyrmDlcad2/XaFlU9vu0EMNBic8Tfod5Cn/WxvajVZC4Zt4UipJaeqcJ4lNlQTBqtLuN/bjpu
	Y3n055GhrVJmGZpl9jVvjUDo3Jf3P4JPt3EflE7vRNg2QxSWev4omojAHupVI1/Ayt3tX+Ba2HN
	aC6iZYszXpHXFp/MdCWXL9Gs2wx2/XC1iLL3O5iayVIIaMPEVxkN3llDEqXgcvucdq5D1ayBKcI
	e1SHDFJHF2ScTcYDfnm3TwO3qW9cthAUhnYdJj1aD0Z9aerbiykodjuVSfYz8xng7yyhpTtjTBC
	dmtkopORMXRD0XmFn8D/XCY+UfHJSrs4Fhy7vPMVJBlp36/esppA70gYHkzjPx4k1sYxBkNQ4h/
	8xoaVa8XyO
X-Received: by 2002:a17:907:1c8f:b0:c26:1649:47a5 with SMTP id a640c23a62f3a-c419f121280mr364849866b.27.1792345748685;
        Sun, 18 Oct 2026 10:49:08 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:07 -0700 (PDT)
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
Subject: [PATCH ath-next v5 0/9] wifi: ath11k: airtime queue limits, airtime fairness and a driver TXQ scheduler
Date: Sun, 18 Oct 2026 19:48:55 +0200
Message-ID: <20261018174904.1757161-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k sets neither NL80211_EXT_FEATURE_AQL nor
NL80211_EXT_FEATURE_AIRTIME_FAIRNESS, so a saturated download queues
every frame in the hardware TX rings, where there is no AQM. This series
sets both, registers tx and rx airtime, and runs the TXQ scheduler from
the driver and from tx completion.

IPQ8074 AP, TCP download from a wired host to one 1x1 VHT80 station,
default limits, 20 s, three interleaved runs per arm:

                        Mbit/s              sender RTT mean ms
  auto rate  without    92.9, 94.4, 94.3    111, 232, 231
             with       93.7, 88.0, 93.6    124,  51, 167
  VHT MCS 0  without    21.4, 22.3, 22.6    587, 550, 526
             with       22.9, 22.2, 22.3     44,  42,  43

Airtime weights are accepted but leave a 2x2 HE160 station at 45 to 49%
of the airtime against a 1x1 VHT80 station at 1:1, 4:1 and 1:4, because
the firmware serves every station with frames queued in turn. Ending the
round at 256 MSDUs in flight, as Toke suggested, gives the HE160 station
65 to 80% at 4:1, but at 1:1 its aggregates shrink from 258 to 100 MSDUs
(one run) and the two-station throughput drops by a third, so the series
leaves it out.

The series is based on "wifi: ath11k/ath12k: implement TX flow control"
v7 [1], patches 1-3.

v5:
 - rebase onto ath-next cd026e68fdbf and [1] patches 1-3
 - patch 5: the free-slot check runs inside the round
 - patch 7: charge rx airtime to the PPDU's TID (Tamizh)
 - patch 8: a round that ends for lack of room restarts on the next
   tx completion
 - drop the dependency on the mac80211 weight patch
 - v4: https://lore.kernel.org/all/20260908135319.754140-1-julius@bairaktaris.de/

[1] https://lore.kernel.org/all/20260917064825.12747-1-jtornosm@redhat.com/

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

 drivers/net/wireless/ath/ath11k/core.h    |  7 ++
 drivers/net/wireless/ath/ath11k/debugfs.c | 10 +++
 drivers/net/wireless/ath/ath11k/dp.c      | 10 ++-
 drivers/net/wireless/ath/ath11k/dp_rx.c   | 31 +++++++++
 drivers/net/wireless/ath/ath11k/dp_tx.c   | 55 ++++++++++++---
 drivers/net/wireless/ath/ath11k/dp_tx.h   |  3 +-
 drivers/net/wireless/ath/ath11k/mac.c     | 81 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/mac.h     |  1 +
 8 files changed, 175 insertions(+), 23 deletions(-)


base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
prerequisite-patch-id: ff44eb6f1d673e75bc013e3ffc870d7d30252c17
prerequisite-patch-id: 59bd66038e87bf2ee9ecb2a916286685c789f865
prerequisite-patch-id: c86d3c9047c851f45b5d46398850c9d810d82258
-- 
2.53.0

