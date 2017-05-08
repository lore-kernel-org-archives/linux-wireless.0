Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58990 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752240AbdEHJcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 05:32:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix IBSS presp allocation size
Date: Mon,  8 May 2017 11:32:17 +0200
Message-Id: <20170508093217.9679-1-johannes@sipsolutions.net> (sfid-20170508_113223_073010_0C10D4CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When VHT IBSS support was added, the size of the extra elements
wasn't considered in ieee80211_ibss_build_presp(), which makes
it possible that it would overrun the allocated buffer. Fix it
by allocating the necessary space.

Fixes: abcff6ef01f9 ("mac80211: add VHT support for IBSS")
Reported-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6db09fa18269..364d4e137649 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -66,6 +66,8 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 		    2 + sizeof(struct ieee80211_ht_cap) +
 		    2 + sizeof(struct ieee80211_ht_operation) +
+		    2 + sizeof(struct ieee80211_vht_cap) +
+		    2 + sizeof(struct ieee80211_vht_operation) +
 		    ifibss->ie_len;
 	presp = kzalloc(sizeof(*presp) + frame_len, GFP_KERNEL);
 	if (!presp)
-- 
2.11.0
