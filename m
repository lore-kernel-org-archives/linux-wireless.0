Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3622D3A75
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 19:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787515059; cv=none; b=KIcLx3d1qDU+k74ZYIk5Yo/UmCdeN1t7fhfjHiHOOOX0CKYiS+O8Bd9gmXLtKvBRqGVoG6F6DJfB3bLlb7SjPsBw+vlQQKKpCzG6ONudrhDHtEHdjALgVSFBsIAlvU1rm6phM9A1p8APgE44B6pOp0laRuRO1lninafaZhk/gW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787515059; c=relaxed/simple;
	bh=Gk/7UroqYu8xW3qXwaYdRfxdTRLSMms8GPc4wLd/IMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz2kNCW9jtwrDjT9/5d77tUR5zo1Ohlfdzj62F4NKdisQuHoBunNnlTVK/5CojR3S5xHEObcAgSvLF7sB6cMm1thRlwQEdELtiMxr/b0LrzPccyzrFq1Z+qsTy/ZDJ/1iOq8tiv97b6g4XdoIxoM0ETtUXm8xG2/tgnqMskU9Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=vTBzdOLS; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="vTBzdOLS"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1670dad7a8so486087266b.3
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 12:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787515056; x=1788119856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drU16NpqjOVFYwneScziNmmGyeG2YnXzmWqCFYgIDxs=;
        b=vTBzdOLS6vWwc8BKf2ADBa8oH1s4o6pG+Zvg/RYI73ELvkZrF6G8EEf3IQ6DY7ysuQ
         iLEkYs+rBdAgYjgoS25h6YjlIXn4RE7C3zCvcPZL5uXu1xZ8/sNNeJ7z+E+Hw8+im9LU
         O3nZul1T+Jz/ItYRI6XLWalVeWxvghmHgXazNDFuRbLKdf0m4qSakM3ZslRCEMDD9TbO
         CdyU33POx3ElrxkDQCGO3AE5uVj4n9luABUGDEaLvWT0mdXmiJaAh6T5gU9wLtPR+Rdo
         qOPrkQ55B3W+fkohUaI5f5/SzMJAUpN/uiRGt2Kc74dxyItLDEXKxQ4lLlGNilvrqtDa
         Qsng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787515056; x=1788119856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=drU16NpqjOVFYwneScziNmmGyeG2YnXzmWqCFYgIDxs=;
        b=BmJlPTvSqkJP/FbeNtj2WvOk14dTP3W4+N40F2buOAq+++SglVvBqfGIHFa5XZYjqA
         skOr2ac6XeiXgawIweQtbZM67WwDZ1SFu0tqfYjjvjmgr/cltNNFcVBGBo9PUzuSmyph
         6j0W8gAInshARbWsa725tygm69ojSe4yjSHpoDu5W4m7pto3TkrSw2+0FknrgYrP9mq7
         a6IUMVladMKhn8TFifPcUpJ8+AKmsdj8snM/TEM0TCyH5m6y5E0zlPYfmnmQAW1x3K2k
         VDlZRIWA+rvAohNCayp8h5Btjj0EbQPR9jaSSiz4QdujuQ2hvgEyP8BTYg9LnVltgkwo
         vVvQ==
X-Gm-Message-State: AFuF++lYYtmP564swQ8IrK6AEkUBuS8UQ1qFQ0YHHjeMuTGLM8U9qQxw
	AIAc6iWbaWYmNCZ8mAYjlb5AWRPXCiLQFHWZgNyyvr+us9FGL/O+6Hbv/EaouKx0aQ==
X-Gm-Gg: AR+sD12AK+CkMqbD9O4ML6/Z77JeDLbUq6Ez6y1t7K8SgsRIJEfs70mgkUoriafTmcX
	vRQsTDw25iF2ysnOSa3YLXPcSri18rwi285EH8iQch1hTAuUD9EWgUhhuFmhORJgBJ06kimiLc9
	vTTJzecq03afKvGJuCjyITMj1NLKD3rrYLU/Mei5GNbTj0KjgHrfyJQ2/O/fZ+/3y91UQXeaz8u
	zJjhWV3kdowluCFFNTjvv+fZcOqWeAomQ8OFfjzT8LhuBlJ3OY/2yV8aeAdTW6EuUufgLCZqj2K
	J3aCBBFe3VNLH7mI3q8ZIBS1YqcXHpTuTHBrhzwAPRWFbjmZQ4UfI46IOXhKwrClXIntv0KYVZK
	Hx4+gYXyrnNACf3wr7sqI2yWQnKujy8h2dkhuclouvB8T2wpjl5+SRCqwzQWlmTGJJv8o60c8dK
	sW1KpNk6GCuUVAcs15BTKkhV+/fa0Go/xfha10LL8E8gaXSCknZQqTZHZZV3rS8Qyfe6AVoDPqn
	bg3+Jwqbnn+cdrIwV0eOHpL+tyWoSauBNTEb8lAiJlfybtPSoCesnQPaYKDKPLknerbtCywmeQ/
	VhT1KdMkm5YAUp+q68zwStLlF1ZFOdF1BuarcKOIsmLsEiBHlgT734OHUK/ULVFwX/kEz657GKR
	aV1AclP7Z/V7g2RmOxcT7jDw1bSw8hWY5frWV6mIbSqvhtnFg3GKbC7yOu3qOIhqK7+ELCgB98T
	Hk2BncpVBTA9RR
X-Received: by 2002:a17:906:9f8b:b0:c1f:c061:569a with SMTP id a640c23a62f3a-c246a4c6d63mr2074267466b.7.1787515055706;
        Sun, 23 Aug 2026 12:57:35 -0700 (PDT)
Received: from Desktop (pd9513a95.dip0.t-ipconnect.de. [217.81.58.149])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a8edsm889532666b.6.2026.08.23.12.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:57:35 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	stable@vger.kernel.org
Subject: [PATCH v1 1/4] wifi: ath11k: free tx skbs through ieee80211_free_txskb()
Date: Sun, 23 Aug 2026 21:57:00 +0200
Message-ID: <20260823195703.49198-2-julius@bairaktaris.de>
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

