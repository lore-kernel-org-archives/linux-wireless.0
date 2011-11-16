Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49989 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab1KPOAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:00:37 -0500
Received: by yenq3 with SMTP id q3so1979367yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 06:00:36 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 16 Nov 2011 15:00:36 +0100
Message-ID: <CAMG6FYg38voWUWtKJ-4dRnv+MS=JqXL+q6A+Pc=mbsbDpMOusQ@mail.gmail.com> (sfid-20111116_150041_059201_735F0AD7)
Subject: [RFC] cfg80211: more correct support of multi-essid bss-es
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More correct implementation of the same idea as in the
"cfg80211: merge in beacon ies of hidden bss" commit.

The patch implements linked list of aliases for bss (alias is a bss
with the same key information but with different ESSID).
Ie update rules when new beacon/proberesp is coming:
 - Beacon updates target bss and aliases with empty beacon ies list.
 - Probe response ies updates only target bss structure.
 - Beacon ies of incoming probe response are filled with
   beacon ies taken from an alias.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 net/wireless/core.h |    1 +
 net/wireless/scan.c |  287 ++++++++++++++++++++++----------------------------
 2 files changed, 127 insertions(+), 161 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 1c7d4df..9a08dcb 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -128,6 +128,7 @@ static inline void assert_cfg80211_lock(void)

 struct cfg80211_internal_bss {
 	struct list_head list;
+	struct list_head list_aliases;
 	struct rb_node rbn;
 	unsigned long ts;
 	struct kref ref;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 31119e3..bca8602 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -191,6 +191,8 @@ static void __cfg80211_unlink_bss(struct
cfg80211_registered_device *dev,
 				  struct cfg80211_internal_bss *bss)
 {
 	list_del_init(&bss->list);
+	if (!list_empty(&bss->list_aliases))
+		list_del_init(&bss->list_aliases);
 	rb_erase(&bss->rbn, &dev->bss_tree);
 	kref_put(&bss->ref, bss_release);
 }
@@ -355,8 +357,8 @@ static bool is_mesh(struct cfg80211_bss *a,
 	    sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
 }

-static int cmp_bss_core(struct cfg80211_bss *a,
-			struct cfg80211_bss *b)
+static int cmp_bss_noessid(struct cfg80211_bss *a,
+			   struct cfg80211_bss *b)
 {
 	int r;

@@ -386,7 +388,7 @@ static int cmp_bss(struct cfg80211_bss *a,
 {
 	int r;

-	r = cmp_bss_core(a, b);
+	r = cmp_bss_noessid(a, b);
 	if (r)
 		return r;

@@ -397,52 +399,6 @@ static int cmp_bss(struct cfg80211_bss *a,
 		       b->len_information_elements);
 }

-static int cmp_hidden_bss(struct cfg80211_bss *a,
-		   struct cfg80211_bss *b)
-{
-	const u8 *ie1;
-	const u8 *ie2;
-	int i;
-	int r;
-
-	r = cmp_bss_core(a, b);
-	if (r)
-		return r;
-
-	ie1 = cfg80211_find_ie(WLAN_EID_SSID,
-			a->information_elements,
-			a->len_information_elements);
-	ie2 = cfg80211_find_ie(WLAN_EID_SSID,
-			b->information_elements,
-			b->len_information_elements);
-
-	/* Key comparator must use same algorithm in any rb-tree
-	 * search function (order is important), otherwise ordering
-	 * of items in the tree is broken and search gives incorrect
-	 * results. This code uses same order as cmp_ies() does. */
-
-	/* sort missing IE before (left of) present IE */
-	if (!ie1)
-		return -1;
-	if (!ie2)
-		return 1;
-
-	/* zero-size SSID is used as an indication of the hidden bss */
-	if (!ie2[1])
-		return 0;
-
-	/* sort by length first, then by contents */
-	if (ie1[1] != ie2[1])
-		return ie2[1] - ie1[1];
-
-	/* zeroed SSID ie is another indication of a hidden bss */
-	for (i = 0; i < ie2[1]; i++)
-		if (ie2[i + 2])
-			return -1;
-
-	return 0;
-}
-
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
@@ -559,7 +515,7 @@ rb_find_bss(struct cfg80211_registered_device *dev,
 }

 static struct cfg80211_internal_bss *
-rb_find_hidden_bss(struct cfg80211_registered_device *dev,
+rb_find_bss_alias(struct cfg80211_registered_device *dev,
 	    struct cfg80211_internal_bss *res)
 {
 	struct rb_node *n = dev->bss_tree.rb_node;
@@ -568,7 +524,7 @@ rb_find_hidden_bss(struct cfg80211_registered_device *dev,

 	while (n) {
 		bss = rb_entry(n, struct cfg80211_internal_bss, rbn);
-		r = cmp_hidden_bss(&res->pub, &bss->pub);
+		r = cmp_bss_noessid(&res->pub, &bss->pub);

 		if (r == 0)
 			return bss;
@@ -582,29 +538,120 @@ rb_find_hidden_bss(struct
cfg80211_registered_device *dev,
 }

 static void
-copy_hidden_ies(struct cfg80211_internal_bss *res,
-		 struct cfg80211_internal_bss *hidden)
+cfg80211_bss_update_bss(struct cfg80211_registered_device *dev,
+			 struct cfg80211_internal_bss *prev,
+			 struct cfg80211_internal_bss *res,
+			 int force)
 {
-	if (unlikely(res->pub.beacon_ies))
-		return;
-	if (WARN_ON(!hidden->pub.beacon_ies))
-		return;
+	prev->pub.beacon_interval = res->pub.beacon_interval;
+	prev->pub.tsf = res->pub.tsf;
+	prev->pub.signal = res->pub.signal;
+	prev->pub.capability = res->pub.capability;
+	prev->ts = res->ts;
+
+	/* Update IEs */
+	if (res->pub.proberesp_ies && (force || !prev->pub.proberesp_ies)) {
+		size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
+		size_t ielen = res->pub.len_proberesp_ies;
+
+		if (prev->pub.proberesp_ies &&
+		    !prev->proberesp_ies_allocated &&
+		    ksize(prev) >= used + ielen) {
+			memcpy(prev->pub.proberesp_ies,
+			       res->pub.proberesp_ies, ielen);
+			prev->pub.len_proberesp_ies = ielen;
+		} else {
+			u8 *ies = prev->pub.proberesp_ies;
+
+			if (prev->proberesp_ies_allocated)
+				ies = krealloc(ies, ielen, GFP_ATOMIC);
+			else
+				ies = kmalloc(ielen, GFP_ATOMIC);
+
+			if (ies) {
+				memcpy(ies, res->pub.proberesp_ies,
+				       ielen);
+				prev->proberesp_ies_allocated = true;
+				prev->pub.proberesp_ies = ies;
+				prev->pub.len_proberesp_ies = ielen;
+			}
+		}

-	res->pub.beacon_ies = kmalloc(hidden->pub.len_beacon_ies, GFP_ATOMIC);
-	if (unlikely(!res->pub.beacon_ies))
-		return;
+		/* Override possible earlier Beacon frame IEs */
+		prev->pub.information_elements =
+			prev->pub.proberesp_ies;
+		prev->pub.len_information_elements =
+			prev->pub.len_proberesp_ies;
+	}
+	if (res->pub.beacon_ies && (force || !prev->pub.beacon_ies)) {
+		size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
+		size_t ielen = res->pub.len_beacon_ies;
+		bool information_elements_is_beacon_ies =
+			(prev->pub.information_elements ==
+			 prev->pub.beacon_ies);
+
+		if (prev->pub.beacon_ies &&
+		    !prev->beacon_ies_allocated &&
+		    ksize(prev) >= used + ielen) {
+			memcpy(prev->pub.beacon_ies,
+			       res->pub.beacon_ies, ielen);
+			prev->pub.len_beacon_ies = ielen;
+		} else {
+			u8 *ies = prev->pub.beacon_ies;
+
+			if (prev->beacon_ies_allocated)
+				ies = krealloc(ies, ielen, GFP_ATOMIC);
+			else
+				ies = kmalloc(ielen, GFP_ATOMIC);
+
+			if (ies) {
+				memcpy(ies, res->pub.beacon_ies,
+				       ielen);
+				prev->beacon_ies_allocated = true;
+				prev->pub.beacon_ies = ies;
+				prev->pub.len_beacon_ies = ielen;
+			}
+		}
+
+		/* Override IEs if they were from a beacon before */
+		if (information_elements_is_beacon_ies) {
+			prev->pub.information_elements =
+				prev->pub.beacon_ies;
+			prev->pub.len_information_elements =
+				prev->pub.len_beacon_ies;
+		}
+	}
+}

-	res->beacon_ies_allocated = true;
-	res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
-	memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
-			res->pub.len_beacon_ies);
+static void
+cfg80211_bss_update_list(struct cfg80211_registered_device *dev,
+			 struct cfg80211_internal_bss *prev,
+			 struct cfg80211_internal_bss *res,
+			 int force)
+{
+	struct cfg80211_internal_bss *bss;
+
+	cfg80211_bss_update_bss(dev, prev, res, force);
+	list_for_each_entry(bss, &prev->list_aliases, list_aliases)
+		cfg80211_bss_update_bss(dev, bss, res, force);
+}
+
+static void
+cfg80211_bss_insert(struct cfg80211_registered_device *dev,
+		    struct cfg80211_internal_bss *alias,
+		    struct cfg80211_internal_bss *res)
+{
+	list_add_tail(&res->list, &dev->bss_list);
+	if (alias)
+		list_add_tail(&alias->list_aliases, &res->list_aliases);
+	rb_insert_bss(dev, res);
 }

 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		    struct cfg80211_internal_bss *res)
 {
-	struct cfg80211_internal_bss *found = NULL;
+	struct cfg80211_internal_bss *found = NULL, *alias;

 	/*
 	 * The reference to "res" is donated to this function.
@@ -622,105 +669,21 @@ cfg80211_bss_update(struct
cfg80211_registered_device *dev,
 	found = rb_find_bss(dev, res);

 	if (found) {
-		found->pub.beacon_interval = res->pub.beacon_interval;
-		found->pub.tsf = res->pub.tsf;
-		found->pub.signal = res->pub.signal;
-		found->pub.capability = res->pub.capability;
-		found->ts = res->ts;
-
-		/* Update IEs */
-		if (res->pub.proberesp_ies) {
-			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
-			size_t ielen = res->pub.len_proberesp_ies;
-
-			if (found->pub.proberesp_ies &&
-			    !found->proberesp_ies_allocated &&
-			    ksize(found) >= used + ielen) {
-				memcpy(found->pub.proberesp_ies,
-				       res->pub.proberesp_ies, ielen);
-				found->pub.len_proberesp_ies = ielen;
-			} else {
-				u8 *ies = found->pub.proberesp_ies;
-
-				if (found->proberesp_ies_allocated)
-					ies = krealloc(ies, ielen, GFP_ATOMIC);
-				else
-					ies = kmalloc(ielen, GFP_ATOMIC);
-
-				if (ies) {
-					memcpy(ies, res->pub.proberesp_ies,
-					       ielen);
-					found->proberesp_ies_allocated = true;
-					found->pub.proberesp_ies = ies;
-					found->pub.len_proberesp_ies = ielen;
-				}
-			}
-
-			/* Override possible earlier Beacon frame IEs */
-			found->pub.information_elements =
-				found->pub.proberesp_ies;
-			found->pub.len_information_elements =
-				found->pub.len_proberesp_ies;
-		}
-		if (res->pub.beacon_ies) {
-			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
-			size_t ielen = res->pub.len_beacon_ies;
-			bool information_elements_is_beacon_ies =
-				(found->pub.information_elements ==
-				 found->pub.beacon_ies);
-
-			if (found->pub.beacon_ies &&
-			    !found->beacon_ies_allocated &&
-			    ksize(found) >= used + ielen) {
-				memcpy(found->pub.beacon_ies,
-				       res->pub.beacon_ies, ielen);
-				found->pub.len_beacon_ies = ielen;
-			} else {
-				u8 *ies = found->pub.beacon_ies;
-
-				if (found->beacon_ies_allocated)
-					ies = krealloc(ies, ielen, GFP_ATOMIC);
-				else
-					ies = kmalloc(ielen, GFP_ATOMIC);
-
-				if (ies) {
-					memcpy(ies, res->pub.beacon_ies,
-					       ielen);
-					found->beacon_ies_allocated = true;
-					found->pub.beacon_ies = ies;
-					found->pub.len_beacon_ies = ielen;
-				}
-			}
-
-			/* Override IEs if they were from a beacon before */
-			if (information_elements_is_beacon_ies) {
-				found->pub.information_elements =
-					found->pub.beacon_ies;
-				found->pub.len_information_elements =
-					found->pub.len_beacon_ies;
-			}
-		}
-
+		if (res->pub.beacon_ies)
+			cfg80211_bss_update_list(dev, found, res, 1);
+		else
+			cfg80211_bss_update_bss(dev, found, res, 1);
 		kref_put(&res->ref, bss_release);
 	} else {
-		struct cfg80211_internal_bss *hidden;
-
-		/* First check if the beacon is a probe response from
-		 * a hidden bss. If so, copy beacon ies (with nullified
-		 * ssid) into the probe response bss entry (with real ssid).
-		 * It is required basically for PSM implementation
-		 * (probe responses do not contain tim ie) */
-
-		/* TODO: The code is not trying to update existing probe
-		 * response bss entries when beacon ies are
-		 * getting changed. */
-		hidden = rb_find_hidden_bss(dev, res);
-		if (hidden)
-			copy_hidden_ies(res, hidden);
-
+		alias = rb_find_bss_alias(dev, res);
+		if (alias) {
+			if (res->pub.beacon_ies)
+				cfg80211_bss_update_list(dev, alias, res, 0);
+			else
+				cfg80211_bss_update_bss(dev, res, alias, 0);
+		}
 		/* this "consumes" the reference */
-		list_add_tail(&res->list, &dev->bss_list);
-		rb_insert_bss(dev, res);
+		cfg80211_bss_insert(dev, alias, res);
 		found = res;
 	}

@@ -761,6 +724,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	res->pub.tsf = timestamp;
 	res->pub.beacon_interval = beacon_interval;
 	res->pub.capability = capability;
+	INIT_LIST_HEAD(&res->list_aliases);
 	/*
 	 * Since we do not know here whether the IEs are from a Beacon or Probe
 	 * Response frame, we need to pick one of the options and only use it
@@ -828,6 +792,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	res->pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	res->pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	res->pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
+	INIT_LIST_HEAD(&res->list_aliases);
 	/*
 	 * The initial buffer for the IEs is allocated with the BSS entry and
 	 * is located after the private area.
-- 

With best regards,
Dmitry Tarnyagin
