Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7423E274E
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 11:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894082; cv=none; b=VCRb2bpx23lYgcsmhHgRlEWBvwLI+f2xKAoqxDQF264MHLT3j8fN5dBGUdCqCgAGaeEUhQeg85tBwpU8z4yKcM1ZIWG5eU4iOl5m2L/H7H3V7zPhr0rZ2Tr4S5j7bLyr/n4+P/0K9kaYs21deCt8QjHAY2/AGMKkrbi/Wz0cgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894082; c=relaxed/simple;
	bh=09i1CrhutGw9cA4Vb3B5kTR52cLi1FNRS13sxYgoVww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lbQJkUvRkTBH2UlQnz709f9Xk26RMbkXZjv+9oGJh2p2ExNHV3TmZiR9EdNiJ2pAT5iQSwgy3TeNrmUAP/R/hourZftlZGGpji0dzEV3nFVZc+2XLv+Ni4FV1dMTxbN3fRd7GhEETrejPK24HS+wKmhaHE1BISA7+oScWUecWIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=PV/yjbcN; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="PV/yjbcN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g0QpOYScky37XwK3szEw2eMye9XS6GWvlIDDtLmsnSg=; b=PV/yjbcNhcZxNFB4BiL+8xCy01
	enzHdmKiVBahnKg3tAjm98+XCL2nm+1Nie9w4HTjyzGV+Cur2Upa7h2maMro3F6i4MIKcnQfgbvOZ
	g01K4iYKpiyQ1uZ2Zf/4vmp/h9SInoUx5ASoPkT6ytEPXtdnuVXYI2Q+wrhkgjLRDy+0=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnEU3-006KUB-1u;
	Fri, 24 Jul 2026 13:54:31 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next v5 1/4] wifi: mac80211: factor out part of ieee80211_calc_expected_tx_airtime
Date: Fri, 24 Jul 2026 11:54:26 +0000
Message-ID: <20260724115429.3921457-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create ieee80211_rate_expected_tx_airtime helper function, which returns
the expected tx airtime for a given rate and packet length in units of
1/1024 usec, for more accuracy.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/airtime.c     | 87 ++++++++++++++++++++++----------------
 net/mac80211/ieee80211_i.h |  5 +++
 2 files changed, 56 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/airtime.c b/net/mac80211/airtime.c
index c61df637232a..0c54cdbd753c 100644
--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -685,7 +685,7 @@ static int ieee80211_fill_rx_status(struct ieee80211_rx_status *stat,
 	if (ieee80211_fill_rate_info(hw, stat, band, ri))
 		return 0;
 
-	if (!ieee80211_rate_valid(rate))
+	if (!rate || !ieee80211_rate_valid(rate))
 		return -1;
 
 	if (rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
@@ -753,6 +753,53 @@ u32 ieee80211_calc_tx_airtime(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(ieee80211_calc_tx_airtime);
 
+u32 ieee80211_rate_expected_tx_airtime(struct ieee80211_hw *hw,
+				       struct ieee80211_tx_rate *tx_rate,
+				       struct rate_info *ri,
+				       enum nl80211_band band,
+				       bool ampdu, int len)
+{
+	struct ieee80211_rx_status stat;
+	u32 duration, overhead;
+	u8 agg_shift;
+
+	if (ieee80211_fill_rx_status(&stat, hw, tx_rate, ri, band, len))
+		return 0;
+
+	if (stat.encoding == RX_ENC_LEGACY || !ampdu)
+		return ieee80211_calc_rx_airtime(hw, &stat, len) * 1024;
+
+	duration = ieee80211_get_rate_duration(hw, &stat, &overhead);
+
+	/*
+	 * Assume that HT/VHT transmission on any AC except VO will
+	 * use aggregation. Since we don't have reliable reporting
+	 * of aggregation length, assume an average size based on the
+	 * tx rate.
+	 * This will not be very accurate, but much better than simply
+	 * assuming un-aggregated tx in all cases.
+	 */
+	if (duration > 400 * 1024) /* <= VHT20 MCS2 1S */
+		agg_shift = 1;
+	else if (duration > 250 * 1024) /* <= VHT20 MCS3 1S or MCS1 2S */
+		agg_shift = 2;
+	else if (duration > 150 * 1024) /* <= VHT20 MCS5 1S or MCS2 2S */
+		agg_shift = 3;
+	else if (duration > 70 * 1024) /* <= VHT20 MCS5 2S */
+		agg_shift = 4;
+	else if (stat.encoding != RX_ENC_HE ||
+		 duration > 20 * 1024) /* <= HE40 MCS6 2S */
+		agg_shift = 5;
+	else
+		agg_shift = 6;
+
+	duration *= len;
+	duration /= AVG_PKT_SIZE;
+	duration += (overhead * 1024 >> agg_shift);
+
+	return duration;
+}
+
 u32 ieee80211_calc_expected_tx_airtime(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_sta *pubsta,
@@ -775,45 +822,13 @@ u32 ieee80211_calc_expected_tx_airtime(struct ieee80211_hw *hw,
 	if (pubsta) {
 		struct sta_info *sta = container_of(pubsta, struct sta_info,
 						    sta);
-		struct ieee80211_rx_status stat;
 		struct ieee80211_tx_rate *tx_rate = &sta->deflink.tx_stats.last_rate;
 		struct rate_info *ri = &sta->deflink.tx_stats.last_rate_info;
-		u32 duration, overhead;
-		u8 agg_shift;
+		u32 duration;
 
-		if (ieee80211_fill_rx_status(&stat, hw, tx_rate, ri, band, len))
-			return 0;
-
-		if (stat.encoding == RX_ENC_LEGACY || !ampdu)
-			return ieee80211_calc_rx_airtime(hw, &stat, len);
-
-		duration = ieee80211_get_rate_duration(hw, &stat, &overhead);
-		/*
-		 * Assume that HT/VHT transmission on any AC except VO will
-		 * use aggregation. Since we don't have reliable reporting
-		 * of aggregation length, assume an average size based on the
-		 * tx rate.
-		 * This will not be very accurate, but much better than simply
-		 * assuming un-aggregated tx in all cases.
-		 */
-		if (duration > 400 * 1024) /* <= VHT20 MCS2 1S */
-			agg_shift = 1;
-		else if (duration > 250 * 1024) /* <= VHT20 MCS3 1S or MCS1 2S */
-			agg_shift = 2;
-		else if (duration > 150 * 1024) /* <= VHT20 MCS5 1S or MCS2 2S */
-			agg_shift = 3;
-		else if (duration > 70 * 1024) /* <= VHT20 MCS5 2S */
-			agg_shift = 4;
-		else if (stat.encoding != RX_ENC_HE ||
-			 duration > 20 * 1024) /* <= HE40 MCS6 2S */
-			agg_shift = 5;
-		else
-			agg_shift = 6;
-
-		duration *= len;
-		duration /= AVG_PKT_SIZE;
+		duration = ieee80211_rate_expected_tx_airtime(hw, tx_rate, ri,
+							      band, true, len);
 		duration /= 1024;
-		duration += (overhead >> agg_shift);
 
 		return max_t(u32, duration, 4);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 11f449e8ff00..4034b71a31cf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2937,6 +2937,11 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
+u32 ieee80211_rate_expected_tx_airtime(struct ieee80211_hw *hw,
+				       struct ieee80211_tx_rate *tx_rate,
+				       struct rate_info *ri,
+				       enum nl80211_band band,
+				       bool ampdu, int len);
 u32 ieee80211_calc_expected_tx_airtime(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_sta *pubsta,
-- 
2.53.0

