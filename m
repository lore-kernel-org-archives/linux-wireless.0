Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44836 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754478AbXD2AcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 20:32:18 -0400
Received: from logostar.upir.cz (r2u241.net.upc.cz [62.245.84.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id 57A66628062
	for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 02:32:16 +0200 (CEST)
Date: Sun, 29 Apr 2007 02:32:15 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mac80211: remove unused code
Message-ID: <20070429023215.40c2aea7@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove code that is commented out and doesn't even compile when uncommented.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/ieee80211_ioctl.c |    8 --------
 1 files changed, 8 deletions(-)

--- dscape.orig/net/mac80211/ieee80211_ioctl.c
+++ dscape/net/mac80211/ieee80211_ioctl.c
@@ -1025,14 +1025,6 @@ static int ieee80211_ioctl_add_if(struct
 
 		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
 				       IEEE80211_IF_TYPE_VLAN);
-		if (res)
-			return res;
-#if 0
-		res = ieee80211_if_update_vlan(new_dev, vlan->id);
-		if (res)
-			__ieee80211_if_del(wdev_priv(dev->ieee80211_ptr),
-					   IEEE80211_DEV_TO_SUB_IF(new_dev));
-#endif
 		return res;
 	case HOSTAP_IF_BSS:
 		bss = (struct hostapd_if_bss *) param->u.if_info.data;

