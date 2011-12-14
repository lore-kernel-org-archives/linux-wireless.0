Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab1LNM2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 07:28:49 -0500
Subject: [PATCH] mac80211: make address arguments to sta_info_alloc const
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 13:28:46 +0100
Message-ID: <1323865726.3380.9.camel@jlt3.sipsolutions.net> (sfid-20111214_132856_727275_6FE29E0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

No real changes, just note that they are const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    2 +-
 net/mac80211/sta_info.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c	2011-12-14 12:42:24.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-12-14 12:52:19.000000000 +0100
@@ -281,7 +281,7 @@ static int sta_prepare_rate_control(stru
 }
 
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
-				u8 *addr, gfp_t gfp)
+				const u8 *addr, gfp_t gfp)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
--- a/net/mac80211/sta_info.h	2011-12-14 12:51:55.000000000 +0100
+++ b/net/mac80211/sta_info.h	2011-12-14 12:52:13.000000000 +0100
@@ -522,7 +522,7 @@ struct sta_info *sta_info_get_by_idx(str
  * until sta_info_insert().
  */
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
-				u8 *addr, gfp_t gfp);
+				const u8 *addr, gfp_t gfp);
 
 void sta_info_free(struct ieee80211_local *local, struct sta_info *sta);
 


