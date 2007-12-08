Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37090 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751462AbXLHLV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:21:56 -0500
Subject: [PATCH 3/4] mac80211: Add PID TX rate control algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1197112439.7472.34.camel@localhost>
References: <1197112439.7472.34.camel@localhost>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:21:53 +0100
Message-Id: <1197112913.7472.51.camel@localhost> (sfid-20071208_112201_740345_3052FB94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new rate control algorithm based on a PID controller. It samples the
percentage of failed frames over time, feeds the result into the controller and
uses it's output to control the TX rate.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
---
 net/mac80211/Kconfig          |   12 ++
 net/mac80211/Makefile         |    1 +
 net/mac80211/ieee80211.c      |   27 +++-
 net/mac80211/ieee80211_rate.h |    3 +
 net/mac80211/rc80211_pid.c    |  368 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 406 insertions(+), 5 deletions(-)
 create mode 100644 net/mac80211/rc80211_pid.c

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index ce176e6..ebe3360 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -25,6 +25,18 @@ config MAC80211_RCSIMPLE
 	  Say Y unless you know you will have another algorithm
 	  available.
 
+config MAC80211_RCPID
+	bool "'PID' rate control algorithm" if EMBEDDED
+	default y
+	depends on MAC80211
+	help
+	  This option enables a TX rate control algorithm for
+	  mac80211 that uses a PID controller to select the TX
+	  rate.
+
+	  Say Y unless you're sure you want to use a different
+	  rate control algorithm.
+
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211 && LEDS_TRIGGERS
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1e6237b..62c01ca 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -4,6 +4,7 @@ mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
 mac80211-objs-$(CONFIG_MAC80211_RCSIMPLE) += rc80211_simple.o
+mac80211-objs-$(CONFIG_MAC80211_RCPID) += rc80211_pid.o
 
 mac80211-objs := \
 	ieee80211.o \
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 59350b8..62eaed4 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1260,23 +1260,37 @@ static int __init ieee80211_init(void)
 #ifdef CONFIG_MAC80211_RCSIMPLE
 	ret = ieee80211_rate_control_register(&mac80211_rcsimple);
 	if (ret)
-		return ret;
+		goto fail;
+#endif
+
+#ifdef CONFIG_MAC80211_RCPID
+	ret = ieee80211_rate_control_register(&mac80211_rcpid);
+	if (ret)
+		goto fail;
 #endif
 
 	ret = ieee80211_wme_register();
 	if (ret) {
-#ifdef CONFIG_MAC80211_RCSIMPLE
-		ieee80211_rate_control_unregister(&mac80211_rcsimple);
-#endif
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
-		return ret;
+		goto fail;
 	}
 
 	ieee80211_debugfs_netdev_init();
 	ieee80211_regdomain_init();
 
 	return 0;
+
+fail:
+
+#ifdef CONFIG_MAC80211_RCSIMPLE
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+#endif
+#ifdef CONFIG_MAC80211_RCPID
+	ieee80211_rate_control_unregister(&mac80211_rcpid);
+#endif
+
+	return ret;
 }
 
 static void __exit ieee80211_exit(void)
@@ -1284,6 +1298,9 @@ static void __exit ieee80211_exit(void)
 #ifdef CONFIG_MAC80211_RCSIMPLE
 	ieee80211_rate_control_unregister(&mac80211_rcsimple);
 #endif
+#ifdef CONFIG_MAC80211_RCPID
+	ieee80211_rate_control_unregister(&mac80211_rcpid);
+#endif
 
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
diff --git a/net/mac80211/ieee80211_rate.h b/net/mac80211/ieee80211_rate.h
index ceb7783..8520184 100644
--- a/net/mac80211/ieee80211_rate.h
+++ b/net/mac80211/ieee80211_rate.h
@@ -61,6 +61,9 @@ struct rate_control_ref {
 /* default 'simple' algorithm */
 extern struct rate_control_ops mac80211_rcsimple;
 
+/* 'PID' algorithm */
+extern struct rate_control_ops mac80211_rcpid;
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
diff --git a/net/mac80211/rc80211_pid.c b/net/mac80211/rc80211_pid.c
new file mode 100644
index 0000000..c1a39ef
--- /dev/null
+++ b/net/mac80211/rc80211_pid.c
@@ -0,0 +1,368 @@
+/*
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+#include <net/mac80211.h>
+#include "ieee80211_rate.h"
+
+
+/* This is an implementation of TX rate control algorithm that uses a PID
+ * controller. Given a target failed frames rate, the controller decides about
+ * TX rate changes to meet the target failed frames rate.
+ *
+ * The controller basically computes the following:
+ *
+ * adj = CP * err + CI * err_avg + CD * (err - last_err)
+ *
+ * where
+ * 	adj	adjustment value that is used to switch TX rate (see below)
+ * 	err	current error: target vs. current failed frames percentage
+ * 	last_err	last error
+ * 	err_avg	average (i.e. poor man's integral) of recent errors
+ * 	CP	Proportional coefficient
+ * 	CI	Integral coefficient
+ * 	CD	Derivative coefficient
+ *
+ * CP, CI, CD are subject to careful tuning.
+ *
+ * The integral component uses a exponential moving average approach instead of
+ * an actual sliding window. Advantage is that we don't need to keep an array of
+ * the last N error values and computation is easier.
+ *
+ * Once we have the adj value, we need to map it to a TX rate to be selected.
+ * For now, we depend on the rates to be ordered in a way such that more robust
+ * rates (i.e. such that exhibit a lower framed failed percentage) come first.
+ * E.g. for the 802.11b/g case, we first have the b rates in ascending order,
+ * then the g rates. The adj simply decides the index of the TX rate in the list
+ * to switch to (relative to the current TX rate entry).
+ *
+ * Note that for the computations we use a fixed-point representation to avoid
+ * floating point arithmetic. Hence, all values are shifted left by
+ * RC_PID_ARITH_SHIFT.
+ */
+
+/* Sampling frequency for measuring percentage of failed frames. */
+#define RC_PID_INTERVAL (HZ / 1)
+
+/* Exponential averaging smoothness (used for I part of PID controller) */
+#define RC_PID_SMOOTHING_SHIFT 3
+#define RC_PID_SMOOTHING (1 << RC_PID_SMOOTHING_SHIFT)
+
+/* Fixed point arithmetic shifting amount. */
+#define RC_PID_ARITH_SHIFT 8
+
+/* Fixed point arithmetic factor. */
+#define RC_PID_ARITH_FACTOR (1 << RC_PID_ARITH_SHIFT)
+
+/* Proportional PID component coefficient. */
+#define RC_PID_COEFF_P 15
+/* Integral PID component coefficient. */
+#define RC_PID_COEFF_I 10
+/* Derivative PID component coefficient. */
+#define RC_PID_COEFF_D 15
+
+/* Target failed frames rate for the PID controller. NB: This effectively gives
+ * maximum failed frames percentage we're willing to accept. If communication is
+ * good, the controller will fail to adjust failed frames percentage to the
+ * target. This is intentional.
+ */
+#define RC_PID_TARGET_PF (20 << RC_PID_ARITH_SHIFT)
+
+struct rc_pid_sta_info {
+	unsigned long last_change;
+	unsigned long last_sample;
+
+	u32 tx_num_failed;
+	u32 tx_num_xmit;
+
+	/* Average failed frames percentage error (i.e. actual vs. target
+	 * percentage), scaled by RC_PID_SMOOTHING. This value is a
+	 * smoothed by using a exponentail weighted average technique:
+	 *
+	 *           (SMOOTHING - 1) * err_avg_old + err
+	 * err_avg = -----------------------------------
+	 *                       SMOOTHING
+	 *
+	 * where err_avg is the new approximation, err_avg_old the previous one
+	 * and err is the error w.r.t. to the current failed frames percentage
+	 * sample. Note that the bigger SMOOTHING the more weight is given to
+	 * the previous estimate, resulting in smoother behavior (i.e.
+	 * corresponding to a longer integration window).
+	 *
+	 * For computation, we actually don't use the above formula, but this
+	 * one:
+	 *
+	 * err_avg_scaled = err_avg_old_scaled - err_avg_old + err
+	 *
+	 * where:
+	 * 	err_avg_scaled = err * SMOOTHING
+	 * 	err_avg_old_scaled = err_avg_old * SMOOTHING
+	 *
+	 * This avoids floating point numbers and the per_failed_old value can
+	 * easily be obtained by shifting per_failed_old_scaled right by
+	 * RC_PID_SMOOTHING_SHIFT.
+	 */
+	s32 err_avg_sc;
+
+	/* Last framed failes percentage sample */
+	u32 last_pf;
+};
+
+/* Algorithm parameters. We keep them on a per-algorithm approach, so they can
+ * be tuned individually for each interface.
+ */
+struct rc_pid_info {
+
+	/* The failed frames percentage target. */
+	u32 target;
+
+	/* P, I and D coefficients. */
+	s32 coeff_p;
+	s32 coeff_i;
+	s32 coeff_d;
+};
+
+
+static void rate_control_pid_adjust_rate(struct ieee80211_local *local,
+					 struct sta_info *sta, int adj)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_hw_mode *mode;
+	int newidx = sta->txrate + adj;
+	int maxrate;
+	int back = (adj > 0) ? 1 : -1;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
+		/* forced unicast rate - do not change STA rate */
+		return;
+	}
+
+	mode = local->oper_hw_mode;
+	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
+
+	if (newidx < 0)
+		newidx = 0;
+	else if (newidx >= mode->num_rates)
+		newidx = mode->num_rates - 1;
+
+	while (newidx != sta->txrate) {
+		if (rate_supported(sta, mode, newidx) &&
+		    (maxrate < 0 || newidx <= maxrate)) {
+			sta->txrate = newidx;
+			break;
+		}
+
+		newidx += back;
+	}
+}
+
+static void rate_control_pid_sample(struct rc_pid_info *pinfo,
+				    struct ieee80211_local *local,
+				    struct sta_info *sta)
+{
+	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
+	u32 pf;
+	s32 err_avg;
+	s32 err_prop;
+	s32 err_int;
+	s32 err_der;
+	int adj;
+
+	spinfo = sta->rate_ctrl_priv;
+	spinfo->last_sample = jiffies;
+
+	/* If no frames were transmitted, we assume the old sample is
+	 * still a good measurement and copy it. */
+	if (spinfo->tx_num_xmit == 0)
+		pf = spinfo->last_pf;
+	else {
+		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
+		pf <<= RC_PID_ARITH_SHIFT;
+
+		spinfo->tx_num_xmit = 0;
+		spinfo->tx_num_failed = 0;
+	}
+
+	/* Compute the proportional, integral and derivative errors. */
+	err_prop = RC_PID_TARGET_PF - pf;
+
+	err_avg = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
+	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
+	err_int = spinfo->err_avg_sc >> RC_PID_SMOOTHING_SHIFT;
+
+	err_der = pf - spinfo->last_pf;
+	spinfo->last_pf = pf;
+
+	/* Compute the controller output. */
+	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
+	      + err_der * pinfo->coeff_d);
+
+	/* We need to do an arithmetic right shift. ISO C says this is
+	 * implementation defined for negative left operands. Hence, be
+	 * careful to get it right, also for negative values. */
+	adj = (adj < 0) ? -((-adj) >> (2 * RC_PID_ARITH_SHIFT)) :
+			  adj >> (2 * RC_PID_ARITH_SHIFT);
+
+	/* Change rate. */
+	if (adj)
+		rate_control_pid_adjust_rate(local, sta, adj);
+}
+
+static void rate_control_pid_tx_status(void *priv, struct net_device *dev,
+				       struct sk_buff *skb,
+				       struct ieee80211_tx_status *status)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct rc_pid_info *pinfo = priv;
+	struct sta_info *sta;
+	struct rc_pid_sta_info *spinfo;
+
+	sta = sta_info_get(local, hdr->addr1);
+
+	if (!sta)
+	    return;
+
+	spinfo = sta->rate_ctrl_priv;
+	spinfo->tx_num_xmit++;
+
+	/* We count frames that totally failed to be transmitted as two bad
+	 * frames, those that made it out but had some retries as one good and
+	 * one bad frame. */
+	if (status->excessive_retries) {
+		spinfo->tx_num_failed += 2;
+		spinfo->tx_num_xmit++;
+	} else if (status->retry_count) {
+		spinfo->tx_num_failed++;
+		spinfo->tx_num_xmit++;
+	}
+
+	if (status->excessive_retries) {
+		sta->tx_retry_failed++;
+		sta->tx_num_consecutive_failures++;
+		sta->tx_num_mpdu_fail++;
+	} else {
+		sta->last_ack_rssi[0] = sta->last_ack_rssi[1];
+		sta->last_ack_rssi[1] = sta->last_ack_rssi[2];
+		sta->last_ack_rssi[2] = status->ack_signal;
+		sta->tx_num_consecutive_failures = 0;
+		sta->tx_num_mpdu_ok++;
+	}
+	sta->tx_retry_count += status->retry_count;
+	sta->tx_num_mpdu_fail += status->retry_count;
+
+	/* Update PID controller state. */
+	if (time_after(jiffies, spinfo->last_sample + RC_PID_INTERVAL))
+		rate_control_pid_sample(pinfo, local, sta);
+
+	sta_info_put(sta);
+}
+
+
+static void
+rate_control_pid_get_rate(void *priv, struct net_device *dev,
+			  struct ieee80211_hw_mode *mode,
+			  struct sk_buff *skb,
+			  struct rate_selection *sel)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct sta_info *sta;
+	int rateidx;
+
+	sta = sta_info_get(local, hdr->addr1);
+
+	if (!sta) {
+		sel->rate = rate_lowest(local, mode, NULL);
+		sta_info_put(sta);
+		return;
+	}
+
+	rateidx = sta->txrate;
+
+	if (rateidx >= mode->num_rates)
+		rateidx = mode->num_rates - 1;
+
+	sta_info_put(sta);
+
+	sel->rate = &mode->rates[rateidx];
+}
+
+
+static void rate_control_pid_rate_init(void *priv, void *priv_sta,
+					  struct ieee80211_local *local,
+					  struct sta_info *sta)
+{
+	/* TODO: This routine should consider using RSSI from previous packets
+	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
+	 * Until that method is implemented, we will use the lowest supported
+	 * rate as a workaround. */
+	sta->txrate = rate_lowest_index(local, local->oper_hw_mode, sta);
+}
+
+
+static void *rate_control_pid_alloc(struct ieee80211_local *local)
+{
+	struct rc_pid_info *pinfo;
+
+	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
+
+	pinfo->target = RC_PID_TARGET_PF;
+	pinfo->coeff_p = RC_PID_COEFF_P;
+	pinfo->coeff_i = RC_PID_COEFF_I;
+	pinfo->coeff_d = RC_PID_COEFF_D;
+
+	return pinfo;
+}
+
+
+static void rate_control_pid_free(void *priv)
+{
+	struct rc_pid_info *pinfo = priv;
+	kfree(pinfo);
+}
+
+
+static void rate_control_pid_clear(void *priv)
+{
+}
+
+
+static void *rate_control_pid_alloc_sta(void *priv, gfp_t gfp)
+{
+	struct rc_pid_sta_info *spinfo;
+
+	spinfo = kzalloc(sizeof(*spinfo), gfp);
+
+	return spinfo;
+}
+
+
+static void rate_control_pid_free_sta(void *priv, void *priv_sta)
+{
+	struct rc_pid_sta_info *spinfo = priv_sta;
+	kfree(spinfo);
+}
+
+struct rate_control_ops mac80211_rcpid = {
+	.name = "pid",
+	.tx_status = rate_control_pid_tx_status,
+	.get_rate = rate_control_pid_get_rate,
+	.rate_init = rate_control_pid_rate_init,
+	.clear = rate_control_pid_clear,
+	.alloc = rate_control_pid_alloc,
+	.free = rate_control_pid_free,
+	.alloc_sta = rate_control_pid_alloc_sta,
+	.free_sta = rate_control_pid_free_sta,
+};
-- 
1.5.3.4

