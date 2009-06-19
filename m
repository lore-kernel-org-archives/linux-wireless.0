Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:63285 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZFSThJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 15:37:09 -0400
Received: by pxi40 with SMTP id 40so160323pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 12:37:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83a869cd0906191233g507fea1cg238d14b57ace0466@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
	 <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
	 <1244750836.29447.5.camel@johannes.local>
	 <83a869cd0906121341k3b58b80fvefdb74c2fca9449d@mail.gmail.com>
	 <1244839645.11782.5.camel@johannes.local>
	 <83a869cd0906191233g507fea1cg238d14b57ace0466@mail.gmail.com>
Date: Fri, 19 Jun 2009 21:37:11 +0200
Message-ID: <83a869cd0906191237j7d727a4ekd6dbb9fc35d60b78@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update : I changed the logic. There is a single flag per key, tracking
if we send the key instead of a flag per rx queue.

The mac80211 tkip code won't call update_tkip_key, if some rx packets
get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
first packet because the hardware key stuff is called asynchronously with
todo workqueue.

This patch workaround that by tracking if we send the key to hardware.


Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
Index: linux-2.6/net/mac80211/tkip.c
===================================================================
--- linux-2.6.orig/net/mac80211/tkip.c	2009-06-19 19:13:47.000000000 +0000
+++ linux-2.6/net/mac80211/tkip.c	2009-06-19 19:21:50.000000000 +0000
@@ -282,6 +282,7 @@
 	    key->u.tkip.rx[queue].iv32 != iv32) {
 		/* IV16 wrapped around - perform TKIP phase 1 */
 		tkip_mixing_phase1(tk, &key->u.tkip.rx[queue], ta, iv32);
+		key->u.tkip.rx_tkip_key_sent = 0;
 #ifdef CONFIG_MAC80211_TKIP_DEBUG
 		{
 			int i;
@@ -298,19 +299,21 @@
 			printk("\n");
 		}
 #endif
-		if (key->local->ops->update_tkip_key &&
-			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-			u8 bcast[ETH_ALEN] =
-				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-			u8 *sta_addr = key->sta->sta.addr;
+	}
+	if (key->local->ops->update_tkip_key &&
+	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+	    !key->u.tkip.rx_tkip_key_sent) {
+		u8 bcast[ETH_ALEN] =
+			{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+		u8 *sta_addr = key->sta->sta.addr;

-			if (is_multicast_ether_addr(ra))
-				sta_addr = bcast;
+		if (is_multicast_ether_addr(ra))
+			sta_addr = bcast;

-			key->local->ops->update_tkip_key(
-				local_to_hw(key->local), &key->conf,
-				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
-		}
+		key->local->ops->update_tkip_key(
+			local_to_hw(key->local), &key->conf,
+			sta_addr, iv32, key->u.tkip.rx[queue].p1k);
+		key->u.tkip.rx_tkip_key_sent = 1;
 	}

 	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
Index: linux-2.6/net/mac80211/key.h
===================================================================
--- linux-2.6.orig/net/mac80211/key.h	2009-06-19 19:22:20.000000000 +0000
+++ linux-2.6/net/mac80211/key.h	2009-06-19 19:22:31.000000000 +0000
@@ -86,6 +86,7 @@

 			/* last received RSC */
 			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
+			int rx_tkip_key_sent;
 		} tkip;
 		struct {
 			u8 tx_pn[6];
