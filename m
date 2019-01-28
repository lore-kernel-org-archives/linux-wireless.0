Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44021C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 10:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226E12148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 10:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfA1KzI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 05:55:08 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35356 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfA1Ky6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 05:54:58 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1go4Z7-0007bD-4g; Mon, 28 Jan 2019 11:54:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v7 06/11] cfg80211: parse mbssid only if HW supports it
Date:   Mon, 28 Jan 2019 11:54:41 +0100
Message-Id: <20190128105446.17256-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190128105446.17256-1-johannes@sipsolutions.net>
References: <20190128105446.17256-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Parsing and exposing nontransmitted APs is problematic
when underlying HW doesn't support it. Do it only if
driver indicated support. Allow HE restriction as well,
since the HE spec defined the exact manner that Multiple
BSSID set should behave. APs that not support the HE
spec will have less predictable Multiple BSSID set
support/behavior

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  8 ++++++++
 net/wireless/scan.c    | 11 ++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ac2961b74c9b..5a8b1b5c3ac8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4300,6 +4300,11 @@ struct cfg80211_pmsr_capabilities {
  * @txq_memory_limit: configuration internal TX queue memory limit
  * @txq_quantum: configuration of internal TX queue scheduler quantum
  *
+ * @support_mbssid: can HW support association with nontransmitted AP
+ * @support_only_he_mbssid: don't parse MBSSID elements if it is not
+ *	HE AP, in order to avoid compatibility issues.
+ *	@support_mbssid must be set for this to have any effect.
+ *
  * @pmsr_capa: peer measurement capabilities
  */
 struct wiphy {
@@ -4440,6 +4445,9 @@ struct wiphy {
 	u32 txq_memory_limit;
 	u32 txq_quantum;
 
+	u8 support_mbssid:1,
+	   support_only_he_mbssid:1;
+
 	const struct cfg80211_pmsr_capabilities *pmsr_capa;
 
 	char priv[0] __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1e95b46e84e2..77b0e1d08b13 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1424,6 +1424,11 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 		return;
 	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return;
+	if (!wiphy->support_mbssid)
+		return;
+	if (wiphy->support_only_he_mbssid &&
+	    !cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ie, ielen))
+		return;
 
 	pos = ie;
 
@@ -1725,7 +1730,11 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
 						    len, NULL, gfp);
-	if (!res || !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
+	if (!res || !wiphy->support_mbssid ||
+	    !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
+		return res;
+	if (wiphy->support_only_he_mbssid &&
+	    !cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ie, ielen))
 		return res;
 
 	/* process each non-transmitting bss */
-- 
2.17.2

