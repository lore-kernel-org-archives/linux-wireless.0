Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52664 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXHREof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 00:44:35 -0400
Subject: [PATCH 2/2 v2] mac80211: ignore key index on pairwise key (WEP  only)
From: Volker Braun <vbraun@physics.upenn.edu>
To: Jouni Malinen <j@w1.fi>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20070818034613.GD1415@jm.kir.nu>
References: <1187406019.30247.18.camel@thinkpad>
	 <20070818034613.GD1415@jm.kir.nu>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 00:44:33 -0400
Message-Id: <1187412273.3515.4.camel@thinkpad>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Work-around for broken APs that use a non-zero key index for WEP
pairwise keys. With this patch, WEP encryption only is exempt from
providing a zero key index.

Signed-off-by: Volker Braun <volker.braun@physik.hu-berlin.de>


diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index fbdd1d1..2a45e54 100644
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
@@ -405,9 +406,15 @@ static int ieee80211_set_encryption(struct net_device *dev,
                 * being, this can be only set at compile time. */
        } else {
                set_tx_key = 0;
-               if (idx != 0) {
-                       printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
-                              "individual key\n", dev->name);
+
+               /*
+                * According to the standard, the key index of a pairwise 
+                * key must be zero. However, some AP are broken when it
+                * comes to WEP key indices, so we work around this.
+                */
+               if (idx != 0 && alg != ALG_WEP) {
+                        printk(KERN_DEBUG "%s: set_encrypt - non-zero idx for "
+                               "pairwise key\n", dev->name);
                        return -EINVAL;
                }
 


