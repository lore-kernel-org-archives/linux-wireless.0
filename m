Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42929 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754727AbXLNWUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 17:20:04 -0500
Date: Fri, 14 Dec 2007 23:14:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP][PATCH] rc80211_pid: Send events to userspace for
 debugging
Message-ID: <20071214231452.21ece93d@morte> (sfid-20071214_222011_051301_E06DDB03)
In-Reply-To: <1197414686.7030.27.camel@localhost>
References: <1197414686.7030.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here comes an amended patch which works with my tree and should be more
mergeable (as it splits the debugfs stuff to another file) just for
convenience and to save Mattias some hassle. Hope this helps.


From: Mattias Nissler <mattias.nissler@gmx.de>
NOT-Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
NOT-Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>

--

Index: wireless-2.6/net/mac80211/rc80211_pid.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid.c
+++ wireless-2.6/net/mac80211/rc80211_pid.c
@@ -16,6 +16,9 @@
 #include <net/mac80211.h>
 #include "ieee80211_rate.h"
 
+#include "rc80211_pid_debugfs.h"
+#include "rc80211_pid.h"
+
 
 /* This is an implementation of TX rate control algorithm that uses a PID
  * controller. Given a target failed frames rate, the controller decides about
@@ -106,109 +109,6 @@ module_param_named(rc_fast_start, modpar
 MODULE_PARM_DESC(rc_fast_start, "PID allowance for high rates right after"
 				"loading");
 
-/* Fixed point arithmetic shifting amount. */
-#define RC_PID_ARITH_SHIFT 8
-
-/* Fixed point arithmetic factor. */
-#define RC_PID_ARITH_FACTOR (1 << RC_PID_ARITH_SHIFT)
-
-/* Arithmetic right shift for positive and negative values for ISO C. */
-#define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
-	(x) < 0 ? -((-(x)) >> (y)) : (x) >> (y)
-
-struct rc_pid_sta_info {
-	unsigned long last_change;
-	unsigned long last_sample;
-
-	u32 tx_num_failed;
-	u32 tx_num_xmit;
-
-	/* Average failed frames percentage error (i.e. actual vs. target
-	 * percentage), scaled by RC_PID_SMOOTHING. This value is a
-	 * smoothed by using a exponentail weighted average technique:
-	 *
-	 *           (SMOOTHING - 1) * err_avg_old + err
-	 * err_avg = -----------------------------------
-	 *                       SMOOTHING
-	 *
-	 * where err_avg is the new approximation, err_avg_old the previous one
-	 * and err is the error w.r.t. to the current failed frames percentage
-	 * sample. Note that the bigger SMOOTHING the more weight is given to
-	 * the previous estimate, resulting in smoother behavior (i.e.
-	 * corresponding to a longer integration window).
-	 *
-	 * For computation, we actually don't use the above formula, but this
-	 * one:
-	 *
-	 * err_avg_scaled = err_avg_old_scaled - err_avg_old + err
-	 *
-	 * where:
-	 * 	err_avg_scaled = err * SMOOTHING
-	 * 	err_avg_old_scaled = err_avg_old * SMOOTHING
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
-	/* Rate control interval multiplier and divider. */
-	int imul;
-	int idiv;
-
-	/* The failed frames percentage target. */
-	int target;
-
-	/* P, I and D coefficients. */
-	int coeff_p;
-	int coeff_i;
-	int coeff_d;
-
-	/* Smoothing and sharpening factors. */
-	int sm_s;
-	int sh_s;
-	int sh_d;
-
-	/* Rate behaviour normalization factor. */
-	int norm_offset;
-
-	/* Fast start. */
-	bool fast_start;
-
-	/* Rates information. */
-	struct rc_pid_rateinfo *rinfo;
-
-	/* Index of the last used rate. */
-	int oldrate;
-};
-
 /* Shift the adjustment so that we won't switch to a lower rate if it exhibited
  * a worse failed frames behaviour and we'll choose the highest rate whose
  * failed frames behaviour is not worse than the one of the original rate
@@ -278,6 +178,12 @@ static void rate_control_pid_adjust_rate
 
 		newidx += back;
 	}
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	rate_control_pid_event_rate_change(
+		&((struct rc_pid_sta_info *)sta->rate_ctrl_priv)->events,
+		newidx, mode->rates[newidx].rate);
+#endif
 }
 
 /* Normalize the failed frames per-rate differences. */
@@ -383,6 +289,11 @@ static void rate_control_pid_sample(stru
 	if (spinfo->sharp_cnt)
 			spinfo->sharp_cnt--;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	rate_control_pid_event_pf_sample(&spinfo->events, pf, err_prop, err_int,
+					 err_der);
+#endif
+
 	/* Compute the controller output. */
 	adj = (err_prop * pinfo->coeff_p + err_int * pinfo->coeff_i
 	      + err_der * pinfo->coeff_d);
@@ -411,6 +322,10 @@ static void rate_control_pid_tx_status(v
 	spinfo = sta->rate_ctrl_priv;
 	spinfo->tx_num_xmit++;
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+	rate_control_pid_event_tx_status(&spinfo->events, status);
+#endif
+
 	/* We count frames that totally failed to be transmitted as two bad
 	 * frames, those that made it out but had some retries as one good and
 	 * one bad frame. */
@@ -476,6 +391,12 @@ rate_control_pid_get_rate(void *priv, st
 	sta_info_put(sta);
 
 	sel->rate = &mode->rates[rateidx];
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	rate_control_pid_event_tx_rate(
+		&((struct rc_pid_sta_info *) sta->rate_ctrl_priv)->events,
+		rateidx, mode->rates[rateidx].rate);
+#endif
 }
 
 
@@ -571,6 +492,13 @@ static void *rate_control_pid_alloc_sta(
 	struct rc_pid_sta_info *spinfo;
 
 	spinfo = kzalloc(sizeof(*spinfo), gfp);
+	if (spinfo == NULL)
+		return NULL;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+	spin_lock_init(&spinfo->events.lock);
+	init_waitqueue_head(&spinfo->events.waitqueue);
+#endif
 
 	return spinfo;
 }
@@ -592,4 +520,8 @@ struct rate_control_ops mac80211_rcpid =
 	.free = rate_control_pid_free,
 	.alloc_sta = rate_control_pid_alloc_sta,
 	.free_sta = rate_control_pid_free_sta,
+#ifdef CONFIG_MAC80211_DEBUGFS
+	.add_sta_debugfs = rate_control_pid_add_sta_debugfs,
+	.remove_sta_debugfs = rate_control_pid_remove_sta_debugfs,
+#endif
 };
Index: wireless-2.6/net/mac80211/rc80211_pid_debugfs.c
===================================================================
--- /dev/null
+++ wireless-2.6/net/mac80211/rc80211_pid_debugfs.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/poll.h>
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <linux/skbuff.h>
+
+#include <net/mac80211.h>
+#include "ieee80211_rate.h"
+
+#include "rc80211_pid_debugfs.h"
+#include "rc80211_pid.h"
+
+static void rate_control_pid_event(struct rc_pid_event_buffer *buf,
+				   enum rc_pid_event_type type,
+				   union rc_pid_event_data *data)
+{
+	struct rc_pid_event *ev;
+	unsigned long status;
+
+	spin_lock_irqsave(&buf->lock, status);
+	ev = &(buf->ring[buf->next_entry]);
+	buf->next_entry = (buf->next_entry + 1) % RC_PID_EVENT_RING_SIZE;
+
+	ev->timestamp = jiffies;
+	ev->id = buf->ev_count++;
+	ev->type = type;
+	ev->data = *data;
+
+	spin_unlock_irqrestore(&buf->lock, status);
+
+	wake_up_all(&buf->waitqueue);
+}
+
+void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
+					     struct ieee80211_tx_status *stat)
+{
+	union rc_pid_event_data evd;
+
+	memcpy(&evd.tx_status, stat, sizeof(struct ieee80211_tx_status));
+	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_TX_STATUS, &evd);
+}
+
+void rate_control_pid_event_rate_change(struct rc_pid_event_buffer *buf,
+					       int index, int rate)
+{
+	union rc_pid_event_data evd;
+
+	evd.index = index;
+	evd.rate = rate;
+	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_RATE_CHANGE, &evd);
+}
+
+void rate_control_pid_event_tx_rate(struct rc_pid_event_buffer *buf,
+					   int index, int rate)
+{
+	union rc_pid_event_data evd;
+
+	evd.index = index;
+	evd.rate = rate;
+	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_TX_RATE, &evd);
+}
+
+void rate_control_pid_event_pf_sample(struct rc_pid_event_buffer *buf,
+					     s32 pf_sample, s32 prop_err,
+					     s32 int_err, s32 der_err)
+{
+	union rc_pid_event_data evd;
+
+	evd.pf_sample = pf_sample;
+	evd.prop_err = prop_err;
+	evd.int_err = int_err;
+	evd.der_err = der_err;
+	rate_control_pid_event(buf, RC_PID_EVENT_TYPE_PF_SAMPLE, &evd);
+}
+
+static int rate_control_pid_events_open(struct inode *inode, struct file *file)
+{
+	struct rc_pid_sta_info *sinfo = inode->i_private;
+	struct rc_pid_event_buffer *events = &sinfo->events;
+	struct rc_pid_events_file_info *file_info;
+	unsigned int status;
+
+	/* Allocate a state struct */
+	file_info = kmalloc(sizeof(*file_info), GFP_KERNEL);
+	if (file_info == NULL)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&events->lock, status);
+
+	file_info->next_entry = events->next_entry;
+	file_info->events = events;
+
+	spin_unlock_irqrestore(&events->lock, status);
+
+	file->private_data = file_info;
+
+	return 0;
+}
+
+static int rate_control_pid_events_release(struct inode *inode,
+					   struct file *file)
+{
+	struct rc_pid_events_file_info *file_info = file->private_data;
+
+	kfree(file_info);
+
+	return 0;
+}
+
+static unsigned int rate_control_pid_events_poll(struct file *file,
+						 poll_table *wait)
+{
+	struct rc_pid_events_file_info *file_info = file->private_data;
+
+	poll_wait(file, &file_info->events->waitqueue, wait);
+
+	return POLLIN | POLLRDNORM;
+}
+
+#define RC_PID_PRINT_BUF_SIZE 64
+
+static ssize_t rate_control_pid_events_read(struct file *file, char __user *buf,
+					    size_t length, loff_t *offset)
+{
+	struct rc_pid_events_file_info *file_info = file->private_data;
+	struct rc_pid_event_buffer *events = file_info->events;
+	struct rc_pid_event *ev;
+	char pb[RC_PID_PRINT_BUF_SIZE];
+	int ret;
+	int p;
+	unsigned int status;
+
+	/* Check if there is something to read. */
+	if (events->next_entry == file_info->next_entry) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		/* Wait */
+		ret = wait_event_interruptible(events->waitqueue,
+				events->next_entry != file_info->next_entry);
+
+		if (ret)
+			return ret;
+	}
+
+	/* Write out one event per call. I don't care whether it's a little
+	 * inefficient, this is debugging code anyway. */
+	spin_lock_irqsave(&events->lock, status);
+
+	/* Get an event */
+	ev = &(events->ring[file_info->next_entry]);
+	file_info->next_entry = (file_info->next_entry + 1) %
+				RC_PID_EVENT_RING_SIZE;
+
+	/* Print information about the event. Note that userpace needs to
+	 * provide large enough buffers. */
+	length = length < RC_PID_PRINT_BUF_SIZE ?
+		 length : RC_PID_PRINT_BUF_SIZE;
+	p = snprintf(pb, length, "%u %lu ", ev->id, ev->timestamp);
+	switch (ev->type) {
+	case RC_PID_EVENT_TYPE_TX_STATUS:
+		p += snprintf(pb + p, length - p, "tx_status %u %u",
+			      ev->data.tx_status.excessive_retries,
+			      ev->data.tx_status.retry_count);
+		break;
+	case RC_PID_EVENT_TYPE_RATE_CHANGE:
+		p += snprintf(pb + p, length - p, "rate_change %d %d",
+			      ev->data.index, ev->data.rate);
+		break;
+	case RC_PID_EVENT_TYPE_TX_RATE:
+		p += snprintf(pb + p, length - p, "tx_rate %d %d",
+			      ev->data.index, ev->data.rate);
+		break;
+	case RC_PID_EVENT_TYPE_PF_SAMPLE:
+		p += snprintf(pb + p, length - p,
+			      "pf_sample %d %d %d %d",
+			      ev->data.pf_sample, ev->data.prop_err,
+			      ev->data.int_err, ev->data.der_err);
+		break;
+	}
+	p += snprintf(pb + p, length - p, "\n");
+
+	spin_unlock_irqrestore(&events->lock, status);
+
+	if (copy_to_user(buf, pb, p))
+		return -EFAULT;
+
+	return p;
+}
+
+#undef RC_PID_PRINT_BUF_SIZE
+
+struct file_operations rc_pid_fop_events = {
+	.owner = THIS_MODULE,
+	.read = rate_control_pid_events_read,
+	.poll = rate_control_pid_events_poll,
+	.open = rate_control_pid_events_open,
+	.release = rate_control_pid_events_release,
+};
+
+void rate_control_pid_add_sta_debugfs(void *priv, void *priv_sta,
+					     struct dentry *dir)
+{
+	struct rc_pid_sta_info *spinfo = priv_sta;
+
+	spinfo->events_entry = debugfs_create_file("rc_pid_events", S_IRUGO,
+						   dir, spinfo,
+						   &rc_pid_fop_events);
+}
+
+void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta)
+{
+	struct rc_pid_sta_info *spinfo = priv_sta;
+
+	debugfs_remove(spinfo->events_entry);
+}
Index: wireless-2.6/net/mac80211/rc80211_pid_debugfs.h
===================================================================
--- /dev/null
+++ wireless-2.6/net/mac80211/rc80211_pid_debugfs.h
@@ -0,0 +1,98 @@
+#ifndef RC80211_PID_DEBUGFS_H
+#define RC80211_PID_DEBUGFS_H
+
+enum rc_pid_event_type
+{
+	RC_PID_EVENT_TYPE_TX_STATUS,
+	RC_PID_EVENT_TYPE_RATE_CHANGE,
+	RC_PID_EVENT_TYPE_TX_RATE,
+	RC_PID_EVENT_TYPE_PF_SAMPLE,
+};
+
+union rc_pid_event_data
+{
+	/* RC_PID_EVENT_TX_STATUS */
+	struct
+	{
+		struct ieee80211_tx_status tx_status;
+	};
+	/* RC_PID_EVENT_TYPE_RATE_CHANGE */
+	/* RC_PID_EVENT_TYPE_TX_RATE */
+	struct
+	{
+		int index;
+		int rate;
+	};
+	/* RC_PID_EVENT_TYPE_PF_SAMPLE */
+	struct
+	{
+		s32 pf_sample;
+		s32 prop_err;
+		s32 int_err;
+		s32 der_err;
+	};
+};
+
+struct rc_pid_event
+{
+	/* The time when the event occured */
+	unsigned long timestamp;
+
+	/* Event ID number */
+	unsigned int id;
+
+	/* Type of event */
+	enum rc_pid_event_type type;
+
+	/* type specific data */
+	union rc_pid_event_data data;
+};
+
+/* Size of the event ring buffer. */
+#define RC_PID_EVENT_RING_SIZE 32
+
+struct rc_pid_event_buffer
+{
+	/* Counter that generates event IDs */
+	unsigned int ev_count;
+
+	/* Ring buffer of events */
+	struct rc_pid_event ring[RC_PID_EVENT_RING_SIZE];
+
+	/* Index to the entry in events_buf to be reused */
+	unsigned int next_entry;
+
+	/* Lock that guards against concurrent access to this buffer struct */
+	spinlock_t lock;
+
+	/* Wait queue for poll/select and blocking I/O */
+	wait_queue_head_t waitqueue;
+};
+
+struct rc_pid_events_file_info
+{
+	/* The event buffer we read */
+	struct rc_pid_event_buffer *events;
+
+	/* The entry we have should read next */
+	unsigned int next_entry;
+};
+void rate_control_pid_event_tx_status(struct rc_pid_event_buffer *buf,
+					     struct ieee80211_tx_status *stat);
+
+void rate_control_pid_event_rate_change(struct rc_pid_event_buffer *buf,
+					       int index, int rate);
+
+void rate_control_pid_event_tx_rate(struct rc_pid_event_buffer *buf,
+					   int index, int rate);
+
+void rate_control_pid_event_pf_sample(struct rc_pid_event_buffer *buf,
+					     s32 pf_sample, s32 prop_err,
+					     s32 int_err, s32 der_err);
+
+void rate_control_pid_add_sta_debugfs(void *priv, void *priv_sta,
+					     struct dentry *dir);
+
+void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta);
+
+#endif /* RC80211_PID_DEBUGFS_H */
Index: wireless-2.6/net/mac80211/Makefile
===================================================================
--- wireless-2.6.orig/net/mac80211/Makefile
+++ wireless-2.6/net/mac80211/Makefile
@@ -1,9 +1,9 @@
 obj-$(CONFIG_MAC80211) += mac80211.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
 mac80211-objs-$(CONFIG_MAC80211_RCPID) += rc80211_pid.o
+mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o rc80211_pid_debugfs.o
 
 mac80211-objs := \
 	ieee80211.o \
Index: wireless-2.6/net/mac80211/rc80211_pid.h
===================================================================
--- /dev/null
+++ wireless-2.6/net/mac80211/rc80211_pid.h
@@ -0,0 +1,116 @@
+#ifndef RC80211_PID_H
+#define RC80211_PID_H
+
+
+/* Fixed point arithmetic shifting amount. */
+#define RC_PID_ARITH_SHIFT 8
+
+/* Fixed point arithmetic factor. */
+#define RC_PID_ARITH_FACTOR (1 << RC_PID_ARITH_SHIFT)
+
+/* Arithmetic right shift for positive and negative values for ISO C. */
+#define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
+	(x) < 0 ? -((-(x)) >> (y)) : (x) >> (y)
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
+	/* Last framed failes percentage sample. */
+	u32 last_pf;
+
+	/* Sharpening needed. */
+	u8 sharp_cnt;
+
+#ifdef CONFIG_MAC80211_DEBUGFS
+
+	/* Event buffer */
+	struct rc_pid_event_buffer events;
+
+	/* Events debugfs file entry */
+	struct dentry *events_entry;
+#endif
+};
+
+/* Algorithm parameters. We keep them on a per-algorithm approach, so they can
+ * be tuned individually for each interface.
+ */
+struct rc_pid_rateinfo {
+
+	/* Map sorted rates to rates in ieee80211_hw_mode. */
+	int index;
+
+	/* Map rates in ieee80211_hw_mode to sorted rates. */
+	int rev_index;
+
+	/* Did we do any measurement on this rate? */
+	bool valid;
+
+	/* Comparison with the lowest rate. */
+	int diff;
+};
+
+struct rc_pid_info {
+
+	/* Rate control interval multiplier and divider. */
+	int imul;
+	int idiv;
+
+	/* The failed frames percentage target. */
+	int target;
+
+	/* P, I and D coefficients. */
+	int coeff_p;
+	int coeff_i;
+	int coeff_d;
+
+	/* Smoothing and sharpening factors. */
+	int sm_s;
+	int sh_s;
+	int sh_d;
+
+	/* Rate behaviour normalization factor. */
+	int norm_offset;
+
+	/* Fast start. */
+	bool fast_start;
+
+	/* Rates information. */
+	struct rc_pid_rateinfo *rinfo;
+
+	/* Index of the last used rate. */
+	int oldrate;
+};
+#endif /* RC80211_PID_H */



-- 
Ciao
Stefano
