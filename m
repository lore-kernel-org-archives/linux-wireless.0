Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbXIFNqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:36 -0400
Message-Id: <20070905234627.703276000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 13/21] mac80211: print out wiphy name instead of master  device
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 print out the wiphy name instead of the
master device name where appropriate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c      |   14 +++++++-------
 net/mac80211/ieee80211_rate.c |    4 ++--
 net/mac80211/ieee80211_sta.c  |    2 +-
 net/mac80211/rx.c             |    3 ++-
 net/mac80211/sta_info.c       |    4 ++--
 net/mac80211/tx.c             |    9 +++++----
 6 files changed, 19 insertions(+), 17 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-06 01:35:14.624453431 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-06 01:35:21.724453431 +0200
@@ -847,7 +847,7 @@ static void ieee80211_tasklet_handler(un
 			break;
 		default: /* should never get here! */
 			printk(KERN_ERR "%s: Unknown message type (%d)\n",
-			       local->mdev->name, skb->pkt_type);
+			       wiphy_name(local->hw.wiphy), skb->pkt_type);
 			dev_kfree_skb(skb);
 			break;
 		}
@@ -937,7 +937,7 @@ void ieee80211_tx_status(struct ieee8021
 	if (!status) {
 		printk(KERN_ERR
 		       "%s: ieee80211_tx_status called with NULL status\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -994,7 +994,7 @@ void ieee80211_tx_status(struct ieee8021
 					printk(KERN_DEBUG "%s: dropped TX "
 					       "filtered frame queue_len=%d "
 					       "PS=%d @%lu\n",
-					       local->mdev->name,
+					       wiphy_name(local->hw.wiphy),
 					       skb_queue_len(
 						       &sta->tx_filtered),
 					       !!(sta->flags & WLAN_STA_PS),
@@ -1319,7 +1319,7 @@ int ieee80211_register_hw(struct ieee802
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize rate control "
-		       "algorithm\n", local->mdev->name);
+		       "algorithm\n", wiphy_name(local->hw.wiphy));
 		goto fail_rate;
 	}
 
@@ -1327,7 +1327,7 @@ int ieee80211_register_hw(struct ieee802
 
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize wep\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 		goto fail_wep;
 	}
 
@@ -1338,7 +1338,7 @@ int ieee80211_register_hw(struct ieee802
 				  IEEE80211_IF_TYPE_STA);
 	if (result)
 		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 
 	local->reg_state = IEEE80211_DEV_REGISTERED;
 	rtnl_unlock();
@@ -1438,7 +1438,7 @@ void ieee80211_unregister_hw(struct ieee
 	if (skb_queue_len(&local->skb_queue)
 			|| skb_queue_len(&local->skb_queue_unreliable))
 		printk(KERN_WARNING "%s: skb_queue not empty\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 
--- wireless-dev.orig/net/mac80211/ieee80211_rate.c	2007-09-06 01:34:55.504453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.c	2007-09-06 01:35:21.724453431 +0200
@@ -152,7 +152,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	ref = rate_control_alloc(name, local);
 	if (!ref) {
 		printk(KERN_WARNING "%s: Failed to select rate control "
-		       "algorithm\n", local->mdev->name);
+		       "algorithm\n", wiphy_name(local->hw.wiphy));
 		return -ENOENT;
 	}
 
@@ -164,7 +164,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	}
 
 	printk(KERN_DEBUG "%s: Selected rate control "
-	       "algorithm '%s'\n", local->mdev->name,
+	       "algorithm '%s'\n", wiphy_name(local->hw.wiphy),
 	       ref->ops->name);
 
 
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-09-06 01:35:12.404453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-09-06 01:35:21.734453431 +0200
@@ -4037,7 +4037,7 @@ struct sta_info * ieee80211_ibss_add_sta
 	}
 
 	printk(KERN_DEBUG "%s: Adding new IBSS station " MAC_FMT " (dev=%s)\n",
-	       local->mdev->name, MAC_ARG(addr), dev->name);
+	       wiphy_name(local->hw.wiphy), MAC_ARG(addr), dev->name);
 
 	sta = sta_info_add(local, dev, addr, GFP_ATOMIC);
 	if (!sta)
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-06 01:35:14.634453431 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-06 01:35:21.734453431 +0200
@@ -1619,7 +1619,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to copy "
 				       "multicast frame for %s",
-				       local->mdev->name, prev->dev->name);
+				       wiphy_name(local->hw.wiphy),
+				       prev->dev->name);
 			continue;
 		}
 		rx.skb = skb_new;
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-09-06 01:34:55.674453431 +0200
+++ wireless-dev/net/mac80211/sta_info.c	2007-09-06 01:35:21.734453431 +0200
@@ -191,7 +191,7 @@ struct sta_info * sta_info_add(struct ie
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Added STA " MAC_FMT "\n",
-	       local->mdev->name, MAC_ARG(addr));
+	       wiphy_name(local->hw.wiphy), MAC_ARG(addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -250,7 +250,7 @@ void sta_info_free(struct sta_info *sta)
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Removed STA " MAC_FMT "\n",
-	       local->mdev->name, MAC_ARG(sta->addr));
+	       wiphy_name(local->hw.wiphy), MAC_ARG(sta->addr));
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	ieee80211_key_free(sta->key);
--- wireless-dev.orig/net/mac80211/tx.c	2007-09-06 01:35:14.634453431 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-06 01:35:21.734453431 +0200
@@ -320,7 +320,7 @@ static void purge_old_ps_buffers(struct 
 
 	local->total_ps_buffered = total;
 	printk(KERN_DEBUG "%s: PS buffers full - purged %d frames\n",
-	       local->mdev->name, purged);
+	       wiphy_name(local->hw.wiphy), purged);
 }
 
 static inline ieee80211_txrx_result
@@ -1044,7 +1044,8 @@ static int __ieee80211_tx(struct ieee802
 		return IEEE80211_TX_AGAIN;
 	}
 	if (skb) {
-		ieee80211_dump_frame(local->mdev->name, "TX to low-level driver", skb);
+		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
+				     "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
@@ -1072,7 +1073,7 @@ static int __ieee80211_tx(struct ieee802
 						~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 			}
 
-			ieee80211_dump_frame(local->mdev->name,
+			ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 					     "TX to low-level driver",
 					     tx->u.tx.extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
@@ -1801,7 +1802,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		if (!rate) {
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: ieee80211_beacon_get: no rate "
-				       "found\n", local->mdev->name);
+				       "found\n", wiphy_name(local->hw.wiphy));
 			}
 			dev_kfree_skb(skb);
 			return NULL;

-- 

