Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20724 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936097Ab0COMMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 08:12:06 -0400
Received: from mgw-mx06.nokia.com (mgw-mx06.nokia.com [192.100.122.233])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FBPT0U029189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:25:30 +0200
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FB07MM020531
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:00:13 +0200
Received: from localhost.localdomain (trdhcp21227.nmp.nokia.com [172.22.212.27])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FB04ui011263
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 13:00:06 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 1/1] mac80211: Add support connection monitor in hardware
Date: Mon, 15 Mar 2010 12:57:23 +0200
Message-Id: <1268650643-23191-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268650643-23191-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268650643-23191-1-git-send-email-juuso.oikarinen@nokia.com>
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
 include/net/mac80211.h |    4 ++++
 net/mac80211/mlme.c    |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 936bc41..cd7b471 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -954,6 +954,9 @@ enum ieee80211_tkip_key_type {
  *	Hardware can provide ack status reports of Tx frames to
  *	the stack.
  *
+ * @IEEE80211_HW_CONNECTION_MONITOR:
+ *      The hardware performs its own connection monitoring, including
+ *      periodic keep-alives to the AP and probing the AP on beacon loss.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -975,6 +978,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
+	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..aa40e43 100644
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
@@ -936,8 +939,36 @@ void ieee80211_beacon_loss_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.beacon_loss_work);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
+	u8 bssid[ETH_ALEN];
+
+	if (!(sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR))
+		ieee80211_mgd_probe_ap(sdata, true);
+	else {
+		mutex_lock(&ifmgd->mtx);
+		if (!ifmgd->associated) {
+			mutex_unlock(&ifmgd->mtx);
+			return;
+		}
 
-	ieee80211_mgd_probe_ap(sdata, true);
+		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
+
+		printk(KERN_DEBUG "No probe-response from AP %pM, "
+		       "disconnected.\n", bssid);
+
+		ieee80211_set_disassoc(sdata);
+		ieee80211_recalc_idle(local);
+		mutex_unlock(&ifmgd->mtx);
+		/*
+		 * must be outside lock due to cfg80211,
+		 * but that's not a problem.
+		 */
+		ieee80211_send_deauth_disassoc(sdata, bssid,
+					       IEEE80211_STYPE_DEAUTH,
+					       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+					       NULL);
+	}
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
-- 
1.6.3.3

