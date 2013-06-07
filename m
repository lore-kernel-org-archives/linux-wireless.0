Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:58230 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3FGNgW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [RFC 1/5] mac80211: introduce __ieee80211_assign_perm_addr
Date: Fri,  7 Jun 2013 15:36:15 +0200
Message-Id: <1370612179-24385-2-git-send-email-moorray3@wp.pl> (sfid-20130607_153630_826838_D9A364A4)
In-Reply-To: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Move code from the default case of the big switch in
ieee80211_assign_perm_addr into a separate function.
It will be handy later.

No functional changes.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/iface.c | 169 ++++++++++++++++++++++++++-------------------------
 1 file changed, 87 insertions(+), 82 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a7eba16..dbee397 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1425,8 +1425,8 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
-				       u8 *perm_addr, enum nl80211_iftype type)
+static void __ieee80211_assign_perm_addr(struct ieee80211_local *local,
+					 u8 *perm_addr)
 {
 	struct ieee80211_sub_if_data *sdata;
 	u64 mask, start, addr, val, inc;
@@ -1434,6 +1434,90 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	u8 tmp_addr[ETH_ALEN];
 	int i;
 
+	/* assign a new address if possible -- try n_addresses first */
+	for (i = 0; i < local->hw.wiphy->n_addresses; i++) {
+		bool used = false;
+
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (memcmp(local->hw.wiphy->addresses[i].addr,
+				   sdata->vif.addr, ETH_ALEN) == 0) {
+				used = true;
+				break;
+			}
+		}
+
+		if (!used) {
+			memcpy(perm_addr, local->hw.wiphy->addresses[i].addr,
+			       ETH_ALEN);
+			break;
+		}
+	}
+
+	/* try mask if available */
+	if (is_zero_ether_addr(local->hw.wiphy->addr_mask))
+		return;
+
+	m = local->hw.wiphy->addr_mask;
+	mask =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+		((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+		((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+	if (__ffs64(mask) + hweight64(mask) != fls64(mask)) {
+		/* not a contiguous mask ... not handled now! */
+		pr_info("not contiguous\n");
+		return;
+	}
+
+	/*
+	 * Pick address of existing interface in case user changed
+	 * MAC address manually, default to perm_addr.
+	 */
+	m = local->hw.wiphy->perm_addr;
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+			continue;
+		m = sdata->vif.addr;
+		break;
+	}
+	start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+		((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+		((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+	inc = 1ULL<<__ffs64(mask);
+	val = (start & mask);
+	addr = (start & ~mask) | (val & mask);
+	do {
+		bool used = false;
+
+		tmp_addr[5] = addr >> 0*8;
+		tmp_addr[4] = addr >> 1*8;
+		tmp_addr[3] = addr >> 2*8;
+		tmp_addr[2] = addr >> 3*8;
+		tmp_addr[1] = addr >> 4*8;
+		tmp_addr[0] = addr >> 5*8;
+
+		val += inc;
+
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (memcmp(tmp_addr, sdata->vif.addr, ETH_ALEN) == 0) {
+				used = true;
+				break;
+			}
+		}
+
+		if (!used) {
+			memcpy(perm_addr, tmp_addr, ETH_ALEN);
+			break;
+		}
+		addr = (start & ~mask) | (val & mask);
+	} while (addr != start);
+}
+
+static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
+				       u8 *perm_addr, enum nl80211_iftype type)
+{
+	struct ieee80211_sub_if_data *sdata;
+
 	/* default ... something at least */
 	memcpy(perm_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 
@@ -1472,86 +1556,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		}
 		/* otherwise fall through */
 	default:
-		/* assign a new address if possible -- try n_addresses first */
-		for (i = 0; i < local->hw.wiphy->n_addresses; i++) {
-			bool used = false;
-
-			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(local->hw.wiphy->addresses[i].addr,
-					   sdata->vif.addr, ETH_ALEN) == 0) {
-					used = true;
-					break;
-				}
-			}
-
-			if (!used) {
-				memcpy(perm_addr,
-				       local->hw.wiphy->addresses[i].addr,
-				       ETH_ALEN);
-				break;
-			}
-		}
-
-		/* try mask if available */
-		if (is_zero_ether_addr(local->hw.wiphy->addr_mask))
-			break;
-
-		m = local->hw.wiphy->addr_mask;
-		mask =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
-			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
-			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
-
-		if (__ffs64(mask) + hweight64(mask) != fls64(mask)) {
-			/* not a contiguous mask ... not handled now! */
-			pr_info("not contiguous\n");
-			break;
-		}
-
-		/*
-		 * Pick address of existing interface in case user changed
-		 * MAC address manually, default to perm_addr.
-		 */
-		m = local->hw.wiphy->perm_addr;
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
-				continue;
-			m = sdata->vif.addr;
-			break;
-		}
-		start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
-			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
-			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
-
-		inc = 1ULL<<__ffs64(mask);
-		val = (start & mask);
-		addr = (start & ~mask) | (val & mask);
-		do {
-			bool used = false;
-
-			tmp_addr[5] = addr >> 0*8;
-			tmp_addr[4] = addr >> 1*8;
-			tmp_addr[3] = addr >> 2*8;
-			tmp_addr[2] = addr >> 3*8;
-			tmp_addr[1] = addr >> 4*8;
-			tmp_addr[0] = addr >> 5*8;
-
-			val += inc;
-
-			list_for_each_entry(sdata, &local->interfaces, list) {
-				if (memcmp(tmp_addr, sdata->vif.addr,
-							ETH_ALEN) == 0) {
-					used = true;
-					break;
-				}
-			}
-
-			if (!used) {
-				memcpy(perm_addr, tmp_addr, ETH_ALEN);
-				break;
-			}
-			addr = (start & ~mask) | (val & mask);
-		} while (addr != start);
-
+		__ieee80211_assign_perm_addr(local, perm_addr);
 		break;
 	}
 
-- 
1.8.1.4

