Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2DSCYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 22:24:18 -0400
Received: by mail-pb0-f46.google.com with SMTP id un15so9656149pbc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 19:24:18 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 1/2] mac80211: don't set mesh peer ht caps if ht disabled
Date: Wed, 18 Apr 2012 19:24:13 -0700
Message-Id: <1334802254-4704-1-git-send-email-thomas@cozybit.com> (sfid-20120419_042427_478071_F2E44A71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Blindly setting ht caps on a mesh peer's station entry would result in
MCS rates being used by the rate control algorithm even if no ht had
been configured. Fix this by checking the channel type before assigning
ht capabilites.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index c2af7b3..1ff2a5c 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -295,7 +295,8 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	spin_lock_bh(&sta->lock);
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[band] = rates;
-	if (elems->ht_cap_elem)
+	if (elems->ht_cap_elem &&
+	    sdata->local->_oper_channel_type != NL80211_CHAN_NO_HT)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  elems->ht_cap_elem,
 						  &sta->sta.ht_cap);
-- 
1.7.5.4

