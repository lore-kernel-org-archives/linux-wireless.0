Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab0BYONP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 09:13:15 -0500
Subject: [PATCH] mac80211: use different MAC addresses for virtual
 interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 15:13:11 +0100
Message-ID: <1267107191.7165.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers can now advertise to cfg80211 that they have
multiple MAC addresses reserved for a device, but we
don't currently make use of that in mac80211.

Change that and assign different addresses to new
virtual interfaces (if addresses are available) in
order to make it easier for users to use multiple
virtual interfaces; they no longer need to always
assign a new MAC address manually.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-02-25 14:15:38.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2010-02-25 14:16:08.000000000 +0100
@@ -815,6 +815,118 @@ int ieee80211_if_change_type(struct ieee
 	return 0;
 }
 
+static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
+				       struct net_device *dev,
+				       enum nl80211_iftype type)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u64 mask, start, addr, val, inc;
+	u8 *m;
+	u8 tmp_addr[ETH_ALEN];
+	int i;
+
+	/* default ... something at least */
+	memcpy(dev->perm_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
+
+	if (is_zero_ether_addr(local->hw.wiphy->addr_mask) &&
+	    local->hw.wiphy->n_addresses <= 1)
+		return;
+
+
+	mutex_lock(&local->iflist_mtx);
+
+	switch (type) {
+	case NL80211_IFTYPE_MONITOR:
+		/* doesn't matter */
+		break;
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_AP_VLAN:
+		/* match up with an AP interface */
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (sdata->vif.type != NL80211_IFTYPE_AP)
+				continue;
+			memcpy(dev->perm_addr, sdata->vif.addr, ETH_ALEN);
+			break;
+		}
+		/* keep default if no AP interface present */
+		break;
+	default:
+		/* assign a new address if possible -- try n_addresses first */
+		for (i = 0; i < local->hw.wiphy->n_addresses; i++) {
+			bool used = false;
+
+			list_for_each_entry(sdata, &local->interfaces, list) {
+				if (memcmp(local->hw.wiphy->addresses[i].addr,
+					   sdata->vif.addr, ETH_ALEN) == 0) {
+					used = true;
+					break;
+				}
+			}
+
+			if (!used) {
+				memcpy(dev->perm_addr,
+				       local->hw.wiphy->addresses[i].addr,
+				       ETH_ALEN);
+				break;
+			}
+		}
+
+		/* try mask if available */
+		if (is_zero_ether_addr(local->hw.wiphy->addr_mask))
+			break;
+
+		m = local->hw.wiphy->addr_mask;
+		mask =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+		if (__ffs64(mask) + hweight64(mask) != fls64(mask)) {
+			/* not a contiguous mask ... not handled now! */
+			printk(KERN_DEBUG "not contiguous\n");
+			break;
+		}
+
+		m = local->hw.wiphy->perm_addr;
+		start = ((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
+			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
+			((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
+
+		inc = 1ULL<<__ffs64(mask);
+		val = (start & mask);
+		addr = (start & ~mask) | (val & mask);
+		do {
+			bool used = false;
+
+			tmp_addr[5] = addr >> 0*8;
+			tmp_addr[4] = addr >> 1*8;
+			tmp_addr[3] = addr >> 2*8;
+			tmp_addr[2] = addr >> 3*8;
+			tmp_addr[1] = addr >> 4*8;
+			tmp_addr[0] = addr >> 5*8;
+
+			val += inc;
+
+			list_for_each_entry(sdata, &local->interfaces, list) {
+				if (memcmp(tmp_addr, sdata->vif.addr,
+							ETH_ALEN) == 0) {
+					used = true;
+					break;
+				}
+			}
+
+			if (!used) {
+				memcpy(dev->perm_addr, tmp_addr, ETH_ALEN);
+				break;
+			}
+			addr = (start & ~mask) | (val & mask);
+		} while (addr != start);
+
+		break;
+	}
+
+	mutex_unlock(&local->iflist_mtx);
+}
+
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params)
@@ -844,8 +956,8 @@ int ieee80211_if_add(struct ieee80211_lo
 	if (ret < 0)
 		goto fail;
 
-	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
-	memcpy(ndev->perm_addr, ndev->dev_addr, ETH_ALEN);
+	ieee80211_assign_perm_addr(local, ndev, type);
+	memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */


