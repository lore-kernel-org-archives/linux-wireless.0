Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3BFPB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 10:01:27 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 3/4] mac80211: Improve error handling for off-channel operation
Date: Wed,  6 Feb 2013 09:01:12 -0600
Message-Id: <1360162873-17240-4-git-send-email-seth.forshee@canonical.com> (sfid-20130206_160131_718933_EE8B5EDD)
In-Reply-To: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
References: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Errors in sending the nullfunc frame to set powersave at the AP for
off-channel operation can lead to high packet loss. Add error handling
to fail going off-channel when this happens, and return an error to
userspace.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mlme.c        |    6 +++---
 net/mac80211/offchannel.c  |   24 ++++++++++++++++++------
 net/mac80211/scan.c        |   13 +++++++++++--
 4 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 505ff3c..8adfdfb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1368,7 +1368,7 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
+bool ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
@@ -1581,7 +1581,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
+bool ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d5a3cf7..0f4e21f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -664,7 +664,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *local,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
+bool ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave)
 {
@@ -674,7 +674,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif);
 	if (!skb)
-		return;
+		return false;
 
 	nullfunc = (struct ieee80211_hdr_3addr *) skb->data;
 	if (powersave)
@@ -685,7 +685,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			    IEEE80211_STA_CONNECTION_POLL))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_USE_MINRATE;
 
-	ieee80211_tx_skb_offchannel(sdata, skb);
+	return ieee80211_tx_skb_offchannel(sdata, skb) == IEEE80211_TX_OK;
 }
 
 static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 5b9b3b8..650af94 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -24,10 +24,11 @@
  * because we *may* be doing work on-operating channel, and want our
  * hardware unconditionally awake, but still let the AP send us normal frames.
  */
-static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
+static bool ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	bool ret = true;
 
 	local->offchannel_ps_enabled = false;
 
@@ -57,7 +58,9 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 		 * to send a new nullfunc frame to inform the AP that we
 		 * are again sleeping.
 		 */
-		ieee80211_send_nullfunc(local, sdata, 1);
+		ret = ieee80211_send_nullfunc(local, sdata, 1);
+
+	return ret;
 }
 
 /* inform AP that we are awake again, unless power save is enabled */
@@ -102,12 +105,13 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
+bool ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
+	bool ret = true;
 
 	if (WARN_ON(local->use_chanctx))
-		return;
+		return false;
 
 	/*
 	 * notify the AP about us leaving the channel and stop all
@@ -138,10 +142,18 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 		}
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    sdata->u.mgd.associated)
-			ieee80211_offchannel_ps_enable(sdata);
+		    sdata->u.mgd.associated) {
+			ret = ieee80211_offchannel_ps_enable(sdata);
+			if (!ret)
+				break;
+		}
 	}
 	mutex_unlock(&local->iflist_mtx);
+
+	/* Attempt to recover if failed */
+	if (!ret)
+		ieee80211_offchannel_return(local);
+	return ret;
 }
 
 void ieee80211_offchannel_return(struct ieee80211_local *local)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 607684c..beca4db 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -340,7 +340,8 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	ieee80211_offchannel_stop_vifs(local);
+	if (!ieee80211_offchannel_stop_vifs(local))
+		goto error;
 
 	ieee80211_configure_filter(local);
 
@@ -351,6 +352,10 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 				     &local->scan_work, 0);
 
 	return 0;
+
+error:
+	drv_sw_scan_complete(local);
+	return -EBUSY;
 }
 
 static bool ieee80211_can_scan(struct ieee80211_local *local,
@@ -688,7 +693,11 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
-	ieee80211_offchannel_stop_vifs(local);
+	if (!ieee80211_offchannel_stop_vifs(local)) {
+		*next_delay = 0;
+		local->next_scan_state = SCAN_ABORT;
+		return;
+	}
 
 	if (local->ops->flush) {
 		drv_flush(local, false);
-- 
1.7.9.5

