Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbZDPLWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:22:33 -0400
Message-Id: <20090416111927.900021423@sipsolutions.net> (sfid-20090416_132235_676569_06627840)
References: <20090416111723.904720021@sipsolutions.net>
Date: Thu, 16 Apr 2009 13:17:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211: implement beacon filtering in software
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regardless of whether the hardware implements beacon filtering,
there's no need to process all beacons in software all the time
throughout the stack (mac80211 does a lot, then cfg80211, then
in the future possibly userspace).

This patch implements the "best possible" beacon filtering in
mac80211. "Best possible" means that it can look for changes in
all requested information elements, and distinguish vendor IEs
by their OUI.

In the future, we will add nl80211 API for userspace to request
information elements and vendor IE OUIs to watch -- drivers can
then implement the best they can do while software implements
it fully.

It is unclear whether or not this actually saves CPU time, but
the data is all in the cache already so it should be fairly
cheap. The additional _testing_, however, has great benefit;
Without this, and on hardware that doesn't implement beacon
filtering, wrong assumptions about, for example, scan result
updates could quickly creep into code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    5 ++++
 net/mac80211/mlme.c        |   52 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/util.c        |   23 ++++++++++++++++++-
 3 files changed, 66 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-16 04:51:12.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-16 05:01:05.000000000 +0200
@@ -308,6 +308,8 @@ struct ieee80211_if_managed {
 	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
 	int auth_transaction;
 
+	u32 beacon_crc;
+
 	enum {
 		IEEE80211_MFP_DISABLED,
 		IEEE80211_MFP_OPTIONAL,
@@ -1085,6 +1087,9 @@ void ieee80211_tx_skb(struct ieee80211_s
 		      int encrypt);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
+u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
+			       struct ieee802_11_elems *elems,
+			       u64 filter, u32 crc);
 int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 			      enum ieee80211_band band);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-16 04:51:12.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-16 12:12:08.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/pm_qos_params.h>
+#include <linux/crc32.h>
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 
@@ -1749,46 +1750,73 @@ static void ieee80211_rx_mgmt_probe_resp
 		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
 }
 
+/*
+ * This is the canonical list of information elements we care about,
+ * the filter code also gives us all changes to the Microsoft OUI
+ * (00:50:F2) vendor IE which is used for WMM which we need to track.
+ *
+ * We implement beacon filtering in software since that means we can
+ * avoid processing the frame here and in cfg80211, and userspace
+ * will not be able to tell whether the hardware supports it or not.
+ *
+ * XXX: This list needs to be dynamic -- userspace needs to be able to
+ *	add items it requires. It also needs to be able to tell us to
+ *	look out for other vendor IEs.
+ */
+static const u64 care_about_ies =
+	BIT(WLAN_EID_COUNTRY) |
+	BIT(WLAN_EID_ERP_INFO) |
+	BIT(WLAN_EID_CHANNEL_SWITCH) |
+	BIT(WLAN_EID_PWR_CONSTRAINT) |
+	BIT(WLAN_EID_HT_CAPABILITY) |
+	BIT(WLAN_EID_HT_INFORMATION);
+
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t baselen;
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
 	u32 changed = 0;
-	bool erp_valid, directed_tim;
+	bool erp_valid, directed_tim = false;
 	u8 erp_value = 0;
+	u32 ncrc;
 
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
-
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
-
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (rx_status->freq != local->hw.conf.channel->center_freq)
 		return;
 
-	ifmgd = &sdata->u.mgd;
-
 	if (!(ifmgd->flags & IEEE80211_STA_ASSOCIATED) ||
 	    memcmp(ifmgd->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	if (rx_status->freq != local->hw.conf.channel->center_freq)
+	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
+	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,
+					  len - baselen, &elems,
+					  care_about_ies, ncrc);
+
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		directed_tim = ieee80211_check_tim(&elems, ifmgd->aid);
+
+	ncrc = crc32_be(ncrc, (void *)&directed_tim, sizeof(directed_tim));
+
+	if (ncrc == ifmgd->beacon_crc)
 		return;
+	ifmgd->beacon_crc = ncrc;
+
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
 
 	ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 				 elems.wmm_param_len);
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
-		directed_tim = ieee80211_check_tim(&elems, ifmgd->aid);
-
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
 				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
--- wireless-testing.orig/net/mac80211/util.c	2009-04-16 04:51:12.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-04-16 12:19:45.000000000 +0200
@@ -20,6 +20,7 @@
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <linux/bitmap.h>
+#include <linux/crc32.h>
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
@@ -537,8 +538,16 @@ EXPORT_SYMBOL_GPL(ieee80211_iterate_acti
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems)
 {
+	ieee802_11_parse_elems_crc(start, len, elems, 0, 0);
+}
+
+u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
+			       struct ieee802_11_elems *elems,
+			       u64 filter, u32 crc)
+{
 	size_t left = len;
 	u8 *pos = start;
+	bool calc_crc = filter != 0;
 
 	memset(elems, 0, sizeof(*elems));
 	elems->ie_start = start;
@@ -552,7 +561,10 @@ void ieee802_11_parse_elems(u8 *start, s
 		left -= 2;
 
 		if (elen > left)
-			return;
+			break;
+
+		if (calc_crc && id < 64 && (filter & BIT(id)))
+			crc = crc32_be(crc, pos - 2, elen + 2);
 
 		switch (id) {
 		case WLAN_EID_SSID:
@@ -587,15 +599,20 @@ void ieee802_11_parse_elems(u8 *start, s
 			elems->challenge = pos;
 			elems->challenge_len = elen;
 			break;
-		case WLAN_EID_WPA:
+		case WLAN_EID_VENDOR_SPECIFIC:
 			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
 			    pos[2] == 0xf2) {
 				/* Microsoft OUI (00:50:F2) */
+
+				if (calc_crc)
+					crc = crc32_be(crc, pos - 2, elen + 2);
+
 				if (pos[3] == 1) {
 					/* OUI Type 1 - WPA IE */
 					elems->wpa = pos;
 					elems->wpa_len = elen;
 				} else if (elen >= 5 && pos[3] == 2) {
+					/* OUI Type 2 - WMM IE */
 					if (pos[4] == 0) {
 						elems->wmm_info = pos;
 						elems->wmm_info_len = elen;
@@ -680,6 +697,8 @@ void ieee802_11_parse_elems(u8 *start, s
 		left -= elen;
 		pos += elen;
 	}
+
+	return crc;
 }
 
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)

-- 

