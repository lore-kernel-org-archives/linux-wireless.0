Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab1KPO3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:29:52 -0500
Message-Id: <20111116142911.501655161@sipsolutions.net> (sfid-20111116_152957_439907_F94BE74E)
Date: Wed, 16 Nov 2011 15:28:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: transmit fragment list to drivers
References: <20111116142854.518391560@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers can usually handle fragmented packets
much easier when they get the entire list of
fragments at once. The only thing they need to
do is keep enough space on the queues for up
to ten fragments of a single MSDU.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/adm8211.c                        |    1 
 drivers/net/wireless/at76c50x-usb.c                   |    1 
 drivers/net/wireless/ath/ath5k/mac80211-ops.c         |    1 
 drivers/net/wireless/ath/ath9k/htc_drv_main.c         |    1 
 drivers/net/wireless/ath/ath9k/main.c                 |    1 
 drivers/net/wireless/ath/carl9170/main.c              |    1 
 drivers/net/wireless/b43/main.c                       |    1 
 drivers/net/wireless/b43legacy/main.c                 |    1 
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    1 
 drivers/net/wireless/iwlegacy/iwl-4965.c              |    1 
 drivers/net/wireless/iwlegacy/iwl3945-base.c          |    1 
 drivers/net/wireless/iwlwifi/iwl-mac80211.c           |    1 
 drivers/net/wireless/libertas_tf/main.c               |    1 
 drivers/net/wireless/mac80211_hwsim.c                 |    1 
 drivers/net/wireless/mwl8k.c                          |    1 
 drivers/net/wireless/p54/main.c                       |    1 
 drivers/net/wireless/rt2x00/rt2400pci.c               |    1 
 drivers/net/wireless/rt2x00/rt2500pci.c               |    1 
 drivers/net/wireless/rt2x00/rt2500usb.c               |    1 
 drivers/net/wireless/rt2x00/rt2800pci.c               |    1 
 drivers/net/wireless/rt2x00/rt2800usb.c               |    1 
 drivers/net/wireless/rt2x00/rt61pci.c                 |    1 
 drivers/net/wireless/rt2x00/rt73usb.c                 |    1 
 drivers/net/wireless/rtl818x/rtl8180/dev.c            |    1 
 drivers/net/wireless/rtl818x/rtl8187/dev.c            |    1 
 drivers/net/wireless/rtlwifi/core.c                   |    1 
 drivers/net/wireless/wl1251/main.c                    |    1 
 drivers/net/wireless/wl12xx/main.c                    |    1 
 drivers/net/wireless/zd1211rw/zd_mac.c                |    1 
 drivers/staging/winbond/wbusb.c                       |    1 
 include/net/mac80211.h                                |   40 ++++++-
 net/mac80211/driver-ops.h                             |   12 ++
 net/mac80211/tx.c                                     |   98 +++++++++++-------
 33 files changed, 138 insertions(+), 42 deletions(-)

--- a/include/net/mac80211.h	2011-11-16 15:19:31.000000000 +0100
+++ b/include/net/mac80211.h	2011-11-16 15:20:03.000000000 +0100
@@ -1760,11 +1760,20 @@ enum ieee80211_frame_release_type {
  *	skb contains the buffer starting from the IEEE 802.11 header.
  *	The low-level driver should send the frame out based on
  *	configuration in the TX control data. This handler should,
- *	preferably, never fail and stop queues appropriately, more
- *	importantly, however, it must never fail for A-MPDU-queues.
- *	This function should return NETDEV_TX_OK except in very
- *	limited cases.
- *	Must be implemented and atomic.
+ *	preferably, never fail and stop queues appropriately.
+ *	This needs only be implemented if @tx_frags is set to the
+ *	ieee80211_generic_tx_frags handler.
+ *	Must be atomic.
+ *
+ * @tx_frags: Called to transmit multiple fragments of a single MSDU.
+ *	This handler must consume all fragments, sending out some of
+ *	them only is useless and it can't ask for some of them to be
+ *	queued again. If the frame is not fragmented the queue has a
+ *	single SKB only.
+ *	If this is called, the tx_info @vif and @sta pointer will be
+ *	invalid -- you must not use them in that case.
+ *	Must be implemented and atomic. If the driver implements @tx
+ *	only then this must be set to ieee80211_generic_tx_frags().
  *
  * @start: Called before the first netdevice attached to the hardware
  *	is enabled. This should turn on the hardware and must turn on
@@ -2101,6 +2110,9 @@ enum ieee80211_frame_release_type {
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
+	void (*tx_frags)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta, struct sk_buff_head *skbs,
+			 void *internal);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 #ifdef CONFIG_PM
@@ -2572,6 +2584,24 @@ void ieee80211_sta_set_buffered(struct i
 				u8 tid, bool buffered);
 
 /**
+ * ieee80211_generic_tx_frags - generic tx_frags handler
+ * @hw: the hardware
+ * @vif: virtual interface, or %NULL
+ * @sta: station, or %NULL
+ * @skbs: the skbs to transmit
+ * @internal: internal data
+ *
+ * This is the generic handler for the @tx_frags operation when
+ * the driver prefers @tx over @tx_frags for whatever reason. It
+ * must not be called in any other context.
+ */
+void ieee80211_generic_tx_frags(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct sk_buff_head *skbs,
+				void *internal);
+
+/**
  * ieee80211_tx_status - transmit status callback
  *
  * Call this function for all transmitted frames after they have been
--- a/net/mac80211/driver-ops.h	2011-11-16 15:19:31.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2011-11-16 15:20:03.000000000 +0100
@@ -15,6 +15,18 @@ static inline void drv_tx(struct ieee802
 	local->ops->tx(&local->hw, skb);
 }
 
+static inline void drv_tx_frags(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct sta_info *sta,
+				struct sk_buff_head *skbs,
+				void *internal)
+{
+	local->ops->tx_frags(&local->hw,
+			     sdata ? &sdata->vif : NULL,
+			     sta ? &sta->sta : NULL,
+			     skbs, internal);
+}
+
 static inline int drv_start(struct ieee80211_local *local)
 {
 	int ret;
--- a/net/mac80211/tx.c	2011-11-16 15:20:02.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-16 15:20:03.000000000 +0100
@@ -1203,79 +1203,103 @@ ieee80211_tx_prepare(struct ieee80211_su
 	return TX_CONTINUE;
 }
 
-/*
- * Returns false if the frame couldn't be transmitted but was queued instead.
- */
-static bool __ieee80211_tx(struct ieee80211_local *local,
-			   struct sk_buff_head *skbs, int led_len,
-			   struct sta_info *sta, bool txpending)
+struct internal_tx_data {
+	bool txpending, result;
+};
+
+void ieee80211_generic_tx_frags(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct sk_buff_head *skbs,
+				void *internal)
 {
+	struct internal_tx_data *itd = internal;
+	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb, *tmp;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
-	__le16 fc;
-
-	if (WARN_ON(skb_queue_empty(skbs)))
-		return true;
-
-	skb = skb_peek(skbs);
-	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
 
 	skb_queue_walk_safe(skbs, skb, tmp) {
 		int q = skb_get_queue_mapping(skb);
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
-		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
+		    (!itd->txpending && !skb_queue_empty(&local->pending[q]))) {
 			/*
 			 * Since queue is stopped, queue up frames for later
 			 * transmission from the tx-pending tasklet when the
 			 * queue is woken again.
 			 */
-			if (txpending)
+			if (itd->txpending)
 				skb_queue_splice(skbs, &local->pending[q]);
 			else
 				skb_queue_splice_tail(skbs, &local->pending[q]);
 
 			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 					       flags);
-			return false;
+			itd->result = false;
+			return;
 		}
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info = IEEE80211_SKB_CB(skb);
+		info->control.vif = vif;
+		info->control.sta = sta;
 
-		sdata = vif_to_sdata(info->control.vif);
+		__skb_unlink(skb, skbs);
+		drv_tx(local, skb);
+	}
 
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_MONITOR:
-			info->control.vif = NULL;
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-			info->control.vif = &container_of(sdata->bss,
-				struct ieee80211_sub_if_data, u.ap)->vif;
-			break;
-		default:
-			/* keep */
-			break;
-		}
+	itd->result = true;
+}
+EXPORT_SYMBOL(ieee80211_generic_tx_frags);
 
-		if (sta && sta->uploaded)
-			info->control.sta = &sta->sta;
-		else
-			info->control.sta = NULL;
+/*
+ * Returns false if the frame couldn't be transmitted but was queued instead.
+ */
+static bool __ieee80211_tx(struct ieee80211_local *local,
+			   struct sk_buff_head *skbs, int led_len,
+			   struct sta_info *sta, bool txpending)
+{
+	struct internal_tx_data itd = {
+		.txpending = txpending,
+		.result = true,
+	};
+	struct ieee80211_tx_info *info;
+	struct ieee80211_sub_if_data *sdata;
+	struct sk_buff *skb;
+	__le16 fc;
 
-		__skb_unlink(skb, skbs);
-		drv_tx(local, skb);
+	if (WARN_ON(skb_queue_empty(skbs)))
+		return true;
+
+	skb = skb_peek(skbs);
+	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
+	info = IEEE80211_SKB_CB(skb);
+	sdata = vif_to_sdata(info->control.vif);
+	if (sta && !sta->uploaded)
+		sta = NULL;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_MONITOR:
+		sdata = NULL;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+	default:
+		/* keep */
+		break;
 	}
 
+	drv_tx_frags(local, sdata, sta, skbs, &itd);
+
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
 	ieee80211_led_tx(local, 1);
 
 	WARN_ON(!skb_queue_empty(skbs));
 
-	return true;
+	return itd.result;
 }
 
 /*
--- a/drivers/net/wireless/adm8211.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/adm8211.c	2011-11-16 15:20:03.000000000 +0100
@@ -1747,6 +1747,7 @@ static int adm8211_alloc_rings(struct ie
 }
 
 static const struct ieee80211_ops adm8211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= adm8211_tx,
 	.start			= adm8211_start,
 	.stop			= adm8211_stop,
--- a/drivers/net/wireless/at76c50x-usb.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/at76c50x-usb.c	2011-11-16 15:20:03.000000000 +0100
@@ -2100,6 +2100,7 @@ static int at76_set_key(struct ieee80211
 }
 
 static const struct ieee80211_ops at76_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx = at76_mac80211_tx,
 	.add_interface = at76_add_interface,
 	.remove_interface = at76_remove_interface,
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c	2011-11-16 15:20:03.000000000 +0100
@@ -769,6 +769,7 @@ static int ath5k_set_ringparam(struct ie
 
 
 const struct ieee80211_ops ath5k_hw_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= ath5k_tx,
 	.start			= ath5k_start,
 	.stop			= ath5k_stop,
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-11-16 15:20:03.000000000 +0100
@@ -1757,6 +1757,7 @@ static int ath9k_htc_get_stats(struct ie
 }
 
 struct ieee80211_ops ath9k_htc_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx                 = ath9k_htc_tx,
 	.start              = ath9k_htc_start,
 	.stop               = ath9k_htc_stop,
--- a/drivers/net/wireless/ath/ath9k/main.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/ath/ath9k/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -2485,6 +2485,7 @@ static int ath9k_get_antenna(struct ieee
 }
 
 struct ieee80211_ops ath9k_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
 	.stop 		    = ath9k_stop,
--- a/drivers/net/wireless/ath/carl9170/main.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/ath/carl9170/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -1680,6 +1680,7 @@ static bool carl9170_tx_frames_pending(s
 }
 
 static const struct ieee80211_ops carl9170_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.start			= carl9170_op_start,
 	.stop			= carl9170_op_stop,
 	.tx			= carl9170_op_tx,
--- a/drivers/net/wireless/b43/main.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/b43/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -4915,6 +4915,7 @@ static int b43_op_get_survey(struct ieee
 }
 
 static const struct ieee80211_ops b43_hw_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= b43_op_tx,
 	.conf_tx		= b43_op_conf_tx,
 	.add_interface		= b43_op_add_interface,
--- a/drivers/net/wireless/b43legacy/main.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/b43legacy/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -3490,6 +3490,7 @@ static int b43legacy_op_get_survey(struc
 }
 
 static const struct ieee80211_ops b43legacy_hw_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= b43legacy_op_tx,
 	.conf_tx		= b43legacy_op_conf_tx,
 	.add_interface		= b43legacy_op_add_interface,
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c	2011-11-16 15:20:03.000000000 +0100
@@ -710,6 +710,7 @@ static void brcms_ops_flush(struct ieee8
 }
 
 static const struct ieee80211_ops brcms_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx = brcms_ops_tx,
 	.start = brcms_ops_start,
 	.stop = brcms_ops_stop,
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c	2011-11-16 15:20:03.000000000 +0100
@@ -2112,6 +2112,7 @@ static const struct iwl_legacy_ops iwl49
 };
 
 struct ieee80211_ops iwl4965_hw_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx = iwl4965_mac_tx,
 	.start = iwl4965_mac_start,
 	.stop = iwl4965_mac_stop,
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-11-16 15:20:03.000000000 +0100
@@ -3510,6 +3510,7 @@ static struct attribute_group iwl3945_at
 };
 
 struct ieee80211_ops iwl3945_hw_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx = iwl3945_mac_tx,
 	.start = iwl3945_mac_start,
 	.stop = iwl3945_mac_stop,
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c	2011-11-16 15:20:03.000000000 +0100
@@ -1577,6 +1577,7 @@ static void iwlagn_mac_sta_notify(struct
 }
 
 struct ieee80211_ops iwlagn_hw_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
 	.stop = iwlagn_mac_stop,
--- a/drivers/net/wireless/libertas_tf/main.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/libertas_tf/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -543,6 +543,7 @@ static int lbtf_op_get_survey(struct iee
 }
 
 static const struct ieee80211_ops lbtf_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= lbtf_op_tx,
 	.start			= lbtf_op_start,
 	.stop			= lbtf_op_stop,
--- a/drivers/net/wireless/mac80211_hwsim.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/mac80211_hwsim.c	2011-11-16 15:20:03.000000000 +0100
@@ -1178,6 +1178,7 @@ static void mac80211_hwsim_sw_scan_compl
 
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx = mac80211_hwsim_tx,
 	.start = mac80211_hwsim_start,
 	.stop = mac80211_hwsim_stop,
--- a/drivers/net/wireless/mwl8k.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/mwl8k.c	2011-11-16 15:20:03.000000000 +0100
@@ -5082,6 +5082,7 @@ mwl8k_ampdu_action(struct ieee80211_hw *
 }
 
 static const struct ieee80211_ops mwl8k_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= mwl8k_tx,
 	.start			= mwl8k_start,
 	.stop			= mwl8k_stop,
--- a/drivers/net/wireless/p54/main.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/p54/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -693,6 +693,7 @@ static void p54_set_coverage_class(struc
 }
 
 static const struct ieee80211_ops p54_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= p54_tx_80211,
 	.start			= p54_start,
 	.stop			= p54_stop,
--- a/drivers/net/wireless/rt2x00/rt2400pci.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c	2011-11-16 15:20:03.000000000 +0100
@@ -1699,6 +1699,7 @@ static int rt2400pci_tx_last_beacon(stru
 }
 
 static const struct ieee80211_ops rt2400pci_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rt2x00/rt2500pci.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c	2011-11-16 15:20:03.000000000 +0100
@@ -1991,6 +1991,7 @@ static int rt2500pci_tx_last_beacon(stru
 }
 
 static const struct ieee80211_ops rt2500pci_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rt2x00/rt2500usb.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c	2011-11-16 15:20:03.000000000 +0100
@@ -1808,6 +1808,7 @@ static int rt2500usb_probe_hw(struct rt2
 }
 
 static const struct ieee80211_ops rt2500usb_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rt2x00/rt2800pci.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c	2011-11-16 15:20:03.000000000 +0100
@@ -1002,6 +1002,7 @@ static int rt2800pci_probe_hw(struct rt2
 }
 
 static const struct ieee80211_ops rt2800pci_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rt2x00/rt2800usb.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c	2011-11-16 15:20:03.000000000 +0100
@@ -746,6 +746,7 @@ static int rt2800usb_probe_hw(struct rt2
 }
 
 static const struct ieee80211_ops rt2800usb_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rt2x00/rt61pci.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt61pci.c	2011-11-16 15:20:03.000000000 +0100
@@ -2956,6 +2956,7 @@ static u64 rt61pci_get_tsf(struct ieee80
 }
 
 static const struct ieee80211_ops rt61pci_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rt2x00/rt73usb.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt73usb.c	2011-11-16 15:20:03.000000000 +0100
@@ -2295,6 +2295,7 @@ static u64 rt73usb_get_tsf(struct ieee80
 }
 
 static const struct ieee80211_ops rt73usb_mac80211_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rt2x00mac_tx,
 	.start			= rt2x00mac_start,
 	.stop			= rt2x00mac_stop,
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c	2011-11-16 15:20:03.000000000 +0100
@@ -853,6 +853,7 @@ static void rtl8180_configure_filter(str
 }
 
 static const struct ieee80211_ops rtl8180_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rtl8180_tx,
 	.start			= rtl8180_start,
 	.stop			= rtl8180_stop,
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c	2011-11-16 15:20:03.000000000 +0100
@@ -1288,6 +1288,7 @@ static u64 rtl8187_get_tsf(struct ieee80
 }
 
 static const struct ieee80211_ops rtl8187_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= rtl8187_tx,
 	.start			= rtl8187_start,
 	.stop			= rtl8187_stop,
--- a/drivers/net/wireless/rtlwifi/core.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/rtlwifi/core.c	2011-11-16 15:20:03.000000000 +0100
@@ -1130,6 +1130,7 @@ static void rtl_op_flush(struct ieee8021
 }
 
 const struct ieee80211_ops rtl_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.start = rtl_op_start,
 	.stop = rtl_op_stop,
 	.tx = rtl_op_tx,
--- a/drivers/net/wireless/wl1251/main.c	2011-11-16 15:19:33.000000000 +0100
+++ b/drivers/net/wireless/wl1251/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -1227,6 +1227,7 @@ static struct ieee80211_supported_band w
 };
 
 static const struct ieee80211_ops wl1251_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.start = wl1251_op_start,
 	.stop = wl1251_op_stop,
 	.add_interface = wl1251_op_add_interface,
--- a/drivers/net/wireless/wl12xx/main.c	2011-11-16 15:19:32.000000000 +0100
+++ b/drivers/net/wireless/wl12xx/main.c	2011-11-16 15:20:03.000000000 +0100
@@ -4406,6 +4406,7 @@ static const u8 *wl1271_band_rate_to_idx
 };
 
 static const struct ieee80211_ops wl1271_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.start = wl1271_op_start,
 	.stop = wl1271_op_stop,
 	.add_interface = wl1271_op_add_interface,
--- a/drivers/net/wireless/zd1211rw/zd_mac.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c	2011-11-16 15:20:03.000000000 +0100
@@ -1339,6 +1339,7 @@ static u64 zd_op_get_tsf(struct ieee8021
 }
 
 static const struct ieee80211_ops zd_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= zd_op_tx,
 	.start			= zd_op_start,
 	.stop			= zd_op_stop,
--- a/drivers/staging/winbond/wbusb.c	2011-11-16 15:19:31.000000000 +0100
+++ b/drivers/staging/winbond/wbusb.c	2011-11-16 15:20:03.000000000 +0100
@@ -285,6 +285,7 @@ static u64 wbsoft_get_tsf(struct ieee802
 }
 
 static const struct ieee80211_ops wbsoft_ops = {
+	.tx_frags = ieee80211_generic_tx_frags,
 	.tx			= wbsoft_tx,
 	.start			= wbsoft_start,
 	.stop			= wbsoft_stop,


