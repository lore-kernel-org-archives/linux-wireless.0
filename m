Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38613 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546AbaJ2PfL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:35:11 -0400
Message-ID: <1414596908.1827.7.camel@jlt4.sipsolutions.net> (sfid-20141029_163517_977764_98B927D4)
Subject: Re: [PATCH 3.18] mac80211: flush keys for AP mode on
 ieee80211_do_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:35:08 +0100
In-Reply-To: <1414407366-52891-1-git-send-email-nbd@openwrt.org>
References: <1414407366-52891-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 11:56 +0100, Felix Fietkau wrote:
> Userspace can add keys to an AP mode interface before start_ap has been
> called. If there have been no calls to start_ap/stop_ap in the mean
> time, the keys will still be around when the interface is brought down.

I applied the following modified version.

johannes

>From 10b68487869031828aede7313c2befc53d6d30ec Mon Sep 17 00:00:00 2001
From: Felix Fietkau <nbd@openwrt.org>
Date: Mon, 27 Oct 2014 11:56:06 +0100
Subject: [PATCH] mac80211: flush keys for AP mode on ieee80211_do_stop

Userspace can add keys to an AP mode interface before start_ap has been
called. If there have been no calls to start_ap/stop_ap in the mean
time, the keys will still be around when the interface is brought down.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
[adjust comments, fix AP_VLAN case]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index af237223a8cd..3b9e2b7b3f30 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -898,6 +898,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		list_del(&sdata->u.vlan.list);
 		mutex_unlock(&local->mtx);
 		RCU_INIT_POINTER(sdata->vif.chanctx_conf, NULL);
+		/* see comment in the default case below */
+		ieee80211_free_keys(sdata, true);
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
@@ -923,17 +925,16 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		/*
 		 * When we get here, the interface is marked down.
 		 * Free the remaining keys, if there are any
-		 * (shouldn't be, except maybe in WDS mode?)
+		 * (which can happen in AP mode if userspace sets
+		 * keys before the interface is operating, and maybe
+		 * also in WDS mode)
 		 *
 		 * Force the key freeing to always synchronize_net()
 		 * to wait for the RX path in case it is using this
-		 * interface enqueuing frames * at this very time on
+		 * interface enqueuing frames at this very time on
 		 * another CPU.
 		 */
 		ieee80211_free_keys(sdata, true);
-
-		/* fall through */
-	case NL80211_IFTYPE_AP:
 		skb_queue_purge(&sdata->skb_queue);
 	}
 
-- 
2.1.0



