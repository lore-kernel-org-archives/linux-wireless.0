Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28698 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab1DTKtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 06:49:06 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 03:48:40 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] mac80211: Assign locally managed MAC address for each vif
Date: Wed, 20 Apr 2011 16:19:02 +0530
Message-ID: <1303296542-18260-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the chip does not have set of hw mac addresses for each vif,
let's generate a locally managed mac address for the secondary
vifs. By doing this, we can avoid setting hw ether address
before bringing up the interface. The actual hw mac address
is set to the first vif.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/iface.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4054399..ba75e25 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1011,19 +1011,33 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 				       struct net_device *dev,
 				       enum nl80211_iftype type)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata, *ifdata = NULL;
 	u64 mask, start, addr, val, inc;
 	u8 *m;
 	u8 tmp_addr[ETH_ALEN];
-	int i;
+	int i = 0;
 
 	/* default ... something at least */
 	memcpy(dev->perm_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 
 	if (is_zero_ether_addr(local->hw.wiphy->addr_mask) &&
-	    local->hw.wiphy->n_addresses <= 1)
-		return;
+	    local->hw.wiphy->n_addresses <= 1) {
 
+		list_for_each_entry(ifdata, &local->interfaces, list)
+			i++;
+		/*
+		 * XOR virtual interface index into the least significant bits
+		 * to generate a different MAC address for secondary vifs
+		 */
+		if (i) {
+			dev->perm_addr[0] |= 0x02; /* Locally managed address */
+			dev->perm_addr[5] ^= i & 0xff;
+			dev->perm_addr[4] ^= (i & 0xff00) >> 8;
+			dev->perm_addr[3] ^= (i & 0xff0000) >> 16;
+		}
+
+		return;
+	}
 
 	mutex_lock(&local->iflist_mtx);
 
-- 
1.7.4.4

