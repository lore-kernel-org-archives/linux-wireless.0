Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6043E08A
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787581479; cv=none; b=twAR8ArTtJWNrXBRyHJpqOXoUkkyOw4w3hirao3OBeySig9K2vXotHSwJmYzSfRvc32bOsyJKPvpQ5jc7NhuYLafZO2dUiYY4OjRTvgtI9+0Lqy7Pqw5pIx/jlcJP/LKNedJaaKanfoGPNJueDJe0Khl7roZxFxRoA6WFYsTL0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787581479; c=relaxed/simple;
	bh=DSexd66nsNepceLBTnaL8EHu7duCBO+eC5BWRUUqKig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swB4sjD2jXB/IQg70Mhm3lU++Z4CqGONZh5UZ26f11izz3p6BqZZxc7mw65ThjiNKNeDR83QT8hXz+4WgZMZoj/2MV/Jc6kM3NB/iodB3Qi6GTberAAQTxqNOMC5sGQSBbOiTYYeLOuPUz76cfkRr9ALMwxINKm4lrQQkt2zpRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=BU5Efo5l; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="BU5Efo5l"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so8259067a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787581475; x=1788186275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7x2IYwzlbtio5Xh8rRB/sJgLP9WAbcTtyfFVFxSqfyQ=;
        b=BU5Efo5lrc5BGigbcSPhKowHGLAttzUYwlKP/xCmMeLY7dB4hLv+gI4eqMxsUItN7u
         QYjEkmTUOVnexzlBuJvhwFXHG6wjmV9rFaj2HSOZPAY6Kq4ah+nYo3t31aFzBGO0ipy+
         SuCemyAUVnx9zT81Vl+99HI/p7xvlkh2MkH8Lrgoo0hmTNUj6XvWI5ven0pP2t+GyWML
         ZRXhHUH1WQHtElhyIBD4BHGtWtHfXXZg7PxHR4wQCOtsf0NglAkcm5AtZof8G461HAEQ
         E0Qu5poGVy3LlG412Q566s4GqXVp/RtJxDL0KKhwYBUwFJN3IDTIE1MpdNXfCpgP0l4+
         Wh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581475; x=1788186275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7x2IYwzlbtio5Xh8rRB/sJgLP9WAbcTtyfFVFxSqfyQ=;
        b=XIpRMgvmZDWNPT/aY7tcXDYHFibD2GFnXBQaxNWp1DQEtjNuqtMsMGKsIoAz2y+crX
         7oSvZwgjeWQWks8YVypy9a+7OLWAR307bfb6ryUVkb3vsKvSuX8aT/Q3JBcvcf7RGpTx
         QrC8ozRO/KIXGbk2hN4mLUcTuDDLzDmg4me8lw/Kzi0Oe0+ElPPvHxNxjYWIeDIYxl6o
         k5Sk2u0TiPBDiu2qfOmXADfoFMjdeTdjhsJQCaUpc6wLDVBBqXIG6+aLPObq2Xz1+EAD
         Sp6Vf5wMbB/iq+RhCxwrOp2Y6gGn3t2uAIjGBhRiFtsQBMjFTZlYABid8MGocZImdP5M
         yjgg==
X-Gm-Message-State: AFuF++nctDF1127FLvSwU/wLGqmK+VnFgOQY9engSKSe+UdgAmcFIKzh
	PoNtWtXy9CsbZ2hiNpOz/kNv7QB6/L2R6vHyBXxDGb4HcbzI3GVHLHj6eukOCBWdvw==
X-Gm-Gg: AR+sD12tTbzMJgzi0Sb+W2ACpZvoIBDxwq5VQ0GoPEjgQY6xekLXtfY2OnrYaSvR0Tj
	OHGD69FH9T66SB7ZiBhvhhYvoO+inUS5N3Sfh0Mqrn4IvkWF8GITpdvitOXHaQQ8VAPMvsM/nZR
	MnA+MWGZTIfPNOQo8HbRXZEzZkpAdz6IuT3W9dYdJWO1caQXNUr1ewKtzFWUyCg0zXPK6DfYPDA
	2hPCWhXv6DPTohbcN5eYd+qIjAGvO33I7t6nkmwG1pdb3kwB4iWQDdIC/cRnDPBNYMPIY4xv5ga
	BrM35uCToAfZQ47x4L2LUSQECLRGApf8gUwE6pwZpIqgueyYRrh0hsrnp13Hv2LjcwwL1tO1XcN
	nPfJA0mjbYfOGuwE1cLshCYLAmMhc/lDkis9ypYn8/rK0DPTQIGNV0VG5avBw+11CigSj4ivyG2
	Xk0eizSeSOR79eBu4uZW6ctjNNPgHOaD0LN4ipzWR/M/NtjuDeAettDRz8nlRwDB4MTwLk49WRp
	8i3T/RC83J/BsKxrbNymL+dqT8DVfa97iIz80GUzGE7gOKtWUjzMyl/IX3GYTHhizZ49lQ/52+e
	GM1V03k3DzSvkX5a4GsxSNjFSMk0SLUEHDjNTCr0OtFpkAjnDcVkfYnGfQIL+V9uSZIC6lkpuE7
	QOXHSP5vhjmSbGOfxEBvKLgfWJ0y/NgwGh/6TA169JjDCmcd2guwDccsKapKztGvIgGb3NuJoMI
	5L9fDV5IE=
X-Received: by 2002:a17:907:724d:b0:c21:393e:6d10 with SMTP id a640c23a62f3a-c246d5eac42mr2556330466b.4.1787581473811;
        Mon, 24 Aug 2026 07:24:33 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.181.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249672becesm1329890866b.42.2026.08.24.07.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:24:33 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk
Subject: [PATCH ath-next v3 8/9] wifi: ath11k: stop a scheduling round when the hardware refuses a frame
Date: Mon, 24 Aug 2026 16:23:49 +0200
Message-ID: <20260824142350.1757379-9-julius@bairaktaris.de>
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

ath11k_dp_tx() returns -ENOSPC when the MSDU idr is exhausted and -ENOMEM
when no TCL descriptor is free on any ring or a DMA mapping fails, and the
caller answers both by freeing the frame. Inside a scheduling round that is
a loop: the next iteration pulls the next frame out of the same flow queue
and drops that one too, so a transient shortage costs the head of an
FQ-CoDel queue rather than the tail of a hardware one.

Return the error from the transmit path and end the round on it. The
round-robin over the remaining stations stops as well, since a shortage
that reaches this point is not specific to the station being served.

ath11k_dp_tx() also rejects a frame the hardware can never accept, with
-EINVAL or -EOPNOTSUPP, and every frame with -ESHUTDOWN while a firmware
crash is being flushed; those describe the frame or the device and not the
ring, so the round continues past them.

ath10k and mt76 end a round the same way when the hardware has no room.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 41 ++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 150b3a1a9c19..2a70a9c58235 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6499,9 +6499,9 @@ static int ath11k_mac_mgmt_tx(struct ath11k *ar, struct sk_buff *skb,
 	return 0;
 }
 
-static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
-			     struct ieee80211_tx_control *control,
-			     struct sk_buff *skb)
+static int ath11k_mac_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB(skb);
 	struct ath11k *ar = hw->priv;
@@ -6533,7 +6533,7 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 				    ret);
 			ieee80211_free_txskb(ar->hw, skb);
 		}
-		return;
+		return ret;
 	}
 
 	if (control->sta)
@@ -6544,20 +6544,36 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
 		ath11k_warn(ar->ab, "failed to transmit frame %d\n", ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
+
+	return ret;
+}
+
+static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_control *control,
+			     struct sk_buff *skb)
+{
+	ath11k_mac_tx(hw, control, skb);
 }
 
-static void ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
+static int ath11k_mac_tx_push_txq(struct ath11k *ar, struct ieee80211_txq *txq)
 {
 	struct ieee80211_tx_control control = { .sta = txq->sta };
 	struct sk_buff *skb;
+	int ret;
 
 	/* ieee80211_tx_dequeue() applies the airtime queue limit itself, so a
-	 * selection ends where that limit binds, where the hardware queue is
-	 * stopped, or when the queue empties, as the generic handler does
-	 * today.
+	 * selection ends where the airtime queue limit binds, where the
+	 * hardware queue is stopped, or when the queue empties, as the generic
+	 * handler does today, and additionally when the hardware refuses a
+	 * frame.
 	 */
-	while ((skb = ieee80211_tx_dequeue(ar->hw, txq)))
-		ath11k_mac_op_tx(ar->hw, &control, skb);
+	while ((skb = ieee80211_tx_dequeue(ar->hw, txq))) {
+		ret = ath11k_mac_tx(ar->hw, &control, skb);
+		if (unlikely(ret == -ENOSPC || ret == -ENOMEM))
+			return ret;
+	}
+
+	return 0;
 }
 
 static void ath11k_mac_schedule_txq(struct ath11k *ar, u8 ac)
@@ -6569,8 +6585,11 @@ static void ath11k_mac_schedule_txq(struct ath11k *ar, u8 ac)
 
 	ieee80211_txq_schedule_start(hw, ac);
 	while ((txq = ieee80211_next_txq(hw, ac))) {
-		ath11k_mac_tx_push_txq(ar, txq);
+		int ret = ath11k_mac_tx_push_txq(ar, txq);
+
 		ieee80211_return_txq(hw, txq, false);
+		if (unlikely(ret))
+			break;
 	}
 	ieee80211_txq_schedule_end(hw, ac);
 
-- 
2.53.0

