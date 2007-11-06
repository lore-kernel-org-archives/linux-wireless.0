Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44731 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754151AbXKFWNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 17:13:11 -0500
Date: Tue, 6 Nov 2007 22:48:25 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH 2/7] b43legacy: use a consistent naming scheme for the ops
Message-ID: <20071106224825.5b942f3f@morte> (sfid-20071106_221317_493302_B8D1195D)
In-Reply-To: <20071106222313.31e9bcd9@morte>
References: <20071106222313.31e9bcd9@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a consistent naming scheme for the ops.

The patch to b43 by Michael Buesch <mb@bu3sch.de> has been ported to
b43legacy.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

----

Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -2285,9 +2285,9 @@ static int b43legacy_rng_init(struct b43
 	return err;
 }
 
-static int b43legacy_tx(struct ieee80211_hw *hw,
-			struct sk_buff *skb,
-			struct ieee80211_tx_control *ctl)
+static int b43legacy_op_tx(struct ieee80211_hw *hw,
+			   struct sk_buff *skb,
+			   struct ieee80211_tx_control *ctl)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -2311,15 +2311,15 @@ out:
 	return NETDEV_TX_OK;
 }
 
-static int b43legacy_conf_tx(struct ieee80211_hw *hw,
-			     int queue,
-			     const struct ieee80211_tx_queue_params *params)
+static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
+				int queue,
+				const struct ieee80211_tx_queue_params *params)
 {
 	return 0;
 }
 
-static int b43legacy_get_tx_stats(struct ieee80211_hw *hw,
-				  struct ieee80211_tx_queue_stats *stats)
+static int b43legacy_op_get_tx_stats(struct ieee80211_hw *hw,
+				     struct ieee80211_tx_queue_stats *stats)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -2341,8 +2341,8 @@ out:
 	return err;
 }
 
-static int b43legacy_get_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_low_level_stats *stats)
+static int b43legacy_op_get_stats(struct ieee80211_hw *hw,
+				  struct ieee80211_low_level_stats *stats)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	unsigned long flags;
@@ -2491,8 +2491,8 @@ static int b43legacy_antenna_from_ieee80
 	}
 }
 
-static int b43legacy_dev_config(struct ieee80211_hw *hw,
-				struct ieee80211_conf *conf)
+static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
+				   struct ieee80211_conf *conf)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev;
@@ -2595,11 +2595,11 @@ out_unlock_mutex:
 	return err;
 }
 
-static void b43legacy_configure_filter(struct ieee80211_hw *hw,
-				       unsigned int changed,
-				       unsigned int *fflags,
-				       int mc_count,
-				       struct dev_addr_list *mc_list)
+static void b43legacy_op_configure_filter(struct ieee80211_hw *hw,
+					  unsigned int changed,
+					  unsigned int *fflags,
+					  int mc_count,
+					  struct dev_addr_list *mc_list)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -2634,9 +2634,9 @@ static void b43legacy_configure_filter(s
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
-static int b43legacy_config_interface(struct ieee80211_hw *hw,
-				      int if_id,
-				      struct ieee80211_if_conf *conf)
+static int b43legacy_op_config_interface(struct ieee80211_hw *hw,
+					 int if_id,
+					 struct ieee80211_if_conf *conf)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -3141,8 +3141,8 @@ err_kfree_lo_control:
 	return err;
 }
 
-static int b43legacy_add_interface(struct ieee80211_hw *hw,
-				   struct ieee80211_if_init_conf *conf)
+static int b43legacy_op_add_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_if_init_conf *conf)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev;
@@ -3181,8 +3181,8 @@ static int b43legacy_add_interface(struc
 	return err;
 }
 
-static void b43legacy_remove_interface(struct ieee80211_hw *hw,
-				       struct ieee80211_if_init_conf *conf)
+static void b43legacy_op_remove_interface(struct ieee80211_hw *hw,
+					  struct ieee80211_if_init_conf *conf)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -3206,7 +3206,7 @@ static void b43legacy_remove_interface(s
 	mutex_unlock(&wl->mutex);
 }
 
-static int b43legacy_start(struct ieee80211_hw *hw)
+static int b43legacy_op_start(struct ieee80211_hw *hw)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -3237,7 +3237,7 @@ out_mutex_unlock:
 	return err;
 }
 
-static void b43legacy_stop(struct ieee80211_hw *hw)
+static void b43legacy_op_stop(struct ieee80211_hw *hw)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
@@ -3272,17 +3272,17 @@ out_unlock:
 }
 
 static const struct ieee80211_ops b43legacy_hw_ops = {
-	.tx			= b43legacy_tx,
-	.conf_tx		= b43legacy_conf_tx,
-	.add_interface		= b43legacy_add_interface,
-	.remove_interface	= b43legacy_remove_interface,
-	.config			= b43legacy_dev_config,
-	.config_interface	= b43legacy_config_interface,
-	.configure_filter	= b43legacy_configure_filter,
-	.get_stats		= b43legacy_get_stats,
-	.get_tx_stats		= b43legacy_get_tx_stats,
-	.start			= b43legacy_start,
-	.stop			= b43legacy_stop,
+	.tx			= b43legacy_op_tx,
+	.conf_tx		= b43legacy_op_conf_tx,
+	.add_interface		= b43legacy_op_add_interface,
+	.remove_interface	= b43legacy_op_remove_interface,
+	.config			= b43legacy_op_dev_config,
+	.config_interface	= b43legacy_op_config_interface,
+	.configure_filter	= b43legacy_op_configure_filter,
+	.get_stats		= b43legacy_op_get_stats,
+	.get_tx_stats		= b43legacy_op_get_tx_stats,
+	.start			= b43legacy_op_start,
+	.stop			= b43legacy_op_stop,
 	.set_retry_limit	= b43legacy_op_set_retry_limit,
 };
 


-- 
Ciao
Stefano
