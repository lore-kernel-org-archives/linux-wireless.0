Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:64068 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3EUMyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 08:54:19 -0400
Received: by mail-qc0-f172.google.com with SMTP id z1so304595qcx.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 May 2013 05:54:18 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, IvDoorn@gmail.com, gwingerde@gmail.com,
	stf_xl@wp.pl, Helmut Schaa <helmut.schaa@googlemail.com>,
	Alessandro Lannocca <alessandro.lannocca@gmail.com>,
	Bruno Randolf <br1@thinktube.com>
Subject: [PATCH] mac80211: Allow single vif mac address change with addr_mask
Date: Tue, 21 May 2013 14:54:53 +0200
Message-Id: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20130521_145422_616063_3B409A2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When changing the MAC address of a single vif mac80211 will check if the new
address fits into the address mask specified by the driver. This only needs
to be done when using multiple BSSIDs. Hence, check the new address only
against all other vifs.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=57371

Reported-by: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Cc: Alessandro Lannocca <alessandro.lannocca@gmail.com>
Cc: Bruno Randolf <br1@thinktube.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/iface.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..c1a8c79 100644
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
+			continue;
+
+		if (iter->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
 
-		m = sdata->vif.addr;
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
 
-- 
1.7.10.4

