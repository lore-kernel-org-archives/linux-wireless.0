Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760061Ab3B0Obm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 09:31:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: phaber@broadcom.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] nl80211: remove channel width and extended capa advertising
Date: Wed, 27 Feb 2013 15:31:36 +0100
Message-Id: <1361975496-5862-1-git-send-email-johannes@sipsolutions.net> (sfid-20130227_153146_957263_5EE9E83F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is another case of data increasing the size of the
wiphy information significantly with a new feature, for
now remove this as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    |  3 +--
 net/wireless/nl80211.c | 21 ---------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 33b75b9..9220021 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -367,8 +367,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
 
-	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH |
-			       NL80211_FEATURE_ADVERTISE_CHAN_LIMITS;
+	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH;
 
 	return &rdev->wiphy;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e652d05..7a7b621 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -557,18 +557,6 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	if ((chan->flags & IEEE80211_CHAN_RADAR) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
 		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_HT40MINUS) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_MINUS))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_HT40PLUS) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_PLUS))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_80MHZ) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_80MHZ))
-		goto nla_put_failure;
-	if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
-	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
-		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 			DBM_TO_MBM(chan->max_power)))
@@ -1310,15 +1298,6 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			dev->wiphy.max_acl_mac_addrs))
 		goto nla_put_failure;
 
-	if (dev->wiphy.extended_capabilities &&
-	    (nla_put(msg, NL80211_ATTR_EXT_CAPA,
-		     dev->wiphy.extended_capabilities_len,
-		     dev->wiphy.extended_capabilities) ||
-	     nla_put(msg, NL80211_ATTR_EXT_CAPA_MASK,
-		     dev->wiphy.extended_capabilities_len,
-		     dev->wiphy.extended_capabilities_mask)))
-		goto nla_put_failure;
-
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
-- 
1.8.0

