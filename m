Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33433 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1EVNLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 09:11:12 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4MDBBK6014002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 08:11:11 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id p4MDBAfY012343
	for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 08:11:10 -0500 (CDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2 1/2] mac80211: Stop BA session event from device
Date: Sun, 22 May 2011 16:10:21 +0300
Message-ID: <1306069822-3125-1-git-send-email-shahar_levi@ti.com> (sfid-20110522_151116_399265_5A5EF843)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices support BT/WLAN co-existence algorigthms.
In order not to harm the system performance and user experience, the device
requests not to allow any RX BA session and tear down existing RX BA sessions
based on system constraints such as periodic BT activity that needs to limit
WLAN activity (eg.SCO or A2DP).
In such cases, the intention is to limit the duration of the RX PPDU and
therefore prevent the peer device to use A-MPDU aggregation.

Adding ieee80211_stop_rx_ba_session() callback
that can be used by the driver to stop existing BA sessions.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Changes from v1:
- Use existing sta->ampdu_mlme.work work queue and add functionality to
 ieee80211_ba_session_work().
- Change reason code
- Fix patch commit message
- Move documentation from c file to h

 include/net/mac80211.h  |   17 +++++++++++++++++
 net/mac80211/agg-rx.c   |   15 +++++++++++++++
 net/mac80211/ht.c       |    6 ++++++
 net/mac80211/sta_info.h |    3 +++
 4 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c7189c..12dd3f8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2964,6 +2964,23 @@ void ieee80211_ready_on_channel(struct ieee80211_hw *hw);
  */
 void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw);
 
+/**
+ * ieee80211_stop_rx_ba_session - callback to stop existing BA sessions
+ *
+ * in order not to harm the system performance and user experience, the device
+ * may request not to allow any rx ba session and tear down existing rx ba
+ * sessions based on system constraints such as periodic BT activity that needs
+ * to limit wlan activity (eg.sco or a2dp)."
+ * in such cases, the intention is to limit the duration of the rx ppdu and
+ * therefore prevent the peer device to use a-mpdu aggregation.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @ba_rx_bitmap: Bit map of open rx ba per tid
+ * @addr: & to bssid mac address
+ */
+void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
+				  const u8 *addr);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 9c0d76c..89b0b2c 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -100,6 +100,21 @@ void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
+void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
+				  const u8 *addr)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct sta_info *sta = sta_info_get(sdata, addr);
+	int i;
+
+	for (i = 0; i < STA_TID_NUM; i++)
+		if (ba_rx_bitmap & BIT(i))
+			set_bit(i, sta->ampdu_mlme.tid_rx_stop_requested);
+
+	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
+}
+EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);
+
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 591add2..7cfc286 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -140,6 +140,12 @@ void ieee80211_ba_session_work(struct work_struct *work)
 				sta, tid, WLAN_BACK_RECIPIENT,
 				WLAN_REASON_QSTA_TIMEOUT, true);
 
+		if (test_and_clear_bit(tid,
+				       sta->ampdu_mlme.tid_rx_stop_requested))
+			___ieee80211_stop_rx_ba_session(
+				sta, tid, WLAN_BACK_RECIPIENT,
+				WLAN_REASON_UNSPECIFIED, true);
+
 		tid_tx = sta->ampdu_mlme.tid_start_tx[tid];
 		if (tid_tx) {
 			/*
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c6ae871..a06d64e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -158,6 +158,8 @@ struct tid_ampdu_rx {
  * @work: work struct for starting/stopping aggregation
  * @tid_rx_timer_expired: bitmap indicating on which TIDs the
  *	RX timer expired until the work for it runs
+ * @tid_rx_stop_requested:  bitmap indicating which BA sessions per TID the
+ *	driver requested to close until the work for it runs
  * @mtx: mutex to protect all TX data (except non-NULL assignments
  *	to tid_tx[idx], which are protected by the sta spinlock)
  */
@@ -166,6 +168,7 @@ struct sta_ampdu_mlme {
 	/* rx */
 	struct tid_ampdu_rx __rcu *tid_rx[STA_TID_NUM];
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(STA_TID_NUM)];
+	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(STA_TID_NUM)];
 	/* tx */
 	struct work_struct work;
 	struct tid_ampdu_tx __rcu *tid_tx[STA_TID_NUM];
-- 
1.7.1

