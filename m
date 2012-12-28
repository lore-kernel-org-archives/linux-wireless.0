Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2L1ODm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 09:03:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: unset peer's HT 40 MHz support if not usable
Date: Fri, 28 Dec 2012 15:04:00 +0100
Message-Id: <1356703440-29267-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_150406_525116_53685D17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interface is configured to a 20 MHz channel
and the device as well as the peer are 40 MHz capable
the HT capabilities of the peer are not restricted to
20 MHz, even though they're supposed to be restricted
to the currently possible capabilities.

Unset the 40 MHz HT capability bits in this case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index df46cd8..61ac7c4 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -120,6 +120,21 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		   IEEE80211_HT_CAP_SGI_20 |
 		   IEEE80211_HT_CAP_SGI_40 |
 		   IEEE80211_HT_CAP_DSSSCCK40));
+
+	/* Unset 40 MHz if we're not using a 40 MHz channel */
+	switch (sdata->vif.bss_conf.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		ht_cap->cap &= ~IEEE80211_HT_CAP_SGI_40;
+		ht_cap->cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		break;
+	}
+
 	/*
 	 * The STBC bits are asymmetric -- if we don't have
 	 * TX then mask out the peer's RX and vice versa.
-- 
1.8.0

