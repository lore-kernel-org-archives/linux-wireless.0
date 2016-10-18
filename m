Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49458 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933007AbcJRUM0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 16:12:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 18 Oct 2016 23:12:12 +0300
Message-Id: <20161018201213.18873-7-luca@coelho.fi> (sfid-20161018_221235_820648_65828FDA)
In-Reply-To: <20161018201213.18873-1-luca@coelho.fi>
References: <20161018201213.18873-1-luca@coelho.fi>
Subject: [PATCH 6/7] mac80211: uapsd_queues is in QoS IE order
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The uapsd_queue field is in QoS IE order and not in
IEEE80211_AC_*'s order.
This means that mac80211 would get confused between
BK and BE which is certainly not such a big deal but
needs to be fixed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h     |  3 ++-
 include/net/mac80211.h     |  3 ++-
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mlme.c        |  2 +-
 net/mac80211/rx.c          |  3 ++-
 net/mac80211/sta_info.c    | 13 ++++++++-----
 net/mac80211/util.c        |  7 +++++++
 7 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5000ec7..10a26f0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4574,7 +4574,8 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr);
  *	moves to cfg80211 in this call
  * @buf: authentication frame (header + body)
  * @len: length of the frame data
- * @uapsd_queues: bitmap of ACs configured to uapsd. -1 if n/a.
+ * @uapsd_queues: bitmap of queues configured for uapsd. Same format
+ *	as the AC bitmap in the QoS info field
  *
  * After being asked to associate via cfg80211_ops::assoc() the driver must
  * call either this function or cfg80211_auth_timeout().
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a1a2702..b9b24ab 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1745,7 +1745,8 @@ struct ieee80211_sta_rates {
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
- *	if wme is supported.
+ *	if wme is supported. The bits order is like in
+ *	IEEE80211_WMM_IE_STA_QOSINFO_AC_*.
  * @max_sp: max Service Period. Only valid if wme is supported.
  * @bandwidth: current bandwidth the station can receive with
  * @rx_nss: in HT/VHT, the maximum number of spatial streams the
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 42d194a..b4e2b6c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -84,6 +84,8 @@ struct ieee80211_local;
 #define IEEE80211_DEFAULT_MAX_SP_LEN		\
 	IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL
 
+extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
+
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7486f2d..c8d3a9b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3193,7 +3193,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		uapsd_queues = 0;
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
 			if (sdata->tx_conf[ac].uapsd)
-				uapsd_queues |= BIT(ac);
+				uapsd_queues |= ieee80211_ac_to_qos_mask[ac];
 	}
 
 	cfg80211_rx_assoc_resp(sdata->dev, bss, (u8 *)mgmt, len, uapsd_queues);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 837d562..21a8947 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1401,7 +1401,8 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	 * enabled queues, but for now we only implement uAPSD w/o
 	 * TSPEC changes to the ACs, so they're always the same.
 	 */
-	if (!(sta->sta.uapsd_queues & BIT(ac)) && tid != IEEE80211_NUM_TIDS)
+	if (!(sta->sta.uapsd_queues & ieee80211_ac_to_qos_mask[ac]) &&
+	    tid != IEEE80211_NUM_TIDS)
 		return;
 
 	/* if we are in a service period, do nothing */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ab91e1e..236d47e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -709,7 +709,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		unsigned long tids;
 
-		if (ignore_for_tim & BIT(ac))
+		if (ignore_for_tim & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
 		indicate_tim |= !skb_queue_empty(&sta->tx_filtered[ac]) ||
@@ -1389,7 +1389,7 @@ ieee80211_sta_ps_more_data(struct sta_info *sta, u8 ignored_acs,
 		return true;
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		if (ignored_acs & BIT(ac))
+		if (ignored_acs & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
 		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
@@ -1414,7 +1414,7 @@ ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		unsigned long tids;
 
-		if (ignored_acs & BIT(ac))
+		if (ignored_acs & ieee80211_ac_to_qos_mask[ac])
 			continue;
 
 		tids = ieee80211_tids_for_ac(ac);
@@ -1482,7 +1482,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			BIT(find_highest_prio_tid(driver_release_tids));
 
 	if (skb_queue_empty(&frames) && !driver_release_tids) {
-		int tid;
+		int tid, ac;
 
 		/*
 		 * For PS-Poll, this can only happen due to a race condition
@@ -1500,7 +1500,10 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		 */
 
 		/* This will evaluate to 1, 3, 5 or 7. */
-		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
+		for (ac = IEEE80211_AC_VO; ac < IEEE80211_NUM_ACS; ac++)
+			if (ignored_acs & BIT(ac))
+				continue;
+		tid = 7 - 2 * ac;
 
 		ieee80211_send_null_response(sta, tid, reason, true, false);
 	} else if (!driver_release_tids) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 031273a..7f24bdc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3452,3 +3452,10 @@ void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 		*byte_cnt = txqi->tin.backlog_bytes + frag_bytes;
 }
 EXPORT_SYMBOL(ieee80211_txq_get_depth);
+
+const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS] = {
+	IEEE80211_WMM_IE_STA_QOSINFO_AC_VO,
+	IEEE80211_WMM_IE_STA_QOSINFO_AC_VI,
+	IEEE80211_WMM_IE_STA_QOSINFO_AC_BE,
+	IEEE80211_WMM_IE_STA_QOSINFO_AC_BK
+};
-- 
2.9.3
