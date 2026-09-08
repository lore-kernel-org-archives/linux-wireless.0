Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A7054B1CC
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875615; cv=none; b=YBX0cN59EXczS0go0sED8+EJfqzxvAqB9PrDXUD/shtGUD7Ky1lO+p7Zu9KeYCMsuoOkg3EGlMRTWtWtmVHZOdY5CDZkKfEzkwzGJP46v3ZGXGeXI7JMlgQwIPoA98Kgy6mBjgqCDLPeNOtGltTs7lByBD1IGb1ZfI0So/30eCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875615; c=relaxed/simple;
	bh=Ll/celIZkrTx5A2z6F9mlVcPTGNDg8fgqyuBKm56wv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5O6ivKy9pgu4WNV+ghD7Z8MJo7hWiZe45Iwoep/ItVp7rM81prZ9p67GShzVfeNBj/g6QEDxQenCRS/TR/wLf5NXSr7uOl3oJBkq5t42PTQ88RykTeoQP43ouDGqKWXJ0eYtjQjWatsf+PfOakV5nDddv7xM+yeDSXq/K9T27c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=nYJz4VPr; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="nYJz4VPr"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2530cabcf4so716365966b.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875601; x=1789480401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lUfEGlTlgKOy+Yc5P7GRFfi0p70OFiu/Xw7gbqqsFKY=;
        b=nYJz4VPr9YDcspOyfOBYUgC9/AFaExynP6ODA2TGCBcAeACPmd/0tk56aBQ95D+adk
         4Lh6TkJInHtt3Il0dLwqifyX0Mr+QAOYYtrvTxyyIjN17zBZg7xcaDBcSCRne7nmFUCz
         xgJobXoddePU84xBcLx4NYRH3nG54nSXBfLl6f0N+KWI3VN/k8d8jq0f6ymd874aX70t
         Sm3peIcHQt0fz6RCrYWD/C7rVAr568E86fo7w2AaD9oiTFLS7LRwciHdXeJZJRJq+oPZ
         zTO1Iv8f1t77Mksdp6+9GIQRNd+HR6bnGKgHkBkhxvLJGRij9qyCTFIJRZGToCsYkN1j
         OYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875601; x=1789480401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lUfEGlTlgKOy+Yc5P7GRFfi0p70OFiu/Xw7gbqqsFKY=;
        b=Pq1H9lr6WullN9PqZkJpyWib/40LMW6Y6SG6Zrv9JlG27/77GHsqO9w+1sW9Jir0s1
         06Rl9i3CLZObAzGYpHpqJWNQdlaLSg+57JxPTfdOmw5qOCsHCMPLvh9mMcNuxiBXSvzs
         taG4eIx6fBKK5Nu1q7I5vQsdspKbHn8SC9MT34yUV0B6a14kR5/Jl4UDxtlWfpz94RM+
         MiRKn+i/Eht7iNyL9vbMcHzzqI1DheH0R7+QGF5u7fEZNhx1eusSSaFZcISQszDCXMJu
         PQBAJqJDtAFbSXbZqKBbxzWUhXArNlMZ6qBp7kuMebNPyQwPEXuc7Gsye2wO5funfFSY
         4uYw==
X-Gm-Message-State: AFuF++nlKY9Ll/nAm5wpIIelFw4slCCeYRsBQTDgpeRVsFZ1SloD7prR
	v8ZqyF/cq1TjaiaDWykpasvxCwrV7YBEhczpM6cgYk2VjyyfuFaPC+EcCBu5JDPYHQ==
X-Gm-Gg: AYBFou0u+pWnz6iUisTPfme+UG4wf4mhxKdc1qPvhx/UqtiXXBWtr7lp+kAnbaqWeqG
	Ffs1DT3cXfljfYpMPVHq426C8WBFUcHi5thMFQOxJq3ysKzwQgs8XwXFxN2woVn7+kAgK9HtT9i
	v+hLinbv+VQdqxUCMDfdTPygKl1c7PqhFP6FdhBA7P8uTUcFSQvt6v/RVbpQbZOPMKjerLGnA6m
	3ZjAF1hMUeyaUNUxyR7vFjMIifUUZ1F0X28xsarAAboKyrPUctxmibNzs87QP1gzzp7G07aWj25
	XkwYMy66zPXhPR45U4dBQRAD0eZIjMwCmvG0vmDQHb25DUmZJDi4dGQkgEYvVnqDnwwo7ZEcK3c
	eduFxwCw+mDd3+4JLo4YCOMLYtDe3KzcTT37RY1kWF/AdE0y57uYbzxGKA83mHTsNe5MLSAV3GE
	HPXMCE2rAC7rmi3/qEmE9QUc3faVncKoOcj97mLImMES1XP2Yuc7lhzMYV6TZZZmeUOzcOxjtVj
	KCwNxI6V1CbWiTePArU+RdfRYcWg9xfYXGSvNLDYbdDaloohv+c8wYU7CVFMXNw/OTeSu7ezABL
	vAP7yHeyw5tyElB4ZRqxhqNYmc8npE5X29RRRPE1oNJrYYYmcOzMAmyTkH0FZbOD8Lhx7/nKk4V
	crFK+vDBUkn4afABtG1R+69abd8XWSDkH9lDfsnququw/IeyJS9BzdFgtoTD9orWzmcV+cdirG4
	u8WPiInQvSDII9
X-Received: by 2002:a17:907:d28:b0:c25:8eb7:f388 with SMTP id a640c23a62f3a-c260cc0bcdbmr2124035566b.17.1788875601078;
        Tue, 08 Sep 2026 06:53:21 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:20 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 1/9] wifi: ath11k: free tx skbs through ieee80211_free_txskb()
Date: Tue,  8 Sep 2026 15:53:10 +0200
Message-ID: <20260908135319.754140-2-julius@bairaktaris.de>
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

On a driver that advertises NL80211_EXT_FEATURE_AQL, which the next
patch makes ath11k do, ieee80211_free_txskb() also returns the pending
airtime the frame was charged at dequeue, and dev_kfree_skb_any() does
not. The charge then stays on the access category for good, and once
local->aql_ac_pending_airtime[] reaches its limit
ieee80211_txq_schedule_airtime_check() stops every station on the radio
in that category.

Neither status was seen on the hardware below during the measurements
in this series, so the change is by inspection of the completion path.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
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

