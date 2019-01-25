Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7983C282C6
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE1D218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfAYLsf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:48:35 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55814 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfAYLsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 06:48:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmzyJ-0007S0-FQ; Fri, 25 Jan 2019 12:48:31 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 08/12] cfg80211: make BSSID generation function inline
Date:   Fri, 25 Jan 2019 12:48:21 +0100
Message-Id: <20190125114825.5872-8-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190125114825.5872-1-johannes@sipsolutions.net>
References: <20190125114825.5872-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

This will enable reuse by mac80211.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 23 +++++++++++++++++++++++
 net/wireless/scan.c    | 16 ----------------
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ceb27fec4710..a08e099c49f4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5307,6 +5307,29 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	return cfg80211_inform_bss_frame_data(wiphy, &data, mgmt, len, gfp);
 }
 
+/**
+ * cfg80211_gen_new_bssid - generate a nontransmitted BSSID for multi-BSSID
+ * @bssid: transmitter BSSID
+ * @max_bssid: max BSSID indicator, taken from Multiple BSSID element
+ * @mbssid_index: BSSID index, taken from Multiple BSSID index element
+ * @new_bssid_addr: address of the resulting BSSID
+ */
+static inline void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
+					  u8 mbssid_index, u8 *new_bssid_addr)
+{
+	u64 bssid_tmp, new_bssid;
+	u64 lsb_n;
+
+	bssid_tmp = ether_addr_to_u64(bssid);
+
+	lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
+	new_bssid = bssid_tmp;
+	new_bssid &= ~((1 << max_bssid) - 1);
+	new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);
+
+	u64_to_ether_addr(new_bssid, new_bssid_addr);
+}
+
 /**
  * enum cfg80211_bss_frame_type - frame type that the BSS data came from
  * @CFG80211_BSS_FTYPE_UNKNOWN: driver doesn't know whether the data is
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8fea029df134..a150f9563842 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -200,22 +200,6 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 	return true;
 }
 
-static void cfg80211_gen_new_bssid(const u8 *bssid, u8 max_bssid,
-				   u8 mbssid_index, u8 *new_bssid_addr)
-{
-	u64 bssid_tmp, new_bssid = 0;
-	u64 lsb_n;
-
-	bssid_tmp = ether_addr_to_u64(bssid);
-
-	lsb_n = bssid_tmp & ((1 << max_bssid) - 1);
-	new_bssid = bssid_tmp;
-	new_bssid &= ~((1 << max_bssid) - 1);
-	new_bssid |= (lsb_n + mbssid_index) % (1 << max_bssid);
-
-	u64_to_ether_addr(new_bssid, new_bssid_addr);
-}
-
 static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 				  const u8 *subelement, size_t subie_len,
 				  u8 *new_ie, gfp_t gfp)
-- 
2.17.2

