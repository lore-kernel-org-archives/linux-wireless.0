Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9AE397949
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 08:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789807621; cv=none; b=PS2mdpew0XGVHugSQwwr+1obvSMPcZJsHFoeJHfKY3IGFAPqVzZRx2pNoCZCOSeVw5RutbpwElSwjFGx/TZxXEYuCyPHhv6iT2E23bAMFXSsv1Not3FN/J5+suUH6VQszdvDlAWHs0YunFyCYe3av2AfkpukO97kKN6AT4GxSy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789807621; c=relaxed/simple;
	bh=wQh8oOwd3AJS0xnjKuwoCAWzE2YC249PM46jHhrKwas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMha3IOc9U26om7a9+T19GtyegDi3vbq5wm+4lSkTe+j0mIBD3EJLtC9ZCPvDyhG+qOV5RYv5jpo+YcTwcsLaBBTN0eHSZlMrX0tu8Z/CbmWSG7XO4WMCPQ6zE/H55W3FJrMdOL9CV6Bz2Er7FNXEvQ5tv95BGns30hkvr2v6H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWMHkNHu; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWMHkNHu"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccda24afso1173940a91.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 01:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789807618; x=1790412418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iwnQmlKstwhwrLUKm+9+EYfHT3GSwcPbs8b4+TyVa14=;
        b=TWMHkNHuiLq5NvRRsef0aZZ4qAB0L/1WTPm4ULS3RykAwNJbeTK8hPUddAEP70Zvbd
         uVggP4G43Jbs2W3xvovh8Tr3WkyVg1eb8rr6MME3IRZg2dvGeazkNxRoul7yTdut9oTf
         4DfVQJt7wVBGjiRRkfe1O+GN9/Ix+n9VEdqq56BmDklcrGQ2vGC+7KLZNFwjVUpkPhz7
         yDcKZwoTlKNtpvC7I9KUE3G1cOR8uQbj4LKBV7tGD70N/9CeDpu2dAwtFuXWXRpblUCF
         mO1Sc5vXwSObY5l3Px88xXvLd7aWIObNpoiBNV+yIP3FOEPnXAoiKCoNf5eCIoi6JKcH
         SIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789807618; x=1790412418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iwnQmlKstwhwrLUKm+9+EYfHT3GSwcPbs8b4+TyVa14=;
        b=AgrW6PGywWZLKqCxhNk45SqfNFVwtUj582gyRAV33o/TCKMqMa588wAnqKZh4YwjBQ
         iDbgt5XE8ZDGglED96Tl3Vu5lNFQNytfsRsezE3CFO5WjwyevtyV7Cr69qFxra5aGsXR
         Iqphi+kFhtpqsI+hZXObj7lpcKx4V3NoaZbnPIWWhAe/Z7FVJlKyupCDiIrEa+x07OdJ
         jROWBlXCVtTpaERI+iN3dF8FflX9LNOjaXgzUtZqmqPzq+L0nE+4+rB8gyAoy7J5BIXd
         dljaXQC04WE+HbviODuaIPpPwwlwbw1TWeDLllI8hTVICWeJzBEVQWr66h/4N57PAT7/
         LjkA==
X-Gm-Message-State: AFuF++msBjxJAQjjGGmUbtTJPImBqgeXb4lC/BE0eYRg42bLm4dI7H45
	1//grNg5IG8IZXUvOxK9vrBD7yICDyPrQqtfUYGdhrV/BkDztR6NmMcuedfcGnLAR1XnL7vL
X-Gm-Gg: AYBFou2+/FxrIK1KJEzqZkou1cxLivndswnHba9rD1tR8lR6jj7UQ93VMIMQbAvBmhJ
	Aszn+l2YM+SB7uH3ezcNRt4vFA8NfZAWxmNg+7dYUw6zJzYcRCE7z8Mo3cGxlpObri2hQGEIiDw
	ahrI/7tEG9iTMM/RfeGZAnWceA1UlVlm8tHzIcac2QrjJXO5m3dHqRqIIyO2HTfB4ZqCLzQZCPQ
	8iEfrQBV+9o3B7A57orwkOrQhme5Vd+kf1biy0xduWce7BBQHIhvNLva6eEPU29YEoQzFVYn7R2
	lZ4D/FLqyVro5J3w7+527G7teEb+m7dL1nhocVrNvkNZF2DFl7MSAkcEt8O8i2n6QK2IJwHbd0n
	4y923w+XOlB4gdmnnvCJgqFa0gJuxvoOdgtlDFRjAs1+/9X5NRwhhcgnzfqDRynAdxL5OoNp9vy
	veH5FGZqGQdv3wCoBTFj+/5BgoKfbuHUeTITb+yF7ofor6x9TY7VQUJ7VedGh5dk1GPjvd/INbe
	OwSG9FsUCQ0a+r6Xf2zlpm5HlVfx9biN4edu6PD32enqYm7/lPilKnka+bpOxPU1m9mwiSJKgB5
	egcS
X-Received: by 2002:a17:90b:1c84:b0:39e:6c68:1556 with SMTP id 98e67ed59e1d1-39e6c6832bamr3861852a91.30.1789807617950;
        Sat, 19 Sep 2026 01:46:57 -0700 (PDT)
Received: from lenovo-thinkbook (42-2-127-248.static.netvigator.com. [42.2.127.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37a88csm3511800a91.8.2026.09.19.01.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:46:56 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH v3 1/1] wifi: mac80211: validate TX status rate metadata
Date: Sat, 19 Sep 2026 16:46:41 +0800
Message-ID: <1243b40f7ec3b44843c55eb42b93d228e37a484d.1789801378.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789801378.git.xuyuqiabc@gmail.com>
References: <cover.1789801378.git.xuyuqiabc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

minstrel_ht_tx_status() converts the HT/VHT rate reported in a TX status
into a group and rate index and uses those to index the minstrel_ht rate
tables.  The existing validation only checked that an entry was present
and had tries recorded; it did not check that the reported MCS, spatial
stream count and bandwidth are representable by the tables, so malformed
metadata passed to minstrel_ht_get_stats() or
minstrel_ht_ri_get_stats() could be used as an out-of-bounds index.

Validate the rate metadata in the common TX status path instead of only
in minstrel_ht, since the values are used by more than rate control.
The legacy ieee80211_tx_rate array and the rate_info based entries are
sanitized in ieee80211_tx_status_ext() and ieee80211_tx_rate_update()
before any consumer runs: an entry that does not describe a valid rate
for its encoding is dropped.  minstrel_ht keeps the checks that depend
on its own tables, i.e. the supported number of spatial streams, the MCS
group size and the supported bandwidths.

This does not take away the driver's responsibility to report sane
values, it only prevents a single bad report from corrupting mac80211
state.  No WARN_ON() is added: with panic_on_warn a driver bug would
otherwise turn into a denial of service.

Fixes: a5f69d94d8e2 ("mac80211: Get rid of search loop for rate group index")
Fixes: 9208247d74bc ("mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz")
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
---
 net/mac80211/rc80211_minstrel_ht.c | 59 ++++++++++++++++++++++---
 net/mac80211/status.c              | 69 ++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index b73ef3adfcc5..60f3e4c8676d 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1193,6 +1193,54 @@ minstrel_ht_update_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi)
 	mi->sample_time = jiffies;
 }
 
+/*
+ * Check whether an HT/VHT rate from a TX status entry maps to an entry
+ * in the minstrel_ht rate tables.  Values that cannot be represented
+ * there must not be used for indexing mi->groups[] and the MCS groups.
+ */
+static bool
+minstrel_ht_txstat_rate_valid(struct ieee80211_tx_rate *rate)
+{
+	unsigned int bw;
+
+	if (!(rate->flags & (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS)))
+		return true;
+
+	if (rate->flags & IEEE80211_TX_RC_MCS) {
+		/* minstrel_ht supports up to MINSTREL_MAX_STREAMS streams */
+		return rate->idx < MINSTREL_MAX_STREAMS * 8;
+	}
+
+	/* minstrel_ht has no VHT groups for 160 MHz and wider */
+	bw = !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) +
+	     2 * !!(rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH);
+	if ((rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH) || bw > BW_80)
+		return false;
+
+	return ieee80211_rate_get_vht_nss(rate) <= MINSTREL_MAX_STREAMS &&
+	       ieee80211_rate_get_vht_mcs(rate) < MCS_GROUP_RATES;
+}
+
+static bool
+minstrel_ht_ri_txstat_rate_valid(struct rate_info *rate)
+{
+	if (!(rate->flags & (RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_VHT_MCS)))
+		return true;
+
+	if (rate->flags & RATE_INFO_FLAGS_MCS) {
+		/* minstrel_ht supports up to MINSTREL_MAX_STREAMS streams */
+		return rate->mcs < MINSTREL_MAX_STREAMS * 8;
+	}
+
+	/* minstrel_ht has VHT groups only for 20/40/80 MHz */
+	if (rate->bw != RATE_INFO_BW_20 && rate->bw != RATE_INFO_BW_40 &&
+	    rate->bw != RATE_INFO_BW_80)
+		return false;
+
+	return rate->nss <= MINSTREL_MAX_STREAMS &&
+	       rate->mcs < MCS_GROUP_RATES;
+}
+
 static bool
 minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 			 struct ieee80211_tx_rate *rate)
@@ -1205,9 +1253,8 @@ minstrel_ht_txstat_valid(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
 	if (!rate->count)
 		return false;
 
-	if (rate->flags & IEEE80211_TX_RC_MCS ||
-	    rate->flags & IEEE80211_TX_RC_VHT_MCS)
-		return true;
+	if (rate->flags & (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_VHT_MCS))
+		return minstrel_ht_txstat_rate_valid(rate);
 
 	for (i = 0; i < ARRAY_SIZE(mp->cck_rates); i++)
 		if (rate->idx == mp->cck_rates[i])
@@ -1235,9 +1282,9 @@ minstrel_ht_ri_txstat_valid(struct minstrel_priv *mp,
 	if (!rate_status->try_count)
 		return false;
 
-	if (rate_status->rate_idx.flags & RATE_INFO_FLAGS_MCS ||
-	    rate_status->rate_idx.flags & RATE_INFO_FLAGS_VHT_MCS)
-		return true;
+	if (rate_status->rate_idx.flags &
+	    (RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_VHT_MCS))
+		return minstrel_ht_ri_txstat_rate_valid(&rate_status->rate_idx);
 
 	for (i = 0; i < ARRAY_SIZE(mp->cck_rates); i++) {
 		if (rate_status->rate_idx.legacy ==
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3d811f652603..1730d48926e7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1164,6 +1164,72 @@ void ieee80211_tx_status_skb(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_tx_status_skb);
 
+/*
+ * Check whether the HT/VHT rate information in a TX status entry is
+ * valid for its encoding.  This is not specific to any rate control
+ * algorithm; all status consumers rely on the values being sane.
+ */
+static bool ieee80211_tx_status_rate_info_valid(const struct rate_info *rate)
+{
+	if (rate->flags & RATE_INFO_FLAGS_MCS)
+		return rate->mcs < 32;
+
+	if (rate->flags & RATE_INFO_FLAGS_VHT_MCS)
+		return rate->nss >= 1 && rate->nss <= 8 && rate->mcs <= 11;
+
+	return true;
+}
+
+static bool
+ieee80211_tx_status_tx_rate_valid(const struct ieee80211_tx_rate *rate)
+{
+	if (rate->flags & IEEE80211_TX_RC_MCS)
+		return rate->idx < 32;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS)
+		return ieee80211_rate_get_vht_mcs(rate) <= 11;
+
+	return true;
+}
+
+/*
+ * Drop TX status rate entries that don't describe a valid rate.  The
+ * status information is used by rate control and by other mac80211
+ * code, and a malformed entry must not be able to corrupt state beyond
+ * the driver that reported it.
+ */
+static void
+ieee80211_tx_status_drop_invalid_rates(struct ieee80211_tx_status *status)
+{
+	int i;
+
+	for (i = 0; i < status->n_rates; i++) {
+		if (ieee80211_tx_status_rate_info_valid(&status->rates[i].rate_idx))
+			continue;
+
+		status->rates[i].try_count = 0;
+		memset(&status->rates[i].rate_idx, 0,
+		       sizeof(status->rates[i].rate_idx));
+	}
+
+	if (!status->info)
+		return;
+
+	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+		struct ieee80211_tx_rate *rate;
+
+		rate = &status->info->status.rates[i];
+		if (rate->idx < 0)
+			break;
+
+		if (ieee80211_tx_status_tx_rate_valid(rate))
+			continue;
+
+		rate->idx = -1;
+		rate->count = 0;
+	}
+}
+
 void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 			     struct ieee80211_tx_status *status)
 {
@@ -1176,6 +1242,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 	bool acked, noack_success, ack_signal_valid;
 	u16 tx_time_est;
 
+	ieee80211_tx_status_drop_invalid_rates(status);
+
 	if (pubsta) {
 		sta = container_of(pubsta, struct sta_info, sta);
 
@@ -1300,6 +1368,7 @@ void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
 		.sta = pubsta,
 	};
 
+	ieee80211_tx_status_drop_invalid_rates(&status);
 	rate_control_tx_status(local, &status);
 
 	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL))
-- 
2.55.0

