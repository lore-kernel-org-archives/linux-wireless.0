Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:58140 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbZFJTmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 15:42:46 -0400
Received: by wf-out-1314.google.com with SMTP id 26so419340wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 12:42:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244569926.18481.27.camel@johannes.local>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
	 <1244442549.11006.2.camel@johannes.local>
	 <83a869cd0906081051h2e82bba2q731be9f84bc1846a@mail.gmail.com>
	 <1244556179.4672.11.camel@johannes.local>
	 <83a869cd0906091048k68616c11k16fa98403aa770b@mail.gmail.com>
	 <1244569926.18481.27.camel@johannes.local>
Date: Wed, 10 Jun 2009 21:42:47 +0200
Message-ID: <83a869cd0906101242w2ae8480cle69abd19a9d87112@mail.gmail.com>
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 7:52 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-09 at 19:48 +0200, gregor kowski wrote:
>
>> > Right. But drivers are free to even only _encrypt_ tkip frames and never
>> > _decrypt_ them after having accepted a hardware key, iow that is
>> > perfectly valid behaviour and I don't think we should keep uploading the
>> > key to the driver. Worst case is that the proper upload fails and we
>> > decrypt all frames in software until the next rollover.
>> >
>> What's the point of setting the tkip callback if we aren't interested
>> in decrypting data by hardware ?
>
> Might depend on something else? Anyhow I don't see the point of
> continuing to call the callback. Maybe it should just be part of the key
> todo instead when the key is initially uploaded to the hw.

Or what do you think about this. This will call the callback only once per wrap.

Gregor.


Index: linux-2.6/net/mac80211/tkip.c
===================================================================
--- linux-2.6.orig/net/mac80211/tkip.c	2009-06-08 19:37:19.000000000 +0000
+++ linux-2.6/net/mac80211/tkip.c	2009-06-10 19:28:20.000000000 +0000
@@ -274,7 +274,7 @@

 	if (only_iv) {
 		res = TKIP_DECRYPT_OK;
-		key->u.tkip.rx[queue].initialized = 1;
+		key->u.tkip.rx[queue].initialized = 2;
 		goto done;
 	}

@@ -298,19 +298,22 @@
 			printk("\n");
 		}
 #endif
-		if (key->local->ops->update_tkip_key &&
-			key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-			u8 bcast[ETH_ALEN] =
-				{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-			u8 *sta_addr = key->sta->sta.addr;
-
-			if (is_multicast_ether_addr(ra))
-				sta_addr = bcast;
-
-			key->local->ops->update_tkip_key(
-				local_to_hw(key->local), &key->conf,
-				sta_addr, iv32, key->u.tkip.rx[queue].p1k);
-		}
+	}
+	/* initialized == 2 means we already call update_tkip_key */
+	if (key->local->ops->update_tkip_key &&
+		key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
+		key->u.tkip.rx[queue].initialized != 2) {
+		u8 bcast[ETH_ALEN] =
+			{0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+		u8 *sta_addr = key->sta->sta.addr;
+
+		if (is_multicast_ether_addr(ra))
+			sta_addr = bcast;
+
+		key->local->ops->update_tkip_key(
+			local_to_hw(key->local), &key->conf,
+			sta_addr, iv32, key->u.tkip.rx[queue].p1k);
+		key->u.tkip.rx[queue].initialized = 2;
 	}

 	tkip_mixing_phase2(tk, &key->u.tkip.rx[queue], iv16, rc4key);
