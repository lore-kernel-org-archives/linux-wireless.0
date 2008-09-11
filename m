Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYIKBOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 21:14:47 -0400
Subject: [PATCH 23/18] mac80211: share sta_info->ht_info
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 03:14:11 +0200
Message-Id: <1221095651.3804.75.camel@johannes.berg> (sfid-20080911_031535_649779_0C5B8813)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate control algorithms may need access to a station's
HT capabilities, so share the ht_info struct in the
public station API.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 +++---
 include/net/mac80211.h                    |    2 ++
 net/mac80211/cfg.c                        |    2 +-
 net/mac80211/mlme.c                       |    4 ++--
 net/mac80211/sta_info.h                   |    2 --
 5 files changed, 8 insertions(+), 8 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-11 03:06:16.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-11 03:06:29.000000000 +0200
@@ -667,6 +667,7 @@ enum set_key_cmd {
  * @addr: MAC address
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
+ * @ht_info: HT capabilities of this STA
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
@@ -674,6 +675,7 @@ struct ieee80211_sta {
 	u64 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
 	u16 aid;
+	struct ieee80211_ht_info ht_info;
 
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
--- everything.orig/net/mac80211/sta_info.h	2008-09-11 03:06:03.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-11 03:06:12.000000000 +0200
@@ -167,7 +167,6 @@ struct sta_ampdu_mlme {
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @flaglock: spinlock for flags accesses
- * @ht_info: HT capabilities of this STA
  * @addr: MAC address of this STA
  * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
  *	only used in AP (and IBSS?) mode
@@ -226,7 +225,6 @@ struct sta_info {
 	void *rate_ctrl_priv;
 	spinlock_t lock;
 	spinlock_t flaglock;
-	struct ieee80211_ht_info ht_info;
 
 	u16 listen_interval;
 
--- everything.orig/net/mac80211/cfg.c	2008-09-11 03:06:52.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-11 03:06:59.000000000 +0200
@@ -667,7 +667,7 @@ static void sta_apply_parameters(struct 
 
 	if (params->ht_capa) {
 		ieee80211_ht_cap_ie_to_ht_info(params->ht_capa,
-					       &sta->ht_info);
+					       &sta->sta.ht_info);
 	}
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->plink_action) {
--- everything.orig/net/mac80211/mlme.c	2008-09-11 03:07:12.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-11 03:07:29.000000000 +0200
@@ -1347,11 +1347,11 @@ static void ieee80211_rx_mgmt_assoc_resp
 		struct ieee80211_ht_bss_info bss_info;
 		ieee80211_ht_cap_ie_to_ht_info(
 				(struct ieee80211_ht_cap *)
-				elems.ht_cap_elem, &sta->ht_info);
+				elems.ht_cap_elem, &sta->sta.ht_info);
 		ieee80211_ht_addt_info_ie_to_ht_bss_info(
 				(struct ieee80211_ht_addt_info *)
 				elems.ht_info_elem, &bss_info);
-		ieee80211_handle_ht(local, 1, &sta->ht_info, &bss_info);
+		ieee80211_handle_ht(local, 1, &sta->sta.ht_info, &bss_info);
 	}
 
 	rate_control_rate_init(sta, local);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 03:07:56.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 03:08:12.000000000 +0200
@@ -1154,10 +1154,10 @@ static int rs_switch_to_mimo2(struct iwl
 	s8 is_green = lq_sta->is_green;
 
 	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
-	    !sta->ht_info.ht_supported)
+	    !sta->sta.ht_info.ht_supported)
 		return -1;
 
-	if (((sta->ht_info.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
+	if (((sta->sta.ht_info.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
 						== WLAN_HT_CAP_SM_PS_STATIC)
 		return -1;
 
@@ -1222,7 +1222,7 @@ static int rs_switch_to_siso(struct iwl_
 	s32 rate;
 
 	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
-	    !sta->ht_info.ht_supported)
+	    !sta->sta.ht_info.ht_supported)
 		return -1;
 
 	IWL_DEBUG_RATE("LQ: try to switch to SISO\n");


