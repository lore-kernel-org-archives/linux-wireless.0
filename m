Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F50C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1982073D
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 12:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfBHMcA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 07:32:00 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:47442 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfBHMb7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 07:31:59 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs5K1-0007Gh-G5; Fri, 08 Feb 2019 13:31:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: use element iteration macro in parsing
Date:   Fri,  8 Feb 2019 13:31:52 +0100
Message-Id: <20190208123154.22414-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208123154.22414-1-johannes@sipsolutions.net>
References: <20190208123154.22414-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Instead of open-coding the element walk, use the new macro.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d0eb38b890aa..7fa9ba197c26 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -895,8 +895,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc)
 {
-	size_t left = len;
-	const u8 *pos = start;
+	struct element *elem;
 	bool calc_crc = filter != 0;
 	DECLARE_BITMAP(seen_elems, 256);
 	const u8 *ie;
@@ -906,18 +905,11 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	elems->ie_start = start;
 	elems->total_len = len;
 
-	while (left >= 2) {
-		u8 id, elen;
+	for_each_element(elem, start, len) {
 		bool elem_parse_failed;
-
-		id = *pos++;
-		elen = *pos++;
-		left -= 2;
-
-		if (elen > left) {
-			elems->parse_error = true;
-			break;
-		}
+		u8 id = elem->id;
+		u8 elen = elem->datalen;
+		const u8 *pos = elem->data;
 
 		switch (id) {
 		case WLAN_EID_SSID:
@@ -960,8 +952,6 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		 */
 			if (test_bit(id, seen_elems)) {
 				elems->parse_error = true;
-				left -= elen;
-				pos += elen;
 				continue;
 			}
 			break;
@@ -1244,12 +1234,9 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			elems->parse_error = true;
 		else
 			__set_bit(id, seen_elems);
-
-		left -= elen;
-		pos += elen;
 	}
 
-	if (left != 0)
+	if (!for_each_element_completed(elem, start, len))
 		elems->parse_error = true;
 
 	return crc;
-- 
2.17.2

