Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34550 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1BGEkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 23:40:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 20:39:51 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] mac80211: Update comments on radiotap MCS index
Date: Mon, 7 Feb 2011 10:10:04 +0530
Message-ID: <1297053604-2770-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

mac80211 now supports passing MCS index to radiotap, so update the
comments regarding this

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 net/mac80211/rx.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b5f59ed..701406c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -142,11 +142,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* IEEE80211_RADIOTAP_RATE */
 	if (status->flag & RX_FLAG_HT) {
 		/*
-		 * TODO: add following information into radiotap header once
-		 * suitable fields are defined for it:
-		 * - MCS index (status->rate_idx)
-		 * - HT40 (status->flag & RX_FLAG_40MHZ)
-		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
+		 * MCS information is a separate field in radiotap,
+		 * added below.
 		 */
 		*pos = 0;
 	} else {
-- 
1.7.0.4

