Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:36515 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3EUPvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 11:51:44 -0400
Received: by mail-ea0-f179.google.com with SMTP id z16so499603ead.24
        for <linux-wireless@vger.kernel.org>; Tue, 21 May 2013 08:51:43 -0700 (PDT)
From: "Alessandro Lannocca" <alessandro.lannocca@gmail.com>
To: "'Helmut Schaa'" <helmut.schaa@googlemail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
Subject: R: [PATCH] mac80211: Allow single vif mac address change with addr_mask
Date: Tue, 21 May 2013 17:51:38 +0200
Message-ID: <000d01ce563b$15810800$40831800$@gmail.com> (sfid-20130521_175147_654833_9487B5CB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested right now against compat-drivers-2013-03-28-5-u and I can confirm it
works.

Thank you for your effort!

Alessandro Lannocca

-----Messaggio originale-----
Da: Helmut Schaa [mailto:helmut.schaa@googlemail.com] 
Inviato: martedì 21 maggio 2013 14.55
A: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net; IvDoorn@gmail.com; gwingerde@gmail.com;
stf_xl@wp.pl; Helmut Schaa; Alessandro Lannocca; Bruno Randolf
Oggetto: [PATCH] mac80211: Allow single vif mac address change with
addr_mask

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

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c index
60f1ce5..c1a8c79 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -159,9 +159,10 @@ static int ieee80211_change_mtu(struct net_device *dev,
int new_mtu)
 	return 0;
 }
 
-static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
+static int ieee80211_verify_mac(struct ieee80211_sub_if_data *sdata, u8 
+*addr)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *iter;
 	u64 new, mask, tmp;
 	u8 *m;
 	int ret = 0;
@@ -181,11 +182,14 @@ static int ieee80211_verify_mac(struct ieee80211_local
*local, u8 *addr)
 
 
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
 			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8); @@ -209,7
+213,7 @@ static int ieee80211_change_mac(struct net_device *dev, void
*addr)
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
+	ret = ieee80211_verify_mac(sdata, sa->sa_data);
 	if (ret)
 		return ret;
 
--
1.7.10.4


