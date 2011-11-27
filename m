Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6095 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab1K0N3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 08:29:48 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: stable@kernel.org, Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] mac80211: fix race between the AGG SM and the Tx data path
Date: Sun, 27 Nov 2011 15:29:44 +0200
Message-Id: <1322400584-10964-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20111127_142959_845534_A4ABDBBA)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a packet is supposed to sent be as an a-MPDU, mac80211 sets
IEEE80211_TX_CTL_AMPDU to let the driver know. On the other
hand, mac80211 configures the driver for aggregration with the
ampdu_action callback.
There is race between these two mechanisms since the following
scenario can occur when the BA agreement is torn down:

Tx softIRQ	 			drv configuration
==========				=================

check OPERATIONAL bit
Set the TX_CTL_AMPDU bit in the packet

					clear OPERATIONAL bit
					stop Tx AGG
Pass Tx packet to the driver.

In that case the driver would get a packet with TX_CTL_AMPDU set
although it has already been notified that the BA session has been
torn down.

To fix this, we need to synchronize all the Qdisc activity after we
cleared the OPERATIONAL bit. After that step, all the following
packets will be buffered until the driver reports it is ready to get
new packets for this RA / TID. This buffering allows not to run into
another race that would send packets with TX_CTL_AMPDU unset while
the driver hasn't been requested to tear down the BA session yet.

This race occurs in practice and iwlwifi complains with a WARN_ON
when it happens.

Cc: stable@kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: Update the comment in the code - Thanks Johannes
---
 net/mac80211/agg-tx.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..e8813bd 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -188,6 +188,20 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 */
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
+	/*
+	 * There might be a few packets being processed right now (on
+	 * another CPU) that have already gotten past the aggregation
+	 * check when it was still OPERATIONAL and consequently have
+	 * IEEE80211_TX_CTL_AMPDU set. In that case, this code might
+	 * call into the driver at the same time or even before the
+	 * TX paths calls into it, which could confuse the driver.
+	 *
+	 * Wait for all currently running TX paths to finish before
+	 * telling the driver. New packets will not go through since
+	 * the aggregation session is no longer OPERATIONAL.
+	 */
+	synchronize_net();
+
 	tid_tx->stop_initiator = initiator;
 	tid_tx->tx_stop = tx;
 
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

