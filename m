Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbYIHJIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:08:17 -0400
Message-Id: <20080908090634.619565000@sipsolutions.net> (sfid-20080908_110820_094705_076B01F9)
References: <20080908090507.641740000@sipsolutions.net>
Date: Mon, 08 Sep 2008 11:05:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211: make conf_tx non-atomic
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The conf_tx callback currently needs to be atomic, this requirement
is just because it can be called from scanning. This rearranges it
slightly to only update while not scanning (which is fine, we'll be
getting beacons when associated) and thus removes the atomic
requirement.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    2 +-
 net/mac80211/mlme.c    |   13 ++++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-09-08 10:20:24.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-08 10:21:17.000000000 +0200
@@ -1142,7 +1142,7 @@ enum ieee80211_ampdu_mlme_action {
  *	of assocaited station or AP.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
- *	bursting) for a hardware TX queue. Must be atomic.
+ *	bursting) for a hardware TX queue.
  *
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
--- everything.orig/net/mac80211/mlme.c	2008-09-08 10:21:09.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 10:21:17.000000000 +0200
@@ -2873,15 +2873,18 @@ static void ieee80211_rx_mgmt_beacon(str
 	    memcmp(ifsta->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
-	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
-				 elems.wmm_param_len);
-
 	/* Do not send changes to driver if we are scanning. This removes
-	 * requirement that driver's bss_info_changed function needs to be
-	 * atomic. */
+	 * requirement that a driver's bss_info_changed/conf_tx functions
+	 * need to be atomic.
+	 * This is really ugly code, we should rewrite scanning and make
+	 * all this more understandable for humans.
+	 */
 	if (local->sta_sw_scanning || local->sta_hw_scanning)
 		return;
 
+	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
+				 elems.wmm_param_len);
+
 	if (elems.erp_info && elems.erp_info_len >= 1)
 		changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
 	else {

-- 

