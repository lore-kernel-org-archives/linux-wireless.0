Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZLARaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 12:30:13 -0500
Subject: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 18:29:42 +0100
Message-ID: <1259688582.32171.97.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some situations it is required that a system be
configured with no support for 40 MHz channels in
the 2.4 GHz band. Rather than imposing any such
restrictions on everybody, allow configuration a
system like that with a module parameter. It is
writable at runtime but only takes effect at the
time of the next association.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |    6 ++++++
 net/mac80211/mlme.c        |    6 ++++++
 net/mac80211/util.c        |   14 +++++++++++---
 4 files changed, 25 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-01 18:11:40.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-01 18:24:18.000000000 +0100
@@ -400,6 +400,12 @@ static void ieee80211_send_assoc(struct 
 
 		/* determine capability flags */
 
+		if (ieee80211_disable_40mhz_24ghz &&
+		    sband->band == IEEE80211_BAND_2GHZ) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
 		switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 			if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
--- wireless-testing.orig/net/mac80211/util.c	2009-12-01 18:11:40.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-12-01 18:23:38.000000000 +0100
@@ -908,16 +908,24 @@ int ieee80211_build_preq_ies(struct ieee
 	}
 
 	if (sband->ht_cap.ht_supported) {
-		__le16 tmp = cpu_to_le16(sband->ht_cap.cap);
+		u16 cap = sband->ht_cap.cap;
+		__le16 tmp;
+
+		if (ieee80211_disable_40mhz_24ghz &&
+		    sband->band == IEEE80211_BAND_2GHZ) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
 
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
 		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+		tmp = cpu_to_le16(cap);
 		memcpy(pos, &tmp, sizeof(u16));
 		pos += sizeof(u16);
-		/* TODO: needs a define here for << 2 */
 		*pos++ = sband->ht_cap.ampdu_factor |
-			 (sband->ht_cap.ampdu_density << 2);
+			 (sband->ht_cap.ampdu_density <<
+				IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
 		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
 		pos += sizeof(sband->ht_cap.mcs);
 		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-01 18:11:40.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-01 18:23:14.000000000 +0100
@@ -881,6 +881,8 @@ void ieee80211_bss_info_change_notify(st
 void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
+extern bool ieee80211_disable_40mhz_24ghz;
+
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/main.c	2009-12-01 18:11:40.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-12-01 18:23:13.000000000 +0100
@@ -33,6 +33,12 @@
 #include "cfg.h"
 #include "debugfs.h"
 
+
+bool ieee80211_disable_40mhz_24ghz;
+module_param(ieee80211_disable_40mhz_24ghz, bool, 0644);
+MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
+		 "Disable 40MHz support in the 2.4GHz band");
+
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;


