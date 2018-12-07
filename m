Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13CDC64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9623E20892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 12:11:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oa1qdtKZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BkkECF7C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9623E20892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbeLGMLA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:11:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbeLGMLA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 07:11:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE15960BFA; Fri,  7 Dec 2018 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544184658;
        bh=x2HNulU2o4awK2CfoJtX06lk6By2EzpTOLEUYIznLxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa1qdtKZeXhN9nw64bImUyAZ8breXOgZNXeeKKMil8ftPdwnfFAMCf5agqXKXtD5f
         5XCXzg3DiEFR3qwxevkT0LU7AAAnJbVnxKi3zspushkOK8ZkHGOSRRLuJavce9JNoe
         8l/eBnMn26b0DZh0AvnGQdXYzYgadps7frUvFWQw=
Received: from jouni.codeaurora.org (37-33-76-121.bb.dnainternet.fi [37.33.76.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6541361309;
        Fri,  7 Dec 2018 12:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544184657;
        bh=x2HNulU2o4awK2CfoJtX06lk6By2EzpTOLEUYIznLxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkkECF7C4Fc8ObhZxXBeQdDHHD/Bi9I8xcHqIpzMJjW0t3Iw4cgdxHMBQFvIRYqlX
         PQJMOLc/rKw1GrRAGOPYHB7Cd/fAiaYYLniyt20OC4SocDN37O2ba/zxFDv3m02uoi
         7JvxrNFXMNcc0TR2/GB70z08zP1Dftn5TUaTF9m8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6541361309
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH 2/5] cfg80211: Properly track transmitting and non-transmitting BSS
Date:   Fri,  7 Dec 2018 14:10:47 +0200
Message-Id: <1544184650-14124-2-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544184650-14124-1-git-send-email-jouni@codeaurora.org>
References: <1544184650-14124-1-git-send-email-jouni@codeaurora.org>
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
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/wireless/core.h |  9 +++++++++
 net/wireless/scan.c | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index d58c56a..b1afc4b 100644
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
@@ -183,12 +184,20 @@ static inline struct cfg80211_internal_bss *bss_from_pub(struct cfg80211_bss *pu
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
index 559f56d..6f2fed2 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -109,6 +109,12 @@ static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
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
@@ -125,6 +131,18 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
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
@@ -1028,6 +1046,7 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *rdev,
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
+		    struct cfg80211_bss *trans_bss,
 		    bool signal_valid)
 {
 	struct cfg80211_internal_bss *found = NULL;
@@ -1184,6 +1203,17 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
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
@@ -1339,7 +1369,8 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
+				  signal_valid);
 	if (!res)
 		return NULL;
 
@@ -1657,7 +1688,8 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
+				  signal_valid);
 	if (!res)
 		return NULL;
 
-- 
2.7.4

