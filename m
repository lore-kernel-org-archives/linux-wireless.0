Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39025 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab0AFOT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 09:19:58 -0500
Date: Wed, 6 Jan 2010 16:19:24 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Store IEs from both Beacon and Probe Response
 frames
Message-ID: <20100106141924.GA18680@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store information elements from Beacon and Probe Response frames in
separate buffers to allow both sets to be made available through
nl80211. This allows user space applications to get access to IEs from
Beacon frames even if we have received Probe Response frames from the
BSS. Previously, the IEs from Probe Response frames would have
overridden the IEs from Beacon frames.

This feature is of somewhat limited use since most protocols include
the same (or extended) information in Probe Response frames. However,
there are couple of exceptions where the IEs from Beacon frames could
be of some use: TIM IE is only included in Beacon frames (and it would
be needed to figure out the DTIM period used in the BSS) and at least
some implementations of Wireless Provisioning Services seem to include
the full IE only in Beacon frames).

The new BSS attribute for scan results is added to allow both the IE
sets to be delivered. This is done in a way that maintains the
previously used behavior for applications that are not aware of the
new NL80211_BSS_BEACON_IES attribute.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/nl80211.h |   10 +++-
 include/net/cfg80211.h  |   12 ++++
 net/wireless/core.h     |    3 -
 net/wireless/nl80211.c  |    4 +
 net/wireless/scan.c     |  120 ++++++++++++++++++++++++++++++++++++------------
 5 files changed, 116 insertions(+), 33 deletions(-)

--- uml.orig/include/linux/nl80211.h	2010-01-06 14:50:20.000000000 +0200
+++ uml/include/linux/nl80211.h	2010-01-06 16:03:25.000000000 +0200
@@ -1399,13 +1399,20 @@ enum nl80211_channel_type {
  * @NL80211_BSS_BEACON_INTERVAL: beacon interval of the (I)BSS (u16)
  * @NL80211_BSS_CAPABILITY: capability field (CPU order, u16)
  * @NL80211_BSS_INFORMATION_ELEMENTS: binary attribute containing the
- *	raw information elements from the probe response/beacon (bin)
+ *	raw information elements from the probe response/beacon (bin);
+ *	if the %NL80211_BSS_BEACON_IES attribute is present, the IEs here are
+ *	from a Probe Response frame; otherwise they are from a Beacon frame.
+ *	However, if the driver does not indicate the source of the IEs, these
+ *	IEs may be from either frame subtype.
  * @NL80211_BSS_SIGNAL_MBM: signal strength of probe response/beacon
  *	in mBm (100 * dBm) (s32)
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
  *	in unspecified units, scaled to 0..100 (u8)
  * @NL80211_BSS_STATUS: status, if this BSS is "used"
  * @NL80211_BSS_SEEN_MS_AGO: age of this BSS entry in ms
+ * @NL80211_BSS_BEACON_IES: binary attribute containing the raw information
+ *	elements from a Beacon frame (bin); not present if no Beacon frame has
+ *	yet been received
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -1421,6 +1428,7 @@ enum nl80211_bss {
 	NL80211_BSS_SIGNAL_UNSPEC,
 	NL80211_BSS_STATUS,
 	NL80211_BSS_SEEN_MS_AGO,
+	NL80211_BSS_BEACON_IES,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2010-01-06 14:47:50.000000000 +0200
+++ uml/include/net/cfg80211.h	2010-01-06 14:49:50.000000000 +0200
@@ -626,8 +626,14 @@ enum cfg80211_signal_type {
  * @beacon_interval: the beacon interval as from the frame
  * @capability: the capability field in host byte order
  * @information_elements: the information elements (Note that there
- *	is no guarantee that these are well-formed!)
+ *	is no guarantee that these are well-formed!); this is a pointer to
+ *	either the beacon_ies or proberesp_ies depending on whether Probe
+ *	Response frame has been received
  * @len_information_elements: total length of the information elements
+ * @beacon_ies: the information elements from the last Beacon frame
+ * @len_beacon_ies: total length of the beacon_ies
+ * @proberesp_ies: the information elements from the last Probe Response frame
+ * @len_proberesp_ies: total length of the proberesp_ies
  * @signal: signal strength value (type depends on the wiphy's signal_type)
  * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
@@ -641,6 +647,10 @@ struct cfg80211_bss {
 	u16 capability;
 	u8 *information_elements;
 	size_t len_information_elements;
+	u8 *beacon_ies;
+	size_t len_beacon_ies;
+	u8 *proberesp_ies;
+	size_t len_proberesp_ies;
 
 	s32 signal;
 
--- uml.orig/net/wireless/core.h	2010-01-06 14:55:19.000000000 +0200
+++ uml/net/wireless/core.h	2010-01-06 14:55:37.000000000 +0200
@@ -111,7 +111,8 @@ struct cfg80211_internal_bss {
 	unsigned long ts;
 	struct kref ref;
 	atomic_t hold;
-	bool ies_allocated;
+	bool beacon_ies_allocated;
+	bool proberesp_ies_allocated;
 
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
--- uml.orig/net/wireless/nl80211.c	2010-01-06 14:47:11.000000000 +0200
+++ uml/net/wireless/nl80211.c	2010-01-06 15:07:19.000000000 +0200
@@ -3151,6 +3151,10 @@ static int nl80211_send_bss(struct sk_bu
 		NLA_PUT(msg, NL80211_BSS_INFORMATION_ELEMENTS,
 			res->len_information_elements,
 			res->information_elements);
+	if (res->beacon_ies && res->len_beacon_ies &&
+	    res->beacon_ies != res->information_elements)
+		NLA_PUT(msg, NL80211_BSS_BEACON_IES,
+			res->len_beacon_ies, res->beacon_ies);
 	if (res->tsf)
 		NLA_PUT_U64(msg, NL80211_BSS_TSF, res->tsf);
 	if (res->beacon_interval)
--- uml.orig/net/wireless/scan.c	2010-01-06 14:46:47.000000000 +0200
+++ uml/net/wireless/scan.c	2010-01-06 15:34:30.000000000 +0200
@@ -100,8 +100,10 @@ static void bss_release(struct kref *ref
 	if (bss->pub.free_priv)
 		bss->pub.free_priv(&bss->pub);
 
-	if (bss->ies_allocated)
-		kfree(bss->pub.information_elements);
+	if (bss->beacon_ies_allocated)
+		kfree(bss->pub.beacon_ies);
+	if (bss->proberesp_ies_allocated)
+		kfree(bss->pub.proberesp_ies);
 
 	BUG_ON(atomic_read(&bss->hold));
 
@@ -375,8 +377,7 @@ rb_find_bss(struct cfg80211_registered_d
 
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
-		    struct cfg80211_internal_bss *res,
-		    bool overwrite)
+		    struct cfg80211_internal_bss *res)
 {
 	struct cfg80211_internal_bss *found = NULL;
 	const u8 *meshid, *meshcfg;
@@ -418,28 +419,64 @@ cfg80211_bss_update(struct cfg80211_regi
 		found->pub.capability = res->pub.capability;
 		found->ts = res->ts;
 
-		/* overwrite IEs */
-		if (overwrite) {
+		/* Update IEs */
+		if (res->pub.proberesp_ies) {
 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
-			size_t ielen = res->pub.len_information_elements;
+			size_t ielen = res->pub.len_proberesp_ies;
 
-			if (!found->ies_allocated && ksize(found) >= used + ielen) {
-				memcpy(found->pub.information_elements,
-				       res->pub.information_elements, ielen);
-				found->pub.len_information_elements = ielen;
+			if (found->pub.proberesp_ies &&
+			    !found->proberesp_ies_allocated &&
+			    ksize(found) >= used + ielen) {
+				memcpy(found->pub.proberesp_ies,
+				       res->pub.proberesp_ies, ielen);
+				found->pub.len_proberesp_ies = ielen;
 			} else {
-				u8 *ies = found->pub.information_elements;
+				u8 *ies = found->pub.proberesp_ies;
 
-				if (found->ies_allocated)
+				if (found->proberesp_ies_allocated)
 					ies = krealloc(ies, ielen, GFP_ATOMIC);
 				else
 					ies = kmalloc(ielen, GFP_ATOMIC);
 
 				if (ies) {
-					memcpy(ies, res->pub.information_elements, ielen);
-					found->ies_allocated = true;
-					found->pub.information_elements = ies;
-					found->pub.len_information_elements = ielen;
+					memcpy(ies, res->pub.proberesp_ies,
+					       ielen);
+					found->proberesp_ies_allocated = true;
+					found->pub.proberesp_ies = ies;
+					found->pub.len_proberesp_ies = ielen;
+				}
+			}
+
+			/* Override possible earlier Beacon frame IEs */
+			found->pub.information_elements =
+				found->pub.proberesp_ies;
+			found->pub.len_information_elements =
+				found->pub.len_proberesp_ies;
+		}
+		if (res->pub.beacon_ies) {
+			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
+			size_t ielen = res->pub.len_beacon_ies;
+
+			if (found->pub.beacon_ies &&
+			    !found->beacon_ies_allocated &&
+			    ksize(found) >= used + ielen) {
+				memcpy(found->pub.beacon_ies,
+				       res->pub.beacon_ies, ielen);
+				found->pub.len_beacon_ies = ielen;
+			} else {
+				u8 *ies = found->pub.beacon_ies;
+
+				if (found->beacon_ies_allocated)
+					ies = krealloc(ies, ielen, GFP_ATOMIC);
+				else
+					ies = kmalloc(ielen, GFP_ATOMIC);
+
+				if (ies) {
+					memcpy(ies, res->pub.beacon_ies,
+					       ielen);
+					found->beacon_ies_allocated = true;
+					found->pub.beacon_ies = ies;
+					found->pub.len_beacon_ies = ielen;
 				}
 			}
 		}
@@ -489,14 +526,26 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	res->pub.tsf = timestamp;
 	res->pub.beacon_interval = beacon_interval;
 	res->pub.capability = capability;
-	/* point to after the private area */
-	res->pub.information_elements = (u8 *)res + sizeof(*res) + privsz;
-	memcpy(res->pub.information_elements, ie, ielen);
-	res->pub.len_information_elements = ielen;
+	/*
+	 * Since we do not know here whether the IEs are from a Beacon or Probe
+	 * Response frame, we need to pick one of the options and only use it
+	 * with the driver that does not provide the full Beacon/Probe Response
+	 * frame. Use Beacon frame pointer to avoid indicating that this should
+	 * override the information_elements pointer should we have received an
+	 * earlier indication of Probe Response data.
+	 *
+	 * The initial buffer for the IEs is allocated with the BSS entry and
+	 * is located after the private area.
+	 */
+	res->pub.beacon_ies = (u8 *)res + sizeof(*res) + privsz;
+	memcpy(res->pub.beacon_ies, ie, ielen);
+	res->pub.len_beacon_ies = ielen;
+	res->pub.information_elements = res->pub.beacon_ies;
+	res->pub.len_information_elements = res->pub.len_beacon_ies;
 
 	kref_init(&res->ref);
 
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res);
 	if (!res)
 		return NULL;
 
@@ -517,7 +566,6 @@ cfg80211_inform_bss_frame(struct wiphy *
 	struct cfg80211_internal_bss *res;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
-	bool overwrite;
 	size_t privsz = wiphy->bss_priv_size;
 
 	if (WARN_ON(wiphy->signal_type == NL80211_BSS_SIGNAL_UNSPEC &&
@@ -538,16 +586,28 @@ cfg80211_inform_bss_frame(struct wiphy *
 	res->pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	res->pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	res->pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
-	/* point to after the private area */
-	res->pub.information_elements = (u8 *)res + sizeof(*res) + privsz;
-	memcpy(res->pub.information_elements, mgmt->u.probe_resp.variable, ielen);
-	res->pub.len_information_elements = ielen;
+	/*
+	 * The initial buffer for the IEs is allocated with the BSS entry and
+	 * is located after the private area.
+	 */
+	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		res->pub.proberesp_ies = (u8 *) res + sizeof(*res) + privsz;
+		memcpy(res->pub.proberesp_ies, mgmt->u.probe_resp.variable,
+		       ielen);
+		res->pub.len_proberesp_ies = ielen;
+		res->pub.information_elements = res->pub.proberesp_ies;
+		res->pub.len_information_elements = res->pub.len_proberesp_ies;
+	} else {
+		res->pub.beacon_ies = (u8 *) res + sizeof(*res) + privsz;
+		memcpy(res->pub.beacon_ies, mgmt->u.beacon.variable, ielen);
+		res->pub.len_beacon_ies = ielen;
+		res->pub.information_elements = res->pub.beacon_ies;
+		res->pub.len_information_elements = res->pub.len_beacon_ies;
+	}
 
 	kref_init(&res->ref);
 
-	overwrite = ieee80211_is_probe_resp(mgmt->frame_control);
-
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res, overwrite);
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res);
 	if (!res)
 		return NULL;
 

-- 
Jouni Malinen                                            PGP id EFC895FA
