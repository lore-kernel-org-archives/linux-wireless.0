Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33072 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbbJNQlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 12:41:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove event.c
Date: Wed, 14 Oct 2015 18:40:58 +0200
Message-Id: <1444840858-20599-1-git-send-email-johannes@sipsolutions.net> (sfid-20151014_184106_401257_ABC7E6DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

That file contains just a single function, which itself is just a
single statement to call a different function. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Makefile      |  1 -
 net/mac80211/event.c       | 27 ---------------------------
 net/mac80211/ieee80211_i.h |  3 ---
 net/mac80211/wpa.c         |  9 ++++++---
 4 files changed, 6 insertions(+), 34 deletions(-)
 delete mode 100644 net/mac80211/event.c

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 783e891b7525..f9137a8341f4 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -27,7 +27,6 @@ mac80211-y := \
 	key.o \
 	util.o \
 	wme.o \
-	event.o \
 	chan.o \
 	trace.o mlme.o \
 	tdls.o \
diff --git a/net/mac80211/event.c b/net/mac80211/event.c
deleted file mode 100644
index 01ae759518f6..000000000000
--- a/net/mac80211/event.c
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * mac80211 - events
- */
-#include <net/cfg80211.h>
-#include "ieee80211_i.h"
-
-/*
- * Indicate a failed Michael MIC to userspace. If the caller knows the TSC of
- * the frame that generated the MIC failure (i.e., if it was provided by the
- * driver or is still in the frame), it should provide that information.
- */
-void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
-				     struct ieee80211_hdr *hdr, const u8 *tsc,
-				     gfp_t gfp)
-{
-	cfg80211_michael_mic_failure(sdata->dev, hdr->addr2,
-				     (hdr->addr1[0] & 0x01) ?
-				     NL80211_KEYTYPE_GROUP :
-				     NL80211_KEYTYPE_PAIRWISE,
-				     keyidx, tsc, gfp);
-}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 04b62435f37e..056d3721148c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1765,9 +1765,6 @@ extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift);
-void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
-				     struct ieee80211_hdr *hdr, const u8 *tsc,
-				     gfp_t gfp);
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index feb547dc8643..d824c38971ed 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -174,9 +174,12 @@ mic_fail_no_key:
 	 * a driver that supports HW encryption. Send up the key idx only if
 	 * the key is set.
 	 */
-	mac80211_ev_michael_mic_failure(rx->sdata,
-					rx->key ? rx->key->conf.keyidx : -1,
-					(void *) skb->data, NULL, GFP_ATOMIC);
+	cfg80211_michael_mic_failure(rx->sdata->dev, hdr->addr2,
+				     is_multicast_ether_addr(hdr->addr1) ?
+				     NL80211_KEYTYPE_GROUP :
+				     NL80211_KEYTYPE_PAIRWISE,
+				     rx->key ? rx->key->conf.keyidx : -1,
+				     NULL, GFP_ATOMIC);
 	return RX_DROP_UNUSABLE;
 }
 
-- 
2.5.1

