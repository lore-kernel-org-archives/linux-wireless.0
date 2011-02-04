Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61906 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1BDPgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 10:36:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 07:36:05 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] mac80211: Fix parsing of MCS rates to radiotap
Date: Fri, 4 Feb 2011 21:06:18 +0530
Message-ID: <1296833778-2912-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Previously the MCS rate elements were parsed at the wrong position

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/rx.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c08b8e9..27b4b1f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -141,14 +141,16 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 	/* IEEE80211_RADIOTAP_RATE */
 	if (status->flag & RX_FLAG_HT) {
-		/*
-		 * TODO: add following information into radiotap header once
-		 * suitable fields are defined for it:
-		 * - MCS index (status->rate_idx)
-		 * - HT40 (status->flag & RX_FLAG_40MHZ)
-		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
-		 */
-		*pos = 0;
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		*pos++ = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
+			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+		if (status->flag & RX_FLAG_SHORT_GI)
+			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
+		if (status->flag & RX_FLAG_40MHZ)
+			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
+		pos++;
+		*pos++ = status->rate_idx;
 	} else {
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
 		*pos = rate->bitrate / 5;
@@ -197,19 +199,6 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	put_unaligned_le16(rx_flags, pos);
 	pos += 2;
 
-	if (status->flag & RX_FLAG_HT) {
-		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
-		*pos++ = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
-			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
-			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
-		*pos = 0;
-		if (status->flag & RX_FLAG_SHORT_GI)
-			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
-		if (status->flag & RX_FLAG_40MHZ)
-			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
-		pos++;
-		*pos++ = status->rate_idx;
-	}
 }
 
 /*
-- 
1.7.0.4

