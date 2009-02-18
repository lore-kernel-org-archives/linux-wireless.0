Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBRRpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 12:45:40 -0500
Subject: [PATCH] cfg80211: clean up signal type
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 18:45:06 +0100
Message-Id: <1234979106.4023.36.camel@johannes.local> (sfid-20090218_184544_683043_C58C9FA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It wasn't a good idea to make the signal type a per-BSS option,
although then it is closer to the actual value. Move it to be
a per-wiphy setting, update mac80211 to match.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Might require that other patch adding qual.qual to apply.

 include/net/cfg80211.h |    8 +++-----
 include/net/wireless.h |    3 +++
 net/mac80211/main.c    |    5 +++++
 net/mac80211/scan.c    |   11 +++--------
 net/wireless/nl80211.c |    2 +-
 net/wireless/scan.c    |   21 +++++++++------------
 6 files changed, 24 insertions(+), 26 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-02-18 18:33:25.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-02-18 18:38:00.000000000 +0100
@@ -577,8 +577,7 @@ enum cfg80211_signal_type {
  * @information_elements: the information elements (Note that there
  *	is no guarantee that these are well-formed!)
  * @len_information_elements: total length of the information elements
- * @signal: signal strength value
- * @signal_type: signal type
+ * @signal: signal strength value (type depends on the wiphy's signal_type)
  * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
@@ -593,7 +592,6 @@ struct cfg80211_bss {
 	size_t len_information_elements;
 
 	s32 signal;
-	enum cfg80211_signal_type signal_type;
 
 	void (*free_priv)(struct cfg80211_bss *bss);
 	u8 priv[0] __attribute__((__aligned__(sizeof(void *))));
@@ -782,6 +780,7 @@ void cfg80211_scan_done(struct cfg80211_
  *
  * @wiphy: the wiphy reporting the BSS
  * @bss: the found BSS
+ * @signal: the signal strength, type depends on the wiphy's signal_type
  * @gfp: context flags
  *
  * This informs cfg80211 that BSS information was found and
@@ -791,8 +790,7 @@ struct cfg80211_bss*
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,
 			  struct ieee80211_mgmt *mgmt, size_t len,
-			  s32 signal, enum cfg80211_signal_type sigtype,
-			  gfp_t gfp);
+			  s32 signal, gfp_t gfp);
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
--- wireless-testing.orig/include/net/wireless.h	2009-02-18 18:33:20.000000000 +0100
+++ wireless-testing/include/net/wireless.h	2009-02-18 18:35:17.000000000 +0100
@@ -200,6 +200,7 @@ struct ieee80211_supported_band {
  * 	the regulatory_hint() API. This can be used by the driver
  *	on the reg_notifier() if it chooses to ignore future
  *	regulatory domain changes caused by other drivers.
+ * @signal_type: signal type reported in &struct cfg80211_bss.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -213,6 +214,8 @@ struct wiphy {
 	bool custom_regulatory;
 	bool strict_regulatory;
 
+	enum cfg80211_signal_type signal_type;
+
 	int bss_priv_size;
 	u8 max_scan_ssids;
 
--- wireless-testing.orig/net/wireless/nl80211.c	2009-02-18 18:39:40.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-02-18 18:39:50.000000000 +0100
@@ -2423,7 +2423,7 @@ static int nl80211_send_bss(struct sk_bu
 	NLA_PUT_U16(msg, NL80211_BSS_CAPABILITY, res->capability);
 	NLA_PUT_U32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq);
 
-	switch (res->signal_type) {
+	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
 		NLA_PUT_U32(msg, NL80211_BSS_SIGNAL_MBM, res->signal);
 		break;
--- wireless-testing.orig/net/wireless/scan.c	2009-02-18 18:36:52.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-02-18 18:39:25.000000000 +0100
@@ -370,7 +370,6 @@ cfg80211_bss_update(struct cfg80211_regi
 		found->pub.beacon_interval = res->pub.beacon_interval;
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;
-		found->pub.signal_type = res->pub.signal_type;
 		found->pub.capability = res->pub.capability;
 		found->ts = res->ts;
 		kref_put(&res->ref, bss_release);
@@ -392,8 +391,7 @@ struct cfg80211_bss *
 cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_channel *channel,
 			  struct ieee80211_mgmt *mgmt, size_t len,
-			  s32 signal, enum cfg80211_signal_type sigtype,
-			  gfp_t gfp)
+			  s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss *res;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
@@ -401,7 +399,7 @@ cfg80211_inform_bss_frame(struct wiphy *
 	bool overwrite;
 	size_t privsz = wiphy->bss_priv_size;
 
-	if (WARN_ON(sigtype == NL80211_BSS_SIGNAL_UNSPEC &&
+	if (WARN_ON(wiphy->signal_type == NL80211_BSS_SIGNAL_UNSPEC &&
 	            (signal < 0 || signal > 100)))
 		return NULL;
 
@@ -415,7 +413,6 @@ cfg80211_inform_bss_frame(struct wiphy *
 
 	memcpy(res->pub.bssid, mgmt->bssid, ETH_ALEN);
 	res->pub.channel = channel;
-	res->pub.signal_type = sigtype;
 	res->pub.signal = signal;
 	res->pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	res->pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
@@ -607,9 +604,9 @@ static inline unsigned int elapsed_jiffi
 }
 
 static char *
-ieee80211_bss(struct iw_request_info *info,
-		      struct cfg80211_internal_bss *bss,
-		      char *current_ev, char *end_buf)
+ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
+	      struct cfg80211_internal_bss *bss, char *current_ev,
+	      char *end_buf)
 {
 	struct iw_event iwe;
 	u8 *buf, *cfg, *p;
@@ -638,13 +635,13 @@ ieee80211_bss(struct iw_request_info *in
 	current_ev = iwe_stream_add_event(info, current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
-	if (bss->pub.signal_type != CFG80211_SIGNAL_TYPE_NONE) {
+	if (wiphy->signal_type != CFG80211_SIGNAL_TYPE_NONE) {
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVQUAL;
 		iwe.u.qual.updated = IW_QUAL_LEVEL_UPDATED |
 				     IW_QUAL_NOISE_INVALID |
 				     IW_QUAL_QUAL_UPDATED;
-		switch (bss->pub.signal_type) {
+		switch (wiphy->signal_type) {
 		case CFG80211_SIGNAL_TYPE_MBM:
 			sig = bss->pub.signal / 100;
 			iwe.u.qual.level = sig;
@@ -823,8 +820,8 @@ static int ieee80211_scan_results(struct
 			spin_unlock_bh(&dev->bss_lock);
 			return -E2BIG;
 		}
-		current_ev = ieee80211_bss(info, bss,
-						   current_ev, end_buf);
+		current_ev = ieee80211_bss(&dev->wiphy, info, bss,
+					   current_ev, end_buf);
 	}
 	spin_unlock_bh(&dev->bss_lock);
 	return current_ev - buf;
--- wireless-testing.orig/net/mac80211/main.c	2009-02-18 18:40:56.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-18 18:42:37.000000000 +0100
@@ -861,6 +861,11 @@ int ieee80211_register_hw(struct ieee802
 	/* mac80211 always supports monitor */
 	local->hw.wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
 
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
+		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
--- wireless-testing.orig/net/mac80211/scan.c	2009-02-18 18:40:15.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-02-18 18:42:11.000000000 +0100
@@ -63,20 +63,15 @@ ieee80211_bss_info_update(struct ieee802
 {
 	struct ieee80211_bss *bss;
 	int clen;
-	enum cfg80211_signal_type sigtype = CFG80211_SIGNAL_TYPE_NONE;
 	s32 signal = 0;
 
-	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
-		sigtype = CFG80211_SIGNAL_TYPE_MBM;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		signal = rx_status->signal * 100;
-	} else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC) {
-		sigtype = CFG80211_SIGNAL_TYPE_UNSPEC;
+	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
-	}
 
 	bss = (void *)cfg80211_inform_bss_frame(local->hw.wiphy, channel,
-						mgmt, len, signal, sigtype,
-						GFP_ATOMIC);
+						mgmt, len, signal, GFP_ATOMIC);
 
 	if (!bss)
 		return NULL;


