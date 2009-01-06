Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751768AbZAFCIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 21:08:13 -0500
Cc: johannes@sipsolutions.net
Content-Type: multipart/mixed; boundary="========GMX302731231207690402995"
Date: Tue, 06 Jan 2009 03:08:10 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090106020810.302730@gmx.net> (sfid-20090106_030816_975988_744AFA5C)
MIME-Version: 1.0
Subject: [PATCH] Fixed BSSID step 4: Don't merge if BSSID is set manually
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX302731231207690402995
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

If you set a fixed BSSID manually, you never want that the driver change it back, or your ad-hoc mesh network will break into peaces. So don't do it.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 02:07:38.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 02:08:38.000000000 +0100
@@ -1660,6 +1660,7 @@
 
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && beacon &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)) &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&

-- 
Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a

--========GMX302731231207690402995
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="step4-dont-merge-if-bssid-is-set-manually.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="step4-dont-merge-if-bssid-is-set-manually.patch"

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/mlme.c compat-wireless-2009-01-05.work/net/mac80211/mlme.c
--- compat-wireless-2009-01-05.orig/net/mac80211/mlme.c	2009-01-06 02:07:38.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/mlme.c	2009-01-06 02:08:38.000000000 +0100
@@ -1660,6 +1660,7 @@
 
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && beacon &&
+	    (!(sdata->u.sta.flags & IEEE80211_STA_BSSID_SET)) &&
 	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems->ssid_len == sdata->u.sta.ssid_len &&

--========GMX302731231207690402995--
