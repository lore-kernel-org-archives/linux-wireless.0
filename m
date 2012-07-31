Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab2GaLfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:35:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] wireless: add radiotap A-MPDU status field
Date: Tue, 31 Jul 2012 13:35:39 +0200
Message-Id: <1343734541-14934-2-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133550_818901_82750D35)
In-Reply-To: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Define the A-MPDU status field in radiotap, also
update the radiotap parser for it and the MCS field
that was apparently missed last time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h |   11 +++++++++++
 net/wireless/radiotap.c          |    2 ++
 2 files changed, 13 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 7139254..b273c5b 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -183,6 +183,9 @@ struct ieee80211_radiotap_header {
  *     Contains a bitmap of known fields/flags, the flags, and
  *     the MCS index.
  *
+ * IEEE80211_RADIOTAP_AMPDU_STATUS	u32, u16, u8, u8	unitlesss
+ *
+ *	Contains the AMPDU information for the subframe.
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,
@@ -205,6 +208,7 @@ enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
 
 	IEEE80211_RADIOTAP_MCS = 19,
+	IEEE80211_RADIOTAP_AMPDU_STATUS = 20,
 
 	/* valid in every it_present bitmap, even vendor namespaces */
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
@@ -270,6 +274,13 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_FMT_GF		0x08
 #define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
 
+/* For IEEE80211_RADIOTAP_AMPDU_STATUS */
+#define IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN		0x0001
+#define IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN		0x0002
+#define IEEE80211_RADIOTAP_AMPDU_LAST_KNOWN		0x0004
+#define IEEE80211_RADIOTAP_AMPDU_IS_LAST		0x0008
+#define IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_ERR		0x0010
+#define IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_KNOWN	0x0020
 
 /* helpers */
 static inline int ieee80211_get_radiotap_len(unsigned char *data)
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index c4ad795..7d604c0 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -41,6 +41,8 @@ static const struct radiotap_align_size rtap_namespace_sizes[] = {
 	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
 	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
+	[IEEE80211_RADIOTAP_AMPDU_STATUS] = { .align = 4, .size = 8, },
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */
-- 
1.7.10.4

