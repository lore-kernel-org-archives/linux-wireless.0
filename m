Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53829 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab0KYOjn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:39:43 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [RFC 1/2] mac80211: Stop BA session event from device
Date: Thu, 25 Nov 2010 16:39:23 +0200
Message-Id: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx device support BT/WLAN co-existence algorithm.
In order not to harm the system performance and user experience, the device may
request not to allow any RX BA session and tear down existing RX BA sessions
based on system constraints such as: For periodic BT activity limiting WLAN
activity - For example: SCO / A2DP.
In such cases, the intention is to limit the duration of the RX PPDU and
therefore prevent the peer device to use A-MPDU aggregation.

Adding new EXPORT_SYMBOL ieee80211_stop_rx_ba_session() in order
to support stop BA session event from device.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/agg-rx.c  |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5b0fff2..e6ab26d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2833,4 +2833,6 @@ ieee80211_vif_type_p2p(struct ieee80211_vif *vif)
 	return ieee80211_iftype_p2p(vif->type, vif->p2p);
 }
 
+void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 tid,
+				  const u8 *addr);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 720b7a8..09f7cd9 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -99,6 +99,16 @@ void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
+void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 tid,
+				  const u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct sta_info *sta = sta_info_get(sdata, addr);
+
+	__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0, true);
+}
+EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);
+
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
-- 
1.7.0.4

