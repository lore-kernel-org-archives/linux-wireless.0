Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab0HEPF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 11:05:58 -0400
Subject: [PATCH] mac80211: allow drivers to request SM PS mode change
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 17:05:55 +0200
Message-ID: <1281020755.4058.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes drivers have more information than the
stack about how their antennas/chains are used,
and may require that the SM PS mode be changed.
This could happen, for example, when detecting
that the user disconnected an antenna. Thus this
patch introduces API to allow drivers to request
SM PS mode changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |   12 ++++++++++++
 net/mac80211/ht.c          |   28 ++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    6 +++++-
 net/mac80211/mlme.c        |    3 +++
 4 files changed, 48 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-08-05 16:12:39.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-05 17:03:03.000000000 +0200
@@ -2524,6 +2524,18 @@ void ieee80211_cqm_rssi_notify(struct ie
  */
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
 
+/**
+ * ieee80211_request_smps - request SM PS transition
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @mode: new SM PS mode
+ *
+ * This allows the driver to request an SM PS transition in managed
+ * mode. This is useful when the driver has more information than
+ * the stack about possible interference, for example by bluetooth.
+ */
+void ieee80211_request_smps(struct ieee80211_vif *vif,
+			    enum ieee80211_smps_mode smps_mode);
+
 /* Rate control API */
 
 /**
--- wireless-testing.orig/net/mac80211/ht.c	2010-07-30 16:08:28.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-08-05 17:03:03.000000000 +0200
@@ -265,3 +265,31 @@ int ieee80211_send_smps_action(struct ie
 
 	return 0;
 }
+
+void ieee80211_request_smps_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.request_smps_work);
+
+	mutex_lock(&sdata->u.mgd.mtx);
+	__ieee80211_request_smps(sdata, sdata->u.mgd.driver_smps_mode);
+	mutex_unlock(&sdata->u.mgd.mtx);
+}
+
+void ieee80211_request_smps(struct ieee80211_vif *vif,
+			    enum ieee80211_smps_mode smps_mode)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+		return;
+
+	if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
+		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+
+	ieee80211_queue_work(&sdata->local->hw,
+			     &sdata->u.mgd.request_smps_work);
+}
+/* this might change ... don't want non-open drivers using it */
+EXPORT_SYMBOL_GPL(ieee80211_request_smps);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-05 16:12:39.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-05 17:03:03.000000000 +0200
@@ -343,7 +343,10 @@ struct ieee80211_if_managed {
 	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
-				 ap_smps; /* smps mode AP thinks we're in */
+				 ap_smps, /* smps mode AP thinks we're in */
+				 driver_smps_mode; /* smps mode request */
+
+	struct work_struct request_smps_work;
 
 	unsigned int flags;
 
@@ -1108,6 +1111,7 @@ void ieee80211_send_delba(struct ieee802
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid);
+void ieee80211_request_smps_work(struct work_struct *work);
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-08-05 16:22:42.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-08-05 17:03:03.000000000 +0200
@@ -1926,6 +1926,8 @@ void ieee80211_sta_quiesce(struct ieee80
 	 * time -- the code here is properly synchronised.
 	 */
 
+	cancel_work_sync(&ifmgd->request_smps_work);
+
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
@@ -1961,6 +1963,7 @@ void ieee80211_sta_setup_sdata(struct ie
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
 		  ieee80211_beacon_connection_loss_work);
+	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,


