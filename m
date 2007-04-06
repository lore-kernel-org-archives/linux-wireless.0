Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44539 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933471AbXDFXwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 19:52:54 -0400
Message-ID: <4616DD7E.6010606@lwfinger.net>
Date: Fri, 06 Apr 2007 18:53:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: RFC: ieee80211: Spamming of log resulting from packets with ExtIV  not set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using bcm43xx-softmac, my log gets full of messages that look like:

Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa
Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa
Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa
Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa
Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa
Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa
Apr  6 18:06:55 larrylap kernel: TKIP: ICV error detected: STA=00:14:bf:85:49:fa

Are there any objections to the following patch to eliminate these messages from TKIP and CCMP?

Index: wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_tkip.c
+++ wireless-2.6/net/ieee80211/ieee80211_crypt_tkip.c
@@ -439,11 +439,7 @@ static int ieee80211_tkip_decrypt(struct
  	pos = skb->data + hdr_len;
  	keyidx = pos[3];
  	if (!(keyidx & (1 << 5))) {
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "TKIP: received packet without ExtIV"
-			       " flag from " MAC_FMT "\n", MAC_ARG(hdr->addr2));
-		}
-		return -2;
+		return -2; /* received packet without ExtIV */
  	}
  	keyidx >>= 6;
  	if (tkey->key_idx != keyidx) {
Index: wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
===================================================================
--- wireless-2.6.orig/net/ieee80211/ieee80211_crypt_ccmp.c
+++ wireless-2.6/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -306,11 +306,7 @@ static int ieee80211_ccmp_decrypt(struct
  	pos = skb->data + hdr_len;
  	keyidx = pos[3];
  	if (!(keyidx & (1 << 5))) {
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "CCMP: received packet without ExtIV"
-			       " flag from " MAC_FMT "\n", MAC_ARG(hdr->addr2));
-		}
-		return -2;
+		return -2; /* received packet without ExtIV */
  	}
  	keyidx >>= 6;

Larry

