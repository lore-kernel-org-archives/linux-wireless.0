Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759935Ab3B0OsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 09:48:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: phaber@broadcom.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: re-add channel width and extended capa advertising
Date: Wed, 27 Feb 2013 15:48:08 +0100
Message-Id: <1361976488-9773-1-git-send-email-johannes@sipsolutions.net> (sfid-20130227_154817_660820_11BC8BC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add back the channel width and extended capability data
to wiphy information if split information is supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3506a8..ba07fa5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -573,6 +573,21 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		}
 	}
 
+	if (large) {
+		if ((chan->flags & IEEE80211_CHAN_NO_HT40MINUS) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_MINUS))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_HT40PLUS) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_HT40_PLUS))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_80MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_80MHZ))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
+			goto nla_put_failure;
+	}
+
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 			DBM_TO_MBM(chan->max_power)))
 		goto nla_put_failure;
@@ -1137,6 +1152,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 	const struct ieee80211_txrx_stypes *mgmt_stypes =
 				dev->wiphy.mgmt_stypes;
 	long start = 0, start_chan = 0, start_band = 0;
+	u32 features;
 
 	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_WIPHY);
 	if (!hdr)
@@ -1461,8 +1477,15 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 				dev->wiphy.ap_sme_capa))
 			goto nla_put_failure;
 
-		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS,
-				dev->wiphy.features))
+		features = dev->wiphy.features;
+		/*
+		 * We can only add the per-channel limit information if the
+		 * dump is split, otherwise it makes it too big. Therefore
+		 * only advertise it in that case.
+		 */
+		if (split)
+			features |= NL80211_FEATURE_ADVERTISE_CHAN_LIMITS;
+		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS, features))
 			goto nla_put_failure;
 
 		if (dev->wiphy.ht_capa_mod_mask &&
@@ -1490,7 +1513,14 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		(*split_start)++;
 		break;
 	case 9:
-		/* placeholder */
+		if (dev->wiphy.extended_capabilities &&
+		    (nla_put(msg, NL80211_ATTR_EXT_CAPA,
+			     dev->wiphy.extended_capabilities_len,
+			     dev->wiphy.extended_capabilities) ||
+		     nla_put(msg, NL80211_ATTR_EXT_CAPA_MASK,
+			     dev->wiphy.extended_capabilities_len,
+			     dev->wiphy.extended_capabilities_mask)))
+			goto nla_put_failure;
 
 		/* done */
 		*split_start = 0;
-- 
1.8.0

