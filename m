Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27709 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0CILzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 06:55:38 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o29BtBiD028719
	for <linux-wireless@vger.kernel.org>; Tue, 9 Mar 2010 13:55:35 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o29BtL6e020412
	for <linux-wireless@vger.kernel.org>; Tue, 9 Mar 2010 13:55:22 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 1/1] mac80211: Add ieee80211_probereq_failed function
Date: Tue,  9 Mar 2010 13:52:52 +0200
Message-Id: <1268135572-30722-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268135572-30722-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268135572-30722-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware (i.e. the wl1271) are able to monitor beacons, and send
probe-requests to AP in case of beacon loss independently to try to recover
the connection. In these cases, it is useless for the mac80211 to send
further probe-requests.

Add a new function for the hardware to indicate that the AP has been lost.
This function immediately tears down the connection.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |   12 ++++++++++++
 net/mac80211/mlme.c    |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 45d7d44..d9792e4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2370,6 +2370,18 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  */
 void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 
+/**
+ * ieee80211_probereq_failed - inform hardware has lost connection with the AP
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
+ * IEEE80211_CONF_PS is set, the driver needs to inform with this function
+ * whenever the hardware is not receiving beacons and the AP is not responding
+ * to probe requests with this function.
+ */
+void ieee80211_probereq_failed(struct ieee80211_vif *vif);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0ab284c..8f591a4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -945,6 +945,38 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_beacon_loss);
 
+void ieee80211_probereq_failed(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
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
+	printk(KERN_DEBUG "No probe-response from AP %pM, "
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
+EXPORT_SYMBOL(ieee80211_probereq_failed);
+
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len)
-- 
1.6.3.3

