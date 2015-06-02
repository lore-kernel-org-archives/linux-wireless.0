Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39971 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbbFBS3F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 14:29:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove short slot/short preamble incapable flags
Date: Tue,  2 Jun 2015 20:29:02 +0200
Message-Id: <1433269742-29131-1-git-send-email-johannes@sipsolutions.net> (sfid-20150602_202910_469280_CEDF2DBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are no drivers setting IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE
or IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE, so any code using the
two flags is dead; it's also exceedingly unlikely that any new driver
could ever need to set these flags.

The wcn36xx code is almost certainly broken, but this preserves the
previous behaviour.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c |  4 +---
 include/net/mac80211.h                 | 17 ++---------------
 net/mac80211/debugfs.c                 |  7 -------
 net/mac80211/mesh_plink.c              |  4 +---
 net/mac80211/mlme.c                    |  6 ++----
 net/mac80211/tdls.c                    | 17 +++++------------
 6 files changed, 11 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index dbd894428be6..c9263e1c75d4 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -216,9 +216,7 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
 		memcpy(&sta_params->bssid, vif->addr, ETH_ALEN);
 
 	sta_params->encrypt_type = priv_vif->encrypt_type;
-	sta_params->short_preamble_supported =
-		!(WCN36XX_FLAGS(wcn) &
-		  IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE);
+	sta_params->short_preamble_supported = true;
 
 	sta_params->rifs_mode = 0;
 	sta_params->rmf = 0;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7466c55bfc0b..68a3cc9796d2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -446,12 +446,8 @@ struct ieee80211_event {
  * @ibss_creator: indicates if a new IBSS network is being created
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
- * @use_short_preamble: use 802.11b short preamble;
- *	if the hardware cannot handle this it must set the
- *	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE hardware flag
- * @use_short_slot: use short slot time (only relevant for ERP);
- *	if the hardware cannot handle this it must set the
- *	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE hardware flag
+ * @use_short_preamble: use 802.11b short preamble
+ * @use_short_slot: use short slot time (only relevant for ERP)
  * @dtim_period: num of beacons before the next DTIM, for beaconing,
  *	valid in station mode only if after the driver was notified
  *	with the %BSS_CHANGED_BEACON_INFO flag, will be non-zero then.
@@ -1784,13 +1780,6 @@ struct ieee80211_txq {
  *	multicast frames when there are power saving stations so that
  *	the driver can fetch them with ieee80211_get_buffered_bc().
  *
- * @IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE:
- *	Hardware is not capable of short slot operation on the 2.4 GHz band.
- *
- * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
- *	Hardware is not capable of receiving frames with short preamble on
- *	the 2.4 GHz band.
- *
  * @IEEE80211_HW_SIGNAL_UNSPEC:
  *	Hardware can provide signal values but we don't know its units. We
  *	expect values between 0 and @max_signal.
@@ -1903,8 +1892,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
-	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
-	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
 	IEEE80211_HW_SIGNAL_UNSPEC			= 1<<5,
 	IEEE80211_HW_SIGNAL_DBM				= 1<<6,
 	IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC		= 1<<7,
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b17206db49b4..1b94d2704c27 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -1,4 +1,3 @@
-
 /*
  * mac80211 debugfs for wireless PHYs
  *
@@ -112,12 +111,6 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 	if (local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)
 		sf += scnprintf(buf + sf, mxln - sf,
 				"HOST_BCAST_PS_BUFFERING\n");
-	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE)
-		sf += scnprintf(buf + sf, mxln - sf,
-				"2GHZ_SHORT_SLOT_INCAPABLE\n");
-	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE)
-		sf += scnprintf(buf + sf, mxln - sf,
-				"2GHZ_SHORT_PREAMBLE_INCAPABLE\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		sf += scnprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
 	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ac843fc88745..72a127e8a1b6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -106,9 +106,7 @@ static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
 		/* (IEEE 802.11-2012 19.4.5) */
 		short_slot = true;
 		goto out;
-	} else if (band != IEEE80211_BAND_2GHZ ||
-		   (band == IEEE80211_BAND_2GHZ &&
-		    local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
+	} else if (band != IEEE80211_BAND_2GHZ)
 		goto out;
 
 	for (i = 0; i < sband->n_bitrates; i++)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 853cfa71b96a..94274ef569fa 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -669,10 +669,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	capab = WLAN_CAPABILITY_ESS;
 
 	if (sband->band == IEEE80211_BAND_2GHZ) {
-		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
-			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
-		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
-			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
+		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
+		capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
 
 	if (assoc_data->capability & WLAN_CAPABILITY_PRIVACY)
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 75e8e3bba538..28298cc50326 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -167,23 +167,16 @@ static void ieee80211_tdls_add_bss_coex_ie(struct sk_buff *skb)
 static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata,
 					u16 status_code)
 {
-	struct ieee80211_local *local = sdata->local;
-	u16 capab;
-
 	/* The capability will be 0 when sending a failure code */
 	if (status_code != 0)
 		return 0;
 
-	capab = 0;
-	if (ieee80211_get_sdata_band(sdata) != IEEE80211_BAND_2GHZ)
-		return capab;
-
-	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
-		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
-		capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
+	if (ieee80211_get_sdata_band(sdata) == IEEE80211_BAND_2GHZ) {
+		return WLAN_CAPABILITY_SHORT_SLOT_TIME |
+		       WLAN_CAPABILITY_SHORT_PREAMBLE;
+	}
 
-	return capab;
+	return 0;
 }
 
 static void ieee80211_tdls_add_link_ie(struct ieee80211_sub_if_data *sdata,
-- 
2.1.4

