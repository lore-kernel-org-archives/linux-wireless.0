Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232AbXCEL6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 06:58:48 -0500
Received: from [84.135.204.66] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HOBla-0002N9-Lr
	for linux-wireless@vger.kernel.org; Mon, 05 Mar 2007 11:54:10 +0000
Subject: [FYI] compiling hostapd against latest wireless-dev
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Mar 2007 12:58:22 +0100
Message-Id: <1173095902.6131.63.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... isn't really possible at the moment. But you only need to change
some include paths (to be able to include the
net/mac80211/mac80211_common.h header!) and apply this change to be able
to include include/net/mac80211.h into the userspace code.

And no, this shouldn't be applied. Rather should the prism ioctl foo be
deleted.

johannes

--- wireless-dev.orig/include/net/mac80211.h	2007-03-04 01:53:43.719146462 +0100
+++ wireless-dev/include/net/mac80211.h	2007-03-04 01:55:13.489146462 +0100
@@ -10,6 +10,7 @@
 #ifndef MAC80211_H
 #define MAC80211_H
 
+#ifdef __KERNEL__
 #include <linux/kernel.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
@@ -18,7 +19,7 @@
 #include <linux/ieee80211.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>
-
+#endif
 /* Note! Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
  * called in hardware interrupt context. The low-level driver must not call any
  * other functions in hardware interrupt context. If there is a need for such
@@ -108,7 +109,7 @@ enum {
 	MODE_ATHEROS_TURBOG = 4 /* Atheros Turbo mode (2x.11g at 2.4 GHz) */,
 	NUM_IEEE80211_MODES = 5
 };
-
+#ifdef __KERNEL__
 struct ieee80211_hw_mode {
 	int mode; /* MODE_IEEE80211... */
 	int num_channels; /* Number of channels (below) */
@@ -118,7 +119,7 @@ struct ieee80211_hw_mode {
 
 	struct list_head list; /* Internal, don't touch */
 };
-
+#endif
 struct ieee80211_tx_queue_params {
 	int aifs; /* 0 .. 255; -1 = use default */
 	int cw_min; /* 2^n-1: 1, 3, 7, .. , 1023; 0 = use default */
@@ -552,7 +553,7 @@ struct ieee80211_hw {
 	 * WMM requires at least four queues. */
 	int queues;
 };
-
+#ifdef __KERNEL__
 static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev)
 {
 	set_wiphy_dev(hw->wiphy, dev);
@@ -1079,4 +1080,6 @@ static inline int ieee80211_get_morefrag
 #define MAC_ARG(x) ((u8*)(x))[0], ((u8*)(x))[1], ((u8*)(x))[2], \
 		   ((u8*)(x))[3], ((u8*)(x))[4], ((u8*)(x))[5]
 
+#endif
+
 #endif /* MAC80211_H */


