Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760017AbXKTGzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 01:55:54 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
Date: Tue, 20 Nov 2007 14:55:36 +0800
Message-Id: <11955417361539-git-send-email-yi.zhu@intel.com> (sfid-20071120_065605_683601_F072F737)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if this is best choice, someone might have better
solutions. But this patch fixed the connection problem when switching
from a WPA enabled AP (using wpa_supplicant) to an open AP (using
iwconfig). The root cause is when we connect to a WPA enabled AP,
wpa_supplicant sets the ifsta->extra_ie thru SIOCSIWGENIE. But if we
stop wpa_supplicant and connect to an open AP with iwconfig, there is
no way to clear the extra_ie so that mac80211 keeps connecting with that.

Someone could argue wpa_supplicant should clear the extra_ie during
its shutdown. But mac80211 should also handle the unexpected shutdown
case (ie. killall -9 wpa_supplicant).

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/ieee80211.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e0ee65a..7cf2f14 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -334,6 +334,10 @@ static int ieee80211_stop(struct net_device *dev)
 			cancel_delayed_work(&local->scan_work);
 		}
 		flush_workqueue(local->hw.workqueue);
+
+		kfree(sdata->u.sta.extra_ie);
+		sdata->u.sta.extra_ie = NULL;
+		sdata->u.sta.extra_ie_len = 0;
 		/* fall through */
 	default:
 		conf.if_id = dev->ifindex;
-- 
1.5.2
