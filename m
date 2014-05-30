Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33389 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3PAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:00:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove PID rate control
Date: Fri, 30 May 2014 10:47:28 -0400
Message-Id: <1401461248-29427-1-git-send-email-linville@tuxdriver.com> (sfid-20140530_170022_501559_C48F8145)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minstrel has long since proven its worth.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS                        |  10 -
 net/mac80211/Kconfig               |  17 --
 net/mac80211/Makefile              |   5 -
 net/mac80211/main.c                |   7 -
 net/mac80211/rate.h                |  13 -
 net/mac80211/rc80211_pid.h         | 278 ---------------------
 net/mac80211/rc80211_pid_algo.c    | 478 -------------------------------------
 net/mac80211/rc80211_pid_debugfs.c | 228 ------------------
 8 files changed, 1036 deletions(-)
 delete mode 100644 net/mac80211/rc80211_pid.h
 delete mode 100644 net/mac80211/rc80211_pid_algo.c
 delete mode 100644 net/mac80211/rc80211_pid_debugfs.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a80a586cbdcd..a6a39cba372d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5566,16 +5566,6 @@ F:	Documentation/networking/mac80211-injection.txt
 F:	include/net/mac80211.h
 F:	net/mac80211/
 
-MAC80211 PID RATE CONTROL
-M:	Stefano Brivio <stefano.brivio@polimi.it>
-M:	Mattias Nissler <mattias.nissler@gmx.de>
-L:	linux-wireless@vger.kernel.org
-W:	http://wireless.kernel.org/en/developers/Documentation/mac80211/RateControl/PID
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
-S:	Maintained
-F:	net/mac80211/rc80211_pid*
-
 MACVLAN DRIVER
 M:	Patrick McHardy <kaber@trash.net>
 L:	netdev@vger.kernel.org
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 97b5dcad5025..aeb6a483b3bc 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -19,14 +19,6 @@ if MAC80211 != n
 config MAC80211_HAS_RC
 	bool
 
-config MAC80211_RC_PID
-	bool "PID controller based rate control algorithm" if EXPERT
-	select MAC80211_HAS_RC
-	---help---
-	  This option enables a TX rate control algorithm for
-	  mac80211 that uses a PID controller to select the TX
-	  rate.
-
 config MAC80211_RC_MINSTREL
 	bool "Minstrel" if EXPERT
 	select MAC80211_HAS_RC
@@ -51,14 +43,6 @@ choice
 	  overridden through the ieee80211_default_rc_algo module
 	  parameter if different algorithms are available.
 
-config MAC80211_RC_DEFAULT_PID
-	bool "PID controller based rate control algorithm"
-	depends on MAC80211_RC_PID
-	---help---
-	  Select the PID controller based rate control as the
-	  default rate control algorithm. You should choose
-	  this unless you know what you are doing.
-
 config MAC80211_RC_DEFAULT_MINSTREL
 	bool "Minstrel"
 	depends on MAC80211_RC_MINSTREL
@@ -72,7 +56,6 @@ config MAC80211_RC_DEFAULT
 	string
 	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
 	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
-	default "pid" if MAC80211_RC_DEFAULT_PID
 	default ""
 
 endif
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1e46ffa69167..4409bf506594 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -47,17 +47,12 @@ mac80211-$(CONFIG_PM) += pm.o
 
 CFLAGS_trace.o := -I$(src)
 
-# objects for PID algorithm
-rc80211_pid-y := rc80211_pid_algo.o
-rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
-
 rc80211_minstrel-y := rc80211_minstrel.o
 rc80211_minstrel-$(CONFIG_MAC80211_DEBUGFS) += rc80211_minstrel_debugfs.o
 
 rc80211_minstrel_ht-y := rc80211_minstrel_ht.o
 rc80211_minstrel_ht-$(CONFIG_MAC80211_DEBUGFS) += rc80211_minstrel_ht_debugfs.o
 
-mac80211-$(CONFIG_MAC80211_RC_PID) += $(rc80211_pid-y)
 mac80211-$(CONFIG_MAC80211_RC_MINSTREL) += $(rc80211_minstrel-y)
 mac80211-$(CONFIG_MAC80211_RC_MINSTREL_HT) += $(rc80211_minstrel_ht-y)
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d17c26d6e369..0512a5096f0f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1187,18 +1187,12 @@ static int __init ieee80211_init(void)
 	if (ret)
 		goto err_minstrel;
 
-	ret = rc80211_pid_init();
-	if (ret)
-		goto err_pid;
-
 	ret = ieee80211_iface_init();
 	if (ret)
 		goto err_netdev;
 
 	return 0;
  err_netdev:
-	rc80211_pid_exit();
- err_pid:
 	rc80211_minstrel_ht_exit();
  err_minstrel:
 	rc80211_minstrel_exit();
@@ -1208,7 +1202,6 @@ static int __init ieee80211_init(void)
 
 static void __exit ieee80211_exit(void)
 {
-	rc80211_pid_exit();
 	rc80211_minstrel_ht_exit();
 	rc80211_minstrel_exit();
 
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 9aa2a1190a86..18babe302832 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -143,19 +143,6 @@ void rate_control_deinitialize(struct ieee80211_local *local);
 
 
 /* Rate control algorithms */
-#ifdef CONFIG_MAC80211_RC_PID
-int rc80211_pid_init(void);
-void rc80211_pid_exit(void);
-#else
-static inline int rc80211_pid_init(void)
-{
-	return 0;
-}
-static inline void rc80211_pid_exit(void)
-{
-}
-#endif
-
 #ifdef CONFIG_MAC80211_RC_MINSTREL
 int rc80211_minstrel_init(void);
 void rc80211_minstrel_exit(void);
diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
deleted file mode 100644
index 19111c7bf454..000000000000
--- a/net/mac80211/rc80211_pid.h
+++ /dev/null
@@ -1,278 +0,0 @@
-/*
- * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
- * Copyright 2007, Stefano Brivio <stefano.brivio@polimi.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef RC80211_PID_H
-#define RC80211_PID_H
-
-/* Sampling period for measuring percentage of failed frames in ms. */
-#define RC_PID_INTERVAL			125
-
-/* Exponential averaging smoothness (used for I part of PID controller) */
-#define RC_PID_SMOOTHING_SHIFT		3
-#define RC_PID_SMOOTHING		(1 << RC_PID_SMOOTHING_SHIFT)
-
-/* Sharpening factor (used for D part of PID controller) */
-#define RC_PID_SHARPENING_FACTOR	0
-#define RC_PID_SHARPENING_DURATION	0
-
-/* Fixed point arithmetic shifting amount. */
-#define RC_PID_ARITH_SHIFT		8
-
-/* Proportional PID component coefficient. */
-#define RC_PID_COEFF_P			15
-/* Integral PID component coefficient. */
-#define RC_PID_COEFF_I			9
-/* Derivative PID component coefficient. */
-#define RC_PID_COEFF_D			15
-
-/* Target failed frames rate for the PID controller. NB: This effectively gives
- * maximum failed frames percentage we're willing to accept. If the wireless
- * link quality is good, the controller will fail to adjust failed frames
- * percentage to the target. This is intentional.
- */
-#define RC_PID_TARGET_PF		14
-
-/* Rate behaviour normalization quantity over time. */
-#define RC_PID_NORM_OFFSET		3
-
-/* Push high rates right after loading. */
-#define RC_PID_FAST_START		0
-
-/* Arithmetic right shift for positive and negative values for ISO C. */
-#define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
-	((x) < 0 ? -((-(x)) >> (y)) : (x) >> (y))
-
-enum rc_pid_event_type {
-	RC_PID_EVENT_TYPE_TX_STATUS,
-	RC_PID_EVENT_TYPE_RATE_CHANGE,
-	RC_PID_EVENT_TYPE_TX_RATE,
-	RC_PID_EVENT_TYPE_PF_SAMPLE,
-};
-
-union rc_pid_event_data {
-	/* RC_PID_EVENT_TX_STATUS */
-	struct {
-		u32 flags;
-		struct ieee80211_tx_info tx_status;
-	};
-	/* RC_PID_EVENT_TYPE_RATE_CHANGE */
-	/* RC_PID_EVENT_TYPE_TX_RATE */
-	struct {
-		int index;
-		int rate;
-	};
-	/* RC_PID_EVENT_TYPE_PF_SAMPLE */
-	struct {
-		s32 pf_sample;
-		s32 prop_err;
-		s32 int_err;
-		s32 der_err;
-	};
-};
-
-struct rc_pid_event {
-	/* The time when the event occurred */
-	unsigned long timestamp;
-
-	/* Event ID number */
-	unsigned int id;
-
-	/* Type of event */
-	enum rc_pid_event_type type;
-
-	/* type specific data */
-	union rc_pid_event_data data;
-};
-
-/* Size of the event ring buffer. */
-#define RC_PID_EVENT_RING_SIZE 32
-
-struct rc_pid_event_buffer {
-	/* Counter that generates event IDs */
-	unsigned int ev_count;
-
-	/* Ring buffer of events */
-	struct rc_pid_event ring[RC_PID_EVENT_RING_SIZE];
-
-	/* Index to the entry in events_buf to be reused */
-	unsigned int next_entry;
-
-	/* Lock that guards against concurrent access to this buffer struct */
-	spinlock_t lock;
-
-	/* Wait queue for poll/select and blocking I/O */
-	wait_queue_head_t waitqueue;
-};
-
-struct rc_pid_events_file_info {
-	/* The event buffer we read */
-	struct rc_pid_event_buffer *events;
-
-	/* The entry we have should read next */
-	unsigned int next_entry;
-};
-
-/**
- * struct rc_pid_debugfs_entries - tunable parameters
- *
- * Algorithm parameters, tunable via debugfs.
- * @target: target percentage for failed frames
- * @sampling_period: error sampling interval in milliseconds
- * @coeff_p: absolute value of the proportional coefficient
- * @coeff_i: absolute value of the integral coefficient
- * @coeff_d: absolute value of the derivative coefficient
- * @smoothing_shift: absolute value of the integral smoothing factor (i.e.
- *	amount of smoothing introduced by the exponential moving average)
- * @sharpen_factor: absolute value of the derivative sharpening factor (i.e.
- *	amount of emphasis given to the derivative term after low activity
- *	events)
- * @sharpen_duration: duration of the sharpening effect after the detected low
- *	activity event, relative to sampling_period
- * @norm_offset: amount of normalization periodically performed on the learnt
- *	rate behaviour values (lower means we should trust more what we learnt
- *	about behaviour of rates, higher means we should trust more the natural
- *	ordering of rates)
- */
-struct rc_pid_debugfs_entries {
-	struct dentry *target;
-	struct dentry *sampling_period;
-	struct dentry *coeff_p;
-	struct dentry *coeff_i;
-	struct dentry *coeff_d;
-	struct dentry *smoothing_shift;
-	struct dentry *sharpen_factor;
-	struct dentry *sharpen_duration;
-	struct dentry *norm_offset;
-};
-
-void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
-				      struct ieee80211_tx_info *stat);
-
-void rate_control_pid_event_rate_change(struct rc_pid_event_buffer *buf,
-					       int index, int rate);
-
-void rate_control_pid_event_tx_rate(struct rc_pid_event_buffer *buf,
-					   int index, int rate);
-
-void rate_control_pid_event_pf_sample(struct rc_pid_event_buffer *buf,
-					     s32 pf_sample, s32 prop_err,
-					     s32 int_err, s32 der_err);
-
-void rate_control_pid_add_sta_debugfs(void *priv, void *priv_sta,
-					     struct dentry *dir);
-
-void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta);
-
-struct rc_pid_sta_info {
-	unsigned long last_change;
-	unsigned long last_sample;
-
-	u32 tx_num_failed;
-	u32 tx_num_xmit;
-
-	int txrate_idx;
-
-	/* Average failed frames percentage error (i.e. actual vs. target
-	 * percentage), scaled by RC_PID_SMOOTHING. This value is computed
-	 * using using an exponential weighted average technique:
-	 *
-	 *           (RC_PID_SMOOTHING - 1) * err_avg_old + err
-	 * err_avg = ------------------------------------------
-	 *                       RC_PID_SMOOTHING
-	 *
-	 * where err_avg is the new approximation, err_avg_old the previous one
-	 * and err is the error w.r.t. to the current failed frames percentage
-	 * sample. Note that the bigger RC_PID_SMOOTHING the more weight is
-	 * given to the previous estimate, resulting in smoother behavior (i.e.
-	 * corresponding to a longer integration window).
-	 *
-	 * For computation, we actually don't use the above formula, but this
-	 * one:
-	 *
-	 * err_avg_scaled = err_avg_old_scaled - err_avg_old + err
-	 *
-	 * where:
-	 * 	err_avg_scaled = err * RC_PID_SMOOTHING
-	 * 	err_avg_old_scaled = err_avg_old * RC_PID_SMOOTHING
-	 *
-	 * This avoids floating point numbers and the per_failed_old value can
-	 * easily be obtained by shifting per_failed_old_scaled right by
-	 * RC_PID_SMOOTHING_SHIFT.
-	 */
-	s32 err_avg_sc;
-
-	/* Last framed failes percentage sample. */
-	u32 last_pf;
-
-	/* Sharpening needed. */
-	u8 sharp_cnt;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	/* Event buffer */
-	struct rc_pid_event_buffer events;
-
-	/* Events debugfs file entry */
-	struct dentry *events_entry;
-#endif
-};
-
-/* Algorithm parameters. We keep them on a per-algorithm approach, so they can
- * be tuned individually for each interface.
- */
-struct rc_pid_rateinfo {
-
-	/* Map sorted rates to rates in ieee80211_hw_mode. */
-	int index;
-
-	/* Map rates in ieee80211_hw_mode to sorted rates. */
-	int rev_index;
-
-	/* Did we do any measurement on this rate? */
-	bool valid;
-
-	/* Comparison with the lowest rate. */
-	int diff;
-};
-
-struct rc_pid_info {
-
-	/* The failed frames percentage target. */
-	unsigned int target;
-
-	/* Rate at which failed frames percentage is sampled in 0.001s. */
-	unsigned int sampling_period;
-
-	/* P, I and D coefficients. */
-	int coeff_p;
-	int coeff_i;
-	int coeff_d;
-
-	/* Exponential averaging shift. */
-	unsigned int smoothing_shift;
-
-	/* Sharpening factor and duration. */
-	unsigned int sharpen_factor;
-	unsigned int sharpen_duration;
-
-	/* Normalization offset. */
-	unsigned int norm_offset;
-
-	/* Rates information. */
-	struct rc_pid_rateinfo *rinfo;
-
-	/* Index of the last used rate. */
-	int oldrate;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	/* Debugfs entries created for the parameters above. */
-	struct rc_pid_debugfs_entries dentries;
-#endif
-};
-
-#endif /* RC80211_PID_H */
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
deleted file mode 100644
index d0da2a70fe68..000000000000
--- a/net/mac80211/rc80211_pid_algo.c
+++ /dev/null
@@ -1,478 +0,0 @@
-/*
- * Copyright 2002-2005, Instant802 Networks, Inc.
- * Copyright 2005, Devicescape Software, Inc.
- * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
- * Copyright 2007-2008, Stefano Brivio <stefano.brivio@polimi.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/debugfs.h>
-#include <linux/slab.h>
-#include <net/mac80211.h>
-#include "rate.h"
-#include "mesh.h"
-#include "rc80211_pid.h"
-
-
-/* This is an implementation of a TX rate control algorithm that uses a PID
- * controller. Given a target failed frames rate, the controller decides about
- * TX rate changes to meet the target failed frames rate.
- *
- * The controller basically computes the following:
- *
- * adj = CP * err + CI * err_avg + CD * (err - last_err) * (1 + sharpening)
- *
- * where
- * 	adj	adjustment value that is used to switch TX rate (see below)
- * 	err	current error: target vs. current failed frames percentage
- * 	last_err	last error
- * 	err_avg	average (i.e. poor man's integral) of recent errors
- *	sharpening	non-zero when fast response is needed (i.e. right after
- *			association or no frames sent for a long time), heading
- * 			to zero over time
- * 	CP	Proportional coefficient
- * 	CI	Integral coefficient
- * 	CD	Derivative coefficient
- *
- * CP, CI, CD are subject to careful tuning.
- *
- * The integral component uses a exponential moving average approach instead of
- * an actual sliding window. The advantage is that we don't need to keep an
- * array of the last N error values and computation is easier.
- *
- * Once we have the adj value, we map it to a rate by means of a learning
- * algorithm. This algorithm keeps the state of the percentual failed frames
- * difference between rates. The behaviour of the lowest available rate is kept
- * as a reference value, and every time we switch between two rates, we compute
- * the difference between the failed frames each rate exhibited. By doing so,
- * we compare behaviours which different rates exhibited in adjacent timeslices,
- * thus the comparison is minimally affected by external conditions. This
- * difference gets propagated to the whole set of measurements, so that the
- * reference is always the same. Periodically, we normalize this set so that
- * recent events weigh the most. By comparing the adj value with this set, we
- * avoid pejorative switches to lower rates and allow for switches to higher
- * rates if they behaved well.
- *
- * Note that for the computations we use a fixed-point representation to avoid
- * floating point arithmetic. Hence, all values are shifted left by
- * RC_PID_ARITH_SHIFT.
- */
-
-
-/* Adjust the rate while ensuring that we won't switch to a lower rate if it
- * exhibited a worse failed frames behaviour and we'll choose the highest rate
- * whose failed frames behaviour is not worse than the one of the original rate
- * target. While at it, check that the new rate is valid. */
-static void rate_control_pid_adjust_rate(struct ieee80211_supported_band *sband,
-					 struct ieee80211_sta *sta,
-					 struct rc_pid_sta_info *spinfo, int adj,
-					 struct rc_pid_rateinfo *rinfo)
-{
-	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
-	int cur = spinfo->txrate_idx;
-
-	band = sband->band;
-	n_bitrates = sband->n_bitrates;
-
-	/* Map passed arguments to sorted values. */
-	cur_sorted = rinfo[cur].rev_index;
-	new_sorted = cur_sorted + adj;
-
-	/* Check limits. */
-	if (new_sorted < 0)
-		new_sorted = rinfo[0].rev_index;
-	else if (new_sorted >= n_bitrates)
-		new_sorted = rinfo[n_bitrates - 1].rev_index;
-
-	tmp = new_sorted;
-
-	if (adj < 0) {
-		/* Ensure that the rate decrease isn't disadvantageous. */
-		for (probe = cur_sorted; probe >= new_sorted; probe--)
-			if (rinfo[probe].diff <= rinfo[cur_sorted].diff &&
-			    rate_supported(sta, band, rinfo[probe].index))
-				tmp = probe;
-	} else {
-		/* Look for rate increase with zero (or below) cost. */
-		for (probe = new_sorted + 1; probe < n_bitrates; probe++)
-			if (rinfo[probe].diff <= rinfo[new_sorted].diff &&
-			    rate_supported(sta, band, rinfo[probe].index))
-				tmp = probe;
-	}
-
-	/* Fit the rate found to the nearest supported rate. */
-	do {
-		if (rate_supported(sta, band, rinfo[tmp].index)) {
-			spinfo->txrate_idx = rinfo[tmp].index;
-			break;
-		}
-		if (adj < 0)
-			tmp--;
-		else
-			tmp++;
-	} while (tmp < n_bitrates && tmp >= 0);
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_rate_change(&spinfo->events,
-		spinfo->txrate_idx,
-		sband->bitrates[spinfo->txrate_idx].bitrate);
-#endif
-}
-
-/* Normalize the failed frames per-rate differences. */
-static void rate_control_pid_normalize(struct rc_pid_info *pinfo, int l)
-{
-	int i, norm_offset = pinfo->norm_offset;
-	struct rc_pid_rateinfo *r = pinfo->rinfo;
-
-	if (r[0].diff > norm_offset)
-		r[0].diff -= norm_offset;
-	else if (r[0].diff < -norm_offset)
-		r[0].diff += norm_offset;
-	for (i = 0; i < l - 1; i++)
-		if (r[i + 1].diff > r[i].diff + norm_offset)
-			r[i + 1].diff -= norm_offset;
-		else if (r[i + 1].diff <= r[i].diff)
-			r[i + 1].diff += norm_offset;
-}
-
-static void rate_control_pid_sample(struct rc_pid_info *pinfo,
-				    struct ieee80211_supported_band *sband,
-				    struct ieee80211_sta *sta,
-				    struct rc_pid_sta_info *spinfo)
-{
-	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
-	u32 pf;
-	s32 err_avg;
-	u32 err_prop;
-	u32 err_int;
-	u32 err_der;
-	int adj, i, j, tmp;
-	unsigned long period;
-
-	/* In case nothing happened during the previous control interval, turn
-	 * the sharpening factor on. */
-	period = msecs_to_jiffies(pinfo->sampling_period);
-	if (jiffies - spinfo->last_sample > 2 * period)
-		spinfo->sharp_cnt = pinfo->sharpen_duration;
-
-	spinfo->last_sample = jiffies;
-
-	/* This should never happen, but in case, we assume the old sample is
-	 * still a good measurement and copy it. */
-	if (unlikely(spinfo->tx_num_xmit == 0))
-		pf = spinfo->last_pf;
-	else
-		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
-
-	spinfo->tx_num_xmit = 0;
-	spinfo->tx_num_failed = 0;
-
-	/* If we just switched rate, update the rate behaviour info. */
-	if (pinfo->oldrate != spinfo->txrate_idx) {
-
-		i = rinfo[pinfo->oldrate].rev_index;
-		j = rinfo[spinfo->txrate_idx].rev_index;
-
-		tmp = (pf - spinfo->last_pf);
-		tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);
-
-		rinfo[j].diff = rinfo[i].diff + tmp;
-		pinfo->oldrate = spinfo->txrate_idx;
-	}
-	rate_control_pid_normalize(pinfo, sband->n_bitrates);
-
-	/* Compute the proportional, integral and derivative errors. */
-	err_prop = (pinfo->target - pf) << RC_PID_ARITH_SHIFT;
-
-	err_avg = spinfo->err_avg_sc >> pinfo->smoothing_shift;
-	spinfo->err_avg_sc = spinfo->err_avg_sc - err_avg + err_prop;
-	err_int = spinfo->err_avg_sc >> pinfo->smoothing_shift;
-
-	err_der = (pf - spinfo->last_pf) *
-		  (1 + pinfo->sharpen_factor * spinfo->sharp_cnt);
-	spinfo->last_pf = pf;
-	if (spinfo->sharp_cnt)
-			spinfo->sharp_cnt--;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_pf_sample(&spinfo->events, pf, err_prop, err_int,
-					 err_der);
-#endif
-
-	/* Compute the controller output. */
-	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
-	      + err_der * pinfo->coeff_d);
-	adj = RC_PID_DO_ARITH_RIGHT_SHIFT(adj, 2 * RC_PID_ARITH_SHIFT);
-
-	/* Change rate. */
-	if (adj)
-		rate_control_pid_adjust_rate(sband, sta, spinfo, adj, rinfo);
-}
-
-static void rate_control_pid_tx_status(void *priv, struct ieee80211_supported_band *sband,
-				       struct ieee80211_sta *sta, void *priv_sta,
-				       struct sk_buff *skb)
-{
-	struct rc_pid_info *pinfo = priv;
-	struct rc_pid_sta_info *spinfo = priv_sta;
-	unsigned long period;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	if (!spinfo)
-		return;
-
-	/* Ignore all frames that were sent with a different rate than the rate
-	 * we currently advise mac80211 to use. */
-	if (info->status.rates[0].idx != spinfo->txrate_idx)
-		return;
-
-	spinfo->tx_num_xmit++;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_tx_status(&spinfo->events, info);
-#endif
-
-	/* We count frames that totally failed to be transmitted as two bad
-	 * frames, those that made it out but had some retries as one good and
-	 * one bad frame. */
-	if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
-		spinfo->tx_num_failed += 2;
-		spinfo->tx_num_xmit++;
-	} else if (info->status.rates[0].count > 1) {
-		spinfo->tx_num_failed++;
-		spinfo->tx_num_xmit++;
-	}
-
-	/* Update PID controller state. */
-	period = msecs_to_jiffies(pinfo->sampling_period);
-	if (time_after(jiffies, spinfo->last_sample + period))
-		rate_control_pid_sample(pinfo, sband, sta, spinfo);
-}
-
-static void
-rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
-			  void *priv_sta,
-			  struct ieee80211_tx_rate_control *txrc)
-{
-	struct sk_buff *skb = txrc->skb;
-	struct ieee80211_supported_band *sband = txrc->sband;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct rc_pid_sta_info *spinfo = priv_sta;
-	int rateidx;
-
-	if (txrc->rts)
-		info->control.rates[0].count =
-			txrc->hw->conf.long_frame_max_tx_count;
-	else
-		info->control.rates[0].count =
-			txrc->hw->conf.short_frame_max_tx_count;
-
-	/* Send management frames and NO_ACK data using lowest rate. */
-	if (rate_control_send_low(sta, priv_sta, txrc))
-		return;
-
-	rateidx = spinfo->txrate_idx;
-
-	if (rateidx >= sband->n_bitrates)
-		rateidx = sband->n_bitrates - 1;
-
-	info->control.rates[0].idx = rateidx;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_tx_rate(&spinfo->events,
-		rateidx, sband->bitrates[rateidx].bitrate);
-#endif
-}
-
-static void
-rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
-			   struct cfg80211_chan_def *chandef,
-			   struct ieee80211_sta *sta, void *priv_sta)
-{
-	struct rc_pid_sta_info *spinfo = priv_sta;
-	struct rc_pid_info *pinfo = priv;
-	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
-	int i, j, tmp;
-	bool s;
-
-	/* TODO: This routine should consider using RSSI from previous packets
-	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
-	 * Until that method is implemented, we will use the lowest supported
-	 * rate as a workaround. */
-
-	/* Sort the rates. This is optimized for the most common case (i.e.
-	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
-	 * mapping too. */
-	for (i = 0; i < sband->n_bitrates; i++) {
-		rinfo[i].index = i;
-		rinfo[i].rev_index = i;
-		if (RC_PID_FAST_START)
-			rinfo[i].diff = 0;
-		else
-			rinfo[i].diff = i * pinfo->norm_offset;
-	}
-	for (i = 1; i < sband->n_bitrates; i++) {
-		s = false;
-		for (j = 0; j < sband->n_bitrates - i; j++)
-			if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
-				     sband->bitrates[rinfo[j + 1].index].bitrate)) {
-				tmp = rinfo[j].index;
-				rinfo[j].index = rinfo[j + 1].index;
-				rinfo[j + 1].index = tmp;
-				rinfo[rinfo[j].index].rev_index = j;
-				rinfo[rinfo[j + 1].index].rev_index = j + 1;
-				s = true;
-			}
-		if (!s)
-			break;
-	}
-
-	spinfo->txrate_idx = rate_lowest_index(sband, sta);
-}
-
-static void *rate_control_pid_alloc(struct ieee80211_hw *hw,
-				    struct dentry *debugfsdir)
-{
-	struct rc_pid_info *pinfo;
-	struct rc_pid_rateinfo *rinfo;
-	struct ieee80211_supported_band *sband;
-	int i, max_rates = 0;
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct rc_pid_debugfs_entries *de;
-#endif
-
-	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
-	if (!pinfo)
-		return NULL;
-
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
-		sband = hw->wiphy->bands[i];
-		if (sband && sband->n_bitrates > max_rates)
-			max_rates = sband->n_bitrates;
-	}
-
-	rinfo = kmalloc(sizeof(*rinfo) * max_rates, GFP_ATOMIC);
-	if (!rinfo) {
-		kfree(pinfo);
-		return NULL;
-	}
-
-	pinfo->target = RC_PID_TARGET_PF;
-	pinfo->sampling_period = RC_PID_INTERVAL;
-	pinfo->coeff_p = RC_PID_COEFF_P;
-	pinfo->coeff_i = RC_PID_COEFF_I;
-	pinfo->coeff_d = RC_PID_COEFF_D;
-	pinfo->smoothing_shift = RC_PID_SMOOTHING_SHIFT;
-	pinfo->sharpen_factor = RC_PID_SHARPENING_FACTOR;
-	pinfo->sharpen_duration = RC_PID_SHARPENING_DURATION;
-	pinfo->norm_offset = RC_PID_NORM_OFFSET;
-	pinfo->rinfo = rinfo;
-	pinfo->oldrate = 0;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	de = &pinfo->dentries;
-	de->target = debugfs_create_u32("target_pf", S_IRUSR | S_IWUSR,
-					debugfsdir, &pinfo->target);
-	de->sampling_period = debugfs_create_u32("sampling_period",
-						 S_IRUSR | S_IWUSR, debugfsdir,
-						 &pinfo->sampling_period);
-	de->coeff_p = debugfs_create_u32("coeff_p", S_IRUSR | S_IWUSR,
-					 debugfsdir, (u32 *)&pinfo->coeff_p);
-	de->coeff_i = debugfs_create_u32("coeff_i", S_IRUSR | S_IWUSR,
-					 debugfsdir, (u32 *)&pinfo->coeff_i);
-	de->coeff_d = debugfs_create_u32("coeff_d", S_IRUSR | S_IWUSR,
-					 debugfsdir, (u32 *)&pinfo->coeff_d);
-	de->smoothing_shift = debugfs_create_u32("smoothing_shift",
-						 S_IRUSR | S_IWUSR, debugfsdir,
-						 &pinfo->smoothing_shift);
-	de->sharpen_factor = debugfs_create_u32("sharpen_factor",
-					       S_IRUSR | S_IWUSR, debugfsdir,
-					       &pinfo->sharpen_factor);
-	de->sharpen_duration = debugfs_create_u32("sharpen_duration",
-						  S_IRUSR | S_IWUSR, debugfsdir,
-						  &pinfo->sharpen_duration);
-	de->norm_offset = debugfs_create_u32("norm_offset",
-					     S_IRUSR | S_IWUSR, debugfsdir,
-					     &pinfo->norm_offset);
-#endif
-
-	return pinfo;
-}
-
-static void rate_control_pid_free(void *priv)
-{
-	struct rc_pid_info *pinfo = priv;
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct rc_pid_debugfs_entries *de = &pinfo->dentries;
-
-	debugfs_remove(de->norm_offset);
-	debugfs_remove(de->sharpen_duration);
-	debugfs_remove(de->sharpen_factor);
-	debugfs_remove(de->smoothing_shift);
-	debugfs_remove(de->coeff_d);
-	debugfs_remove(de->coeff_i);
-	debugfs_remove(de->coeff_p);
-	debugfs_remove(de->sampling_period);
-	debugfs_remove(de->target);
-#endif
-
-	kfree(pinfo->rinfo);
-	kfree(pinfo);
-}
-
-static void *rate_control_pid_alloc_sta(void *priv, struct ieee80211_sta *sta,
-					gfp_t gfp)
-{
-	struct rc_pid_sta_info *spinfo;
-
-	spinfo = kzalloc(sizeof(*spinfo), gfp);
-	if (spinfo == NULL)
-		return NULL;
-
-	spinfo->last_sample = jiffies;
-
-#ifdef CONFIG_MAC80211_DEBUGFS
-	spin_lock_init(&spinfo->events.lock);
-	init_waitqueue_head(&spinfo->events.waitqueue);
-#endif
-
-	return spinfo;
-}
-
-static void rate_control_pid_free_sta(void *priv, struct ieee80211_sta *sta,
-				      void *priv_sta)
-{
-	kfree(priv_sta);
-}
-
-static const struct rate_control_ops mac80211_rcpid = {
-	.name = "pid",
-	.tx_status = rate_control_pid_tx_status,
-	.get_rate = rate_control_pid_get_rate,
-	.rate_init = rate_control_pid_rate_init,
-	.alloc = rate_control_pid_alloc,
-	.free = rate_control_pid_free,
-	.alloc_sta = rate_control_pid_alloc_sta,
-	.free_sta = rate_control_pid_free_sta,
-#ifdef CONFIG_MAC80211_DEBUGFS
-	.add_sta_debugfs = rate_control_pid_add_sta_debugfs,
-	.remove_sta_debugfs = rate_control_pid_remove_sta_debugfs,
-#endif
-};
-
-int __init rc80211_pid_init(void)
-{
-	return ieee80211_rate_control_register(&mac80211_rcpid);
-}
-
-void rc80211_pid_exit(void)
-{
-	ieee80211_rate_control_unregister(&mac80211_rcpid);
-}
diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
deleted file mode 100644
index 6ff134650a84..000000000000
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ /dev/null
@@ -1,228 +0,0 @@
-/*
- * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/sched.h>
-#include <linux/spinlock.h>
-#include <linux/poll.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-
-#include <net/mac80211.h>
-#include "rate.h"
-
-#include "rc80211_pid.h"
-
-static void rate_control_pid_event(struct rc_pid_event_buffer *buf,
-				   enum rc_pid_event_type type,
-				   union rc_pid_event_data *data)
-{
-	struct rc_pid_event *ev;
-	unsigned long status;
-
-	spin_lock_irqsave(&buf->lock, status);
-	ev = &(buf->ring[buf->next_entry]);
-	buf->next_entry = (buf->next_entry + 1) % RC_PID_EVENT_RING_SIZE;
-
-	ev->timestamp = jiffies;
-	ev->id = buf->ev_count++;
-	ev->type = type;
-	ev->data = *data;
-
-	spin_unlock_irqrestore(&buf->lock, status);
-
-	wake_up_all(&buf->waitqueue);
-}
-
-void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
-				      struct ieee80211_tx_info *stat)
-{
-	union rc_pid_event_data evd;
-
-	evd.flags = stat->flags;
-	memcpy(&evd.tx_status, stat, sizeof(struct ieee80211_tx_info));
-	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_TX_STATUS, &evd);
-}
-
-void rate_control_pid_event_rate_change(struct rc_pid_event_buffer *buf,
-					       int index, int rate)
-{
-	union rc_pid_event_data evd;
-
-	evd.index = index;
-	evd.rate = rate;
-	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_RATE_CHANGE, &evd);
-}
-
-void rate_control_pid_event_tx_rate(struct rc_pid_event_buffer *buf,
-					   int index, int rate)
-{
-	union rc_pid_event_data evd;
-
-	evd.index = index;
-	evd.rate = rate;
-	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_TX_RATE, &evd);
-}
-
-void rate_control_pid_event_pf_sample(struct rc_pid_event_buffer *buf,
-					     s32 pf_sample, s32 prop_err,
-					     s32 int_err, s32 der_err)
-{
-	union rc_pid_event_data evd;
-
-	evd.pf_sample = pf_sample;
-	evd.prop_err = prop_err;
-	evd.int_err = int_err;
-	evd.der_err = der_err;
-	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_PF_SAMPLE, &evd);
-}
-
-static int rate_control_pid_events_open(struct inode *inode, struct file *file)
-{
-	struct rc_pid_sta_info *sinfo = inode->i_private;
-	struct rc_pid_event_buffer *events = &sinfo->events;
-	struct rc_pid_events_file_info *file_info;
-	unsigned long status;
-
-	/* Allocate a state struct */
-	file_info = kmalloc(sizeof(*file_info), GFP_KERNEL);
-	if (file_info == NULL)
-		return -ENOMEM;
-
-	spin_lock_irqsave(&events->lock, status);
-
-	file_info->next_entry = events->next_entry;
-	file_info->events = events;
-
-	spin_unlock_irqrestore(&events->lock, status);
-
-	file->private_data = file_info;
-
-	return 0;
-}
-
-static int rate_control_pid_events_release(struct inode *inode,
-					   struct file *file)
-{
-	struct rc_pid_events_file_info *file_info = file->private_data;
-
-	kfree(file_info);
-
-	return 0;
-}
-
-static unsigned int rate_control_pid_events_poll(struct file *file,
-						 poll_table *wait)
-{
-	struct rc_pid_events_file_info *file_info = file->private_data;
-
-	poll_wait(file, &file_info->events->waitqueue, wait);
-
-	return POLLIN | POLLRDNORM;
-}
-
-#define RC_PID_PRINT_BUF_SIZE 64
-
-static ssize_t rate_control_pid_events_read(struct file *file, char __user *buf,
-					    size_t length, loff_t *offset)
-{
-	struct rc_pid_events_file_info *file_info = file->private_data;
-	struct rc_pid_event_buffer *events = file_info->events;
-	struct rc_pid_event *ev;
-	char pb[RC_PID_PRINT_BUF_SIZE];
-	int ret;
-	int p;
-	unsigned long status;
-
-	/* Check if there is something to read. */
-	if (events->next_entry == file_info->next_entry) {
-		if (file->f_flags & O_NONBLOCK)
-			return -EAGAIN;
-
-		/* Wait */
-		ret = wait_event_interruptible(events->waitqueue,
-				events->next_entry != file_info->next_entry);
-
-		if (ret)
-			return ret;
-	}
-
-	/* Write out one event per call. I don't care whether it's a little
-	 * inefficient, this is debugging code anyway. */
-	spin_lock_irqsave(&events->lock, status);
-
-	/* Get an event */
-	ev = &(events->ring[file_info->next_entry]);
-	file_info->next_entry = (file_info->next_entry + 1) %
-				RC_PID_EVENT_RING_SIZE;
-
-	/* Print information about the event. Note that userspace needs to
-	 * provide large enough buffers. */
-	length = length < RC_PID_PRINT_BUF_SIZE ?
-		 length : RC_PID_PRINT_BUF_SIZE;
-	p = scnprintf(pb, length, "%u %lu ", ev->id, ev->timestamp);
-	switch (ev->type) {
-	case RC_PID_EVENT_TYPE_TX_STATUS:
-		p += scnprintf(pb + p, length - p, "tx_status %u %u",
-			       !(ev->data.flags & IEEE80211_TX_STAT_ACK),
-			       ev->data.tx_status.status.rates[0].idx);
-		break;
-	case RC_PID_EVENT_TYPE_RATE_CHANGE:
-		p += scnprintf(pb + p, length - p, "rate_change %d %d",
-			       ev->data.index, ev->data.rate);
-		break;
-	case RC_PID_EVENT_TYPE_TX_RATE:
-		p += scnprintf(pb + p, length - p, "tx_rate %d %d",
-			       ev->data.index, ev->data.rate);
-		break;
-	case RC_PID_EVENT_TYPE_PF_SAMPLE:
-		p += scnprintf(pb + p, length - p,
-			       "pf_sample %d %d %d %d",
-			       ev->data.pf_sample, ev->data.prop_err,
-			       ev->data.int_err, ev->data.der_err);
-		break;
-	}
-	p += scnprintf(pb + p, length - p, "\n");
-
-	spin_unlock_irqrestore(&events->lock, status);
-
-	if (copy_to_user(buf, pb, p))
-		return -EFAULT;
-
-	return p;
-}
-
-#undef RC_PID_PRINT_BUF_SIZE
-
-static const struct file_operations rc_pid_fop_events = {
-	.owner = THIS_MODULE,
-	.read = rate_control_pid_events_read,
-	.poll = rate_control_pid_events_poll,
-	.open = rate_control_pid_events_open,
-	.release = rate_control_pid_events_release,
-	.llseek = noop_llseek,
-};
-
-void rate_control_pid_add_sta_debugfs(void *priv, void *priv_sta,
-					     struct dentry *dir)
-{
-	struct rc_pid_sta_info *spinfo = priv_sta;
-
-	spinfo->events_entry = debugfs_create_file("rc_pid_events", S_IRUGO,
-						   dir, spinfo,
-						   &rc_pid_fop_events);
-}
-
-void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta)
-{
-	struct rc_pid_sta_info *spinfo = priv_sta;
-
-	debugfs_remove(spinfo->events_entry);
-}
-- 
1.9.3

