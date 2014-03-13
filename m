Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaCMMd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 08:33:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Subject: [PATCH] mac80211: add status_driver_data array to ieee80211_tx_info
Date: Thu, 13 Mar 2014 14:30:47 +0200
Message-Id: <1394713847-12397-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140313_133331_626830_8D2C0B5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Drivers might want to have private data in addition
to all other ieee80211_tx_info.status fields.

The current ieee80211_tx_info.rate_driver_data overlaps
with some of the non-rate data (e.g. ampdu_ack_len), so
it might not be good enough.

Since we already know how much free bytes remained,
simply use this size to define (void *) array.

While on it, change ack_signal type from int to the more
explicit s32 type.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 include/net/mac80211.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2890188..1090855 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -697,11 +697,12 @@ struct ieee80211_tx_info {
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
-			int ack_signal;
+			s32 ack_signal;
 			u8 ampdu_ack_len;
 			u8 ampdu_len;
 			u8 antenna;
 			/* 21 bytes free */
+			void *status_driver_data[21 / sizeof(void *)];
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
-- 
1.8.3.2

