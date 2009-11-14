Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57331 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbZKNAsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 19:48:00 -0500
Message-ID: <4AFDFE41.9000003@openwrt.org>
Date: Sat, 14 Nov 2009 01:48:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC 1/2] mac80211: add private driver flags and ampdu length to
 tx info
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers may want to store a few flags of their own in the tx 
info. Also it is useful for 11n rate control to know the total number
of aggregated frames in an AMPDU, not just the ones that were acked.
Use two previously unused padding bytes to store those two values

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -386,6 +386,7 @@ struct ieee80211_tx_rate {
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
  * @antenna_sel_tx: antenna to use, 0 for automatic diversity
+ * @driver_flags: flags for internal driver use
  * @pad: padding, ignore
  * @control: union for control data
  * @status: union for status data
@@ -404,7 +405,8 @@ struct ieee80211_tx_info {
 	u8 antenna_sel_tx;
 
 	/* 2 byte hole */
-	u8 pad[2];
+	u8 driver_flags;
+	u8 ampdu_len;
 
 	union {
 		struct {

