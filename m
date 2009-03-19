Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49802 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbZCSLsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 07:48:13 -0400
Message-Id: <20090319114800.533740586@atheros.com> (sfid-20090319_124818_544863_6AF2B998)
References: <20090319113918.555693846@atheros.com>
Date: Thu, 19 Mar 2009 13:39:20 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/4] mac80211: Fix reassociation by not clearing previous BSSID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We must not clear the previous BSSID when roaming to another AP within
the same ESS for reassociation to be used properly. It is fine to
clear this when the SSID changes, so let's move the code into
ieee80211_sta_set_ssid().

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- uml.orig/net/mac80211/mlme.c	2009-03-19 00:20:04.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-03-19 00:20:52.000000000 +0200
@@ -1888,8 +1888,6 @@ int ieee80211_sta_commit(struct ieee8021
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-
 	if (ifmgd->ssid_len)
 		ifmgd->flags |= IEEE80211_STA_SSID_SET;
 	else
@@ -1908,6 +1906,10 @@ int ieee80211_sta_set_ssid(struct ieee80
 	ifmgd = &sdata->u.mgd;
 
 	if (ifmgd->ssid_len != len || memcmp(ifmgd->ssid, ssid, len) != 0) {
+		/*
+		 * Do not use reassociation if SSID is changed (different ESS).
+		 */
+		ifmgd->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		memset(ifmgd->ssid, 0, sizeof(ifmgd->ssid));
 		memcpy(ifmgd->ssid, ssid, len);
 		ifmgd->ssid_len = len;

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
