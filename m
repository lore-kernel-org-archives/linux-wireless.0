Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3C0NkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:40:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: check DSSS params IE length in parser
Date: Wed, 27 Mar 2013 14:39:55 +0100
Message-Id: <1364391597-3977-3-git-send-email-johannes@sipsolutions.net> (sfid-20130327_144016_622283_C39D059B)
In-Reply-To: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
References: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's always just one byte, so check for that and
remove the length field from the parser struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        | 2 +-
 net/mac80211/ieee80211_i.h | 1 -
 net/mac80211/mesh.c        | 2 +-
 net/mac80211/mlme.c        | 2 +-
 net/mac80211/util.c        | 6 ++++--
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5ab32e2..2a0b218 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -463,7 +463,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	bool rates_updated = false;
 
-	if (elems->ds_params && elems->ds_params_len == 1)
+	if (elems->ds_params)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
 						      band);
 	else
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 207b4f3..bf020d0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1189,7 +1189,6 @@ struct ieee802_11_elems {
 	/* length of them, respectively */
 	u8 ssid_len;
 	u8 supp_rates_len;
-	u8 ds_params_len;
 	u8 tim_len;
 	u8 challenge_len;
 	u8 rsn_len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index aead541..0acc287 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -907,7 +907,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	    (!elems.rsn && sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE))
 		return;
 
-	if (elems.ds_params && elems.ds_params_len == 1)
+	if (elems.ds_params)
 		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
 	else
 		freq = rx_status->freq;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c98a26d..7208612 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2764,7 +2764,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (elems->ds_params && elems->ds_params_len == 1)
+	if (elems->ds_params)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
 						      rx_status->band);
 	else
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 83e213b..9d7664f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -741,8 +741,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->supp_rates_len = elen;
 			break;
 		case WLAN_EID_DS_PARAMS:
-			elems->ds_params = pos;
-			elems->ds_params_len = elen;
+			if (elen >= 1)
+				elems->ds_params = pos;
+			else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_TIM:
 			if (elen >= sizeof(struct ieee80211_tim_ie)) {
-- 
1.8.0

