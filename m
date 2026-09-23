Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453E5326A0
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169804; cv=none; b=BQtMdVrHyeofF0IO4EV0LnnRiTftA3uv5HPe9/vll37nSnEodeIUt22qi5UvzVpVMo4wQGaiaYjhor4cwStIOxSZ13u3xEzKInrSeVK1mrCR21WPXDeSt6KGTP5aW65Hv3Mo1a7rab+pNmw2J/uukOw7pjVbwekPry8rR8rDFyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169804; c=relaxed/simple;
	bh=nikI0ifAlEVnI6Wh4wMGcQRCHZPLhyk39H3rDhCEdMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3zS5zUlFwk+clZo1Zl/9jcLsanWXWOTRvj0zY6p/ENRDz6sR7q2RQkpO+lUheoN4KLBxHn/uYFp23bzrtEVs5fUjLFSTzxuXRdqRtOR1Yi0HADvlkxwxsiVZKXLPpd5DolOWkyMG1eSR4dnwV6T3c/93gZmJK3nyTULQvxJ7rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOxyStQ1; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOxyStQ1"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-982838c4cccso650350241.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 06:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790169801; x=1790774601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X9XcF/3IRZUDlfTjnlc5xrlEPXzRZ38t+QGTj72aQ/s=;
        b=gOxyStQ1gSU1Fdm9pPEGbsMsSwQQT1A/Zd3uGbGU/4TpGAvGogg+8WcIBVL3omackD
         kzzXcgJGXuD/1oZrfW0j+N5QNkFq0ygot9EbQC5YqNBxHydNF8lVxV7uOl+qMlwiE5OY
         0mdbyE0R3dposC5x4vM+6BYXX4xQqrFpF0OwMjD1LVPwLvJZ6WsPKlkmJJ99NXWhaix/
         QJXq+DgiOceg7YozkQ/2/qOaCQYYae1aWVDJR29Fmh3sdkMTCYJRyhtpEFvDOJ5Ni65i
         eTYhrZBKIRYQt+FKs8F7nFf9aWxpm8GsMucaLJ1Lnw3Y/irKHN0pTZjm/J0XgzPEtJBT
         /f0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790169801; x=1790774601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X9XcF/3IRZUDlfTjnlc5xrlEPXzRZ38t+QGTj72aQ/s=;
        b=kFsggM5WDyVJM5Z5H27SQTzm5fhsUTq+LfXVZA4QpG90fwu1eAQYYDFr6/2BRhjvRL
         6gMdkMZUzNj4MwLnbEN6LOGQeUL/8u35l5pvnQovn48hfJAXHv2gQc714ADqcYOH9Vpn
         nQ67Xxa880DtP5qC0ecM9FFXikvBDUqyhMv5ZBcjVBnxKB1SPeQcMdkMNKGMYihV8m5K
         uw5VyCN/XYT4qp8FO+Hwv2wPJqGhl3hUjlboXn8fts2XK781dcwYRzhS+WTdOnrQncqf
         2VDtE6koKYgPgNFmWKyaIbh0i/Vsr2K1bDwL0/+ykvRhQjraqfSV45nCdziiW3tS3KC9
         x6KQ==
X-Gm-Message-State: AFuF++mQXMKFO3UA8aKsgrkoN0PtXSpIL4SayAI7ixYKJ5ex2n8O/2dc
	SRVL2jNUDZqv9rdl6FZJXrvCvp5dOQfodAkZIih24I2XWGBbEA3fv3NKeyZ5MOJE
X-Gm-Gg: AYBFou3DtR2og4+4fu2JPnvQ+PxvvF4NTqny1NEK12J7m94a6TaAE9XQNw5qIa5Dx6w
	p90G/IkgC/c198DQM9BFs5+1tT7PXQ8AXxadG0pZMS4N1DUmUOio7g3/FQExxiAasWDJO6X+NIG
	DO9OZeP701X57yj1BODYPmpZTTEUXZNPTMejUq4Zp6K90YgitKPFB1B4VPVCdY8h8fHAbJjSPPw
	gi5fupnPeDXW85PlqBD0mpav6Ny2DskkPo15W94JqRBOWpnKSWclnrNBT70Mw4zPf9yywZ/tBX3
	Mkjq0rPfXdaKaGsPMoGisEF8LhbvBnTzR2EbD31PmXx/L1l4f1NTJ2/qn4W1Ubiqg8y2lQ11MR6
	59pFLlSGDHwzwYq4WLYZINPJIpwjQMvE+GEJCwRhwbonzUK/cMmWS2p0pXQEXprvnsmbbwMyEKi
	/xydChRQuKAgTImA0GVfrrK/bQ+Mbq7WqVPzF4LhnEKoRR7qfkJA3Hy0cmEpm6FNVMU2GyCMR0W
	38ka/BJ54Dt7FM07qEmIRAQqhh9wHlMbca19NW3sRlZSwThug4Qu0h62QE=
X-Received: by 2002:a05:6102:41db:b0:7a1:f2b5:6465 with SMTP id ada2fe7eead31-7aaa080ee21mr4051183137.34.1790169800671;
        Wed, 23 Sep 2026 06:23:20 -0700 (PDT)
Received: from localhost.localdomain ([190.177.169.131])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-98517a8ecaesm2910924241.12.2026.09.23.06.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:23:19 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: [RFC PATCH 1/2] wifi: mt76: let a driver hold a station's tx queues
Date: Wed, 23 Sep 2026 10:22:55 -0300
Message-ID: <20260923132257.8729-2-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923132257.8729-1-pcristian292@gmail.com>
References: <20260923132257.8729-1-pcristian292@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some drivers know how many frames a station has inside the hardware
better than AQL does. mt7603 completes a frame to mac80211 as soon as
DMA has copied it, so AQL releases its airtime right away while the
hardware may keep hundreds of frames for the station.

Add MT_WCID_FLAG_TX_HOLD. While it is set, the tx scheduler leaves the
station's queues alone, like it does for a station at the non-AQL limit,
and stops a burst that filled the hardware. The driver clears the flag
and schedules the queues again when the hardware has drained.

No functional change for drivers that do not set the flag.

Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 1 +
 drivers/net/wireless/mediatek/mt76/tx.c   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 62b41c8bb..d03e66c2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -362,6 +362,7 @@ enum mt76_wcid_flags {
 	MT_WCID_FLAG_4ADDR,
 	MT_WCID_FLAG_HDR_TRANS,
 	MT_WCID_FLAG_TDLS_PEER,
+	MT_WCID_FLAG_TX_HOLD,
 };
 
 #define MT76_N_WCIDS 1088
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3707ee19e..e16a380c6 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -534,6 +534,10 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 		if (stop || mt76_txq_stopped(q))
 			break;
 
+		/* The previous frame may have filled the hardware. */
+		if (test_bit(MT_WCID_FLAG_TX_HOLD, &wcid->flags))
+			break;
+
 		skb = mt76_txq_dequeue(phy, mtxq);
 		if (!skb)
 			break;
@@ -605,6 +609,9 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 
 		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
 			continue;
+		/* The driver schedules the queues again when it lifts the hold. */
+		if (test_bit(MT_WCID_FLAG_TX_HOLD, &wcid->flags))
+			continue;
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
 			dev->queue_ops->tx_cleanup(dev, q, false);
-- 
2.47.3

