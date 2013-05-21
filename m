Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:50947 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3EUPKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 May 2013 11:10:22 -0400
Date: Tue, 21 May 2013 17:10:18 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	IvDoorn@gmail.com, gwingerde@gmail.com, stf_xl@wp.pl,
	Alessandro Lannocca <alessandro.lannocca@gmail.com>,
	Bruno Randolf <br1@thinktube.com>
Subject: Re: [PATCH] mac80211: Allow single vif mac address change with
 addr_mask
Message-ID: <20130521171018.238056b2@north> (sfid-20130521_171026_273390_478D8325)
In-Reply-To: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
References: <1369140893-22622-1-git-send-email-helmut.schaa@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 21 May 2013 14:54:53 +0200, Helmut Schaa wrote:
> When changing the MAC address of a single vif mac80211 will check if the new
> address fits into the address mask specified by the driver. This only needs
> to be done when using multiple BSSIDs. Hence, check the new address only
> against all other vifs.

Oh, I see that you already posted this patch for review! 

I think we should also take care of the way addresses for new
interfaces are chosen otherwise they'll just pick up
perm_addr and we will end up with incompatible MACs.

I created a patch for a user who reported this problem to
rt2x00 ML independently from Helmut.

--->8------------------

>From 63b32f4509d2c2bcf0ad791faa624b56a1947748 Mon Sep 17 00:00:00 2001
From: Jakub Kicinski <kubakici@wp.pl>
Date: Tue, 21 May 2013 13:05:43 +0200
Subject: [PATCH] mac80211: allow changing mac address on mac-masking devices

Some devices support multiple MAC addresses by
masking last few bits of the address.  Address
compatibility has to be checked only when there
is more than one interface - otherwise we can
just overwrite current address.

While at it fix inverted flow at the end of
ieee80211_change_mac.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/iface.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..367aa3b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -159,8 +159,9 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
+static int ieee80211_verify_mac(struct ieee80211_sub_if_data *target, u8 *addr)
 {
+	struct ieee80211_local *local = target->local;
 	struct ieee80211_sub_if_data *sdata;
 	u64 new, mask, tmp;
 	u8 *m;
@@ -184,6 +185,8 @@ static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
+		if (sdata == target)
+			continue;
 
 		m = sdata->vif.addr;
 		tmp =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
@@ -209,14 +212,15 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
+	ret = ieee80211_verify_mac(sdata, sa->sa_data);
 	if (ret)
 		return ret;
 
 	ret = eth_mac_addr(dev, sa);
+	if (ret)
+		return ret;
 
-	if (ret == 0)
-		memcpy(sdata->vif.addr, sa->sa_data, ETH_ALEN);
+	memcpy(sdata->vif.addr, sa->sa_data, ETH_ALEN);
 
 	return ret;
 }
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
1.8.1.4

