Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43586 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753703AbdBNNWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:22:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/7] ieee80211: define HT operation CCFS2 field
Date: Tue, 14 Feb 2017 14:22:03 +0100
Message-Id: <20170214132208.8715-3-johannes@sipsolutions.net> (sfid-20170214_142242_062130_6A34A3C2)
In-Reply-To: <20170214132208.8715-1-johannes@sipsolutions.net>
References: <20170214132208.8715-1-johannes@sipsolutions.net>
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
