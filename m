Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYIFQNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 12:13:18 -0400
Subject: [PATCH] mac80211: make conf_tx non-atomic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 18:13:08 +0200
Message-Id: <1220717588.5376.0.camel@johannes.berg> (sfid-20080906_181322_345780_C344134A)
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

--- everything.orig/include/net/mac80211.h	2008-09-06 17:05:53.000000000 +0200
+++ everything/include/net/mac80211.h	2008-09-06 17:05:58.000000000 +0200
@@ -1142,7 +1142,7 @@ enum ieee80211_ampdu_mlme_action {
  *	of assocaited station or AP.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
- *	bursting) for a hardware TX queue. Must be atomic.
+ *	bursting) for a hardware TX queue.
  *
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
--- everything.orig/net/mac80211/mlme.c	2008-09-06 17:06:00.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-06 17:07:13.000000000 +0200
@@ -2701,15 +2701,18 @@ static void ieee80211_rx_mgmt_beacon(str
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


