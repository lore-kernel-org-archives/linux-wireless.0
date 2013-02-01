Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab3BAVkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 16:40:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: track hidden SSID networks properly
Date: Fri,  1 Feb 2013 22:40:37 +0100
Message-Id: <1359754837-1271-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_224022_738976_09E79D21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, cfg80211 will copy beacon IEs from a previously
received hidden SSID beacon to a probe response entry, if
that entry is created after the beacon entry. However, if
it is the other way around, or if the beacon is updated,
such changes aren't propagated.

Fix this by tracking the relation between the probe
response and beacon BSS structs in this case.

In case drivers have private data stored in a BSS struct
and need access to such data from a beacon entry, cfg80211
now provides the hidden_beacon_bss pointer from the probe
response entry to the beacon entry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |   9 ++
 net/wireless/core.h    |   4 +-
 net/wireless/scan.c    | 273 +++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 232 insertions(+), 54 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f781a5e..532ce29 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1299,7 +1299,14 @@ struct cfg80211_bss_ies {
  *	either the beacon_ies or proberesp_ies depending on whether Probe
  *	Response frame has been received
  * @beacon_ies: the information elements from the last Beacon frame
+ *	(implementation note: if @hidden_beacon_bss is set this struct doesn't
+ *	own the beacon_ies, but they're just pointers to the ones from the
+ *	@hidden_beacon_bss struct)
  * @proberesp_ies: the information elements from the last Probe Response frame
+ * @hidden_beacon_bss: in case this BSS struct represents a probe response from
+ *	a BSS that hides the SSID in its beacon, this points to the BSS struct
+ *	that holds the beacon data. @beacon_ies is still valid, of course, and
+ *	points to the same data as hidden_beacon_bss->beacon_ies in that case.
  * @signal: signal strength value (type depends on the wiphy's signal_type)
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
@@ -1312,6 +1319,8 @@ struct cfg80211_bss {
 	const struct cfg80211_bss_ies __rcu *beacon_ies;
 	const struct cfg80211_bss_ies __rcu *proberesp_ies;
 
+	struct cfg80211_bss *hidden_beacon_bss;
+
 	s32 signal;
 
 	u16 beacon_interval;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 8396f76..37d70dc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -8,7 +8,6 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
-#include <linux/kref.h>
 #include <linux/rbtree.h>
 #include <linux/debugfs.h>
 #include <linux/rfkill.h>
@@ -124,9 +123,10 @@ static inline void assert_cfg80211_lock(void)
 
 struct cfg80211_internal_bss {
 	struct list_head list;
+	struct list_head hidden_list;
 	struct rb_node rbn;
 	unsigned long ts;
-	struct kref ref;
+	unsigned long refcount;
 	atomic_t hold;
 
 	/* must be last because of priv member */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index dacb44a..5e0983d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -19,46 +19,124 @@
 #include "wext-compat.h"
 #include "rdev-ops.h"
 
+/**
+ * DOC: BSS tree/list structure
+ *
+ * At the top level, the BSS list is kept in both a list in each
+ * registered device (@bss_list) as well as an RB-tree for faster
+ * lookup. In the RB-tree, entries can be looked up using their
+ * channel, MESHID, MESHCONF (for MBSSes) or channel, BSSID, SSID
+ * for other BSSes.
+ *
+ * Due to the possibility of hidden SSIDs, there's a second level
+ * structure, the "hidden_list" and "hidden_beacon_bss" pointer.
+ * The hidden_list connects all BSSes belonging to a single AP
+ * that has a hidden SSID, and connects beacon and probe response
+ * entries. For a probe response entry for a hidden SSID, the
+ * hidden_beacon_bss pointer points to the BSS struct holding the
+ * beacon's information.
+ *
+ * Reference counting is done for all these references except for
+ * the hidden_list, so that a beacon BSS struct that is otherwise
+ * not referenced has one reference for being on the bss_list and
+ * one for each probe response entry that points to it using the
+ * hidden_beacon_bss pointer. When a BSS struct that has such a
+ * pointer is get/put, the refcount update is also propagated to
+ * the referenced struct, this ensure that it cannot get removed
+ * while somebody is using the probe response version.
+ *
+ * Note that the hidden_beacon_bss pointer never changes, due to
+ * the reference counting. Therefore, no locking is needed for
+ * it.
+ *
+ * Also note that the hidden_beacon_bss pointer is only relevant
+ * if the driver uses something other than the IEs, e.g. private
+ * data stored stored in the BSS struct, since the beacon IEs are
+ * also linked into the probe response struct.
+ */
+
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
-static void bss_release(struct kref *ref)
+static void bss_free(struct cfg80211_internal_bss *bss)
 {
 	struct cfg80211_bss_ies *ies;
-	struct cfg80211_internal_bss *bss;
-
-	bss = container_of(ref, struct cfg80211_internal_bss, ref);
 
 	if (WARN_ON(atomic_read(&bss->hold)))
 		return;
 
 	ies = (void *)rcu_access_pointer(bss->pub.beacon_ies);
-	if (ies)
+	if (ies && !bss->pub.hidden_beacon_bss)
 		kfree_rcu(ies, rcu_head);
 	ies = (void *)rcu_access_pointer(bss->pub.proberesp_ies);
 	if (ies)
 		kfree_rcu(ies, rcu_head);
 
+	/*
+	 * This happens when the module is removed, it doesn't
+	 * really matter any more save for completeness
+	 */
+	if (!list_empty(&bss->hidden_list))
+		list_del(&bss->hidden_list);
+
 	kfree(bss);
 }
 
-static inline void bss_ref_get(struct cfg80211_internal_bss *bss)
+static inline void bss_ref_get(struct cfg80211_registered_device *dev,
+			       struct cfg80211_internal_bss *bss)
 {
-	kref_get(&bss->ref);
+	lockdep_assert_held(&dev->bss_lock);
+
+	bss->refcount++;
+	if (bss->pub.hidden_beacon_bss) {
+		bss = container_of(bss->pub.hidden_beacon_bss,
+				   struct cfg80211_internal_bss,
+				   pub);
+		bss->refcount++;
+	}
 }
 
-static inline void bss_ref_put(struct cfg80211_internal_bss *bss)
+static inline void bss_ref_put(struct cfg80211_registered_device *dev,
+			       struct cfg80211_internal_bss *bss)
 {
-	kref_put(&bss->ref, bss_release);
+	lockdep_assert_held(&dev->bss_lock);
+
+	if (bss->pub.hidden_beacon_bss) {
+		struct cfg80211_internal_bss *hbss;
+		hbss = container_of(bss->pub.hidden_beacon_bss,
+				    struct cfg80211_internal_bss,
+				    pub);
+		hbss->refcount--;
+		if (hbss->refcount == 0)
+			bss_free(hbss);
+	}
+	bss->refcount--;
+	if (bss->refcount == 0)
+		bss_free(bss);
 }
 
-static void __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
+static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *dev,
 				  struct cfg80211_internal_bss *bss)
 {
 	lockdep_assert_held(&dev->bss_lock);
 
+	if (!list_empty(&bss->hidden_list)) {
+		/*
+		 * don't remove the beacon entry if it has
+		 * probe responses associated with it
+		 */
+		if (!bss->pub.hidden_beacon_bss)
+			return false;
+		/*
+		 * if it's a probe response entry break its
+		 * link to the other entries in the group
+		 */
+		list_del_init(&bss->hidden_list);
+	}
+
 	list_del_init(&bss->list);
 	rb_erase(&bss->rbn, &dev->bss_tree);
-	bss_ref_put(bss);
+	bss_ref_put(dev, bss);
+	return true;
 }
 
 static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
@@ -75,8 +153,8 @@ static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
 		if (!time_after(expire_time, bss->ts))
 			continue;
 
-		__cfg80211_unlink_bss(dev, bss);
-		expired = true;
+		if (__cfg80211_unlink_bss(dev, bss))
+			expired = true;
 	}
 
 	if (expired)
@@ -466,7 +544,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
 			res = bss;
-			bss_ref_get(res);
+			bss_ref_get(dev, res);
 			break;
 		}
 	}
@@ -532,23 +610,67 @@ rb_find_bss(struct cfg80211_registered_device *dev,
 	return NULL;
 }
 
-static void
-copy_hidden_ies(struct cfg80211_internal_bss *res,
-		struct cfg80211_internal_bss *hidden)
+static bool cfg80211_combine_bsses(struct cfg80211_registered_device *dev,
+				   struct cfg80211_internal_bss *new)
 {
 	const struct cfg80211_bss_ies *ies;
+	struct cfg80211_internal_bss *bss;
+	const u8 *ie;
+	int i, ssidlen;
+	u8 fold = 0;
 
-	if (rcu_access_pointer(res->pub.beacon_ies))
-		return;
-
-	ies = rcu_access_pointer(hidden->pub.beacon_ies);
+	ies = rcu_access_pointer(new->pub.beacon_ies);
 	if (WARN_ON(!ies))
-		return;
+		return false;
 
-	ies = kmemdup(ies, sizeof(*ies) + ies->len, GFP_ATOMIC);
-	if (unlikely(!ies))
-		return;
-	rcu_assign_pointer(res->pub.beacon_ies, ies);
+	ie = cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
+	if (!ie) {
+		/* nothing to do */
+		return true;
+	}
+
+	ssidlen = ie[1];
+	for (i = 0; i < ssidlen; i++)
+		fold |= ie[2 + i];
+
+	if (fold) {
+		/* not a hidden SSID */
+		return true;
+	}
+
+	/* This is the bad part ... */
+
+	list_for_each_entry(bss, &dev->bss_list, list) {
+		if (!ether_addr_equal(bss->pub.bssid, new->pub.bssid))
+			continue;
+		if (bss->pub.channel != new->pub.channel)
+			continue;
+		if (rcu_access_pointer(bss->pub.beacon_ies))
+			continue;
+		ies = rcu_access_pointer(bss->pub.ies);
+		if (!ies)
+			continue;
+		ie = cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
+		if (!ie)
+			continue;
+		if (ssidlen && ie[1] != ssidlen)
+			continue;
+		/* that would be odd ... */
+		if (bss->pub.beacon_ies)
+			continue;
+		if (WARN_ON_ONCE(bss->pub.hidden_beacon_bss))
+			continue;
+		if (WARN_ON_ONCE(!list_empty(&bss->hidden_list)))
+			list_del(&bss->hidden_list);
+		/* combine them */
+		list_add(&bss->hidden_list, &new->hidden_list);
+		bss->pub.hidden_beacon_bss = &new->pub;
+		new->refcount += bss->refcount;
+		rcu_assign_pointer(bss->pub.beacon_ies,
+				   new->pub.beacon_ies);
+	}
+
+	return true;
 }
 
 static struct cfg80211_internal_bss *
@@ -594,6 +716,21 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 					  rcu_head);
 		} else if (rcu_access_pointer(tmp->pub.beacon_ies)) {
 			const struct cfg80211_bss_ies *old;
+			struct cfg80211_internal_bss *bss;
+
+			if (found->pub.hidden_beacon_bss &&
+			    !list_empty(&found->hidden_list)) {
+				/*
+				 * The found BSS struct is one of the probe
+				 * response members of a group, but we're
+				 * receiving a beacon (beacon_ies in the tmp
+				 * bss is used). This can only mean that the
+				 * AP changed its beacon from not having an
+				 * SSID to showing it, which is confusing so
+				 * drop this information.
+				 */
+				goto drop;
+			}
 
 			old = rcu_access_pointer(found->pub.beacon_ies);
 
@@ -605,6 +742,18 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				rcu_assign_pointer(found->pub.ies,
 						   tmp->pub.beacon_ies);
 
+			/* Assign beacon IEs to all sub entries */
+			list_for_each_entry(bss, &found->hidden_list,
+					    hidden_list) {
+				const struct cfg80211_bss_ies *ies;
+
+				ies = rcu_access_pointer(bss->pub.beacon_ies);
+				WARN_ON(ies != old);
+
+				rcu_assign_pointer(bss->pub.beacon_ies,
+						   tmp->pub.beacon_ies);
+			}
+
 			if (old)
 				kfree_rcu((struct cfg80211_bss_ies *)old,
 					  rcu_head);
@@ -614,24 +763,6 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		struct cfg80211_internal_bss *hidden;
 		struct cfg80211_bss_ies *ies;
 
-		/* First check if the beacon is a probe response from
-		 * a hidden bss. If so, copy beacon ies (with nullified
-		 * ssid) into the probe response bss entry (with real ssid).
-		 * It is required basically for PSM implementation
-		 * (probe responses do not contain tim ie) */
-
-		/* TODO: The code is not trying to update existing probe
-		 * response bss entries when beacon ies are
-		 * getting changed. */
-		hidden = rb_find_bss(dev, tmp, BSS_CMP_HIDE_ZLEN);
-		if (hidden) {
-			copy_hidden_ies(tmp, hidden);
-		} else {
-			hidden = rb_find_bss(dev, tmp, BSS_CMP_HIDE_NUL);
-			if (hidden)
-				copy_hidden_ies(tmp, hidden);
-		}
-
 		/*
 		 * create a copy -- the "res" variable that is passed in
 		 * is allocated on the stack since it's not needed in the
@@ -646,21 +777,51 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 			ies = (void *)rcu_dereference(tmp->pub.proberesp_ies);
 			if (ies)
 				kfree_rcu(ies, rcu_head);
-			spin_unlock_bh(&dev->bss_lock);
-			return NULL;
+			goto drop;
 		}
 		memcpy(new, tmp, sizeof(*new));
-		kref_init(&new->ref);
+		new->refcount = 1;
+		INIT_LIST_HEAD(&new->hidden_list);
+
+		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
+			hidden = rb_find_bss(dev, tmp, BSS_CMP_HIDE_ZLEN);
+			if (!hidden)
+				hidden = rb_find_bss(dev, tmp,
+						     BSS_CMP_HIDE_NUL);
+			if (hidden) {
+				new->pub.hidden_beacon_bss = &hidden->pub;
+				list_add(&new->hidden_list,
+					 &hidden->hidden_list);
+				hidden->refcount++;
+				rcu_assign_pointer(new->pub.beacon_ies,
+						   hidden->pub.beacon_ies);
+			}
+		} else {
+			/*
+			 * Ok so we found a beacon, and don't have an entry. If
+			 * it's a beacon with hidden SSID, we might be in for an
+			 * expensive search for any probe responses that should
+			 * be grouped with this beacon for updates ...
+			 */
+			if (!cfg80211_combine_bsses(dev, new)) {
+				kfree(new);
+				goto drop;
+			}
+		}
+
 		list_add_tail(&new->list, &dev->bss_list);
 		rb_insert_bss(dev, new);
 		found = new;
 	}
 
 	dev->bss_generation++;
+	bss_ref_get(dev, found);
 	spin_unlock_bh(&dev->bss_lock);
 
-	bss_ref_get(found);
 	return found;
+ drop:
+	spin_unlock_bh(&dev->bss_lock);
+	return NULL;
 }
 
 static struct ieee80211_channel *
@@ -820,25 +981,33 @@ EXPORT_SYMBOL(cfg80211_inform_bss_frame);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
+	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (!pub)
 		return;
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
-	bss_ref_get(bss);
+
+	spin_lock_bh(&dev->bss_lock);
+	bss_ref_get(dev, bss);
+	spin_unlock_bh(&dev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_ref_bss);
 
 void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
+	struct cfg80211_registered_device *dev = wiphy_to_dev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (!pub)
 		return;
 
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
-	bss_ref_put(bss);
+
+	spin_lock_bh(&dev->bss_lock);
+	bss_ref_put(dev, bss);
+	spin_unlock_bh(&dev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_put_bss);
 
@@ -854,8 +1023,8 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 
 	spin_lock_bh(&dev->bss_lock);
 	if (!list_empty(&bss->list)) {
-		__cfg80211_unlink_bss(dev, bss);
-		dev->bss_generation++;
+		if (__cfg80211_unlink_bss(dev, bss))
+			dev->bss_generation++;
 	}
 	spin_unlock_bh(&dev->bss_lock);
 }
-- 
1.8.0

