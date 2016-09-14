Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47995 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbcINHSt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 03:18:49 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2] mac80211: allow driver to handle packet-loss mechanism
Date: Wed, 14 Sep 2016 12:48:32 +0530
Message-ID: <20160914071832.11465-1-rmanohar@qti.qualcomm.com> (sfid-20160914_091910_937474_3B4D6153)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on consecutive msdu failures, mac80211 triggers CQM packet-loss
mechanism. Drivers like ath10k that have its own connection monitoring
algorithm, offloaded to firmware for triggering station kickout. In case
of station kickout, driver will report low ack status by mac80211 API
(ieee80211_report_low_ack).

This flag will enable the driver to completely rely on firmware events
for station kickout and bypass mac80211 packet loss mechanism.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: updated comments and commit log

 include/net/mac80211.h | 6 ++++++
 net/mac80211/debugfs.c | 1 +
 net/mac80211/status.c  | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 08bac23c8de1..d1351aaccda0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2018,6 +2018,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TX_FRAG_LIST: Hardware (or driver) supports sending frag_list
  *	skbs, needed for zero-copy software A-MSDU.
  *
+ * @IEEE80211_HW_REPORTS_LOW_ACK: The driver (or firmware) reports low ack event
+ *	by ieee80211_report_low_ack() based on its own algorithm. For such
+ *	drivers, mac80211 packet loss mechanism will not be triggered and driver
+ *	is completely depending on firmware event for station kickout.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2058,6 +2063,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_USES_RSS,
 	IEEE80211_HW_TX_AMSDU,
 	IEEE80211_HW_TX_FRAG_LIST,
+	IEEE80211_HW_REPORTS_LOW_ACK,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5bbb470f335f..8ca62b6bb02a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -201,6 +201,7 @@ static const char *hw_flag_names[] = {
 	FLAG(USES_RSS),
 	FLAG(TX_AMSDU),
 	FLAG(TX_FRAG_LIST),
+	FLAG(REPORTS_LOW_ACK),
 #undef FLAG
 };
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index fabd9ff710d9..ea39f8a7baf3 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -557,6 +557,12 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 static void ieee80211_lost_packet(struct sta_info *sta,
 				  struct ieee80211_tx_info *info)
 {
+	/* If driver relies on its own algorithm for station kickout, skip
+	 * mac80211 packet loss mechanism.
+	 */
+	if (ieee80211_hw_check(&sta->local->hw, REPORTS_LOW_ACK))
+		return;
+
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
-- 
2.9.3
