Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:63057 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3E0ImT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 04:42:19 -0400
Received: by mail-qe0-f42.google.com with SMTP id cz11so3671223qeb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 May 2013 01:42:18 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Jakub Kicinski <kubakici@wp.pl>,
	Alessandro Lannocca <alessandro.lannocca@gmail.com>,
	Bruno Randolf <br1@thinktube.com>
Subject: [PATCHv2] mac80211: Allow single vif mac address change with addr_mask
Date: Mon, 27 May 2013 10:43:09 +0200
Message-Id: <1369644189-13874-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20130527_104222_822726_9A333977)
In-Reply-To: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When changing the MAC address of a single vif mac80211 will check if
the new address fits into the address mask specified by the driver.
This only needs to be done when using multiple BSSIDs. Hence, check
the new address only against all other vifs.

Also fix the MAC address assignment on new interfaces if the user
changed the address of a vif such that perm_addr is not covered by
addr_mask anymore.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=57371

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
Reported-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Cc: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Cc: Bruno Randolf <br1@thinktube.com>
---
 net/mac80211/iface.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..3000cda 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -159,9 +159,10 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
+static int ieee80211_verify_mac(struct ieee80211_sub_if_data *sdata, u8 *addr)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *iter;
 	u64 new, mask, tmp;
 	u8 *m;
 	int ret = 0;
@@ -181,11 +182,14 @@ static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
 
 
 	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+	list_for_each_entry(iter, &local->interfaces, list) {
+		if (iter == sdata)
 			continue;
 
-		m = sdata->vif.addr;
+		if (iter->vif.type == NL80211_IFTYPE_MONITOR)
+			continue;
+
+		m = iter->vif.addr;
 		tmp =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
 			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
@@ -209,7 +213,7 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
+	ret = ieee80211_verify_mac(sdata, sa->sa_data);
 	if (ret)
 		return ret;
 
@@ -1479,7 +1483,17 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			break;
 		}
 
+		/*
+		 * Pick address of existing interface in case user changed
+		 * MAC address manually, default to perm_addr.
+		 */
 		m = local->hw.wiphy->perm_addr;
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+				continue;
+			m = sdata->vif.addr;
+			break;
+		}
 		start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
 			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
-- 
1.7.10.4

