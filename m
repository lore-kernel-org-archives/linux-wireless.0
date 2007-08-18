Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41697 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXHRDAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 23:00:20 -0400
Subject: [PATCH 2/2] mac80211: ignore key index on pairwise key
From: Volker Braun <vbraun@physics.upenn.edu>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 23:00:19 -0400
Message-Id: <1187406019.30247.18.camel@thinkpad>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our Cisco AP's set key index 3 for the PTK. This patch removes the check
for the key index. I also tried to set idx=0 by hand, but this did not
work (presumably because the AP then discarded my unicast packets with
key index 0 instead of 3).

With these two patches I can successfully use our dynamic wep wireless
network.

Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>


diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index fbdd1d1..66b4f5a 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -385,13 +385,14 @@ static int ieee80211_set_encryption(struct net_device *dev
 
        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+       if (idx <0 || idx >= NUM_DEFAULT_KEYS) {
+               printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
+                      dev->name, idx);
+               return -EINVAL;
+       }
+
        if (is_broadcast_ether_addr(sta_addr)) {
                sta = NULL;
-               if (idx >= NUM_DEFAULT_KEYS) {
-                       printk(KERN_DEBUG "%s: set_encrypt - invalid idx=%d\n",
-                              dev->name, idx);
-                       return -EINVAL;
-               }
                key = sdata->keys[idx];
 
                /* TODO: consider adding hwaccel support for these; at least
@@ -405,12 +406,6 @@ static int ieee80211_set_encryption(struct net_device *dev,
                 * being, this can be only set at compile time. */
        } else {
                set_tx_key = 0;
-               if (idx != 0) {
-                       printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
-                              "individual key\n", dev->name);
-                       return -EINVAL;
-               }
-
                sta = sta_info_get(local, sta_addr);
                if (!sta) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG


