Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab1KQPXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 10:23:34 -0500
Subject: [PATCH] mac80211: remove unused ASSOC_AP flag
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 16:23:29 +0100
Message-ID: <1321543409.3997.42.camel@jlt3.sipsolutions.net> (sfid-20111117_162337_552950_BB1CBC85)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

WLAN_STA_ASSOC_AP indicates that the station entry
is for an AP we're associated to but isn't used so
remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_sta.c |    4 ++--
 net/mac80211/mlme.c        |    1 -
 net/mac80211/sta_info.h    |    2 --
 3 files changed, 2 insertions(+), 5 deletions(-)

--- a/net/mac80211/mlme.c	2011-11-14 16:46:03.000000000 +0100
+++ b/net/mac80211/mlme.c	2011-11-17 14:46:01.000000000 +0100
@@ -1575,7 +1575,6 @@ static bool ieee80211_assoc_success(stru
 
 	set_sta_flag(sta, WLAN_STA_AUTH);
 	set_sta_flag(sta, WLAN_STA_ASSOC);
-	set_sta_flag(sta, WLAN_STA_ASSOC_AP);
 	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
 		set_sta_flag(sta, WLAN_STA_AUTHORIZED);
 
--- a/net/mac80211/sta_info.h	2011-11-10 09:27:32.000000000 +0100
+++ b/net/mac80211/sta_info.h	2011-11-17 14:46:04.000000000 +0100
@@ -30,7 +30,6 @@
  *	when virtual port control is not in use.
  * @WLAN_STA_SHORT_PREAMBLE: Station is capable of receiving short-preamble
  *	frames.
- * @WLAN_STA_ASSOC_AP: We're associated to that station, it is an AP.
  * @WLAN_STA_WME: Station is a QoS-STA.
  * @WLAN_STA_WDS: Station is one of our WDS peers.
  * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
@@ -60,7 +59,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PS_STA,
 	WLAN_STA_AUTHORIZED,
 	WLAN_STA_SHORT_PREAMBLE,
-	WLAN_STA_ASSOC_AP,
 	WLAN_STA_WME,
 	WLAN_STA_WDS,
 	WLAN_STA_CLEAR_PS_FILT,
--- a/net/mac80211/debugfs_sta.c	2011-11-08 18:04:34.000000000 +0100
+++ b/net/mac80211/debugfs_sta.c	2011-11-17 14:46:20.000000000 +0100
@@ -63,10 +63,10 @@ static ssize_t sta_flags_read(struct fil
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
-			    TEST(SHORT_PREAMBLE), TEST(ASSOC_AP),
+			    TEST(SHORT_PREAMBLE),
 			    TEST(WME), TEST(WDS), TEST(CLEAR_PS_FILT),
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),


