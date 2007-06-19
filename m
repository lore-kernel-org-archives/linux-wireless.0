Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXFTLQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:16:35 -0400
Subject: [PATCH] bcm43xx: honour promisc bit even in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 01:30:38 +0200
Message-Id: <1182295838.3714.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When bcm43xx goes into monitor mode, it always is a promisc monitor
mode. For the hostapd using monitor interfaces, we'll want to only go
into monitor mode if it's really required. I previously thought that
this requires changes to mac80211, but mac80211 does in fact already
seem to handle IFF_PROMISC appropriately. Hence, this change is the
only required to get proper semantics for a monitor interface that
isn't in promiscuous mode on bcm43xx.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Since wireshark/tcpdump by default still set IFF_PROMISC everything will
work just fine, but if somebody really wants a monitor interface that
isn't promisc this makes it work too. However, you'll of course get all
packets still if any other interface is set promisc. We don't do any
promisc/non-promisc filtering in the stack when multiple monitor
interfaces are open.

 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c |    1 -
 1 file changed, 1 deletion(-)

--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-20 01:03:35.547360230 +0200
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-20 01:03:42.467360230 +0200
@@ -1939,7 +1939,6 @@ static void bcm43xx_adjust_opmode(struct
 		}
 	}
 	if (wl->monitor) {
-		ctl |= BCM43xx_MACCTL_PROMISC;
 		ctl |= BCM43xx_MACCTL_KEEP_CTL;
 		if (modparam_mon_keep_bad)
 			ctl |= BCM43xx_MACCTL_KEEP_BAD;


