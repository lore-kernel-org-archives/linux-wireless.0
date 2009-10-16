Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54524 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbZJPCKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 22:10:13 -0400
Received: by fxm18 with SMTP id 18so1882562fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2009 19:09:36 -0700 (PDT)
Subject: [PATCH] mac80211: fixed injection in monitor mode
From: Gabriele Gristina <matrix.use.linux@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 16 Oct 2009 04:09:21 +0200
Message-Id: <1255658961.23827.2.camel@el8pc>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a problem with mac80211 injection:
if i setup interface in monitor mode with iwconfig and i try to send a
custum 802.11 frame i see twice the packet in monitor interface.
The first packet is right, the second is different only in the radiotap
header: rtap len is fixed to 13 bytes...
If i setup interface with airmon-ng the packet is sended once but the
radiotap header is fixed to 13 bytes.

Patch for 2.6.31.4

--- net/mac80211/main.c.orig    2009-10-16 00:50:00.000000000 +0200
+++ net/mac80211/main.c    2009-10-15 23:06:03.000000000 +0200
@@ -607,6 +607,9 @@
     skb->protocol = htons(ETH_P_802_2);
     memset(skb->cb, 0, sizeof(skb->cb));
 
+    if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+        goto out_no_echo;
+
     rcu_read_lock();
     list_for_each_entry_rcu(sdata, &local->interfaces, list) {
         if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
@@ -630,7 +633,8 @@
         skb = NULL;
     }
     rcu_read_unlock();
-    dev_kfree_skb(skb);
+out_no_echo:
+    if (skb) dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);


