Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745DCC282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B6EC217D8
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfBHNPp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:15:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48694 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfBHNPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:15:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60N-0008Jb-Be; Fri, 08 Feb 2019 14:15:43 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 05/15] cfg80211: Properly track transmitting and non-transmitting BSS
Date:   Fri,  8 Feb 2019 14:15:29 +0100
Message-Id: <20190208131539.6813-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When holding data of the non-transmitting BSS, we need to keep the
transmitting BSS data on. Otherwise it will be released, and release
the non-transmitting BSS with it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.h | 12 ++++++++++++
 net/wireless/scan.c | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index a50b92ac77a1..c20c75df60f5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -153,6 +153,7 @@ struct cfg80211_internal_bss {
 	struct list_head list;
 	struct list_head hidden_list;
 	struct list_head nontrans_list;
+	struct cfg80211_bss *transmitted_bss;
 	struct rb_node rbn;
 	u64 ts_boottime;
 	unsigned long ts;
@@ -183,12 +184,23 @@ static inline struct cfg80211_internal_bss *bss_from_pub(struct cfg80211_bss *pu
 static inline void cfg80211_hold_bss(struct cfg80211_internal_bss *bss)
 {
 	atomic_inc(&bss->hold);
+	if (bss->transmitted_bss) {
+		bss = container_of(bss->transmitted_bss,
+				   struct cfg80211_internal_bss, pub);
+		atomic_inc(&bss->hold);
+	}
 }
 
 static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
 {
 	int r = atomic_dec_return(&bss->hold);
 	WARN_ON(r < 0);
+	if (bss->transmitted_bss) {
+		bss = container_of(bss->transmitted_bss,
+				   struct cfg80211_internal_bss, pub);
+		r = atomic_dec_return(&bss->hold);
+		WARN_ON(r < 0);
+	}
 }
 
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 54feb7741c26..d5950a23e619 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -110,6 +110,12 @@ static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
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
@@ -126,6 +132,18 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
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
@@ -1024,6 +1042,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *rdev,
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
+		    struct cfg80211_bss *trans_bss,
 		    bool signal_valid)
 {
 	struct cfg80211_internal_bss *found = NULL;
@@ -1181,6 +1200,17 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
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
@@ -1336,7 +1366,8 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
+				  signal_valid);
 	if (!res)
 		return NULL;
 
@@ -1639,7 +1670,8 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
+				  signal_valid);
 	if (!res)
 		return NULL;
 
-- 
2.17.2

