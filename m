Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3BNLNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 06:13:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: remove and renumber NL80211_FEATURE_FULL_AP_CLIENT_STATE
Date: Thu, 14 Feb 2013 12:13:04 +0100
Message-Id: <1360840384-13986-1-git-send-email-johannes@sipsolutions.net> (sfid-20130214_121311_772413_A31329D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Adding the flag to mac80211 already without testing was
clearly a mistake, one that we now pay for by having to
reserve bit 13 forever. The problem is cfg80211 doesn't
allow capability/rate changes for station entries that
were added unassociated, so the station entries cannot
be set up properly when marked associated.

Change the NL80211_FEATURE_FULL_AP_CLIENT_STATE number
to make it clear to userspace implementations that all
current kernels don't actually support it, even though
the previous bit is set, and of course also remove the
flag from mac80211 until we test and fix the issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 3 ++-
 net/mac80211/main.c          | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1fd6e561..db6ef0b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3461,8 +3461,9 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_NEED_OBSS_SCAN			= 1 << 10,
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
-	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
+	/* bit 13 is reserved */
 	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
+	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 75a78c6..4c894da 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -572,8 +572,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS |
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
-			   NL80211_FEATURE_VIF_TXPOWER |
-			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
+			   NL80211_FEATURE_VIF_TXPOWER;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
1.8.0

