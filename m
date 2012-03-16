Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab2CPNqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 09:46:53 -0400
Subject: RE: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1331902885.6753.10.camel@jlt3.sipsolutions.net> (sfid-20120316_140157_658300_7E065B29)
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 <1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 (sfid-20120316_140157_658300_7E065B29)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 14:46:50 +0100
Message-ID: <1331905610.6753.17.camel@jlt3.sipsolutions.net> (sfid-20120316_144657_750872_E3D9560B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 14:01 +0100, Johannes Berg wrote:

> > Not calling hw_config could affect drivers like ath9k_htc where the rate control runs in the firmware.
> > Those drivers will update the rate control based on CHANGED_HT flag.
> 
> Yeah that's actually an interesting point -- but we have it wrong right
> now I think. Did you see Paul's recent patch? We really shouldn't be
> reconfiguring the channel if all we want is to stop transmitting 40 MHz,
> we should just update rate control only. Now for in-device rate control
> that isn't really possible today since they can't get rate_update(), but
> that means we should add a separate callback, I think?

Below patch is what I've just added to my patchset. This will allow
drivers like ath9k_htc to update their internal rate control as needed
without requiring that we actually change the channel type, which we
don't want to do for the reasons we discussed with Paul in the thread
around his patch (see the thread at
http://mid.gmane.org/20120221060932.8A38C20517@glenhelen.mtv.corp.google.com and go to my later replies)

I think this is the right thing to do -- we leave the channel type set
to whatever we wanted to have to start with, and just update the 20/40
bandwidth as needed.

johannes



mac80211: notify driver of rate control updates

From: Johannes Berg <johannes.berg@intel.com>

Devices that have internal rate control need to be
notified when the bandwidth or SMPS state changes
just like external rate control algorithms get a
notification now.

Add this notification and clarify the change bits
while at it, the HT_CHANGED bit really meant only
bandwidth changed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl    |    2 -
 drivers/net/wireless/ath/ath9k/rc.c |    2 -
 include/net/mac80211.h              |   37 +++++++++++++++++++++++-------------
 net/mac80211/driver-ops.h           |   17 ++++++++++++++++
 net/mac80211/driver-trace.h         |   28 +++++++++++++++++++++++++++
 net/mac80211/mlme.c                 |    2 -
 net/mac80211/rate.h                 |    2 +
 7 files changed, 74 insertions(+), 16 deletions(-)

--- a/Documentation/DocBook/80211.tmpl	2012-03-16 14:13:10.000000000 +0100
+++ b/Documentation/DocBook/80211.tmpl	2012-03-16 14:25:57.000000000 +0100
@@ -533,7 +533,7 @@ MISSING
 !Finclude/net/mac80211.h ieee80211_start_tx_ba_cb_irqsafe
 !Finclude/net/mac80211.h ieee80211_stop_tx_ba_session
 !Finclude/net/mac80211.h ieee80211_stop_tx_ba_cb_irqsafe
-!Finclude/net/mac80211.h rate_control_changed
+!Finclude/net/mac80211.h ieee80211_rate_control_changed
 !Finclude/net/mac80211.h ieee80211_tx_rate_control
 !Finclude/net/mac80211.h rate_control_send_low
       </chapter>
--- a/include/net/mac80211.h	2012-03-16 14:14:31.000000000 +0100
+++ b/include/net/mac80211.h	2012-03-16 14:36:25.000000000 +0100
@@ -1778,6 +1778,18 @@ enum ieee80211_frame_release_type {
 };
 
 /**
+ * enum ieee80211_rate_control_changed - flags to indicate what changed
+ *
+ * @IEEE80211_RC_BW_CHANGED: The bandwidth that can be used to transmit
+ *	to this station changed.
+ * @IEEE80211_RC_SMPS_CHANGED: The SMPS state of the station changed.
+ */
+enum ieee80211_rate_control_changed {
+	IEEE80211_RC_BW_CHANGED		= BIT(0),
+	IEEE80211_RC_SMPS_CHANGED	= BIT(1),
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -1978,6 +1990,14 @@ enum ieee80211_frame_release_type {
  *	up the list of states.
  *	The callback can sleep.
  *
+ * @sta_rc_update: Notifies the driver of changes to the bitrates that can be
+ *	used to transmit to the station. The changes are advertised with bits
+ *	from &enum ieee80211_rate_control_changed and the values are reflected
+ *	in the station data. This callback should only be used when the driver
+ *	uses hardware rate control (%IEEE80211_HW_HAS_RATE_CONTROL) since
+ *	otherwise the rate control algorithm is notified directly.
+ *	Must be atomic.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *	Returns a negative error code on failure.
@@ -2194,6 +2214,10 @@ struct ieee80211_ops {
 			 struct ieee80211_sta *sta,
 			 enum ieee80211_sta_state old_state,
 			 enum ieee80211_sta_state new_state);
+	void (*sta_rc_update)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      u32 changed);
 	int (*conf_tx)(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
@@ -3510,19 +3534,6 @@ void ieee80211_send_bar(struct ieee80211
 /* Rate control API */
 
 /**
- * enum rate_control_changed - flags to indicate which parameter changed
- *
- * @IEEE80211_RC_HT_CHANGED: The HT parameters of the operating channel have
- *	changed, rate control algorithm can update its internal state if needed.
- * @IEEE80211_RC_SMPS_CHANGED: The SMPS state of the station changed, the rate
- *	control algorithm needs to adjust accordingly.
- */
-enum rate_control_changed {
-	IEEE80211_RC_HT_CHANGED		= BIT(0),
-	IEEE80211_RC_SMPS_CHANGED	= BIT(1),
-};
-
-/**
  * struct ieee80211_tx_rate_control - rate control information for/from RC algo
  *
  * @hw: The hardware the algorithm is invoked for.
--- a/drivers/net/wireless/ath/ath9k/rc.c	2012-03-16 14:14:31.000000000 +0100
+++ b/drivers/net/wireless/ath/ath9k/rc.c	2012-03-16 14:28:34.000000000 +0100
@@ -1447,7 +1447,7 @@ static void ath_rate_update(void *priv,
 
 	/* FIXME: Handle AP mode later when we support CWM */
 
-	if (changed & IEEE80211_RC_HT_CHANGED) {
+	if (changed & IEEE80211_RC_BW_CHANGED) {
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 			return;
 
--- a/net/mac80211/mlme.c	2012-03-16 14:23:40.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-16 14:28:30.000000000 +0100
@@ -219,7 +219,7 @@ static u32 ieee80211_config_ht_tx(struct
 			sta->sta.ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
 		rate_control_rate_update(local, sband, sta,
-					 IEEE80211_RC_HT_CHANGED);
+					 IEEE80211_RC_BW_CHANGED);
 	}
 	mutex_unlock(&local->sta_mtx);
 
--- a/net/mac80211/driver-trace.h	2012-03-15 20:43:13.000000000 +0100
+++ b/net/mac80211/driver-trace.h	2012-03-16 14:37:24.000000000 +0100
@@ -624,6 +624,34 @@ TRACE_EVENT(drv_sta_state,
 	)
 );
 
+TRACE_EVENT(drv_sta_rc_update,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 u32 changed),
+
+	TP_ARGS(local, sdata, sta, changed),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u32, changed)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->changed = changed;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " changed: 0x%x",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->changed
+	)
+);
+
 TRACE_EVENT(drv_sta_add,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/driver-ops.h	2012-03-15 20:43:13.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2012-03-16 14:35:54.000000000 +0100
@@ -474,6 +474,23 @@ int drv_sta_state(struct ieee80211_local
 	return ret;
 }
 
+static inline void drv_sta_rc_update(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta *sta, u32 changed)
+{
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	check_sdata_in_driver(sdata);
+
+	trace_drv_sta_rc_update(local, sdata, sta, changed);
+	if (local->ops->sta_rc_update)
+		local->ops->sta_rc_update(&local->hw, &sdata->vif,
+					  sta, changed);
+
+	trace_drv_return_void(local);
+}
+
 static inline int drv_conf_tx(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
--- a/net/mac80211/rate.h	2012-03-16 14:14:31.000000000 +0100
+++ b/net/mac80211/rate.h	2012-03-16 14:38:20.000000000 +0100
@@ -17,6 +17,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
+#include "driver-ops.h"
 
 struct rate_control_ref {
 	struct ieee80211_local *local;
@@ -72,6 +73,7 @@ static inline void rate_control_rate_upd
 	if (ref && ref->ops->rate_update)
 		ref->ops->rate_update(ref->priv, sband, ista,
 				      priv_sta, changed);
+	drv_sta_rc_update(local, sta->sdata, &sta->sta, changed);
 }
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,


