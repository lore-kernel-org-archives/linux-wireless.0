Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55446 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab3CBSFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 13:05:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.9] mac80211: another fix for idle handling in monitor mode
Date: Sat,  2 Mar 2013 19:05:47 +0100
Message-Id: <1362247547-71096-1-git-send-email-nbd@openwrt.org> (sfid-20130302_190556_325828_C80D961E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting a monitor interface up or down, the idle state needs to be
recalculated, otherwise the hardware will just stay in its previous idle
state.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/iface.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 640afab..baaa860 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -541,6 +541,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 		ieee80211_adjust_monitor_flags(sdata, 1);
 		ieee80211_configure_filter(local);
+		mutex_lock(&local->mtx);
+		ieee80211_recalc_idle(local);
+		mutex_unlock(&local->mtx);
 
 		netif_carrier_on(dev);
 		break;
@@ -812,6 +815,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
 		ieee80211_configure_filter(local);
+		mutex_lock(&local->mtx);
+		ieee80211_recalc_idle(local);
+		mutex_unlock(&local->mtx);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
-- 
1.8.0.2

