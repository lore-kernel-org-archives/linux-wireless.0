Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbZHGO2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 10:28:13 -0400
Subject: [PATCH] mac80211: document TX powersave filter requirements
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:28:09 +0200
Message-Id: <1249655289.7194.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This documents what's required to implement that TX powersave
filter properly wrt. handling hardware queues.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-08-07 16:24:58.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-08-07 16:26:46.000000000 +0200
@@ -239,7 +239,14 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
  * @IEEE80211_TX_CTL_INJECTED: Frame was injected, internal to mac80211.
  * @IEEE80211_TX_STAT_TX_FILTERED: The frame was not transmitted
- *	because the destination STA was in powersave mode.
+ *	because the destination STA was in powersave mode. Note that to
+ *	avoid race conditions, the filter must be set by the hardware or
+ *	firmware upon receiving a frame that indicates that the station
+ *	went to sleep (must be done on device to filter frames already on
+ *	the queue) and may only be unset after mac80211 gives the OK for
+ *	that by setting the IEEE80211_TX_CTL_CLEAR_PS_FILT (see above),
+ *	since only then is it guaranteed that no more frames are in the
+ *	hardware queue.
  * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
  * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
  * 	is for the whole aggregation.


