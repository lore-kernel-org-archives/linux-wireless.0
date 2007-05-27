Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:31481 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXE0OfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2007 10:35:15 -0400
Received: by py-out-1112.google.com with SMTP id a73so2349535pye
        for <linux-wireless@vger.kernel.org>; Sun, 27 May 2007 07:35:15 -0700 (PDT)
Date: Sun, 27 May 2007 23:27:40 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] softmac: use list_for_each_entry
Message-ID: <20070527142740.GB13105@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup using list_for_each_entry.

Cc: John W. Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Joe Jezak <josejx@gentoo.org>
Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 net/ieee80211/softmac/ieee80211softmac_module.c |   32 ++++++++----------------
 1 file changed, 11 insertions(+), 21 deletions(-)

Index: 2.6-mm/net/ieee80211/softmac/ieee80211softmac_module.c
===================================================================
--- 2.6-mm.orig/net/ieee80211/softmac/ieee80211softmac_module.c
+++ 2.6-mm/net/ieee80211/softmac/ieee80211softmac_module.c
@@ -456,18 +456,13 @@ void
 ieee80211softmac_add_network_locked(struct ieee80211softmac_device *mac,
 	struct ieee80211softmac_network *add_net)
 {
-	struct list_head *list_ptr;
-	struct ieee80211softmac_network *softmac_net = NULL;
+	struct ieee80211softmac_network *softmac_net;
 
-	list_for_each(list_ptr, &mac->network_list) {
-		softmac_net = list_entry(list_ptr, struct ieee80211softmac_network, list);
+	list_for_each_entry(softmac_net, &mac->network_list, list) {
 		if(!memcmp(softmac_net->bssid, add_net->bssid, ETH_ALEN))
-			break;
-		else
-			softmac_net = NULL;
+			return;
 	}
-	if(softmac_net == NULL)
-		list_add(&(add_net->list), &mac->network_list);
+	list_add(&(add_net->list), &mac->network_list);
 }
 
 /* Add a network to the list, with locking */
@@ -506,16 +501,13 @@ struct ieee80211softmac_network *
 ieee80211softmac_get_network_by_bssid_locked(struct ieee80211softmac_device *mac,
 	u8 *bssid)
 {
-	struct list_head *list_ptr;
-	struct ieee80211softmac_network *softmac_net = NULL;
-	list_for_each(list_ptr, &mac->network_list) {
-		softmac_net = list_entry(list_ptr, struct ieee80211softmac_network, list);
+	struct ieee80211softmac_network *softmac_net;
+
+	list_for_each_entry(softmac_net, &mac->network_list, list) {
 		if(!memcmp(softmac_net->bssid, bssid, ETH_ALEN))
-			break;
-		else
-			softmac_net = NULL;
+			return softmac_net;
 	}
-	return softmac_net;
+	return NULL;
 }
 
 /* Get a network from the list by BSSID with locking */
@@ -537,11 +529,9 @@ struct ieee80211softmac_network *
 ieee80211softmac_get_network_by_essid_locked(struct ieee80211softmac_device *mac,
 	struct ieee80211softmac_essid *essid)
 {
-	struct list_head *list_ptr;
-	struct ieee80211softmac_network *softmac_net = NULL;
+	struct ieee80211softmac_network *softmac_net;
 
-	list_for_each(list_ptr, &mac->network_list) {
-		softmac_net = list_entry(list_ptr, struct ieee80211softmac_network, list);
+	list_for_each_entry(softmac_net, &mac->network_list, list) {
 		if (softmac_net->essid.len == essid->len &&
 			!memcmp(softmac_net->essid.data, essid->data, essid->len))
 			return softmac_net;
