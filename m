Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED49C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED23220869
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfBHNYU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:24:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48864 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfBHNYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:24:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60P-0008Jb-QZ; Fri, 08 Feb 2019 14:15:45 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 12/15] cfg80211: fix the IE inheritance of extension IEs
Date:   Fri,  8 Feb 2019 14:15:36 +0100
Message-Id: <20190208131539.6813-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Extension IEs have ID 255 followed by extension ID. Current
code is buggy in handling it in two ways:
1. When checking if IE is in the frame, it uses just the ID, which
   for extension elements is too broad.
2. It uses 0xFF to mark copied IEs, which will result in not copying
   extension IEs from the subelement.

Fix both issue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 387e5f868684..46ecb10e85fb 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -216,7 +216,13 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 			continue;
 		}
 
-		tmp = (u8 *)cfg80211_find_ie(tmp_old[0], sub_copy, subie_len);
+		if (tmp_old[0] == WLAN_EID_EXTENSION)
+			tmp = (u8 *)cfg80211_find_ext_ie(tmp_old[2], sub_copy,
+							 subie_len);
+		else
+			tmp = (u8 *)cfg80211_find_ie(tmp_old[0], sub_copy,
+						     subie_len);
+
 		if (!tmp) {
 			/* ie in old ie but not in subelement */
 			if (tmp_old[0] != WLAN_EID_MULTIPLE_BSSID) {
@@ -226,8 +232,9 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 		} else {
 			/* ie in transmitting ie also in subelement,
 			 * copy from subelement and flag the ie in subelement
-			 * as copied (by setting eid field to 0xff). For
-			 * vendor ie, compare OUI + type + subType to
+			 * as copied (by setting eid field to WLAN_EID_SSID,
+			 * which is skipped anyway).
+			 * For vendor ie, compare OUI + type + subType to
 			 * determine if they are the same ie.
 			 */
 			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
@@ -237,7 +244,7 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 					 */
 					memcpy(pos, tmp, tmp[1] + 2);
 					pos += tmp[1] + 2;
-					tmp[0] = 0xff;
+					tmp[0] = WLAN_EID_SSID;
 				} else {
 					memcpy(pos, tmp_old, tmp_old[1] + 2);
 					pos += tmp_old[1] + 2;
@@ -246,7 +253,7 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 				/* copy ie from subelement into new ie */
 				memcpy(pos, tmp, tmp[1] + 2);
 				pos += tmp[1] + 2;
-				tmp[0] = 0xff;
+				tmp[0] = WLAN_EID_SSID;
 			}
 		}
 
@@ -263,8 +270,7 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 	while (tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
 		if (!(tmp_new[0] == WLAN_EID_NON_TX_BSSID_CAP ||
 		      tmp_new[0] == WLAN_EID_SSID ||
-		      tmp_new[0] == WLAN_EID_MULTI_BSSID_IDX ||
-		      tmp_new[0] == 0xff)) {
+		      tmp_new[0] == WLAN_EID_MULTI_BSSID_IDX)) {
 			memcpy(pos, tmp_new, tmp_new[1] + 2);
 			pos += tmp_new[1] + 2;
 		}
-- 
2.17.2

