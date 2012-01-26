Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:48927 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2AZPeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 10:34:14 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: rodrigue@qca.qualcomm.com, nbd@openwrt.org, adrian.chadd@gmail.com,
	kgiori@qca.qualcomm.com, shafi.wireless@gmail.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFC 1/2] ath9k: add DFS pattern detector
Date: Thu, 26 Jan 2012 16:34:03 +0100
Message-Id: <1327592044-3319-2-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120126_163423_578733_9E74C41C)
In-Reply-To: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1327592044-3319-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a DFS pattern detector to the common ath module. It takes
pulse events reported by ath9k and reports in place whether a
pattern was detected. On detection, caller must report a radar event
to the DFS management component in the upper layer.

Currently the ETSI DFS domain is supported with detector lines for
the patterns defined by EN-301-893 v1.5.1. Support for FCC and JP
will be added gradually.

The detector is independent of the underlying HW, but located in
the ath driver since so far it is used by ath9k only. It might
move up to mac80211 as soon as other non-Atheros drivers start
using it.

NOTE: since DFS requires some more components on different layers
that are currently missing, the detector is not functionally
integrated yet. When ath9k is build with a certified DFS config
option, the detector is included in ath.ko. All it does there is
wasting kernel memory and waiting to be used by ath9k.

USAGE: to use the detector, wiphy drivers must
 - use dfs_pattern_detector.h as interface
 - have a struct dfs_pattern_detector *dpd per wiphy
 - on wiphy creation, instantiate a detector with
   dpd = dfs_pattern_detector_init(enum dfs_domain)
 - forward any radar pulse detected to dpd->add_pulse()
 - report radar event if add_pulse() returns RADAR_DETECTED
 - on wiphy destruction call dpd->exit()

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/Makefile                  |   10 +
 .../ath/dfs_pattern_detector/detector_elem.c       |   92 ++++++
 .../ath/dfs_pattern_detector/detector_elem.h       |   45 +++
 .../dfs_pattern_detector/dfs_pattern_detector.h    |   92 ++++++
 .../ath/dfs_pattern_detector/pattern_detector.c    |  294 ++++++++++++++++++++
 .../ath/dfs_pattern_detector/pulse_queue.c         |  168 +++++++++++
 .../ath/dfs_pattern_detector/pulse_queue.h         |   77 +++++
 .../ath/dfs_pattern_detector/pulse_sequence.c      |  280 +++++++++++++++++++
 .../ath/dfs_pattern_detector/pulse_sequence.h      |   89 ++++++
 .../ath/dfs_pattern_detector/radar_types.c         |   52 ++++
 .../ath/dfs_pattern_detector/radar_types.h         |   95 +++++++
 .../net/wireless/ath/dfs_pattern_detector/utils.c  |   45 +++
 .../net/wireless/ath/dfs_pattern_detector/utils.h  |   30 ++
 13 files changed, 1369 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/dfs_pattern_detector.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/radar_types.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/radar_types.h
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/utils.c
 create mode 100644 drivers/net/wireless/ath/dfs_pattern_detector/utils.h

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index d716b74..10f9554 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -11,4 +11,14 @@ ath-objs :=	main.o \
 		key.o
 
 ath-$(CONFIG_ATH_DEBUG) += debug.o
+
+# include DFS pattern detector if we have certified HW
+ath-$(CONFIG_ATH9K_DFS_CERTIFIED)	+= \
+			dfs_pattern_detector/pulse_queue.o \
+			dfs_pattern_detector/pulse_sequence.o \
+			dfs_pattern_detector/detector_elem.o \
+			dfs_pattern_detector/pattern_detector.o \
+			dfs_pattern_detector/radar_types.o \
+			dfs_pattern_detector/utils.o
+
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.c b/drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.c
new file mode 100644
index 0000000..ea5ae34
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/slab.h>
+
+#include "detector_elem.h"
+#include "utils.h"
+#include "pulse_sequence.h"
+
+
+static void de_exit(struct detector_elem *de)
+{
+	de->reset(de, 0);
+	if (de->sequence_handler != NULL)
+		de->sequence_handler->exit(de->sequence_handler);
+	kfree(de);
+}
+
+static void de_reset(struct detector_elem *de, u64 ts)
+{
+	de->sequence_handler->reset(de->sequence_handler);
+	de->last_ts = ts;
+}
+
+static int de_add_pulse(struct detector_elem *de, struct pulse_event *event)
+{
+	u64 ts = event->ts;
+	int retval = 0;
+	int detected_pri;
+	struct radar_detector_specs *rs = de->radar_spec;
+
+	/* ignore pulses not within width range */
+	if ((rs->width_min > event->width) || (rs->width_max < event->width))
+		return 0;
+
+	if (ts < de->last_ts)
+		/* reset detector on time stamp wrap-around */
+		de->sequence_handler->reset(de->sequence_handler);
+	else if ((ts - de->last_ts) < rs->max_pri_tolerance)
+		/* if delta to last pulse is too short, don't use this pulse */
+		return 0;
+	de->last_ts = ts;
+
+	detected_pri = de->sequence_handler->add(de->sequence_handler, ts);
+	if (detected_pri > 0) {
+		pr_info("*********** radar detected on type %d, pri=%d\n",
+				de->radar_spec->type_id, detected_pri);
+		retval = 1;
+	}
+	return retval;
+}
+
+static struct detector_elem default_detector_elem = {
+	.exit = de_exit,
+	.add_pulse = de_add_pulse,
+	.reset = de_reset,
+};
+
+struct detector_elem *detector_elem_init(struct radar_detector_specs *rs)
+{
+	struct detector_elem *de;
+	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	if (de == NULL)
+		return NULL;
+	*de = default_detector_elem;
+
+	de->sequence_handler = pulse_sequence_handler_init(rs);
+	if (de->sequence_handler == NULL)
+		goto failure;
+
+	de->radar_spec = rs;
+
+	return de;
+
+failure:
+	de->exit(de);
+	return NULL;
+}
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.h b/drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.h
new file mode 100644
index 0000000..b58d4a6
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/detector_elem.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef DETECTOR_ELEM_H
+#define DETECTOR_ELEM_H
+
+#include "dfs_pattern_detector.h"
+#include "radar_types.h"
+
+/**
+ * struct detector_elem - detector element for a dedicated radar type
+ * @exit(): destructor
+ * @add_pulse(): add pulse event, returns 1 if pattern was detected
+ * @reset(): clear states and reset to given time stamp
+ * @radar_spec: detector specs for this detector element
+ * @sequence_handler: sequence handler collecting pulse sequences
+ * @last_ts: last valid pulse time stamp considered for this element
+ */
+struct detector_elem {
+	void (*exit)     (struct detector_elem *de);
+	int  (*add_pulse)(struct detector_elem *de, struct pulse_event *e);
+	void (*reset)    (struct detector_elem *de, u64 ts);
+
+/* private: internal use only */
+	struct radar_detector_specs *radar_spec;
+	struct pulse_sequence_handler *sequence_handler;
+	u64 last_ts;
+};
+
+struct detector_elem *detector_elem_init(struct radar_detector_specs *rs);
+
+#endif /* DETECTOR_ELEM_H */
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/dfs_pattern_detector.h b/drivers/net/wireless/ath/dfs_pattern_detector/dfs_pattern_detector.h
new file mode 100644
index 0000000..6fccbdf
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/dfs_pattern_detector.h
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef DFS_H
+#define DFS_H
+
+#include <linux/types.h>
+
+/**
+ * enum dfs_detector_result - DFS detector result after adding pulse
+ * @NO_DETECTION: pulse added, but no detection so far
+ * @RADAR_DETECTED: pulse added, pattern matched => radar detected
+ * @PULSE_DROPPED: pulse not added, outside valid pattern ranges
+ */
+enum dfs_detector_result {
+	NO_DETECTION,
+	RADAR_DETECTED,
+	PULSE_DROPPED,
+};
+
+/**
+ * enum dfs_domain - DFS regulatory domains
+ * @DFS_DOMAIN_UNINIT: uninitialized/invalid dfs domain
+ * @DFS_DOMAIN_FCC: FCC domain
+ * @DFS_DOMAIN_ETSI: ETSI domain
+ * @DFS_DOMAIN_JP: Japan domain
+ *
+ * TODO: move those to or reuse from a more common place
+ */
+enum dfs_domain {
+	DFS_DOMAIN_UNINIT	= 0,
+	DFS_DOMAIN_FCC		= 1,
+	DFS_DOMAIN_ETSI		= 2,
+	DFS_DOMAIN_JP		= 3,
+};
+
+/**
+ * struct pulse_event - describing pulses reported by PHY
+ * @ts: pulse time stamp in us
+ * @freq: channel frequency in MHz
+ * @rssi: rssi of radar event
+ * @width: pulse duration in us
+ */
+struct pulse_event {
+	__u64	ts;
+	__u16	freq;
+	__u8	rssi;
+	__u8	width;
+};
+
+/**
+ * struct dfs_pattern_detector - DFS pattern detector
+ * @exit: destructor
+ * @add_pulse: add radar pulse to detector, return detector result
+ */
+struct dfs_pattern_detector {
+	void (*exit)(struct dfs_pattern_detector *dpd);
+	enum dfs_detector_result (*add_pulse)
+		(struct dfs_pattern_detector *dpd, struct pulse_event *pe);
+};
+
+/**
+ * dfs_pattern_detector_init() - constructor for pattern detector class
+ * @param dfs_domain: DFS domain to be used
+ * @return instance pointer on success, NULL otherwise
+ */
+extern struct dfs_pattern_detector *dfs_pattern_detector_init(enum dfs_domain);
+
+/**
+ * DOC: Workflow using DFS Pattern Detector with PHY
+ * 1) when a PHY requiring DFS support is created, create a pattern-detector
+ *    instance with dfs_pattern_detector_init()
+ * 2) feed pulse_events detected by PHY to pattern_detector->add_pulse()
+ * 3) if pattern_detector->add_pulse() returns RADAR_DETECTED, inform DFS
+ *    management layer about radar detection
+ * 4) on PHY destruction, call pattern_detector->exit() to free resources
+ */
+
+#endif /* DFS_H */
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
new file mode 100644
index 0000000..2d634fe
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/pattern_detector.c
@@ -0,0 +1,294 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/list.h>
+
+#include "dfs_pattern_detector.h"
+#include "detector_elem.h"
+#include "radar_types.h"
+
+/**
+ * struct channel_detector - detector elements for a DFS channel
+ * @head: list_head
+ * @freq: frequency for this channel detector in MHz
+ * @detectors: array of dynamically created detector elements for this freq
+ */
+struct channel_detector {
+	struct list_head head;
+	u16 freq;
+	struct detector_elem **detectors;
+};
+
+/**
+ * struct pattern_detector - overloading base dfs_pattern_detector
+ *
+ * @exit(): destructor
+ * @add_pulse(): add radar pulse to detector
+ * @num_radar_types: number of different radar types
+ * @last_pulse_ts: time stamp of last valid pulse
+ * @radar_detector_specs: array of radar detection specs
+ * @channel_detectors: list connecting channel_detector elements
+ */
+struct pattern_detector {
+	void (*exit)(struct pattern_detector *_this);
+	enum dfs_detector_result (*add_pulse)
+		(struct pattern_detector *_this, struct pulse_event *pe);
+
+	u8 num_radar_types;
+	u64 last_pulse_ts;
+	struct radar_detector_specs *radar_spec;
+	struct list_head channel_detectors;
+};
+
+/*
+ * tolerated deviation of radar time stamp in usecs on both sides
+ *
+ * TODO: this might need to be HW-dependent
+ */
+#define MAX_PRI_TOLERANCE	16
+
+/**
+ * is_dfs_channel() - verify that frequency is a DFS channel
+ * @param freq: frequency to check
+ * @return 1 if valid, 0 otherwise
+ *
+ * For double checking that reported pulse events have valid frequencies.
+ * TODO: might be skipped if caller ensures validity
+ */
+static int is_dfs_channel(u16 freq)
+{
+	const u16 dfs_channels[] = {
+		5260, 5280, 5300,
+		5320, 5500, 5520,
+		5540, 5560, 5580,
+		/* weather radar channels are not supported */
+		/* 5600, 5620, 5640, */
+		5660, 5680, 5700,
+	};
+	int i;
+	for (i = 0; i < ARRAY_SIZE(dfs_channels); i++)
+		if (dfs_channels[i] == freq)
+			return 1;
+	return 0;
+}
+
+static void free_dfs_channel_detector(struct pattern_detector *dpd,
+				      struct channel_detector *cd)
+{
+	int i;
+	if (cd == NULL)
+		return;
+	list_del(&cd->head);
+	for (i = 0; i < dpd->num_radar_types; i++) {
+		struct detector_elem *de = cd->detectors[i];
+		if (de != NULL)
+			de->exit(de);
+	}
+	kfree(cd->detectors);
+	kfree(cd);
+}
+
+static struct channel_detector *
+create_dfs_channel_detector(struct pattern_detector *dpd, u16 freq)
+{
+	int sz, i;
+	struct channel_detector *cd;
+
+	if (is_dfs_channel(freq) == 0) {
+		pr_warn("dropping non-DFS frequency %d\n", freq);
+		return NULL;
+	}
+
+	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
+	if (cd == NULL)
+		goto fail;
+
+	INIT_LIST_HEAD(&cd->head);
+	cd->freq = freq;
+	sz = sizeof(cd->detectors) * dpd->num_radar_types;
+	cd->detectors = kmalloc(sz, GFP_KERNEL);
+	if (cd->detectors == NULL)
+		goto fail;
+
+	memset(cd->detectors, 0, sz);
+	for (i = 0; i < dpd->num_radar_types; i++) {
+		struct radar_detector_specs *rs = &dpd->radar_spec[i];
+		struct detector_elem *de = detector_elem_init(rs);
+		if (de == NULL)
+			goto fail;
+		cd->detectors[i] = de;
+	}
+	list_add(&cd->head, &dpd->channel_detectors);
+	return cd;
+
+fail:
+	pr_err("failed to allocate channel_detector for freq=%d\n", freq);
+	free_dfs_channel_detector(dpd, cd);
+	return NULL;
+}
+
+/**
+ * get_dfs_channel_detector() - get channel detector for given frequency
+ * @param dpd instance pointer
+ * @param freq frequency in MHz
+ * @return pointer to channel detector on success, NULL otherwise
+ *
+ * Return existing channel detector for the given frequency or return a
+ * newly create one.
+ */
+static struct channel_detector *
+get_dfs_channel_detector(struct pattern_detector *dpd, u16 freq)
+{
+	struct channel_detector *cd;
+	list_for_each_entry(cd, &dpd->channel_detectors, head) {
+		if (cd->freq == freq)
+			return cd;
+	}
+	return create_dfs_channel_detector(dpd, freq);
+}
+
+/**
+ * detector_reset() - reset all detector lines for a given channel
+ * @param dpd: detector instance
+ * @param cd: channel detector
+ */
+static void detector_reset(struct pattern_detector *dpd,
+			   struct channel_detector *cd)
+{
+	int i;
+	struct detector_elem **de;
+	u64 ts = dpd->last_pulse_ts;
+	de = cd->detectors;
+	for (i = 0; i < dpd->num_radar_types; i++, de++)
+		(*de)->reset(*de, ts);
+}
+
+static void dpd_exit(struct pattern_detector *dpd)
+{
+	struct channel_detector *cd, *cd0;
+	if (!list_empty(&dpd->channel_detectors))
+		list_for_each_entry_safe(cd, cd0, &dpd->channel_detectors, head)
+			free_dfs_channel_detector(dpd, cd);
+
+	kfree(dpd->radar_spec);
+	kfree(dpd);
+}
+
+static enum dfs_detector_result
+dpd_add_pulse(struct pattern_detector *dpd, struct pulse_event *event)
+{
+	int i;
+	struct detector_elem **de;
+	struct channel_detector *cd;
+
+	cd = get_dfs_channel_detector(dpd, event->freq);
+	if (cd == NULL)
+		return PULSE_DROPPED;
+
+	dpd->last_pulse_ts = event->ts;
+
+	de = cd->detectors;
+	/* do type individual pattern matching */
+	for (i = 0; i < dpd->num_radar_types; i++, de++) {
+		if ((*de)->add_pulse(*de, event) != 0) {
+			detector_reset(dpd, cd);
+			return RADAR_DETECTED;
+		}
+	}
+	return NO_DETECTION;
+}
+
+/* percentage on ppb threshold to trigger detection */
+#define MIN_PPB_THRESH	50
+#define PPB_THRESH(X)	((X*MIN_PPB_THRESH + 50) / 100)
+/*
+ * convert PRF (pulse repetition freq) to PRI (pulse repetition interval) in us
+ * includes correct rounding
+ */
+#define PRF2PRI(X) ((1000000 + X/2) / X)
+
+static int init_dfs_pattern(struct pattern_detector *dpd,
+			    const struct radar_types *rt, int jitter)
+{
+	int i;
+	int sz;
+	const struct dfs_radar_spec *drs;
+	struct radar_detector_specs *rs;
+
+	sz = sizeof(*dpd->radar_spec) * rt->num_radar_types;
+	dpd->radar_spec = kmalloc(sz, GFP_KERNEL);
+	if (dpd->radar_spec == NULL)
+		return -1;
+	memset(dpd->radar_spec, 0, sz);
+	dpd->num_radar_types = rt->num_radar_types;
+
+	drs = rt->radar_types;
+	rs = dpd->radar_spec;
+	for (i = 0; i < rt->num_radar_types; i++, drs++, rs++) {
+		rs->type_id = drs->type_id;
+		rs->width_min = drs->width_min;
+		rs->width_max = drs->width_max;
+		rs->pri_min = PRF2PRI(drs->prf_max) - jitter;
+		/* for multi-pri, we accept combined pris */
+		rs->pri_max = PRF2PRI(drs->prf_min) * drs->num_prf + jitter;
+		rs->num_pri = drs->num_prf;
+		rs->ppb = drs->ppb;
+		/* we do not consider multiplier in multi-pri patterns */
+		rs->ppb_thresh = PPB_THRESH(drs->ppb);
+		rs->max_dur = rs->pri_max * drs->ppb * drs->num_prf;
+		rs->max_pri_tolerance = jitter;
+	}
+	return 0;
+}
+
+static struct pattern_detector default_dpd = {
+	.exit = dpd_exit,
+	.add_pulse = dpd_add_pulse,
+};
+
+struct dfs_pattern_detector *
+dfs_pattern_detector_init(enum dfs_domain dfs_domain)
+{
+	struct pattern_detector *dpd;
+	const struct radar_types *rt = get_dfs_domain_radar_types(dfs_domain);
+
+	if (rt == NULL) {
+		pr_err("non-supported dfs-domain %d\n", dfs_domain);
+		return NULL;
+	}
+
+	dpd = kmalloc(sizeof(struct pattern_detector), GFP_KERNEL);
+	if (dpd == NULL) {
+		pr_err("allocation of pattern_detector failed\n");
+		return NULL;
+	}
+	*dpd = default_dpd;
+	INIT_LIST_HEAD(&dpd->channel_detectors);
+
+	/* allocate and initialize object data */
+	if (init_dfs_pattern(dpd, rt, MAX_PRI_TOLERANCE) != 0) {
+		pr_err("initialization of pattern_detector failed\n");
+		dpd->exit(dpd);
+		return NULL;
+	}
+	/* cast instance pointer to base class */
+	return (struct dfs_pattern_detector *)dpd;
+}
+EXPORT_SYMBOL(dfs_pattern_detector_init);
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.c b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.c
new file mode 100644
index 0000000..ca706f7
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.c
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/slab.h>
+
+#include "pulse_queue.h"
+
+/**
+ * DOC: Pulse Pool
+ *
+ * Instances of pulse_elem are kept in a singleton pool to reduce the
+ * number of dynamic allocations. It is shared between all pulse queues and
+ * grows up to the peak number of simultaneously used pulses.
+ *
+ * Memory is freed after all reference to the pool are released.
+ */
+static int pulse_pool_references;
+static LIST_HEAD(pulse_pool);
+static int pulse_pool_count;
+
+static void pulse_pool_register(void)
+{
+	pulse_pool_references++;
+}
+
+static void pulse_pool_deregister(void)
+{
+	struct pulse_elem *p, *p0;
+	pulse_pool_references--;
+	if (pulse_pool_references > 0)
+		return;
+
+	list_for_each_entry_safe(p, p0, &pulse_pool, head) {
+		list_del(&p->head);
+		kfree(p);
+	}
+	pulse_pool_count = 0;
+}
+
+static struct pulse_elem *pulse_pool_get(void)
+{
+	struct pulse_elem *p;
+	if (pulse_pool_count <= 0)
+		return kmalloc(sizeof(*p), GFP_KERNEL);
+
+	p = list_first_entry(&pulse_pool, struct pulse_elem, head);
+	list_del(&p->head);
+	pulse_pool_count--;
+	return p;
+}
+
+static void pulse_pool_put(struct pulse_elem *p)
+{
+	list_del_init(&p->head);
+	list_add(&p->head, &pulse_pool);
+	pulse_pool_count++;
+}
+
+/*
+ * Pulse queue class
+ */
+static struct pulse_elem *get_tail(struct pulse_queue *pq)
+{
+	struct list_head *l = &pq->pulses;
+	if (list_empty(l))
+		return NULL;
+	return list_entry(l->prev, struct pulse_elem, head);
+}
+
+static int pq_dequeue(struct pulse_queue *pq)
+{
+	struct pulse_elem *p = get_tail(pq);
+	if (p != NULL) {
+		pulse_pool_put(p);
+		pq->count--;
+	}
+	return (pq->count > 0);
+}
+
+static void pq_reset(struct pulse_queue *pq)
+{
+	while (pq_dequeue(pq) > 0)
+		/* NOP */;
+}
+
+static void pq_exit(struct pulse_queue *pq)
+{
+	pq->reset(pq);
+	kfree(pq);
+	pulse_pool_deregister();
+}
+
+/* remove pulses older than window */
+static void check_window(struct pulse_queue *pq)
+{
+	u64 min_valid_ts;
+	struct pulse_elem *p;
+
+	/* there is no delta time with less than 2 pulses */
+	if (pq->count < 2)
+		return;
+
+	if (pq->last_ts <= pq->window_size)
+		return;
+
+	min_valid_ts = pq->last_ts - pq->window_size;
+	while ((p = get_tail(pq)) != NULL) {
+		if (p->ts >= min_valid_ts)
+			return;
+		pq_dequeue(pq);
+	}
+}
+
+static int pq_enqueue(struct pulse_queue *pq, u64 ts)
+{
+	struct pulse_elem *p = pulse_pool_get();
+	if (p == NULL) {
+		pr_err("failed to allocate pulse_elem\n");
+		return -1;
+	}
+
+	memset(p, 0, sizeof(*p));
+	INIT_LIST_HEAD(&p->head);
+	p->ts = ts;
+	list_add(&p->head, &pq->pulses);
+	pq->count++;
+	pq->last_ts = ts;
+	check_window(pq);
+	if (pq->count >= pq->max_count)
+		pq_dequeue(pq);
+	return 0;
+}
+
+static struct pulse_queue default_pulse_queue = {
+	.exit = pq_exit,
+	.enqueue = pq_enqueue,
+	.reset = pq_reset,
+};
+
+struct pulse_queue *pulse_queue_init(int max_count, int window_size)
+{
+	struct pulse_queue *pq = kmalloc(sizeof(*pq), GFP_KERNEL);
+	if (pq == NULL) {
+		pr_err("failed to allocate pulse_queue\n");
+		return NULL;
+	}
+
+	*pq = default_pulse_queue;
+	INIT_LIST_HEAD(&pq->pulses);
+	pq->window_size = window_size;
+	pq->max_count = max_count;
+	pulse_pool_register();
+	return pq;
+}
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.h b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.h
new file mode 100644
index 0000000..d2d12eb
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_queue.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef PULSE_QUEUE_H
+#define PULSE_QUEUE_H
+
+#include "linux/list.h"
+
+/**
+ * DOC: Pulse Queue
+ *
+ * Pulse queue class with
+ *   * newest pulses being enqueued to head
+ *   * oldest pulses are dequeued from tail
+ *
+ * The queue is instantiated with the maximum number of pulses to keep and
+ * the valid window size. When a pulse added exceeds the maximum number of
+ * pulses, the oldest pulse is dequeued. At the same time, all pulses older
+ * than the window to the newest pulse are removed.
+ */
+
+/**
+ * struct pulse_elem - pulse elements handled by pulse queue are time stamps
+ * @head: list_head
+ * @ts: time stamp in usecs
+ */
+struct pulse_elem {
+	struct list_head head;
+	u64 ts;
+};
+
+/**
+ * struct pulse_queue - pulse queue class for window based pulse handling
+ * @exit(): destructor
+ * @reset(): release all pulses
+ * @enqueue(): add pulse with given (strictly increasing) time stamp to queue
+ * @last_ts: time stamp of last pulse added to queue
+ * @pulses: list connecting pulse_elem objects
+ * @count: number of pulses in queue
+ * @max_count: maximum number of pulses to be queued
+ * @window_size: valid window size back from newest pulse time stamp in usecs
+ */
+struct pulse_queue {
+	void (*exit)(struct pulse_queue *pq);
+	void (*reset)(struct pulse_queue *pq);
+	int  (*enqueue)(struct pulse_queue *pq, u64 ts);
+
+	u64 last_ts;
+/* private: internal use only */
+	struct list_head pulses;
+	int count;
+	int max_count;
+	int window_size;
+};
+
+/**
+ * pulse_queue_init() - constructor for pulse queue class
+ * @param max_count: maximum number of pulses to be queued
+ * @param window_size: window size in usecs
+ * @return instance pointer on success, NULL otherwise
+ */
+extern struct pulse_queue *pulse_queue_init(int max_count, int window_size);
+
+#endif /* PULSE_QUEUE_H */
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.c b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.c
new file mode 100644
index 0000000..6fc65de
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.c
@@ -0,0 +1,280 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/slab.h>
+
+#include "pulse_sequence.h"
+#include "utils.h"
+#include "pulse_queue.h"
+#include "radar_types.h"
+
+/**
+ * DOC: Pulse Sequence Pool
+ *
+ * Instances of pulse_sequence are kept in a singleton pool to reduce the
+ * number of dynamic allocations. It is shared between all pulse sequences
+ * and grows up to the peak number of simultaneously used sequences.
+ *
+ * Memory is freed after all reference to the pool are released.
+ */
+static int seq_pool_references;
+static LIST_HEAD(seq_pool);
+static int seq_pool_count;
+
+static void seq_pool_register(void)
+{
+	seq_pool_references++;
+}
+
+static void seq_pool_deregister(void)
+{
+	struct pulse_sequence *ps, *ps0;
+
+	seq_pool_references--;
+	if (seq_pool_references > 0)
+		return;
+
+	list_for_each_entry_safe(ps, ps0, &seq_pool, head) {
+		list_del(&ps->head);
+		kfree(ps);
+	}
+	seq_pool_count = 0;
+}
+
+static struct pulse_sequence *seq_pool_get(void)
+{
+	struct pulse_sequence *p;
+	if (seq_pool_count <= 0)
+		return kmalloc(sizeof(*p), GFP_KERNEL);
+
+	p = list_first_entry(&seq_pool, struct pulse_sequence, head);
+	list_del(&p->head);
+	seq_pool_count--;
+	return p;
+}
+
+static void seq_pool_put(struct pulse_sequence *p)
+{
+	list_del_init(&p->head);
+	list_add(&p->head, &seq_pool);
+	seq_pool_count++;
+}
+
+static void ps_reset(struct pulse_sequence_handler *psh)
+{
+	struct pulse_sequence *ps, *ps0;
+	list_for_each_entry_safe(ps, ps0, &psh->sequences, head)
+		seq_pool_put(ps);
+	psh->pq->reset(psh->pq);
+	psh->count = 0;
+}
+
+static void ps_exit(struct pulse_sequence_handler *psh)
+{
+	psh->reset(psh);
+	if (psh->pq != NULL)
+		psh->pq->exit(psh->pq);
+	kfree(psh);
+	seq_pool_deregister();
+}
+
+static int match_past_pulse_to_sequence(struct pulse_sequence_handler *psh,
+					struct pulse_sequence *ps, u64 ts)
+{
+	u64 first_ts = ps->first_ts;
+	u32 delta_ts = first_ts - ts;
+	u32 tolerance = psh->rs->max_pri_tolerance;
+	return (get_multiple(delta_ts, ps->pri, tolerance) > 0);
+}
+
+static int create_sequences(struct pulse_sequence_handler *psh,
+			    u64 ts, int min_count)
+{
+	struct pulse_elem *p;
+	struct list_head *pulses = &psh->pq->pulses;
+
+	struct pulse_sequence ps;
+	list_for_each_entry(p, pulses, head) {
+		struct pulse_elem *p2;
+		struct pulse_sequence *new_ps;
+		int tmp_false_count;
+		u64 min_valid_ts;
+		int delta_ts = ts - p->ts;
+
+		if (delta_ts < psh->rs->pri_min)
+			/* ignore too small pri */
+			continue;
+
+		if (delta_ts > psh->rs->pri_max)
+			/* stop on too large pri (sorted list) */
+			break;
+
+		/* build a new sequence with new potential pri */
+		ps.count = 2;
+		ps.count_falses = 0;
+		ps.first_ts = p->ts;
+		ps.last_ts = ts;
+		ps.pri = ts - p->ts;
+		ps.dur = ps.pri * (psh->rs->ppb - 1)
+				+ 2 * psh->rs->max_pri_tolerance;
+
+		p2 = p;
+		tmp_false_count = 0;
+		min_valid_ts = ts - ps.dur;
+		/* check which past pulses are candidates for new sequence */
+		list_for_each_entry_continue(p2, pulses, head) {
+			if (p2->ts < min_valid_ts)
+				/* stop on crossing window border */
+				break;
+			if (match_past_pulse_to_sequence(psh, &ps, p2->ts)) {
+				ps.count++;
+				ps.first_ts = p2->ts;
+				/*
+				 * on match, add the intermediate falses
+				 * and reset counter
+				 */
+				ps.count_falses += tmp_false_count;
+				tmp_false_count = 0;
+			} else {
+				/* this is a potentially falso one */
+				tmp_false_count++;
+			}
+		}
+		if (ps.count < min_count)
+			/* did not reach minimum count, drop sequence */
+			continue;
+
+		/* this is a valid one, add it */
+		ps.deadline_ts = ps.first_ts + ps.dur;
+
+		new_ps = seq_pool_get();
+		if (new_ps == NULL)
+			return -1;
+
+		memcpy(new_ps, &ps, sizeof(ps));
+		INIT_LIST_HEAD(&new_ps->head);
+		list_add(&new_ps->head, &psh->sequences);
+		psh->count++;
+	}
+	return 0;
+}
+
+/* check new ts and add to all matching existing sequences */
+static int add_to_existing_sequences(struct pulse_sequence_handler *psh, u64 ts)
+{
+	int max_count = 0;
+	struct pulse_sequence *ps, *ps2;
+	list_for_each_entry_safe(ps, ps2, &psh->sequences, head) {
+		int delta_ts;
+		int factor;
+
+		/* first ensure that sequence is within window */
+		if (ts > ps->deadline_ts) {
+			seq_pool_put(ps);
+			psh->count--;
+			continue;
+		}
+
+		delta_ts = ts - ps->last_ts;
+		factor = get_multiple(delta_ts, ps->pri,
+				      psh->rs->max_pri_tolerance);
+		if (factor > 0) {
+			ps->last_ts = ts;
+			ps->count++;
+
+			if (max_count < ps->count)
+				max_count = ps->count;
+		} else {
+			ps->count_falses++;
+		}
+	}
+	return max_count;
+}
+
+static struct pulse_sequence *
+ps_check_detection(struct pulse_sequence_handler *psh)
+{
+	struct pulse_sequence *ps;
+
+	if (list_empty(&psh->sequences))
+		return NULL;
+
+	list_for_each_entry(ps, &psh->sequences, head) {
+		/*
+		 * we assume to have enough matching confidence if we
+		 * 1) have enough pulses
+		 * 2) have more matching than false pulses
+		 */
+		if ((ps->count >= psh->rs->ppb_thresh) &&
+		    (ps->count * psh->rs->num_pri >= ps->count_falses))
+			return ps;
+	}
+	return NULL;
+}
+
+
+static int ps_add(struct pulse_sequence_handler *psh, u64 ts)
+{
+	int max_updated_seq;
+	struct pulse_sequence *ps;
+
+	max_updated_seq = add_to_existing_sequences(psh, ts);
+
+	if (create_sequences(psh, ts, max_updated_seq) != 0) {
+		pr_err("failed to create pulse sequences\n");
+		psh->reset(psh);
+		return 0;
+	}
+
+	ps = ps_check_detection(psh);
+
+	if (ps != NULL) {
+		int found_pri = ps->pri;
+		pr_debug("XXX radar found: pri=%d, count=%d, count_false=%d\n",
+			 ps->pri, ps->count, ps->count_falses);
+		psh->reset(psh);
+		return found_pri;
+	}
+	psh->pq->enqueue(psh->pq, ts);
+	return 0;
+}
+
+static struct pulse_sequence_handler default_pri_sequence_handler = {
+	.exit = ps_exit,
+	.add  = ps_add,
+	.reset = ps_reset,
+};
+
+struct pulse_sequence_handler *
+pulse_sequence_handler_init(struct radar_detector_specs *rs)
+{
+	struct pulse_sequence_handler *ps = kmalloc(sizeof(*ps), GFP_KERNEL);
+	if (ps == NULL)
+		return NULL;
+
+	*ps = default_pri_sequence_handler;
+	ps->rs = rs;
+	ps->pq = pulse_queue_init(rs->ppb * 2, rs->max_dur);
+	if (ps->pq == NULL) {
+		pr_err("failed to initialize pulse_queue\n");
+		kfree(ps);
+		return NULL;
+	}
+	INIT_LIST_HEAD(&ps->sequences);
+	seq_pool_register();
+	return ps;
+}
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.h b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.h
new file mode 100644
index 0000000..68bf0ff
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/pulse_sequence.h
@@ -0,0 +1,89 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef PULSE_SEQUENCE_H
+#define PULSE_SEQUENCE_H
+
+#include <linux/list.h>
+
+/**
+ * struct pulse_sequence - sequence of pulses matching one PRI
+ * @head: list_head
+ * @pri: pulse repetition interval (PRI) in usecs
+ * @dur: duration of sequence in usecs
+ * @count: number of pulses in this sequence
+ * @count_falses: number of not matching pulses in this sequence
+ * @first_ts: time stamp of first pulse in usecs
+ * @last_ts: time stamp of last pulse in usecs
+ * @deadline_ts: deadline when this sequence becomes invalid (first_ts + dur)
+ */
+struct pulse_sequence {
+	struct list_head head;
+	int pri;
+	int dur;
+	int count;
+	int count_falses;
+	u64 first_ts;
+	u64 last_ts;
+	u64 deadline_ts;
+};
+
+/**
+ * struct pulse_sequence_handler - handle pulse sequences for a radar type
+ * @exit(): destructor
+ * @add(): add new pulse time stamp to pulse sequences, returns 1 on match
+ * @reset(): free all potential sequences
+ * @sequences: list_head holding potential pulse sequences
+ * @count: number of active pulse sequences
+ * @pulse_queue: pulse queue instance for this radar type
+ * @rs: detector specs for this radar type
+ *
+ * A pulse sequence handler handles all sequences for its given radar type.
+ * It uses a pulse list to keep track of past pulses within the window for
+ * that type.
+ *
+ * When a new pulse is added, it is first checked whether it can extend the
+ * existing pulse sequences. Then it is used to form new sequences with any
+ * past pulse that stays within the valid PRI range for its radar type. As
+ * a result, the handler manages a complete set of potential pulse sequences
+ * between any valid pulse combination within its window.
+ *
+ * Managed pulse sequences live either until they trigger a pattern match
+ * or surpass their individual deadline without reaching the detection
+ * criteria.
+ */
+struct pulse_sequence_handler {
+	void (*exit)  (struct pulse_sequence_handler *ps);
+	int  (*add)   (struct pulse_sequence_handler *ps, u64 ts);
+	void (*reset) (struct pulse_sequence_handler *ps);
+
+	/* private data */
+	struct list_head sequences;
+	int count;
+	struct pulse_queue *pq;
+	struct radar_detector_specs *rs;
+};
+
+/**
+ * pulse_sequence_handler_init() - constructor for pulse sequence handler class
+ * @param rs: detector specs for radar type to be used
+ * @return instance pointer on success, NULL otherwise
+ */
+struct pulse_sequence_handler *
+pulse_sequence_handler_init(struct radar_detector_specs *rs);
+
+#endif /* PULSE_SEQUENCE_H */
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/radar_types.c b/drivers/net/wireless/ath/dfs_pattern_detector/radar_types.c
new file mode 100644
index 0000000..52f861b
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/radar_types.c
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include "dfs_pattern_detector.h"
+#include "radar_types.h"
+
+/* radar types as defined by ETSI EN-301-893 v1.5.1 */
+static const struct dfs_radar_spec etsi_radar_ref_types_v15[] = {
+	{ 0,  0,  1,  700,  700, 1, 18, },
+	{ 1,  0,  5,  200, 1000, 1, 10, },
+	{ 2,  0, 15,  200, 1600, 1, 15, },
+	{ 3,  0, 15, 2300, 4000, 1, 25, },
+	{ 4, 20, 30, 2000, 4000, 1, 20, },
+	{ 5,  0,  2,  300,  400, 3, 10, },
+	{ 6,  0,  2,  400, 1200, 3, 15, },
+};
+
+static const struct radar_types etsi_radar_types_v15 = {
+	.domain = DFS_DOMAIN_ETSI,
+	.num_radar_types = ARRAY_SIZE(etsi_radar_ref_types_v15),
+	.radar_types = etsi_radar_ref_types_v15,
+};
+
+/* for now, we support ETSI radar types, FCC and JP are TODO */
+static const struct radar_types *dfs_domains[] = {
+	&etsi_radar_types_v15,
+};
+
+const struct radar_types *get_dfs_domain_radar_types(enum dfs_domain domain)
+{
+	int i;
+	const struct radar_types **rt = dfs_domains;
+	for (i = 0; i < ARRAY_SIZE(dfs_domains); i++, rt++) {
+		if ((*rt)->domain == domain)
+			return *rt;
+	}
+	return NULL;
+}
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/radar_types.h b/drivers/net/wireless/ath/dfs_pattern_detector/radar_types.h
new file mode 100644
index 0000000..10ffbb7
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/radar_types.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef RADAR_TYPES_H
+#define RADAR_TYPES_H
+
+#include "dfs_pattern_detector.h"
+
+/**
+ * struct dfs_radar_spec - radar pattern specification
+ * @type_id: pattern type, as defined by regulatory
+ * @width_min: minimum radar pulse width in [us]
+ * @width_max: maximum radar pulse width in [us]
+ * @prf_min: minimum pulse repetition frequency in [Hz]
+ * @prf_max: minimum prf in [Hz]
+ * @num_prf: maximum number of different prf for this type
+ * @ppb: pulses per bursts for this type
+ *
+ * Specifies the parameters for a radar test pattern as defined
+ * by regulatories.
+ */
+struct dfs_radar_spec {
+	unsigned int type_id;
+	unsigned int width_min;
+	unsigned int width_max;
+	unsigned int prf_min;
+	unsigned int prf_max;
+	unsigned int num_prf;
+	unsigned int ppb;
+};
+
+/**
+ * struct radar_detector_specs - detector specs for a radar pattern type
+ * @type_id: pattern type, as defined by regulatory
+ * @width_min: minimum radar pulse width in [us]
+ * @width_max: maximum radar pulse width in [us]
+ * @pri_min: minimum pulse repetition interval in [us] (including tolerance)
+ * @pri_max: minimum pri in [us] (including tolerance)
+ * @num_pri: maximum number of different pri for this type
+ * @ppb: pulses per bursts for this type
+ * @ppb_thresh: number of pulses required to trigger detection
+ * @max_dur: absolute max duration of pattern: num_pri * pri_max * ppb
+ *
+ * Detector specs for each radar pattern type are calculated at initialization
+ * based on dfs_radar_spec defined by the chosen regulatory.
+ * They remain unchanged thereafter.
+ */
+struct radar_detector_specs {
+	u8 type_id;
+	u8 width_min;
+	u8 width_max;
+	u16 pri_min;
+	u16 pri_max;
+	u8 num_pri;
+	u8 ppb;
+	u8 ppb_thresh;
+	u8 max_pri_tolerance;
+	u32 max_dur;
+};
+
+/**
+ * struct radar_types - contains array of patterns defined for one DFS domain
+ * @domain: DFS regulatory domain
+ * @num_radar_types: number of radar types to follow
+ * @radar_types: radar types array
+ */
+struct radar_types {
+	enum dfs_domain domain;
+	u32 num_radar_types;
+	const struct dfs_radar_spec *radar_types;
+};
+
+/**
+ * get_dfs_domain_radar_types() - get radar types for a given DFS domain
+ * @param domain DFS domain
+ * @return radar_types ptr on success, NULL if DFS domain is not supported
+ */
+extern const struct radar_types *
+get_dfs_domain_radar_types(enum dfs_domain domain);
+
+#endif /* RADAR_TYPES_H */
+
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/utils.c b/drivers/net/wireless/ath/dfs_pattern_detector/utils.c
new file mode 100644
index 0000000..55b389d
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/utils.c
@@ -0,0 +1,45 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "utils.h"
+
+#define DELTA(X, Y) ((X < Y) ? (Y-X) : (X-Y))
+
+unsigned int get_multiple(unsigned int val, unsigned int fraction,
+			  unsigned int tolerance)
+{
+	unsigned int remainder;
+	unsigned int factor;
+
+	if (fraction == 0)
+		return 0;
+
+	if (DELTA(val, fraction) <= tolerance)
+		/* val and fraction are within tolerance */
+		return 1;
+
+	factor = val / fraction;
+	remainder = val % fraction;
+	if (remainder > tolerance) {
+		/* no exact match */
+		if ((fraction - remainder) <= tolerance)
+			/* remainder is within tolerance */
+			factor++;
+		else
+			factor = 0;
+	}
+	return factor;
+}
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector/utils.h b/drivers/net/wireless/ath/dfs_pattern_detector/utils.h
new file mode 100644
index 0000000..dcb7359
--- /dev/null
+++ b/drivers/net/wireless/ath/dfs_pattern_detector/utils.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2012 Neratec Solutions AG
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef UTILS_H
+#define UTILS_H
+
+/**
+ * get_multiple() - get number of multiples considering a given tolerance
+ * @param val: value to check for being multiple of fraction
+ * @param fraction: fraction to check
+ * @param tolerance: maximum tolerance
+ * @return factor if abs(val - factor*fraction) <= tolerance, 0 otherwise
+ */
+unsigned int get_multiple(unsigned int val, unsigned int fraction,
+			  unsigned int tolerance);
+
+#endif /* UTILS_H */
-- 
1.7.4.1

