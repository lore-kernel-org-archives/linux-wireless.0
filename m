Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab1K0IUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 03:20:03 -0500
From: emmanuel.grumbach@intel.com
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] mac80211: fix race between the AGG SM and the Tx data path
Date: Sun, 27 Nov 2011 10:19:59 +0200
Message-Id: <1322381999-27872-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20111127_092013_663934_B2C02739)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

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

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/agg-tx.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..d9b5340 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -188,6 +188,18 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	 */
 	clear_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state);
 
+	/*
+	 * There might be a few packets that have been scheduled
+	 * before the HT_AGG_STATE_OPERATIONAL has been cleared
+	 * and that may get to the driver only after the following
+	 * drv_ampdu_action gets called. In that case, the driver
+	 * would get a packet with the IEEE80211_TX_CTL_AMPDU flag
+	 * set while it has been already notified that the BA session
+	 * has been torn down. Sync the Qdisc to make sure this does
+	 * not happen.
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

