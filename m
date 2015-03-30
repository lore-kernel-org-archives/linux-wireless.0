Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45445 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbbC3Hwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 03:52:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: make sta.wme indicate whether QoS is used
Date: Mon, 30 Mar 2015 09:52:29 +0200
Message-Id: <1427701950-27977-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_095237_104191_DB4992B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Indicating just the peer's capability is fairly pointless
if the local device doesn't support it. Make the variable
track both combined, and remove the 'local support' check
in the TX path.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 3 ++-
 net/mac80211/cfg.c     | 3 ++-
 net/mac80211/ibss.c    | 2 +-
 net/mac80211/mlme.c    | 2 +-
 net/mac80211/tx.c      | 4 ++--
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 157c0f151766..2a5431354ed9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1488,7 +1488,8 @@ struct ieee80211_sta_rates {
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own capabilities
  * @vht_cap: VHT capabilities of this STA; restricted to our own capabilities
- * @wme: indicates whether the STA supports QoS/WME.
+ * @wme: indicates whether the STA supports QoS/WME (if local devices does,
+ *	otherwise always false)
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0aaf8b04a738..a3ea77efd4fc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1072,7 +1072,8 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 			clear_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE);
 	}
 
-	if (mask & BIT(NL80211_STA_FLAG_WME))
+	if (mask & BIT(NL80211_STA_FLAG_WME) &&
+	    local->hw.queues >= IEEE80211_NUM_ACS)
 		sta->sta.wme = set & BIT(NL80211_STA_FLAG_WME);
 
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 17eda3575d7d..6da4e72f8178 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1016,7 +1016,7 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (sta && elems->wmm_info)
+	if (sta && elems->wmm_info && local->hw.queues >= IEEE80211_NUM_ACS)
 		sta->sta.wme = true;
 
 	if (sta && elems->ht_operation && elems->ht_cap_elem &&
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c22e7520d9b9..b2aac2dc2944 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2962,7 +2962,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		sta->sta.mfp = false;
 	}
 
-	sta->sta.wme = elems.wmm_param;
+	sta->sta.wme = elems.wmm_param && local->hw.queues >= IEEE80211_NUM_ACS;
 
 	err = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 	if (!err && !(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 34b0e7545cc5..018f029d0c95 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2088,8 +2088,8 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		wme_sta = true;
 
-	/* receiver and we are QoS enabled, use a QoS type frame */
-	if (wme_sta && local->hw.queues >= IEEE80211_NUM_ACS) {
+	/* receiver does QoS (which also means we do) use it */
+	if (wme_sta) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
 	}
-- 
2.1.4

