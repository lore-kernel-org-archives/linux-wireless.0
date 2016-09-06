Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43452 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752345AbcIFG5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 02:57:36 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        "Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] mac80211: allow driver to handle packet-loss mechanism
Date: Tue, 6 Sep 2016 12:26:24 +0530
Message-ID: <20160906065624.4062-1-rmanohar@qti.qualcomm.com> (sfid-20160906_085742_213803_F3D7090E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 keeps track of missing acks and triggers CQM packet-loss
mechanism whenever consecutive msdu failure reaches threshold limit
(STA_LOST_PKT_THRESHOLD). Drivers like ath10k offlaoded rate countrol
and aggregation to firmware. Such drivers have its own connection
monitoring algorithm that is offloaded to firmware for triggering
station kickout due to excessive tries. In VHT mode, single PPDU can have
more than 50 msdus at higher rates. Under noisy environment, single ppdu
failure can cause station kickout by current mac80211 lost_packet mechanism
while firmware is trying to adapt its rate table. This is causing frequent
connect and disconnect iteration when station is roaming around.

In such scenario, driver (or firmware) is not given enough chance to
tune its rate control. So for devices that report low ack events, add a
hardware flag to rely on their mechnism.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 include/net/mac80211.h | 5 +++++
 net/mac80211/debugfs.c | 1 +
 net/mac80211/status.c  | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a585c3..6619fa1ccd01 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2014,6 +2014,10 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TX_FRAG_LIST: Hardware (or driver) supports sending frag_list
  *	skbs, needed for zero-copy software A-MSDU.
  *
+ * @IEEE80211_HW_REPORTS_LOW_ACK: The driver (or firmware) reports low ack event
+ *	based on its own algorithm. For such devices, mac80211 does not report
+ *	low ack event based on lost packets.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2054,6 +2058,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_USES_RSS,
 	IEEE80211_HW_TX_AMSDU,
 	IEEE80211_HW_TX_FRAG_LIST,
+	IEEE80211_HW_REPORTS_LOW_ACK,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2906c1004e1a..e433319a67f1 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -302,6 +302,7 @@ static const char *hw_flag_names[] = {
 	FLAG(USES_RSS),
 	FLAG(TX_AMSDU),
 	FLAG(TX_FRAG_LIST),
+	FLAG(REPORTS_LOW_ACK),
 #undef FLAG
 };
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index fabd9ff710d9..6121ed196630 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -557,6 +557,12 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 static void ieee80211_lost_packet(struct sta_info *sta,
 				  struct ieee80211_tx_info *info)
 {
+	/* Driver supports its own algorithm for triggering CQM packet-loss
+	 * mechanism.
+	 */
+	if (ieee80211_hw_check(&sta->local->hw, REPORTS_LOW_ACK))
+		return;
+
 	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
-- 
2.9.3
