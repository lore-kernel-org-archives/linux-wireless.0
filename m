Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:47947 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758767Ab2CWPe0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 11:34:26 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [RFCv2 1/3] ath9k: add DFS pattern detector
Date: Fri, 23 Mar 2012 16:34:00 +0100
Message-Id: <1332516842-27522-2-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120323_163435_653056_5B1FCD6E)
In-Reply-To: <1332516842-27522-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1332516842-27522-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a DFS pattern detector to ath9k. It is fed with pulse events
by the radar pulse detector and reports in place whether a pattern
was detected. On detection, the result is reported as radar event to
the DFS management component in the upper layer.

Currently the ETSI DFS domain is supported with detector lines for
the patterns defined by EN-301-893 v1.5.1. Support for FCC and JP
will be added gradually.

To include the pattern detector, ath9k must be built with support
for DFS certified config flag set (CONFIG_ATH9K_DFS_CERTIFIED).

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/Makefile            |    5 +-
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |  300 +++++++++++++++
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |  104 ++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |  390 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h  |   52 +++
 5 files changed, 850 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 27d95fe..3f0b847 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -11,7 +11,10 @@ ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) += dfs_debug.o
-ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
+ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += \
+		dfs.o \
+		dfs_pattern_detector.o \
+		dfs_pri_detector.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
 
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
new file mode 100644
index 0000000..ea2a6cf
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -0,0 +1,300 @@
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
+#include <linux/export.h>
+
+#include "dfs_pattern_detector.h"
+#include "dfs_pri_detector.h"
+
+/*
+ * tolerated deviation of radar time stamp in usecs on both sides
+ * TODO: this might need to be HW-dependent
+ */
+#define PRI_TOLERANCE	16
+
+/**
+ * struct radar_types - contains array of patterns defined for one DFS domain
+ * @domain: DFS regulatory domain
+ * @num_radar_types: number of radar types to follow
+ * @radar_types: radar types array
+ */
+struct radar_types {
+	enum nl80211_dfs_regions region;
+	u32 num_radar_types;
+	const struct radar_detector_specs *radar_types;
+};
+
+/* percentage on ppb threshold to trigger detection */
+#define MIN_PPB_THRESH	50
+#define PPB_THRESH(PPB) ((PPB * MIN_PPB_THRESH + 50) / 100)
+#define PRF2PRI(PRF) ((1000000 + PRF / 2) / PRF)
+
+#define ETSI_PATTERN(ID, WMIN, WMAX, PMIN, PMAX, PRF, PPB)	\
+{								\
+	ID, WMIN, WMAX, (PRF2PRI(PMAX) - PRI_TOLERANCE),	\
+	(PRF2PRI(PMIN) * PRF + PRI_TOLERANCE), PRF, PPB * PRF,	\
+	PPB_THRESH(PPB), PRI_TOLERANCE,				\
+}
+
+/* radar types as defined by ETSI EN-301-893 v1.5.1 */
+static const struct radar_detector_specs etsi_radar_ref_types_v15[] = {
+	ETSI_PATTERN(0,  0,  1,  700,  700, 1, 18),
+	ETSI_PATTERN(1,  0,  5,  200, 1000, 1, 10),
+	ETSI_PATTERN(2,  0, 15,  200, 1600, 1, 15),
+	ETSI_PATTERN(3,  0, 15, 2300, 4000, 1, 25),
+	ETSI_PATTERN(4, 20, 30, 2000, 4000, 1, 20),
+	ETSI_PATTERN(5,  0,  2,  300,  400, 3, 10),
+	ETSI_PATTERN(6,  0,  2,  400, 1200, 3, 15),
+};
+
+static const struct radar_types etsi_radar_types_v15 = {
+	.region			= NL80211_DFS_ETSI,
+	.num_radar_types	= ARRAY_SIZE(etsi_radar_ref_types_v15),
+	.radar_types		= etsi_radar_ref_types_v15,
+};
+
+/* for now, we support ETSI radar types, FCC and JP are TODO */
+static const struct radar_types *dfs_domains[] = {
+	&etsi_radar_types_v15,
+};
+
+/**
+ * get_dfs_domain_radar_types() - get radar types for a given DFS domain
+ * @param domain DFS domain
+ * @return radar_types ptr on success, NULL if DFS domain is not supported
+ */
+static const struct radar_types *
+get_dfs_domain_radar_types(enum nl80211_dfs_regions region)
+{
+	u32 i;
+	for (i = 0; i < ARRAY_SIZE(dfs_domains); i++) {
+		if (dfs_domains[i]->region == region)
+			return dfs_domains[i];
+	}
+	return NULL;
+}
+
+/**
+ * struct channel_detector - detector elements for a DFS channel
+ * @head: list_head
+ * @freq: frequency for this channel detector in MHz
+ * @detectors: array of dynamically created detector elements for this freq
+ *
+ * Channel detectors are required to provide multi-channel DFS detection, e.g.
+ * to support off-channel scanning. A pattern detector has a list of channels
+ * radar pulses have been reported for in the past.
+ */
+struct channel_detector {
+	struct list_head head;
+	u16 freq;
+	struct pri_detector **detectors;
+};
+
+/* channel_detector_reset() - reset detector lines for a given channel */
+static void channel_detector_reset(struct dfs_pattern_detector *dpd,
+				   struct channel_detector *cd)
+{
+	u32 i;
+	if (cd == NULL)
+		return;
+	for (i = 0; i < dpd->num_radar_types; i++)
+		cd->detectors[i]->reset(cd->detectors[i], dpd->last_pulse_ts);
+}
+
+/* channel_detector_exit() - destructor */
+static void channel_detector_exit(struct dfs_pattern_detector *dpd,
+				  struct channel_detector *cd)
+{
+	u32 i;
+	if (cd == NULL)
+		return;
+	list_del(&cd->head);
+	for (i = 0; i < dpd->num_radar_types; i++) {
+		struct pri_detector *de = cd->detectors[i];
+		if (de != NULL)
+			de->exit(de);
+	}
+	kfree(cd->detectors);
+	kfree(cd);
+}
+
+static struct channel_detector *
+channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
+{
+	u32 sz, i;
+	struct channel_detector *cd;
+
+	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
+	if (cd == NULL)
+		goto fail;
+
+	INIT_LIST_HEAD(&cd->head);
+	cd->freq = freq;
+	sz = sizeof(cd->detectors) * dpd->num_radar_types;
+	cd->detectors = kzalloc(sz, GFP_KERNEL);
+	if (cd->detectors == NULL)
+		goto fail;
+
+	for (i = 0; i < dpd->num_radar_types; i++) {
+		const struct radar_detector_specs *rs = &dpd->radar_spec[i];
+		struct pri_detector *de = pri_detector_init(rs);
+		if (de == NULL)
+			goto fail;
+		cd->detectors[i] = de;
+	}
+	list_add(&cd->head, &dpd->channel_detectors);
+	return cd;
+
+fail:
+	pr_err("failed to allocate channel_detector for freq=%d\n", freq);
+	channel_detector_exit(dpd, cd);
+	return NULL;
+}
+
+/**
+ * channel_detector_get() - get channel detector for given frequency
+ * @param dpd instance pointer
+ * @param freq frequency in MHz
+ * @return pointer to channel detector on success, NULL otherwise
+ *
+ * Return existing channel detector for the given frequency or return a
+ * newly create one.
+ */
+static struct channel_detector *
+channel_detector_get(struct dfs_pattern_detector *dpd, u16 freq)
+{
+	struct channel_detector *cd;
+	list_for_each_entry(cd, &dpd->channel_detectors, head) {
+		if (cd->freq == freq)
+			return cd;
+	}
+	return channel_detector_create(dpd, freq);
+}
+
+/*
+ * DFS Pattern Detector
+ */
+
+/* dpd_reset(): reset all channel detectors */
+static void dpd_reset(struct dfs_pattern_detector *dpd)
+{
+	struct channel_detector *cd;
+	if (!list_empty(&dpd->channel_detectors))
+		list_for_each_entry(cd, &dpd->channel_detectors, head)
+			channel_detector_reset(dpd, cd);
+
+}
+static void dpd_exit(struct dfs_pattern_detector *dpd)
+{
+	struct channel_detector *cd, *cd0;
+	if (!list_empty(&dpd->channel_detectors))
+		list_for_each_entry_safe(cd, cd0, &dpd->channel_detectors, head)
+			channel_detector_exit(dpd, cd);
+	kfree(dpd);
+}
+
+static bool
+dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
+{
+	u32 i;
+	bool ts_wraparound;
+	struct channel_detector *cd;
+
+	if (dpd->region == NL80211_DFS_UNSET) {
+		/*
+		 * pulses received for a non-supported or un-initialized
+		 * domain are treated as detected radars
+		 */
+		return true;
+	}
+
+	cd = channel_detector_get(dpd, event->freq);
+	if (cd == NULL)
+		return false;
+
+	ts_wraparound = (event->ts < dpd->last_pulse_ts);
+	dpd->last_pulse_ts = event->ts;
+	if (ts_wraparound) {
+		/*
+		 * reset detector on time stamp wraparound
+		 * with monotonic time stamps, this should never happen
+		 */
+		pr_warn("DFS: time stamp wraparound detected, resetting\n");
+		dpd_reset(dpd);
+	}
+	/* do type individual pattern matching */
+	for (i = 0; i < dpd->num_radar_types; i++) {
+		if (cd->detectors[i]->add_pulse(cd->detectors[i], event) != 0) {
+			channel_detector_reset(dpd, cd);
+			return true;
+		}
+	}
+	return false;
+}
+
+static bool dpd_set_domain(struct dfs_pattern_detector *dpd,
+			   enum nl80211_dfs_regions region)
+{
+	const struct radar_types *rt;
+	struct channel_detector *cd, *cd0;
+
+	if (dpd->region == region)
+		return true;
+
+	dpd->region = NL80211_DFS_UNSET;
+
+	rt = get_dfs_domain_radar_types(region);
+	if (rt == NULL)
+		return false;
+
+	/* delete all channel detectors for previous DFS domain */
+	if (!list_empty(&dpd->channel_detectors))
+		list_for_each_entry_safe(cd, cd0, &dpd->channel_detectors, head)
+			channel_detector_exit(dpd, cd);
+	dpd->radar_spec = rt->radar_types;
+	dpd->num_radar_types = rt->num_radar_types;
+
+	dpd->region = region;
+	return true;
+}
+
+static struct dfs_pattern_detector default_dpd = {
+	.exit		= dpd_exit,
+	.set_domain	= dpd_set_domain,
+	.add_pulse	= dpd_add_pulse,
+	.region		= NL80211_DFS_UNSET,
+};
+
+struct dfs_pattern_detector *
+dfs_pattern_detector_init(enum nl80211_dfs_regions region)
+{
+	struct dfs_pattern_detector *dpd;
+	dpd = kmalloc(sizeof(*dpd), GFP_KERNEL);
+	if (dpd == NULL) {
+		pr_err("allocation of dfs_pattern_detector failed\n");
+		return NULL;
+	}
+	*dpd = default_dpd;
+	INIT_LIST_HEAD(&dpd->channel_detectors);
+
+	if (dpd->set_domain(dpd, region))
+		return dpd;
+
+	pr_err("Could not set DFS domain to %d. ", region);
+	return NULL;
+}
+EXPORT_SYMBOL(dfs_pattern_detector_init);
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
new file mode 100644
index 0000000..fd0328a
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
@@ -0,0 +1,104 @@
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
+#ifndef DFS_PATTERN_DETECTOR_H
+#define DFS_PATTERN_DETECTOR_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/nl80211.h>
+
+/**
+ * struct pulse_event - describing pulses reported by PHY
+ * @ts: pulse time stamp in us
+ * @freq: channel frequency in MHz
+ * @width: pulse duration in us
+ * @rssi: rssi of radar event
+ */
+struct pulse_event {
+	u64 ts;
+	u16 freq;
+	u8 width;
+	u8 rssi;
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
+ * @max_pri_tolerance: pulse time stamp tolerance on both sides [us]
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
+};
+
+/**
+ * struct dfs_pattern_detector - DFS pattern detector
+ * @exit(): destructor
+ * @set_domain(): set DFS domain, resets detector lines upon domain changes
+ * @add_pulse(): add radar pulse to detector, returns true on detection
+ * @region: active DFS region, NL80211_DFS_UNSET until set
+ * @num_radar_types: number of different radar types
+ * @last_pulse_ts: time stamp of last valid pulse in usecs
+ * @radar_detector_specs: array of radar detection specs
+ * @channel_detectors: list connecting channel_detector elements
+ */
+struct dfs_pattern_detector {
+	void (*exit)(struct dfs_pattern_detector *dpd);
+	bool (*set_domain)(struct dfs_pattern_detector *dpd,
+			   enum nl80211_dfs_regions region);
+	bool (*add_pulse)(struct dfs_pattern_detector *dpd,
+			  struct pulse_event *pe);
+
+	enum nl80211_dfs_regions region;
+	u8 num_radar_types;
+	u64 last_pulse_ts;
+
+	const struct radar_detector_specs *radar_spec;
+	struct list_head channel_detectors;
+};
+
+/**
+ * dfs_pattern_detector_init() - constructor for pattern detector class
+ * @param region: DFS domain to be used, can be NL80211_DFS_UNSET at creation
+ * @return instance pointer on success, NULL otherwise
+ */
+#if defined(CONFIG_ATH9K_DFS_CERTIFIED)
+extern struct dfs_pattern_detector *
+dfs_pattern_detector_init(enum nl80211_dfs_regions region);
+#else
+static inline struct dfs_pattern_detector *
+dfs_pattern_detector_init(enum nl80211_dfs_regions region)
+{
+	return NULL;
+}
+#endif /* CONFIG_ATH9K_DFS_CERTIFIED */
+
+#endif /* DFS_PATTERN_DETECTOR_H */
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
new file mode 100644
index 0000000..edc47e8
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
@@ -0,0 +1,390 @@
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
+#include "dfs_pattern_detector.h"
+#include "dfs_pri_detector.h"
+
+/**
+ * struct pri_sequence - sequence of pulses matching one PRI
+ * @head: list_head
+ * @pri: pulse repetition interval (PRI) in usecs
+ * @dur: duration of sequence in usecs
+ * @count: number of pulses in this sequence
+ * @count_falses: number of not matching pulses in this sequence
+ * @first_ts: time stamp of first pulse in usecs
+ * @last_ts: time stamp of last pulse in usecs
+ * @deadline_ts: deadline when this sequence becomes invalid (first_ts + dur)
+ */
+struct pri_sequence {
+	struct list_head head;
+	u32 pri;
+	u32 dur;
+	u32 count;
+	u32 count_falses;
+	u64 first_ts;
+	u64 last_ts;
+	u64 deadline_ts;
+};
+
+/**
+ * struct pulse_elem - elements in pulse queue
+ * @ts: time stamp in usecs
+ */
+struct pulse_elem {
+	struct list_head head;
+	u64 ts;
+};
+
+/**
+ * pde_get_multiple() - get number of multiples considering a given tolerance
+ * @return factor if abs(val - factor*fraction) <= tolerance, 0 otherwise
+ */
+static unsigned int pde_get_multiple(u32 val, u32 fraction, u32 tolerance)
+{
+	u32 remainder;
+	u32 factor;
+	u32 delta;
+
+	if (fraction == 0)
+		return 0;
+
+	delta = (val < fraction) ? (fraction - val) : (val - fraction);
+
+	if (delta <= tolerance)
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
+
+/**
+ * DOC: Singleton Pulse and Sequence Pools
+ *
+ * Instances of pri_sequence and pulse_elem are kept in singleton pools to
+ * reduce the number of dynamic allocations. They are shared between all
+ * instances and grow up to the peak number of simultaneously used objects.
+ *
+ * Memory is freed after all references to the pools are released.
+ */
+static int singleton_pool_references;
+static LIST_HEAD(pulse_pool);
+static LIST_HEAD(pseq_pool);
+
+static struct pulse_elem *pulse_queue_get_tail(struct pri_detector *pde)
+{
+	struct list_head *l = &pde->pulses;
+	if (list_empty(l))
+		return NULL;
+	return list_entry(l->prev, struct pulse_elem, head);
+}
+
+static bool pulse_queue_dequeue(struct pri_detector *pde)
+{
+	struct pulse_elem *p = pulse_queue_get_tail(pde);
+	if (p != NULL) {
+		list_del_init(&p->head);
+		pde->count--;
+		/* give it back to pool */
+		list_add(&p->head, &pulse_pool);
+	}
+	return (pde->count > 0);
+}
+
+/* remove pulses older than window */
+static void pulse_queue_check_window(struct pri_detector *pde)
+{
+	u64 min_valid_ts;
+	struct pulse_elem *p;
+
+	/* there is no delta time with less than 2 pulses */
+	if (pde->count < 2)
+		return;
+
+	if (pde->last_ts <= pde->window_size)
+		return;
+
+	min_valid_ts = pde->last_ts - pde->window_size;
+	while ((p = pulse_queue_get_tail(pde)) != NULL) {
+		if (p->ts >= min_valid_ts)
+			return;
+		pulse_queue_dequeue(pde);
+	}
+}
+
+static bool pulse_queue_enqueue(struct pri_detector *pde, u64 ts)
+{
+	struct pulse_elem *p;
+	if (!list_empty(&pulse_pool)) {
+		p = list_first_entry(&pulse_pool, struct pulse_elem, head);
+		list_del(&p->head);
+	} else {
+		p = kmalloc(sizeof(*p), GFP_KERNEL);
+		if (p == NULL) {
+			pr_err("failed to allocate pulse_elem\n");
+			return false;
+		}
+	}
+	INIT_LIST_HEAD(&p->head);
+	p->ts = ts;
+	list_add(&p->head, &pde->pulses);
+	pde->count++;
+	pde->last_ts = ts;
+	pulse_queue_check_window(pde);
+	if (pde->count >= pde->max_count)
+		pulse_queue_dequeue(pde);
+	return true;
+}
+
+static bool pseq_handler_create_sequences(struct pri_detector *pde,
+					  u64 ts, u32 min_count)
+{
+	struct pulse_elem *p;
+	list_for_each_entry(p, &pde->pulses, head) {
+		struct pri_sequence ps, *new_ps;
+		struct pulse_elem *p2;
+		int tmp_false_count;
+		u64 min_valid_ts;
+		u32 delta_ts = ts - p->ts;
+
+		if (delta_ts < pde->rs->pri_min)
+			/* ignore too small pri */
+			continue;
+
+		if (delta_ts > pde->rs->pri_max)
+			/* stop on too large pri (sorted list) */
+			break;
+
+		/* build a new sequence with new potential pri */
+		ps.count = 2;
+		ps.count_falses = 0;
+		ps.first_ts = p->ts;
+		ps.last_ts = ts;
+		ps.pri = ts - p->ts;
+		ps.dur = ps.pri * (pde->rs->ppb - 1)
+				+ 2 * pde->rs->max_pri_tolerance;
+
+		p2 = p;
+		tmp_false_count = 0;
+		min_valid_ts = ts - ps.dur;
+		/* check which past pulses are candidates for new sequence */
+		list_for_each_entry_continue(p2, &pde->pulses, head) {
+			u32 factor;
+			if (p2->ts < min_valid_ts)
+				/* stop on crossing window border */
+				break;
+			/* check if pulse match (multi)PRI */
+			factor = pde_get_multiple(ps.last_ts - p2->ts, ps.pri,
+						  pde->rs->max_pri_tolerance);
+			if (factor > 0) {
+				ps.count++;
+				ps.first_ts = p2->ts;
+				/*
+				 * on match, add the intermediate falses
+				 * and reset counter
+				 */
+				ps.count_falses += tmp_false_count;
+				tmp_false_count = 0;
+			} else {
+				/* this is a potentially false one */
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
+		if (!list_empty(&pseq_pool)) {
+			new_ps = list_first_entry(&pseq_pool,
+						  struct pri_sequence, head);
+			list_del(&new_ps->head);
+		} else {
+			new_ps = kmalloc(sizeof(*new_ps), GFP_KERNEL);
+			if (new_ps == NULL)
+				return false;
+		}
+		memcpy(new_ps, &ps, sizeof(ps));
+		INIT_LIST_HEAD(&new_ps->head);
+		list_add(&new_ps->head, &pde->sequences);
+	}
+	return true;
+}
+
+/* check new ts and add to all matching existing sequences */
+static u32
+pseq_handler_add_to_existing_seqs(struct pri_detector *pde, u64 ts)
+{
+	u32 max_count = 0;
+	struct pri_sequence *ps, *ps2;
+	list_for_each_entry_safe(ps, ps2, &pde->sequences, head) {
+		int delta_ts;
+		int factor;
+
+		/* first ensure that sequence is within window */
+		if (ts > ps->deadline_ts) {
+			list_del_init(&ps->head);
+			list_add(&ps->head, &pseq_pool);
+			continue;
+		}
+
+		delta_ts = ts - ps->last_ts;
+		factor = pde_get_multiple(delta_ts, ps->pri,
+					  pde->rs->max_pri_tolerance);
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
+static struct pri_sequence *
+pseq_handler_check_detection(struct pri_detector *pde)
+{
+	struct pri_sequence *ps;
+
+	if (list_empty(&pde->sequences))
+		return NULL;
+
+	list_for_each_entry(ps, &pde->sequences, head) {
+		/*
+		 * we assume to have enough matching confidence if we
+		 * 1) have enough pulses
+		 * 2) have more matching than false pulses
+		 */
+		if ((ps->count >= pde->rs->ppb_thresh) &&
+		    (ps->count * pde->rs->num_pri >= ps->count_falses))
+			return ps;
+	}
+	return NULL;
+}
+
+
+/* free pulse queue and sequences list and give objects back to pools */
+static void pri_detector_reset(struct pri_detector *pde, u64 ts)
+{
+	struct pri_sequence *ps, *ps0;
+	struct pulse_elem *p, *p0;
+	list_for_each_entry_safe(ps, ps0, &pde->sequences, head) {
+		list_del_init(&ps->head);
+		list_add(&ps->head, &pseq_pool);
+	}
+	list_for_each_entry_safe(p, p0, &pde->pulses, head) {
+		list_del_init(&p->head);
+		list_add(&p->head, &pulse_pool);
+	}
+	pde->count = 0;
+	pde->last_ts = ts;
+}
+
+static void pri_detector_exit(struct pri_detector *de)
+{
+	pri_detector_reset(de, 0);
+
+	singleton_pool_references--;
+	if (singleton_pool_references == 0) {
+		/* free singleton pools with no references left */
+		struct pri_sequence *ps, *ps0;
+		struct pulse_elem *p, *p0;
+
+		list_for_each_entry_safe(p, p0, &pulse_pool, head) {
+			list_del(&p->head);
+			kfree(p);
+		}
+		list_for_each_entry_safe(ps, ps0, &pseq_pool, head) {
+			list_del(&ps->head);
+			kfree(ps);
+		}
+	}
+	kfree(de);
+}
+
+static bool pri_detector_add_pulse(struct pri_detector *de,
+				   struct pulse_event *event)
+{
+	u32 max_updated_seq;
+	struct pri_sequence *ps;
+	u64 ts = event->ts;
+	const struct radar_detector_specs *rs = de->rs;
+
+	/* ignore pulses not within width range */
+	if ((rs->width_min > event->width) || (rs->width_max < event->width))
+		return false;
+
+	if ((ts - de->last_ts) < rs->max_pri_tolerance)
+		/* if delta to last pulse is too short, don't use this pulse */
+		return false;
+	de->last_ts = ts;
+
+	max_updated_seq = pseq_handler_add_to_existing_seqs(de, ts);
+
+	if (!pseq_handler_create_sequences(de, ts, max_updated_seq)) {
+		pr_err("failed to create pulse sequences\n");
+		pri_detector_reset(de, ts);
+		return false;
+	}
+
+	ps = pseq_handler_check_detection(de);
+
+	if (ps != NULL) {
+		pr_info("DFS: radar found: pri=%d, count=%d, count_false=%d\n",
+			 ps->pri, ps->count, ps->count_falses);
+		pri_detector_reset(de, ts);
+		return true;
+	}
+	pulse_queue_enqueue(de, ts);
+	return false;
+}
+
+struct pri_detector *
+pri_detector_init(const struct radar_detector_specs *rs)
+{
+	struct pri_detector *de;
+	de = kzalloc(sizeof(*de), GFP_KERNEL);
+	if (de == NULL)
+		return NULL;
+	de->exit = pri_detector_exit;
+	de->add_pulse = pri_detector_add_pulse;
+	de->reset = pri_detector_reset;
+
+	INIT_LIST_HEAD(&de->sequences);
+	INIT_LIST_HEAD(&de->pulses);
+	de->window_size = rs->pri_max * rs->ppb * rs->num_pri;
+	de->max_count = rs->ppb * 2;
+	de->rs = rs;
+
+	singleton_pool_references++;
+	return de;
+}
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
new file mode 100644
index 0000000..81cde9f
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
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
+#ifndef DFS_PRI_DETECTOR_H
+#define DFS_PRI_DETECTOR_H
+
+#include <linux/list.h>
+
+/**
+ * struct pri_detector - PRI detector element for a dedicated radar type
+ * @exit(): destructor
+ * @add_pulse(): add pulse event, returns true if pattern was detected
+ * @reset(): clear states and reset to given time stamp
+ * @rs: detector specs for this detector element
+ * @last_ts: last pulse time stamp considered for this element in usecs
+ * @sequences: list_head holding potential pulse sequences
+ * @pulses: list connecting pulse_elem objects
+ * @count: number of pulses in queue
+ * @max_count: maximum number of pulses to be queued
+ * @window_size: window size back from newest pulse time stamp in usecs
+ */
+struct pri_detector {
+	void (*exit)     (struct pri_detector *de);
+	bool (*add_pulse)(struct pri_detector *de, struct pulse_event *e);
+	void (*reset)    (struct pri_detector *de, u64 ts);
+
+/* private: internal use only */
+	const struct radar_detector_specs *rs;
+	u64 last_ts;
+	struct list_head sequences;
+	struct list_head pulses;
+	u32 count;
+	u32 max_count;
+	u32 window_size;
+};
+
+struct pri_detector *pri_detector_init(const struct radar_detector_specs *rs);
+
+#endif /* DFS_PRI_DETECTOR_H */
-- 
1.7.4.1

