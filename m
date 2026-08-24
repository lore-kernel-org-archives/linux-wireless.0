Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2843439E184
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557383; cv=none; b=kXnOtd/sOvEUw25PvFGreW61Vma72XVtf523htG44dAX3GMH4wvG24UtOGJqXkEVxUysUnLelyryB1thcHAqUi9BWJ9LH+5FNc0bgHZPZqYj3RB6ZiZpH/4wYFG2QolxjDxoIsraf46mRA1nr65CDv1jyh0FGck8oLzrsWr5fUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557383; c=relaxed/simple;
	bh=mWfayRCA0S5NuSm5G9JW/1Jerbcn53Tnz8gP/ayFSTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1ho/K0TPGnT73vQOptFCkpdQeuIHcmuONym1acIR8AQbK0TFF4qm5dtMv4C+iile2fOeFv8y+aF+ClEVSYtSjKOZ3nCF7Z4OJQaOz1LM7iINpMQsySEHcS1Ogk9BbUGNFJmgjLQu9ucybDZScb3qakOlYezw8qx7XdJpkl8Hks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=kZcQyDK0; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="kZcQyDK0"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c20e70a0962so468368366b.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557379; x=1788162179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IUe2piPfROCuIddmZ/ae/9op4qLIu+jbzjbUhLZABGU=;
        b=kZcQyDK0Qqp0anIUDKGK17xRdsnfhHr6ZRw25UXivBSV0Sbqy5Byzx62cZehkZoXmV
         r9t2rs3cZeW09m5cMbDIETdNtehCtdKhIVBvZkr1SlKVC1ZcqMrO/SNkTJaGEbFnmtWT
         H1y016/yxNQ6gin0ybduxcEeEGRrI+e47uYAhJ7i0PHSynu1zc48CzBdd8i6Lujuj4hn
         VsI75aTMM97q6EuEkEMPY7iIjwwrWnbYj8DBND/nB/gebZvDVo6hWyn/UAMQDXELjWn1
         wzQxpP7wDyZCYwveMvgYLEeqlP4nJHxHkbb8L+/m3HQrmySmWwDpRY+F0bxJErlXmHHV
         tTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557379; x=1788162179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IUe2piPfROCuIddmZ/ae/9op4qLIu+jbzjbUhLZABGU=;
        b=bif7F/euehy2XRJCvKE3/dWvmpyT4V6pWyAnv/4obVVR/9qb9ZPgQby7gxfHli4F0Z
         /D5/gv9/QNiYX3pW7NJD43NsNtqY8u+5jOom+FXP8IlzV7Jl4/M8S5D65VxuGhpqt5p+
         oT5tITQMz3NKFulfsLa+w4wPqJg5HR0UjrhjfLjtwvOxWC/AYJywozfr7Zg/CwETClv4
         YAtOVBxfoNuho6kyn60q16opRHMQ2E2tBPpIM67mj6PRYNESCeFBgcAOAJq7hpFAPEVx
         QSxQQwJ88IyAv83NRdolMOg21L4aaP3rJ4nKmTO7JhCLak28ugTBl13XQ9+1+yIJgnsp
         flXA==
X-Gm-Message-State: AFuF++kOLPkQJpVSjjEbbJkpK//g3FkKYF+1WcmplWfCVWCUIiKTTSU2
	k8ewLxgClYcMCiOucp8SXN22+WqHHe8JHF4mMvHG+BeUCv+YolnhDDe8rRAyGaHBKNJPzk4f9pk
	YxFP9zI3K
X-Gm-Gg: AR+sD12WS15My+VzqPInvC+zNXFTdn61H2CqtiiSDwaDz0IxukLPbZRwjQFU/C0wmq9
	VGxQJB4SQ9p/CGSzeYMnQ2I9LgaYq4G5iZF5K+HinTcG11TrgMGY3keWfo+5bTUJf/XMMwrJyrO
	2P8JxHdi2ZeSYkZ0H5CPwOPzCzXMS/3fdV1mWcxQNiUoIBqzHYbykwsdyDBisKCTp8O6PbevnxN
	6700BJcBLqeOXHiXz08ne35yEKy4KmSIollfq+2Nq2yOQ8zB5NBtDECHKlLFiuoolIqFix84Nfp
	7zqYgUh5vl6J6y4nxsUKW3941O6v1br2gWPvDePN1Ap4SwX2kmOm7HiZOd/RxZ9kgFi2fCdHuev
	cvyZwsBkFewJaZtG/5PVNN7Jj+2CsJp8i2Wn6sCtR2sAAAtEBde6bTWAIUd/Rhu1//qnhE2zU5Y
	RsTxdB5mIioJO3oqsjzrra+EYCt2HeJgXkyn03YNWk5HaCNJnNdarqEqmQxIN2+Als0geJYlH0W
	hoaY/bXxYZRQTwD2VmfRIYfRpHX46L8EJXJBl5CrqufnzuZtBMLZbPVRRRWXsKC7yzO+C5tutiB
	JYjB85bxWtm0bz3N5/4w7Wq2mlZGFJhd9gl7f1+X2GHafB096Bnv88DqMG7pkm462tR2udYAtIU
	/K4fLuXkA2dn2t1ZeDTzTcZtksxpp6Boq0te6MA+E3D0nY3F0OlQP/Xd4gdJ5rRp/gzoCAhL8SQ
	LAfEVh2/Wrfa4Bqw==
X-Received: by 2002:a17:906:4fc6:b0:c08:417e:3696 with SMTP id a640c23a62f3a-c24d922ff39mr61778966b.20.1787557379061;
        Mon, 24 Aug 2026 00:42:59 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:58 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 8/9] wifi: ath11k: stop a scheduling round when the hardware refuses a frame
Date: Mon, 24 Aug 2026 09:42:27 +0200
Message-ID: <20260824074228.2114579-9-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260824074228.2114579-1-julius@bairaktaris.de>
References: <20260824074228.2114579-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_dp_tx() returns -ENOSPC when the MSDU idr is exhausted and
-ENOMEM when no TCL descriptor is free on any ring, and the caller
answers both by freeing the frame. Inside a scheduling round that is a
loop: the next iteration pulls the next frame out of the same flow queue
and drops that one too, so a transient shortage costs the head of an
FQ-CoDel queue rather than the tail of a hardware one, and the frames it
discards are the ones the queue had already selected as most deserving
of the medium.

Return the error from the transmit path and end the round on it. The
round-robin over the remaining stations stops as well, since a shortage
that reaches this point is not specific to the station being served.

ath11k_dp_tx() also rejects a frame the hardware can never accept, with
-EINVAL or -EOPNOTSUPP; those describe the frame and not the ring, so the
round continues past them.

ath10k and mt76 end a round the same way when the hardware has no room.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 34 ++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 996f421b6957..eb420fa0fd68 100644
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
@@ -6544,19 +6544,34 @@ static void ath11k_mac_op_tx(struct ieee80211_hw *hw,
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
 
 	/* ieee80211_tx_dequeue() applies the airtime queue limit, so the burst
 	 * a station gets from one selection is bounded by the airtime already
 	 * in flight for it rather than by a frame count.
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
@@ -6568,8 +6583,11 @@ static void ath11k_mac_schedule_txq(struct ath11k *ar, u8 ac)
 
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

