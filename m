Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbXC1JLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:11:50 -0400
Subject: [PATCH] mac80211: make 802.1X setting consistent with low-level
	driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 17:59:54 +0200
Message-Id: <1175011194.9282.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the low-level driver fails to reconfigure 802.1X we currently still
set the variable. Don't do that since it brings things out of sync.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211_ioctl.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-27 16:33:44.363155480 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-27 16:33:44.943155480 +0200
@@ -2478,11 +2478,14 @@ static int ieee80211_ioctl_prism2_param(
 		break;
 
 	case PRISM2_PARAM_IEEE_802_1X:
-		sdata->ieee802_1x = value;
-		if (local->ops->set_ieee8021x &&
-		    local->ops->set_ieee8021x(local_to_hw(local), value))
+		if (local->ops->set_ieee8021x)
+			ret = local->ops->set_ieee8021x(local_to_hw(local),
+							value);
+		if (ret)
 			printk(KERN_DEBUG "%s: failed to set IEEE 802.1X (%d) "
 			       "for low-level driver\n", dev->name, value);
+		else
+			sdata->ieee802_1x = value;
 		break;
 
 	case PRISM2_PARAM_ANTSEL_TX:


