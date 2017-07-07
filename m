Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49722 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdGGJ4c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 05:56:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "[4.0+]" <stable@vger.kernel.org>
Subject: [PATCH] cfg80211: don't change the regulatory HT flags in custom regulatory flows
Date: Fri,  7 Jul 2017 12:56:16 +0300
Message-Id: <20170707095616.29450-1-emmanuel.grumbach@intel.com> (sfid-20170707_115636_912882_607436E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the regulatory is handled by the driver, don't
interact with the flags it sets.
iwlwifi doesn't want to use channel 40 HT40+ for example.

Cc: <stable@vger.kernel.org> [4.0+]
Fixes: b0d7aa59592b ("cfg80211: allow wiphy specific regdomain management")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5fae296a6a58..29879440626e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -4,6 +4,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2008-2011	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright      2017  Intel Deutschland GmbH
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1483,7 +1484,9 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 {
 	struct ieee80211_supported_band *sband = wiphy->bands[channel->band];
 	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
+	const struct ieee80211_regdomain *regd;
 	unsigned int i;
+	u32 flags;
 
 	if (!is_ht40_allowed(channel)) {
 		channel->flags |= IEEE80211_CHAN_NO_HT40;
@@ -1503,17 +1506,30 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 			channel_after = c;
 	}
 
+	regd = get_wiphy_regdom(wiphy);
+	if (regd) {
+		const struct ieee80211_reg_rule *reg_rule =
+			freq_reg_info_regd(MHZ_TO_KHZ(channel->center_freq),
+					   regd, MHZ_TO_KHZ(20));
+
+		flags = reg_rule->flags;
+	} else {
+		flags = 0;
+	}
+
 	/*
 	 * Please note that this assumes target bandwidth is 20 MHz,
 	 * if that ever changes we also need to change the below logic
 	 * to include that as well.
 	 */
-	if (!is_ht40_allowed(channel_before))
+	if (!is_ht40_allowed(channel_before) ||
+	    flags & NL80211_RRF_NO_HT40MINUS)
 		channel->flags |= IEEE80211_CHAN_NO_HT40MINUS;
 	else
 		channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
 
-	if (!is_ht40_allowed(channel_after))
+	if (!is_ht40_allowed(channel_after) ||
+	    flags & NL80211_RRF_NO_HT40PLUS)
 		channel->flags |= IEEE80211_CHAN_NO_HT40PLUS;
 	else
 		channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
-- 
2.9.3
