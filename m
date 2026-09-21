Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7C146D5A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 02:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959136; cv=none; b=idyh9LnQ5V9GQbNh+rh1kN0w/5x/Y/BiCKImhWCkUVnxmssrkDKw+jxXhFIQzit/LUkvh9BWXtRxEXzaows3nf3A1YiUrh6JcAhq5ufJI32v60xrxcGIXhF4TRXp3uPdpiNVEw3WgwsTlXHI4i3KS8Xrp7mVpXNs+nDeIy9/+nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959136; c=relaxed/simple;
	bh=iUEhDLd+fcWB5gAv3VgBiHnRBmXIlQ90utvFWNoUiek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZev/fpRn53ZdRt9Qul0DOifX34U7SK2P+jAulr/ueJW1lFndTlXzAdEZq1VnL51l0QY7DIPgrejiD8zptHG1rV07QMc/fYU8u6Xmrz0RbxKirQamfC7GnsIcKNcyJmXrh3Jfsn3kF95J3htrFt1OyCR3Nov9cCy/1aU+6uKSTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=USBI8Dn0; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="USBI8Dn0"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f0b25dso27249805ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2026 19:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789959134; x=1790563934; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w90vAi+aujL5E3ajWwEfIMTY75kTaUq3YOXsPNYV5SY=;
        b=USBI8Dn0aXvF03VrTsyfUhwGlJYcjnE+u7x1A0/4QHKBSGoWJJXCa9o1ZnibYlaM4h
         MtAO+T09QPT652lZ79hnoPw4+uFPM1RK7zqCM47AfhSfIXNnTZr1P8UFInd3Nu6CyjSG
         75yVaC0L0FPeZKYGLlS8QKP7s8jw8KVPJP1NYPds3u35jdZ/wVHXfu4hrcxertXT6API
         nCJqyxUy+fybHm17ACKNJlWNVndsMH7ytMR7roh4py+HRTzbOMI9vt2ci9/Xykf5F0uk
         8762ubzy3kHCRueFKyjLKbzYq89yCIIHF/NH42NkS6plRUNx428UEfaH/Pc0NIDhFwUk
         lqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789959134; x=1790563934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w90vAi+aujL5E3ajWwEfIMTY75kTaUq3YOXsPNYV5SY=;
        b=O158XTbjTMgmAkHDuH+5j4cc5XiJ9k6QwlaOLAx0ByTWvZALu7dtukFZxW4UXblb50
         bjNIBTZ6gTa6arfvr1R5MLSDF6LiTGlNYVBnbdd2/tSXqb2XnLmDQTo55jCTuejkuIgV
         U8lJqzcc5Mpv3MDX+NisWYotxzQcHUVrWuS/hsmPA6/JPt5c4hh9uBtYewz7QkMaOKF4
         SfZgFxsiTZCCLa+JJtJ4FpWuhILn51T/C8UaQVVk/9WL3vF9wLtnW3ju987aWZx3lL79
         U6j+tIh9cmh9GwH+XsYwl2Ke9SY2ugajWwE0AnaSkQmtj6AmSem99H4ARWKoVaydQ8mg
         +GJw==
X-Gm-Message-State: AFuF++n/BelAvrSgGOaE8WlGQYYQa86n0VwTcJb3G7FsJ49kUZUn3ePu
	bhn0hWIV0KvIZmnDpNKtkGeaNRIVEr7ABEThHWj0i3pUm5EEHoS0U22Rp4yOk7ZmxkOYhvV9
X-Gm-Gg: AYBFou2bd6+HbFZZ+j35RuMuzq2OQkGxCfocbjm6couoQPG9yKQDVOlN11ppQg4Igdp
	2MJ9NpJDq1HpgOKTZmwmDB7D6B2lCc9TIXC+sjOWxIpg5mSqmCc9NMByXqYSaCyP6et9N0NbgKI
	BKE+lF2wYWfEh23ElKQavUb/EJ9eopLad1VSTj3Fh5u7EICI91AZIKyHKWRwxNG+i55gpVLnkEw
	4IM1rzjOkyvlLjee1HMCykYzFU7jCvfusHLsqpp8gEouOZdc+Py1+rwkG+ZDDtGuxYunBhfxu91
	F1gRSIHUUs12KyixILqcpS5gfTRI2hCdtaBDv/AM+wd2N4RLHN25HNdGu8kOJZFgwfRWnoRr9vY
	eB88QWWElDabrRLrOO3RkBI7fngZ1M4Mk8rVQLSD8fx1WL/m/2rwR6fvLKsAU+bW/XjAg1rNzoe
	nve9cqRy/rvHG291Y3Sd5/GuPGgTf6EJnUSnrg4lpW30NaYiyT/AyU/29tatSNSvGeXb+QKp2XD
	gevJTwI3olm/9T7Xq3hOzvAfgAWapnBgTXFgnCJJ0HSXZu/Ln3t9AzFqvX/S4KXHq+2xHzc7Y0I
X-Received: by 2002:a17:903:2f81:b0:2dd:c054:197e with SMTP id d9443c01a7336-2ddc0541cabmr91958045ad.35.1789959133963;
        Sun, 20 Sep 2026 19:52:13 -0700 (PDT)
Received: from lenovo-thinkbook.lenovo.com (n11212025079.netvigator.com. [112.120.25.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2de217b3a97sm24898935ad.31.2026.09.20.19.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 19:52:13 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W . Linville" <linville@tuxdriver.com>,
	Vega <vega@nebusec.ai>,
	Ren Wei <weir@nebusec.ai>,
	xuyq21@lenovo.com
Subject: [PATCH v4 1/1] wifi: mac80211: validate TX status rate metadata
Date: Mon, 21 Sep 2026 10:52:04 +0800
Message-ID: <607e985d71fbbe63ebfc182a37f882f04f980f7f.1789958876.git.xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789958876.git.xuyuqiabc@gmail.com>
References: <cover.1789958876.git.xuyuqiabc@gmail.com>
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
 net/mac80211/status.c              | 70 ++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 6 deletions(-)

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
index 3d811f652603..414979e2a1d9 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1164,6 +1164,73 @@ void ieee80211_tx_status_skb(struct ieee80211_hw *hw, struct sk_buff *skb)
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
+		struct ieee80211_rate_status *rs = &status->rates[i];
+
+		if (ieee80211_tx_status_rate_info_valid(&rs->rate_idx))
+			continue;
+
+		rs->try_count = 0;
+		memset(&rs->rate_idx, 0, sizeof(rs->rate_idx));
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
@@ -1176,6 +1243,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 	bool acked, noack_success, ack_signal_valid;
 	u16 tx_time_est;
 
+	ieee80211_tx_status_drop_invalid_rates(status);
+
 	if (pubsta) {
 		sta = container_of(pubsta, struct sta_info, sta);
 
@@ -1300,6 +1369,7 @@ void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
 		.sta = pubsta,
 	};
 
+	ieee80211_tx_status_drop_invalid_rates(&status);
 	rate_control_tx_status(local, &status);
 
 	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL))
-- 
2.55.0

