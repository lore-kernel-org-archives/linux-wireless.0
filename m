Received: from smtp.inf.ufrgs.br (smtp.inf.ufrgs.br [143.54.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1D53CC7DF
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 03:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.54.11.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788231687; cv=none; b=JEZUlNyVmiLjy3OYwtjx/d1TT9/aCmAIPbiuACzPUY+DfCWDRpGzV3j293ehpR4PAeZMm4Rhz/KEBEvckxs5pr9Jab+YaWxFoJNPhDjn5AhwHa3NUvPdr/MEDSvV9d8ZHmR9JZyb70SHNHl502pX5LWVbLFwZr0covdBJbZh2z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788231687; c=relaxed/simple;
	bh=uPkOQj6AnobFhvshk8VE4DVpskoyOYkhJa1GxGaZHV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UNUHq7m7LDGszpQ+CbIqDr2kzmC0WjrB4BxhygdIOg5TAvr/gpJ34fvMOkeEQ/8i9jIkXi8q695cJDhBm9BSDzEX2l96vXuY1IGQDb2lgHEwgOkMqz5gGOHGET1HnFgb4FXeLpxjx3di0SWary7p47kXO31L/iVCTT5lw5Y/Lzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inf.ufrgs.br; spf=pass smtp.mailfrom=inf.ufrgs.br; dkim=pass (2048-bit key) header.d=inf.ufrgs.br header.i=@inf.ufrgs.br header.b=PqGBzpL2; arc=none smtp.client-ip=143.54.11.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inf.ufrgs.br
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inf.ufrgs.br
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=inf.ufrgs.br header.i=@inf.ufrgs.br header.b="PqGBzpL2"
Received: from localhost.. (unknown [179.104.165.168])
	by smtp.inf.ufrgs.br (Postfix) with ESMTPSA id 3EAF51210C9;
	Mon, 31 Aug 2026 23:55:35 -0300 (-03)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inf.ufrgs.br;
	s=dkim2026; t=1788231336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wZ+GicGdAxvX2n3fUwDYS8b2goo3qMfithlKy5RGr48=;
	b=PqGBzpL2L4k5pTkjEV+4+cS8FSBelQI0hfUbf7EvriDcfXmkAyz75UvHx4XLawTwHCkhTG
	JgUSHeFJqA45JBDPc7/p2SOicYQ6ByI9wqWq+kLD/wD3k6qhSBMjDROLzgMZMJEWbGEO6v
	ppJjLKQdNyMHqRei5/Y4k10BscAhAi+Med6Mhm+Nx8lPaBFEP261K9gPrBCPjWQo7Hj3YJ
	IO3K55y2I+s1x/+/3Z4UT2liN8jdsezxwryysOiJaVB02QFigZD8oaTqC6y6dArKaMpeCD
	sElXVzizUacKpCMRWVT45b8rrV3sGYVCCbDDrdIQVEboh8EkurXLpituq/2PBA==
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: [PATCH wireless] wifi: mac80211: fix channel changes for active monitors
Date: Mon, 31 Aug 2026 23:55:25 -0300
Message-ID: <20260901025525.4017-1-matheus.aalmeida@inf.ufrgs.br>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Active monitor interfaces are added to the driver as real VIFs so that
frames addressed to their MAC address can be acknowledged. However,
ieee80211_set_monitor_channel() redirects monitor channel changes to the
hidden monitor_sdata whenever the driver does not set
NO_VIRTUAL_MONITOR.

An active-only monitor does not create monitor_sdata, so the function can
return success after only updating monitor_chanreq. The active monitor
itself never gets a channel context, making channel changes ineffective.

Use the active monitor VIF directly when changing channels, while keeping
monitor_chanreq private to the hidden virtual monitor. Also treat active
monitors as valid directly channel-bound monitor interfaces in channel
width and SMPS accounting.

This fixes active monitor channel switching with mac80211_hwsim. Before
this change, an active monitor failed to discover any APs while scanning.
With the fix applied, scanning works across channels 1, 6 and 11 with both
channels=1 and channels=2, and authentication and association on channel 6
succeed without mac80211 or hwsim warnings.

Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
---
 net/mac80211/cfg.c  | 9 +++++++--
 net/mac80211/chan.c | 8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 43f142624d33..c844ae2abcb4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1064,12 +1064,16 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_chan_req chanreq = { .oper = *chandef };
+	bool use_virtual_monitor;
 	int ret;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (!ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR)) {
+	use_virtual_monitor =
+		!ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR) &&
+		!(sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE);
+	if (use_virtual_monitor) {
 		if (cfg80211_chandef_identical(&local->monitor_chanreq.oper,
 					       &chanreq.oper))
 			return 0;
@@ -1090,7 +1094,8 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 	if (ret)
 		return ret;
 done:
-	local->monitor_chanreq = chanreq;
+	if (use_virtual_monitor)
+		local->monitor_chanreq = chanreq;
 	return 0;
 }
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5152b84a3357..800b7585c010 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -543,7 +543,9 @@ ieee80211_get_width_of_link(struct ieee80211_link_data *link)
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		WARN_ON_ONCE(!ieee80211_hw_check(&local->hw,
+		WARN_ON_ONCE(!(link->sdata->u.mntr.flags &
+			       MONITOR_FLAG_ACTIVE) &&
+			     !ieee80211_hw_check(&local->hw,
 						 NO_VIRTUAL_MONITOR));
 		fallthrough;
 	case NL80211_IFTYPE_ADHOC:
@@ -1279,7 +1281,9 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				continue;
 			break;
 		case NL80211_IFTYPE_MONITOR:
-			if (!ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR))
+			if (!(iter.sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE) &&
+			    !ieee80211_hw_check(&local->hw,
+						NO_VIRTUAL_MONITOR))
 				continue;
 			break;
 		case NL80211_IFTYPE_AP:
-- 
2.47.3

