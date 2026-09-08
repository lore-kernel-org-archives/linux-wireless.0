Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5A154938E
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875622; cv=none; b=awDn/KD+FBxAI7mPCRDs5PaMPVCSQgUXsonu9Xy9rFLMcyeMe8XmX/i8ZUqetFX1GDWdeMvxC0HS2rlwND3bZ4OoAjzFnfCa2GnkOmXwq6ts3MGUNXK5rHUAQ5W67HdRTmU4TmaCsR/v7V7bO5ilEBBNpo9aphBRgszNKqlK4Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875622; c=relaxed/simple;
	bh=Bi1cb3woDgCQH/9tomuCwCHWEJ1hy9AZu85Iv7PLKkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPh7ROC5Df1HjtyxnTQSIu4VxJ3OqmnjXZ74txvbsCxJL73IUw4dF7NfySaYJWhq9gnRQeuhQl2l4wU8EzJCjQnX/H/K4uHFPDoSOnvZ6A8Hi7VN1/imQrNVW/Aw/YhFucgGbTJNkUBkPtDA0EXz4GNgrq2/uj2pyVlGjZurUSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=UuZK2aDT; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="UuZK2aDT"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1c26d7e951so777151166b.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875607; x=1789480407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6y/xU9e5Bzn6V96XBSS35d3RBrYr4Ir2RWo4uuGwhTc=;
        b=UuZK2aDTRtGmVuw2ov17H4rYrxOqC/P6eeNckBhkBzU/9IcvEnYlkrZaH6CSSQJ62h
         pmlSblLqVmwZMszu+UerWqrn1han9OysTkxdnTRKFWYmj0/VtiFnt+PSS2/cdAWjM96q
         dlGstfiHrQRtq95lOmE/bLkhZT0sBu5ZBG8mtwy4Oou6l1ZW/7WO8AujT1RHh+oE5Hfd
         rSsNFqJrH4Cx63nD1sY59tEKZkALcj4CGE4lGbcyQMz49KpPeRPpVMyQCoYyuq+jKaJk
         A/TmfYMA0D3uzt5QT3p/vULg6xYNXYAitfSdGn/P8DRsENdnqYCLYSBzRyG+CfRYeOFT
         TR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875607; x=1789480407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6y/xU9e5Bzn6V96XBSS35d3RBrYr4Ir2RWo4uuGwhTc=;
        b=Lq8SIPXiFw2Lnbkrr7Vo6rX1pWij92zXD5fzdJCQXzYLTEgUD68umiEczf1CJD/o/9
         8DXGnjt0pBbgEV+M0CA9CTmECG+CnaD65hY3X0FXbpyFdTcRLQJeUg6SNykqC4trG6Er
         cXJsJxjdBfFqRE3C8tUNiD3XEUZTP1H6YERZ3QYn2F7dDf/WoCaEcxAJ4Iq9NNqrDuMW
         FQHDX1og7cZR8oC7fPMkHngzT75zK3hx/kN8T0soRalt4H87GPODARNp9MICh/VazfIH
         FdD25HqUeGNe/z5p05aM7qMvxQ6dGWvnzyWpzSiSFtzxZipfpBqXVSbjl6Lyfd7spGk+
         8LGQ==
X-Gm-Message-State: AFuF++k/FmGD1PLg3+ylYZ4n6tNwKF0/uLiBHoWqogJyJLRLZOwO7QNH
	JH5V8s0+AgszA9BcWHoohvS8rrMdSnS86gbmjG6aXeGgvMPEdZiPBC5HLHErChNKgA==
X-Gm-Gg: AYBFou2cHZMhSdVU3ajmWW0S4Oz6kE80TeFAASwPaVm8FyndFRo63kLGy7o8wv1DRaK
	QNSxZQaFu7TO7A1z1kaaOpcMZdj8Cg/8IWpO0TW5wxe0l2YG2IZlOpTxmjFaC3/39+HRbh6Qc3A
	8/ux/9oBUNk/oL0Cs4Mpb0PTi4Kum5JA+Vi6r0PuQxrRia2C62Hh+/ZUpqyimT3fHtyyYcc2XoC
	M7EYojCKfYUA38SmYIuj3VAwOKzkmd9c4AL2aKDm5BhX97S9hE96s15gyXY8UuRfkVDSDe0avRl
	oT/DUyr4RI34W9nPnuLCJvdApP9veasfmXCaC57FjudAOxam+GZWm4ke+MF3qDNvMWkkPBykwc/
	cJLxSMMRjvj5f2jhFNGwNmYCgf5WGY234vubHJRMYCADZUgEV43kEETu5EIWo10thUn21Lm8HjP
	EKcVc4Gw7bC5pmC2iozq6A7tpgKIffCrjfI50LQ+z/hhWfT/aQ3lECk2d9sR3ohsRFis+oFXQk4
	O0KvOqCSYLIFR7v4mtGHW1GGQwyyftCWiGbNoaVB4gMgEVNk3UvP/ISqUm06SG8FFguH0k7UlZa
	cqEEGC/NjSUpb+U98dw9rMxbUkKgA+6RuXtLNjvZi7Pvhj6Wc9XgDf8x13HlwHxWChp5+L4rD9H
	PR9DzYzhEccXrtOkKyaiiicfe2+F1qBTI/OQwHg/24qRNllyQNvKsoS+ghjqhhd3mLL76WMxFXu
	kbWjM6bwdTdjVz3kirEBBwfDdZ
X-Received: by 2002:a17:907:9708:b0:c26:1648:a06a with SMTP id a640c23a62f3a-c261648b7afmr1033756066b.37.1788875606512;
        Tue, 08 Sep 2026 06:53:26 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:26 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 8/9] wifi: ath11k: stop a scheduling round when the hardware refuses a frame
Date: Tue,  8 Sep 2026 15:53:17 +0200
Message-ID: <20260908135319.754140-9-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908135319.754140-1-julius@bairaktaris.de>
References: <20260908135319.754140-1-julius@bairaktaris.de>
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
frame that met the shortage is freed as before; the ones behind it stay
queued. The round-robin over the remaining stations stops as well, since
a shortage that reaches this point is not specific to the station being
served.

ath11k_mac_mgmt_tx() returns -ENOSPC as well, for a full management
queue, and that ends the round the same way; the next tx completion on
the radio starts another.

ath11k_dp_tx() also rejects a frame the hardware can never accept, with
-EINVAL or -EOPNOTSUPP, and every frame with -ESHUTDOWN while a firmware
crash is being flushed; those describe the frame or the device and not the
ring, so the round continues past them.

ath10k and mt76 check for room before they dequeue and never hold a frame
at this point; ath11k learns of the shortage from ath11k_dp_tx() and
cannot.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 41 ++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ffb6b865c2df..12535926631b 100644
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

