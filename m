Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2GCLwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 07:52:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add TX prepare API
Date: Tue,  3 Jul 2012 13:51:56 +0200
Message-Id: <1341316316-18134-1-git-send-email-johannes@sipsolutions.net> (sfid-20120703_135204_942551_77E975FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some drivers require setup before being able to send
management frames in managed mode, in particular in
multi-channel cases.

Introduce API to allow the drivers to do such setup
while being able to sleep waiting for the setup to
finish in the device. This isn't possible inside the
TX call since that can't sleep.

A future patch may also restructure the TX retry to
wait for the driver to report the frame status, as
suggested by Arik in
http://mid.gmane.org/CA+XVXffKSEL6ZQPQ98x-zO-NL2=TNF1uN==mprRyUmAaRn254g@mail.gmail.com

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |   15 +++++++++++++++
 net/mac80211/driver-ops.h |   14 ++++++++++++++
 net/mac80211/mlme.c       |    8 ++++++++
 net/mac80211/trace.h      |    7 +++++++
 4 files changed, 44 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3f1b58c..e3fa90c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2244,6 +2244,18 @@ enum ieee80211_rate_control_changed {
  * @get_rssi: Get current signal strength in dBm, the function is optional
  *	and can sleep.
  *
+ * @mgd_prepare_tx: Prepare for transmitting a management frame for association
+ *	before associated. In multi-channel scenarios, a virtual interface is
+ *	bound to a channel before it is associated, but as it isn't associated
+ *	yet it need not necessarily be given airtime, in particular since any
+ *	transmission to a P2P GO needs to be synchronized against the GO's
+ *	powersave state. mac80211 will call this function before transmitting a
+ *	management frame prior to having successfully associated to allow the
+ *	driver to give it channel time for the transmission, to get a response
+ *	and to be able to synchronize with the GO.
+ *	The callback will be called before each transmission and upon return
+ *	mac80211 will transmit the frame right away.
+ *	The callback is optional and can (should!) sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2383,6 +2395,9 @@ struct ieee80211_ops {
 				  u32 sset, u8 *data);
 	int	(*get_rssi)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, s8 *rssi_dbm);
+
+	void	(*mgd_prepare_tx)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5042151..df92031 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -852,4 +852,18 @@ static inline int drv_get_rssi(struct ieee80211_local *local,
 
 	return ret;
 }
+
+static inline void drv_mgd_prepare_tx(struct ieee80211_local *local,
+				      struct ieee80211_sub_if_data *sdata)
+{
+	might_sleep();
+
+	check_sdata_in_driver(sdata);
+	WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
+
+	trace_drv_mgd_prepare_tx(local, sdata);
+	if (local->ops->mgd_prepare_tx)
+		local->ops->mgd_prepare_tx(&local->hw, &sdata->vif);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e9c0d1b..d563f7c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -541,6 +541,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		memcpy(pos, assoc_data->ie + offset, noffset - offset);
 	}
 
+	drv_mgd_prepare_tx(local, sdata);
+
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
 }
@@ -580,6 +582,9 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
 			IEEE80211_SKB_CB(skb)->flags |=
 				IEEE80211_TX_INTFL_DONT_ENCRYPT;
+
+		drv_mgd_prepare_tx(local, sdata);
+
 		ieee80211_tx_skb(sdata, skb);
 	}
 }
@@ -1756,6 +1761,7 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 	if (!elems.challenge)
 		return;
 	auth_data->expected_transaction = 4;
+	drv_mgd_prepare_tx(sdata->local, sdata);
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm,
 			    elems.challenge - 2, elems.challenge_len + 2,
 			    auth_data->bss->bssid, auth_data->bss->bssid,
@@ -2641,6 +2647,8 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		return -ETIMEDOUT;
 	}
 
+	drv_mgd_prepare_tx(local, sdata);
+
 	if (auth_data->bss->proberesp_ies) {
 		sdata_info(sdata, "send auth to %pM (try %d/%d)\n",
 			   auth_data->bss->bssid, auth_data->tries,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 2e60f4a..e1e9d10 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1244,6 +1244,13 @@ TRACE_EVENT(drv_get_rssi,
 	)
 );
 
+DEFINE_EVENT(local_sdata_evt, drv_mgd_prepare_tx,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(local, sdata)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
1.7.10

