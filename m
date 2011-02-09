Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41802 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab1BIMCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:02:08 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id 6A21B664001
	for <linux-wireless@vger.kernel.org>; Wed,  9 Feb 2011 13:02:06 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 1/3] hostapd: simple pattern detector
Date: Wed,  9 Feb 2011 13:01:43 +0100
Message-Id: <1297252905-29739-4-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provides a very basic pattern detector to test the proposed design.

Implements detection for ETSI 1.5.1 single PRI radar test signals. It is
usable only for off-channel-scans, i.e. does not tolerate false pulses.
---
 src/dfs/Makefile               |    8 +
 src/dfs/dfs.h                  |   83 ++++++
 src/dfs/dfs_debug.c            |   15 +
 src/dfs/dfs_debug.h            |  110 ++++++++
 src/dfs/dfs_handler.c          |  109 ++++++++
 src/dfs/dfs_pattern_detector.c |  568 ++++++++++++++++++++++++++++++++++++++++
 src/dfs/dfs_pattern_detector.h |   46 ++++
 src/dfs/dfs_radar_types.h      |   48 ++++
 8 files changed, 987 insertions(+), 0 deletions(-)
 create mode 100644 src/dfs/Makefile
 create mode 100644 src/dfs/dfs.h
 create mode 100644 src/dfs/dfs_debug.c
 create mode 100644 src/dfs/dfs_debug.h
 create mode 100644 src/dfs/dfs_handler.c
 create mode 100644 src/dfs/dfs_pattern_detector.c
 create mode 100644 src/dfs/dfs_pattern_detector.h
 create mode 100644 src/dfs/dfs_radar_types.h

diff --git a/src/dfs/Makefile b/src/dfs/Makefile
new file mode 100644
index 0000000..9c41962
--- /dev/null
+++ b/src/dfs/Makefile
@@ -0,0 +1,8 @@
+all:
+	@echo Nothing to be made.
+
+clean:
+	rm -f *~ *.o *.d
+
+install:
+	@echo Nothing to be made.
diff --git a/src/dfs/dfs.h b/src/dfs/dfs.h
new file mode 100644
index 0000000..4ca71ec
--- /dev/null
+++ b/src/dfs/dfs.h
@@ -0,0 +1,83 @@
+#ifndef DFS_H
+#define DFS_H
+/*
+ * Copyright 2011, Neratec Solutions AG, <zefir.kurtisi@neratec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/**
+ * DOC: Introduction
+ *
+ * DFS radar detector interface
+ *
+ * This is a proposal for a common DFS pattern detector interface.
+ *
+ * It should be used by devices that are able to detect radar pulses and need
+ * pattern matching (as defined by ETSI, FCC, JP regulatories).
+ *
+ */
+
+#include <stdint.h>
+
+/* TODO: move those to more common place */
+enum dfs_domain {
+	DFS_FCC_DOMAIN		= 1,	/* FCC dfs domain */
+	DFS_ETSI_DOMAIN		= 2,	/* ETSI dfs domain */
+	DFS_JP_DOMAIN		= 3,	/* Japan dfs domain */
+};
+
+/**
+ * struct pulse_event - events fed to the dfs handler
+ *
+ * @ts: absolute time stamp for start of pulse in [us] (e.g. as TSF)
+ * @freq: channel frequency in [MHz]
+ * @width: pulse width in [us]
+ *
+ */
+struct pulse_event {
+	uint64_t ts;
+	uint16_t freq;
+	uint8_t  width;
+};
+
+
+/**
+ * struct dfs_handler - DFS handler pseudo-OO interface
+ *
+ * @exit: terminate DFS handler and release all resources
+ * @add_pulse: add given pulse event to detector lines
+ *             returns 1 if added event triggered a pattern match
+ * @data: private instance data
+ *
+ */
+struct dfs_handler {
+	/* VFT */
+	void (*exit)(struct dfs_handler *_this);
+	int (*add_pulse)(struct dfs_handler *_this, struct pulse_event *event);
+
+	/* private data */
+	struct dfs_data *data;
+};
+
+/**
+ * dfs_handler_init - DFS handler constructor
+ *
+ * @dfs_domain: DFS domain to detect radar patterns for
+ *
+ * A DFS handler instance is allocated via this constructor.
+ * On success the pointer to the fully initialized handler is returned that
+ * can be fed with radar pulses during its lifetime. Allocated resources are
+ * released upon calling the destructor.
+ *
+ * On failure NULL is returned.
+ */
+struct dfs_handler *dfs_handler_init(enum dfs_domain dfs_domain);
+
+/* only one global DFS handler instance enough for proof-of-concept */
+extern struct dfs_handler *global_dfs_handler;
+
+
+#endif  /* DFS_H */
diff --git a/src/dfs/dfs_debug.c b/src/dfs/dfs_debug.c
new file mode 100644
index 0000000..2cce48f
--- /dev/null
+++ b/src/dfs/dfs_debug.c
@@ -0,0 +1,15 @@
+#include "dfs_debug.h"
+
+#define USE_FULL_DEBUG	0
+
+uint32_t dfs_debug_level = 0
+	| DFS_DEBUG_ERROR
+	| DFS_DEBUG_WARN
+	| DFS_DEBUG_INFO
+#if USE_FULL_DEBUG
+	| DFS_DEBUG_TRACE
+	| DFS_DEBUG_LOG
+#endif
+;
+
+char dbg_buff[MAX_DEBUG_SPRINTF + 1] = {0};
diff --git a/src/dfs/dfs_debug.h b/src/dfs/dfs_debug.h
new file mode 100644
index 0000000..06f8f22
--- /dev/null
+++ b/src/dfs/dfs_debug.h
@@ -0,0 +1,110 @@
+#ifndef DFS_DEBUG_H
+#define DFS_DEBUG_H
+
+#include <stdint.h>
+
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+
+#define DFS_DPRINTK(LEVEL, FMT, ...) \
+do { \
+	if ((LEVEL) & dfs_debug_level)	\
+		printk(FMT, ##__VA_ARGS__); \
+} while (0)
+
+#define ASSERT(expr) \
+if (unlikely(!(expr))) { \
+	panic(KERN_ERR "Assertion failed! %s,%s,%s,line=%d\n", \
+	#expr, __SHORT_FILE__, __func__, __LINE__); \
+}
+#else
+#include <string.h>
+#include <stdio.h>
+
+#define DFS_DPRINTK(LEVEL, FMT, ...) \
+do { \
+	if ((LEVEL) & dfs_debug_level)	\
+		printf(FMT, ##__VA_ARGS__);  \
+} while (0)
+
+#define ASSERT(expr) \
+do { \
+	if (!(expr)) { \
+		printf("Assertion failed! %s,%s,%s,line=%d\n", \
+		#expr, __SHORT_FILE__, __func__, __LINE__); \
+	} \
+} while (0)
+
+#endif
+
+enum {
+	DFS_DEBUG_ERROR	= 0x000100,
+	DFS_DEBUG_WARN	= 0x000200,
+	DFS_DEBUG_INFO	= 0x000400,
+	DFS_DEBUG_TRACE	= 0x000800,
+	DFS_DEBUG_LOG	= 0x001000,
+};
+
+extern uint32_t dfs_debug_level;
+#define MAX_DEBUG_SPRINTF 511
+extern char dbg_buff[MAX_DEBUG_SPRINTF + 1];
+
+#define __SHORT_FILE__ \
+	(strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
+
+
+
+#define DTRACE(...) \
+do { \
+	DFS_DPRINTK(DFS_DEBUG_TRACE, "TRACE: %s\n", __func__); \
+} while (0)
+
+#define DLOG(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, "LOG: %s\n", FMT); \
+	DFS_DPRINTK(DFS_DEBUG_LOG, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DINFO(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, "INFO: %s\n", FMT); \
+	DFS_DPRINTK(DFS_DEBUG_INFO, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DWARN(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"WARN: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_WARN, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DERROR(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"WARN: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_ERROR, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DFATAL(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"FATAL: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_ERROR, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+
+#define DINIT(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, \
+			"INIT: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_ERROR, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+#define DINFO_OK(FMT, ...) \
+do { \
+	snprintf(dbg_buff, MAX_DEBUG_SPRINTF, "OK: %s: %s\n", __func__, FMT); \
+	DFS_DPRINTK(DFS_DEBUG_INFO, dbg_buff, ##__VA_ARGS__); \
+} while (0)
+
+
+#endif /* DFS_DEBUG_H */
diff --git a/src/dfs/dfs_handler.c b/src/dfs/dfs_handler.c
new file mode 100644
index 0000000..a13d45c
--- /dev/null
+++ b/src/dfs/dfs_handler.c
@@ -0,0 +1,109 @@
+/*
+ * Copyright 2011, Neratec Solutions AG, <zefir.kurtisi@neratec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdlib.h>
+
+#include "dfs.h"
+#include "dfs_debug.h"
+#include "dfs_pattern_detector.h"
+
+
+/**
+ * struct dfs_data - DFS handler private data
+ *
+ * @dfs_handler: instance back-reference
+ * @dfs_domain: DFS domain the handler is currently working
+ * @pattern_detector: instance reference to pattern detector
+ */
+struct dfs_data {
+	struct dfs_handler *dfs_handler;
+	enum dfs_domain dfs_domain;
+	struct dfs_pattern_detector *pattern_detector;
+};
+
+
+
+/* Destructor */
+static void dh_exit(struct dfs_handler *_this)
+{
+	ASSERT(_this != NULL);
+
+	if (_this->data != NULL) {
+		struct dfs_data *dfs_data = _this->data;
+		if (dfs_data->pattern_detector != NULL)
+			dfs_data->pattern_detector->
+				exit(dfs_data->pattern_detector);
+		free(dfs_data);
+		_this->data = NULL;
+	}
+	free(_this);
+}
+
+static int dh_add_pulse(struct dfs_handler *_this, struct pulse_event *event)
+{
+	int detector_result;
+	struct dfs_data *dfs_data;
+	DTRACE();
+	ASSERT((_this != NULL) && (_this->data != NULL));
+
+	dfs_data = _this->data;
+	detector_result = dfs_data->pattern_detector->
+			add_pulse(dfs_data->pattern_detector, event);
+	if (detector_result == RADAR_DETECTED) {
+		DINIT("found radar");
+		return 1;
+	}
+	return 0;
+}
+
+static struct dfs_handler default_dfs_handler = {
+	.exit		= dh_exit,
+	.add_pulse	= dh_add_pulse,
+};
+
+/* Constructor */
+struct dfs_handler *dfs_handler_init(enum dfs_domain dfs_domain)
+{
+	struct dfs_handler *_this;
+	struct dfs_data *dfs_data;
+	int sz = sizeof(struct dfs_handler);
+	_this = malloc(sz);
+
+	if (_this == NULL) {
+		DFATAL("dfs_handler allocation failed");
+		return NULL;
+	}
+
+	*_this = default_dfs_handler;
+
+
+	sz = sizeof(struct dfs_data);
+	dfs_data = malloc(sz);
+	if (dfs_data == NULL) {
+		DFATAL("dfs_data allocation failed");
+		goto failed;
+	}
+
+	memset(dfs_data, 0, sz);
+
+	_this->data = dfs_data;
+	dfs_data->pattern_detector = dfs_pattern_detector_init(dfs_domain);
+	if (dfs_data->pattern_detector == NULL) {
+		DFATAL("detector_init() failed!");
+		goto failed;
+	}
+	_this->data->dfs_domain = dfs_domain;
+	_this->data->dfs_handler = _this;
+
+	DINIT("ok");
+	return _this;
+
+failed:
+	_this->exit(_this);
+	return NULL;
+}
diff --git a/src/dfs/dfs_pattern_detector.c b/src/dfs/dfs_pattern_detector.c
new file mode 100644
index 0000000..d240796
--- /dev/null
+++ b/src/dfs/dfs_pattern_detector.c
@@ -0,0 +1,568 @@
+/*
+ * Copyright 2011, Neratec Solutions AG, <zefir.kurtisi@neratec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdlib.h>
+
+#include "dfs_pattern_detector.h"
+#include "dfs_debug.h"
+#include "dfs.h"
+
+#include "dfs_radar_types.h"
+
+
+/*
+ * Abbreviations used (based on regulatory specs):
+ *  * prf: pulse repetition frequency [Hz]
+ *  * pri: pulse repetition interval = 1/prf, here used as [us]
+ *  * ppb: pulses per burst
+ */
+
+
+#define DELTA(X, Y) ((X < Y) ? (Y-X) : (X-Y))
+
+/* number of deviation of radar time in usecs tolerated on both sides
+ * TODO: this might need to be HW-dependent
+ */
+#define MAX_PRI_TOLERANCE	10
+
+
+/**
+ * struct radar_specs - specifies a radar pattern type
+ *
+ * @type_id: pattern type, as defined by ETSI / FCC
+ * @width_min: minimum radar pulse width in [us]
+ * @width_max: maximum radar pulse width in [us]
+ * @pri_min: minimum pulse repetition interval in [us] (including tolerance)
+ * @pri_max: minimum pri in [us] (including tolerance)
+ * @num_pri: maximum number of different pri for this type
+ * @ppb: pulses per bursts for this type
+ * @ppb_thresh: number of pulses required to trigger detection
+ * @max_dur: absolute max duration of pattern: num_pri * pri_max * ppb
+ *
+ * Characteristics of each radar pattern type are calculated at initialization
+ * based on radar test signal types defined by the chosen regulatory.
+ * They remain unchanged thereafter.
+ */
+struct radar_specs {
+	unsigned int type_id;
+	unsigned int width_min;
+	unsigned int width_max;
+	unsigned int pri_min;
+	unsigned int pri_max;
+	unsigned int num_pri;
+	unsigned int ppb;
+	unsigned int ppb_thresh;
+	unsigned int max_dur;
+};
+
+
+/* so far, maximum prf number is 3 for ETSI types 5 and 6 */
+#define MAX_PRF_NUM 3
+
+/**
+ * struct radar_stats - detector statistics updated on each pulse
+ *
+ * @pri_count: number of pri used for this pattern type so far
+ * @pri: array of pris in use
+ * @matching_pulse_count: number of pulses detected correctly so far
+ * @missed_pulse_count: number of pulses assumed as lost so far
+ * @false_pulse_count: number of invalid / false pulses so far
+ * @first_ts: timestamp of first valid pulse for this type
+ * @last_ts: timestamp of last valid pulse for this type
+ *
+ * The statistics reflect the current state of the related detector line.
+ *
+ * Detection is performed in place updating the affected detector lines
+ * whenever a pulse is added. The algorithm operates without keeping track
+ * of the pulse history but requires only the statistics collected so far.
+ *
+ * Statistical decisions are made based on the numbers for matching,
+ * missed, and false pulses count.
+ */
+struct radar_stats {
+	uint32_t pri_count;
+	uint32_t pri[MAX_PRF_NUM];
+	uint32_t matching_pulse_count;
+	uint32_t missed_pulse_count;
+	uint32_t false_pulse_count;
+	uint64_t first_ts;
+	uint64_t last_ts;
+};
+
+/**
+ * struct dfs_channels - DFS channels' frequencies, assumed constant
+ */
+static const uint16_t dfs_channels[] = {
+	5260, 5280, 5300, 5320,
+	5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640, 5660, 5680, 5700,
+};
+#define NUM_DFS_CHANNELS (sizeof(dfs_channels)/sizeof(dfs_channels[0]))
+
+
+/**
+ * struct detector_line - detector line for one specific dfs pattern type
+ *
+ * @specs: dfs pattern type specification
+ * @stats: array of statistics for for all DFS channels
+ *
+ * Each detector line consists of a constant radar type specification and
+ * an array of statistics for all DFS channels.
+ */
+struct detector_line {
+	struct radar_specs specs;
+	struct radar_stats stats[NUM_DFS_CHANNELS];
+};
+
+
+/**
+ * struct pattern_detector_data - private instance data
+ *
+ * @num_detector_elements: number of different radar types
+ * @radar_detectors: array of num_detector_elements detector lines
+ * @min_valid_width: combined min of valid pulse widths
+ * @max_valid_width: combined max of valid pulse widths
+ * @min_valid_pri: combined min of valid pris
+ * @max_valid_pri: combined max of valid pris
+ * @max_radar_dur: combined max duration of radar patterns
+ * @first_pulse_ts: timestamp of first pulse after detector reset
+ * @last_pulse_ts: timestamp of last valid pulse
+ * @last_pulse_rssi: rssi of last pulse
+ *
+ * For global range checking dfs_pattern_detector instances are initialized
+ * with a pre-calculated set of global limits that combine the limits of
+ * all detector lines.
+ */
+struct pattern_detector_data {
+	uint32_t num_detector_elements;
+	struct detector_line *radar_detectors;
+	uint32_t min_valid_width;
+	uint32_t max_valid_width;
+	uint32_t min_valid_pri;
+	uint32_t max_valid_pri;
+	uint32_t max_radar_dur;
+	uint64_t first_pulse_ts;
+	uint64_t last_pulse_ts;
+	uint32_t last_pulse_rssi;
+};
+
+/**
+ * get_dfs_channel_idx - (private) find DFS channel index for given frequency
+ *
+ * @freq: frequency to search for
+ *
+ * Returns -1 if not found.
+ */
+static int get_dfs_channel_idx(uint16_t freq)
+{
+	int i;
+	for (i = 0; i < NUM_DFS_CHANNELS; i++)
+		if (dfs_channels[i] == freq)
+			return i;
+	return -1;
+}
+
+/**
+ * reset_detector_element - (private) reset one detector element
+ *
+ * @rs: radar statistics to reset
+ * @ts: time stamp to be reset to
+ *
+ * Resets the statistics for one pattern type of one channel. Sets the
+ * timestamp for the last valid pulse to given value.
+ */
+static void reset_detector_element(struct radar_stats *rs, uint64_t ts)
+{
+	memset(rs, 0, sizeof(struct radar_stats));
+	rs->last_ts = ts;
+}
+
+
+/**
+ * detector_reset - (private) reset all detector lines for a given channel
+ *
+ * @pd_data: instance data ptr
+ * @dfs_channel_idx: DFS channel index to be reset
+ *
+ * Resets the statistics for all pattern types of one given channel.
+ */
+static void detector_reset(struct pattern_detector_data *pd_data,
+		int dfs_channel_idx)
+{
+	int i;
+	uint64_t ts = pd_data->last_pulse_ts;
+	DTRACE();
+	for (i = 0; i < pd_data->num_detector_elements; i++) {
+		struct radar_stats *rs;
+		rs = &pd_data->radar_detectors[i].stats[dfs_channel_idx];
+		reset_detector_element(rs, ts);
+	}
+}
+
+
+/**
+ * check_pulse_lost - (private) check potentially lost pulses
+ *
+ * @rs: radar stats to be checked
+ * @delta_ts: pulse interval to be checked
+ *
+ * In case we missed some pulse '.' in a row of valid pulses '|', we try to
+ * reconstruct them by checking for delta_ts being a multiple of the pri.
+ *
+ * Assume we were fed with a pattern like
+ *    |    |    .    .    |
+ * Evaluating the last pulse we check if the last interval is a multiple of our
+ * pri and in that case return 2 as the number of (potentially) lost pulses.
+ *
+ * The global check if the last interval exceeds the max duration of this
+ * pattern type is performed by the caller.
+ *
+ */
+static int check_pulse_lost(struct radar_stats *rs, uint32_t delta_ts)
+{
+	int lost_pulses = 0;
+
+	if (rs->pri_count == 1) {
+		/* check constant pri patterns */
+		uint32_t pri = rs->pri[0];
+		while (delta_ts > pri) {
+			/* we already checked that we are within valid duration
+			 * => won't loop too long */
+			lost_pulses++;
+			delta_ts -= pri;
+		}
+
+		if (DELTA(pri, delta_ts) <= MAX_PRI_TOLERANCE)
+			return lost_pulses;
+
+		return 0;
+	} else {
+		/* TODO: check staggered radar patterns
+			 here we need to support
+			 * single burst / packet based and
+			 * single burst / single pulse
+			 staggered PRF radar test signals
+		 */
+	}
+	return 0;
+}
+
+/**
+ * detector_check_match - (private) check for pattern match
+ *
+ * @rp: radar specs to be checked
+ * @rs: radar stats to be checked
+ * @delta_ts: pulse interval to be checked
+ *
+ * Returns 1 on match
+ */
+static int detector_check_match(struct radar_specs *rp, struct radar_stats *rs)
+{
+
+	if (rs->matching_pulse_count >= rp->ppb_thresh) {
+		DINIT("XXXXXXXXXXXXXXXXXXXXXXX MATCH on type %d", rp->type_id);
+		return 1;
+	}
+	return 0;
+}
+
+static int detector_check_pri(struct radar_specs *rp, struct radar_stats *rs,
+		uint32_t delta_ts)
+{
+	int lost_pulses;
+
+	int pri_num;
+	DLOG("OK: delta_ts=%d <= max_dur[%d]=%d",
+			delta_ts, rp->type_id, rp->max_dur);
+	for (pri_num = 0; pri_num < rs->pri_count; pri_num++) {
+		if (DELTA(delta_ts, rs->pri[pri_num]) < MAX_PRI_TOLERANCE) {
+			rs->matching_pulse_count++;
+			DLOG("delta_ts=%d matches pri_num[%d][%d] => "
+				"matching_pulse_count = %d", delta_ts,
+				rp->type_id, pri_num, rs->matching_pulse_count);
+			if (detector_check_match(rp, rs))
+				return 1;
+			/* we only take the first match */
+			return 0;
+		}
+		lost_pulses = check_pulse_lost(rs, delta_ts);
+		if (lost_pulses > 0) {
+			rs->matching_pulse_count += lost_pulses + 1;
+			DLOG("[%d] assuming %d lost pulses => "
+					"matching_pulse_count = %d",
+					rp->type_id, lost_pulses,
+					rs->matching_pulse_count);
+			if (detector_check_match(rp, rs))
+				return 1;
+			return 0;
+		}
+		DLOG("delta_ts=%d not multiple of [%d] = %d",
+				delta_ts, rp->type_id, rs->pri[0]);
+		reset_detector_element(rs, rs->last_ts);
+		return 0;
+
+	}
+	if (rs->pri_count >= rp->num_pri) {
+		rs->false_pulse_count++;
+	} else {
+		/* pri was not found in the current array, add it as new */
+		rs->pri[rs->pri_count++] = delta_ts;
+		rs->matching_pulse_count += 2;
+		DLOG("added new pri[%d][%d]=%d",
+				rp->type_id, rs->pri_count-1, delta_ts);
+	}
+	return 0;
+}
+
+static int detector_check_pulse_ts(struct radar_specs *rp,
+		struct radar_stats *rs, uint64_t ts)
+{
+	uint32_t delta_ts;
+
+	DTRACE();
+	delta_ts = ts - rs->last_ts;
+	DLOG("[%d]: ts=%llu, last_ts=%llu, delta_ts=%d, pri_min=%d, pri_max=%d,"
+			"max_dur=%d", rp->type_id, ts, rs->last_ts, delta_ts,
+			rp->pri_min, rp->pri_max, rp->max_dur);
+	if (delta_ts >= rp->pri_min) {
+		DLOG("OK: delta_ts >= pri_min");
+		if (delta_ts <= rp->max_dur) {
+			/* this one is for us */
+			rs->last_ts = ts;
+			return detector_check_pri(rp, rs, delta_ts);
+		} else {
+			DLOG("NOK: delta_ts=%d > max_dur[%d]=%d",
+					delta_ts, rp->type_id, rp->max_dur);
+		}
+	} else
+		DLOG("delta_ts=%d < pri_min[%d]=%d",
+				delta_ts, rp->type_id, rp->pri_min);
+	/* if for some reason this radar was not for me, safely reset stats
+	 * since this pulse invalidates all previous
+	 */
+	reset_detector_element(rs, ts);
+	return 0;
+}
+
+
+static uint32_t freq_to_usec(uint32_t freq)
+{
+	return 1000000 / freq;
+}
+
+/* percentage of ppb threshold to trigger detection */
+#define MIN_PPB_THRESH	66
+#define PPB_THRESH(X)	((X*MIN_PPB_THRESH + 50) / 100)
+
+static void dpd_exit(struct dfs_pattern_detector *_this)
+{
+	if (_this->data != NULL) {
+		if (_this->data->radar_detectors != NULL)
+			free(_this->data->radar_detectors);
+		free(_this->data);
+	}
+	free(_this);
+}
+
+static enum dfs_detector_result dpd_add_pulse(
+		struct dfs_pattern_detector *_this, struct pulse_event *event)
+{
+	int detector_result = NO_DETECTION;
+	struct pattern_detector_data *pd_data = _this->data;
+	uint64_t delta_ts = event->ts - pd_data->last_pulse_ts;
+	uint32_t width = event->width;
+	int dfs_channel_idx;
+	DTRACE();
+
+	DINFO("e->width=%d, e->ts=%llu, delta_ts=%llu, e->freq=%d",
+			event->width, event->ts, delta_ts, event->freq);
+
+	dfs_channel_idx = get_dfs_channel_idx(event->freq);
+	if (dfs_channel_idx < 0) {
+		DERROR("pulse_event.freq=%d is no DFS frequency, dropping");
+		return PULSE_DROPPED;
+	}
+
+	/* global condition checks */
+
+	/* condition: pulse width inside valid range? */
+	if ((width > pd_data->max_valid_width) ||
+			(width < pd_data->min_valid_width)) {
+		DINFO("pulse width %d outside valid range [%d, %d], dropping",
+			width, pd_data->min_valid_pri, pd_data->max_valid_pri);
+		return PULSE_DROPPED;
+	}
+
+	pd_data->last_pulse_ts = event->ts;
+
+	/* condition: pulse interval < max allowed pattern duration */
+	if (delta_ts > pd_data->max_radar_dur) {
+		DINFO("pulse with delta_ts=%llu > max_radar_dur=%d, resetting",
+				delta_ts, pd_data->max_radar_dur);
+		detector_reset(pd_data, dfs_channel_idx);
+		return NO_DETECTION;
+	}
+
+	/* condition: pulse interval larger that min allowed pri
+	 * NOTE: we are not checking against max allowed pri to
+	 *       allow for coverage of multiple pris
+	 */
+	if (delta_ts >= pd_data->min_valid_pri) {
+		int i;
+
+		/* do type individual pattern matching */
+		for (i = 0; i < pd_data->num_detector_elements; i++) {
+			struct radar_specs *rp;
+			rp = &pd_data->radar_detectors[i].specs;
+			/* condition: width within type specific width range */
+			if (width >= rp->width_min && width <= rp->width_max) {
+				struct radar_stats *rs;
+				rs = &pd_data->radar_detectors[i].
+						stats[dfs_channel_idx];
+				if (detector_check_pulse_ts(rp,
+						rs, event->ts)) {
+					detector_result = RADAR_DETECTED;
+					/* stop here, don't care if further
+					 * patterns might also match */
+					break;
+				}
+			}
+		}
+		if (detector_result == RADAR_DETECTED) {
+			/* radar pattern found -> reset detector line */
+			detector_reset(pd_data, dfs_channel_idx);
+		}
+		return detector_result;
+	} else
+		DINFO("pulse with delta_ts=%llu outside valid pri-range "
+			"[%d, %d], resetting", delta_ts,
+			pd_data->min_valid_pri, pd_data->max_valid_pri);
+	return 0;
+}
+
+
+/* our base VFT */
+static struct dfs_pattern_detector dpd_default_vft = {
+	.exit 		= dpd_exit,
+	.add_pulse 	= dpd_add_pulse,
+};
+
+
+static void print_detector_specs(struct pattern_detector_data *pd_data)
+{
+	int i;
+	for (i = 0; i < pd_data->num_detector_elements; i++) {
+		struct radar_specs *rs = &pd_data->radar_detectors[i].specs;
+		DINIT("Initialized radar pattern type %d", i);
+		DINIT("   rs->type_id = %d", rs->type_id);
+		DINIT("   rs->width_min = %d", rs->width_min);
+		DINIT("   rs->width_max = %d", rs->width_max);
+		DINIT("   rs->pri_min = %d", rs->pri_min);
+		DINIT("   rs->pri_max = %d", rs->pri_max);
+		DINIT("   rs->num_pri = %d", rs->num_pri);
+		DINIT("   rs->ppb_thresh = %d", rs->ppb_thresh);
+		DINIT("   rs->max_dur = %d", rs->max_dur);
+	}
+	DINIT("valid ranges: width=[%d, %d], pri=[%d, %d], dur=%d",
+			pd_data->min_valid_width, pd_data->max_valid_width,
+			pd_data->min_valid_pri, pd_data->max_valid_pri,
+			pd_data->max_radar_dur);
+}
+
+
+/* allocate and initialize object data */
+static struct pattern_detector_data *setup_detector_data(struct radar_type *rt)
+{
+	int i;
+	struct pattern_detector_data *pd_data;
+	int sz = sizeof(struct pattern_detector_data);
+	pd_data = malloc(sz);
+	if (pd_data == NULL) {
+		DERROR("allocation of pattern_detector_data failed");
+		return NULL;
+	}
+
+	memset(pd_data, 0, sz);
+
+	sz = sizeof(struct detector_line) * rt->num_radar_types;
+	pd_data->radar_detectors = malloc(sz);
+	if (pd_data->radar_detectors == NULL) {
+		DERROR("allocation of radar_detectors failed");
+		return NULL;
+	}
+	memset(pd_data->radar_detectors, 0, sz);
+
+	pd_data->num_detector_elements = rt->num_radar_types;
+	pd_data->min_valid_width = (uint32_t) -1;
+	pd_data->max_valid_width = 0;
+	pd_data->min_valid_pri = (uint32_t) -1;
+	pd_data->max_valid_pri = 0;
+	pd_data->max_radar_dur = 0;
+
+	for (i = 0; i < rt->num_radar_types; i++) {
+		struct radar_signal_type *rst = &rt->radar_types[i];
+		struct radar_specs *rs = &pd_data->radar_detectors[i].specs;
+		DINIT("Initializing type %d", i);
+		rs->type_id = rst->type_id;
+		rs->width_min = rst->width_min;
+		rs->width_max = rst->width_max;
+		rs->pri_min = freq_to_usec(rst->pps_max) - MAX_PRI_TOLERANCE;
+		rs->pri_max = freq_to_usec(rst->pps_min) + MAX_PRI_TOLERANCE;
+		rs->num_pri = rst->num_pri;
+		rs->ppb = rst->ppb;
+		rs->ppb_thresh = PPB_THRESH(rst->ppb);
+		rs->max_dur = rs->pri_max * rst->ppb * rst->num_pri;
+
+		if (rs->width_min < pd_data->min_valid_width)
+			pd_data->min_valid_width = rs->width_min;
+		if (rs->width_max > pd_data->max_valid_width)
+			pd_data->max_valid_width = rs->width_max;
+		if (rs->pri_min < pd_data->min_valid_pri)
+			pd_data->min_valid_pri = rs->pri_min;
+		if (rs->pri_max > pd_data->max_valid_pri)
+			pd_data->max_valid_pri = rs->pri_max;
+		if (rs->max_dur > pd_data->max_radar_dur)
+			pd_data->max_radar_dur = rs->max_dur;
+	}
+	print_detector_specs(pd_data);
+	return pd_data;
+}
+
+
+struct dfs_pattern_detector *dfs_pattern_detector_init(
+		enum dfs_domain dfs_domain)
+{
+	int i;
+	struct dfs_pattern_detector *_this;
+	struct radar_type *rt;
+
+	/* find supported radar type */
+	for (i = 0; /* nothing */; i++) {
+		rt = supported_radar_types[i];
+		if (rt == NULL) {
+			DERROR("non-supported dfs-domain %d", dfs_domain);
+			return NULL;
+		}
+		if (rt->dfs_id == dfs_domain)
+			break;
+	}
+	/* allocate object instance */
+	_this = malloc(sizeof(struct dfs_pattern_detector));
+	if (_this == NULL) {
+		DERROR("allocation of dfs_pattern_detector failed");
+		return NULL;
+	}
+	*_this = dpd_default_vft;
+
+	/* allocate and initialize object data */
+	_this->data = setup_detector_data(rt);
+	if (_this->data == NULL) {
+		_this->exit(_this);
+		return NULL;
+	}
+	return _this;
+}
diff --git a/src/dfs/dfs_pattern_detector.h b/src/dfs/dfs_pattern_detector.h
new file mode 100644
index 0000000..384774f
--- /dev/null
+++ b/src/dfs/dfs_pattern_detector.h
@@ -0,0 +1,46 @@
+#ifndef DFS_PATTERN_DETECTOR_H
+#define DFS_PATTERN_DETECTOR_H
+
+#include "dfs.h"
+
+
+/**
+ * enum dfs_detector_result - DFS detector result after adding pulse
+ *
+ * Feeding a potential radar pulse to the detector might result in:
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
+ * struct dfs_pattern_detector - pseudo-OO DFS pattern detector class
+ *
+ * A DFS pattern detector object is instantiated with its constructor that
+ * returns ptr to initialized object.
+ *
+ * The VFT so far needs only two public methods:
+ * @exit: destructor
+ * @add_pulse: adds radar pulse to detector
+ *
+ * All data is private.
+ */
+struct dfs_pattern_detector {
+	/* VFT */
+	void (*exit)(struct dfs_pattern_detector *_this);
+	enum dfs_detector_result (*add_pulse)
+		(struct dfs_pattern_detector *_this, struct pulse_event *pe);
+
+	/* private data */
+	struct pattern_detector_data *data;
+};
+
+/* Constructor */
+struct dfs_pattern_detector *dfs_pattern_detector_init(enum dfs_domain);
+
+#endif /* DFS_PATTERN_DETECTOR_H */
diff --git a/src/dfs/dfs_radar_types.h b/src/dfs/dfs_radar_types.h
new file mode 100644
index 0000000..435ce32
--- /dev/null
+++ b/src/dfs/dfs_radar_types.h
@@ -0,0 +1,48 @@
+#ifndef DFS_RADAR_TYPES_H
+#define DFS_RADAR_TYPES_H
+
+#include "dfs.h"
+
+struct radar_signal_type {
+	unsigned int type_id;
+	unsigned int width_min;
+	unsigned int width_max;
+	unsigned int pps_min;
+	unsigned int pps_max;
+	unsigned int num_pri;
+	unsigned int ppb;
+};
+
+static struct radar_signal_type etsi_radar_ref_types_v15[] = {
+	{ 0,  0,  1,  700,  700, 1, 18, },
+	{ 1,  0,  5,  200, 1000, 1, 10, },
+	{ 2,  0, 15,  200, 1600, 1, 15, },
+	{ 3,  0, 15, 2300, 4000, 1, 25, },
+	{ 4, 20, 30, 2000, 4000, 1, 20, },
+	{ 5,  0,  2,  300,  400, 3, 10, },
+	{ 6,  0,  2,  400, 1200, 3, 15, },
+};
+
+struct radar_type {
+	uint32_t dfs_id;
+	uint32_t num_radar_types;
+	struct radar_signal_type *radar_types;
+};
+
+static struct radar_type etsi_radar_types_v15 = {
+	.dfs_id = DFS_ETSI_DOMAIN,
+	.num_radar_types = sizeof(etsi_radar_ref_types_v15) /
+				sizeof(struct radar_signal_type),
+	.radar_types = etsi_radar_ref_types_v15,
+};
+
+
+static struct radar_type *supported_radar_types[] = {
+	&etsi_radar_types_v15,
+	0,
+};
+
+
+
+#endif /* DFS_RADAR_TYPES_H */
+
-- 
1.7.1

