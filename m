Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32869 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752185AbZAFCP0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 21:15:26 -0500
Cc: johannes@sipsolutions.net
Content-Type: multipart/mixed; boundary="========GMX302751231208123255535"
Date: Tue, 06 Jan 2009 03:15:23 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090106021523.302750@gmx.net> (sfid-20090106_031529_695837_608650C0)
MIME-Version: 1.0
Subject: [PATCH] Fixed BSSID step 5: Allow to set channel in adhoc properly
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX302751231208123255535
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

The last patch fixes a bug that it was not possible to set the channel manually in the ad hoc mode properly.

Please commit this patches so that we don't need the proprietary Broadcom driver in the near future anymore.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/wext.c compat-wireless-2009-01-05.work/net/mac80211/wext.c
--- compat-wireless-2009-01-05.orig/net/mac80211/wext.c	2009-01-06 02:07:38.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/wext.c	2009-01-06 02:13:21.000000000 +0100
@@ -230,13 +230,15 @@
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+			    sdata->vif.type == NL80211_IFTYPE_STATION)
 				sdata->u.sta.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;

-- 
Sensationsangebot verlängert: GMX FreeDSL - Telefonanschluss + DSL 
für nur 16,37 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K1308T4569a

--========GMX302751231208123255535
Content-Type: text/x-patch;
 charset="iso-8859-15";
 name="step5-allow-to-set-channel-in-adhoc-properly.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="step5-allow-to-set-channel-in-adhoc-properly.patch"

diff -urN compat-wireless-2009-01-05.orig/net/mac80211/wext.c compat-wireless-2009-01-05.work/net/mac80211/wext.c
--- compat-wireless-2009-01-05.orig/net/mac80211/wext.c	2009-01-06 02:07:38.000000000 +0100
+++ compat-wireless-2009-01-05/net/mac80211/wext.c	2009-01-06 02:13:21.000000000 +0100
@@ -230,13 +230,15 @@
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		sdata->u.sta.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			if (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+			    sdata->vif.type == NL80211_IFTYPE_STATION)
 				sdata->u.sta.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;

--========GMX302751231208123255535--
