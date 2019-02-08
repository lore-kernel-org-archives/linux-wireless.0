Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C51C282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89869217D8
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfBHNPq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:15:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48690 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfBHNPp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:15:45 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60N-0008Jb-0d; Fri, 08 Feb 2019 14:15:43 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v8 04/15] cfg80211: use for_each_element() for multi-bssid parsing
Date:   Fri,  8 Feb 2019 14:15:28 +0100
Message-Id: <20190208131539.6813-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Use the new for_each_element() helper here, we cannot use
for_each_subelement() since we have a fixed 1 byte before
the subelements start.

While at it, also fix le16_to_cpup() to be get_unaligned_le16()
since we don't know anything about alignment.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 47 +++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 531c2e56413f..54feb7741c26 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1377,9 +1377,9 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 				       struct cfg80211_bss *trans_bss,
 				       gfp_t gfp)
 {
-	const u8 *pos, *subelement, *mbssid_end_pos;
-	const u8 *tmp, *mbssid_index_ie;
-	size_t subie_len, new_ie_len;
+	const u8 *mbssid_index_ie;
+	const struct element *elem, *sub;
+	size_t new_ie_len;
 	u8 new_bssid[ETH_ALEN];
 	u8 *new_ie;
 	u16 capability;
@@ -1390,34 +1390,21 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return;
 
-	pos = ie;
-
 	new_ie = kmalloc(IEEE80211_MAX_DATA_LEN, gfp);
 	if (!new_ie)
 		return;
 
-	while (pos < ie + ielen + 2) {
-		tmp = cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, pos,
-				       ielen - (pos - ie));
-		if (!tmp)
-			break;
-
-		mbssid_end_pos = tmp + tmp[1] + 2;
-		/* Skip Element ID, Len, MaxBSSID Indicator */
-		if (tmp[1] < 4)
-			break;
-		for (subelement = tmp + 3; subelement < mbssid_end_pos - 1;
-		     subelement += 2 + subelement[1]) {
-			subie_len = subelement[1];
-			if (mbssid_end_pos - subelement < 2 + subie_len)
-				break;
-			if (subelement[0] != 0 || subelement[1] < 4) {
+	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ie, ielen) {
+		if (elem->datalen < 4)
+			continue;
+		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
+			if (sub->id != 0 || sub->datalen < 4) {
 				/* not a valid BSS profile */
 				continue;
 			}
 
-			if (subelement[2] != WLAN_EID_NON_TX_BSSID_CAP ||
-			    subelement[3] != 2) {
+			if (sub->data[0] != WLAN_EID_NON_TX_BSSID_CAP ||
+			    sub->data[1] != 2) {
 				/* The first element within the Nontransmitted
 				 * BSSID Profile is not the Nontransmitted
 				 * BSSID Capability element.
@@ -1428,26 +1415,24 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 			/* found a Nontransmitted BSSID Profile */
 			mbssid_index_ie = cfg80211_find_ie
 				(WLAN_EID_MULTI_BSSID_IDX,
-				 subelement + 2, subie_len);
+				 sub->data, sub->datalen);
 			if (!mbssid_index_ie || mbssid_index_ie[1] < 1 ||
 			    mbssid_index_ie[2] == 0) {
 				/* No valid Multiple BSSID-Index element */
 				continue;
 			}
 
-			cfg80211_gen_new_bssid(bssid, tmp[2],
+			cfg80211_gen_new_bssid(bssid, elem->data[0],
 					       mbssid_index_ie[2],
 					       new_bssid);
 			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
-			new_ie_len = cfg80211_gen_new_ie(ie, ielen,
-							 subelement + 2,
-							 subie_len, new_ie,
+			new_ie_len = cfg80211_gen_new_ie(ie, ielen, sub->data,
+							 sub->datalen, new_ie,
 							 gfp);
 			if (!new_ie_len)
 				continue;
 
-			capability = le16_to_cpup((const __le16 *)
-						  &subelement[4]);
+			capability = get_unaligned_le16(sub->data + 2);
 			bss = cfg80211_inform_single_bss_data(wiphy, data,
 							      ftype,
 							      new_bssid, tsf,
@@ -1460,8 +1445,6 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 				break;
 			cfg80211_put_bss(wiphy, bss);
 		}
-
-		pos = mbssid_end_pos;
 	}
 
 	kfree(new_ie);
-- 
2.17.2

