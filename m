Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbXLTKhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 05:37:04 -0500
Subject: [RFC] mac80211: add unified BSS configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 01:16:57 +0100
Message-Id: <1198109817.16241.7.camel@johannes.berg> (sfid-20071220_103713_165656_6A79CF3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch (based on Ron Rindjunsky's) creates a framework for
a unified way to pass BSS configuration to drivers that require
the information, e.g. for implementing power save mode.

A new ieee80211_bss_conf structure is embedded into each virtual
interface structure to allow the driver to access the BSS
configuration at any time, changes in the structure are passed
to the driver via the new bss_info_changed() callback.

This new BSS configuration infrastructure adds the following
new features:
 * drivers are notified of their association AID
 * drivers are notified of association status

and replaces the erp_ie_changed() callback. The patch also does
the relevant driver updates for the latter change.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Ivo, can you see if you can address the FIXME item in the rt2x00 driver?
It is probably very easy but I don't know how you'd want to handle it.

Tomas, I'm a bit confused that iwl3945 doesn't use the erp_ie_changed
callback but iwl4965 does. This seems like something that should be
addressed. I hope with this patch you can get rid of the frame sniffing
code.

Ron, I think this can replace conf_ht as well, but I'd rather do it in
an extra patch I think. With the erp replacement this patch is already
large enough but I wanted to do that here to get rid of all the
duplicate data storing. This is basically a rework of both your patches
from October.

 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 --
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 --
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   23 ++++++---
 drivers/net/wireless/rt2x00/rt2400pci.c     |    2 
 drivers/net/wireless/rt2x00/rt2500pci.c     |    2 
 drivers/net/wireless/rt2x00/rt2500usb.c     |    2 
 drivers/net/wireless/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    4 +
 drivers/net/wireless/rt2x00/rt2x00mac.c     |   15 +++---
 drivers/net/wireless/rt2x00/rt61pci.c       |    2 
 drivers/net/wireless/rt2x00/rt73usb.c       |    2 
 drivers/net/wireless/zd1211rw/zd_mac.c      |   11 ++--
 include/net/mac80211.h                      |   66 ++++++++++++++++++++-------
 net/mac80211/debugfs_netdev.c               |    2 
 net/mac80211/ieee80211.c                    |   27 ++++++-----
 net/mac80211/ieee80211_i.h                  |   10 +---
 net/mac80211/ieee80211_sta.c                |   67 ++++++++++++++--------------
 net/mac80211/tx.c                           |   13 ++---
 net/mac80211/util.c                         |   12 ++---
 19 files changed, 161 insertions(+), 116 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-20 00:48:11.002385905 +0100
+++ everything/include/net/mac80211.h	2007-12-20 01:06:37.052367893 +0100
@@ -275,6 +275,43 @@ struct ieee80211_low_level_stats {
 	unsigned int dot11RTSSuccessCount;
 };
 
+/**
+ * enum ieee80211_bss_change - BSS change notification flags
+ *
+ * These flags are used with the bss_info_changed() callback
+ * to indicate which BSS parameter changed.
+ *
+ * @BSS_CHANGED_ASSOC: association status changed (associated/disassociated),
+ *	also implies a change in the AID.
+ * @BSS_CHANGED_ERP_CTS_PROT: CTS protection changed
+ * @BSS_CHANGED_ERP_PREAMBLE: preamble changed
+ */
+enum ieee80211_bss_change {
+	BSS_CHANGED_ASSOC		= 1<<0,
+	BSS_CHANGED_ERP_CTS_PROT	= 1<<1,
+	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
+};
+
+/**
+ * struct ieee80211_bss_conf - holds the BSS's changing parameters
+ *
+ * This structure keeps information about a BSS (and an association
+ * to that BSS) that can change during the lifetime of the BSS.
+ *
+ * @assoc: association status
+ * @aid: association ID number, valid only when @assoc is true
+ * @use_cts_prot: use CTS protection
+ * @use_short_preamble: use 802.11b short preamble
+ */
+struct ieee80211_bss_conf {
+	/* association related data */
+	bool assoc;
+	u16 aid;
+	/* erp related data */
+	bool use_cts_prot;
+	bool use_short_preamble;
+};
+
 /* Transmit control fields. This data structure is passed to low-level driver
  * with each TX frame. The low-level driver is responsible for configuring
  * the hardware to use given values (depending on what is supported). */
@@ -541,6 +578,7 @@ enum ieee80211_if_types {
  */
 struct ieee80211_vif {
 	enum ieee80211_if_types type;
+	struct ieee80211_bss_conf bss_conf;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
@@ -923,19 +961,6 @@ enum ieee80211_filter_flags {
 	FIF_OTHER_BSS		= 1<<6,
 };
 
-/**
- * enum ieee80211_erp_change_flags - erp change flags
- *
- * These flags are used with the erp_ie_changed() callback in
- * &struct ieee80211_ops to indicate which parameter(s) changed.
- * @IEEE80211_ERP_CHANGE_PROTECTION: protection changed
- * @IEEE80211_ERP_CHANGE_PREAMBLE: barker preamble mode changed
- */
-enum ieee80211_erp_change_flags {
-	IEEE80211_ERP_CHANGE_PROTECTION	= 1<<0,
-	IEEE80211_ERP_CHANGE_PREAMBLE	= 1<<1,
-};
-
 
 /**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
@@ -992,6 +1017,14 @@ enum ieee80211_erp_change_flags {
  * @config_interface: Handler for configuration requests related to interfaces
  *	(e.g. BSSID changes.)
  *
+ * @bss_info_changed: Handler for configuration requests related to BSS
+ *	parameters that may vary during BSS's lifespan, and may affect low
+ *	level driver (e.g. assoc/disassoc status, erp parameters).
+ *	This function should not be used if no BSS has been set, unless
+ *	for association indication. The @changed parameter indicates which
+ *	of the bss parameters has changed when a call is made. This callback
+ *	has to be atomic.
+ *
  * @configure_filter: Configure the device's RX filter.
  *	See the section "Frame filtering" for more information.
  *	This callback must be implemented and atomic.
@@ -1026,8 +1059,6 @@ enum ieee80211_erp_change_flags {
  * @sta_notify: Notifies low level driver about addition or removal
  *	of assocaited station or AP.
  *
- * @erp_ie_changed: Handle ERP IE change notifications. Must be atomic.
- *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue. The @queue parameter uses the
  *	%IEEE80211_TX_QUEUE_* constants. Must be atomic.
@@ -1078,6 +1109,9 @@ struct ieee80211_ops {
 	int (*config_interface)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_if_conf *conf);
+	void (*bss_info_changed)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 u32 changed);
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
@@ -1097,8 +1131,6 @@ struct ieee80211_ops {
 			       u32 short_retry, u32 long_retr);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, const u8 *addr);
-	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
-			       int cts_protection, int preamble);
 	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-20 00:48:11.122375109 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-20 00:51:36.482370606 +0100
@@ -291,12 +291,7 @@ struct ieee80211_if_sta {
 /* flags used in struct ieee80211_sub_if_data.flags */
 #define IEEE80211_SDATA_ALLMULTI	BIT(0)
 #define IEEE80211_SDATA_PROMISC		BIT(1)
-#define IEEE80211_SDATA_USE_PROTECTION	BIT(2) /* CTS protect ERP frames */
-/* use short preamble with IEEE 802.11b: this flag is set when the AP or beacon
- * generator reports that there are no present stations that cannot support short
- * preambles */
-#define IEEE80211_SDATA_SHORT_PREAMBLE	BIT(3)
-#define IEEE80211_SDATA_USERSPACE_MLME	BIT(4)
+#define IEEE80211_SDATA_USERSPACE_MLME	BIT(2)
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -769,7 +764,8 @@ struct sta_info * ieee80211_ibss_add_sta
 					 u8 *addr);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
-void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
+void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				      u32 changed);
 void ieee80211_reset_erp_info(struct net_device *dev);
 int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 				   struct ieee80211_ht_info *ht_info);
--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-20 00:48:11.252371149 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-20 01:07:23.872371311 +0100
@@ -306,48 +306,42 @@ static void ieee80211_sta_wmm_params(str
 }
 
 
-static void ieee80211_handle_erp_ie(struct net_device *dev, u8 erp_value)
+static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
+				   u8 erp_value)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	int use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
-	int preamble_mode = (erp_value & WLAN_ERP_BARKER_PREAMBLE) != 0;
-	u8 changes = 0;
+	bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
+	bool preamble_mode = (erp_value & WLAN_ERP_BARKER_PREAMBLE) != 0;
 	DECLARE_MAC_BUF(mac);
+	u32 changed = 0;
 
-	if (use_protection != !!(sdata->flags & IEEE80211_SDATA_USE_PROTECTION)) {
+	if (use_protection != bss_conf->use_cts_prot) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: CTS protection %s (BSSID="
 			       "%s)\n",
-			       dev->name,
+			       sdata->dev->name,
 			       use_protection ? "enabled" : "disabled",
 			       print_mac(mac, ifsta->bssid));
 		}
-		if (use_protection)
-			sdata->flags |= IEEE80211_SDATA_USE_PROTECTION;
-		else
-			sdata->flags &= ~IEEE80211_SDATA_USE_PROTECTION;
-		changes |= IEEE80211_ERP_CHANGE_PROTECTION;
+		bss_conf->use_cts_prot = use_protection;
+		changed |= BSS_CHANGED_ERP_CTS_PROT;
 	}
 
-	if (preamble_mode != !(sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE)) {
+	if (preamble_mode != bss_conf->use_short_preamble) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: switched to %s barker preamble"
 			       " (BSSID=%s)\n",
-			       dev->name,
+			       sdata->dev->name,
 			       (preamble_mode == WLAN_ERP_PREAMBLE_SHORT) ?
 					"short" : "long",
 			       print_mac(mac, ifsta->bssid));
 		}
-		if (preamble_mode)
-			sdata->flags &= ~IEEE80211_SDATA_SHORT_PREAMBLE;
-		else
-			sdata->flags |= IEEE80211_SDATA_SHORT_PREAMBLE;
-		changes |= IEEE80211_ERP_CHANGE_PREAMBLE;
+		bss_conf->use_short_preamble = preamble_mode;
+		changed |= BSS_CHANGED_ERP_PREAMBLE;
 	}
 
-	if (changes)
-		ieee80211_erp_info_change_notify(dev, changes);
+	return changed;
 }
 
 int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
@@ -451,11 +445,10 @@ static void ieee80211_set_associated(str
 				     struct ieee80211_if_sta *ifsta,
 				     bool assoc)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	union iwreq_data wrqu;
-
-	if (!!(ifsta->flags & IEEE80211_STA_ASSOCIATED) == assoc)
-		return;
+	u32 changed = BSS_CHANGED_ASSOC;
 
 	if (assoc) {
 		struct ieee80211_sub_if_data *sdata;
@@ -472,7 +465,8 @@ static void ieee80211_set_associated(str
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			if (bss->has_erp_value)
-				ieee80211_handle_erp_ie(dev, bss->erp_value);
+				changed |= ieee80211_handle_erp_ie(
+						sdata, bss->erp_value);
 			ieee80211_rx_bss_put(dev, bss);
 		}
 
@@ -492,6 +486,8 @@ static void ieee80211_set_associated(str
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 	ifsta->last_probe = jiffies;
 	ieee80211_led_assoc(local, assoc);
+
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
 static void ieee80211_set_disassoc(struct net_device *dev,
@@ -1297,18 +1293,20 @@ static void ieee80211_rx_mgmt_disassoc(s
 }
 
 
-static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
+static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_if_sta *ifsta,
 					 struct ieee80211_mgmt *mgmt,
 					 size_t len,
 					 int reassoc)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = sdata->local;
+	struct net_device *dev = sdata->dev;
 	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
 	u32 rates;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	u8 *pos;
 	int i, j;
 	DECLARE_MAC_BUF(mac);
@@ -1381,6 +1379,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (ifsta->assocresp_ies)
 		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
 
+	/* set AID, ieee80211_set_associated() will tell the driver */
+	bss_conf->aid = aid;
 	ieee80211_set_associated(dev, ifsta, 1);
 
 	/* Add STA entry for the AP */
@@ -1860,6 +1860,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
+	u32 changed = 0;
 
 	ieee80211_rx_bss_info(dev, mgmt, len, rx_status, 1);
 
@@ -1880,7 +1881,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
 	if (elems.erp_info && elems.erp_info_len >= 1)
-		ieee80211_handle_erp_ie(dev, elems.erp_info[0]);
+		changed |= ieee80211_handle_erp_ie(sdata, elems.erp_info[0]);
 
 	if (elems.ht_cap_elem && elems.ht_info_elem &&
 	    elems.wmm_param && local->ops->conf_ht &&
@@ -1903,6 +1904,8 @@ static void ieee80211_rx_mgmt_beacon(str
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
 	}
+
+	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
 
@@ -2084,10 +2087,10 @@ static void ieee80211_sta_rx_queued_mgmt
 		ieee80211_rx_mgmt_auth(dev, ifsta, mgmt, skb->len);
 		break;
 	case IEEE80211_STYPE_ASSOC_RESP:
-		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len, 0);
+		ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt, skb->len, 0);
 		break;
 	case IEEE80211_STYPE_REASSOC_RESP:
-		ieee80211_rx_mgmt_assoc_resp(dev, ifsta, mgmt, skb->len, 1);
+		ieee80211_rx_mgmt_assoc_resp(sdata, ifsta, mgmt, skb->len, 1);
 		break;
 	case IEEE80211_STYPE_DEAUTH:
 		ieee80211_rx_mgmt_deauth(dev, ifsta, mgmt, skb->len);
@@ -2545,7 +2548,7 @@ static int ieee80211_sta_join_ibss(struc
 			break;
 		}
 		control.tx_rate =
-			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
+			(sdata->vif.bss_conf.use_short_preamble &&
 			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
 			rate->val2 : rate->val;
 		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
--- everything.orig/net/mac80211/ieee80211.c	2007-12-20 00:48:11.512371582 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-20 00:52:05.812370172 +0100
@@ -623,25 +623,28 @@ int ieee80211_hw_config_ht(struct ieee80
 	return 0;
 }
 
-void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes)
+void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				      u32 changed)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (local->ops->erp_ie_changed)
-		local->ops->erp_ie_changed(local_to_hw(local), changes,
-			!!(sdata->flags & IEEE80211_SDATA_USE_PROTECTION),
-			!(sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE));
+	struct ieee80211_local *local = sdata->local;
+
+	if (!changed)
+		return;
+
+	if (local->ops->bss_info_changed)
+		local->ops->bss_info_changed(local_to_hw(local),
+					     &sdata->vif, changed);
 }
 
 void ieee80211_reset_erp_info(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	sdata->flags &= ~(IEEE80211_SDATA_USE_PROTECTION |
-			IEEE80211_SDATA_SHORT_PREAMBLE);
-	ieee80211_erp_info_change_notify(dev,
-					 IEEE80211_ERP_CHANGE_PROTECTION |
-					 IEEE80211_ERP_CHANGE_PREAMBLE);
+	sdata->vif.bss_conf.use_cts_prot = 0;
+	sdata->vif.bss_conf.use_short_preamble = 0;
+	ieee80211_bss_info_change_notify(sdata,
+					 BSS_CHANGED_ERP_CTS_PROT |
+					 BSS_CHANGED_ERP_PREAMBLE);
 }
 
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
--- everything.orig/net/mac80211/tx.c	2007-12-20 00:48:11.562403213 +0100
+++ everything/net/mac80211/tx.c	2007-12-20 00:54:52.432369900 +0100
@@ -176,7 +176,7 @@ static u16 ieee80211_duration(struct iee
 	 * to closest integer */
 
 	dur = ieee80211_frame_duration(local, 10, rate, erp,
-		       tx->sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE);
+				tx->sdata->vif.bss_conf.use_short_preamble);
 
 	if (next_frag_len) {
 		/* Frame is fragmented: duration increases with time needed to
@@ -185,8 +185,7 @@ static u16 ieee80211_duration(struct iee
 		/* next fragment */
 		dur += ieee80211_frame_duration(local, next_frag_len,
 				txrate->rate, erp,
-				tx->sdata->flags &
-					IEEE80211_SDATA_SHORT_PREAMBLE);
+				tx->sdata->vif.bss_conf.use_short_preamble);
 	}
 
 	return dur;
@@ -609,7 +608,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		tx->u.tx.control->alt_retry_rate = -1;
 
 	if (tx->u.tx.mode->mode == MODE_IEEE80211G &&
-	    (tx->sdata->flags & IEEE80211_SDATA_USE_PROTECTION) &&
+	    tx->sdata->vif.bss_conf.use_cts_prot &&
 	    (tx->flags & IEEE80211_TXRXD_FRAGMENTED) && extra.nonerp) {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
 		if (extra.probe)
@@ -671,7 +670,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	if (mode->mode == MODE_IEEE80211G &&
 	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP) &&
 	    (tx->flags & IEEE80211_TXRXD_TXUNICAST) &&
-	    (tx->sdata->flags & IEEE80211_SDATA_USE_PROTECTION) &&
+	    tx->sdata->vif.bss_conf.use_cts_prot &&
 	    !(control->flags & IEEE80211_TXCTL_USE_RTS_CTS))
 		control->flags |= IEEE80211_TXCTL_USE_CTS_PROTECT;
 
@@ -680,7 +679,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	 * available on the network at the current point in time. */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
 	    (tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
-	    (tx->sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
+	    tx->sdata->vif.bss_conf.use_short_preamble &&
 	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
 		tx->u.tx.control->tx_rate = tx->u.tx.rate->val2;
 	}
@@ -1761,7 +1760,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		}
 
 		control->tx_rate =
-			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
+			(sdata->vif.bss_conf.use_short_preamble &&
 			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
 			rate->val2 : rate->val;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
--- everything.orig/net/mac80211/util.c	2007-12-20 00:48:11.582370280 +0100
+++ everything/net/mac80211/util.c	2007-12-20 00:55:12.382370335 +0100
@@ -294,8 +294,8 @@ __le16 ieee80211_generic_frame_duration(
 	int erp;
 
 	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
-	dur = ieee80211_frame_duration(local, frame_len, rate,
-		       erp, sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE);
+	dur = ieee80211_frame_duration(local, frame_len, rate, erp,
+				       sdata->vif.bss_conf.use_short_preamble);
 
 	return cpu_to_le16(dur);
 }
@@ -308,11 +308,11 @@ __le16 ieee80211_rts_duration(struct iee
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	int short_preamble;
+	bool short_preamble;
 	int erp;
 	u16 dur;
 
-	short_preamble = sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE;
+	short_preamble = sdata->vif.bss_conf.use_short_preamble;
 
 	rate = frame_txctl->rts_rate;
 	erp = !!(rate->flags & IEEE80211_RATE_ERP);
@@ -339,11 +339,11 @@ __le16 ieee80211_ctstoself_duration(stru
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	int short_preamble;
+	bool short_preamble;
 	int erp;
 	u16 dur;
 
-	short_preamble = sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE;
+	short_preamble = sdata->vif.bss_conf.use_short_preamble;
 
 	rate = frame_txctl->rts_rate;
 	erp = !!(rate->flags & IEEE80211_RATE_ERP);
--- everything.orig/net/mac80211/debugfs_netdev.c	2007-12-20 00:48:11.622370063 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2007-12-20 00:55:47.902370714 +0100
@@ -118,7 +118,7 @@ static ssize_t ieee80211_if_fmt_flags(
 		 sdata->u.sta.flags & IEEE80211_STA_AUTHENTICATED ? "AUTH\n" : "",
 		 sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED ? "ASSOC\n" : "",
 		 sdata->u.sta.flags & IEEE80211_STA_PROBEREQ_POLL ? "PROBEREQ POLL\n" : "",
-		 sdata->flags & IEEE80211_SDATA_USE_PROTECTION ? "CTS prot\n" : "");
+		 sdata->vif.bss_conf.use_cts_prot ? "CTS prot\n" : "");
 }
 __IEEE80211_IF_FILE(flags);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-12-20 00:48:11.642370009 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-12-20 00:48:18.242370335 +0100
@@ -3998,10 +3998,8 @@ static void iwl4965_rx_reply_rx(struct i
 			break;
 
 			/*
-			 * TODO: There is no callback function from upper
-			 * stack to inform us when associated status. this
-			 * work around to sniff assoc_resp management frame
-			 * and finish the association process.
+			 * TODO: Use the new callback function from
+			 * mac80211 instead of sniffing these packets.
 			 */
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-12-20 00:48:11.672370118 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-12-20 00:48:18.252370226 +0100
@@ -435,10 +435,8 @@ static void iwl3945_rx_reply_rx(struct i
 			break;
 
 			/*
-			 * TODO: There is no callback function from upper
-			 * stack to inform us when associated status. this
-			 * work around to sniff assoc_resp management frame
-			 * and finish the association process.
+			 * TODO: Use the new callback function from
+			 * mac80211 instead of sniffing these packets.
 			 */
 		case IEEE80211_STYPE_ASSOC_RESP:
 		case IEEE80211_STYPE_REASSOC_RESP:{
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-12-20 00:48:11.702369955 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-12-20 00:58:26.862369792 +0100
@@ -7863,25 +7863,34 @@ static void iwl4965_mac_remove_interface
 	IWL_DEBUG_MAC80211("leave\n");
 
 }
-static void iwl4965_mac_erp_ie_changed(struct ieee80211_hw *hw,
-		u8 changes, int cts_protection, int preamble)
+
+static void iwl4965_bss_info_changed(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     u32 changes)
 {
 	struct iwl4965_priv *priv = hw->priv;
 
-	if (changes & IEEE80211_ERP_CHANGE_PREAMBLE) {
-		if (preamble == WLAN_ERP_PREAMBLE_SHORT)
+	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
+		if (vif->bss_conf.use_short_preamble)
 			priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_SHORT_PREAMBLE_MSK;
 	}
 
-	if (changes & IEEE80211_ERP_CHANGE_PROTECTION) {
-		if (cts_protection && (priv->phymode != MODE_IEEE80211A))
+	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
+		if (vif->bss_conf.use_cts_prot && (priv->phymode != MODE_IEEE80211A))
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 	}
 
+	if (changes & BSS_CHANGED_ASSOC) {
+		/*
+		 * TODO:
+		 * do stuff instead of sniffing assoc resp
+		 */
+	}
+
 	if (iwl4965_is_associated(priv))
 		iwl4965_send_rxon_assoc(priv);
 }
@@ -9051,7 +9060,7 @@ static struct ieee80211_ops iwl4965_hw_o
 	.get_tsf = iwl4965_mac_get_tsf,
 	.reset_tsf = iwl4965_mac_reset_tsf,
 	.beacon_update = iwl4965_mac_beacon_update,
-	.erp_ie_changed = iwl4965_mac_erp_ie_changed,
+	.bss_info_changed = iwl4965_bss_info_changed,
 #ifdef CONFIG_IWL4965_HT
 	.conf_ht = iwl4965_mac_conf_ht,
 #ifdef CONFIG_IWL4965_HT_AGG
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2007-12-20 00:48:11.812371582 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2007-12-20 00:56:46.312373698 +0100
@@ -934,8 +934,9 @@ int rt2x00mac_get_stats(struct ieee80211
 			struct ieee80211_low_level_stats *stats);
 int rt2x00mac_get_tx_stats(struct ieee80211_hw *hw,
 			   struct ieee80211_tx_queue_stats *stats);
-void rt2x00mac_erp_ie_changed(struct ieee80211_hw *hw, u8 changes,
-			      int cts_protection, int preamble);
+void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				u32 changes);
 int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
 		      const struct ieee80211_tx_queue_params *params);
 
--- everything.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2007-12-20 00:48:11.842370118 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2400pci.c	2007-12-20 01:02:36.962367134 +0100
@@ -1558,7 +1558,7 @@ static const struct ieee80211_ops rt2400
 	.configure_filter	= rt2400pci_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2400pci_set_retry_limit,
-	.erp_ie_changed		= rt2x00mac_erp_ie_changed,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2400pci_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2400pci_get_tsf,
--- everything.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2007-12-20 00:48:11.862370335 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2500pci.c	2007-12-20 01:02:38.612370226 +0100
@@ -1867,7 +1867,7 @@ static const struct ieee80211_ops rt2500
 	.configure_filter	= rt2500pci_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt2500pci_set_retry_limit,
-	.erp_ie_changed		= rt2x00mac_erp_ie_changed,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2500pci_get_tsf,
--- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2007-12-20 00:48:11.892370280 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2500usb.c	2007-12-20 01:02:40.112370009 +0100
@@ -1770,7 +1770,7 @@ static const struct ieee80211_ops rt2500
 	.config_interface	= rt2x00mac_config_interface,
 	.configure_filter	= rt2500usb_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
-	.erp_ie_changed		= rt2x00mac_erp_ie_changed,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.beacon_update		= rt2500usb_beacon_update,
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2007-12-20 00:48:11.782372071 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2007-12-20 00:48:18.282369792 +0100
@@ -437,8 +437,10 @@ static void rt2x00lib_configuration_sche
 	    container_of(work, struct rt2x00_dev, config_work);
 	int preamble = !test_bit(CONFIG_SHORT_PREAMBLE, &rt2x00dev->flags);
 
-	rt2x00mac_erp_ie_changed(rt2x00dev->hw,
+	/* !!FIXME FIXME FIXME!!
+	rt2x00mac_bss_info_changed(rt2x00dev->hw,
 				 IEEE80211_ERP_CHANGE_PREAMBLE, 0, preamble);
+	*/
 }
 
 /*
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2007-12-20 00:48:12.012369738 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2007-12-20 00:58:43.842370770 +0100
@@ -369,23 +369,26 @@ int rt2x00mac_get_tx_stats(struct ieee80
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_get_tx_stats);
 
-void rt2x00mac_erp_ie_changed(struct ieee80211_hw *hw, u8 changes,
-			      int cts_protection, int preamble)
+void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				u32 changes)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	int short_preamble;
 	int ack_timeout;
 	int ack_consume_time;
 	int difs;
+	int preamble;
 
 	/*
 	 * We only support changing preamble mode.
 	 */
-	if (!(changes & IEEE80211_ERP_CHANGE_PREAMBLE))
+	if (!(changes & BSS_CHANGED_ERP_PREAMBLE))
 		return;
 
-	short_preamble = !preamble;
-	preamble = !!(preamble) ? PREAMBLE : SHORT_PREAMBLE;
+	short_preamble = vif->bss_conf.use_short_preamble;
+	preamble = vif->bss_conf.use_short_preamble ?
+				SHORT_PREAMBLE : PREAMBLE;
 
 	difs = (hw->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME) ?
 		SHORT_DIFS : DIFS;
@@ -401,7 +404,7 @@ void rt2x00mac_erp_ie_changed(struct iee
 	rt2x00dev->ops->lib->config_preamble(rt2x00dev, short_preamble,
 					     ack_timeout, ack_consume_time);
 }
-EXPORT_SYMBOL_GPL(rt2x00mac_erp_ie_changed);
+EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 
 int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
 		      const struct ieee80211_tx_queue_params *params)
--- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c	2007-12-20 00:48:12.162370280 +0100
+++ everything/drivers/net/wireless/rt2x00/rt61pci.c	2007-12-20 01:02:10.812369955 +0100
@@ -2474,7 +2474,7 @@ static const struct ieee80211_ops rt61pc
 	.configure_filter	= rt61pci_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt61pci_set_retry_limit,
-	.erp_ie_changed		= rt2x00mac_erp_ie_changed,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
--- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c	2007-12-20 00:48:12.192370552 +0100
+++ everything/drivers/net/wireless/rt2x00/rt73usb.c	2007-12-20 01:02:43.692371583 +0100
@@ -2023,7 +2023,7 @@ static const struct ieee80211_ops rt73us
 	.configure_filter	= rt73usb_configure_filter,
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt73usb_set_retry_limit,
-	.erp_ie_changed		= rt2x00mac_erp_ie_changed,
+	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt73usb_get_tsf,
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-20 00:48:12.262370009 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-20 00:58:58.482369956 +0100
@@ -834,17 +834,18 @@ static void set_rts_cts_work(struct work
 	mutex_unlock(&mac->chip.mutex);
 }
 
-static void zd_op_erp_ie_changed(struct ieee80211_hw *hw, u8 changes,
-				 int cts_protection, int preamble)
+static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   u32 changes)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
 
 	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
 
-	if (changes & IEEE80211_ERP_CHANGE_PREAMBLE) {
+	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
 		spin_lock_irqsave(&mac->lock, flags);
-		mac->short_preamble = !preamble;
+		mac->short_preamble = vif->bss_conf.use_short_preamble;
 		if (!mac->updating_rts_rate) {
 			mac->updating_rts_rate = 1;
 			/* FIXME: should disable TX here, until work has
@@ -864,7 +865,7 @@ static const struct ieee80211_ops zd_ops
 	.config			= zd_op_config,
 	.config_interface	= zd_op_config_interface,
 	.configure_filter	= zd_op_configure_filter,
-	.erp_ie_changed		= zd_op_erp_ie_changed,
+	.bss_info_changed	= zd_op_bss_info_changed,
 };
 
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)


