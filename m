Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59822 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbdBOOCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:02:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/5] ieee80211: define HT operation CCFS2 field
Date: Wed, 15 Feb 2017 15:02:10 +0100
Message-Id: <20170215140210.19393-5-johannes@sipsolutions.net> (sfid-20170215_150226_070559_654F2469)
In-Reply-To: <20170215140210.19393-1-johannes@sipsolutions.net>
References: <20170215140210.19393-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The Channel Center Frequency Segment 2 field is used in
802.11-2016 for encoding the actual channel position of
the 80+80/160 MHz channel, if the max NSS is restricted.
This is used for backwards compatibility.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4a15e77d9d66..4a7200c6c9ea 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1411,6 +1411,8 @@ struct ieee80211_ht_operation {
 #define		IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED	3
 #define IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT		0x0004
 #define IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT		0x0010
+#define IEEE80211_HT_OP_MODE_CCFS2_SHIFT		5
+#define IEEE80211_HT_OP_MODE_CCFS2_MASK			0x1fe0
 
 /* for stbc_param */
 #define IEEE80211_HT_STBC_PARAM_DUAL_BEACON		0x0040
-- 
2.9.3
