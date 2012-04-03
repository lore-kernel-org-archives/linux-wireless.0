Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2DCMp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:45:56 -0400
Message-ID: <1333457154.3574.18.camel@jlt3.sipsolutions.net> (sfid-20120403_144559_919415_04C97E86)
Subject: [PATCH] mac80211: clean up an ieee80211_do_open error path
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Date: Tue, 03 Apr 2012 14:45:54 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Eliad's comment prompted me to look closer at
the error paths in ieee80211_do_open() and I
found one that should use the error labels.

Also add a comment about the clear_bit since
in many error cases the bit hasn't been set.

Cc: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/mac80211/iface.c	2012-04-03 14:41:44.000000000 +0200
+++ b/net/mac80211/iface.c	2012-04-03 14:44:24.000000000 +0200
@@ -349,9 +349,8 @@ static int ieee80211_do_open(struct net_
 		memcpy(dev->perm_addr, dev->dev_addr, ETH_ALEN);
 
 		if (!is_valid_ether_addr(dev->dev_addr)) {
-			if (!local->open_count)
-				drv_stop(local);
-			return -EADDRNOTAVAIL;
+			res = -EADDRNOTAVAIL;
+			goto err_stop;
 		}
 	}
 
@@ -485,6 +484,7 @@ static int ieee80211_do_open(struct net_
 	sdata->bss = NULL;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		list_del(&sdata->u.vlan.list);
+	/* might already be clear but that doesn't matter */
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 	return res;
 }


