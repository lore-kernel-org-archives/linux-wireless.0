Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbXI2MgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 08:36:11 -0400
Subject: [PATCH] hostapd: adjust for changed nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 14:37:33 +0200
Message-Id: <1191069453.22960.77.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before pushing nl80211 into mainline I cleaned it up
and made it more object oriented. This led to a rename
of some things hostapd is already using, so it needs
to be adjusted.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/driver_devicescape.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-09-26 14:43:47.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-09-26 14:43:48.000000000 +0200
@@ -783,7 +783,7 @@ static void nl80211_remove_iface(struct 
 		goto nla_put_failure;
 
 	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
-		    0, NL80211_CMD_DEL_VIRTUAL_INTERFACE, 0);
+		    0, NL80211_CMD_DEL_INTERFACE, 0);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, ifidx);
 	if (nl_send_auto_complete(drv->nl_handle, msg) < 0 ||
 	    nl_wait_for_ack(drv->nl_handle) < 0)
@@ -808,7 +808,7 @@ static int nl80211_create_iface(struct i
 		return -1;
 
 	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
-		    0, NL80211_CMD_ADD_VIRTUAL_INTERFACE, 0);
+		    0, NL80211_CMD_NEW_INTERFACE, 0);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX,
 		    if_nametoindex(drv->hapd->conf->iface));
 	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, ifname);


