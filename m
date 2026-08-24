Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD703399D0D
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 07:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557379; cv=none; b=C82ZjabpbfgL7mmi/j6AJRtOoIOGXMt+8NVGbRuYYCKHudZy4076uvXaR5XfFATd486RMYeE/E8E8v1d3x/JSAp+hDcmeV57fmHjbToYW6THQhvS4rlpaBZRBR03NOcT6V7KDDd3RjJo/T7lnJ7VJfvdkqUlaKlhz2P/yog82aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557379; c=relaxed/simple;
	bh=p31/Xvf65JeO/q8DSaJZOd8MZrV6bgHXXj3pKhmNZSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHg60G/DndnpG11yJHmX46B8qmsm3L+oMV8G+2E2AAFfO1OxtyYB4CkMTrXqBgL+DuKADol5CWa8Oi5fXGRUOmzBSDED4V6Oq0RFI88VlxsTCPQdimkhWv6uBLj5OUVSTThoiKqC++8HsrNCrMr7s+x9Cu8Dk5CrfVbbyvjCG3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=kv8UwLGB; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="kv8UwLGB"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c214321dc32so615280266b.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 00:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787557375; x=1788162175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o6H25IhW3xS5zD2V6sWstLC40W2D2voHGreESygqwOc=;
        b=kv8UwLGBp27QgjjK2dNagm+hiTBDGYASNh9SGUdh9xq6HZaFYnkIsS35vGZrdxc3jK
         Ie7Z/n/Wq9J6mZRNgDa5H7mXwY9qK6hckiIhZsEpKrbqmoQelitbKOnIUBytoDPu9Gv4
         g7zzmYGme86RJDsIFE9FCJ/4qFMjzN1qiKr6D7gv8PfykUqX53Tsm2h5HzNvcM+wgZp4
         M2od4tiBdLs+o7lw/c2g28DQQhbPKIO530Z1rf1y7zkMJxv8/BbOEiRfi+pbZy3YpqTy
         B6Gpc1HAm5eDdg4tMR5nwx4L26s+IamRCidPkVu9T1/oraCo2iXdP49BPBSY0uN26jOh
         9YGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557375; x=1788162175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o6H25IhW3xS5zD2V6sWstLC40W2D2voHGreESygqwOc=;
        b=ok36lQrpgbQVyl7e66IcdRnfxIb4sNs2IYN357EZY7h6ds3pTgdxAJTk8wbBnCXjQU
         Nm4nLLyQe4uYVm8q4BX9eHSFHL0hgFTwht1hytdOT2nvGhuAWu1Virrav/km4+duy82L
         ikyCcTIDCg2BJrZTg9vnwjhrLGiy0Xka/s4swfzx7oujfvqDd/Nx144paFuYarFf7Rjn
         Szk+midyHYpQLDbM40eFecnpVP7Ef3jdjz4qjkvI1U3RodBw609WOeFgel1nxMJVMDPt
         kGn2a69YWFRtMK3wPtoBRGqoKLfzPvZOhIXFXHASyAWDuwH4q4n/1BrJXOfH7o9Qgf3n
         nEAA==
X-Gm-Message-State: AFuF++nhWZN7C7V7OE9dPZN4JGpXRAV61Oq2xeIK9EjcU7XviiV75XNI
	cNAA3VgyILQHYcHXLVg5A+sBwpE5mj5SCrmXzIZ2XwQ6cTxz5NpJH7p2XdoQ9yqEPQ==
X-Gm-Gg: AR+sD10yrDoXaSZvz2ykiFudiro9mohgQnD24RQ0HVOgzFNYAIU6wtI/FjzKHDOB92r
	KMgPADC2hS6tVWtSF/+q1dv7/Wpn5/XqFMyLTR+h+tONkJenGUSnS3YQE12Rh3mtPDNA59KogVP
	i5E1jgj4ol/D2s+h0qrDJMKEuIxK9mfzetFInjHXbt89t+GjIiYyol5ZG/a2iZwRlvU+TpESpyh
	lXOXIc00ISjfbFYHsS9ZxamiV/ZHcWInuQzH0DmToaRWfGjj2ApfQOG8nVTNRDQG1cWKDnSHQ33
	/Uxo75GOXB5e+nUfkSq9lhn1fQKYa6C9PL16rI0xkmRX/dXOe/YUGMbBbPNJUpPX3dKWISJ5lGJ
	wz1n1H5Z7APEuy8Jrbgno1NOkFppW+EBVJHzXuuW0wo70OLXYEaTIa/kRolVnDgGRbWFqxa7eAA
	bslUYD/mPaSCrwjr9A+e0/UA4qeKFLOrUKAJ0j0Oz2m5RZ2Uw3we6Q6mEnpswSR446bi5DtA334
	FAEnr+IYMhY8hOPQ2tHO95BRMeOxcR/yhgX/dQlfX5VxEQhW+8ikXK3KUTRQ5pj4phVqtoxeT8/
	aH4pimISu8MtvZTWkvt2y1KNlThRzKUFYRQykSHqz1vplvhUX1OXys1AlBAi2XVsrmt1NaKf0bi
	HAJJFNH+0HkBbDQvOf82pWsohqbOvjq/T3vebIFnq1IJbq4YuQ/WsqZjaGqXn1KuA/7wJdvGD+/
	dJAp7sxgH5rk6Hmg==
X-Received: by 2002:a17:906:3e5a:b0:c20:2165:d74f with SMTP id a640c23a62f3a-c246a6ca4f5mr2287983866b.22.1787557374842;
        Mon, 24 Aug 2026 00:42:54 -0700 (PDT)
Received: from Desktop (p54affeee.dip0.t-ipconnect.de. [84.175.254.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249685ef7bsm1261549266b.52.2026.08.24.00.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 00:42:54 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next v2 4/9] wifi: ath11k: report tx airtime and enable airtime fairness
Date: Mon, 24 Aug 2026 09:42:23 +0200
Message-ID: <20260824074228.2114579-5-julius@bairaktaris.de>
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
ack/BA status TLV that ath11k took it from is emitted only for a PPDU
that drew a response. A transmission that timed out, was filtered or was
aborted names its TID only in the completion and rate TLVs, both of which
already reach the driver and were read nowhere. Take the first of the
three the firmware supplied; a PPDU that names none of the sixteen QoS
TIDs is charged to best effort, the access category mac80211 queues a
frame without a QoS TID in.

Measured on an IPQ8074 AP with two stations on one radio, a 1x1 VHT
client and a 2x2 HE client, both receiving at once. Before, 'iw station
set <mac> airtime_weight' is refused with -EOPNOTSUPP and the per-station
airtime file reads zero. After, the weight is accepted and read back, TX
airtime accumulates, and the per-AC deficits move.

What the deficit can do with that is bounded by how the driver hands
frames to the hardware, which the following patches change; the airtime
share this alone produces is reported with them rather than here.

Two properties of the source are worth stating. fes_duration_us spans the
frame exchange sequence, so it includes the SIFS and the responding
BlockAck, time the radio spends receiving; the airtime registered is
therefore larger than the airtime transmitted. And it is a per-PPDU
field, so on a downlink MU PPDU each user is charged the whole sequence.
No per-user duration is reported in these stats. On the firmware tested
here every PPDU carried exactly one user, measured over 21051 PPDUs, so
the MU case is latent rather than observed.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/mac.c   |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c084..05fb34e70889 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1377,6 +1377,7 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 	u16 rate = 0, succ_pkts = 0;
 	u32 tx_duration = 0;
 	u8 tid = HTT_PPDU_STATS_NON_QOS_TID;
+	u8 airtime_tid;
 	bool is_ampdu = false;
 
 	if (!(usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_RATE)))
@@ -1485,6 +1486,27 @@ ath11k_update_per_peer_tx_stats(struct ath11k *ar,
 
 	arsta->txrate.bw = ath11k_mac_bw_to_mac80211_bw(bw);
 	arsta->tx_duration += tx_duration;
+
+	/* The ack/BA status TLV is emitted only for a PPDU that drew a
+	 * response, so a transmission that timed out, was filtered or was
+	 * aborted names its TID only in the completion and rate TLVs. Take the
+	 * first of the three the firmware supplied. Its non-QoS, management,
+	 * nonpause and invalid markers all sit above the sixteen QoS TIDs, so a
+	 * value counts only when it names one of those; a PPDU that names none
+	 * is charged to best effort, the access category mac80211 queues a
+	 * frame without a QoS TID in.
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

