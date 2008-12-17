Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46598 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbYLQS17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:27:59 -0500
Message-ID: <494944AD.7020204@lwfinger.net> (sfid-20081217_192801_523435_D48B213C)
Date: Wed, 17 Dec 2008 12:27:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: Print unknown packet type
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I'm trying to find a problem with p54usb that causes it to go belly-up under
stress testing. In one of my runs, I hit the WARN_ON in
ieee80211_tasklet_handler(). Unfortunately, I got no indication of what was in
skb->pkt_type, just that it was not one of the expected types.

Do you think that adding the printk below would be worthwhile?

Thanks,

Larry
---

Index: wireless-testing/net/mac80211/main.c
===================================================================
--- wireless-testing.orig/net/mac80211/main.c
+++ wireless-testing/net/mac80211/main.c
@@ -341,6 +341,8 @@ static void ieee80211_tasklet_handler(un
 			dev_kfree_skb(skb);
 			break ;
 		default:
+			printk(KERN_INFO "mac80211: Packet is of unknown type"
+					 " %d\n", skb->pkt_type);
 			WARN_ON(1);
 			dev_kfree_skb(skb);
 			break;


