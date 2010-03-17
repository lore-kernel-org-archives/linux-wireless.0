Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:57722 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0CQMzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 08:55:51 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2HCtlDi002783
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:55:49 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2HCtge6018216
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:55:43 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv3 1/1] mac80211: Add support connection monitor in hardware
Date: Wed, 17 Mar 2010 14:52:57 +0200
Message-Id: <1268830377-3450-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is based on a RFC patch by Kalle Valo.

The wl1271 has a feature which handles the connection monitor logic
in hardware, basically sending periodically nullfunc frames and reporting
to the host if AP is lost, after attempting to recover by sending
probe-requests to the AP.

Add support to mac80211 by adding a new flag IEEE80211_HW_CONNECTION_MONITOR
which prevents conn_mon_timer from triggering during idle periods, and
prevents sending probe-requests to the AP if beacon-loss is indicated by the
hardware.

Cc: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |   10 ++++++++++
 net/mac80211/mlme.c    |   38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 936bc41..ab138d2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -954,6 +954,11 @@ enum ieee80211_tkip_key_type {
  *	Hardware can provide ack status reports of Tx frames to
  *	the stack.
  *
+ * @IEEE80211_HW_CONNECTION_MONITOR:
+ *      The hardware performs its own connection monitoring, including
+ *      periodic keep-alives to the AP and probing the AP on beacon loss.
+ *      When this flag is set, signaling beacon-loss will cause an immediate
+ *      change to disassociated state.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -975,6 +980,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
+	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 };
 
 /**
@@ -2367,6 +2373,10 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
  * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
  * hardware is not receiving beacons with this function.
+ *
+ * When hardware connection monitoring is enabled with
+ * IEEE80211_HW_CONNECTION_MONITOR, this function will cause immediate change
+ * to disassociated state, without connection recovery attempts.
  */
 void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..312a210 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -854,6 +854,9 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		return;
+
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 }
@@ -931,13 +934,46 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&ifmgd->mtx);
 }
 
+static void ieee80211_beacon_loss_disassoc(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
+	u8 bssid[ETH_ALEN];
+
+	mutex_lock(&ifmgd->mtx);
+	if (!ifmgd->associated) {
+		mutex_unlock(&ifmgd->mtx);
+		return;
+	}
+
+	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
+
+	printk(KERN_DEBUG "Beacon loss from AP %pM, "
+	       "disconnected.\n", bssid);
+
+	ieee80211_set_disassoc(sdata);
+	ieee80211_recalc_idle(local);
+	mutex_unlock(&ifmgd->mtx);
+	/*
+	 * must be outside lock due to cfg80211,
+	 * but that's not a problem.
+	 */
+	ieee80211_send_deauth_disassoc(sdata, bssid,
+				       IEEE80211_STYPE_DEAUTH,
+				       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+				       NULL);
+}
+
 void ieee80211_beacon_loss_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.beacon_loss_work);
 
-	ieee80211_mgd_probe_ap(sdata, true);
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		ieee80211_beacon_loss_disassoc(sdata);
+	else
+		ieee80211_mgd_probe_ap(sdata, true);
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
-- 
1.6.3.3

