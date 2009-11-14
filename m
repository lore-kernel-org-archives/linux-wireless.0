Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47382 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZKNQGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 11:06:01 -0500
Message-ID: <4AFED564.8030804@openwrt.org>
Date: Sat, 14 Nov 2009 17:05:56 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] mac80211: add private driver flags and ampdu length to
 tx info
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers may want to store a few flags of their own in the tx
info. Also it is useful for 11n rate control to know the total number
of aggregated frames in an AMPDU, not just the ones that were acked.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -386,14 +386,17 @@ struct ieee80211_tx_rate {
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
  * @antenna_sel_tx: antenna to use, 0 for automatic diversity
+ * @driver_flags: flags for internal driver use
  * @pad: padding, ignore
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
- * @ampdu_ack_len: number of aggregated frames.
- * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ampdu_ack_len: number of acked aggregated frames.
+ * 	relevant only if ieee80211_tx_status_ampdu was set.
  * @ampdu_ack_map: block ack bit map for the aggregation.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ampdu_len: number of aggregated frames.
+ * 	relevant only if ieee80211_tx_status_ampdu was set.
  * @ack_signal: signal strength of the ACK frame
  */
 struct ieee80211_tx_info {
@@ -403,8 +406,8 @@ struct ieee80211_tx_info {

 	u8 antenna_sel_tx;

-	/* 2 byte hole */
-	u8 pad[2];
+	u8 driver_flags;
+	u8 pad;

 	union {
 		struct {
@@ -428,7 +431,8 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			u64 ampdu_ack_map;
 			int ack_signal;
-			/* 8 bytes free */
+			u8 ampdu_len;
+			/* 7 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[

