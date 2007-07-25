Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27943 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756607AbXGYGvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 02:51:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: use more GFP_KERNEL instead of GFP_ATOMIC
Date: Tue, 24 Jul 2007 23:49:59 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Message-Id: <200707242350.00185.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch replaces atomic allocations with regular ones where possible.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211_sta.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 847e3c9..8296c0c 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -404,7 +404,7 @@ static void ieee80211_sta_send_associnfo(struct net_device *dev,
 		return;
 
 	buf = kmalloc(50 + 2 * (ifsta->assocreq_ies_len +
-				ifsta->assocresp_ies_len), GFP_ATOMIC);
+				ifsta->assocresp_ies_len), GFP_KERNEL);
 	if (!buf)
 		return;
 
@@ -698,7 +698,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
 
 	kfree(ifsta->assocreq_ies);
 	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
-	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_ATOMIC);
+	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_KERNEL);
 	if (ifsta->assocreq_ies)
 		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
 
@@ -1692,7 +1692,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 
 	kfree(ifsta->assocresp_ies);
 	ifsta->assocresp_ies_len = len - (pos - (u8 *) mgmt);
-	ifsta->assocresp_ies = kmalloc(ifsta->assocresp_ies_len, GFP_ATOMIC);
+	ifsta->assocresp_ies = kmalloc(ifsta->assocresp_ies_len, GFP_KERNEL);
 	if (ifsta->assocresp_ies)
 		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
 
@@ -1702,7 +1702,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
 		struct ieee80211_sta_bss *bss;
-		sta = sta_info_add(local, dev, ifsta->bssid, GFP_ATOMIC);
+		sta = sta_info_add(local, dev, ifsta->bssid, GFP_KERNEL);
 		if (!sta) {
 			printk(KERN_DEBUG "%s: failed to add STA entry for the"
 			       " AP\n", dev->name);
@@ -2503,7 +2503,7 @@ static void ieee80211_rx_mgmt_probe_req(struct net_device *dev,
 	}
 
 	/* Reply with ProbeResp */
-	skb = skb_copy(ifsta->probe_resp, GFP_ATOMIC);
+	skb = skb_copy(ifsta->probe_resp, GFP_KERNEL);
 	if (!skb)
 		return;
 
@@ -3911,7 +3911,7 @@ ieee80211_sta_scan_result(struct net_device *dev,
 
 	if (bss) {
 		char *buf;
-		buf = kmalloc(30, GFP_ATOMIC);
+		buf = kmalloc(30, GFP_KERNEL);
 		if (buf) {
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
@@ -3929,7 +3929,7 @@ ieee80211_sta_scan_result(struct net_device *dev,
 		if (!(local->scan_flags & IEEE80211_SCAN_EXTRA_INFO))
 			break;
 
-		buf = kmalloc(100, GFP_ATOMIC);
+		buf = kmalloc(100, GFP_KERNEL);
 		if (!buf)
 			break;
 

