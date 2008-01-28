Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYA2L3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 06:29:03 -0500
Subject: [PATCH] mac80211: allow sending multicast frames through virtual
	ports
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 17:11:43 +0100
Message-Id: <1201536703.9397.14.camel@johannes.berg> (sfid-20080129_112907_141584_667BAFA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When reworking the port access control code, I forgot multicast frames
and those are now always rejected because the destination station is
not known. This changes the code to allow through multicast frames and
also avoid the sta hash lookup (which is bound to fail) for them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Even though this is a fix, there's no need to apply this patch to
non-development kernels, the problem cannot trigger unless you're
in master mode which isn't supported yet.

 net/mac80211/tx.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-01-25 13:39:39.446496582 +0100
+++ everything/net/mac80211/tx.c	2008-01-25 13:43:11.856498535 +0100
@@ -1449,10 +1449,17 @@ int ieee80211_subif_start_xmit(struct sk
 		goto fail;
 	}
 
-	sta = sta_info_get(local, hdr.addr1);
-	if (sta) {
-		sta_flags = sta->flags;
-		sta_info_put(sta);
+	/*
+	 * There's no need to try to look up the destination
+	 * if it is a multicast address (which can only happen
+	 * in AP mode)
+	 */
+	if (!is_multicast_ether_addr(hdr.addr1)) {
+		sta = sta_info_get(local, hdr.addr1);
+		if (sta) {
+			sta_flags = sta->flags;
+			sta_info_put(sta);
+		}
 	}
 
 	/* receiver is QoS enabled, use a QoS type frame */
@@ -1462,10 +1469,12 @@ int ieee80211_subif_start_xmit(struct sk
 	}
 
 	/*
-	 * If port access control is enabled, drop frames to unauthorised
-	 * stations unless they are EAPOL frames from the local station.
+	 * If port access control is enabled, drop unicast frames to
+	 * unauthorised stations unless they are EAPOL frames from the
+	 * local station.
 	 */
 	if (unlikely(sdata->ieee802_1x_pac &&
+		     !is_multicast_ether_addr(hdr.addr1) &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED) &&
 		     !(ethertype == ETH_P_PAE &&
 		       compare_ether_addr(dev->dev_addr,


