Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1ARMwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:52:25 -0500
Subject: [PATCH] mac80211: allow advertising correct maximum aggregate size
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:52:23 +0100
Message-ID: <1295355143.3563.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, mac80211 always advertises that it may send
up to 64 subframes in an aggregate. This is fine, since
it's the max, but might as well be set to zero instead
since it doesn't have any information.

However, drivers might have that information, so allow
them to set a variable giving it, which will then be
used. The default of zero will be fine since to the
peer that means we don't know and it will just use its
own limit for the buffer size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This will apply only after Luca's patch
"mac80211: add hw configuration for max ampdu buffer size"

 include/net/mac80211.h |    5 +++++
 net/mac80211/agg-tx.c  |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-01-18 13:49:49.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-01-18 13:50:20.000000000 +0100
@@ -1154,6 +1154,10 @@ enum ieee80211_hw_flags {
  *	This is only relevant if the device has restrictions on the
  *	number of subframes, if it relies on mac80211 to do reordering
  *	it shouldn't be set.
+ *
+ * @max_tx_aggregation_subframes: maximum number of subframes in an
+ *	aggregate an HT driver will transmit, used by the peer as a
+ *	hint to size its reorder buffer.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1173,6 +1177,7 @@ struct ieee80211_hw {
 	u8 max_report_rates;
 	u8 max_rate_tries;
 	u8 max_rx_aggregation_subframes;
+	u8 max_tx_aggregation_subframes;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/agg-tx.c	2011-01-18 13:49:49.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2011-01-18 13:50:20.000000000 +0100
@@ -342,7 +342,8 @@ void ieee80211_tx_ba_session_handle_star
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, start_seq_num,
-				     0x40, tid_tx->timeout);
+				     local->hw.max_tx_aggregation_subframes,
+				     tid_tx->timeout);
 }
 
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,


