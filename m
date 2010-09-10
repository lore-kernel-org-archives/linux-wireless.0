Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37109 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0IJTsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 15:48:43 -0400
Message-ID: <4C8A8B96.5050409@candelatech.com>
Date: Fri, 10 Sep 2010 12:48:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: RFC:  v2: Support multiple STA on same AP with ath9k
Content-Type: multipart/mixed;
 boundary="------------060902050409070408060604"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060902050409070408060604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch lets mac80111 create multiple STA on the same
AP, and the changes to ath9k let it function properly, at least for
un-encrypted traffic.  WPA does not work..no idea why yet.

It also consolidates some of the util.c iterator logic in
mac80211.

Please let me know if this is moving in the right direction.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------060902050409070408060604
Content-Type: text/plain;
 name="wt-36-vsta-ok-b.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wt-36-vsta-ok-b.patch"

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2a6e45a..26fb322 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -416,6 +416,7 @@ static void ath9k_htc_opmode_init(struct ath9k_htc_priv *priv)
 
 	/* configure bssid mask */
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+		/* NOTE:  Maybe this should be ath9k_set_bssid_mask?? */
 		ath_hw_setbssidmask(common);
 
 	/* configure operational mode */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b32c8f0..4ce4029 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -110,7 +110,6 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 static void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 
 	u32 rfilt, mfilt[2];
 
@@ -118,9 +117,15 @@ static void ath_opmode_init(struct ath_softc *sc)
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(ah, rfilt);
 
-	/* configure bssid mask */
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath_hw_setbssidmask(common);
+	/* configure bssid mask, if ah->hw is configured.
+	 * it is NOT configured when mac80211 is calling
+	 * ieee80211_do_open, but probably just as well since
+	 * this STA isn't in the list yet.
+	 */
+	if (ah->hw) {
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+			ath9k_set_bssid_mask(ah->hw);
+	}
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
@@ -426,6 +431,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 #define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
 
 	u32 rfilt;
+	int avifs = ieee80211_count_sta_atomic(sc->hw);
 
 	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
 		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
@@ -448,7 +454,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->rx.rxfilter & FIF_CONTROL)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
+	/* If we have more than one active STA, then we need to
+	 * accept more than just MYBEACON.
+	 */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (avifs <= 1) &&
 	    !(sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
@@ -463,9 +473,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (conf_is_ht(&sc->hw->conf))
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->sec_wiphy || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
-		/* TODO: only needed if more than one BSSID is in use in
-		 * station/adhoc mode */
+	if (sc->sec_wiphy || (avifs > 1) || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
 		/* The following may also be needed for other older chips */
 		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index fd20241..9c1d529 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -59,15 +59,17 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	} else
 		iter_data.count = 0;
 
-	/* Get list of all active MAC addresses */
+	/* Get list of all MAC addresses for STA and ADHOC interfaces. */
 	spin_lock_bh(&sc->wiphy_lock);
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
-						   &iter_data);
+	ieee80211_iterate_interfaces_helper(sc->hw, true, false,
+					    ath9k_vif_iter,
+					    &iter_data);
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		if (sc->sec_wiphy[i] == NULL)
 			continue;
-		ieee80211_iterate_active_interfaces_atomic(
-			sc->sec_wiphy[i]->hw, ath9k_vif_iter, &iter_data);
+		ieee80211_iterate_interfaces_helper(
+			sc->sec_wiphy[i]->hw, true, false,
+			ath9k_vif_iter, &iter_data);
 	}
 	spin_unlock_bh(&sc->wiphy_lock);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f91fc33..e87396d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2320,6 +2320,35 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						    u8 *mac,
 						    struct ieee80211_vif *vif),
 						void *data);
+/**
+ * ieee80211_iterate_interfaces_helper - iterate interfaces
+ *
+ * This function iterates over the interfaces associated with a given
+ * hardware and calls the callback for them.  If do_atomic is true,
+ * this function requires the iterator callback function to be atomic,
+ * if that is not desired, set do_atomic to false.
+ * If you want only active interfaces, set active_only to true.
+ * See also: @ieee80211_iterate_active_interfaces
+ *           @ieee80211_iterate_active_interfaces_atomic
+ *
+ * Returns number of interfaces to be filtered.
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @do_atomic:  Should iterator be treated as atomic or not.
+ * @active_only:  Should we only iterate over active interfaces.
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+int ieee80211_iterate_interfaces_helper(struct ieee80211_hw *hw,
+					bool do_atomic,
+					bool active_only,
+					void (*iterator)(void *data, u8 *mac,
+						struct ieee80211_vif *vif),
+					void *data);
+
+/** Return a count of all station-like interfaces for
+ * this hardware.  Running/Stopped state has no affect.
+ */
+int ieee80211_count_sta_atomic(struct ieee80211_hw *hw);
 
 /**
  * ieee80211_queue_work - add work onto the mac80211 workqueue
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 687077e..db751f1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (sta_info_get_bss(sdata, sta->sta.addr)) {
+	if (sta_info_get(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index bd40b11..cd54c30 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -461,16 +461,22 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-void ieee80211_iterate_active_interfaces(
+int ieee80211_iterate_interfaces_helper(
 	struct ieee80211_hw *hw,
+	bool do_atomic,
+	bool active_only,
 	void (*iterator)(void *data, u8 *mac,
 			 struct ieee80211_vif *vif),
 	void *data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
+	int cnt = 0;
 
-	mutex_lock(&local->iflist_mtx);
+	if (do_atomic)
+		rcu_read_lock();
+	else
+		mutex_lock(&local->iflist_mtx);
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
@@ -486,12 +492,30 @@ void ieee80211_iterate_active_interfaces(
 		case NL80211_IFTYPE_MESH_POINT:
 			break;
 		}
-		if (ieee80211_sdata_running(sdata))
-			iterator(data, sdata->vif.addr,
-				 &sdata->vif);
+		if (ieee80211_sdata_running(sdata) || !active_only) {
+			cnt++;
+			if (iterator)
+				iterator(data, sdata->vif.addr,
+					 &sdata->vif);
+		}
 	}
 
-	mutex_unlock(&local->iflist_mtx);
+	if (do_atomic)
+		rcu_read_unlock();
+	else
+		mutex_unlock(&local->iflist_mtx);
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_interfaces_helper);
+
+
+void ieee80211_iterate_active_interfaces(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
+{
+	ieee80211_iterate_interfaces_helper(hw, false, false, iterator, data);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
 
@@ -501,33 +525,20 @@ void ieee80211_iterate_active_interfaces_atomic(
 			 struct ieee80211_vif *vif),
 	void *data)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	ieee80211_iterate_interfaces_helper(hw, true, false, iterator, data);
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
-	rcu_read_lock();
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		switch (sdata->vif.type) {
-		case NUM_NL80211_IFTYPES:
-		case NL80211_IFTYPE_UNSPECIFIED:
-		case NL80211_IFTYPE_MONITOR:
-		case NL80211_IFTYPE_AP_VLAN:
-			continue;
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_ADHOC:
-		case NL80211_IFTYPE_WDS:
-		case NL80211_IFTYPE_MESH_POINT:
-			break;
-		}
-		if (ieee80211_sdata_running(sdata))
-			iterator(data, sdata->vif.addr,
-				 &sdata->vif);
-	}
 
-	rcu_read_unlock();
+/** Return a count of all station-like interfaces for
+ * this hardware.  Running/Stopped state has no affect.
+ */
+int ieee80211_count_sta_atomic(struct ieee80211_hw *hw)
+{
+	return ieee80211_iterate_interfaces_helper(hw, true, false, NULL, NULL);
 }
-EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
+EXPORT_SYMBOL_GPL(ieee80211_count_sta_atomic);
 
 /*
  * Nothing should have been stuffed into the workqueue during

--------------060902050409070408060604--
