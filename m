Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1ALMbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:31:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Pczr5-0001fC-2r
	for linux-wireless@vger.kernel.org; Wed, 12 Jan 2011 13:31:11 +0100
Message-Id: <20110112123132.021743908@sipsolutions.net>
Date: Wed, 12 Jan 2011 13:31:01 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: allow advertising correct maximum aggregate
 size
References: <20110112123100.615900267@sipsolutions.net>
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
 include/net/mac80211.h |    5 +++++
 net/mac80211/agg-tx.c  |    3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-01-12 13:25:40.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-01-12 13:26:56.000000000 +0100
@@ -1147,6 +1147,10 @@ enum ieee80211_hw_flags {
  * @napi_weight: weight used for NAPI polling.  You must specify an
  *	appropriate value here if a napi_poll operation is provided
  *	by your driver.
+ *
+ * @max_tx_aggregation_subframes: maximum number of subframes in an
+ *	aggregate an HT driver will transmit, used by the peer as a
+ *	hint to size its reorder buffer.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -1165,6 +1169,7 @@ struct ieee80211_hw {
 	u8 max_rates;
 	u8 max_report_rates;
 	u8 max_rate_tries;
+	u8 max_tx_aggregation_subframes;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/agg-tx.c	2011-01-12 13:27:01.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2011-01-12 13:27:20.000000000 +0100
@@ -342,7 +342,8 @@ void ieee80211_tx_ba_session_handle_star
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, start_seq_num,
-				     0x40, tid_tx->timeout);
+				     local->hw.max_tx_aggregation_subframes,
+				     tid_tx->timeout);
 }
 
 int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,


