Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59139 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752187AbXLHLVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:21:52 -0500
Subject: [PATCH 1/4] mac80211: Clean up rate selection
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1197112439.7472.34.camel@localhost>
References: <1197112439.7472.34.camel@localhost>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:21:49 +0100
Message-Id: <1197112909.7472.49.camel@localhost> (sfid-20071208_112159_240600_F494B452)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move some code out of rc80211_simple since it's probably needed for all rate
selection algorithms. While at it, clean up the rate_control_get_rate()
interface.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 net/mac80211/ieee80211_rate.c |   47 ++++++++++++++++++++++++++++
 net/mac80211/ieee80211_rate.h |   68 ++++++++++++++++++++++++++---------------
 net/mac80211/ieee80211_sta.c  |   13 +++-----
 net/mac80211/rc80211_simple.c |   64 ++++++--------------------------------
 net/mac80211/tx.c             |   42 +++++++++++--------------
 5 files changed, 124 insertions(+), 110 deletions(-)

diff --git a/net/mac80211/ieee80211_rate.c b/net/mac80211/ieee80211_rate.c
index 7254bd6..a2f8d64 100644
--- a/net/mac80211/ieee80211_rate.c
+++ b/net/mac80211/ieee80211_rate.c
@@ -146,6 +146,53 @@ static void rate_control_release(struct kref *kref)
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
+	    (hdr->addr1[0] & 0x01))
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
diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index 2368813..ceb7783 100644
--- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
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
@@ -75,6 +68,9 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
  * first available algorithm. */
 struct rate_control_ref *rate_control_alloc(const char *name,
 					    struct ieee80211_local *local);
+void rate_control_get_rate(struct net_device *dev,
+			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			   struct rate_selection *sel);
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
 void rate_control_put(struct rate_control_ref *ref);
 
@@ -88,15 +84,6 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 }
 

-static inline struct ieee80211_rate *
-rate_control_get_rate(struct ieee80211_local *local, struct net_device *dev,
-		      struct sk_buff *skb, struct rate_control_extra *extra)
-{
-	struct rate_control_ref *ref = local->rate_ctrl;
-	return ref->ops->get_rate(ref->priv, dev, skb, extra);
-}
-
-
 static inline void rate_control_rate_init(struct sta_info *sta,
 					  struct ieee80211_local *local)
 {
@@ -142,6 +129,37 @@ static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
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
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2a321f0..e55a9f4 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2208,9 +2208,8 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_control control;
-	struct ieee80211_rate *rate;
 	struct ieee80211_hw_mode *mode;
-	struct rate_control_extra extra;
+	struct rate_selection ratesel;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
 
@@ -2295,18 +2294,16 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
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
diff --git a/net/mac80211/rc80211_simple.c b/net/mac80211/rc80211_simple.c
index da72737..c1c8b76 100644
--- a/net/mac80211/rc80211_simple.c
+++ b/net/mac80211/rc80211_simple.c
@@ -23,6 +23,8 @@
 /* This is a minimal implementation of TX rate controlling that can be used
  * as the default when no improved mechanisms are available. */
 
+#define RATE_CONTROL_NUM_DOWN 20
+#define RATE_CONTROL_NUM_UP   15
 
 #define RATE_CONTROL_EMERG_DEC 2
 #define RATE_CONTROL_INTERVAL (HZ / 20)
@@ -87,26 +89,6 @@ static void rate_control_rate_dec(struct ieee80211_local *local,
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
@@ -216,56 +198,32 @@ static void rate_control_simple_tx_status(void *priv, struct net_device *dev,
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
 

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9ccf4b5..0ccc03d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -567,21 +567,17 @@ ieee80211_tx_h_encrypt(struct ieee80211_txrx_data *tx)
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
 
@@ -592,14 +588,14 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_txrx_data *tx)
 
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
@@ -1665,8 +1661,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
-	struct ieee80211_rate *rate;
-	struct rate_control_extra extra;
+	struct rate_selection rsel;
 	u8 *b_head, *b_tail;
 	int bh_len, bt_len;
 
@@ -1710,14 +1705,13 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
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
@@ -1725,8 +1719,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
 
 		control->tx_rate =
 			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
-			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+			(rsel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
+			rsel.rate->val2 : rsel.rate->val;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->power_level = local->hw.conf.power_level;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
-- 
1.5.3.4

