Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515AbZHGOXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 10:23:47 -0400
Subject: [PATCH] mac80211: explain TX retry and status
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: nbd <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:23:43 +0200
Message-Id: <1249655023.7194.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some more documentation including an example so that
it's clearer what should be done for TX retries.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2009-08-07 16:18:15.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-08-07 16:22:21.000000000 +0200
@@ -338,6 +338,21 @@ enum mac80211_rate_control_flags {
  *
  * When used for transmit status reporting, the driver should
  * always report the rate along with the flags it used.
+ *
+ * &struct ieee80211_tx_info contains an array of these structs
+ * in the control information, and it will be filled by the rate
+ * control algorithm according to what should be sent. For example,
+ * if this array contains, in the format { <idx>, <count> } the
+ * information
+ *    { 3, 2 }, { 2, 2 }, { 1, 4 }, { -1, 0 }, { -1, 0 }
+ * then this means that the frame should be transmitted
+ * up to twice at rate 3, up to twice at rate 2, and up to four
+ * times at rate 1 if it doesn't get acknowledged. Say it gets
+ * acknowledged by the peer after the fifth attempt, the status
+ * information should then contain
+ *   { 3, 2 }, { 2, 2 }, { 1, 1 }, { -1, 0 } ...
+ * since it was transmitted twice at rate 3, twice at rate 2
+ * and once at rate 1 after which we received an acknowledgement.
  */
 struct ieee80211_tx_rate {
 	s8 idx;


