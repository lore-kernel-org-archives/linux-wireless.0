Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaLNJKx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 04:10:53 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4] mac80211: remove unused variable in ieee80211_parse_ch_switch_ie()
Date: Sun, 14 Dec 2014 11:05:52 +0200
Message-Id: <1418547953-17699-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141214_101111_758177_7BF6E11C)
In-Reply-To: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1418547953-17699-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The ht_oper variable is assigned a value, but never used in
ieee80211_parse_ch_switch_ie().  Remove it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/spectmgmt.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index efeba56..06e6ac8 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -34,19 +34,15 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def new_vht_chandef = {};
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
-	const struct ieee80211_ht_operation *ht_oper;
 	int secondary_channel_offset = -1;
 
 	sec_chan_offs = elems->sec_chan_offs;
 	wide_bw_chansw_ie = elems->wide_bw_chansw_ie;
-	ht_oper = elems->ht_operation;
 
 	if (sta_flags & (IEEE80211_STA_DISABLE_HT |
 			 IEEE80211_STA_DISABLE_40MHZ)) {
 		sec_chan_offs = NULL;
 		wide_bw_chansw_ie = NULL;
-		/* only used for bandwidth here */
-		ht_oper = NULL;
 	}
 
 	if (sta_flags & IEEE80211_STA_DISABLE_VHT)
-- 
1.9.1

