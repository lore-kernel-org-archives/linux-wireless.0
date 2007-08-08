Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55151 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbXHHBzI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 21:55:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IIalK-00007I-UC
	for linux-wireless@vger.kernel.org; Wed, 08 Aug 2007 03:55:02 +0200
Received: from carrot.hep.upenn.edu ([128.91.45.96])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2007 03:55:02 +0200
Received: from volker.braun by carrot.hep.upenn.edu with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2007 03:55:02 +0200
To: linux-wireless@vger.kernel.org
From: Volker Braun <volker.braun@physik.hu-berlin.de>
Subject: mac8011 vs. dynamic wep infrastructure
Date: Wed, 8 Aug 2007 00:00:09 +0000 (UTC)
Message-ID: <pan.2007.08.08.00.00.05@physik.hu-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had problems associating to my university's wireless lan. We are
using dynamic WEP (IEEE8021X EAP-TTLS/PAP, aka "eduroam") and Cisco
APs. There seem to be two problems:

1) The AP beacon sets WLAN_CAPABILITY_PRIVACY. Of course, the initial
authentication and WEP key exchange cannot be WEP encrypted (but is
protected by TTLS, so it is secure). Reading the original 80211 draft,
it is probably illegal to set WLAN_CAPABILITY_PRIVACY in this
situation, so it would be Cisco's fault (but we still have to live
with it). I patched ieee80211_privacy_mismatch to allow the mismatch
as long as we are not associated.

2) The Cisco AP sets the unicast key to some index higher than
0. While outright weird, this is probably legal. However, mac80211
does not allow this setting. I patched ieee80211_set_encryption to
remove this invalid restriction of the key index. Finally I inserted
some hack in ieee80211_rx_h_check to guess the right key.

With these modifications, I can associate to our network and exchange
data.

To get the patch into a presentable state, I have a couple of
questions:

a) Can anyone please confirm that the key index *must* be in the range
[0,NUM_DEFAULT_KEYS), everywhere in the code? Or are there some magic
values outside this interval? 

b) In ieee80211_set_encryption, there are two places to store WEP
keys: sta->key (for the unicast key) and sdata->keys[0..3] (for
broad/multicast keys). So the unicast key is not included in the
output of "iwlist key", is that intentional? In ieee80211_rx_h_check
you get the key index, but the unicast key is _NOT_
sdata->keys[keyindex]?!? Why don't we simply put all keys into
sdata->keys[0..3], would that be too easy? 

I see some similar (wrong) assumptions about keyidx==0 being the
unicast key in ieee80211_rx_michael_mic_report. The statistics
gathering is probably still broken in that regard.


Volker Braun
---


diff -ru linux+mac80211-9.0.3/include/linux/ieee80211.h linux-2.6.22.1/include/linux/ieee80211.h
--- linux+mac80211-9.0.3/include/linux/ieee80211.h      2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/include/linux/ieee80211.h    2007-08-07 13:35:18.000000000 -0400
@@ -357,7 +357,7 @@
 #define WLAN_CAPABILITY_IBSS           (1<<1)
 #define WLAN_CAPABILITY_CF_POLLABLE    (1<<2)
 #define WLAN_CAPABILITY_CF_POLL_REQUEST        (1<<3)
-#define WLAN_CAPABILITY_PRIVACY                (1<<4)
+#define WLAN_CAPABILITY_PRIVACY                (1<<4) /* Force WEP on data packets */
 #define WLAN_CAPABILITY_SHORT_PREAMBLE (1<<5)
 #define WLAN_CAPABILITY_PBCC           (1<<6)
 #define WLAN_CAPABILITY_CHANNEL_AGILITY        (1<<7)
diff -ru linux+mac80211-9.0.3/net/mac80211/ieee80211.c linux-2.6.22.1/net/mac80211/ieee80211.c
--- linux+mac80211-9.0.3/net/mac80211/ieee80211.c       2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/net/mac80211/ieee80211.c     2007-08-07 19:52:42.000000000 -0400
@@ -3571,12 +3571,19 @@
 
                if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
                    rx->fc & IEEE80211_FCTL_PROTECTED) {
-                       int keyidx = ieee80211_wep_get_keyidx(rx->skb);
 
+                       int keyidx = ieee80211_wep_get_keyidx(rx->skb);
+                       if (keyidx < 0 || keyidx >= NUM_DEFAULT_KEYS)
+                               return TXRX_DROP;
+
                        if (keyidx >= 0 && keyidx < NUM_DEFAULT_KEYS &&
                            (!rx->sta || !rx->sta->key || keyidx > 0))
                                rx->key = rx->sdata->keys[keyidx];
 
+                       /* nasty hack: the unicast key had keyidx > 0 */
+                       if (rx->sta && rx->sta->key && !rx->key)
+                               rx->key = rx->sta->key;
+
                        if (!rx->key) {
                                if (!rx->u.rx.ra_match)
                                        return TXRX_DROP;
diff -ru linux+mac80211-9.0.3/net/mac80211/ieee80211_ioctl.c linux-2.6.22.1/net/mac80211/ieee80211_ioctl.c
--- linux+mac80211-9.0.3/net/mac80211/ieee80211_ioctl.c 2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/net/mac80211/ieee80211_ioctl.c       2007-08-07 19:37:25.000000000 -0400
@@ -479,13 +479,14 @@
 
        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+       if (idx < 0 || idx >= NUM_DEFAULT_KEYS) {
+               printk(KERN_DEBUG "%s: set_encrypt - invalid idx = %d\n",
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
@@ -499,12 +500,6 @@
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
                        if (err)
diff -ru linux+mac80211-9.0.3/net/mac80211/ieee80211_sta.c linux-2.6.22.1/net/mac80211/ieee80211_sta.c
--- linux+mac80211-9.0.3/net/mac80211/ieee80211_sta.c   2007-08-06 16:28:48.000000000 -0400
+++ linux-2.6.22.1/net/mac80211/ieee80211_sta.c 2007-08-07 15:01:31.000000000 -0400
@@ -1131,10 +1131,11 @@
        bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
        if (!bss)
                return 0;
-
-       if (ieee80211_sta_wep_configured(dev) !=
-           !!(bss->capability & WLAN_CAPABILITY_PRIVACY))
-               res = 1;
+
+       if (ifsta->associated && ieee80211_sta_wep_configured(dev) != 
+           !!(bss->capability & WLAN_CAPABILITY_PRIVACY)) {
+               res = 1;  /* associated and WEP encryption mismatch */
+       }
 
        ieee80211_rx_bss_put(dev, bss);

