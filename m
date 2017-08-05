Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42300 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751477AbdHEIpY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:34 +0300
Message-Id: <20170805084438.12550-7-luca@coelho.fi> (sfid-20170805_104540_250123_726B68ED)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 06/10] cfg80211: honor NL80211_RRF_NO_HT40{MINUS,PLUS}
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Honor the NL80211_RRF_NO_HT40{MINUS,PLUS} flags in
reg_process_ht_flags_channel. Not doing so leads can lead
to a firmware assert in iwlwifi for example.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=195299

Fixes: b0d7aa59592b ("cfg80211: allow wiphy specific regdomain management")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
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
2.13.2
