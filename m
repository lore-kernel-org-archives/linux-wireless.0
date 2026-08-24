Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E413988EB
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557377; cv=none; b=ItKaSJ72G+U4d7qsife+IBI3n+R6Lb0Ib80Ty3WpO74S31IVVghzQVL+AV7GG3pTwfT/jupIipZsBXoUaxMI/b/CwHiZ2mwbi1KgBDLqlEEOuc8csa8KF1FRKeRI6VVJZZqDAoyGNhpwjxxVna0iD6a9y+9MBSMFR5d8UDkljOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557377; c=relaxed/simple;
	bh=Bn92nLSylgxoZ9U5cHwMOT9XUKCNXy4PBAAK+jFbDKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6cLEuKI72+OhJKpPHVtX/0fZgdupAqkK6cCXgKS26xA5FbJW8rMxUkfSfcElOQkByQoO4KFdoBMHkIcfL32BpwSDSe3BzqffwxWnIz7svxJPa2U0kq3MvIU3L3A2khn1BCp0LisHRYoRyI9yi6Ujm6XzDxvtBOtUPporAK4Kic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=ZF/2i25b; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="ZF/2i25b"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2020421077so525771266b.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557372; x=1788162172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OEvSzrV5rFR5uHelmOPkOPAfb0Dsg+m2IDvGU2X7KdA=;
        b=ZF/2i25bqw6D5DWLjh77Uk7JFQ5W15QGXmeNFIl5qwrXx/43BYudHlmGBRcz5qqt1F
         oGYwspzrCMxI6vxMPb1mon2P3xzAnju/9+aDsM8a3D/gCrmi+w5fTbXQ5YFu+dw6YtbR
         P24RqSupaY7SZzHeV9a0Ur2Sga6zEdl3JBgIwhH8RBVj/sBs+orwdx6CSVFsaTPoqvXn
         SEgksKjgzjUEB0DFEM9u1XQdybE2//ByWX783T83tQ1qzhDRyLo6se74tQVLCFyxsR6h
         Azrg/oVkvARsZooiMGgXOetbCPynFvFjab9byBy7pjhWOXzcG1CZjY48d47ShGXUo94G
         HnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557372; x=1788162172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OEvSzrV5rFR5uHelmOPkOPAfb0Dsg+m2IDvGU2X7KdA=;
        b=BTeuYZE4rTGtKT3JkYqFjw1A99G+PpLcDGCKy+f082hsXD1DzrT9ny5saNQQ+NqRvH
         DZ5fI6fWHMHO4NBhhY2RvgjcsZ6t/d3E48YL2EEoCamzRxx3kdbM20eIjlviAFrX7i6v
         wN1/i9cA7OuzWyKd2BBuGDr+ttJZuzhF5xzL3MRxfheANeYPXoYJhplv8yUYYs/C5V40
         5n1p/IM1+gQVcJ8eWJZW/keAK8Z4sEKVT3QtF4JRxqDmCCh1ld8HjZxKW0+AOXs0BVxn
         bN8U14gnVEDKPe2vyrhN50rGuuz2B252gigmsHI431b+hNwJ5kx3EIMMfoZDaBqIDRN1
         Vfww==
X-Gm-Message-State: AFuF++lNzH7MbeWDsvdMX666BkIQLlsXgUsCcVUydYLWiAKxokejR0gC
	xRf+1bzMgRzfaz1thvQCegyeoSsNn2UYEV1TdnzCV8FB8yG4ya1ye6vIZd134D71Lw==
X-Gm-Gg: AR+sD101j/zLfv+CB4xR0VaiCHi2bA3ZhsMX10JR4cjpERxeoRVG6ZdnuklNNMRnMQZ
	X3mkTc3aqI3ahgRM0yd0zHrzrZovgt1hVjCiJ9cvGhcYGZW/uRHnqRAmDRJ+D1YbqQBl9DAhyWF
	Wyw3yARCIcmfBP4HUNvqiuXYjlTjYKfoToFRScUl+8Ed2jLIS1MdYBBUXY9244575JEgiqLqtol
	IhlsSuwGgo6aW6n4dFeNEHZSsAy/TrZqSUlOGlwQXKsqVF9gTvOM5yVZE8ZjabZeQCmJSqFfxhx
	BMx8E2roeeIcpyOXiXfJNWaebARaflSQ96MVNY2y9inph4dj4izq8z7F8FhY6LjFjrWPx1o8dbX
	BRa3h0/Nd1Z3ltbJa8IDItnbYLDlMjefLjnIZgfS87TPaAcBUM9SpZbNkQOpufBqhYxL004drMx
	WsZLexWjdgmGXsgeUbonF4917AX7JT6GFHAetO854os+M4SKMv0xRYkGsEip+lCxtNb9fkrTMfx
	utsYslYSixsR9tC2VS8IeqG3rsDAkr1MLXcUP/ji9Igdq7ipYKwpL+Y7nT7Aon5wFD7OWsyhriD
	xFzuLUncn9r1XRWhuggj3gPpSKLHKBAG5Kw/vh3MDTJrDF3El5+SoKgzAMEy4Hg1BLZevk5E2/t
	56YAX9fqOn0oAejMr6t1teQgEw/GLArccKqMq0Qccssj/t/Buo9XBvbgk4VKaFTat7FBkG5aSdK
	QAMRBisjScAzdDs1uv+VZvM/0X
X-Received: by 2002:a17:907:d78a:b0:c20:899:b8bc with SMTP id a640c23a62f3a-c2491c836e7mr1648797166b.6.1787557371929;
        Mon, 24 Aug 2026 00:42:51 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:51 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 1/9] wifi: ath11k: free tx skbs through ieee80211_free_txskb()
Date: Mon, 24 Aug 2026 09:42:20 +0200
Message-ID: <20260824074228.2114579-2-julius@bairaktaris.de>
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

The leak also bounds AQL. ieee80211_free_txskb() returns the pending
airtime the frame was charged, through ieee80211_report_used_skb(), and
dev_kfree_skb_any() does not, so airtime charged at dequeue is never
given back. local->aql_ac_pending_airtime[] rises without bound,
ieee80211_txq_schedule_airtime_check() stops starting a scheduling round
for that access category, and no station on the radio is served in it
again.

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

