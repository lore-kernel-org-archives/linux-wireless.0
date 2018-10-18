Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D261C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9A312145D
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:36:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9A312145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbeJRQgD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:36:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59950 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbeJRQgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:36:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gD3mo-0002rB-6q; Thu, 18 Oct 2018 10:36:06 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sushant Kumar Mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: allow hardware scan to fall back to software
Date:   Thu, 18 Oct 2018 10:35:47 +0200
Message-Id: <20181018083547.23262-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In some cases, like in the rsi driver hardware scan offload, there
may be scenarios in which hardware scan might not be available or
desirable.

Allow drivers to cope with this by letting them fall back to software
scan by returning the special value 1 from the hardware scan method.

Requested-by: Sushant Kumar Mishra <sushant2k1513@gmail.com>
Requested-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  5 +++++
 net/mac80211/scan.c    | 22 ++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e95d2d9..4631b3b6fc37 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3239,6 +3239,11 @@ enum ieee80211_reconfig_type {
  *	When the scan finishes, ieee80211_scan_completed() must be called;
  *	note that it also must be called when the scan cannot finish due to
  *	any error unless this callback returned a negative error code.
+ *	This callback is also allowed to return the special return value 1,
+ *	this indicates that hardware scan isn't desirable right now and a
+ *	software scan should be done instead. A driver wishing to use this
+ *	capability must ensure its (hardware) scan capabilities aren't
+ *	advertised as more capable than mac80211's software scan is.
  *	The callback can sleep.
  *
  * @cancel_hw_scan: Ask the low-level tp cancel the active hw scan.
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5d2a11777718..95413413f98c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -356,7 +356,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	bool hw_scan = local->ops->hw_scan;
+	bool hw_scan = test_bit(SCAN_HW_SCANNING, &local->scanning);
 	bool was_scanning = local->scanning;
 	struct cfg80211_scan_request *scan_req;
 	struct ieee80211_sub_if_data *scan_sdata;
@@ -606,6 +606,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
+	bool hw_scan = local->ops->hw_scan;
 	int rc;
 
 	lockdep_assert_held(&local->mtx);
@@ -620,7 +621,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		return 0;
 	}
 
-	if (local->ops->hw_scan) {
+ again:
+	if (hw_scan) {
 		u8 *ies;
 
 		local->hw_scan_ies_bufsize = local->scan_ies_len + req->ie_len;
@@ -679,7 +681,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	else
 		memcpy(local->scan_addr, sdata->vif.addr, ETH_ALEN);
 
-	if (local->ops->hw_scan) {
+	if (hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
 		   (req->channels[0] == local->_oper_chandef.chan)) {
@@ -722,7 +724,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_recalc_idle(local);
 
-	if (local->ops->hw_scan) {
+	if (hw_scan) {
 		WARN_ON(!ieee80211_prep_hw_scan(local));
 		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
 	} else {
@@ -740,6 +742,18 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(local->scan_sdata, NULL);
 	}
 
+	if (hw_scan && rc == 1) {
+		/*
+		 * we can't fall back to software for P2P-GO
+		 * as it must update NoA etc.
+		 */
+		if (ieee80211_vif_type_p2p(&sdata->vif) ==
+				NL80211_IFTYPE_P2P_GO)
+			return -EOPNOTSUPP;
+		hw_scan = false;
+		goto again;
+	}
+
 	return rc;
 }
 
-- 
2.17.2

