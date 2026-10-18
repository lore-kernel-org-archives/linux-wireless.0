Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5E641687C
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345766; cv=none; b=bPRVYkeRh2yvy++8Gu/zhNCueZa2bU4EtaFkaDYkPkdUuPZJD57ygiPtB5vgmO2dyYuXQCvabMogX26OSA4jbtq9aGTP163HGGPlOEWY3jjCf0hn4kfHgbL6aOTL6fRJbyRBbtxbuTv73wNR93FsptsK3icw91n8zKIurawTAFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345766; c=relaxed/simple;
	bh=ZgAH1aO17JCTl3Ktzh4EF5ov+WcA77yVVym4c2eRQd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC1JgZacydyPvkAlsBVaQSMmuUjCyRF+FETjtBE8Dc36ft9z+CsMSzLCDJwQHvQr0lTvWLrk0X6QxLdp+rWiZr/RQCb4yhyBMOzsSVRry7YGuZXPmrFjx2XfSqdlcHMojWNFYoxsMLMDH+JcMsqX7+VmpsqkegRUt9Kq/rBGXQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=n6Kk5LNI; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="n6Kk5LNI"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso4261722a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345762; x=1792950562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VpsxtVvi9ogB8U9CtpikmUlQdCiUBK5dcmVCHnoFJIw=;
        b=n6Kk5LNIqBxLR5ywlTA4K8103xgmMyKKwOhWXlhnERKK1RFHFbT6/RH1d8QpFusMbY
         nSMTWWdyDwIVo5j8Di2y8G+LDaBb6+n7cLbGohQ0IBkkILe6ljjnTlMtK0AeTp1oxYz7
         LdSFo+pltQVwpVw9qSmZs2UNohxy64lGjWCfuWO1rRBFRQWQfq+nLokgYzi3Krq6RFi1
         nn0Am2+BurPAMyKv0krHRVsNm94Dz8UfJD4svzSfNS/AmGTby2283spbGZ6nYtRyaaJN
         BP5bETOieJpFOUMJrsLbxHOz+rZQSeaUBV9rcnDaxEJgCAOfQY5fKSyUrIM0dKGdEFuO
         ut0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345762; x=1792950562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VpsxtVvi9ogB8U9CtpikmUlQdCiUBK5dcmVCHnoFJIw=;
        b=1j0X2UppsVgRy7JVOyU4LlMQoqcaK9E5qF198ghZI+UeD38Rwnev8IHT0Kx6txqrN2
         W8v+JlyTFx8KhYJVTtl+1QWu3GcydbFB6+dJPjR9jz8XrTvkWV/ke2pVAJ+2vJBJoS0a
         +MP3gkGaAxLxVmvQ8kmsf+T1rcCCPTDH6yVIUuPRbwOd6D94LnoASOc3CsdBoBmCBEFX
         mBStYf+6NA/9dIk3+quo/4c5tEA6Of9VxolHK6qK2wiL6t65ijZaDJF7nvha92S19ROy
         0OX1ZJc4ZqgTio1IrGoGdCzVXLiVBRBW+0DeU1hxk59Q3lgyisUjUGw6GsBS/agBZGZA
         lYuw==
X-Gm-Message-State: AFq9FYIICTsg0DP0MwinOTH5pTpo4agfzcPueITBGt/3JDtBKSa+mvR1
	JZPD6WAzEnXVK5wCQ8yn6j6L41ws7D0jcdkA6wKgUTW7X21I8LA5RDbiotglmScayQ==
X-Gm-Gg: AYBFou2gYbg/rq7X+WeLxL/hc5dtGPMQdYWPDAHTqFVt/qDBsMuCoe8hQrtdi2fRkvM
	6ZsGc0QWS4ysolvx2aCQ9RE90sZTTXSDSalVQlSIk/vyQ1yIRvA9H+MHUD8eco+jJmMllvf4Ms6
	YHlSs2VDQsekd26ALqWrxC1JxL/01E8/2uCNtXvHIBD2hWpArtnO2jwGrFeWBTp8Lop3a+7W7Ju
	WzBKPkfvRlod2fB91IvYf4FomS93hj+oqmjna6vA8+Eb0q02MqJC+rcf4mZk3JqtGHKa3TykKG7
	0S1wZ1NALrnRtxmWEKnu7jT59SgNV6vIDId51dbhxuNOEMxNrl4MGihVhMIlMbMNDTfyUauYOba
	i6hXjlgvla18ATFnzXBp+ekZiyLlsagxv+VLdUyUMkA8asE5TD7kFzherrJsKN9uL6rPGs/z1Rx
	6dhIYzTSKpIOAOiJ+7nUzrpb5q5umVfrSimMHmZ9reqQ6vhsfc5bHMAFpaZwXMDg9Mxs2LGn4tW
	xPp0dlV+aYqwR9N+AflsnVkDw6zBqLO3KCrRPoSZByEaA+ppfocPigaMJTHBv1S5UY0PO546rGF
	C9e4TAIIq6TNoe7G38mCXITxAIQ68GIBtT3w9qYCv9Egnf6GPsPfesd25UlpVRwf8QYh4dWsksR
	GzAK2JWkplaBb/0V2KGyNV8AognHs2PuBSIXaYsjsPayqWtEmVEdsR1U3Acm/xR5c3h1qFM7Xn+
	nGCXqqy3E9gVoqfeqsoZg=
X-Received: by 2002:a17:906:4795:b0:c42:fc8b:6c6a with SMTP id a640c23a62f3a-c42fc8b8ea7mr172167566b.14.1792345762000;
        Sun, 18 Oct 2026 10:49:22 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:20 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tamizh.raja@oss.qualcomm.com,
	jtornosm@redhat.com,
	baochen.qiang@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	sriram.ramachandran@oss.qualcomm.com,
	yaojiale02@163.com,
	quic_pradeepc@quicinc.com,
	kvalo@kernel.org,
	sven@narfation.org,
	john@phrozen.org,
	toke@toke.dk
Subject: [PATCH ath-next v5 7/9] wifi: ath11k: charge received airtime to the station deficit
Date: Sun, 18 Oct 2026 19:49:02 +0200
Message-ID: <20261018174904.1757161-8-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018174904.1757161-1-julius@bairaktaris.de>
References: <20261018174904.1757161-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211 charges received airtime to the same deficit, as AIRTIME_USE_RX
is set by default, but ath11k reports none. Register each received
PPDU's duration, which ath11k already adds to rx_duration, once against
the PPDU's first TID, or BE when it names none. The TID comes from the
PPDU end user stats TLV, which is added to the default monitor status
filter. The call runs after ab->base_lock is dropped, under the RCU read
lock.

A station uploading with DSCP CS5 moved its VI deficit in 3 of 3 runs;
uploads marked BE left it unchanged in 3 of 3.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 14 ++++++++++++++
 drivers/net/wireless/ath/ath11k/mac.c   |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 8b9df63966989..42ce3dcff5ce9 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5275,7 +5275,9 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 	struct sk_buff_head skb_list;
 	struct ath11k_peer *peer;
 	struct ath11k_sta *arsta;
+	struct ieee80211_sta *sta;
 	int num_buffs_reaped = 0;
+	u8 tid;
 	u32 rx_buf_sz;
 	u16 log_type;
 	struct ath11k_mon_data *pmon = (struct ath11k_mon_data *)&ar->dp.mon_data;
@@ -5329,6 +5331,7 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 			continue;
 		}
 
+		sta = NULL;
 		rcu_read_lock();
 		spin_lock_bh(&ab->base_lock);
 		peer = ath11k_peer_find_by_id(ab, ppdu_info->peer_id);
@@ -5342,12 +5345,23 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 
 		arsta = ath11k_sta_to_arsta(peer->sta);
 		ath11k_dp_rx_update_peer_stats(arsta, ppdu_info);
+		sta = peer->sta;
 
 		if (ath11k_debugfs_is_pktlog_peer_valid(ar, peer->addr))
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
 next_skb:
 		spin_unlock_bh(&ab->base_lock);
+
+		/* Charged once per PPDU with the measured duration, as on
+		 * the transmit side, to the first TID of the PPDU; BE when
+		 * it names none. Outside base_lock, which tx completion
+		 * contends for; sta is held by the rcu read lock.
+		 */
+		tid = ppdu_info->tid < IEEE80211_NUM_TIDS ? ppdu_info->tid : 0;
+		if (sta && ppdu_info->rx_duration)
+			ieee80211_sta_register_airtime(sta, tid, 0,
+						       ppdu_info->rx_duration);
 		rcu_read_unlock();
 
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 4527ab6977d04..d17f80cbcdb5d 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -229,6 +229,7 @@ ath11k_phymodes[NUM_NL80211_BANDS][ATH11K_CHAN_WIDTH_NUM] = {
 const struct htt_rx_ring_tlv_filter ath11k_mac_mon_status_filter_default = {
 	.rx_filter = HTT_RX_FILTER_TLV_FLAGS_MPDU_START |
 		     HTT_RX_FILTER_TLV_FLAGS_PPDU_END |
+		     HTT_RX_FILTER_TLV_FLAGS_PPDU_END_USER_STATS |
 		     HTT_RX_FILTER_TLV_FLAGS_PPDU_END_STATUS_DONE,
 	.pkt_filter_flags0 = HTT_RX_FP_MGMT_FILTER_FLAGS0,
 	.pkt_filter_flags1 = HTT_RX_FP_MGMT_FILTER_FLAGS1,
-- 
2.53.0

