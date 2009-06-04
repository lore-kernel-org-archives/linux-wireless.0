Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:39861 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZFDUQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 16:16:26 -0400
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 22FE54C8105
	for <linux-wireless@vger.kernel.org>; Thu,  4 Jun 2009 22:16:22 +0200 (CEST)
Received: from [192.168.1.189] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp4-g21.free.fr (Postfix) with ESMTP id D57A74C817A
	for <linux-wireless@vger.kernel.org>; Thu,  4 Jun 2009 22:16:19 +0200 (CEST)
Message-ID: <4A282B92.70609@free.fr>
Date: Thu, 04 Jun 2009 22:16:18 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 : fix unaligned rx skb
Content-Type: multipart/mixed;
 boundary="------------080709000202070700080601"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080709000202070700080601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


--------------080709000202070700080601
Content-Type: text/x-diff;
 name="mac80211_alignement.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mac80211_alignement.diff"

mac80211 is checking is the skb is aligned on 32 bit boundary.
But it is checking against ethernet header, whereas Linux expect IP
header aligned.
And ethernet ether size is 6*2+2=14, so aligning ethernet header make IP header unaligned.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9776f73..0845fb3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1397,7 +1397,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		 * mac80211. That also explains the __skb_push()
 		 * below.
 		 */
-		align = (unsigned long)skb->data & 3;
+		align = ((unsigned long)(skb->data + sizeof(struct ethhdr))) & 3;
 		if (align) {
 			if (WARN_ON(skb_headroom(skb) < 3)) {
 				dev_kfree_skb(skb);

--------------080709000202070700080601--
