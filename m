Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2EJHKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 03:10:17 -0400
Message-Id: <20120510070930.804638281@sipsolutions.net> (sfid-20120510_091027_078626_244A1FE5)
Date: Thu, 10 May 2012 09:09:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: (selectively) add HT details in radiotap
References: <20120510070909.253886400@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add a flag for the HT format (mixed vs. greenfield)
to allow drivers to report that on receive. Not all
drivers will do that though, so allow drivers to set
which radiotap MCS details they report.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/main.c    |    3 +++
 net/mac80211/rx.c      |    6 +++---
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/net/mac80211/rx.c	2012-05-10 08:54:21.000000000 +0200
+++ b/net/mac80211/rx.c	2012-05-10 08:58:09.000000000 +0200
@@ -204,14 +204,14 @@ ieee80211_add_rx_radiotap_header(struct
 
 	if (status->flag & RX_FLAG_HT) {
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
-		*pos++ = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
-			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
-			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+		*pos++ = local->hw.radiotap_mcs_details;
 		*pos = 0;
 		if (status->flag & RX_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
 		if (status->flag & RX_FLAG_40MHZ)
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
+		if (status->flag & RX_FLAG_HT_GF)
+			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
 		pos++;
 		*pos++ = status->rate_idx;
 	}
--- a/include/net/mac80211.h	2012-05-10 08:54:21.000000000 +0200
+++ b/include/net/mac80211.h	2012-05-10 09:00:41.000000000 +0200
@@ -667,6 +667,9 @@ ieee80211_tx_info_clear_status(struct ie
  * @RX_FLAG_SHORT_GI: Short guard interval was used
  * @RX_FLAG_NO_SIGNAL_VAL: The signal strength value is not present.
  *	Valid only for data frames (mainly A-MPDU)
+ * @RX_FLAG_HT_GF: This frame was received in a HT-greenfield transmission, if
+ *	the driver fills this value it should add %IEEE80211_RADIOTAP_MCS_HAVE_FMT
+ *	to hw.radiotap_mcs_details to advertise that fact
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -681,6 +684,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
 	RX_FLAG_NO_SIGNAL_VAL	= 1<<12,
+	RX_FLAG_HT_GF		= 1<<13,
 };
 
 /**
@@ -1288,6 +1292,11 @@ enum ieee80211_hw_flags {
  *
  * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
  *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
+ *
+ * @radiotap_mcs_details: lists which MCS information can the HW
+ *	reports, by default it is set to _MCS, _GI and _BW but doesn't
+ *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_* values, only
+ *	adding _BW is supported today.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1309,6 +1318,7 @@ struct ieee80211_hw {
 	u8 max_rx_aggregation_subframes;
 	u8 max_tx_aggregation_subframes;
 	u8 offchannel_tx_hw_queue;
+	u8 radiotap_mcs_details;
 };
 
 /**
--- a/net/mac80211/main.c	2012-05-10 08:53:23.000000000 +0200
+++ b/net/mac80211/main.c	2012-05-10 08:58:42.000000000 +0200
@@ -597,6 +597,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.offchannel_tx_hw_queue = IEEE80211_INVAL_HW_QUEUE;
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
+	local->hw.radiotap_mcs_details = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+					 IEEE80211_RADIOTAP_MCS_HAVE_GI |
+					 IEEE80211_RADIOTAP_MCS_HAVE_BW;
 	local->user_power_level = -1;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 


