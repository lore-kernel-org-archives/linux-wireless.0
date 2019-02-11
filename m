Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A8CC282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CA18222B9
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390608AbfBKPDV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:03:21 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44742 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390599AbfBKPDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:03:21 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtD79-0008BB-4R; Mon, 11 Feb 2019 16:03:19 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jouni Malinen <j@w1.fi>, Peng Xu <pxu@codeaurora.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] cfg80211: fix and clean up cfg80211_gen_new_bssid()
Date:   Mon, 11 Feb 2019 16:03:12 +0100
Message-Id: <20190211150312.2523-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Fix cfg80211_gen_new_bssid() to not rely on u64 modulo arithmetic,
which isn't needed since we really just want to mask there. Also,
clean it up to calculate the mask only once and use GENMASK_ULL()
instead of open-coding the mask calculation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b61b71f369c7..02a4d5a80521 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5475,22 +5475,20 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
  * @bssid: transmitter BSSID
  * @max_bssid: max BSSID indicator, taken from Multiple BSSID element
  * @mbssid_index: BSSID index, taken from Multiple BSSID index element
- * @new_bssid_addr: address of the resulting BSSID
+ * @new_bssid: address of the resulting BSSID
  */
 static inline void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
-					  u8 mbssid_index, u8 *new_bssid_addr)
+					  u8 mbssid_index, u8 *new_bssid)
 {
-	u64 bssid_tmp, new_bssid;
-	u64 lsb_n;
+	u64 bssid_u64 = ether_addr_to_u64(bssid);
+	u64 mask = GENMASK_ULL(max_bssid - 1, 0);
+	u64 new_bssid_u64;
 
-	bssid_tmp = ether_addr_to_u64(bssid);
+	new_bssid_u64 = bssid_u64 & ~mask;
 
-	lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
-	new_bssid = bssid_tmp;
-	new_bssid &= ~((1 << max_bssid) - 1);
-	new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);
+	new_bssid_u64 |= ((bssid_u64 & mask) + mbssid_index) & mask;
 
-	u64_to_ether_addr(new_bssid, new_bssid_addr);
+	u64_to_ether_addr(new_bssid_u64, new_bssid);
 }
 
 /**
-- 
2.17.2

