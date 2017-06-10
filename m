Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60204 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751941AbdFJKwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 06:52:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Sat, 10 Jun 2017 13:52:43 +0300
Message-Id: <20170610105246.26455-2-luca@coelho.fi> (sfid-20170610_125401_075960_21A34947)
In-Reply-To: <20170610105246.26455-1-luca@coelho.fi>
References: <20170610105246.26455-1-luca@coelho.fi>
Subject: [PATCH 1/4] mac80211: set bss_info data before configuring the channel
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When mac80211 changes the channel, it also calls into the driver's
bss_info_changed() callback, e.g. with BSS_CHANGED_IDLE. The driver
may, like iwlwifi does, access more data from bss_info in that case
and iwlwifi accesses the basic_rates bitmap, but if changing from a
band with more (basic) rates to one with fewer, an out-of-bounds
access of the rate array may result.

While we can't avoid having invalid data at some point in time, we
can avoid having it while we call the driver - so set up all the
data before configuring the channel, and then apply it afterwards.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=195677

Reported-by: Johannes Hirte <johannes.hirte@datenkhaos.de>
Tested-by: Johannes Hirte <johannes.hirte@datenkhaos.de>
Debugged-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1ae9be090309..570d9ab61950 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4397,15 +4397,19 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			return -ENOMEM;
 	}
 
-	if (new_sta || override) {
-		err = ieee80211_prep_channel(sdata, cbss);
-		if (err) {
-			if (new_sta)
-				sta_info_free(local, new_sta);
-			return -EINVAL;
-		}
-	}
-
+	/*
+	 * Set up the information for the new channel before setting the
+	 * new channel. We can't - completely race-free - change the basic
+	 * rates bitmap and the channel (sband) that it refers to, but if
+	 * we set it up before we at least avoid calling into the driver's
+	 * bss_info_changed() method with invalid information (since we do
+	 * call that from changing the channel - only for IDLE and perhaps
+	 * some others, but ...).
+	 *
+	 * So to avoid that, just set up all the new information before the
+	 * channel, but tell the driver to apply it only afterwards, since
+	 * it might need the new channel for that.
+	 */
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
@@ -4488,8 +4492,22 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.bss_conf.sync_dtim_count = 0;
 		}
 		rcu_read_unlock();
+	}
 
-		/* tell driver about BSSID, basic rates and timing */
+	if (new_sta || override) {
+		err = ieee80211_prep_channel(sdata, cbss);
+		if (err) {
+			if (new_sta)
+				sta_info_free(local, new_sta);
+			return -EINVAL;
+		}
+	}
+
+	if (new_sta) {
+		/*
+		 * tell driver about BSSID, basic rates and timing
+		 * this was set up above, before setting the channel
+		 */
 		ieee80211_bss_info_change_notify(sdata,
 			BSS_CHANGED_BSSID | BSS_CHANGED_BASIC_RATES |
 			BSS_CHANGED_BEACON_INT);
-- 
2.11.0
