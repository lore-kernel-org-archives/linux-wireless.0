Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:32447 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3FGNgW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 09:36:22 -0400
Received: from 89-71-197-70.dynamic.chello.pl (HELO localhost.localdomain) (moorray3@[89.71.197.70])
          (envelope-sender <moorray3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 7 Jun 2013 15:36:20 +0200
From: Jakub Kicinski <moorray3@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: [RFC 3/5] mac80211: always default to address compatible with mask
Date: Fri,  7 Jun 2013 15:36:17 +0200
Message-Id: <1370612179-24385-4-git-send-email-moorray3@wp.pl> (sfid-20130607_153627_906181_3EC15A43)
In-Reply-To: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Currently default mac address for new interfaces
is set to perm_addr. It can be addr_mask-wise
incompatible with other addresses if user have
changed address of existing interfaces manualy.

This is especially important after introduction
of active monitors. We have to make sure that
monitor interfaces have mac addresses that fall
into addr_mask, otherwise hardware may not
acknowledge frames.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/iface.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 38898b3..1f26980 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1468,17 +1468,7 @@ static void __ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		return;
 	}
 
-	/*
-	 * Pick address of existing interface in case user changed
-	 * MAC address manually, default to perm_addr.
-	 */
-	m = local->hw.wiphy->perm_addr;
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
-			continue;
-		m = sdata->vif.addr;
-		break;
-	}
+	m = perm_addr;
 	start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
 		((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 		((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
@@ -1529,6 +1519,15 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 
 	mutex_lock(&local->iflist_mtx);
 
+	/* After manual mac change default addr may no longer fit into mask. */
+	if (!is_zero_ether_addr(local->hw.wiphy->addr_mask) &&
+	    !list_empty(&local->interfaces)) {
+		sdata = list_first_entry(&local->interfaces,
+					 struct ieee80211_sub_if_data,
+					 list);
+		memcpy(perm_addr, sdata->vif.addr, ETH_ALEN);
+	}
+
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 		/* doesn't matter */
-- 
1.8.1.4

