Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E11239CD0B
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557384; cv=none; b=Cgq3p9JcvkcEuSw/VwUZ5GniElDfWFeNsWV0HzXg6gzR/2bnpLRCsF7qF6cG0f7r8XzvukCLziDL33iDUZNCR4HQ48kxvB6HXct0S7plyMkPkAhy/H9Bf6Hd25vfpcHoMod47DoqQUjtCLpedODJLO40xcGQ3CxcaP02gNogF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557384; c=relaxed/simple;
	bh=jBU+6dFYFt1wbcIcVm2pNiBgqWCTHfH0WI0xzF32+/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2rOY/Vdqxx3uyFuIaY2gE+MrsWtAzMgyI1BKBM5c1hUykSVQF8VSKmYgukKFhyyh5yjaXnEOIUrjPrz8rpUQ3/aW56ZS5vg5qyre8hCGdfZauuaEvlx99JpWDryR3JJ9gq1MDT5EJbebYaRx22vHnSwJN2ze6R5Fi+VcX/E3Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=pUXRvOHt; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="pUXRvOHt"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so6041549a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557380; x=1788162180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TAcQKsiHHrhl5U4tNXvyThYZ1gGnGcacUCSiyofhb0k=;
        b=pUXRvOHtcSA/5EKH3CHYkdVu/HVXIGhppMietdBL+VTEj5cfxpwlu3xkIMbX+S8Eou
         mZO7LlZ/RWfHY9vaandD+OH/wtwrLVHONOXAqLDC0Q2j1UiGiq2qhcqEpDFw4iVKfNpm
         QH0NJ/kWH1MfAK3VsUy4wwoxVDWJpb31sCgRCuoOPl4JtZcEcAAXZp9kqySrCq+zbUfw
         iWETGgENAjt5okjnNUaN0klEZJwkt3IcH0vkj5TFBd1VVKRxC4Rfk2EypS2PqnsTdtv7
         I/DyYKeELeSl+iPxidZx5f9GNJdC3U+old4LE61H1+HME3Rp+aZdSV0o9Gd5Ta+K8ZMX
         k/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557380; x=1788162180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TAcQKsiHHrhl5U4tNXvyThYZ1gGnGcacUCSiyofhb0k=;
        b=ReA9kHUIMmC3+DmlUz8pienZAyVKl+gfWAC5A2Amixbbva87tHJaazE56X9QrDTafO
         zGEp1x2jwQbPilKxaJScKpVXJSHrJwR8zKQTloI4O5uQTgwxuqXLxjeEmfdWGhioixJ3
         jJ8zYg1pq2IhMyw5XA33DOwdkXevYzmgweyBoasvslqiRoE+FuQuUbyCuIX29uewdMJl
         uVw+ASpbb+HzrjY/ZneMnNTO55U09h6SFfKsMCEQDjYOVedWHg59F3FQ+rsqeV0AMTtz
         gitWco4IEB6gB2fdpZdbHizQLh/4w8oqYErMLl0GdUMh4HspgIcyMx+p7MdJbvG6Boxc
         d5hw==
X-Gm-Message-State: AFuF++nSsCF7coNL18qoFXU37BD0n5nGQ4Kx3cWe9Rt86al9IwTmmr1i
	XC9Fih/0kvc3fCA1lnggokxxn/PyTxjSIE/3W/AdlJBygbxuhG4gYEJmWrt+/Q7cjg==
X-Gm-Gg: AR+sD11PhWOpUAVE9JrfN0xC99SK2QYvxbVntuvyxx/yFDnMnqswJ6oi3Zv8WZ8IQlw
	2ymxbQsZ+pbkqvWRDtmlZMitpC+1TTLgv6nKZV82UkAB7hp0L9DDW1TKv5qKC94FeQb5jNBN916
	rc+wm7Inb7U5DmoKWytv4ciJBOHHVXO5M5JAXmhaE25OSjVSJy5hjBSNSA6ggt1/mnphu10BZPa
	zgV6UzB2iScBDjpJanFYUvGfI9XSuaVOe+7t2QSy65pnJl8j5JZ5Mj21eOz5T9qTfkYHnTHTl5D
	0XGZNQZ2ZGm1DAET3Xy4qvS1vmNSwr4fR4OnTDES55Q1DlihgJczWEAvh/W0L7SUmaPHSVID4Ot
	Z9ZGhXqBcrVBon0ePoUaBl/Q0rlb0CHR4exkKHhpXtDC8jvgJ1wyAbtWWAPQ2ayBqKKoF8t3Kvb
	F6YPlnNfrpQ6R/stS8M9iuc2uJbBlv017WW+zv5t6M18d3kV0B5slHA1u9lk9T37UIu2yBrW1Eq
	0MsZ9lSgbrKw9bdMH0y/+vwdC8Rei7cCEe+STE3fMWLyH9oZSZCZebMSYvkxsOvz2+1bGSO5oXI
	UeCY9KruE4E7a9iTIaSksQREo1nY2yb0FruogDMJpJEzCcfUK2vP4oA2jxxXFCnxzCLvLJ9i2uN
	tFEwIXbhVNim0bbgb45r2zZkPElrquU8cVUgg6zDOw259YO8P2RF18Fi8sTezcQHe62oAZIEzbx
	qa0wByd6MLDrNDRfTxSJpvr7SQ
X-Received: by 2002:a17:907:98d:b0:c12:b2db:873d with SMTP id a640c23a62f3a-c246a2ec634mr3075330866b.5.1787557379883;
        Mon, 24 Aug 2026 00:42:59 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:59 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 9/9] wifi: ath11k: budget the tx completion handler
Date: Mon, 24 Aug 2026 09:42:28 +0200
Message-ID: <20260824074228.2114579-10-julius@bairaktaris.de>
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

ath11k_dp_service_srng() calls ath11k_dp_tx_completion_handler() without a
budget and discards its result, while every receive block below it takes
the NAPI budget as a bound and reports what it consumed. The handler
drains the whole software status FIFO, which holds one entry short of the
32768-entry release ring, and each entry costs a DMA unmap, an idr
removal, a peer lookup under the base lock and a call into
ieee80211_tx_status_ext(). One poll can therefore run for as long as the
hardware has completions to report, with the receive rings behind it
waiting, and the scheduling round the handler now ends with adds to that.

Bound the drain by the budget it is given and account for it the way the
receive blocks do. No new constant is introduced: the currency is the
NAPI weight the poll already carries, so a poll that spends it on
completions returns and is rescheduled rather than running on.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp.c    | 10 ++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.c | 11 +++++++++--
 drivers/net/wireless/ath/ath11k/dp_tx.h |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index f389b97acbdd..676440ee742a 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -781,8 +781,14 @@ int ath11k_dp_service_srng(struct ath11k_base *ab,
 
 	for (i = 0; i < ab->hw_params.hal_params->num_tx_rings; i++) {
 		if (BIT(ab->hw_params.hal_params->tcl2wbm_rbm_map[i].wbm_ring_num) &
-		    ab->hw_params.ring_mask->tx[grp_id])
-			ath11k_dp_tx_completion_handler(ab, i);
+		    ab->hw_params.ring_mask->tx[grp_id]) {
+			work_done =
+				ath11k_dp_tx_completion_handler(ab, i, budget);
+			budget -= work_done;
+			tot_work_done += work_done;
+			if (budget <= 0)
+				goto done;
+		}
 	}
 
 	if (ab->hw_params.ring_mask->rx_err[grp_id]) {
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 2270b2079297..0a4381870496 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -685,7 +685,8 @@ static inline void ath11k_dp_tx_status_parse(struct ath11k_base *ab,
 		ts->rate_stats = 0;
 }
 
-void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
+int ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id,
+				    int budget)
 {
 	struct ath11k *ar;
 	struct ath11k_dp *dp = &ab->dp;
@@ -695,6 +696,7 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	struct hal_tx_status ts = {};
 	struct dp_tx_ring *tx_ring = &dp->tx_ring[ring_id];
 	unsigned long push = 0;
+	int done = 0;
 	u32 *desc;
 	u32 msdu_id;
 	u8 mac_id, i;
@@ -723,10 +725,13 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 
 	spin_unlock_bh(&status_ring->lock);
 
-	while (ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail) != tx_ring->tx_status_head) {
+	while (done < budget &&
+	       ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail) !=
+	       tx_ring->tx_status_head) {
 		struct hal_wbm_release_ring *tx_status;
 		u32 desc_id;
 
+		done++;
 		tx_ring->tx_status_tail =
 			ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail);
 		tx_status = &tx_ring->tx_status[tx_ring->tx_status_tail];
@@ -772,6 +777,8 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	 */
 	for_each_set_bit(i, &push, ab->num_radios)
 		ath11k_mac_tx_push_pending(ab->pdevs[i].ar);
+
+	return done;
 }
 
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.h b/drivers/net/wireless/ath/ath11k/dp_tx.h
index 9303b5ba6e01..b5296cda73e3 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.h
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.h
@@ -21,7 +21,8 @@ void ath11k_dp_tx_update_txcompl(struct ath11k *ar, struct hal_tx_status *ts);
 int ath11k_dp_tx_htt_h2t_ver_req_msg(struct ath11k_base *ab);
 int ath11k_dp_tx(struct ath11k *ar, struct ath11k_vif *arvif,
 		 struct ath11k_sta *arsta, struct sk_buff *skb);
-void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id);
+int ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id,
+				    int budget);
 int ath11k_dp_tx_send_reo_cmd(struct ath11k_base *ab, struct dp_rx_tid *rx_tid,
 			      enum hal_reo_cmd_type type,
 			      struct ath11k_hal_reo_cmd *cmd,
-- 
2.53.0

