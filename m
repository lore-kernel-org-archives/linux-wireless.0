Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3BNLUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 06:20:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: prevent spurious HT/VHT downgrade message
Date: Thu, 14 Feb 2013 12:20:26 +0100
Message-Id: <1360840826-23188-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_122034_394749_8A612C00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even when connecting to an AP that doesn't support VHT,
and even when the local device doesn't support it either,
the downgrade message gets printed. Suppress the message
if HT and/or VHT is disabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7d6a863..1087538 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -357,6 +357,10 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	ret = 0;
 
 out:
+	/* don't print the message below for VHT mismatch if VHT is disabled */
+	if (ret & IEEE80211_STA_DISABLE_VHT)
+		vht_chandef = *chandef;
+
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
 					IEEE80211_CHAN_DISABLED)) {
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
-- 
1.8.0

