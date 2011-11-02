Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34207 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1KBSTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 14:19:42 -0400
Received: by qyk2 with SMTP id 2so38074qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 11:19:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Nov 2011 19:19:41 +0100
Message-ID: <CAMG6FYiV8F=MFBeUQCGSj__h=REVLMvTZCvLEvDPT7GP2KWsWw@mail.gmail.com> (sfid-20111102_191945_962100_47EF911D)
Subject: [PATCH] cfg80211: merge in beacon ies of hidden bss.
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
   but does not switch to powersave becuse the beacon-ies are missing.

As result, the STA does not ever enter PSM.

The patch merges in beacon ies of hidden bss from beacon to the probe
response, creating a consistant set of ies in place.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 net/wireless/scan.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index dd0d4c5..237e9ed 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -325,8 +325,8 @@ static bool is_mesh(struct cfg80211_bss *a,
 	    sizeof(struct ieee80211_meshconf_ie) - 2) == 0;
 }

-static int cmp_bss(struct cfg80211_bss *a,
-		   struct cfg80211_bss *b)
+static int cmp_bss_core(struct cfg80211_bss *a,
+			struct cfg80211_bss *b)
 {
 	int r;

@@ -348,7 +348,15 @@ static int cmp_bss(struct cfg80211_bss *a,
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

@@ -359,6 +367,38 @@ static int cmp_bss(struct cfg80211_bss *a,
 		       b->len_information_elements);
 }

+static int cmp_hidden_bss(struct cfg80211_bss *a,
+		   struct cfg80211_bss *b)
+{
+	const u8 *ie1;
+	const u8 *ie2;
+	size_t ielen;
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
+	if (!ie1 && !ie2)
+		return 0;
+	if (!ie1 || !ie2)
+		return -1;
+
+	ielen = min(ie1[1], ie2[1]);
+	for (i = 0; i < ielen; ++i)
+		if (ie2[i + 2])
+			return -1;
+
+	return ie2[1] - ie1[1];
+}
+
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
@@ -475,6 +515,50 @@ rb_find_bss(struct cfg80211_registered_device *dev,
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
+static int
+merge_hidden_ies(struct cfg80211_internal_bss *res,
+		 struct cfg80211_internal_bss *hidden)
+{
+	if (unlikely(res->pub.beacon_ies))
+		return -EALREADY;
+	if (WARN_ON(!hidden->pub.beacon_ies))
+		return -EINVAL;
+
+	res->pub.beacon_ies = kmalloc(hidden->pub.len_beacon_ies, GFP_ATOMIC);
+	if (unlikely(!res->pub.beacon_ies))
+		return -ENOMEM;
+
+	res->beacon_ies_allocated = true;
+	res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
+	memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
+			res->pub.len_beacon_ies);
+
+	return 0;
+}
+
+static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		    struct cfg80211_internal_bss *res)
 {
@@ -494,6 +578,13 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	spin_lock_bh(&dev->bss_lock);

 	found = rb_find_bss(dev, res);
+	if (!found) {
+		struct cfg80211_internal_bss *hidden;
+
+		hidden = rb_find_hidden_bss(dev, res);
+		if (hidden)
+			merge_hidden_ies(res, hidden);
+	}

 	if (found) {
 		found->pub.beacon_interval = res->pub.beacon_interval;
-- 
With best regards,
Dmitry Tarnyagin
