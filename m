Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4A2C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DF3E2064A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:52:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DF3E2064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbeJAQ3S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:29:18 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56406 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbeJAQ3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:29:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6usE-0001z4-IO; Mon, 01 Oct 2018 11:52:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: move cookie_counter out of wiphy
Date:   Mon,  1 Oct 2018 11:52:07 +0200
Message-Id: <20181001095207.16423-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's no reason for drivers to be able to access the
cfg80211 internal cookie counter; move it out of the
wiphy into the rdev structure.

While at it, also make it never assign 0 as a cookie
(we consider that invalid in some places), and warn if
we manage to do that for some reason (wrapping is not
likely to happen with a u64.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  3 ---
 net/wireless/core.h    | 11 +++++++++++
 net/wireless/nl80211.c |  4 ++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f3ed79c39d7..b74ab3a545ab 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3960,7 +3960,6 @@ struct wiphy_iftype_ext_capab {
  *	by the driver in the .connect() callback. The bit position maps to the
  *	attribute indices defined in &enum nl80211_bss_select_attr.
  *
- * @cookie_counter: unique generic cookie counter, used to identify objects.
  * @nan_supported_bands: bands supported by the device in NAN mode, a
  *	bitmap of &enum nl80211_band values.  For instance, for
  *	NL80211_BAND_2GHZ, bit 0 would be set
@@ -4099,8 +4098,6 @@ struct wiphy {
 
 	u32 bss_select_support;
 
-	u64 cookie_counter;
-
 	u8 nan_supported_bands;
 
 	u32 txq_limit;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 45fd4e21dbda..c61dbba8bf47 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -66,6 +66,7 @@ struct cfg80211_registered_device {
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
+	u64 cookie_counter;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
@@ -133,6 +134,16 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 #endif
 }
 
+static inline u64 cfg80211_assign_cookie(struct cfg80211_registered_device *rdev)
+{
+	u64 r = ++rdev->cookie_counter;
+
+	if (WARN_ON(r == 0))
+		r = ++rdev->cookie_counter;
+
+	return r;
+}
+
 extern struct workqueue_struct *cfg80211_wq;
 extern struct list_head cfg80211_rdev_list;
 extern int cfg80211_rdev_list_generation;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 52086f71103a..35d2947a2af5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7759,7 +7759,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	 */
 	if (want_multi && rdev->wiphy.max_sched_scan_reqs > 1) {
 		while (!sched_scan_req->reqid)
-			sched_scan_req->reqid = rdev->wiphy.cookie_counter++;
+			sched_scan_req->reqid = cfg80211_assign_cookie(rdev);
 	}
 
 	err = rdev_sched_scan_start(rdev, dev, sched_scan_req);
@@ -11755,7 +11755,7 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (!func)
 		return -ENOMEM;
 
-	func->cookie = wdev->wiphy->cookie_counter++;
+	func->cookie = cfg80211_assign_cookie(rdev);
 
 	if (!tb[NL80211_NAN_FUNC_TYPE] ||
 	    nla_get_u8(tb[NL80211_NAN_FUNC_TYPE]) > NL80211_NAN_FUNC_MAX_TYPE) {
-- 
2.14.4

