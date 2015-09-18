Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46823 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbbIRVCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 17:02:18 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] nl80211:  Print reasons for errors in setting bitrates.
Date: Fri, 18 Sep 2015 14:02:15 -0700
Message-Id: <1442610135-8696-1-git-send-email-greearb@candelatech.com> (sfid-20150918_230221_739029_1B62934D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Makes it easier to figure out why user-space calls are
failing.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/nl80211.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba73def..94c9ad8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8287,44 +8287,60 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		enum ieee80211_band band = nla_type(tx_rates);
 		int err;
 
-		if (band < 0 || band >= IEEE80211_NUM_BANDS)
+		if (band < 0 || band >= IEEE80211_NUM_BANDS) {
+			pr_err("band: %d is out of range, num-bands: %d\n",
+			       band, IEEE80211_NUM_BANDS);
 			return -EINVAL;
+		}
 		sband = rdev->wiphy.bands[band];
-		if (sband == NULL)
+		if (!sband) {
+			pr_err("sband[%d] is null\n", band);
 			return -EINVAL;
+		}
 		err = nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
 				nla_len(tx_rates), nl80211_txattr_policy);
-		if (err)
+		if (err) {
+			pr_err("Error parsing tx_rates, band: %d\n", band);
 			return err;
+		}
 		if (tb[NL80211_TXRATE_LEGACY]) {
 			mask.control[band].legacy = rateset_to_mask(
 				sband,
 				nla_data(tb[NL80211_TXRATE_LEGACY]),
 				nla_len(tb[NL80211_TXRATE_LEGACY]));
 			if ((mask.control[band].legacy == 0) &&
-			    nla_len(tb[NL80211_TXRATE_LEGACY]))
+			    nla_len(tb[NL80211_TXRATE_LEGACY])) {
+				pr_err("Legacy rates invalid, band: %d.\n",
+				       band);
 				return -EINVAL;
+			}
 		}
 		if (tb[NL80211_TXRATE_HT]) {
 			if (!ht_rateset_to_mask(
 					sband,
 					nla_data(tb[NL80211_TXRATE_HT]),
 					nla_len(tb[NL80211_TXRATE_HT]),
-					mask.control[band].ht_mcs))
+					mask.control[band].ht_mcs)) {
+				pr_err("HT rates invalid, band: %d\n", band);
 				return -EINVAL;
+			}
 		}
 		if (tb[NL80211_TXRATE_VHT]) {
 			if (!vht_set_mcs_mask(
 					sband,
 					nla_data(tb[NL80211_TXRATE_VHT]),
-					mask.control[band].vht_mcs))
+					mask.control[band].vht_mcs)) {
+				pr_err("VHT rates invalid, band: %d\n", band);
 				return -EINVAL;
+			}
 		}
 		if (tb[NL80211_TXRATE_GI]) {
 			mask.control[band].gi =
 				nla_get_u8(tb[NL80211_TXRATE_GI]);
-			if (mask.control[band].gi > NL80211_TXRATE_FORCE_LGI)
+			if (mask.control[band].gi > NL80211_TXRATE_FORCE_LGI) {
+				pr_err("FORCE-LGI invalid, band: %d\n", band);
 				return -EINVAL;
+			}
 		}
 
 		if (mask.control[band].legacy == 0) {
@@ -8332,8 +8348,11 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 			 * are not even supported.
 			 */
 			if (!(rdev->wiphy.bands[band]->ht_cap.ht_supported ||
-			      rdev->wiphy.bands[band]->vht_cap.vht_supported))
+			      rdev->wiphy.bands[band]->vht_cap.vht_supported)) {
+				pr_err("Legacy is empty, as is ht, vht, band: %d\n",
+				       band);
 				return -EINVAL;
+			}
 
 			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
 				if (mask.control[band].ht_mcs[i])
@@ -8344,6 +8363,8 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 					goto out;
 
 			/* legacy and mcs rates may not be both empty */
+			pr_err("Legacy and MCS both empty sets, band: %d\n",
+			       band);
 			return -EINVAL;
 		}
 	}
-- 
2.4.3

