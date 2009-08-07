Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563AbZHGOmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 10:42:20 -0400
Subject: [PATCH] mac80211: allow DMA optimisation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:42:15 +0200
Message-Id: <1249656135.7194.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have a lot of frames to transmit at once, for
instance with fragmentation, it can be an optimisation
to only tell the DMA engine about them on the last
fragment/frame to avoid banging the IO too much. This
patch allows implementation such an optimisation by
telling the driver when more frames can be expected.

Currently, this is used by mac80211 only on fragmented
frames, but could also be used in the future on other
frames when the queue was full and there are multiple
frames pending.

Note that drivers need to be careful when using this
flag, they need to kick their DMA engines not just
when this flag is clear, but also when the queue gets
full so that progress can be made.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/tx.c      |    3 +++
 2 files changed, 8 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2009-08-07 16:36:27.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-08-07 16:38:37.000000000 +0200
@@ -268,6 +268,10 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_PSPOLL_RESPONSE: (internal?)
  *	This frame is a response to a PS-poll frame and should be sent
  *	although the station is in powersave mode.
+ * @IEEE80211_TX_CTL_MORE_FRAMES: More frames will be passed to the
+ *	transmit function after the current frame, this can be used
+ *	by drivers to kick the DMA queue only if unset or when the
+ *	queue gets full.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -288,6 +292,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
 	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
+	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/tx.c	2009-08-07 16:38:44.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-08-07 16:38:51.000000000 +0200
@@ -1154,6 +1154,9 @@ static int __ieee80211_tx(struct ieee802
 		next = skb->next;
 		len = skb->len;
 
+		if (next)
+			info->flags |= IEEE80211_TX_CTL_MORE_FRAMES;
+
 		sdata = vif_to_sdata(info->control.vif);
 
 		switch (sdata->vif.type) {


