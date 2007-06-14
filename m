Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXFNJIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:08:38 -0400
Subject: [PATCH] conserve stack space due to padding
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 09:26:11 +0200
Message-Id: <1181805971.9058.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reorders some fields in struct ieee802_11_elems to save 17*7
or 17*3 bytes (on 64/32-bit machines respectively) stack space in a few
functions.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
I don't think this hurts readability at all since these things are
*very* structured to begin with. And having 8/4 byte fields alternate
with 1 byte fields isn't such a great idea.

 net/mac80211/ieee80211_sta.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-06-14 09:19:48.780669913 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-06-14 09:21:28.720669913 +0200
@@ -79,39 +79,42 @@ static int ieee80211_sta_config_auth(str
 
 /* Parsed Information Elements */
 struct ieee802_11_elems {
+	/* pointers to IEs */
 	u8 *ssid;
-	u8 ssid_len;
 	u8 *supp_rates;
-	u8 supp_rates_len;
 	u8 *fh_params;
-	u8 fh_params_len;
 	u8 *ds_params;
-	u8 ds_params_len;
 	u8 *cf_params;
-	u8 cf_params_len;
 	u8 *tim;
-	u8 tim_len;
 	u8 *ibss_params;
-	u8 ibss_params_len;
 	u8 *challenge;
-	u8 challenge_len;
 	u8 *wpa;
-	u8 wpa_len;
 	u8 *rsn;
-	u8 rsn_len;
 	u8 *erp_info;
-	u8 erp_info_len;
 	u8 *ht_cap_param;
-	u8 ht_cap_param_len;
 	u8 *ht_extra_param;
-	u8 ht_extra_param_len;
 	u8 *ext_supp_rates;
-	u8 ext_supp_rates_len;
 	u8 *wmm_info;
-	u8 wmm_info_len;
 	u8 *wmm_param;
-	u8 wmm_param_len;
 	u8 *tspec;
+
+	/* length of them, respectively */
+	u8 ssid_len;
+	u8 supp_rates_len;
+	u8 fh_params_len;
+	u8 ds_params_len;
+	u8 cf_params_len;
+	u8 tim_len;
+	u8 ibss_params_len;
+	u8 challenge_len;
+	u8 wpa_len;
+	u8 rsn_len;
+	u8 erp_info_len;
+	u8 ht_cap_param_len;
+	u8 ht_extra_param_len;
+	u8 ext_supp_rates_len;
+	u8 wmm_info_len;
+	u8 wmm_param_len;
 	u8 tspec_len;
 };
 


