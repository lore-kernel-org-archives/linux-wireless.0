Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210B4229BA
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345758; cv=none; b=aBseRfH8yFaJMSHoqxJ+/2mKumVUTog1TbRDO6FINxwlH4C2UmtfRxyx9bTdy1qO8lK7qap3YuwuvYvwO6dK7uVwa/jk8GYIIQ4iOmYyA9PX4vOIP0YXzKqQcKK6DPt0io4lez0Z7295p7e0KcAA6MGvSYFvohsG6vPMy63ABgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345758; c=relaxed/simple;
	bh=qnYKBqg1sOw4ZMa34S8NMaygPYz7QiSI4zvn7YJU1Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgXyLcXU4ffpPRoNdCKCxhrK8JtgNmW1VBJhVUQTHT8qhJnNFv0ovIURJtOCGF+47iJL6gNhSl10tnhGmtEIx/h7Qwp8HhE+5GbZIWen8yjP5ga+/g3Ca8/6hX8XUFsGMmO9+NXL8EmnW5nNArebiJ2JFPjiPLFkX2jFPBvNOSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PXVItv8p; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PXVItv8p"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c445c95d553so9670766b.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 10:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792345755; x=1792950555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNnVVn8ZmmAppQLNnGauLJv1tl92SVrN5Z9s62QXmWo=;
        b=PXVItv8p7BGPGoU2PEk9/O/m9ZXJpdcR9CXNPUWPIaws0BdPY+8Epcztttz646J5yk
         X3GqyFEjptHvTF1cZU0MD8VZQ6HxJ9r2YL5Vg8ULqau0M0mY5hYvpnmLkl+iYIKDs7Ob
         Ms1TK5Qo+IBcP04tGA5uCkeAUoQU5FILHNXJv1hd2nEzaChjSqFUX/voff48N7Qf2jeR
         C41rUnnd61YYAwn0NH9A1sfcbIdX6PCcU21l93HH7ouWE/Scl18voNbgE+Mhw+oTtxW5
         xEXolbIGUUvaHtEAvMFJDWuXTYV4fPlUO8xTXwTXzuEfah2aJUo7Oh7gl+/RA6WnNUfa
         OuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792345755; x=1792950555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNnVVn8ZmmAppQLNnGauLJv1tl92SVrN5Z9s62QXmWo=;
        b=JkayRlZxr3zj8JgYdy/MYdNmZBAEYPoL49byhG2QSjx8jvsZTiMmSaVi86jl5Bw5kH
         ZPp422BvYBSIvK2W81ZGq9Je/R5Umxr3aDkICIHa2kwlpVHtGMknphPCQmL9RN2embGA
         VkX9N6tkDz3wktsB/bI/X9nzYxaP0dr5ciO3XUBM5iULrP9nmlkB534S3ejz4UJvq7JX
         6FQYP6BnY2JJMq9QeX94CVX6O58c8eVCdKLh2fqIq1qhSixI+goa6XpyBmArCjomFjWm
         Z2vo5iSZsh/2O+cNZ8ReWqdgzc3+fj0uDXeh6r4T6QPTPkCShZjCVqQCTuUJzYEY95mD
         OaRA==
X-Gm-Message-State: AFq9FYK2b33EhazqGnzN7o2zhcwgAEmUTUwHAOXMjleTkbl+tnx3Jvf1
	x+ManuXQJ0vpCafIgDUQeL8E5b4cANNIYJxUtIRbLSnckHsjt06Rr19kbAevwbP+3A==
X-Gm-Gg: AYBFou0KiSBx94eoqCjQosV3sfF5P2MIurcd+FAlq0tj3r3sWvbfvP+vZXqmW3HX/5a
	TozZhU1ZNsJ9Ll8gpuX+Maul1/rIgNLixYJLvjWLMt/1/A2SYCt12Jfjt/QAWfsGYNtkx7zT6FF
	C0DXumMdldAcUCoMao1xA3zKy5WpiW5vSAF95s75GlxDleJGNdwTFe2XmOr1nLfdlSs1TIwgNnh
	jfieAGtaBwOt8zwvj1i8ur1uxAyHoee+vM+cUAc5Hq3mG5KQDRuDaalpiWgURIcOELxkwoAakJm
	o9e4COzsbKvHGQH7Wb7moVLDf7ne9zxzjw/oxqBsgIjNRvKvSQquwM1djVnzb7dl1k8Dc0YiwJg
	UBFyf/dVjadN/zYb0/MBswiFWXgEQsGESBnYny3ZgX+kr5hEOZKP3oOdl6PBws7tvh0uxudS5DX
	EVQkNTJ3d4vm4ENgyjjMhp8tL6P5C/qHBCvWUXPjG93I54x+hdVRe7RYZIlImCe2DQfLrbB+zDg
	uRa1MhIwbuz7HFAPBF39I/To5sdNGNo+UUMJ6ppLMREKmPx9wRJ3NI6x0fYjaHCFZKCgIc8ycE2
	bjdCrlz9swBtdyIIVdg1Ofoa9yt0PiwlWaxTBD/7PtkbYIaPJidsTgUCEG3088nicJmfKH63ycg
	d9qxZjgGswIURHkJoG3Eu/ZWazQ0xOImD+5t/VLXQ6sOrE8vVlVRVIoy64aC4Zq+aZrnqKFL7nd
	kvMjN4JyMP
X-Received: by 2002:a17:907:c305:b0:c31:c767:adfb with SMTP id a640c23a62f3a-c4196aa9278mr343812566b.0.1792345755046;
        Sun, 18 Oct 2026 10:49:15 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4091eb14a7sm291056366b.76.2026.10.18.10.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 10:49:14 -0700 (PDT)
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
Subject: [PATCH ath-next v5 4/9] wifi: ath11k: report tx airtime and enable airtime fairness
Date: Sun, 18 Oct 2026 19:48:59 +0200
Message-ID: <20261018174904.1757161-5-julius@bairaktaris.de>
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

mac80211 charges the airtime deficit only through
ieee80211_sta_register_airtime(), which ath11k never calls, so with
NL80211_EXT_FEATURE_AIRTIME_FAIRNESS alone every station stays in
credit. Register fes_duration_us from the PPDU stats, which ath11k
already adds to arsta->tx_duration, and set the bit. The TID comes from
the ack/BA status TLV, sent only for a PPDU that drew a response, then
from the completion or rate TLV, then BE. Each user of a downlink MU
PPDU is charged the whole duration, as arsta->tx_duration is; every PPDU
on this hardware had one user. mac80211 takes only
local->active_txq_lock[ac] inside the call, which runs under
ar->data_lock and ab->base_lock.

'iw station set <mac> airtime_weight' fails with -EOPNOTSUPP before this
patch and succeeds after it.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath11k/mac.c   |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 6d95f7b343a55..8b9df63966989 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1382,6 +1382,7 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 	u16 rate = 0, succ_pkts = 0;
 	u32 tx_duration = 0;
 	u8 tid = HTT_PPDU_STATS_NON_QOS_TID;
+	u8 airtime_tid;
 	bool is_ampdu = false;
 
 	if (!(usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_RATE)))
@@ -1490,6 +1491,22 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 
 	arsta->txrate.bw = ath11k_mac_bw_to_mac80211_bw(bw);
 	arsta->tx_duration += tx_duration;
+
+	/* The ack/BA status TLV names the TID only for a PPDU that drew a
+	 * response; fall back to the completion and rate TLVs, then to BE.
+	 */
+	airtime_tid = tid;
+	if (airtime_tid >= IEEE80211_NUM_TIDS &&
+	    usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_COMPLTN_COMMON))
+		airtime_tid = usr_stats->cmpltn_cmn.tid_num;
+	if (airtime_tid >= IEEE80211_NUM_TIDS)
+		airtime_tid = user_rate->tid_num;
+	if (airtime_tid >= IEEE80211_NUM_TIDS)
+		airtime_tid = 0;
+
+	if (tx_duration)
+		ieee80211_sta_register_airtime(sta, airtime_tid, tx_duration, 0);
+
 	memcpy(&arsta->last_txrate, &arsta->txrate, sizeof(struct rate_info));
 
 	/* PPDU stats reported for mgmt packet doesn't have valid tx bytes.
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 6f4462b7d3f15..eca16a151d068 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10653,6 +10653,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_AQL);
+	wiphy_ext_feature_set(ar->hw->wiphy,
+			      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 	if (test_bit(WMI_TLV_SERVICE_BSS_COLOR_OFFLOAD,
 		     ar->ab->wmi_ab.svc_map)) {
-- 
2.53.0

