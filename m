Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbbAVVaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 16:30:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: synchronize_net() before flushing the queues
Date: Thu, 22 Jan 2015 23:30:19 +0200
Message-Id: <1421962219-6840-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_223058_210779_E754A085)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 disconnects, it drops all the packets on the
queues. This happens after the net stack has been notified
that we have no link anymore (netif_carrier_off).
netif_carrier_off ensures that no new packets are sent to
xmit() callback, but we might have older packets in the
middle of the Tx path. These packets will land in the
driver's queues after the latter have been flushed.
Synchronize_net() between netif_carrier_off and drv_flush()
will fix this.

Note that we can't call synchronize_net inside
ieee80211_flush_queues since there are flows that call
ieee80211_flush_queues and don't need synchronize_net()
which is an expensive operation.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1d6bf01..1eafa63 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2016,6 +2016,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	/* disable per-vif ps */
 	ieee80211_recalc_ps_vif(sdata);
 
+	/* flush out all packets */
+	synchronize_net();
+
 	/*
 	 * drop any frame before deauth/disassoc, this can be data or
 	 * management frame. Since we are disconnecting, we should not
-- 
1.9.1

