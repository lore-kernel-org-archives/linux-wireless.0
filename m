Received: from mail-ej2-f8.google.com (mail-ej2-f8.google.com [74.125.228.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A72538D82
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788875622; cv=none; b=HkBX3+ZA5dq2f5Q6SVhsYjufJtUzRvc/qypzyNOXbtkJ5TEBvwxz6aAoNVOynuTJyY3d8zWY8G9xGuW++cxd0ugicpLWxVbAxjQnqySjbkwUPsLzqgd1AHxLzKlqNFB/jYkALNYt4qVGuNcHh+L1GOWccDmBplSVqC7hGnhXkVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788875622; c=relaxed/simple;
	bh=ui7a4a3Woi27XfGFxXdwer5CuptT8ACQe6AUJ8sgdPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYX4AClJmD/5lpCBrt0mF7gjUqKtz3Xe7lsr32WO6VSLK0uwJKYboEByP41PX9bgpo0/uo3PqQcjmf3T/ddZQCdg8baq4zJqeRr/BQtadT6M9UFDn6cLi4ynnZHSHfq9FVzBX7Q55theeck4m5FiX/e3GyueV1d47ci/pY3X+Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=ZTLi9sj6; arc=none smtp.client-ip=74.125.228.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="ZTLi9sj6"
Received: by mail-ej2-f8.google.com with SMTP id a640c23a62f3a-c2537a164b8so171062166b.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 06:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788875603; x=1789480403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aI13hMT4+xLSGth65Ot3fMrBV+yKj5UHO4cpBnEI4T0=;
        b=ZTLi9sj6FuIhK1cRGSAf/YkqYixA2wIuvj4zrxzB8f5QVlsoIT49FP8h7hAj8plLv7
         5l856ildSQFTff8hRnu7kik+6P0lKm+JEaCMqC657ESGL9ZFt2UByzM0L7czYL0cFl3h
         xWpvU/0M5p8uKYptKCyCDYigHpRlJulJJmYxK81z9LIirZpciGQNaa+cCrWqVYgyMA1a
         PQ2cm+L3iWx4sESXvZh5ycY1ONKZY8xier+MxqESbNcipY3Le+r51DQm9LBj2PvFFZ9/
         SUyC9MQOIpY6DM21rr2N7e/nKjz3lqkC2vbRd9ucFfgyEkpoLKdQO7Ge2mC/cvqgSTtU
         hAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875603; x=1789480403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aI13hMT4+xLSGth65Ot3fMrBV+yKj5UHO4cpBnEI4T0=;
        b=hc34EJUi76xPIbKqJvBSz2/bZckyEBvha/Cq3cfiRomWWJ/p3BYsrFp1lz6dIHnpGM
         n2Zee+KyQiOJJIoBlT2IBFPvCq6o+rkRY/SSAFxvmG7cviaKgfOJsuFLHQ/a35DHKPao
         S7mdE3zXhF2sUzOS14tcgk44Lm03eKpBXt/5yYnm2pSRKbACMY8MzhtmqiYAGUO7qK5/
         Zx4Y4r3iWDv964OBwcR257521qsD/33mKGllvHthm84FDOFqimkvYLzklzicZD1RilYD
         niwlx8IHmInEp9CLvUuTlAIg43c0dW1VIRTOBJtajke9kEKHKEXIdsEA4EIN/V3DUsmo
         9/Ig==
X-Gm-Message-State: AFuF++mxQviXUOIFhBnZDW7idXGpqGf5IrgX6zDSCc9Fd35AUC2LhvQe
	CCz8qYsJQf0TVvuL7aRrlyJn2O2cgk5S/w0+ra920r/Smbla1//gIvkB7w4qB7XLag==
X-Gm-Gg: AYBFou1CK6k8IeB6VJg9xLV9UBu+X6/RSUW3iLzLCaGJHn7FxQmFiIZRO57j8X3Lv0J
	fuRG7alnksbLuL+hUpNmc/8kIGcH3zbM6/ulDWehY1M8NzmvcM7koaskSvPF7RxcbVEb0j17jQw
	Rtr3qq7lMinYoecZZxtb+Je+dxk4ArmEah++z5+vTbvWoSfp95X8tnGsLiq9aHdGGt8EnYlAz9D
	aYzNGOxF8LGhC2yZFyAwhEkDMLIESObRMN4sirj1kvlQ2PUimZsSKRZ1k/SzLZpRCeUtyOcR2nF
	54RsgrJpC9qsSXdX4XWRv1c9qrPmxbirv9t2Br2iXrRpuSukB2p50rlYTrMtuF7nkQjhM32A3IO
	Y6pg1NF1Lj7UiyTZsJqbEzz/BkM9aP/rE7FD7G7LB5yQ1kBU9PgQyCwsDryTgD4ilFj4zLhgCR0
	OJbK4WuKxzrHowXT3M0pI2W9baltuVMwt91ehNmoxZbMRLJAv+RokZN9BZWftPYGV4N7XAC1HWY
	332IId0HtW+hpWw85RrrQ8PKp0kYaz5dlsV2cZBARLcM+mmufPtSh3+tmJ6LoOIzp9IwjibbnIs
	kzHFohhHhKIJWEDqjEDDHeGubKk4u7BNftGn1RJyGGNyE7GuW2RurOgsuhjIWY8it3wGdkLibZ/
	GPlXBpJrM61x7pfdy4Q1QxWGTz6YytfaNA2la1Ed5kO1ccb+8SamG9s+cLO4EXluBYWuONNiq/N
	R3EoeZD28KR8j6
X-Received: by 2002:a17:907:d649:b0:c26:19e3:e982 with SMTP id a640c23a62f3a-c2619e3eee5mr931925666b.34.1788875603444;
        Tue, 08 Sep 2026 06:53:23 -0700 (PDT)
Received: from Desktop (pd951346e.dip0.t-ipconnect.de. [217.81.52.110])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d5cdf7asm647602666b.58.2026.09.08.06.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:23 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	toke@toke.dk,
	sven@narfation.org,
	quic_vthiagar@quicinc.com,
	john@phrozen.org
Subject: [PATCH ath-next v4 4/9] wifi: ath11k: report tx airtime and enable airtime fairness
Date: Tue,  8 Sep 2026 15:53:13 +0200
Message-ID: <20260908135319.754140-5-julius@bairaktaris.de>
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

mac80211's airtime scheduler charges sta->airtime[ac].deficit from one
place, ieee80211_sta_register_airtime(). Unlike AQL there is no estimator
fallback, and ath11k never calls it, so the ATF feature bit cannot be
advertised on its own: the deficit would only ever be replenished, every
station would stay permanently in credit, and the DRR would be inert. The
bit is not a no-op in that state either, because it also moves txq
insertion to the head of the active list, which __ieee80211_schedule_txq()
documents as safe only because the DRR moves a station back once its
deficit goes negative.

fes_duration_us arrives with every PPDU's stats and is already
accumulated into arsta->tx_duration a few lines above. Register it, and
set the feature bit in the same change so the two cannot be separated.

The access category the airtime is charged to comes from the TID, and the
ack/BA status TLV that ath11k took it from is emitted only for a PPDU that
drew a response. A transmission that timed out, was filtered or was aborted
names its TID only in the completion and rate TLVs, both of which already
reach the driver and were read nowhere. Take the first of the three the
firmware supplied that names one of the sixteen QoS TIDs; a PPDU that names
none is charged to best effort, where ieee80211_sta_register_airtime()
also puts the management TID.

The call runs under ar->data_lock and ab->base_lock. mac80211 takes
local->active_txq_lock[ac] inside it and calls nothing back under that
lock, and ath10k registers from the same place under its data_lock.

Measured on an IPQ8074 AP with two stations on one radio, a 1x1 VHT
client and a 2x2 HE client, both receiving at once. Before, 'iw station
set <mac> airtime_weight' is refused with -EOPNOTSUPP and the per-station
airtime file reads zero. After, the weight is accepted and read back, TX
airtime accumulates, and the per-AC deficits move.

What the deficit can do with that is bounded by how the driver hands
frames to the hardware. Every station keeps its full airtime queue limit
in flight and the hardware picks among them, so the scheduling order
does not reach the air and a weight moves nothing on this driver by
itself. The bit is what makes the weight settable and the deficit real;
what acts on them is a mac80211 change posted separately, which scales
the limit by the weight for a driver that says it pushes everything.

fes_duration_us spans the frame exchange sequence, so it includes the
SIFS and the responding BlockAck, time the radio spends receiving; the
airtime registered is therefore larger than the airtime transmitted. It
is a per-PPDU field, so each user of a downlink MU PPDU is charged the
whole sequence, as arsta->tx_duration already accumulates it; the stats
carry no per-user duration. On the firmware tested here every PPDU
carried exactly one user, over 21051 PPDUs.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath11k/mac.c   |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c084..68472e1e748a 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1377,6 +1377,7 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 	u16 rate = 0, succ_pkts = 0;
 	u32 tx_duration = 0;
 	u8 tid = HTT_PPDU_STATS_NON_QOS_TID;
+	u8 airtime_tid;
 	bool is_ampdu = false;
 
 	if (!(usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_RATE)))
@@ -1485,6 +1486,22 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 
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
index 38f641bbc53c..40a2b6d2f804 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10593,6 +10593,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_AQL);
+	wiphy_ext_feature_set(ar->hw->wiphy,
+			      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_STA_TX_PWR);
 	if (test_bit(WMI_TLV_SERVICE_BSS_COLOR_OFFLOAD,
 		     ar->ab->wmi_ab.svc_map)) {
-- 
2.53.0

