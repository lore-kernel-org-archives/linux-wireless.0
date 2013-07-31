Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab3GaIWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:22:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11] mac80211: don't wait for TX status forever
Date: Wed, 31 Jul 2013 10:22:41 +0200
Message-Id: <1375258961-26321-1-git-send-email-johannes@sipsolutions.net> (sfid-20130731_102255_451028_6D22D481)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

TX status notification can get lost, or the frames could
get stuck on the queue, so don't wait for the callback
from the driver forever and instead time out after half
a second.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fa19828..8a02018 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -31,10 +31,12 @@
 #include "led.h"
 
 #define IEEE80211_AUTH_TIMEOUT		(HZ / 5)
+#define IEEE80211_AUTH_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_AUTH_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_AUTH_MAX_TRIES	3
 #define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
+#define IEEE80211_ASSOC_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
@@ -3412,10 +3414,13 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 
 	if (tx_flags == 0) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-		ifmgd->auth_data->timeout_started = true;
+		auth_data->timeout_started = true;
 		run_again(sdata, auth_data->timeout);
 	} else {
-		auth_data->timeout_started = false;
+		auth_data->timeout =
+			round_jiffies_up(jiffies + IEEE80211_AUTH_TIMEOUT_LONG);
+		auth_data->timeout_started = true;
+		run_again(sdata, auth_data->timeout);
 	}
 
 	return 0;
@@ -3452,7 +3457,11 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 		assoc_data->timeout_started = true;
 		run_again(sdata, assoc_data->timeout);
 	} else {
-		assoc_data->timeout_started = false;
+		assoc_data->timeout =
+			round_jiffies_up(jiffies +
+					 IEEE80211_ASSOC_TIMEOUT_LONG);
+		assoc_data->timeout_started = true;
+		run_again(sdata, assoc_data->timeout);
 	}
 
 	return 0;
-- 
1.8.0

