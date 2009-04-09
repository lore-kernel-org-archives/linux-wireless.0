Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbZDIInM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 04:43:12 -0400
Subject: [PATCH] mac80211: make scan IE length more dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 10:43:07 +0200
Message-Id: <1239266587.32594.28.camel@johannes.local> (sfid-20090409_104320_630045_0FA26BFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generally drivers don't have all 32 possible rates, and also
do not support HT. This patch adds code to calculate the scan
IE length more accurately to benefit drivers that don't have
all that much space for scan IEs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This was supposed to be part of the patchset doing the scan IEs, but
seems either I forgot to send it out or you took an older version.

 net/mac80211/ieee80211_i.h |    6 ----
 net/mac80211/main.c        |   57 ++++++++++++++++++++++++++++++---------------
 net/mac80211/scan.c        |    3 +-
 net/mac80211/util.c        |    5 +++
 4 files changed, 45 insertions(+), 26 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-09 10:00:39.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-09 10:12:55.000000000 +0200
@@ -51,11 +51,6 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
-/* cfg80211 only supports 32 rates */
-#define MAC80211_PREQ_IE_LEN	( 2 + 32 /* SSID */\
-				+ 4 + 32 /* (ext) supp rates */\
-				+ sizeof(struct ieee80211_ht_cap))
-
 /*
  * Time after which we ignore scan results and no longer report/use
  * them in any way.
@@ -679,6 +674,7 @@ struct ieee80211_local {
 	const u8 *orig_ies;
 	int orig_ies_len;
 	int scan_channel_idx;
+	int scan_ies_len;
 
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
--- wireless-testing.orig/net/mac80211/main.c	2009-04-09 10:09:35.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-09 10:16:21.000000000 +0200
@@ -729,21 +729,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	wiphy->privid = mac80211_wiphy_privid;
 
-	if (!ops->hw_scan) {
-		/* For hw_scan, driver needs to set these up. */
-		wiphy->max_scan_ssids = 4;
-		wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
-	}
-	/*
-	 * If the driver supports any scan IEs, then assume the
-	 * limit includes the IEs mac80211 will add, otherwise
-	 * leave it at zero and let the driver sort it out; we
-	 * still pass our IEs to the driver but userspace will
-	 * not be allowed to in that case.
-	 */
-	if (wiphy->max_scan_ie_len)
-		wiphy->max_scan_ie_len -= MAC80211_PREQ_IE_LEN;
-
 	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss) -
 			       sizeof(struct cfg80211_bss);
@@ -835,7 +820,8 @@ int ieee80211_register_hw(struct ieee802
 	enum ieee80211_band band;
 	struct net_device *mdev;
 	struct ieee80211_master_priv *mpriv;
-	int channels, i, j;
+	int channels, i, j, max_bitrates;
+	bool supp_ht;
 
 	/*
 	 * generic code guarantees at least one band,
@@ -843,18 +829,25 @@ int ieee80211_register_hw(struct ieee802
 	 * that hw.conf.channel is assigned
 	 */
 	channels = 0;
+	max_bitrates = 0;
+	supp_ht = false;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[band];
-		if (sband && !local->oper_channel) {
+		if (!sband)
+			continue;
+		if (!local->oper_channel) {
 			/* init channel we're on */
 			local->hw.conf.channel =
 			local->oper_channel =
 			local->scan_channel = &sband->channels[0];
 		}
-		if (sband)
-			channels += sband->n_channels;
+		channels += sband->n_channels;
+
+		if (max_bitrates < sband->n_bitrates)
+			max_bitrates = sband->n_bitrates;
+		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 	}
 
 	local->int_scan_req.n_channels = channels;
@@ -874,6 +867,32 @@ int ieee80211_register_hw(struct ieee802
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
+	/*
+	 * Calculate scan IE length -- we need this to alloc
+	 * memory and to subtract from the driver limit. It
+	 * includes the (extended) supported rates and HT
+	 * information -- SSID is the driver's responsibility.
+	 */
+	local->scan_ies_len = 4 + max_bitrates; /* (ext) supp rates */
+	if (supp_ht)
+		local->scan_ies_len += 2 + sizeof(struct ieee80211_ht_cap);
+
+	if (!local->ops->hw_scan) {
+		/* For hw_scan, driver needs to set these up. */
+		local->hw.wiphy->max_scan_ssids = 4;
+		local->hw.wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+	}
+
+	/*
+	 * If the driver supports any scan IEs, then assume the
+	 * limit includes the IEs mac80211 will add, otherwise
+	 * leave it at zero and let the driver sort it out; we
+	 * still pass our IEs to the driver but userspace will
+	 * not be allowed to in that case.
+	 */
+	if (local->hw.wiphy->max_scan_ie_len)
+		local->hw.wiphy->max_scan_ie_len -= local->scan_ies_len;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-09 10:00:39.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-09 10:12:42.000000000 +0200
@@ -466,7 +466,8 @@ int ieee80211_start_scan(struct ieee8021
 		u8 *ies;
 		int rc, ielen;
 
-		ies = kmalloc(MAC80211_PREQ_IE_LEN + req->ie_len, GFP_KERNEL);
+		ies = kmalloc(2 + IEEE80211_MAX_SSID_LEN +
+			      local->scan_ies_len + req->ie_len, GFP_KERNEL);
 		if (!ies)
 			return -ENOMEM;
 
--- wireless-testing.orig/net/mac80211/util.c	2009-04-09 10:00:39.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-09 10:12:42.000000000 +0200
@@ -877,7 +877,10 @@ int ieee80211_build_preq_ies(struct ieee
 		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
 	}
 
-	/* if adding more here, adjust MAC80211_PREQ_IE_LEN */
+	/*
+	 * If adding more here, adjust code in main.c
+	 * that calculates local->scan_ies_len.
+	 */
 
 	if (ie) {
 		memcpy(pos, ie, ie_len);


