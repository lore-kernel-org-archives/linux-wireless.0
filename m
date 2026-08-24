Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C58432E8D
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581472; cv=none; b=IBp1lpiohX2SMvaYue3E+e7RaENHB7MThA5TuPtRpoSSYq2ecM7KLYk36zsMpZQdFkPXoAHs0cRySAevQAQzLDalAT93RTDBIk1SoTBN3bUNjF8M8HxFF06srcvi1256KbxxXJy5TqseK4i286YB+9B3bf8zByb+bbswzpm1C+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581472; c=relaxed/simple;
	bh=im34TzSBvMs+VxSkzP69y69BJEr6lyQIVj6pgsKkYAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0d8Wdk9uq3YhZY/8b3/zDfpTCt2LNe6L333+GBF0Z3vj3LYRHIR/MhJOo1Emc9sfTLdyjitRg3zbWJRu5ZdA233RLnjjPQ/9s0CKVZ6+k7603H02Le2jMkFGKP3VHhgGy1l4mi4QPsYoLC4a9zBreVdUghMnmunlCyynOaqpL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=f2410GRe; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="f2410GRe"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a36982a875so5303177a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581469; x=1788186269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1VZl1PgTMrv9AbBgLJ1P6kkw01P+MG1RQDwfvaSet2M=;
        b=f2410GRed2o3ipO0+ImxgAlJVcw9dytub7Ue60fqUBomXRr2Yoay3iEOIGb7lmH3fy
         lJSU0G6SRPKA/5zZ2j6J5rETAoLQYKvSaUWjxYJ7ULuxfjnhhYuY2ux4XQUwMLoMUKJy
         Bf8m6+r54lYknVe7xflEyGR9tqE43NcCEZxoOymeaDpl08SnvG/Z+LQ4AYu3wkxdD3em
         d7u85LaazmSvoIHWIbIWxQAa87XZBD9RZEbOg9rYdTixzTsmNLYvrBNU6Oct/V+9M6nZ
         vGkNi+PvkaNscy5gOpJrHpXch8povCDQqBQEZMadOrcSgY676rsNBu7hB0IHf06Q4aJ5
         H+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581469; x=1788186269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1VZl1PgTMrv9AbBgLJ1P6kkw01P+MG1RQDwfvaSet2M=;
        b=e2J80RxM55crNkEe7iJDkuBfbyxkyDBB3S4cUOOTpV1Z5bGi73ccNiIsVvQIhtz2cH
         7HrVFOyl0mnCEFy9ZNL4pTRYVJtj51SLwXc2NOyNszR+r6XzltHeUdJ4FylI1tNX5Bk2
         zRRroecsBG9yUpr4xOOhEjApMT6ywI63t+c4s4zfttNXWMkiomUzey6yVFJQdLyGM3Dw
         t/ywmBYd834/v58CGLl+w39rBw/iuUVY6/3TMsmd/ABcev0Emfma8Zz3d80/wBZcngiy
         1d0u/opHsYk4y3yFdXl/HVF0SaUlA/u68uLA/fgWHng3QnYMStutzoPXjJl+1pa0TytD
         +aMw==
X-Gm-Message-State: AFuF++nf/IinCU1sjI0Z+O2ryDGo1XQVZH8SbrSUqqoyVPCzBHUrrOtO
	n8t5mzjuSVGdsjAGWMXgZmSA6g9UqhLDMBJb+xvBq4f/XSnkeUkUAP9tLxt4i3LCcg==
X-Gm-Gg: AR+sD12yiIMjrg3BwlwpGAzNNpEqtulaqLzldSbUBNJEFgr9kBeFjt8dy+iWOrfML5b
	KBisYy+CFiFoYtyHWHYUsAUr/vnurAtQRvupSZfIbfvS4Erx4sKYSVS7iVflt0+et+LVRW9q/zv
	sPJVm1g2aMtf3XcMgzTSd/rlkUXKuf7voEWsxAuPTpk24I/YHHglvvHxATpR0oRLrYeAVGRlURz
	t/zDt/yw0G05lnW0/GmNg252o4xzUHGaPzpv6Hcm8zqk/njEpLQwkFyTxWlfhuO1aX729mo/efF
	i6uPTy9hNJqWYLYNZEG5387LweXyZn2YTFb9vZVjHsx6pnQkaN278BreF0PJUqaXjDiAVajQ+bA
	KkMglnJc8Hc+CYEfOWrB1enVnUnAZPq11DMJYZ9xs6cXsQPyUOxNheCByc3Yo0rES8JDgmg+SXW
	hIZzP0a4b/1pVbRN8PcYXTIixpSw33jjXd7p+5Xmw82NNEqUZq+GcZbELQ4OhJnfjoyufkzT9ef
	sOtYp22OIF+AvcL9XmvPiJOV1f2EbfyBm6tI5CS0sqo91eob/1XTo1Y00FJYCEkN9sGeUzHEWfE
	YZfQE/R6fm8BHklSwRKgjENmrOFmH2JnjB0D8xlTWlpV6HM8yXDdmqYdMbI6to6O+KI2+3jZljM
	288iGncbfZ4qE4ciPi4BYPQy19YeXVfuHLxwk89E/5JmP+EoYCYQVeYYmopVwzmVWkr6jJFt8
X-Received: by 2002:a17:907:9629:b0:c24:d6f0:f4a with SMTP id a640c23a62f3a-c24d6f1021amr378846266b.10.1787581468455;
        Mon, 24 Aug 2026 07:24:28 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:28 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 1/9] wifi: ath11k: free tx skbs through ieee80211_free_txskb()
Date: Mon, 24 Aug 2026 16:23:42 +0200
Message-ID: <20260824142350.1757379-2-julius@bairaktaris.de>
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

ath11k_dp_tx_free_txbuf(), reached from the HTT tx completion handler for
the REINJ and INSPECT statuses, releases the frame with
dev_kfree_skb_any(). Every other tx completion path in dp_tx.c hands the
skb back to mac80211, and this one is the last that does not.

A frame freed that way keeps whatever state mac80211 was holding for it.
A data frame whose socket asked for tx status has a clone parked in
local->ack_status_frames and an index allocated from an idr bounded at
8191 entries; ieee80211_free_txskb() releases both through
ieee80211_report_used_skb(), and dev_kfree_skb_any() leaks them for the
lifetime of the hw. Commit 29d15589f084 ("wifi: ath11k: Cleanup mac80211
references on failure during tx_complete") converted three sibling paths
for exactly that reason and left this one.

The leak also breaks AQL on a driver that advertises
NL80211_EXT_FEATURE_AQL, which the next patch makes ath11k do.
ieee80211_free_txskb() returns the pending
airtime the frame was charged, through ieee80211_report_used_skb(), and
dev_kfree_skb_any() does not, so airtime charged at dequeue is never
given back. local->aql_ac_pending_airtime[] rises without bound,
ieee80211_txq_schedule_airtime_check() stops starting a scheduling round
for that access category, and no station on the radio is served in it
again. Without that feature bit mac80211 charges no airtime, so a tree
carrying this fix alone sees the leak and not the stall.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index cac970c92806..52c4a9924a31 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -305,9 +305,10 @@ static void ath11k_dp_tx_free_txbuf(struct ath11k_base *ab, u8 mac_id,
 	skb_cb = ATH11K_SKB_CB(msdu);
 
 	dma_unmap_single(ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-	dev_kfree_skb_any(msdu);
 
 	ar = ab->pdevs[mac_id].ar;
+	ieee80211_free_txskb(ar->hw, msdu);
+
 	if (atomic_dec_and_test(&ar->dp.num_tx_pending))
 		wake_up(&ar->dp.tx_empty_waitq);
 }
-- 
2.53.0

