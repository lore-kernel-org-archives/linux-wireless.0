Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30260 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbZGWKBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:01:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:01:39 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19048.13563.475455.554327@localhost.localdomain>
Date: Thu, 23 Jul 2009 15:31:31 +0530
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Add a few 802.11n defines for AMPDU parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 include/linux/ieee80211.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 23343ab..21556a2 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -802,6 +802,31 @@ struct ieee80211_ht_cap {
 #define IEEE80211_HT_AMPDU_PARM_FACTOR		0x03
 #define IEEE80211_HT_AMPDU_PARM_DENSITY		0x1C
 
+/*
+ * Maximum length of AMPDU that the STA can receive.
+ * Length = 2 ^ (13 + max_ampdu_length_exp) - 1 (octets)
+ */
+enum ieee80211_max_ampdu_length_exp {
+	IEEE80211_HT_MAX_AMPDU_8K = 0,
+	IEEE80211_HT_MAX_AMPDU_16K = 1,
+	IEEE80211_HT_MAX_AMPDU_32K = 2,
+	IEEE80211_HT_MAX_AMPDU_64K = 3
+};
+
+#define IEEE80211_HT_MAX_AMPDU_FACTOR 13
+
+/* Minimum MPDU start spacing */
+enum ieee80211_min_mpdu_spacing {
+	IEEE80211_HT_MPDU_DENSITY_NONE = 0,	/* No restriction */
+	IEEE80211_HT_MPDU_DENSITY_0_25 = 1,	/* 1/4 usec */
+	IEEE80211_HT_MPDU_DENSITY_0_5 = 2,	/* 1/2 usec */
+	IEEE80211_HT_MPDU_DENSITY_1 = 3,	/* 1 usec */
+	IEEE80211_HT_MPDU_DENSITY_2 = 4,	/* 2 usec */
+	IEEE80211_HT_MPDU_DENSITY_4 = 5,	/* 4 usec */
+	IEEE80211_HT_MPDU_DENSITY_8 = 6,	/* 8 usec */
+	IEEE80211_HT_MPDU_DENSITY_16 = 7	/* 16 usec */
+};
+
 /**
  * struct ieee80211_ht_info - HT information
  *
-- 
1.6.3.3

