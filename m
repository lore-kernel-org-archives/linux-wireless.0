Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbXHUPEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:04:31 -0400
Message-Id: <20070821150052.565594000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 27/27] mac80211: use switch statement in tx code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The transmit code needs to set the addresses depending on the
interface type, a likely() for AP/VLAN is quite wrong since
most people will be using STA; convert to a switch statement
to make it look nicer.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/tx.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- wireless-dev.orig/net/mac80211/tx.c	2007-08-21 15:48:54.925923881 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-21 16:04:00.675923881 +0200
@@ -1363,15 +1363,17 @@ int ieee80211_subif_start_xmit(struct sk
 	/* TODO: handling for 802.1x authorized/unauthorized port */
 	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA;
 
-	if (likely(sdata->type == IEEE80211_IF_TYPE_AP ||
-		   sdata->type == IEEE80211_IF_TYPE_VLAN)) {
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_AP:
+	case IEEE80211_IF_TYPE_VLAN:
 		fc |= IEEE80211_FCTL_FROMDS;
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 24;
-	} else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
+		break;
+	case IEEE80211_IF_TYPE_WDS:
 		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
 		/* RA TA DA SA */
 		memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
@@ -1379,7 +1381,8 @@ int ieee80211_subif_start_xmit(struct sk
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
-	} else if (sdata->type == IEEE80211_IF_TYPE_STA) {
+		break;
+	case IEEE80211_IF_TYPE_STA:
 		if (dls_link_status(local, skb->data) == DLS_STATUS_OK) {
 			/* DA SA BSSID */
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -1393,13 +1396,15 @@ int ieee80211_subif_start_xmit(struct sk
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		}
 		hdrlen = 24;
-	} else if (sdata->type == IEEE80211_IF_TYPE_IBSS) {
+		break;
+	case IEEE80211_IF_TYPE_IBSS:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 		memcpy(hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
 		hdrlen = 24;
-	} else {
+		break;
+	default:
 		ret = 0;
 		goto fail;
 	}

-- 

