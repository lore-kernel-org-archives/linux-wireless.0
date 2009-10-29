Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbZJ2LTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 07:19:47 -0400
Subject: [PATCH] mac80211: unconditionally set
 IEEE80211_TX_CTL_SEND_AFTER_DTIM
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 12:19:21 +0100
Message-ID: <1256815161.3865.106.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 is asked to buffer multicast frames
in AP mode, it will not set the flag indicating
that the frames should be sent after the DTIM
beacon for those frames buffered in software. Fix
this little inconsistency by always setting that
flag in the buffering code path.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Drivers still need to know since they usually have to put such frames
onto a separate queue...

 net/mac80211/tx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-10-29 12:15:05.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-10-29 12:18:04.000000000 +0100
@@ -317,12 +317,11 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	if (!atomic_read(&tx->sdata->bss->num_sta_ps))
 		return TX_CONTINUE;
 
-	/* buffered in hardware */
-	if (!(tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)) {
-		info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
+	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 
+	/* device releases frame after DTIM beacon */
+	if (!(tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING))
 		return TX_CONTINUE;
-	}
 
 	/* buffered in mac80211 */
 	if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)


