Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab2C1JHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:07:04 -0400
Message-Id: <20120328090433.095113620@sipsolutions.net> (sfid-20120328_110709_116799_97D436D1)
Date: Wed, 28 Mar 2012 11:04:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] mac80211: use IEEE80211_NUM_ACS
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When comparing hw->queues to determine if the
device is QoS capable, use IEEE80211_NUM_ACS
instead of just 4.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c  |    2 +-
 net/mac80211/iface.c |    2 +-
 net/mac80211/mlme.c  |    7 ++++---
 net/mac80211/tx.c    |    2 +-
 net/mac80211/wme.c   |    4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

--- a/net/mac80211/ibss.c	2012-03-23 17:46:30.000000000 +0100
+++ b/net/mac80211/ibss.c	2012-03-23 17:47:04.000000000 +0100
@@ -167,7 +167,7 @@ static void __ieee80211_sta_join_ibss(st
 						 chan, channel_type);
 	}
 
-	if (local->hw.queues >= 4) {
+	if (local->hw.queues >= IEEE80211_NUM_ACS) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
 		*pos++ = 7; /* len */
--- a/net/mac80211/iface.c	2012-03-23 17:46:30.000000000 +0100
+++ b/net/mac80211/iface.c	2012-03-23 17:47:04.000000000 +0100
@@ -676,7 +676,7 @@ static u16 ieee80211_monitor_select_queu
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
 
-	if (local->hw.queues < 4)
+	if (local->hw.queues < IEEE80211_NUM_ACS)
 		return 0;
 
 	if (skb->len < 4 ||
--- a/net/mac80211/mlme.c	2012-03-23 17:46:30.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-23 17:47:04.000000000 +0100
@@ -1125,7 +1125,7 @@ static void ieee80211_sta_wmm_params(str
 	if (!local->ops->conf_tx)
 		return;
 
-	if (local->hw.queues < 4)
+	if (local->hw.queues < IEEE80211_NUM_ACS)
 		return;
 
 	if (!wmm_param)
@@ -3299,7 +3299,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
 	if (!sband->ht_cap.ht_supported ||
-	    local->hw.queues < 4 || !bss->wmm_used)
+	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
@@ -3322,7 +3322,8 @@ int ieee80211_mgd_assoc(struct ieee80211
 		ifmgd->ap_smps = ifmgd->req_smps;
 
 	assoc_data->capability = req->bss->capability;
-	assoc_data->wmm = bss->wmm_used && (local->hw.queues >= 4);
+	assoc_data->wmm = bss->wmm_used &&
+			  (local->hw.queues >= IEEE80211_NUM_ACS);
 	assoc_data->supp_rates = bss->supp_rates;
 	assoc_data->supp_rates_len = bss->supp_rates_len;
 
--- a/net/mac80211/tx.c	2012-03-23 17:46:30.000000000 +0100
+++ b/net/mac80211/tx.c	2012-03-23 17:47:04.000000000 +0100
@@ -1929,7 +1929,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		wme_sta = true;
 
 	/* receiver and we are QoS enabled, use a QoS type frame */
-	if (wme_sta && local->hw.queues >= 4) {
+	if (wme_sta && local->hw.queues >= IEEE80211_NUM_ACS) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
 	}
--- a/net/mac80211/wme.c	2012-03-23 17:46:30.000000000 +0100
+++ b/net/mac80211/wme.c	2012-03-23 17:47:04.000000000 +0100
@@ -79,7 +79,7 @@ u16 ieee80211_select_queue_80211(struct
 {
 	u8 *p;
 
-	if (local->hw.queues < 4)
+	if (local->hw.queues < IEEE80211_NUM_ACS)
 		return 0;
 
 	if (!ieee80211_is_data(hdr->frame_control)) {
@@ -106,7 +106,7 @@ u16 ieee80211_select_queue(struct ieee80
 	const u8 *ra = NULL;
 	bool qos = false;
 
-	if (local->hw.queues < 4 || skb->len < 6) {
+	if (local->hw.queues < IEEE80211_NUM_ACS || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
 		return 0;
 	}


