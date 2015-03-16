Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47848 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbbCPIIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 04:08:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add comment for rx_path_lock
Date: Mon, 16 Mar 2015 09:08:47 +0100
Message-Id: <1426493327-5331-1-git-send-email-johannes@sipsolutions.net> (sfid-20150316_090853_037664_8E49DE67)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a comment explaining how the RX path lock is used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bdabf349c6ee..6accd61ee54b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3123,6 +3123,12 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 			goto rxh_next;  \
 	} while (0);
 
+	/* Lock here to avoid hitting all of the data used in the RX
+	 * path (e.g. key data, station data, ...) concurrently when
+	 * a frame is released from the reorder buffer due to timeout
+	 * from the timer, potentially concurrently with RX from the
+	 * driver.
+	 */
 	spin_lock_bh(&rx->local->rx_path_lock);
 
 	while ((skb = __skb_dequeue(frames))) {
-- 
2.1.4

