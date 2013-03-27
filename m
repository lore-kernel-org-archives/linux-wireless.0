Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3C0NkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:40:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: check ERP info IE length in parser
Date: Wed, 27 Mar 2013 14:39:56 +0100
Message-Id: <1364391597-3977-4-git-send-email-johannes@sipsolutions.net> (sfid-20130327_144010_065451_09BA7F34)
In-Reply-To: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
References: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's always just one byte, so check for that and
remove the length field from the parser struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 1 -
 net/mac80211/mlme.c        | 2 +-
 net/mac80211/scan.c        | 5 ++---
 net/mac80211/util.c        | 6 ++++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bf020d0..eb364f3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1192,7 +1192,6 @@ struct ieee802_11_elems {
 	u8 tim_len;
 	u8 challenge_len;
 	u8 rsn_len;
-	u8 erp_info_len;
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7208612..c6d87bc4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3106,7 +3106,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		changed |= BSS_CHANGED_DTIM_PERIOD;
 	}
 
-	if (elems.erp_info && elems.erp_info_len >= 1) {
+	if (elems.erp_info) {
 		erp_valid = true;
 		erp_value = elems.erp_info[0];
 	} else {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 581764f..33fbf10 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -98,9 +98,8 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	}
 
 	/* save the ERP value so that it is available at association time */
-	if (elems->erp_info && elems->erp_info_len >= 1 &&
-			(!elems->parse_error ||
-			 !(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
+	if (elems->erp_info && (!elems->parse_error ||
+				!(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
 		bss->erp_value = elems->erp_info[0];
 		bss->has_erp_value = true;
 		if (!elems->parse_error)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9d7664f..739ae33 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -782,8 +782,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->rsn_len = elen;
 			break;
 		case WLAN_EID_ERP_INFO:
-			elems->erp_info = pos;
-			elems->erp_info_len = elen;
+			if (elen >= 1)
+				elems->erp_info = pos;
+			else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_EXT_SUPP_RATES:
 			elems->ext_supp_rates = pos;
-- 
1.8.0

