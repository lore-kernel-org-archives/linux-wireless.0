Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:30134
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbcBYLc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 06:32:27 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] nl80211: use ieee80211_band in kernel space
Date: Thu, 25 Feb 2016 12:32:21 +0100
Message-Id: <1456399941-8408-1-git-send-email-arend@broadcom.com> (sfid-20160225_123232_236316_15795CA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The enumeration nl80211_band intends to expose the public part of
ieee80211_band enumeration. As such it should not be used in the
kernel. This patch changes nl80211_band usage to ieee80211_band.

Reported-by: kbuild robot <lkp@intel.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/net/cfg80211.h | 4 ++--
 net/wireless/nl80211.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1dfb890..c6ddb69 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1863,7 +1863,7 @@ struct cfg80211_ibss_params {
  * @delta: value of RSSI level adjustment.
  */
 struct cfg80211_bss_select_adjust {
-	enum nl80211_band band;
+	enum ieee80211_band band;
 	s8 delta;
 };
 
@@ -1878,7 +1878,7 @@ struct cfg80211_bss_select_adjust {
 struct cfg80211_bss_selection {
 	enum nl80211_bss_select_attr behaviour;
 	union {
-		enum nl80211_band band_pref;
+		enum ieee80211_band band_pref;
 		struct cfg80211_bss_select_adjust adjust;
 	} param;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 52ce26f..1f6d8e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5786,7 +5786,7 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
-static bool is_band_valid(struct wiphy *wiphy, enum nl80211_band b)
+static bool is_band_valid(struct wiphy *wiphy, enum ieee80211_band b)
 {
 	return b < IEEE80211_NUM_BANDS && wiphy->bands[b];
 }
-- 
1.9.1

