Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab3A2PKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 10:10:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: start auth/assoc timeout on frame status
Date: Tue, 29 Jan 2013 16:10:54 +0100
Message-Id: <1359472254-5300-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_161035_765614_4BC3700F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When sending authentication/association frames they
might take a bit of time to go out because we may
have to synchronise with the AP, in particular in
the case where it's really a P2P GO. In this case
the 200ms fixed timeout could potentially be too
short if the beacon interval is relatively large.

For drivers that report TX status we can do better.
Instead of starting the timeout directly, start it
only when the frame status arrives. Since then the
frame was out on the air, we can wait shorter (the
typical response time is supposed to be 30ms, wait
100ms.) Also, if the frame failed to be transmitted
try again right away instead of waiting.

Change-Id: I63bda3e40824deea4f9eba2bc47aa23ed3559b83
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  5 ++-
 net/mac80211/ibss.c        |  4 +--
 net/mac80211/ieee80211_i.h | 12 +++++--
 net/mac80211/mlme.c        | 84 +++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/scan.c        |  3 +-
 net/mac80211/status.c      | 12 ++++---
 net/mac80211/util.c        | 12 +++----
 7 files changed, 102 insertions(+), 30 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bdac5e6..11729d2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -408,6 +408,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
  *	after TX status because the destination was asleep, it must not
  *	be modified again (no seqno assignment, crypto, etc.)
+ * @IEEE80211_TX_INTFL_MLME_CONN_TX: This frame was transmitted by the MLME
+ *	code for connection establishment, this indicates that its status
+ *	should kick the MLME state machine.
  * @IEEE80211_TX_INTFL_NL80211_FRAME_TX: Frame was requested through nl80211
  *	MLME command (internal to mac80211 to figure out whether to send TX
  *	status to user space)
@@ -459,7 +462,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_NO_PS_BUFFER		= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
-	/* hole at 20, use later */
+	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(20),
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b4b866f..a54c824 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -302,7 +302,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
 			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, 0, NULL, 0,
-				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
+				    addr, sdata->u.ibss.bssid, NULL, 0, 0, 0);
 	}
 	return sta;
 }
@@ -422,7 +422,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	 * has actually implemented this.
 	 */
 	ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, 0, NULL, 0,
-			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0);
+			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0, 0);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 01f7349..8bbf54b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -446,8 +446,11 @@ struct ieee80211_if_managed {
 
 	unsigned int flags;
 
-	bool beacon_crc_valid;
 	u32 beacon_crc;
+	bool beacon_crc_valid;
+
+	bool status_acked;
+	__le16 status_fc;
 
 	enum {
 		IEEE80211_MFP_DISABLED,
@@ -1323,6 +1326,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
+				  __le16 fc, bool acked);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
@@ -1583,7 +1588,8 @@ static inline void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
-			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx);
+			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx,
+			 u32 tx_flags);
 void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 				    const u8 *bssid, u16 stype, u16 reason,
 				    bool send_frame, u8 *frame_buf);
@@ -1600,7 +1606,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      u32 ratemask, bool directed, bool no_cck,
+			      u32 ratemask, bool directed, u32 tx_flags,
 			      struct ieee80211_channel *channel, bool scan);
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a64f8e3..81651ff 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -30,11 +30,13 @@
 #include "rate.h"
 #include "led.h"
 
-#define IEEE80211_AUTH_TIMEOUT (HZ / 5)
-#define IEEE80211_AUTH_MAX_TRIES 3
-#define IEEE80211_AUTH_WAIT_ASSOC (HZ * 5)
-#define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
-#define IEEE80211_ASSOC_MAX_TRIES 3
+#define IEEE80211_AUTH_TIMEOUT		(HZ / 5)
+#define IEEE80211_AUTH_TIMEOUT_SHORT	(HZ / 10)
+#define IEEE80211_AUTH_MAX_TRIES	3
+#define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
+#define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
+#define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
+#define IEEE80211_ASSOC_MAX_TRIES	3
 
 static int max_nullfunc_tries = 2;
 module_param(max_nullfunc_tries, int, 0644);
@@ -644,6 +646,9 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	drv_mgd_prepare_tx(local, sdata);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
+						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
 }
 
@@ -1716,7 +1721,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 			ssid_len = ssid[1];
 
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid_len, NULL,
-					 0, (u32) -1, true, false,
+					 0, (u32) -1, true, 0,
 					 ifmgd->associated->channel, false);
 		rcu_read_unlock();
 	}
@@ -1946,9 +1951,11 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
 	u8 *pos;
 	struct ieee802_11_elems elems;
+	u32 tx_flags = 0;
 
 	pos = mgmt->u.auth.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
@@ -1956,11 +1963,14 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata);
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
 			    elems.challenge - 2, elems.challenge_len + 2,
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
-			    auth_data->key_idx);
+			    auth_data->key_idx, tx_flags);
 }
 
 static enum rx_mgmt_action __must_check
@@ -2878,12 +2888,17 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_auth_data *auth_data = ifmgd->auth_data;
+	u32 tx_flags = 0;
 
 	lockdep_assert_held(&ifmgd->mtx);
 
 	if (WARN_ON_ONCE(!auth_data))
 		return -EINVAL;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+			   IEEE80211_TX_INTFL_MLME_CONN_TX;
+
 	auth_data->tries++;
 
 	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -2920,7 +2935,8 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
 				    auth_data->data, auth_data->data_len,
 				    auth_data->bss->bssid,
-				    auth_data->bss->bssid, NULL, 0, 0);
+				    auth_data->bss->bssid, NULL, 0, 0,
+				    tx_flags);
 	} else {
 		const u8 *ssidie;
 
@@ -2939,13 +2955,15 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		 * will not answer to direct packet in unassociated state.
 		 */
 		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
-					 NULL, 0, (u32) -1, true, false,
+					 NULL, 0, (u32) -1, true, tx_flags,
 					 auth_data->bss->channel, false);
 		rcu_read_unlock();
 	}
 
-	auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-	run_again(ifmgd, auth_data->timeout);
+	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
+		run_again(ifmgd, auth_data->timeout);
+	}
 
 	return 0;
 }
@@ -2976,12 +2994,25 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 		   IEEE80211_ASSOC_MAX_TRIES);
 	ieee80211_send_assoc(sdata);
 
-	assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
-	run_again(&sdata->u.mgd, assoc_data->timeout);
+	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
+		run_again(&sdata->u.mgd, assoc_data->timeout);
+	}
 
 	return 0;
 }
 
+void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
+				  __le16 fc, bool acked)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	sdata->u.mgd.status_fc = fc;
+	sdata->u.mgd.status_acked = acked;
+	
+	ieee80211_queue_work(&local->hw, &sdata->work);
+}
+
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -2989,6 +3020,33 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 	mutex_lock(&ifmgd->mtx);
 
+	if (ifmgd->status_fc) {
+		__le16 fc = ifmgd->status_fc;
+		bool status_acked = ifmgd->status_acked;
+
+		ifmgd->status_fc = 0;
+		if (ifmgd->auth_data &&
+		    (ieee80211_is_probe_req(fc) || ieee80211_is_auth(fc))) {
+			if (status_acked) {
+				ifmgd->auth_data->timeout =
+					jiffies + IEEE80211_AUTH_TIMEOUT_SHORT;
+				run_again(ifmgd, ifmgd->auth_data->timeout);
+			} else {
+				ifmgd->auth_data->timeout = jiffies - 1;
+			}
+		} else if (ifmgd->assoc_data &&
+			   (ieee80211_is_assoc_req(fc) ||
+			    ieee80211_is_reassoc_req(fc))) {
+			if (status_acked) {
+				ifmgd->assoc_data->timeout =
+					jiffies + IEEE80211_ASSOC_TIMEOUT_SHORT;
+				run_again(ifmgd, ifmgd->assoc_data->timeout);
+			} else {
+				ifmgd->assoc_data->timeout = jiffies - 1;
+			}
+		}
+	}
+
 	if (ifmgd->auth_data &&
 	    time_after(jiffies, ifmgd->auth_data->timeout)) {
 		if (ifmgd->auth_data->done) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 607684c..c1f8d54 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -401,7 +401,8 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
 			local->scan_req->rates[band], false,
-			local->scan_req->no_cck,
+			local->scan_req->no_cck ?
+				IEEE80211_TX_CTL_NO_CCK_RATE : 0,
 			local->hw.conf.channel, true);
 
 	/*
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 07d9957..940387d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -335,7 +335,8 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 	if (dropped)
 		acked = false;
 
-	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
+	if (info->flags & (IEEE80211_TX_INTFL_NL80211_FRAME_TX |
+			   IEEE80211_TX_INTFL_MLME_CONN_TX)) {
 		struct ieee80211_sub_if_data *sdata = NULL;
 		struct ieee80211_sub_if_data *iter_sdata;
 		u64 cookie = (unsigned long)skb;
@@ -357,10 +358,13 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 			sdata = rcu_dereference(local->p2p_sdata);
 		}
 
-		if (!sdata)
+		if (!sdata) {
 			skb->dev = NULL;
-		else if (ieee80211_is_nullfunc(hdr->frame_control) ||
-			 ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+		} else if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
+			ieee80211_mgd_conn_tx_status(sdata, hdr->frame_control,
+						     acked);
+		} else if (ieee80211_is_nullfunc(hdr->frame_control) ||
+			   ieee80211_is_qos_nullfunc(hdr->frame_control)) {
 			cfg80211_probe_status(sdata->dev, hdr->addr1,
 					      cookie, acked, GFP_ATOMIC);
 		} else {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1c74512..139ad9b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1030,7 +1030,8 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 u8 *extra, size_t extra_len, const u8 *da,
-			 const u8 *bssid, const u8 *key, u8 key_len, u8 key_idx)
+			 const u8 *bssid, const u8 *key, u8 key_len, u8 key_idx,
+			 u32 tx_flags)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -1063,7 +1064,8 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(err);
 	}
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
+					tx_flags;
 	ieee80211_tx_skb(sdata, skb);
 }
 
@@ -1277,7 +1279,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      u32 ratemask, bool directed, bool no_cck,
+			      u32 ratemask, bool directed, u32 tx_flags,
 			      struct ieee80211_channel *channel, bool scan)
 {
 	struct sk_buff *skb;
@@ -1286,9 +1288,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 					ssid, ssid_len,
 					ie, ie_len, directed);
 	if (skb) {
-		if (no_cck)
-			IEEE80211_SKB_CB(skb)->flags |=
-				IEEE80211_TX_CTL_NO_CCK_RATE;
+		IEEE80211_SKB_CB(skb)->flags |= tx_flags;
 		if (scan)
 			ieee80211_tx_skb_tid_band(sdata, skb, 7, channel->band);
 		else
-- 
1.8.0

