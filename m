Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:38765 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbZCLNEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 09:04:52 -0400
Received: by bwz26 with SMTP id 26so174348bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 06:04:49 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: start pending scan after probe/auth/assoc timed out
Date: Thu, 12 Mar 2009 14:04:34 +0100
MIME-Version: 1.0
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903121404.34716.helmut.schaa@gmail.com> (sfid-20090312_140456_967338_C258FB46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a scan is queued in STA mode while the interface is in state direct
probe, authenticate or associate the scan is delayed until the interface
enters disabled or associated state. But in case of direct probe-,
authentication- or association- timeout sta_work will not be scheduled
anymore (without external trigger) and thus the pending scan is not
executed and prevents a new scan from being triggered (-EBUSY).

Fix this by queueing the sta work again after direct probe-, authentication-
and association- timeout.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Johannes, I'm not completely sure if this fixes the issue I've got on monday
as I was unable to trigger it again :(. Nevertheless I guess this patch is
correct. I'll keep some debug output in mac80211 as well (locally) to see
if the issue happens again and to see if it is fixed.

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6e92674..feb8340 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -682,6 +682,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
 
 	ifmgd->direct_probe_tries++;
 	if (ifmgd->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -697,6 +698,13 @@ static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata)
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
+
+		/*
+		 * We might have a pending scan which had no chance to run yet
+		 * due to state == IEEE80211_STA_MLME_DIRECT_PROBE.
+		 * Hence, queue the STAs work again
+		 */
+		queue_work(local->hw.workqueue, &ifmgd->work);
 		return;
 	}
 
@@ -721,6 +729,7 @@ static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
 
 	ifmgd->auth_tries++;
 	if (ifmgd->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -732,6 +741,13 @@ static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata)
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
+
+		/*
+		 * We might have a pending scan which had no chance to run yet
+		 * due to state == IEEE80211_STA_MLME_AUTHENTICATE.
+		 * Hence, queue the STAs work again
+		 */
+		queue_work(local->hw.workqueue, &ifmgd->work);
 		return;
 	}
 
@@ -878,6 +894,7 @@ static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_associate(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
 
 	ifmgd->assoc_tries++;
 	if (ifmgd->assoc_tries > IEEE80211_ASSOC_MAX_TRIES) {
@@ -889,6 +906,12 @@ static void ieee80211_associate(struct ieee80211_sub_if_data *sdata)
 		ieee80211_rx_bss_remove(sdata, ifmgd->bssid,
 				sdata->local->hw.conf.channel->center_freq,
 				ifmgd->ssid, ifmgd->ssid_len);
+		/*
+		 * We might have a pending scan which had no chance to run yet
+		 * due to state == IEEE80211_STA_MLME_ASSOCIATE.
+		 * Hence, queue the STAs work again
+		 */
+		queue_work(local->hw.workqueue, &ifmgd->work);
 		return;
 	}
