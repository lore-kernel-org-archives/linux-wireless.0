Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35797 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab0GQN7M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 09:59:12 -0400
Message-ID: <4C41B72B.8020306@openwrt.org>
Date: Sat, 17 Jul 2010 15:59:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix aggregation action frame handling with AP VLANs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When aggregation related action frames are enqueued for further work,
and they originate from a STA that is part of an AP VLAN, they are
currently enqueued for the AP interface. This breaks the sta_info_get()
lookup in the actual work function, and because of that, aggregation
sessions are not established for this STA.

Fix this by replacing the sta_info_get call with a call to
sta_info_get_bss.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -756,7 +756,7 @@ static void ieee80211_iface_work(struct 
 			int len = skb->len;
 
 			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get(sdata, mgmt->sa);
+			sta = sta_info_get_bss(sdata, mgmt->sa);
 			if (sta) {
 				switch (mgmt->u.action.u.addba_req.action_code) {
 				case WLAN_ACTION_ADDBA_REQ:
@@ -797,7 +797,7 @@ static void ieee80211_iface_work(struct 
 			 * right, so terminate the session.
 			 */
 			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get(sdata, mgmt->sa);
+			sta = sta_info_get_bss(sdata, mgmt->sa);
 			if (sta) {
 				u16 tid = *ieee80211_get_qos_ctl(hdr) &
 						IEEE80211_QOS_CTL_TID_MASK;
