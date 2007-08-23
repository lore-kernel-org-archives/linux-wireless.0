Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbXHWQti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:38 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFsF-00010C-Ge
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:36 +0100
Message-Id: <20070823164523.962519000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 07/11] mac80211: print out wiphy name instead of master device
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

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-23 18:38:38.211897709 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-23 18:38:43.831897709 +0200
@@ -864,7 +864,7 @@ static void ieee80211_tasklet_handler(un
 			break;
 		default: /* should never get here! */
 			printk(KERN_ERR "%s: Unknown message type (%d)\n",
-			       local->mdev->name, skb->pkt_type);
+			       wiphy_name(local->hw.wiphy), skb->pkt_type);
 			dev_kfree_skb(skb);
 			break;
 		}
@@ -949,7 +949,7 @@ void ieee80211_tx_status(struct ieee8021
 	if (!status) {
 		printk(KERN_ERR
 		       "%s: ieee80211_tx_status called with NULL status\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -1006,7 +1006,7 @@ void ieee80211_tx_status(struct ieee8021
 					printk(KERN_DEBUG "%s: dropped TX "
 					       "filtered frame queue_len=%d "
 					       "PS=%d @%lu\n",
-					       local->mdev->name,
+					       wiphy_name(local->hw.wiphy),
 					       skb_queue_len(
 						       &sta->tx_filtered),
 					       !!(sta->flags & WLAN_STA_PS),
@@ -1331,7 +1331,7 @@ int ieee80211_register_hw(struct ieee802
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize rate control "
-		       "algorithm\n", local->mdev->name);
+		       "algorithm\n", wiphy_name(local->hw.wiphy));
 		goto fail_rate;
 	}
 
@@ -1339,7 +1339,7 @@ int ieee80211_register_hw(struct ieee802
 
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize wep\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 		goto fail_wep;
 	}
 
@@ -1350,7 +1350,7 @@ int ieee80211_register_hw(struct ieee802
 				  IEEE80211_IF_TYPE_STA);
 	if (result)
 		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 
 	local->reg_state = IEEE80211_DEV_REGISTERED;
 	rtnl_unlock();
@@ -1450,7 +1450,7 @@ void ieee80211_unregister_hw(struct ieee
 	if (skb_queue_len(&local->skb_queue)
 			|| skb_queue_len(&local->skb_queue_unreliable))
 		printk(KERN_WARNING "%s: skb_queue not empty\n",
-		       local->mdev->name);
+		       wiphy_name(local->hw.wiphy));
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 
--- wireless-dev.orig/net/mac80211/ieee80211_rate.c	2007-08-23 18:38:38.251897709 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.c	2007-08-23 18:38:43.831897709 +0200
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
 
 
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-23 18:38:38.271897709 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-23 18:38:43.841897709 +0200
@@ -4027,7 +4027,7 @@ struct sta_info * ieee80211_ibss_add_sta
 	}
 
 	printk(KERN_DEBUG "%s: Adding new IBSS station " MAC_FMT " (dev=%s)\n",
-	       local->mdev->name, MAC_ARG(addr), dev->name);
+	       wiphy_name(local->hw.wiphy), MAC_ARG(addr), dev->name);
 
 	sta = sta_info_add(local, dev, addr, GFP_ATOMIC);
 	if (!sta)
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-23 18:38:38.321897709 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-23 18:38:43.841897709 +0200
@@ -1605,7 +1605,8 @@ void __ieee80211_rx(struct ieee80211_hw 
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: failed to copy "
 				       "multicast frame for %s",
-				       local->mdev->name, prev->dev->name);
+				       wiphy_name(local->hw.wiphy),
+				       prev->dev->name);
 			continue;
 		}
 		rx.skb = skb_new;
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-08-23 18:38:38.361897709 +0200
+++ wireless-dev/net/mac80211/sta_info.c	2007-08-23 18:38:43.851897709 +0200
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
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-23 18:38:43.161897709 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-23 18:38:43.861897709 +0200
@@ -318,7 +318,7 @@ static void purge_old_ps_buffers(struct 
 
 	local->total_ps_buffered = total;
 	printk(KERN_DEBUG "%s: PS buffers full - purged %d frames\n",
-	       local->mdev->name, purged);
+	       wiphy_name(local->hw.wiphy), purged);
 }
 
 static inline ieee80211_txrx_result
@@ -1030,7 +1030,8 @@ static int __ieee80211_tx(struct ieee802
 		return IEEE80211_TX_AGAIN;
 	}
 	if (skb) {
-		ieee80211_dump_frame(local->mdev->name, "TX to low-level driver", skb);
+		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
+				     "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
@@ -1058,7 +1059,7 @@ static int __ieee80211_tx(struct ieee802
 						~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 			}
 
-			ieee80211_dump_frame(local->mdev->name,
+			ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 					     "TX to low-level driver",
 					     tx->u.tx.extra_frag[i]);
 			ret = local->ops->tx(local_to_hw(local),
@@ -1761,7 +1762,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		if (!rate) {
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: ieee80211_beacon_get: no rate "
-				       "found\n", local->mdev->name);
+				       "found\n", wiphy_name(local->hw.wiphy));
 			}
 			dev_kfree_skb(skb);
 			return NULL;

-- 

