Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35166 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab0KSVzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 16:55:49 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/4] mac80211: calculate beacon loss time accurately
Date: Fri, 19 Nov 2010 22:55:38 +0100
Message-Id: <1290203740-57124-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290203740-57124-1-git-send-email-nbd@openwrt.org>
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using a fixed 2 second timeout, calculate beacon loss interval
from the advertised beacon interval and a frame count.  With this beacon
loss happens after N (default 7) consecutive frames are missed which
for a typical setup (100TU beacon interval) is ~700ms (or ~1/3 previous).

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7bb9a62..5bc0745 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -349,6 +349,7 @@ struct ieee80211_if_managed {
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
 
+	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
 	int probe_send_count;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7e24c3e..f2b414b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -32,10 +32,15 @@
 #define IEEE80211_MAX_PROBE_TRIES 5
 
 /*
- * beacon loss detection timeout
- * XXX: should depend on beacon interval
+ * Beacon loss timeout is calculated as N frames times the
+ * advertised beacon interval.  This may need to be somewhat
+ * higher than what hardware might detect to account for
+ * delays in the host processing frames. But since we also
+ * probe on beacon miss before declaring the connection lost
+ * default to what we want.
  */
-#define IEEE80211_BEACON_LOSS_TIME	(2 * HZ)
+#define IEEE80211_BEACON_LOSS_COUNT	7
+
 /*
  * Time the connection can be idle before we probe
  * it to see if we can still talk to the AP.
@@ -122,7 +127,7 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 		return;
 
 	mod_timer(&sdata->u.mgd.bcn_mon_timer,
-		  round_jiffies_up(jiffies + IEEE80211_BEACON_LOSS_TIME));
+		  round_jiffies_up(jiffies + sdata->u.mgd.beacon_timeout));
 }
 
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
@@ -872,6 +877,9 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 		cbss->capability, bss->has_erp_value, bss->erp_value);
 
+	sdata->u.mgd.beacon_timeout = usecs_to_jiffies(ieee80211_tu_to_usec(
+		IEEE80211_BEACON_LOSS_COUNT * bss_conf->beacon_int));
+
 	sdata->u.mgd.associated = cbss;
 	memcpy(sdata->u.mgd.bssid, cbss->bssid, ETH_ALEN);
 
-- 
1.7.3.2

