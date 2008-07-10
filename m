Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbYGJILu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 04:11:50 -0400
Subject: [PATCH] mac80211: fix RX sequence number check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 10:11:02 +0200
Message-Id: <1215677463.3932.4.camel@johannes.berg> (sfid-20080710_101208_283131_8E357CEF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2007, we are doing the wrong thing in the
sequence number checks when receiving frames. This fixes it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-07-10 10:05:57.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-07-10 10:08:07.000000000 +0200
@@ -334,13 +334,18 @@ static void ieee80211_parse_qos(struct i
 		else
 			rx->flags &= ~IEEE80211_RX_AMSDU;
 	} else {
-		if (unlikely(ieee80211_is_mgmt(hdr->frame_control))) {
-			/* Separate TID for management frames */
-			tid = NUM_RX_DATA_QUEUES - 1;
-		} else {
-			/* no qos control present */
-			tid = 0; /* 802.1d - Best Effort */
-		}
+		/*
+		 * IEEE 802.11-2007, 7.1.3.4.1 ("Sequence Number field"):
+		 *
+		 *	Sequence numbers for management frames, QoS data
+		 *	frames with a broadcast/multicast address in the
+		 *	Address 1 field, and all non-QoS data frames sent
+		 *	by QoS STAs are assigned using an additional single
+		 *	modulo-4096 counter, [...]
+		 *
+		 * We also use that counter for non-QoS STAs.
+		 */
+		tid = NUM_RX_DATA_QUEUES - 1;
 	}
 
 	rx->queue = tid;


