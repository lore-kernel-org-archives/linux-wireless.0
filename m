Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:33308 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab2GDP7D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 11:59:03 -0400
Received: by werb14 with SMTP id b14so4517695wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 08:59:01 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC 3/4] cfg80211: allow driver to implement HT capabilities per netdev
Date: Wed,  4 Jul 2012 18:58:49 +0300
Message-Id: <1341417530-9062-4-git-send-email-arik@wizery.com> (sfid-20120704_175910_732975_DEF7DC33)
In-Reply-To: <1341417530-9062-1-git-send-email-arik@wizery.com>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a callback allowing drivers to return custom HT capabilities per
interface (netdev). This callback is used when per-band HT capabilities
are marked as invalid.

Use the new callback to return per-netdev HT capabilities where
need by NL80211 commands - namely, GET_WIPHY and SET_TX_BITRATE_MASK.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/cfg80211.h |    7 +++++++
 net/wireless/nl80211.c |   49 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7b24d88..b27ffe1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1619,6 +1619,10 @@ struct cfg80211_gtk_rekey_data {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *	See @ethtool_ops.get_strings
+ *
+ * @get_ht_cap: Get the HT capabilities of the given interface on the given
+ *	band. If not implemented, the per-band HT capabilities from struct
+ *	wiphy are used.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1827,6 +1831,9 @@ struct cfg80211_ops {
 				  u32 sset, u8 *data);
 
 	void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
+	struct ieee80211_sta_ht_cap *(*get_ht_cap)(struct wiphy *wiphy,
+						   struct net_device *dev,
+						   enum ieee80211_band band);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 010ff47..e737d8c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -790,6 +790,19 @@ nla_put_failure:
 	return -ENOBUFS;
 }
 
+static const struct ieee80211_sta_ht_cap *
+nl80211_get_ht_cap(struct cfg80211_registered_device *dev,
+		   struct net_device *netdev, enum ieee80211_band band)
+{
+	WARN_ON(!dev->wiphy.bands[band]);
+
+	if (netdev && dev->ops->get_ht_cap &&
+	    dev->wiphy.bands[band]->ht_cap_invalid)
+		return dev->ops->get_ht_cap(&dev->wiphy, netdev, band);
+
+	return &dev->wiphy.bands[band]->ht_cap;
+}
+
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *dev,
 			      struct net_device *netdev)
@@ -902,6 +915,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		goto nla_put_failure;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		const struct ieee80211_sta_ht_cap *local_ht_cap;
 		if (!dev->wiphy.bands[band])
 			continue;
 
@@ -909,17 +923,19 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		if (!nl_band)
 			goto nla_put_failure;
 
+		local_ht_cap = nl80211_get_ht_cap(dev, netdev, band);
+
 		/* add HT info */
-		if (dev->wiphy.bands[band]->ht_cap.ht_supported &&
+		if (local_ht_cap->ht_supported &&
 		    (nla_put(msg, NL80211_BAND_ATTR_HT_MCS_SET,
-			     sizeof(dev->wiphy.bands[band]->ht_cap.mcs),
-			     &dev->wiphy.bands[band]->ht_cap.mcs) ||
+			     sizeof(local_ht_cap->mcs),
+			     &local_ht_cap->mcs) ||
 		     nla_put_u16(msg, NL80211_BAND_ATTR_HT_CAPA,
-				 dev->wiphy.bands[band]->ht_cap.cap) ||
+				 local_ht_cap->cap) ||
 		     nla_put_u8(msg, NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
-				dev->wiphy.bands[band]->ht_cap.ampdu_factor) ||
+				local_ht_cap->ampdu_factor) ||
 		     nla_put_u8(msg, NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
-				dev->wiphy.bands[band]->ht_cap.ampdu_density)))
+				local_ht_cap->ampdu_density)))
 			goto nla_put_failure;
 
 		/* add VHT info */
@@ -5793,7 +5809,7 @@ static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
 	return mask;
 }
 
-static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
+static bool ht_rateset_to_mask(const struct ieee80211_sta_ht_cap *ht_cap,
 			       u8 *rates, u8 rates_len,
 			       u8 mcs[IEEE80211_HT_MCS_MASK_LEN])
 {
@@ -5812,7 +5828,7 @@ static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
 			return false;
 
 		/* check availability */
-		if (sband->ht_cap.mcs.rx_mask[ridx] & rbit)
+		if (ht_cap->mcs.rx_mask[ridx] & rbit)
 			mcs[ridx] |= rbit;
 		else
 			return false;
@@ -5838,6 +5854,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct nlattr *tx_rates;
 	struct ieee80211_supported_band *sband;
+	const struct ieee80211_sta_ht_cap *ht_cap;
 
 	if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
 		return -EINVAL;
@@ -5851,13 +5868,15 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		sband = rdev->wiphy.bands[i];
 		mask.control[i].legacy =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
-		if (sband)
+		if (sband) {
+			ht_cap = nl80211_get_ht_cap(rdev, dev, i);
 			memcpy(mask.control[i].mcs,
-			       sband->ht_cap.mcs.rx_mask,
+			       ht_cap->mcs.rx_mask,
 			       sizeof(mask.control[i].mcs));
-		else
+		} else {
 			memset(mask.control[i].mcs, 0,
 			       sizeof(mask.control[i].mcs));
+		}
 	}
 
 	/*
@@ -5884,9 +5903,10 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 			    nla_len(tb[NL80211_TXRATE_LEGACY]))
 				return -EINVAL;
 		}
+		ht_cap = nl80211_get_ht_cap(rdev, dev, band);
 		if (tb[NL80211_TXRATE_MCS]) {
 			if (!ht_rateset_to_mask(
-					sband,
+					ht_cap,
 					nla_data(tb[NL80211_TXRATE_MCS]),
 					nla_len(tb[NL80211_TXRATE_MCS]),
 					mask.control[band].mcs))
@@ -5894,9 +5914,12 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		}
 
 		if (mask.control[band].legacy == 0) {
+			const struct ieee80211_sta_ht_cap *ht_cap;
+			ht_cap = nl80211_get_ht_cap(rdev, dev, band);
+
 			/* don't allow empty legacy rates if HT
 			 * is not even supported. */
-			if (!rdev->wiphy.bands[band]->ht_cap.ht_supported)
+			if (!ht_cap->ht_supported)
 				return -EINVAL;
 
 			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-- 
1.7.9.5

