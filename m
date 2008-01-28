Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22822 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbYA1MHk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 07:07:40 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 07/12 v2] mac80211: A-MPDU Tx change tx_status to support Block Ack data
Date: Mon, 28 Jan 2008 14:07:21 +0200
Message-Id: <12015220543200-git-send-email-ron.rindjunsky@intel.com> (sfid-20080128_120748_662885_E68D99C1)
In-Reply-To: <12015220461052-git-send-email-ron.rindjunsky@intel.com>
References: <12015220461052-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds fields to ieee80211_tx_status in order to allow block ack
information exchange between low-level driver,mac80211 and rate scaling
module.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

Index: wl2_6_24_rc8_ev/include/net/mac80211.h
===================================================================
--- wl2_6_24_rc8_ev.orig/include/net/mac80211.h
+++ wl2_6_24_rc8_ev/include/net/mac80211.h
@@ -445,12 +445,14 @@ struct ieee80211_rx_status {
  *
  * @IEEE80211_TX_STATUS_TX_FILTERED: The frame was not transmitted
  *	because the destination STA was in powersave mode.
- *
  * @IEEE80211_TX_STATUS_ACK: Frame was acknowledged
+ * @IEEE80211_TX_STATUS_AMPDU: The frame was aggregated, so status
+ * 	is for the whole aggregation.
  */
 enum ieee80211_tx_status_flags {
 	IEEE80211_TX_STATUS_TX_FILTERED	= 1<<0,
 	IEEE80211_TX_STATUS_ACK		= 1<<1,
+	IEEE80211_TX_STATUS_AMPDU	= 1<<2,
 };
 
 /**
@@ -461,24 +463,25 @@ enum ieee80211_tx_status_flags {
  *
  * @control: a copy of the &struct ieee80211_tx_control passed to the driver
  *	in the tx() callback.
- *
  * @flags: transmit status flags, defined above
- *
- * @ack_signal: signal strength of the ACK frame
- *
+ * @retry_count: number of retries
  * @excessive_retries: set to 1 if the frame was retried many times
  *	but not acknowledged
- *
- * @retry_count: number of retries
- *
+ * @ampdu_ack_len: number of aggregated frames.
+ * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ampdu_ack_map: block ack bit map for the aggregation.
+ * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * @ack_signal: signal strength of the ACK frame
  * @queue_length: ?? REMOVE
  * @queue_number: ?? REMOVE
  */
 struct ieee80211_tx_status {
 	struct ieee80211_tx_control control;
 	u8 flags;
-	bool excessive_retries;
 	u8 retry_count;
+	bool excessive_retries;
+	u8 ampdu_ack_len;
+	u64 ampdu_ack_map;
 	int ack_signal;
 	int queue_length;
 	int queue_number;
