Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbeEOJKL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:10:11 -0400
From: Sriram R <srirrama@codeaurora.org>
To: kvalo@codeaurora.org, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCHv2 1/2] ath: Add support to get the detected radar specifications
Date: Tue, 15 May 2018 14:39:48 +0530
Message-Id: <1526375389-7106-2-git-send-email-srirrama@codeaurora.org> (sfid-20180515_111026_404665_DE476BBE)
In-Reply-To: <1526375389-7106-1-git-send-email-srirrama@codeaurora.org>
References: <1526375389-7106-1-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables ath10k/ath9k drivers to collect the specifications of the
radar type once it is detected by the dfs pattern detector unit.
Usage of the collected info is specific to driver implementation.
For example, collected radar info could be used by the host driver
to send to co-processors for additional processing/validation.

Note: 'radar_detector_specs' data containing the specifications of
different radar types which was private within dfs_pattern_detector/
dfs_pri_detector is now shared with drivers as well for making use
of this information.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c           | 2 +-
 drivers/net/wireless/ath/ath9k/dfs.c            | 2 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c | 5 ++++-
 drivers/net/wireless/ath/dfs_pattern_detector.h | 3 ++-
 drivers/net/wireless/ath/dfs_pri_detector.h     | 3 ++-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 46fb96e..1bccac0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3757,7 +3757,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 
 	ATH10K_DFS_STAT_INC(ar, pulses_detected);
 
-	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe)) {
+	if (!ar->dfs_detector->add_pulse(ar->dfs_detector, &pe, NULL)) {
 		ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 			   "dfs no pulse pattern detected, yet\n");
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index c8844f5..acb9602 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -277,7 +277,7 @@ ath9k_dfs_process_radar_pulse(struct ath_softc *sc, struct pulse_event *pe)
 	DFS_STAT_INC(sc, pulses_processed);
 	if (pd == NULL)
 		return;
-	if (!pd->add_pulse(pd, pe))
+	if (!pd->add_pulse(pd, pe, NULL))
 		return;
 	DFS_STAT_INC(sc, radar_detected);
 	ieee80211_radar_detected(sc->hw);
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index 448b83e..d52b31b 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -268,7 +268,8 @@ static void dpd_exit(struct dfs_pattern_detector *dpd)
 }
 
 static bool
-dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
+dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event,
+	      struct radar_detector_specs *rs)
 {
 	u32 i;
 	struct channel_detector *cd;
@@ -294,6 +295,8 @@ dpd_add_pulse(struct dfs_pattern_detector *dpd, struct pulse_event *event)
 		struct pri_detector *pd = cd->detectors[i];
 		struct pri_sequence *ps = pd->add_pulse(pd, event);
 		if (ps != NULL) {
+			if (rs != NULL)
+				memcpy(rs, pd->rs, sizeof(*rs));
 			ath_dbg(dpd->common, DFS,
 				"DFS: radar found on freq=%d: id=%d, pri=%d, "
 				"count=%d, count_false=%d\n",
diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.h b/drivers/net/wireless/ath/dfs_pattern_detector.h
index 92be353..18db6f4 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.h
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.h
@@ -97,7 +97,8 @@ struct dfs_pattern_detector {
 	bool (*set_dfs_domain)(struct dfs_pattern_detector *dpd,
 			   enum nl80211_dfs_regions region);
 	bool (*add_pulse)(struct dfs_pattern_detector *dpd,
-			  struct pulse_event *pe);
+			  struct pulse_event *pe,
+			  struct radar_detector_specs *rs);
 
 	struct ath_dfs_pool_stats (*get_stats)(struct dfs_pattern_detector *dpd);
 	enum nl80211_dfs_regions region;
diff --git a/drivers/net/wireless/ath/dfs_pri_detector.h b/drivers/net/wireless/ath/dfs_pri_detector.h
index 79f0fff..86339f2 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.h
+++ b/drivers/net/wireless/ath/dfs_pri_detector.h
@@ -62,8 +62,9 @@ struct pri_detector {
 	     (*add_pulse)(struct pri_detector *de, struct pulse_event *e);
 	void (*reset)    (struct pri_detector *de, u64 ts);
 
-/* private: internal use only */
 	const struct radar_detector_specs *rs;
+
+/* private: internal use only */
 	u64 last_ts;
 	struct list_head sequences;
 	struct list_head pulses;
-- 
2.7.4
