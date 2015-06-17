Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46741 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbbFQIlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/14] mac80211: move ieee80211_get_bssid into RX file
Date: Wed, 17 Jun 2015 10:41:06 +0200
Message-Id: <1434530475-3553-6-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104136_142888_9B5E9A1D)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function is only used in the RX code, so moving it into
that file gives the compiler better optimisation possibilities
and also allows us to remove the check for short frames (which
in the RX path cannot happen, but as a generic utility needed
to be checked.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/rx.c          | 45 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c        | 49 ----------------------------------------------
 3 files changed, 45 insertions(+), 51 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eb91102e4809..361bb3ca335c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1762,8 +1762,6 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 
 /* utility functions/constants */
 extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
-			enum nl80211_iftype type);
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index aa57a2ab8245..dd6bb2a54d45 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -42,6 +42,51 @@ static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
 	u64_stats_update_end(&tstats->syncp);
 }
 
+static u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
+			       enum nl80211_iftype type)
+{
+	__le16 fc = hdr->frame_control;
+
+	if (ieee80211_is_data(fc)) {
+		if (len < 24) /* drop incorrect hdr len (data) */
+			return NULL;
+
+		if (ieee80211_has_a4(fc))
+			return NULL;
+		if (ieee80211_has_tods(fc))
+			return hdr->addr1;
+		if (ieee80211_has_fromds(fc))
+			return hdr->addr2;
+
+		return hdr->addr3;
+	}
+
+	if (ieee80211_is_mgmt(fc)) {
+		if (len < 24) /* drop incorrect hdr len (mgmt) */
+			return NULL;
+		return hdr->addr3;
+	}
+
+	if (ieee80211_is_ctl(fc)) {
+		if (ieee80211_is_pspoll(fc))
+			return hdr->addr1;
+
+		if (ieee80211_is_back_req(fc)) {
+			switch (type) {
+			case NL80211_IFTYPE_STATION:
+				return hdr->addr2;
+			case NL80211_IFTYPE_AP:
+			case NL80211_IFTYPE_AP_VLAN:
+				return hdr->addr1;
+			default:
+				break; /* fall through to the return */
+			}
+		}
+	}
+
+	return NULL;
+}
+
 /*
  * monitor mode reception
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 43e5aadd7a89..7fb2c7bacc8c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -47,55 +47,6 @@ struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
 
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
-			enum nl80211_iftype type)
-{
-	__le16 fc = hdr->frame_control;
-
-	 /* drop ACK/CTS frames and incorrect hdr len (ctrl) */
-	if (len < 16)
-		return NULL;
-
-	if (ieee80211_is_data(fc)) {
-		if (len < 24) /* drop incorrect hdr len (data) */
-			return NULL;
-
-		if (ieee80211_has_a4(fc))
-			return NULL;
-		if (ieee80211_has_tods(fc))
-			return hdr->addr1;
-		if (ieee80211_has_fromds(fc))
-			return hdr->addr2;
-
-		return hdr->addr3;
-	}
-
-	if (ieee80211_is_mgmt(fc)) {
-		if (len < 24) /* drop incorrect hdr len (mgmt) */
-			return NULL;
-		return hdr->addr3;
-	}
-
-	if (ieee80211_is_ctl(fc)) {
-		if (ieee80211_is_pspoll(fc))
-			return hdr->addr1;
-
-		if (ieee80211_is_back_req(fc)) {
-			switch (type) {
-			case NL80211_IFTYPE_STATION:
-				return hdr->addr2;
-			case NL80211_IFTYPE_AP:
-			case NL80211_IFTYPE_AP_VLAN:
-				return hdr->addr1;
-			default:
-				break; /* fall through to the return */
-			}
-		}
-	}
-
-	return NULL;
-}
-
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb;
-- 
2.1.4

