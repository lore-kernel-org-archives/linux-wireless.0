Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35275 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759412Ab2DZWBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 18:01:18 -0400
Received: by pbbrr13 with SMTP id rr13so215637pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 15:01:18 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/2] mac80211: insert mesh peer after init
Date: Thu, 26 Apr 2012 15:01:06 -0700
Message-Id: <1335477667-1625-1-git-send-email-thomas@cozybit.com> (sfid-20120427_000127_405140_ACAC9428)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers need the station rate info when inserting a new sta_info. The
patch "mac80211: refactor mesh peer initialization" wrongly assumed the
rate info could be applied after insertion. After further review, this
is clearly not the case.

This fixes a regression where HT parameters were not applied before
inserting the sta_info, causing performance degradation.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1ff2a5c..f4124d7 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -102,9 +102,6 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 
 	set_sta_flag(sta, WLAN_STA_WME);
 
-	if (sta_info_insert(sta))
-		return NULL;
-
 	return sta;
 }
 
@@ -281,6 +278,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	u32 rates, basic_rates = 0;
 	struct sta_info *sta;
+	bool insert = false;
 
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(local, elems, band, &basic_rates);
@@ -290,6 +288,7 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 		sta = mesh_plink_alloc(sdata, addr);
 		if (!sta)
 			return NULL;
+		insert = true;
 	}
 
 	spin_lock_bh(&sta->lock);
@@ -306,6 +305,9 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	rate_control_rate_init(sta);
 	spin_unlock_bh(&sta->lock);
 
+	if (insert && sta_info_insert(sta))
+		return NULL;
+
 	return sta;
 }
 
-- 
1.7.5.4

