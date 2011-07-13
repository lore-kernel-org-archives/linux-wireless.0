Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400Ab1GMRui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 13:50:38 -0400
Subject: [PATCH] mac80211: allow driver access to TKIP RX P1K
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 19:50:34 +0200
Message-ID: <1310579434.3873.11.camel@jlt3.sipsolutions.net> (sfid-20110713_195041_261681_7BE54DCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver wants to pre-program the TKIP
RX phase 1 key, it needs to be able to obtain
it for the peer's TA. Add API to allow it to
generate it.

The generation uses a dummy on-stack context
since it doesn't know the RX queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   14 ++++++++++++++
 net/mac80211/tkip.c    |   11 +++++++++++
 2 files changed, 25 insertions(+)

--- a/include/net/mac80211.h	2011-07-13 19:20:36.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-13 19:24:20.000000000 +0200
@@ -2612,6 +2612,20 @@ static inline void ieee80211_get_tkip_p1
 }
 
 /**
+ * ieee80211_get_tkip_rx_p1k - get a TKIP phase 1 key for RX
+ *
+ * This function returns the TKIP phase 1 key for the given IV32
+ * and transmitter address.
+ *
+ * @keyconf: the parameter passed with the set key
+ * @ta: TA that will be used with the key
+ * @iv32: IV32 to get the P1K for
+ * @p1k: a buffer to which the key will be written, as 5 u16 values
+ */
+void ieee80211_get_tkip_rx_p1k(struct ieee80211_key_conf *keyconf,
+			       const u8 *ta, u32 iv32, u16 *p1k);
+
+/**
  * ieee80211_get_tkip_p2k - get a TKIP phase 2 key
  *
  * This function computes the TKIP RC4 key for the IV values
--- a/net/mac80211/tkip.c	2011-07-13 19:20:36.000000000 +0200
+++ b/net/mac80211/tkip.c	2011-07-13 19:20:37.000000000 +0200
@@ -185,6 +185,17 @@ void ieee80211_get_tkip_p1k_iv(struct ie
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p1k_iv);
 
+void ieee80211_get_tkip_rx_p1k(struct ieee80211_key_conf *keyconf,
+                               const u8 *ta, u32 iv32, u16 *p1k)
+{
+	const u8 *tk = &keyconf->key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
+	struct tkip_ctx ctx;
+
+	tkip_mixing_phase1(tk, &ctx, ta, iv32);
+	memcpy(p1k, ctx.p1k, sizeof(ctx.p1k));
+}
+EXPORT_SYMBOL(ieee80211_get_tkip_rx_p1k);
+
 void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
 			    struct sk_buff *skb, u8 *p2k)
 {


