Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:61778 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbaGQOO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:26 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3157728wes.15
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:25 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Liad Kaufman <liad.kaufman@intel.com>
Subject: [PATCH 15/15] mac80211: make sure TDLS teardown packet is sent on time
Date: Thu, 17 Jul 2014 17:14:31 +0300
Message-Id: <1405606471-30128-16-git-send-email-arik@wizery.com> (sfid-20140717_161518_726859_89FDF230)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Since the teardown packet is created while the queues are
stopped, it isn't sent immediately, but rather is pending.
To be sure that when we flush the queues prior to destroying
the station we also send this packet - the tasklet handling
pending packets is invoked to flush the packets.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: ArikX Nemtsov <arik@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 50d0e06..1b21050 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -836,6 +836,17 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		ret = 0;
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
+		/*
+		 * The teardown message in ieee80211_tdls_mgmt_teardown() was
+		 * created while the queues were stopped, so it might still be
+		 * pending. Before flushing the queues we need to be sure the
+		 * message is handled by the tasklet handling pending messages,
+		 * otherwise we might start destroying the station before
+		 * sending the teardown packet.
+		 * Note that this only forces the tasklet to flush pendings -
+		 * not to stop the tasklet from rescheduling itself.
+		 */
+		tasklet_kill(&local->tx_pending_tasklet);
 		/* flush a potentially queued teardown packet */
 		ieee80211_flush_queues(local, sdata);
 
-- 
1.9.1

