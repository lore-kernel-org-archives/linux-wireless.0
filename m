Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41414
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXJ1Pa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 11:30:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: consistent naming for ieee80211_ops
Date: Sun, 28 Oct 2007 16:29:32 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710281629.32319.mb@bu3sch.de> (sfid-20071028_153030_903475_A42F64A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a consistent naming scheme for the ops.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-10-28 16:20:03.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-10-28 16:24:51.000000000 +0100
@@ -2486,8 +2486,9 @@ static int b43_rng_init(struct b43_wl *w
 	return err;
 }
 
-static int b43_tx(struct ieee80211_hw *hw,
-		  struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+static int b43_op_tx(struct ieee80211_hw *hw,
+		     struct sk_buff *skb,
+		     struct ieee80211_tx_control *ctl)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -2505,21 +2506,21 @@ static int b43_tx(struct ieee80211_hw *h
 		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	} else
 		err = b43_dma_tx(dev, skb, ctl);
-      out:
+out:
 	if (unlikely(err))
 		return NETDEV_TX_BUSY;
 	return NETDEV_TX_OK;
 }
 
-static int b43_conf_tx(struct ieee80211_hw *hw,
-		       int queue,
-		       const struct ieee80211_tx_queue_params *params)
+static int b43_op_conf_tx(struct ieee80211_hw *hw,
+			  int queue,
+			  const struct ieee80211_tx_queue_params *params)
 {
 	return 0;
 }
 
-static int b43_get_tx_stats(struct ieee80211_hw *hw,
-			    struct ieee80211_tx_queue_stats *stats)
+static int b43_op_get_tx_stats(struct ieee80211_hw *hw,
+			       struct ieee80211_tx_queue_stats *stats)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -2537,12 +2538,12 @@ static int b43_get_tx_stats(struct ieee8
 		err = 0;
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
-      out:
+out:
 	return err;
 }
 
-static int b43_get_stats(struct ieee80211_hw *hw,
-			 struct ieee80211_low_level_stats *stats)
+static int b43_op_get_stats(struct ieee80211_hw *hw,
+			    struct ieee80211_low_level_stats *stats)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	unsigned long flags;
@@ -2695,7 +2696,7 @@ static int b43_antenna_from_ieee80211(u8
 	}
 }
 
-static int b43_dev_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+static int b43_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -2800,7 +2801,7 @@ static int b43_dev_config(struct ieee802
 	return err;
 }
 
-static int b43_dev_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int b43_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			   const u8 *local_addr, const u8 *addr,
 			   struct ieee80211_key_conf *key)
 {
@@ -2893,7 +2894,6 @@ BUG_ON(!key);
 out_unlock:
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	mutex_unlock(&wl->mutex);
-out:
 	if (!err) {
 		b43dbg(wl, "%s hardware based encryption for keyidx: %d, "
 		       "mac: %s\n",
@@ -2903,9 +2903,9 @@ out:
 	return err;
 }
 
-static void b43_configure_filter(struct ieee80211_hw *hw,
-				 unsigned int changed, unsigned int *fflags,
-				 int mc_count, struct dev_addr_list *mc_list)
+static void b43_op_configure_filter(struct ieee80211_hw *hw,
+				    unsigned int changed, unsigned int *fflags,
+				    int mc_count, struct dev_addr_list *mc_list)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -2940,8 +2940,9 @@ static void b43_configure_filter(struct 
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
-static int b43_config_interface(struct ieee80211_hw *hw,
-				int if_id, struct ieee80211_if_conf *conf)
+static int b43_op_config_interface(struct ieee80211_hw *hw,
+				   int if_id,
+				   struct ieee80211_if_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -3427,8 +3428,8 @@ static int b43_wireless_core_init(struct
 	return err;
 }
 
-static int b43_add_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_if_init_conf *conf)
+static int b43_op_add_interface(struct ieee80211_hw *hw,
+				struct ieee80211_if_init_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
@@ -3467,8 +3468,8 @@ static int b43_add_interface(struct ieee
 	return err;
 }
 
-static void b43_remove_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf)
+static void b43_op_remove_interface(struct ieee80211_hw *hw,
+				    struct ieee80211_if_init_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -3492,7 +3493,7 @@ static void b43_remove_interface(struct 
 	mutex_unlock(&wl->mutex);
 }
 
-static int b43_start(struct ieee80211_hw *hw)
+static int b43_op_start(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -3523,7 +3524,7 @@ static int b43_start(struct ieee80211_hw
 	return err;
 }
 
-static void b43_stop(struct ieee80211_hw *hw)
+static void b43_op_stop(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
@@ -3556,18 +3557,18 @@ out_unlock:
 }
 
 static const struct ieee80211_ops b43_hw_ops = {
-	.tx			= b43_tx,
-	.conf_tx		= b43_conf_tx,
-	.add_interface		= b43_add_interface,
-	.remove_interface	= b43_remove_interface,
-	.config			= b43_dev_config,
-	.config_interface	= b43_config_interface,
-	.configure_filter	= b43_configure_filter,
-	.set_key		= b43_dev_set_key,
-	.get_stats		= b43_get_stats,
-	.get_tx_stats		= b43_get_tx_stats,
-	.start			= b43_start,
-	.stop			= b43_stop,
+	.tx			= b43_op_tx,
+	.conf_tx		= b43_op_conf_tx,
+	.add_interface		= b43_op_add_interface,
+	.remove_interface	= b43_op_remove_interface,
+	.config			= b43_op_config,
+	.config_interface	= b43_op_config_interface,
+	.configure_filter	= b43_op_configure_filter,
+	.set_key		= b43_op_set_key,
+	.get_stats		= b43_op_get_stats,
+	.get_tx_stats		= b43_op_get_tx_stats,
+	.start			= b43_op_start,
+	.stop			= b43_op_stop,
 	.set_retry_limit	= b43_op_set_retry_limit,
 };
 
