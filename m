Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37212 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2CARAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 12:00:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: add an rx flag for ignoring a packet's signal strength
Date: Thu,  1 Mar 2012 18:00:07 +0100
Message-Id: <1330621207-95805-1-git-send-email-nbd@openwrt.org> (sfid-20120301_180026_908717_7921EF9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For A-MPDU rx it makes sense to only process the signal strength once per
aggregate instead of once per subframe. Additonally, some hardware (e.g.
Atheros) only provides valid signal strength information for the last
subframe.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h |    3 +++
 net/mac80211/rx.c      |    9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7477f02..c06974a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -659,6 +659,8 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
+ * @RX_FLAG_NO_SIGNAL_VAL: The signal strength value is not present.
+ *	Valid only for data frames (mainly A-MPDU)
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -672,6 +674,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
+	RX_FLAG_NO_SIGNAL_VAL	= 1<<12,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3cf011f..f3b515d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -177,7 +177,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM &&
+	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		*pos = status->signal;
 		rthdr->it_present |=
 			cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
@@ -1309,8 +1310,10 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
-	sta->last_signal = status->signal;
-	ewma_add(&sta->avg_signal, -status->signal);
+	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
+		sta->last_signal = status->signal;
+		ewma_add(&sta->avg_signal, -status->signal);
+	}
 
 	/*
 	 * Change STA power saving mode only at the end of a frame
-- 
1.7.3.2

