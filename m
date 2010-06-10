Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab0FJI00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:26 -0400
Message-Id: <20100610082232.848905959@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 22/23] mac80211: update aggregation documentation
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even before the recent changes, the documentation
for TX aggregation was somewhat out of date. Update
it and also add documentation for the RX side.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c |   23 +++++++++++++++++++++++
 net/mac80211/agg-tx.c |   43 +++++++++++++++++++++++++++----------------
 2 files changed, 50 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-09 17:21:17.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-09 17:21:18.000000000 +0200
@@ -21,28 +21,39 @@
 #include "wme.h"
 
 /**
- * DOC: TX aggregation
+ * DOC: TX A-MPDU aggregation
  *
  * Aggregation on the TX side requires setting the hardware flag
- * %IEEE80211_HW_AMPDU_AGGREGATION as well as, if present, the @ampdu_queues
- * hardware parameter to the number of hardware AMPDU queues. If there are no
- * hardware queues then the driver will (currently) have to do all frame
- * buffering.
+ * %IEEE80211_HW_AMPDU_AGGREGATION. The driver will then be handed
+ * packets with a flag indicating A-MPDU aggregation. The driver
+ * or device is responsible for actually aggregating the frames,
+ * as well as deciding how many and which to aggregate.
  *
- * When TX aggregation is started by some subsystem (usually the rate control
- * algorithm would be appropriate) by calling the
- * ieee80211_start_tx_ba_session() function, the driver will be notified via
- * its @ampdu_action function, with the %IEEE80211_AMPDU_TX_START action.
+ * When TX aggregation is started by some subsystem (usually the rate
+ * control algorithm would be appropriate) by calling the
+ * ieee80211_start_tx_ba_session() function, the driver will be
+ * notified via its @ampdu_action function, with the
+ * %IEEE80211_AMPDU_TX_START action.
  *
  * In response to that, the driver is later required to call the
- * ieee80211_start_tx_ba_cb() (or ieee80211_start_tx_ba_cb_irqsafe())
- * function, which will start the aggregation session.
+ * ieee80211_start_tx_ba_cb_irqsafe() function, which will really
+ * start the aggregation session after the peer has also responded.
+ * If the peer responds negatively, the session will be stopped
+ * again right away. Note that it is possible for the aggregation
+ * session to be stopped before the driver has indicated that it
+ * is done setting it up, in which case it must not indicate the
+ * setup completion.
  *
- * Similarly, when the aggregation session is stopped by
- * ieee80211_stop_tx_ba_session(), the driver's @ampdu_action function will
- * be called with the action %IEEE80211_AMPDU_TX_STOP. In this case, the
- * call must not fail, and the driver must later call ieee80211_stop_tx_ba_cb()
- * (or ieee80211_stop_tx_ba_cb_irqsafe()).
+ * Also note that, since we also need to wait for a response from
+ * the peer, the driver is notified of the completion of the
+ * handshake by the %IEEE80211_AMPDU_TX_OPERATIONAL action to the
+ * @ampdu_action callback.
+ *
+ * Similarly, when the aggregation session is stopped by the peer
+ * or something calling ieee80211_stop_tx_ba_session(), the driver's
+ * @ampdu_action function will be called with the action
+ * %IEEE80211_AMPDU_TX_STOP. In this case, the call must not fail,
+ * and the driver must later call ieee80211_stop_tx_ba_cb_irqsafe().
  */
 
 static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-06-09 17:21:16.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-06-09 17:21:18.000000000 +0200
@@ -13,6 +13,29 @@
  * published by the Free Software Foundation.
  */
 
+/**
+ * DOC: RX A-MPDU aggregation
+ *
+ * Aggregation on the RX side requires only implementing the
+ * @ampdu_action callback that is invoked to start/stop any
+ * block-ack sessions for RX aggregation.
+ *
+ * When RX aggregation is started by the peer, the driver is
+ * notified via @ampdu_action function, with the
+ * %IEEE80211_AMPDU_RX_START action, and may reject the request
+ * in which case a negative response is sent to the peer, if it
+ * accepts it a positive response is sent.
+ *
+ * While the session is active, the device/driver are required
+ * to de-aggregate frames and pass them up one by one to mac80211,
+ * which will handle the reorder buffer.
+ *
+ * When the aggregation session is stopped again by the peer or
+ * ourselves, the driver's @ampdu_action function will be called
+ * with the action %IEEE80211_AMPDU_RX_STOP. In this case, the
+ * call must not fail.
+ */
+
 #include <linux/ieee80211.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>


