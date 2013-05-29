Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3E2JFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 05:05:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: always send multicast on CAB queue
Date: Wed, 29 May 2013 11:05:02 +0200
Message-Id: <1369818302-15580-1-git-send-email-johannes@sipsolutions.net> (sfid-20130529_110516_171071_5C88C853)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver advertised support for a CAB queue, then we
should put all multicast frames there, otherwise sending
them can be racy with clients going to sleep while we TX
a frame. To avoid this, always TX multicast frames on the
multicast queue.

It seems like even drivers not using the queue framework
might want to do this which would mean also moving the
IEEE80211_TX_CTL_SEND_AFTER_DTIM flag assignment, but it
also seems that drivers behave differently here so that
just moving it wouldn't be a good idea. It'd be better to
modify those drivers to use the queue framework.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9972e07..34be933 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -398,13 +398,14 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
+	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
+		info->hw_queue = tx->sdata->vif.cab_queue;
+
 	/* no stations in PS mode */
 	if (!atomic_read(&ps->num_sta_ps))
 		return TX_CONTINUE;
 
 	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
-	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
-		info->hw_queue = tx->sdata->vif.cab_queue;
 
 	/* device releases frame after DTIM beacon */
 	if (!(tx->local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING))
-- 
1.8.0

