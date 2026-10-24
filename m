Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792877456;
	b=pS2m17YnbwoZLdEFgm8NaCaHiEi2Gjjp/vjunBdOPFU14ShAIl9bk31cr4x70qPU/TCQ
	 PSnvzuVtWFQo3bIuT53bzMMBlnGKBYvpZvd6CSux2Ms+WBPWlftNapUxSRLl5699IWD7E
	 8FnpYixtJC2l1EU0RxkjyziddSrt7D/gC28fwWIxhopcPNXLfDyljrf4R7QbYLsg+TxfF
	 hkl6ww1b6/xNf0FpyD2spndYEHQg6z9CXCBin2dN/++XXpXScboS/ktcTRFx3CsKSEwBF
	 GIeDSoc2FJJwn/NrKjihawdbZ0b6f3B7OIZucS8+v4NapXHGMneQEu7dldCrBEz7EnQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792877456;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=V/wNu+oldJDtoA2LpsIfGgrCD+VIaBcOKfcDLEv7Hk8=;
	b=A2DUlj17A1vqbs8cToaY1b7ZrY55yACJPfW/QBUDX1fE28rxx9cQD7HRTY5HyWfLS2mH
	 OdUqwqUr7ZaspUx4ggiTTO0SvbpjT/68kv+PtoKQLV90t5HnaxMgL96cKlyuysFNj0FWi
	 EnQcTvwoHKbwXt+PficRUFdyKk/DryD/Qq1lljTlDGlSAjTANIxJjjFLMk8CBZ8UFCJ9G
	 o2A9YkKKSGxy92vfkgFt2Dy7yZqie1tf34DJuPi6NPua/UlMS+0bfncA+BQvg26VhV49d
	 QaevK8kLuhKFBUoBVfbhwa6ivLyHY3eC7m7UfLkPwZS8Jdo3N14CCsk8AdW/aWs6MhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d40CXIw9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F94606A320;
	Sat, 24 Oct 2026 21:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d40CXIw9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792877455;
	b=ohjiOn1QXoTKy+uV5Ac4kjG+H1zh/BWJ2JOz1wb3JZvtUSAXj2JKyWGv1tIPBvbh6x5y
	 wBsF9Pwi7B0/uQF4Q01G6rw2mjY7vgkOHSEqhLXc6lXqbNDoiOKc5PFMx6vvs432P6L9f
	 03t7vblv9TdjZCiFXAB5VfEPiZ93TcAmjGkobzOW73HSWHkkD/ZCL7nW4vGN9TfRileZ/
	 F8aay/QEPOEOCiVqu613XipNL/M5zkws2AtiqC6Eldq7HadWiGZxiueXhFRzgsfWaKeld
	 Zs3jbLDbcoqdVm+OU3H8G3/iPjwbsSqQmnRdsUgxKFGO5aHcc//dCqjFZFmgx0GHSqg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792877455;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=V/wNu+oldJDtoA2LpsIfGgrCD+VIaBcOKfcDLEv7Hk8=;
	b=hauyiZsFC4TNeF+ZlnbOR/eMHgyOYlzMRWwxQNXM19MjHUvPKOw6TOFms4Kz3bS9Fmp6
	 8i57YVsejaCBRaxCz6c0Tl7sAbivML/8pyd41C1I/tP65J+KD82uc75HjFTaUvF7UTMg+
	 VQfhsilt0wLFuxXP7PxqzDizjZ4kWw/VUgaUY2yYhlcEUE3RZUgBvfa7KTudUNRb7BTNl
	 RmC9qCb8E+E/d7vKCPUuQ7g8wbpxmde5zNJY82HYFxLgBcxzLBsj/OhAAK5gR3HvQD/rP
	 ejelDf2Dw2EPppxhMCd8cO/bsFB3H+gf7g521VeHRfcEO51GD8KTTviRbRqYK7bO4pQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EB3311F01825;
	Sat, 24 Oct 2026 21:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792877455;
	bh=V/wNu+oldJDtoA2LpsIfGgrCD+VIaBcOKfcDLEv7Hk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=d40CXIw9LvL7rwca4XiGXDPl11PZSr+DxEZ/jEJ56+F8PzZYBbGTPyN7rkIj7G7b/
	 NmYdZOcF3C7aGfCEoGg2EN+Z5ECKdUU6yMsHkXbxbpSmadYvNVvFixV3tWPQCST/z3
	 cueQYRt53w2h+v2hKdhgX1tx5hJaPzsMUXn1kMRqOpcc6c1qqb0q6pzicrbrxw0Xjm
	 2WZeYuBKX+Ksr193gZ3fpbmOpa8dgWOPSZzN4HwX2OshJpc08xYPV8zXqKBwBG+9nr
	 lWYN3UEe8yl3ImZOfJBh3+2MPg4mnzRf1mqtvduQdjYzUhRQlgA1JDxtnNM/2wRWGP
	 d0mz51bTRqT4g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 57259448AA;
	Sat, 24 Oct 2026 21:30:54 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sat, 24 Oct 2026 16:30:54 -0500
Subject: [PATCH ath-next 1/2] wifi: ath11k: don't free a monitor buffer the
 device still holds
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261024-ath11k-monitor-buffers-v1-1-ff155feca2f6@gmail.com>
References: <20261024-ath11k-monitor-buffers-v1-0-ff155feca2f6@gmail.com>
In-Reply-To: <20261024-ath11k-monitor-buffers-v1-0-ff155feca2f6@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792877453; l=4316;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=s35q2CYjVXwogmYo/l8p7P0e8hgpBmv0wenKY9afIwc=;
 b=m/g1ePTlaKTN3CaC8EoZsl78Yf6EniWFcrbtvrnF/exChSy+GKEBp7vM2VwDfpAfrNuOJ0/pI
 gVMunv7in9WD5Zq/3gHdw63h+2orEEYU50DN62Qbzj7tbU5PxDdn7tn
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k_dp_rx_mon_mpdu_pop() finds each MSDU's buffer by the buf_id in
the cookie of the MSDU link descriptor, and never looks at the buffer
address beside it. The device sometimes lists a buffer that it handed
back a few milliseconds earlier. By then the driver has replenished the
ring, and idr_alloc() has given that buf_id to a new buffer, still
posted to the device. The driver unmaps and frees that buffer, and the
device writes a received frame into it later, into memory that belongs
to something else by then. The duplicate check in
ath11k_dp_rx_mon_mpdu_pop() only catches the same cookie twice in a row.

On an IPQ8074 with a monitor interface on each radio, such stale cookies
came about twice a minute at first, e.g.:

  device wrote 0x6ac8d040: back 0 ms (3 buffers) earlier as buf_id 1002
  buf_id 1002 now names 0x709d6e40, still posted to the device

Each buffer freed that way comes back later under a buf_id given out
again, so they cascade: 782 in 32 minutes (1.75 million monitor
buffers). The buffers wrongly freed are also handed up unwritten, which
trips mac80211's WARN_ON(!sband) in ieee80211_rx_list() (24 times in
those 32 minutes). Left running, the AP crashed every few hours on
corrupted skb shared info and Ethernet receive buffers, e.g. on an
Ethernet receive buffer whose shared info held 0x80 bytes:

  pc : skb_release_data+0xdc/0x1a4
  Call trace:
   skb_release_data+0xdc/0x1a4
   sk_skb_reason_drop+0x44/0xa0
   udp_queue_rcv_skb+0x24c/0x280

Take the buffer address from the link descriptor too, and when the
buffer the cookie names is not at that address, leave it to the device
and drop the MPDU. With this, 7 hours at the same load gave no
WARN_ON(!sband) and no crash.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c  | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hal_rx.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6d95f7b34..f0bff6c16 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4644,6 +4644,11 @@ static void ath11k_hal_rx_msdu_list_get(struct ath11k *ar,
 		msdu_list->sw_cookie[i] =
 			FIELD_GET(BUFFER_ADDR_INFO1_SW_COOKIE,
 				  msdu_details[i].buf_addr_info.info1);
+		msdu_list->paddr[i] =
+			((u64)FIELD_GET(BUFFER_ADDR_INFO1_ADDR,
+					msdu_details[i].buf_addr_info.info1) << 32) |
+			FIELD_GET(BUFFER_ADDR_INFO0_ADDR,
+				  msdu_details[i].buf_addr_info.info0);
 		tmp = FIELD_GET(BUFFER_ADDR_INFO1_RET_BUF_MGR,
 				msdu_details[i].buf_addr_info.info1);
 		msdu_list->rbm[i] = tmp;
@@ -4790,6 +4795,21 @@ u32 ath11k_dp_rx_mon_mpdu_pop(struct ath11k *ar, int mac_id,
 				goto next_msdu;
 			}
 			rxcb = ATH11K_SKB_RXCB(msdu);
+			if (unlikely(rxcb->paddr != msdu_list.paddr[i])) {
+				/* The cookie names a buffer other than the one
+				 * the device wrote, one it still holds: the
+				 * report is stale and the buf_id has been given
+				 * to a new buffer since. Leave that buffer to the
+				 * device and drop the MPDU.
+				 */
+				ath11k_dbg(ar->ab, ATH11K_DBG_DATA,
+					   "msdu_pop: buf_id %d is at %pad, not %pad\n",
+					   buf_id, &rxcb->paddr, &msdu_list.paddr[i]);
+				pmon->rx_mon_stats.dup_mon_buf_cnt++;
+				pmon->mon_last_buf_cookie = msdu_list.sw_cookie[i];
+				drop_mpdu = true;
+				continue;
+			}
 			if (!rxcb->unmapped) {
 				dma_unmap_single(ar->ab->dev, rxcb->paddr,
 						 msdu->len +
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.h b/drivers/net/wireless/ath/ath11k/hal_rx.h
index 475807b89..11e367bcb 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.h
@@ -463,6 +463,7 @@ struct hal_rx_msdu_list {
 	struct hal_rx_msdu_desc_info msdu_info[HAL_RX_NUM_MSDU_DESC];
 	u32 sw_cookie[HAL_RX_NUM_MSDU_DESC];
 	u8 rbm[HAL_RX_NUM_MSDU_DESC];
+	dma_addr_t paddr[HAL_RX_NUM_MSDU_DESC];
 };
 
 void ath11k_hal_reo_status_queue_stats(struct ath11k_base *ab, u32 *reo_desc,

-- 
2.43.0


