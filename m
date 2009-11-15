Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41972 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZKOWH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 17:07:26 -0500
Message-ID: <4B007BA2.5020209@openwrt.org>
Date: Sun, 15 Nov 2009 23:07:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 1/2] mac80211: add the total ampdu length to tx info
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -390,10 +390,12 @@ struct ieee80211_tx_rate {
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
- * @ampdu_ack_len: number of aggregated frames.
+ * @ampdu_ack_len: number of acked aggregated frames.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
  * @ampdu_ack_map: block ack bit map for the aggregation.
  * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ampdu_len: number of aggregated frames.
+ * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
  * @ack_signal: signal strength of the ACK frame
  */
 struct ieee80211_tx_info {
@@ -428,7 +430,8 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			u64 ampdu_ack_map;
 			int ack_signal;
-			/* 8 bytes free */
+			u8 ampdu_len;
+			/* 7 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
