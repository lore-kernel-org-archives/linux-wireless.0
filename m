Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53022 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QLV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>,
        Sara Sharon <sara.sharon@intel.com>
Subject: [RFC 4/6] cfg80211: properly track relation of transmitting and non-transmitting BSS
Date: Tue, 28 Aug 2018 14:13:51 +0200
Message-Id: <20180828121353.11193-5-johannes@sipsolutions.net> (sfid-20180828_141959_829344_E0519364)
In-Reply-To: <20180828121353.11193-1-johannes@sipsolutions.net>
References: <20180828121353.11193-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When holding data of the non-transmitting BSS, we need to keep
the transmitting BSS data on.
Otherwise it will be released, and release the non-transmitting
BSS with it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h |  9 +++++++++
 net/wireless/scan.c | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 625c59653ed6..f9f0b9cdac6c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -145,6 +145,7 @@ struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
 	struct list_head nontrans_list;
+	struct cfg80211_bss *transmitted_bss;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
@@ -175,12 +176,20 @@ static inline struct cfg80211_internal_bss *bss_from_pub(struct cfg80211_bss *pu
 static inline void cfg80211_hold_bss(struct cfg80211_internal_bss *bss)
 {
 	atomic_inc(&bss->hold);
+	if (bss->transmitted_bss)
+		cfg80211_hold_bss(container_of(bss->transmitted_bss,
+					       struct cfg80211_internal_bss,
+					       pub));
 }
 
 static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
 {
 	int r = atomic_dec_return(&bss->hold);
 	WARN_ON(r < 0);
+	if (bss->transmitted_bss)
+		cfg80211_unhold_bss(container_of(bss->transmitted_bss,
+						 struct cfg80211_internal_bss,
+						 pub));
 }
 
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c08b39a622b7..87526940178b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -108,6 +108,12 @@ static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
 				   pub);
 		bss->refcount++;
 	}
+	if (bss->transmitted_bss) {
+		bss = container_of(bss->transmitted_bss,
+				   struct cfg80211_internal_bss,
+				   pub);
+		bss->refcount++;
+	}
 }
 
 static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
@@ -124,6 +130,18 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
 		if (hbss->refcount == 0)
 			bss_free(hbss);
 	}
+
+	if (bss->transmitted_bss) {
+		struct cfg80211_internal_bss *tbss;
+
+		tbss = container_of(bss->transmitted_bss,
+				    struct cfg80211_internal_bss,
+				    pub);
+		tbss->refcount--;
+		if (tbss->refcount == 0)
+			bss_free(tbss);
+	}
+
 	bss->refcount--;
 	if (bss->refcount == 0)
 		bss_free(bss);
@@ -886,6 +904,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *rdev,
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
+		    struct cfg80211_bss *trans_bss,
 		    bool signal_valid)
 {
 	struct cfg80211_internal_bss *found = NULL;
@@ -1040,6 +1059,17 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			goto drop;
 		}
 
+		/* This must be before the call to bss_ref_get */
+		if (trans_bss) {
+			struct cfg80211_internal_bss *pbss =
+				container_of(trans_bss,
+					     struct cfg80211_internal_bss,
+					     pub);
+
+			new->transmitted_bss = trans_bss;
+			bss_ref_get(rdev, pbss);
+		}
+
 		list_add_tail(&new->list, &rdev->bss_list);
 		rdev->bss_entries++;
 		rb_insert_bss(rdev, new);
@@ -1294,7 +1324,8 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
+				  signal_valid);
 	if (!res)
 		return NULL;
 
@@ -1609,7 +1640,8 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
+				  signal_valid);
 	if (!res)
 		return NULL;
 
-- 
2.14.4
