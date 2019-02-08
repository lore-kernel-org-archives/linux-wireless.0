Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2758AC169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B81217D8
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbfBHNPy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:15:54 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48702 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfBHNPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:15:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60O-0008Jb-2n; Fri, 08 Feb 2019 14:15:44 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 07/15] cfg80211: parse multi-bssid only if HW supports it
Date:   Fri,  8 Feb 2019 14:15:31 +0100
Message-Id: <20190208131539.6813-7-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
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
index 86de6b62a44b..67aeb7199617 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4315,6 +4315,11 @@ struct cfg80211_pmsr_capabilities {
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
@@ -4455,6 +4460,9 @@ struct wiphy {
 	u32 txq_memory_limit;
 	u32 txq_quantum;
 
+	u8 support_mbssid:1,
+	   support_only_he_mbssid:1;
+
 	const struct cfg80211_pmsr_capabilities *pmsr_capa;
 
 	char priv[0] __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 325323a842d8..ab0f0178ee0e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1417,6 +1417,11 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 		return;
 	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return;
+	if (!wiphy->support_mbssid)
+		return;
+	if (wiphy->support_only_he_mbssid &&
+	    !cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ie, ielen))
+		return;
 
 	new_ie = kmalloc(IEEE80211_MAX_DATA_LEN, gfp);
 	if (!new_ie)
@@ -1701,7 +1706,11 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 
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

