Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41638 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbbIXOVW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 10:21:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: use bool argument to ieee80211_send_nullfunc
Date: Thu, 24 Sep 2015 16:21:17 +0200
Message-Id: <1443104477-26034-2-git-send-email-johannes@sipsolutions.net> (sfid-20150924_162142_922247_25C429E3)
In-Reply-To: <1443104477-26034-1-git-send-email-johannes@sipsolutions.net>
References: <1443104477-26034-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of int with 0/1, use bool with false/true for the
powersave argument to ieee80211_send_nullfunc().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mlme.c        | 10 +++++-----
 net/mac80211/offchannel.c  |  6 +++---
 net/mac80211/util.c        |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1af655a136bb..f9605f13def9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1850,7 +1850,7 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
-			     int powersave);
+			     bool powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 88894d9a25b2..88047bf6c0e0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -936,7 +936,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *local,
 
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
-			     int powersave)
+			     bool powersave)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr *nullfunc;
@@ -1420,7 +1420,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 			  msecs_to_jiffies(conf->dynamic_ps_timeout));
 	} else {
 		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
-			ieee80211_send_nullfunc(local, sdata, 1);
+			ieee80211_send_nullfunc(local, sdata, true);
 
 		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
 		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
@@ -1635,7 +1635,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 				  msecs_to_jiffies(
 				  local->hw.conf.dynamic_ps_timeout));
 		} else {
-			ieee80211_send_nullfunc(local, sdata, 1);
+			ieee80211_send_nullfunc(local, sdata, true);
 			/* Flush to get the tx status of nullfunc frame */
 			ieee80211_flush_queues(local, sdata, false);
 		}
@@ -2268,7 +2268,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
 		ifmgd->nullfunc_failed = false;
-		ieee80211_send_nullfunc(sdata->local, sdata, 0);
+		ieee80211_send_nullfunc(sdata->local, sdata, false);
 	} else {
 		int ssid_len;
 
@@ -3445,7 +3445,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				ieee80211_hw_config(local,
 						    IEEE80211_CONF_CHANGE_PS);
 			}
-			ieee80211_send_nullfunc(local, sdata, 0);
+			ieee80211_send_nullfunc(local, sdata, false);
 		} else if (!local->pspolling && sdata->u.mgd.powersave) {
 			local->pspolling = true;
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f2c75cf491fc..04401037140e 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -57,7 +57,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 		 * to send a new nullfunc frame to inform the AP that we
 		 * are again sleeping.
 		 */
-		ieee80211_send_nullfunc(local, sdata, 1);
+		ieee80211_send_nullfunc(local, sdata, true);
 }
 
 /* inform AP that we are awake again, unless power save is enabled */
@@ -66,7 +66,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	if (!local->ps_sdata)
-		ieee80211_send_nullfunc(local, sdata, 0);
+		ieee80211_send_nullfunc(local, sdata, false);
 	else if (local->offchannel_ps_enabled) {
 		/*
 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
@@ -93,7 +93,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		 * restart the timer now and send a nullfunc frame to inform
 		 * the AP that we are awake.
 		 */
-		ieee80211_send_nullfunc(local, sdata, 0);
+		ieee80211_send_nullfunc(local, sdata, false);
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 62948bbb0623..60c4dbf92625 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1966,7 +1966,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			if (!sdata->u.mgd.associated)
 				continue;
 
-			ieee80211_send_nullfunc(local, sdata, 0);
+			ieee80211_send_nullfunc(local, sdata, false);
 		}
 	}
 
-- 
2.5.1

