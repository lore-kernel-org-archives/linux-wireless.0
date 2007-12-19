Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:59604 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754136AbXLSAaj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 19:30:39 -0500
Date: Wed, 19 Dec 2007 01:25:28 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v3 1/8] mac80211: clean up rate selection
Message-ID: <20071219012528.7cb831eb@morte> (sfid-20071219_003044_282419_17F64850)
In-Reply-To: <20071219001955.055692620@polimi.it>
References: <20071219001955.055692620@polimi.it>>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Move some code out of rc80211_simple since it's probably needed for all rate
selection algorithms, and fix iwlwifi accordingly. While at it, clean up the
rate_control_get_rate() interface.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   44 ++---------------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   47 +++---------------
 net/mac80211/ieee80211.c                   |    6 --
 net/mac80211/ieee80211_rate.c              |   47 ++++++++++++++++++
 net/mac80211/ieee80211_rate.h              |   73 ++++++++++++++++++-----------
 net/mac80211/ieee80211_sta.c               |   13 +----
 net/mac80211/rc80211_simple.c              |   64 ++++---------------------
 net/mac80211/tx.c                          |   42 +++++++---------
 8 files changed, 146 insertions(+), 190 deletions(-)

Index: wireless-2.6/net/mac80211/ieee80211.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211.c
+++ wireless-2.6/net/mac80211/ieee80211.c
@@ -860,10 +860,8 @@ void ieee80211_tx_status(struct ieee8021
 			sta_info_put(sta);
 			return;
 		}
-	} else {
-		/* FIXME: STUPID to call this with both local and local->mdev */
-		rate_control_tx_status(local, local->mdev, skb, status);
-	}
+	} else
+		rate_control_tx_status(local->mdev, skb, status);

 	ieee80211_led_tx(local, 0);

Index: wireless-2.6/net/mac80211/ieee80211_rate.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.c
+++ wireless-2.6/net/mac80211/ieee80211_rate.c
@@ -147,6 +147,53 @@ static void rate_control_release(struct
 	kfree(ctrl_ref);
 }

+void rate_control_get_rate(struct net_device *dev,
+			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			   struct rate_selection *sel)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct sta_info *sta = sta_info_get(local, hdr->addr1);
+	int i;
+	u16 fc;
+
+	memset(sel, 0, sizeof(struct rate_selection));
+
+	/* Send management frames and broadcast/multicast data using lowest
+	 * rate. */
+	fc = le16_to_cpu(hdr->frame_control);
+	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	    is_multicast_ether_addr(hdr->addr1))
+		sel->rate = rate_lowest(local, mode, sta);
+
+	/* If a forced rate is in effect, select it. */
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
+		sel->rate = &mode->rates[sdata->bss->force_unicast_rateidx];
+
+	/* If we haven't found the rate yet, ask the rate control algo. */
+	if (!sel->rate)
+		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
+
+	/* Select a non-ERP backup rate. */
+	if (!sel->nonerp) {
+		for (i = 0; i < mode->num_rates - 1; i++) {
+			struct ieee80211_rate *rate = &mode->rates[i];
+			if (sel->rate->rate < rate->rate)
+				break;
+
+			if (rate_supported(sta, mode, i) &&
+			    !(rate->flags & IEEE80211_RATE_ERP))
+				sel->nonerp = rate;
+		}
+	}
+
+	if (sta)
+		sta_info_put(sta);
+}
+
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref)
 {
 	kref_get(&ref->kref);
Index: wireless-2.6/net/mac80211/ieee80211_rate.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.h
+++ wireless-2.6/net/mac80211/ieee80211_rate.h
@@ -18,31 +18,24 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"

-#define RATE_CONTROL_NUM_DOWN 20
-#define RATE_CONTROL_NUM_UP   15
-
-
-struct rate_control_extra {
-	/* values from rate_control_get_rate() to the caller: */
-	struct ieee80211_rate *probe; /* probe with this rate, or NULL for no
-				       * probing */
+struct rate_selection {
+	/* Selected transmission rate */
+	struct ieee80211_rate *rate;
+	/* Non-ERP rate to use if mac80211 decides it cannot use an ERP rate */
 	struct ieee80211_rate *nonerp;
-
-	/* parameters from the caller to rate_control_get_rate(): */
-	struct ieee80211_hw_mode *mode;
-	u16 ethertype;
+	/* probe with this rate, or NULL for no probing */
+	struct ieee80211_rate *probe;
 };

-
 struct rate_control_ops {
 	struct module *module;
 	const char *name;
 	void (*tx_status)(void *priv, struct net_device *dev,
 			  struct sk_buff *skb,
 			  struct ieee80211_tx_status *status);
-	struct ieee80211_rate *(*get_rate)(void *priv, struct net_device *dev,
-					   struct sk_buff *skb,
-					   struct rate_control_extra *extra);
+	void (*get_rate)(void *priv, struct net_device *dev,
+			 struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			 struct rate_selection *sel);
 	void (*rate_init)(void *priv, void *priv_sta,
 			  struct ieee80211_local *local, struct sta_info *sta);
 	void (*clear)(void *priv);
@@ -75,25 +68,20 @@ void ieee80211_rate_control_unregister(s
  * first available algorithm. */
 struct rate_control_ref *rate_control_alloc(const char *name,
 					    struct ieee80211_local *local);
+void rate_control_get_rate(struct net_device *dev,
+			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			   struct rate_selection *sel);
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
 void rate_control_put(struct rate_control_ref *ref);

-static inline void rate_control_tx_status(struct ieee80211_local *local,
-					  struct net_device *dev,
+static inline void rate_control_tx_status(struct net_device *dev,
 					  struct sk_buff *skb,
 					  struct ieee80211_tx_status *status)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct rate_control_ref *ref = local->rate_ctrl;
-	ref->ops->tx_status(ref->priv, dev, skb, status);
-}

-
-static inline struct ieee80211_rate *
-rate_control_get_rate(struct ieee80211_local *local, struct net_device *dev,
-		      struct sk_buff *skb, struct rate_control_extra *extra)
-{
-	struct rate_control_ref *ref = local->rate_ctrl;
-	return ref->ops->get_rate(ref->priv, dev, skb, extra);
+	ref->ops->tx_status(ref->priv, dev, skb, status);
 }


@@ -142,6 +130,37 @@ static inline void rate_control_remove_s
 #endif
 }

+static inline int
+rate_supported(struct sta_info *sta, struct ieee80211_hw_mode *mode, int index)
+{
+	return (sta == NULL || sta->supp_rates & BIT(index)) &&
+	       (mode->rates[index].flags & IEEE80211_RATE_SUPPORTED);
+}
+
+static inline int
+rate_lowest_index(struct ieee80211_local *local, struct ieee80211_hw_mode *mode,
+		  struct sta_info *sta)
+{
+	int i;
+
+	for (i = 0; i < mode->num_rates; i++) {
+		if (rate_supported(sta, mode, i))
+			return i;
+	}
+
+	/* warn when we cannot find a rate. */
+	WARN_ON(i == 0);
+
+	return 0;
+}
+
+static inline struct ieee80211_rate *
+rate_lowest(struct ieee80211_local *local, struct ieee80211_hw_mode *mode,
+	    struct sta_info *sta)
+{
+	return &mode->rates[rate_lowest_index(local, mode, sta)];
+}
+

 /* functions for rate control related to a device */
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
Index: wireless-2.6/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_sta.c
+++ wireless-2.6/net/mac80211/ieee80211_sta.c
@@ -2467,9 +2467,8 @@ static int ieee80211_sta_join_ibss(struc
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_control control;
-	struct ieee80211_rate *rate;
 	struct ieee80211_hw_mode *mode;
-	struct rate_control_extra extra;
+	struct rate_selection ratesel;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;

@@ -2554,18 +2553,16 @@ static int ieee80211_sta_join_ibss(struc
 		}

 		memset(&control, 0, sizeof(control));
-		memset(&extra, 0, sizeof(extra));
-		extra.mode = local->oper_hw_mode;
-		rate = rate_control_get_rate(local, dev, skb, &extra);
-		if (!rate) {
+		rate_control_get_rate(dev, local->oper_hw_mode, skb, &ratesel);
+		if (!ratesel.rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
 		control.tx_rate =
 			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
-			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+			(ratesel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
+			ratesel.rate->val2 : ratesel.rate->val;
 		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control.power_level = local->hw.conf.power_level;
 		control.flags |= IEEE80211_TXCTL_NO_ACK;
Index: wireless-2.6/net/mac80211/rc80211_simple.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_simple.c
+++ wireless-2.6/net/mac80211/rc80211_simple.c
@@ -23,6 +23,8 @@
 /* This is a minimal implementation of TX rate controlling that can be used
  * as the default when no improved mechanisms are available. */

+#define RATE_CONTROL_NUM_DOWN 20
+#define RATE_CONTROL_NUM_UP   15

 #define RATE_CONTROL_EMERG_DEC 2
 #define RATE_CONTROL_INTERVAL (HZ / 20)
@@ -87,26 +89,6 @@ static void rate_control_rate_dec(struct
 	}
 }

-
-static struct ieee80211_rate *
-rate_control_lowest_rate(struct ieee80211_local *local,
-			 struct ieee80211_hw_mode *mode)
-{
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		if (rate->flags & IEEE80211_RATE_SUPPORTED)
-			return rate;
-	}
-
-	printk(KERN_DEBUG "rate_control_lowest_rate - no supported rates "
-	       "found\n");
-	return &mode->rates[0];
-}
-
-
 struct global_rate_control {
 	int dummy;
 };
@@ -216,56 +198,32 @@ static void rate_control_simple_tx_statu
 }


-static struct ieee80211_rate *
+static void
 rate_control_simple_get_rate(void *priv, struct net_device *dev,
+			     struct ieee80211_hw_mode *mode,
 			     struct sk_buff *skb,
-			     struct rate_control_extra *extra)
+			     struct rate_selection *sel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_hw_mode *mode = extra->mode;
 	struct sta_info *sta;
-	int rateidx, nonerp_idx;
-	u16 fc;
-
-	memset(extra, 0, sizeof(*extra));
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    (hdr->addr1[0] & 0x01)) {
-		/* Send management frames and broadcast/multicast data using
-		 * lowest rate. */
-		/* TODO: this could probably be improved.. */
-		return rate_control_lowest_rate(local, mode);
-	}
+	int rateidx;

 	sta = sta_info_get(local, hdr->addr1);

-	if (!sta)
-		return rate_control_lowest_rate(local, mode);
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sta->txrate = sdata->bss->force_unicast_rateidx;
+	if (!sta) {
+		sel->rate = rate_lowest(local, mode, NULL);
+		return;
+	}

 	rateidx = sta->txrate;

 	if (rateidx >= mode->num_rates)
 		rateidx = mode->num_rates - 1;

-	sta->last_txrate = rateidx;
-	nonerp_idx = rateidx;
-	while (nonerp_idx > 0 &&
-	       ((mode->rates[nonerp_idx].flags & IEEE80211_RATE_ERP) ||
-		!(mode->rates[nonerp_idx].flags & IEEE80211_RATE_SUPPORTED) ||
-		!(sta->supp_rates & BIT(nonerp_idx))))
-		nonerp_idx--;
-	extra->nonerp = &mode->rates[nonerp_idx];
-
 	sta_info_put(sta);

-	return &mode->rates[rateidx];
+	sel->rate = &mode->rates[rateidx];
 }


Index: wireless-2.6/net/mac80211/tx.c
===================================================================
--- wireless-2.6.orig/net/mac80211/tx.c
+++ wireless-2.6/net/mac80211/tx.c
@@ -569,21 +569,17 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 static ieee80211_txrx_result
 ieee80211_tx_h_rate_ctrl(struct ieee80211_txrx_data *tx)
 {
-	struct rate_control_extra extra;
+	struct rate_selection rsel;

 	if (likely(!tx->u.tx.rate)) {
-		memset(&extra, 0, sizeof(extra));
-		extra.mode = tx->u.tx.mode;
-		extra.ethertype = tx->ethertype;
-
-		tx->u.tx.rate = rate_control_get_rate(tx->local, tx->dev,
-						      tx->skb, &extra);
-		if (unlikely(extra.probe != NULL)) {
+		rate_control_get_rate(tx->dev, tx->u.tx.mode, tx->skb, &rsel);
+		tx->u.tx.rate = rsel.rate;
+		if (unlikely(rsel.probe != NULL)) {
 			tx->u.tx.control->flags |=
 				IEEE80211_TXCTL_RATE_CTRL_PROBE;
 			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
 			tx->u.tx.control->alt_retry_rate = tx->u.tx.rate->val;
-			tx->u.tx.rate = extra.probe;
+			tx->u.tx.rate = rsel.probe;
 		} else
 			tx->u.tx.control->alt_retry_rate = -1;

@@ -594,14 +590,14 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021

 	if (tx->u.tx.mode->mode == MODE_IEEE80211G &&
 	    (tx->sdata->flags & IEEE80211_SDATA_USE_PROTECTION) &&
-	    (tx->flags & IEEE80211_TXRXD_FRAGMENTED) && extra.nonerp) {
+	    (tx->flags & IEEE80211_TXRXD_FRAGMENTED) && rsel.nonerp) {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
-		if (extra.probe)
+		if (rsel.probe)
 			tx->flags &= ~IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
 		else
 			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
-		tx->u.tx.rate = extra.nonerp;
-		tx->u.tx.control->rate = extra.nonerp;
+		tx->u.tx.rate = rsel.nonerp;
+		tx->u.tx.control->rate = rsel.nonerp;
 		tx->u.tx.control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 	} else {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
@@ -1667,8 +1663,7 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
-	struct ieee80211_rate *rate;
-	struct rate_control_extra extra;
+	struct rate_selection rsel;
 	u8 *b_head, *b_tail;
 	int bh_len, bt_len;

@@ -1712,14 +1707,13 @@ struct sk_buff *ieee80211_beacon_get(str
 	}

 	if (control) {
-		memset(&extra, 0, sizeof(extra));
-		extra.mode = local->oper_hw_mode;
-
-		rate = rate_control_get_rate(local, local->mdev, skb, &extra);
-		if (!rate) {
+		rate_control_get_rate(local->mdev, local->oper_hw_mode, skb,
+				      &rsel);
+		if (!rsel.rate) {
 			if (net_ratelimit()) {
-				printk(KERN_DEBUG "%s: ieee80211_beacon_get: no rate "
-				       "found\n", wiphy_name(local->hw.wiphy));
+				printk(KERN_DEBUG "%s: ieee80211_beacon_get: "
+				       "no rate found\n",
+				       wiphy_name(local->hw.wiphy));
 			}
 			dev_kfree_skb(skb);
 			return NULL;
@@ -1727,8 +1721,8 @@ struct sk_buff *ieee80211_beacon_get(str

 		control->tx_rate =
 			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
-			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+			(rsel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
+			rsel.rate->val2 : rsel.rate->val;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->power_level = local->hw.conf.power_level;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -560,22 +560,6 @@ static void rs_tx_status(void *priv_rate
 	return;
 }

-static struct ieee80211_rate *iwl3945_get_lowest_rate(struct ieee80211_local
-						  *local)
-{
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		if (rate->flags & IEEE80211_RATE_SUPPORTED)
-			return rate;
-	}
-
-	return &mode->rates[0];
-}
-
 static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
 				 u8 index, u16 rate_mask, int phymode)
 {
@@ -654,10 +638,9 @@ static u16 iwl3945_get_adjacent_rate(str
  * rate table and must reference the driver allocated rate table
  *
  */
-static struct ieee80211_rate *rs_get_rate(void *priv_rate,
-					  struct net_device *dev,
-					  struct sk_buff *skb,
-					  struct rate_control_extra *extra)
+static void rs_get_rate(void *priv_rate, struct net_device *dev,
+			struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			struct rate_selection *sel)
 {
 	u8 low = IWL_RATE_INVALID;
 	u8 high = IWL_RATE_INVALID;
@@ -674,32 +657,19 @@ static struct ieee80211_rate *rs_get_rat
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 fc, rate_mask;
+	u16 rate_mask;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	DECLARE_MAC_BUF(mac);

 	IWL_DEBUG_RATE("enter\n");

-	memset(extra, 0, sizeof(*extra));
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
-	    (is_multicast_ether_addr(hdr->addr1))) {
-		/* Send management frames and broadcast/multicast data using
-		 * lowest rate. */
-		/* TODO: this could probably be improved.. */
-		IWL_DEBUG_RATE("leave: lowest rate (not data or is "
-			       "multicast)\n");
-
-		return iwl3945_get_lowest_rate(local);
-	}
-
 	sta = sta_info_get(local, hdr->addr1);
 	if (!sta || !sta->rate_ctrl_priv) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
+		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
 		if (sta)
 			sta_info_put(sta);
-		return NULL;
+		return;
 	}

 	rate_mask = sta->supp_rates;
@@ -844,7 +814,7 @@ static struct ieee80211_rate *rs_get_rat

 	IWL_DEBUG_RATE("leave: %d\n", index);

-	return &priv->ieee_rates[index];
+	sel->rate = &priv->ieee_rates[index];
 }

 static struct rate_control_ops rs_ops = {
Index: wireless-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ wireless-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2007,56 +2007,27 @@ static void rs_initialize_lq(struct iwl4
 	return;
 }

-static struct ieee80211_rate *rs_get_lowest_rate(struct ieee80211_local
-						 *local)
+static void rs_get_rate(void *priv_rate, struct net_device *dev,
+			struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			struct rate_selection *sel)
 {
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		if (rate->flags & IEEE80211_RATE_SUPPORTED)
-			return rate;
-	}
-
-	return &mode->rates[0];
-}
-
-static struct ieee80211_rate *rs_get_rate(void *priv_rate,
-					       struct net_device *dev,
-					       struct sk_buff *skb,
-					       struct rate_control_extra
-					       *extra)
-{
-
 	int i;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
-	u16 fc;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
 	struct iwl4965_rate_scale_priv *lq;

 	IWL_DEBUG_RATE_LIMIT("rate scale calculate new rate for skb\n");

-	memset(extra, 0, sizeof(*extra));
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
-		/* Send management frames and broadcast/multicast data using
-		 * lowest rate. */
-		/* TODO: this could probably be improved.. */
-		return rs_get_lowest_rate(local);
-	}
-
 	sta = sta_info_get(local, hdr->addr1);

 	if (!sta || !sta->rate_ctrl_priv) {
+		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
 		if (sta)
 			sta_info_put(sta);
-		return rs_get_lowest_rate(local);
+		return;
 	}

 	lq = (struct iwl4965_rate_scale_priv *)sta->rate_ctrl_priv;
@@ -2083,11 +2054,13 @@ static struct ieee80211_rate *rs_get_rat
 	}

  done:
+	if ((i < 0) || (i > IWL_RATE_COUNT)) {
+		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
+		return;
+	}
 	sta_info_put(sta);
-	if ((i < 0) || (i > IWL_RATE_COUNT))
-		return rs_get_lowest_rate(local);

-	return &priv->ieee_rates[i];
+	sel->rate = &priv->ieee_rates[i];
 }

 static void *rs_alloc_sta(void *priv, gfp_t gfp)

-- 
Ciao
Stefano
