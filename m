Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:33101 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959Ab3DOJ3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 05:29:18 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: change DFS logging to use ath_dbg()
Date: Mon, 15 Apr 2013 11:29:06 +0200
Message-Id: <1366018146-4175-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130415_112923_220395_F48C2421)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DFS pattern detector was initially planned to reside on
a higher layer and used generic pr_*() logging functions.

Being part of ath9k, use ath_dbg() instead and make DFS log
ouput selectable via ATH_DBG_DFS (0x20000) at runtime.

This patch does not contain functional modifications.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c               |    6 ---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |   43 ++++++++++--------
 .../net/wireless/ath/ath9k/dfs_pattern_detector.h  |    6 ++-
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c  |   46 ++++----------------
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h  |   27 +++++++++++-
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 6 files changed, 63 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 508f8b3..7187d36 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -55,12 +55,6 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 	u8 rssi;
 	u16 dur;
 
-	ath_dbg(ath9k_hw_common(sc->sc_ah), DFS,
-		"pulse_bw_info=0x%x, pri,ext len/rssi=(%u/%u, %u/%u)\n",
-		ard->pulse_bw_info,
-		ard->pulse_length_pri, ard->rssi,
-		ard->pulse_length_ext, ard->ext_rssi);
-
 	/*
 	 * Only the last 2 bits of the BW info are relevant, they indicate
 	 * which channel the radar was detected in.
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
index 73fe8d6..491305c 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
@@ -19,6 +19,7 @@
 
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
+#include "ath9k.h"
 
 /*
  * tolerated deviation of radar time stamp in usecs on both sides
@@ -142,6 +143,7 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 {
 	u32 sz, i;
 	struct channel_detector *cd;
+	struct ath_common *common = ath9k_hw_common(dpd->ah);
 
 	cd = kmalloc(sizeof(*cd), GFP_ATOMIC);
 	if (cd == NULL)
@@ -165,7 +167,8 @@ channel_detector_create(struct dfs_pattern_detector *dpd, u16 freq)
 	return cd;
 
 fail:
-	pr_err("failed to allocate channel_detector for freq=%d\n", freq);
+	ath_dbg(common, DFS,
+		"failed to allocate channel_detector for freq=%d\n", freq);
 	channel_detector_exit(dpd, cd);
 	return NULL;
 }
@@ -216,34 +219,34 @@ static bool
 dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
 {
 	u32 i;
-	bool ts_wraparound;
 	struct channel_detector *cd;
 
-	if (dpd->region == NL80211_DFS_UNSET) {
-		/*
-		 * pulses received for a non-supported or un-initialized
-		 * domain are treated as detected radars
-		 */
+	/*
+	 * pulses received for a non-supported or un-initialized
+	 * domain are treated as detected radars for fail-safety
+	 */
+	if (dpd->region == NL80211_DFS_UNSET)
 		return true;
-	}
 
 	cd = channel_detector_get(dpd, event->freq);
 	if (cd == NULL)
 		return false;
 
-	ts_wraparound = (event->ts < dpd->last_pulse_ts);
 	dpd->last_pulse_ts = event->ts;
-	if (ts_wraparound) {
-		/*
-		 * reset detector on time stamp wraparound
-		 * with monotonic time stamps, this should never happen
-		 */
-		pr_warn("DFS: time stamp wraparound detected, resetting\n");
+	/* reset detector on time stamp wraparound, caused by TSF reset */
+	if (event->ts < dpd->last_pulse_ts)
 		dpd_reset(dpd);
-	}
+
 	/* do type individual pattern matching */
 	for (i = 0; i < dpd->num_radar_types; i++) {
-		if (cd->detectors[i]->add_pulse(cd->detectors[i], event) != 0) {
+		struct pri_detector *pd = cd->detectors[i];
+		struct pri_sequence *ps = pd->add_pulse(pd, event);
+		if (ps != NULL) {
+			ath_dbg(ath9k_hw_common(dpd->ah), DFS,
+				"DFS: radar found on freq=%d: id=%d, pri=%d, "
+				"count=%d, count_false=%d\n",
+				event->freq, pd->rs->type_id,
+				ps->pri, ps->count, ps->count_falses);
 			channel_detector_reset(dpd, cd);
 			return true;
 		}
@@ -285,9 +288,10 @@ static struct dfs_pattern_detector default_dpd = {
 };
 
 struct dfs_pattern_detector *
-dfs_pattern_detector_init(enum nl80211_dfs_regions region)
+dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region)
 {
 	struct dfs_pattern_detector *dpd;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	dpd = kmalloc(sizeof(*dpd), GFP_KERNEL);
 	if (dpd == NULL)
@@ -296,10 +300,11 @@ dfs_pattern_detector_init(enum nl80211_dfs_regions region)
 	*dpd = default_dpd;
 	INIT_LIST_HEAD(&dpd->channel_detectors);
 
+	dpd->ah = ah;
 	if (dpd->set_dfs_domain(dpd, region))
 		return dpd;
 
-	pr_err("Could not set DFS domain to %d. ", region);
+	ath_dbg(common, DFS,"Could not set DFS domain to %d", region);
 	kfree(dpd);
 	return NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
index cda52f3..90a5abc 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
@@ -80,6 +80,8 @@ struct dfs_pattern_detector {
 	enum nl80211_dfs_regions region;
 	u8 num_radar_types;
 	u64 last_pulse_ts;
+	/* needed for ath_dbg() */
+	struct ath_hw *ah;
 
 	const struct radar_detector_specs *radar_spec;
 	struct list_head channel_detectors;
@@ -92,10 +94,10 @@ struct dfs_pattern_detector {
  */
 #if defined(CONFIG_ATH9K_DFS_CERTIFIED)
 extern struct dfs_pattern_detector *
-dfs_pattern_detector_init(enum nl80211_dfs_regions region);
+dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region);
 #else
 static inline struct dfs_pattern_detector *
-dfs_pattern_detector_init(enum nl80211_dfs_regions region)
+dfs_pattern_detector_init(struct ath_hw *ah, enum nl80211_dfs_regions region)
 {
 	return NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
index 5e48c55..9447be5 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
@@ -23,28 +23,6 @@
 #include "dfs_debug.h"
 
 /**
- * struct pri_sequence - sequence of pulses matching one PRI
- * @head: list_head
- * @pri: pulse repetition interval (PRI) in usecs
- * @dur: duration of sequence in usecs
- * @count: number of pulses in this sequence
- * @count_falses: number of not matching pulses in this sequence
- * @first_ts: time stamp of first pulse in usecs
- * @last_ts: time stamp of last pulse in usecs
- * @deadline_ts: deadline when this sequence becomes invalid (first_ts + dur)
- */
-struct pri_sequence {
-	struct list_head head;
-	u32 pri;
-	u32 dur;
-	u32 count;
-	u32 count_falses;
-	u64 first_ts;
-	u64 last_ts;
-	u64 deadline_ts;
-};
-
-/**
  * struct pulse_elem - elements in pulse queue
  * @ts: time stamp in usecs
  */
@@ -393,8 +371,8 @@ static void pri_detector_exit(struct pri_detector *de)
 	kfree(de);
 }
 
-static bool pri_detector_add_pulse(struct pri_detector *de,
-				   struct pulse_event *event)
+static struct pri_sequence *pri_detector_add_pulse(struct pri_detector *de,
+						   struct pulse_event *event)
 {
 	u32 max_updated_seq;
 	struct pri_sequence *ps;
@@ -403,35 +381,29 @@ static bool pri_detector_add_pulse(struct pri_detector *de,
 
 	/* ignore pulses not within width range */
 	if ((rs->width_min > event->width) || (rs->width_max < event->width))
-		return false;
+		return NULL;
 
 	if ((ts - de->last_ts) < rs->max_pri_tolerance)
 		/* if delta to last pulse is too short, don't use this pulse */
-		return false;
+		return NULL;
 	de->last_ts = ts;
 
 	max_updated_seq = pseq_handler_add_to_existing_seqs(de, ts);
 
 	if (!pseq_handler_create_sequences(de, ts, max_updated_seq)) {
-		pr_err("failed to create pulse sequences\n");
 		pri_detector_reset(de, ts);
 		return false;
 	}
 
 	ps = pseq_handler_check_detection(de);
 
-	if (ps != NULL) {
-		pr_info("DFS: radar found: pri=%d, count=%d, count_false=%d\n",
-			 ps->pri, ps->count, ps->count_falses);
-		pri_detector_reset(de, ts);
-		return true;
-	}
-	pulse_queue_enqueue(de, ts);
-	return false;
+	if (ps == NULL)
+		pulse_queue_enqueue(de, ts);
+
+	return ps;
 }
 
-struct pri_detector *
-pri_detector_init(const struct radar_detector_specs *rs)
+struct pri_detector *pri_detector_init(const struct radar_detector_specs *rs)
 {
 	struct pri_detector *de;
 	de = kzalloc(sizeof(*de), GFP_KERNEL);
diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
index 81cde9f..723962d 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
@@ -20,9 +20,31 @@
 #include <linux/list.h>
 
 /**
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
  * struct pri_detector - PRI detector element for a dedicated radar type
  * @exit(): destructor
- * @add_pulse(): add pulse event, returns true if pattern was detected
+ * @add_pulse(): add pulse event, returns pri_sequence if pattern was detected
  * @reset(): clear states and reset to given time stamp
  * @rs: detector specs for this detector element
  * @last_ts: last pulse time stamp considered for this element in usecs
@@ -34,7 +56,8 @@
  */
 struct pri_detector {
 	void (*exit)     (struct pri_detector *de);
-	bool (*add_pulse)(struct pri_detector *de, struct pulse_event *e);
+	struct pri_sequence *
+	     (*add_pulse)(struct pri_detector *de, struct pulse_event *e);
 	void (*reset)    (struct pri_detector *de, u64 ts);
 
 /* private: internal use only */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3be2eb0..6b275e0 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -577,7 +577,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	atomic_set(&ah->intr_ref_cnt, -1);
 	sc->sc_ah = ah;
 
-	sc->dfs_detector = dfs_pattern_detector_init(NL80211_DFS_UNSET);
+	sc->dfs_detector = dfs_pattern_detector_init(ah, NL80211_DFS_UNSET);
 
 	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
-- 
1.7.4.1

