Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab3C1JtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:49:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 7/9] mac80211: make ieee802_11_parse_elems an inline
Date: Thu, 28 Mar 2013 10:49:03 +0100
Message-Id: <1364464145-14446-8-git-send-email-johannes@sipsolutions.net> (sfid-20130328_104927_236681_465B27FC)
In-Reply-To: <1364464145-14446-1-git-send-email-johannes@sipsolutions.net>
References: <1364464145-14446-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This (slightly) reduces the code size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 8 ++++++--
 net/mac80211/util.c        | 6 ------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3eee89d..8f240c0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1490,11 +1490,15 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb_tid(sdata, skb, 7);
 }
 
-void ieee802_11_parse_elems(u8 *start, size_t len,
-			    struct ieee802_11_elems *elems);
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
+static inline void ieee802_11_parse_elems(u8 *start, size_t len,
+					  struct ieee802_11_elems *elems)
+{
+	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
+}
+
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7efadbc..6ded61a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -913,12 +913,6 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 	return crc;
 }
 
-void ieee802_11_parse_elems(u8 *start, size_t len,
-			    struct ieee802_11_elems *elems)
-{
-	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
-}
-
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify)
 {
-- 
1.8.0

