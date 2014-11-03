Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59324 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaKCSGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 13:06:54 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so7174050wid.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2014 10:06:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] ieee80211: add "max length of AMPDU" enum for VHT
Date: Mon,  3 Nov 2014 20:06:47 +0200
Message-Id: <1415038007-2873-1-git-send-email-egrumbach@gmail.com> (sfid-20141103_190707_571153_B05E8D88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Maximum length of AMPDU that an STA can receive in VHT.
length = 2 ^ (13 + max_ampdu_length_exp) - 1.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b1be39c..42c910e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1274,7 +1274,7 @@ struct ieee80211_ht_cap {
 #define		IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT	2
 
 /*
- * Maximum length of AMPDU that the STA can receive.
+ * Maximum length of AMPDU that the STA can receive in high-throughput (HT).
  * Length = 2 ^ (13 + max_ampdu_length_exp) - 1 (octets)
  */
 enum ieee80211_max_ampdu_length_exp {
@@ -1284,6 +1284,21 @@ enum ieee80211_max_ampdu_length_exp {
 	IEEE80211_HT_MAX_AMPDU_64K = 3
 };
 
+/*
+ * Maximum length of AMPDU that the STA can receive in VHT.
+ * Length = 2 ^ (13 + max_ampdu_length_exp) - 1 (octets)
+ */
+enum ieee80211_vht_max_ampdu_length_exp {
+	IEEE80211_VHT_MAX_AMPDU_8K = 0,
+	IEEE80211_VHT_MAX_AMPDU_16K = 1,
+	IEEE80211_VHT_MAX_AMPDU_32K = 2,
+	IEEE80211_VHT_MAX_AMPDU_64K = 3,
+	IEEE80211_VHT_MAX_AMPDU_128K = 4,
+	IEEE80211_VHT_MAX_AMPDU_256K = 5,
+	IEEE80211_VHT_MAX_AMPDU_512K = 6,
+	IEEE80211_VHT_MAX_AMPDU_1024K = 7
+};
+
 #define IEEE80211_HT_MAX_AMPDU_FACTOR 13
 
 /* Minimum MPDU start spacing */
-- 
1.9.1

