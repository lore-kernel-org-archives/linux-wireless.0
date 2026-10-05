Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AE044A408
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193466; cv=none; b=Xbg3NCYTyG2BE9pgRvvriGEDKbHg+a3JwNEI6BqJWOAxYfGybHwXIXPMbMIGlZBa/sT7wAyDiLgYOfin9FLawYm/9cGDtJfZogv2wwFCYJtpzXTEuY8HpTXw24Hl8/Wbi5yISOWrhAS6mdoUR5oqlJFy3UXAO7PHY/LX5yjBmhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193466; c=relaxed/simple;
	bh=Lc4MIyOuqOV9PrOFrUe01P9IlgTrnM+Es6a8LiOPwRw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q8I4dZTeMNRYiwcYvdVtG9GpM1N6578zHbmL4ZhHqZ6BoWyJ88MGk+MeTTMbm2V7dsR8a3dzBC2nf7E7R2GJP/pyjXTOpV9+AVWJQ2fBDYSNhJryUSyJPVEpeE/lklAw5on78i3mQC+Ej2Gz5knri3B0b9lNcv5M2D6U5RPoias=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=u+STiLKV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="u+STiLKV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=B9/e4GodqHsXiw0Dsl2LgPp/7lkL3jgvyTgMF1iyV7c=; t=1791193462; x=1792403062; 
	b=u+STiLKVcXSSCwMz3txl10AGCScMPUM1sDe63AHM2gS06erZe6dhlyKDtd1cucdRTKCRbk+gD7W
	WCeLyNZHw5nlvcAZ1t+VmgxCfKtRmJBz1QlmJGUO+vPkUiSbuxzRukTxCPgO20djzGKf+sUtYuQMA
	lQUJddzTZ/AeUoLYTAwYg5++upsfEZlpMVsyur5qFH+4D69MMcyJ2N1arsQz0cOGMVTAU7fnD/GkN
	XI+4N3TjlggHEHL6Lqf7LIBCHpHYLLyF1PQSWSn/AMVmqw6vunJwYlOdaPYDBo9kJXA94xdeLZ7vv
	bAdsueHho8QiGKb1yeTuTJNWi8kBZeznjBrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDfF2-00000005Ayx-1Y5o;
	Mon, 05 Oct 2026 11:44:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Jouni Malinen <j@w1.fi>
Subject: [PATCH wireless-next] wifi: mac80211: fix non-MLD link ID handling
Date: Mon,  5 Oct 2026 11:44:14 +0200
Message-ID: <20261005114413.816905704456.Ib59a1ecce6ad74b23e4382e03cf3c113cbbdea2e@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In mac80211 the deflink link IDs for non-MLO are set to
zero to match the array index where their pointer lives.
However, the rx->link_id is expected to be -1 in these
cases, so just mapping it to the link/sta_link link_id
broke a few things such as reporting of spurious 4-addr
frames.

Set the link ID to -1 in these cases.

Reported-by: Jouni Malinen <j@w1.fi>
Fixes: 6d531b9af16e ("wifi: mac80211: rework RX packet handling")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f5893f9c07c6..804a0dc1e35c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4345,7 +4345,10 @@ static bool ieee80211_rx_data_set_link_sta(struct ieee80211_rx_data *rx,
 	if (!rx->link)
 		return false;
 
-	rx->link_id = rx->link->link_id;
+	if (ieee80211_vif_is_mld(&sta->sdata->vif))
+		rx->link_id = rx->link->link_id;
+	else
+		rx->link_id = -1;
 	rx->link_sta = link_sta;
 
 	return true;
@@ -5292,6 +5295,7 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 	struct ieee80211_fast_rx *fast_rx;
 	struct ieee80211_rx_data rx;
 	struct sta_info *sta;
+	int link_id = -1;
 
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
@@ -5308,11 +5312,11 @@ static void __ieee80211_rx_handle_8023(struct ieee80211_hw *hw,
 		goto drop;
 
 	sta = container_of(link_pubsta->sta, struct sta_info, sta);
-	if (!ieee80211_rx_data_set_sta(&rx, sta, link_pubsta->link_id))
+	if (sta->sta.valid_links)
+		link_id = link_pubsta->link_id;
+	if (!ieee80211_rx_data_set_sta(&rx, sta, link_id))
 		goto drop;
 
-	rx.link_id = link_pubsta->link_id;
-
 	fast_rx = rcu_dereference(rx.sta->fast_rx);
 	if (!fast_rx)
 		goto drop;
@@ -5575,7 +5579,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		rx.sdata = sdata;
 		rx.local = sdata->local;
 		rx.link = link;
-		rx.link_id = link->link_id;
+		rx.link_id = link != &sdata->deflink ? link->link_id : -1;
 		rx.sta = NULL;
 		rx.link_sta = NULL;
 
-- 
2.55.0

