Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50199 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab1KDQMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 12:12:08 -0400
Received: by qyk2 with SMTP id 2so2135128qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 09:12:07 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Nov 2011 17:12:07 +0100
Message-ID: <CAMG6FYhbX+zKRw823RmPzwXqVzP7c+5W8pAaR4DGsOm0qnZGpA@mail.gmail.com> (sfid-20111104_171212_230697_F4323BFB)
Subject: [PATCH v3] cfg80211: merge in beacon ies of hidden bss.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The problem with PSM when a hidden SSID was used was originally
reported by Juuso Oikarinen.

 - When generally scanning, the AP is getting a bss entry with
   a zero SSID.
 - When associationg, a probe-req is sent to the AP with the SSID,
   and as a result a probe-responseis received with the hidden
   SSID in place. As a consequence, a second bss entry is created
   for the AP, now with the real SSID.
 - After association, mac80211 executes ieee80211_recalc_ps(),
   but does not switch to powersave because the beacon-ies are missing.

As result, the STA does not ever enter PSM.

The patch merges in beacon ies of hidden bss from beacon to the probe
response, creating a consistant set of ies in place.

Patch is depended on "cfg80211: fix cmp_ies" made by Johannes.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 net/wireless/scan.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2ab0aba..87d1432 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -328,8 +328,8 @@ static bool is_mesh(struct cfg80211_bss *a,
 	    sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
 }

-static int cmp_bss(struct cfg80211_bss *a,
-		   struct cfg80211_bss *b)
+static int cmp_bss_core(struct cfg80211_bss *a,
+			struct cfg80211_bss *b)
 {
 	int r;

@@ -351,7 +351,15 @@ static int cmp_bss(struct cfg80211_bss *a,
 			       b->len_information_elements);
 	}

-	r = memcmp(a->bssid, b->bssid, ETH_ALEN);
+	return memcmp(a->bssid, b->bssid, ETH_ALEN);
+}
+
+static int cmp_bss(struct cfg80211_bss *a,
+		   struct cfg80211_bss *b)
+{
+	int r;
+
+	r = cmp_bss_core(a, b);
 	if (r)
 		return r;

@@ -362,6 +370,52 @@ static int cmp_bss(struct cfg80211_bss *a,
 		       b->len_information_elements);
 }

+static int cmp_hidden_bss(struct cfg80211_bss *a,
+		   struct cfg80211_bss *b)
+{
+	const u8 *ie1;
+	const u8 *ie2;
+	int i;
+	int r;
+
+	r = cmp_bss_core(a, b);
+	if (r)
+		return r;
+
+	ie1 = cfg80211_find_ie(WLAN_EID_SSID,
+			a->information_elements,
+			a->len_information_elements);
+	ie2 = cfg80211_find_ie(WLAN_EID_SSID,
+			b->information_elements,
+			b->len_information_elements);
+
+	/* Key comparator must use same algorithm in any rb-tree
+	 * search function (order is important), otherwise ordering
+	 * of items in the tree is broken and search gives incorrect
+	 * results. This code uses same order as cmp_ies() does. */
+
+	/* sort missing IE before (left of) present IE */
+	if (!ie1)
+		return -1;
+	if (!ie2)
+		return 1;
+
+	/* zero-size SSID is used as an indication of the hidden bss */
+	if (!ie2[1])
+		return 0;
+
+	/* sort by length first, then by contents */
+	if (ie1[1] != ie2[1])
+		return ie2[1] - ie1[1];
+
+	/* zeroed SSID ie is another indication of a hidden bss */
+	for (i = 0; i < ie2[1]; i++)
+		if (ie2[i + 2])
+			return -1;
+
+	return 0;
+}
+
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
@@ -478,6 +532,48 @@ rb_find_bss(struct cfg80211_registered_device *dev,
 }

 static struct cfg80211_internal_bss *
+rb_find_hidden_bss(struct cfg80211_registered_device *dev,
+	    struct cfg80211_internal_bss *res)
+{
+	struct rb_node *n = dev->bss_tree.rb_node;
+	struct cfg80211_internal_bss *bss;
+	int r;
+
+	while (n) {
+		bss = rb_entry(n, struct cfg80211_internal_bss, rbn);
+		r = cmp_hidden_bss(&res->pub, &bss->pub);
+
+		if (r == 0)
+			return bss;
+		else if (r < 0)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+
+	return NULL;
+}
+
+static void
+copy_hidden_ies(struct cfg80211_internal_bss *res,
+		 struct cfg80211_internal_bss *hidden)
+{
+	if (unlikely(res->pub.beacon_ies))
+		return;
+	if (WARN_ON(!hidden->pub.beacon_ies))
+		return;
+
+	res->pub.beacon_ies = kmalloc(hidden->pub.len_beacon_ies, GFP_ATOMIC);
+	if (unlikely(!res->pub.beacon_ies))
+		return;
+
+	res->beacon_ies_allocated = true;
+	res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
+	memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
+			res->pub.len_beacon_ies);
+}
+
+static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		    struct cfg80211_internal_bss *res)
 {
@@ -590,6 +686,21 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,

 		kref_put(&res->ref, bss_release);
 	} else {
+		struct cfg80211_internal_bss *hidden;
+
+		/* First check if the beacon is a probe response from
+		 * a hidden bss. If so, copy beacon ies (with nullified
+		 * ssid) into the probe response bss entry (with real ssid).
+		 * It is required basically for PSM implementation
+		 * (probe responses do not contain tim ie) */
+
+		/* TODO: The code is not trying to update existing probe
+		 * response bss entries when beacon ies are
+		 * getting changed. */
+		hidden = rb_find_hidden_bss(dev, res);
+		if (hidden)
+			copy_hidden_ies(res, hidden);
+
 		/* this "consumes" the reference */
 		list_add_tail(&res->list, &dev->bss_list);
 		rb_insert_bss(dev, res);
-- 
With best regards,
Dmitry Tarnyagin
