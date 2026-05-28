Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9E3E2ABA
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2026 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779967085; cv=none; b=FNItyfvSRApr++ldkT/ieahS/wUQeFAsy2gKHqRVRhFrQKCxr+XTudtT21U2PaCBALScsUudn159onqcfCNoMfxM0LA7U1X/xmLv+5rXWONPSsFISXBbYMVGiMvwazIeuqik2EjA3b8qa33Ewvfv3ZBoxiBNShtF3uYK/y0zFAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779967085; c=relaxed/simple;
	bh=1294t6cTOCKFR9PXIk2zmfyEpGXxaPkWWfADo7lxG0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIC5pzdz/M0iU9SwxjGEUiS2BunMfYdYgEZcsSBCVipRWW1BCzeY5CrUjId3a5MR387GaED2VJCMCzKGBWGAhfnNw8CaLxcWRJXY3lB1kqfVaZJPt3Kr6RNwJUfGD+mG+Tiv7ruzs4oF+bMb/cpCV2Zq+Htf3fXfD/SL082f+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=WO5mjjkJ; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WO5mjjkJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yZcelHd2ibgPXJJxYGk9gVREhC6GQr51VIsYQvTzqaA=; b=WO5mjjkJupy9F3jzqjSIqqpQeH
	+tyCRY5n1jvOpxj7UKz/H0f36ZYDRtYbvr418Ti9cYeIDiUhEB0vsyOOmE5D+dbv65awZf0eFHSFN
	z+HXBhbh4wGEUI0nGGwDkn6MKwAnao52HdVxhkyUKPG9XJNLhikeZBPUEhoIt9t5gFqM=;
Received: from p200300cadf1ddd00000000000000085c.dip0.t-ipconnect.de ([2003:ca:df1d:dd00::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wSYkR-0027n2-1D;
	Thu, 28 May 2026 13:17:59 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless v2 2/4] wifi: mac80211: estimate expected throughput if not provided by driver/rc
Date: Thu, 28 May 2026 11:17:54 +0000
Message-ID: <20260528111756.848243-2-nbd@nbd.name>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260528111756.848243-1-nbd@nbd.name>
References: <20260528111756.848243-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Estimate the tx throughput based on the expected per-packet tx time.
This is useful for mesh implementations that rely on expected throughput,
e.g. 802.11s or batman-adv.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/sta_info.c | 48 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4c86a3793804..2bc5cab76261 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2769,6 +2769,27 @@ void sta_set_accumulated_removed_links_sinfo(struct sta_info *sta,
 	}
 }
 
+static u32 sta_estimate_expected_throughput(struct sta_info *sta,
+					    struct rate_info *ri,
+					    struct ieee80211_bss_conf *bss_conf)
+{
+	struct ieee80211_hw *hw = &sta->sdata->local->hw;
+	struct ieee80211_chanctx_conf *conf;
+	u32 duration;
+	u8 band = 0;
+
+	conf = rcu_dereference(bss_conf->chanctx_conf);
+	if (conf)
+		band = conf->def.chan->band;
+
+	duration = ieee80211_rate_expected_tx_airtime(hw, NULL, ri, band, true, 1024);
+	duration += duration >> 4; /* add assumed packet error rate of ~6% */
+	if (!duration)
+		return 0;
+
+	return ((1024 * USEC_PER_SEC) / duration) * 8;
+}
+
 static void sta_set_link_sinfo(struct sta_info *sta,
 			       struct link_station_info *link_sinfo,
 			       struct ieee80211_link_data *link,
@@ -2983,6 +3004,10 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	link_sinfo->bss_param.beacon_interval = link->conf->beacon_int;
 
 	thr = sta_get_expected_throughput(sta);
+	if (!thr && (link_sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE)))
+		thr = sta_estimate_expected_throughput(sta,
+						      &link_sinfo->txrate,
+						      link->conf);
 
 	if (thr != 0) {
 		link_sinfo->filled |=
@@ -3236,6 +3261,14 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	if (thr != 0) {
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
 		sinfo->expected_throughput = thr;
+	} else if (!sta->sta.valid_links &&
+		   (sinfo->filled & BIT_ULL(NL80211_STA_INFO_TX_BITRATE))) {
+		thr = sta_estimate_expected_throughput(sta, &sinfo->txrate,
+						      &sdata->vif.bss_conf);
+		if (thr) {
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
+			sinfo->expected_throughput = thr;
+		}
 	}
 
 	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) &&
@@ -3256,6 +3289,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	if (sta->sta.valid_links) {
 		struct ieee80211_link_data *link;
 		struct link_sta_info *link_sta;
+		u32 est_thr = 0;
 		int link_id;
 
 		sinfo->mlo_params_valid = true;
@@ -3267,17 +3301,25 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		sinfo->valid_links = sta->sta.valid_links;
 
 		for_each_valid_link(sinfo, link_id) {
+			struct link_station_info *lsi = sinfo->links[link_id];
+
 			link_sta = wiphy_dereference(sta->local->hw.wiphy,
 						     sta->link[link_id]);
 			link = wiphy_dereference(sdata->local->hw.wiphy,
 						 sdata->link[link_id]);
 
-			if (!link_sta || !sinfo->links[link_id] || !link) {
+			if (!link_sta || !lsi || !link) {
 				sinfo->valid_links &= ~BIT(link_id);
 				continue;
 			}
-			sta_set_link_sinfo(sta, sinfo->links[link_id],
-					   link, tidstats);
+			sta_set_link_sinfo(sta, lsi, link, tidstats);
+			if (!thr &&
+			    (lsi->filled & BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
+				est_thr += lsi->expected_throughput;
+		}
+		if (est_thr) {
+			sinfo->filled |= BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
+			sinfo->expected_throughput = est_thr;
 		}
 	}
 }
-- 
2.51.0

