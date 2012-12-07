Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:33583 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755962Ab2LGKmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:42:00 -0500
Message-ID: <50C1C7F5.6010808@posedge.com> (sfid-20121207_114205_064989_33269E22)
Date: Fri, 07 Dec 2012 16:11:57 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Checking for zero Len subframe's only when driver
 supports the reporting of zero len subframes.
References: <201212071036.qB7Aas8o001865@chaitanya-desktop>
In-Reply-To: <201212071036.qB7Aas8o001865@chaitanya-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Zero Len subframe makes sense only when driver supports the reporting
of zero len subframes.(to handle buggy drivers)

Signed-off-by: T Krushna Chaitanya <chaitanyatk@posedge.com>
--- 
 net/mac80211/rx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index db343fa..654c22f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -281,10 +281,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_AMPDU_STATUS);
 		put_unaligned_le32(status->ampdu_reference, pos);
 		pos += 4;
-		if (status->flag & RX_FLAG_AMPDU_REPORT_ZEROLEN)
+		if (status->flag & RX_FLAG_AMPDU_REPORT_ZEROLEN) {
 			flags |= IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN;
-		if (status->flag & RX_FLAG_AMPDU_IS_ZEROLEN)
-			flags |= IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN;
+			if (status->flag & RX_FLAG_AMPDU_IS_ZEROLEN)
+				flags |= IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN;
+		}
 		if (status->flag & RX_FLAG_AMPDU_LAST_KNOWN)
 			flags |= IEEE80211_RADIOTAP_AMPDU_LAST_KNOWN;
 		if (status->flag & RX_FLAG_AMPDU_IS_LAST)




