Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:41114 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbcBXP0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 10:26:37 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 2/2] mac80211: fix parsing of 40Mhz in injected radiotap header
Date: Wed, 24 Feb 2016 16:25:49 +0100
Message-Id: <1456327549-31765-2-git-send-email-sven@narfation.org> (sfid-20160224_162641_155345_22D27D33)
In-Reply-To: <1456327549-31765-1-git-send-email-sven@narfation.org>
References: <1456327549-31765-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MCS bandwidth part of the radiotap header is 2 bits wide. The full 2
bit have to compared against IEEE80211_RADIOTAP_MCS_BW_40 and not only if
the first bit is set. Otherwise IEEE80211_RADIOTAP_MCS_BW_40 can be
confused with IEEE80211_RADIOTAP_MCS_BW_20U.

Fixes: 5ec3aed9ba4c ("mac80211: Parse legacy and HT rate in injected frames")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/mac80211/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a7475f..60c26a5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1691,7 +1691,7 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 	bool rate_found = false;
 	u8 rate_retries = 0;
 	u16 rate_flags = 0;
-	u8 mcs_known, mcs_flags;
+	u8 mcs_known, mcs_flags, mcs_bw;
 	int i;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
@@ -1767,8 +1767,9 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 			    mcs_flags & IEEE80211_RADIOTAP_MCS_SGI)
 				rate_flags |= IEEE80211_TX_RC_SHORT_GI;
 
+			mcs_bw = mcs_flags & IEEE80211_RADIOTAP_MCS_BW_MASK;
 			if (mcs_known & IEEE80211_RADIOTAP_MCS_HAVE_BW &&
-			    mcs_flags & IEEE80211_RADIOTAP_MCS_BW_40)
+			    mcs_bw == IEEE80211_RADIOTAP_MCS_BW_40)
 				rate_flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 			break;
 
-- 
2.7.0

