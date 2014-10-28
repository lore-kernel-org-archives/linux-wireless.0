Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:48737 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753458AbaJ1Ld5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 07:33:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: johill@sipsolutions.net
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Date: Tue, 28 Oct 2014 13:33:04 +0200
Message-Id: <1414495985-26937-2-git-send-email-luca@coelho.fi> (sfid-20141028_123405_201808_89DF929A)
In-Reply-To: <1414495985-26937-1-git-send-email-luca@coelho.fi>
References: <1414495985-26937-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 1/2] mac80211: use secondary channel offset IE also beacons during CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If we are switching from an HT40+ to an HT40- channel (or vice-versa),
we need the secondary channel offset IE to specify what is the
post-CSA offset to be used.  This applies both to beacons and to probe
responses.

In ieee80211_parse_ch_switch_ie() we were ignoring this IE from
beacons and using the *current* HT information IE instead.  This was
causing us to use the same offset as before the switch.

Fix that by using the secondary channel offset IE also for beacons and
don't ever use the pre-switch offset.  Additionally, remove the
"beacon" argument from ieee80211_parse_ch_switch_ie(), since it's not
needed anymore.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/mesh.c        |  2 +-
 net/mac80211/mlme.c        |  2 +-
 net/mac80211/spectmgmt.c   | 18 ++++++------------
 5 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 56b5357..509bc15 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -805,7 +805,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	memset(&params, 0, sizeof(params));
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
+	err = ieee80211_parse_ch_switch_ie(sdata, elems,
 					   ifibss->chandef.chan->band,
 					   sta_flags, ifibss->bssid, &csa_ie);
 	/* can't switch to destination channel, fail */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 146a818..96074df 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1676,7 +1676,6 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  * ieee80211_parse_ch_switch_ie - parses channel switch IEs
  * @sdata: the sdata of the interface which has received the frame
  * @elems: parsed 802.11 elements received with the frame
- * @beacon: indicates if the frame was a beacon or probe response
  * @current_band: indicates the current band
  * @sta_flags: contains information about own capabilities and restrictions
  *	to decide which channel switch announcements can be accepted. Only the
@@ -1690,7 +1689,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
  * Return: 0 on success, <0 on error and >0 if there is nothing to parse.
  */
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
-				 struct ieee802_11_elems *elems, bool beacon,
+				 struct ieee802_11_elems *elems,
 				 enum ieee80211_band current_band,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e9f99c1..0c8b2a7 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -874,7 +874,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	memset(&params, 0, sizeof(params));
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, band,
+	err = ieee80211_parse_ch_switch_ie(sdata, elems, band,
 					   sta_flags, sdata->vif.addr,
 					   &csa_ie);
 	if (err < 0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c078cd3..ae9f3bd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1096,7 +1096,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	current_band = cbss->channel->band;
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	res = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, current_band,
+	res = ieee80211_parse_ch_switch_ie(sdata, elems, current_band,
 					   ifmgd->flags,
 					   ifmgd->associated->bssid, &csa_ie);
 	if (res	< 0)
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 6ab0090..efeba56 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -22,7 +22,7 @@
 #include "wme.h"
 
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
-				 struct ieee802_11_elems *elems, bool beacon,
+				 struct ieee802_11_elems *elems,
 				 enum ieee80211_band current_band,
 				 u32 sta_flags, u8 *bssid,
 				 struct ieee80211_csa_ie *csa_ie)
@@ -91,19 +91,13 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 	}
 
-	if (!beacon && sec_chan_offs) {
+	if (sec_chan_offs) {
 		secondary_channel_offset = sec_chan_offs->sec_chan_offs;
-	} else if (beacon && ht_oper) {
-		secondary_channel_offset =
-			ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
 	} else if (!(sta_flags & IEEE80211_STA_DISABLE_HT)) {
-		/* If it's not a beacon, HT is enabled and the IE not present,
-		 * it's 20 MHz, 802.11-2012 8.5.2.6:
-		 *	This element [the Secondary Channel Offset Element] is
-		 *	present when switching to a 40 MHz channel. It may be
-		 *	present when switching to a 20 MHz channel (in which
-		 *	case the secondary channel offset is set to SCN).
-		 */
+		/* If the secondary channel offset IE is not present,
+		 * we can't know what's the post-CSA offset, so the
+		 * best we can do is use 20MHz.
+		*/
 		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 	}
 
-- 
2.1.1

