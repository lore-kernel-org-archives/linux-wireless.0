Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35882 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936112AbeF2LlK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:41:10 -0400
Received: by mail-wm0-f65.google.com with SMTP id u18-v6so1759083wmc.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 04:41:09 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: [PATCH v2 3/4] mt76x2: dfs: add sw pattern detector
Date: Fri, 29 Jun 2018 13:40:54 +0200
Message-Id: <8e1df57615f718def79deff06a11e292d60053ed.1530260731.git.lorenzo.bianconi@redhat.com> (sfid-20180629_134115_337987_6811518D)
In-Reply-To: <cover.1530260731.git.lorenzo.bianconi@redhat.com>
References: <cover.1530260731.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sw DFS pattern detector support for mt76x2 based devices.
Dfs pattern supported:
- short pulse radar patterns
- staggered radar patterns

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   | 231 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x2_dfs.h   |  30 +++
 2 files changed, 260 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index 606202fe1851..38c1d5dc47ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -159,9 +159,57 @@ static void mt76x2_dfs_set_capture_mode_ctrl(struct mt76x2_dev *dev,
 	mt76_wr(dev, MT_BBP(DFS, 36), data);
 }
 
+static void mt76x2_dfs_seq_pool_put(struct mt76x2_dev *dev,
+				    struct mt76x2_dfs_sequence *seq)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+
+	list_add(&seq->head, &dfs_pd->seq_pool);
+}
+
+static
+struct mt76x2_dfs_sequence *mt76x2_dfs_seq_pool_get(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_sequence *seq;
+
+	if (list_empty(&dfs_pd->seq_pool)) {
+		seq = devm_kzalloc(dev->mt76.dev, sizeof(*seq), GFP_ATOMIC);
+	} else {
+		seq = list_first_entry(&dfs_pd->seq_pool,
+				       struct mt76x2_dfs_sequence,
+				       head);
+		list_del(&seq->head);
+	}
+	return seq;
+}
+
+static int mt76x2_dfs_get_multiple(int val, int frac, int margin)
+{
+	int remainder, factor;
+
+	if (!frac)
+		return 0;
+
+	if (abs(val - frac) <= margin)
+		return 1;
+
+	factor = val / frac;
+	remainder = val % frac;
+
+	if (remainder > margin) {
+		if ((frac - remainder) <= margin)
+			factor++;
+		else
+			factor = 0;
+	}
+	return factor;
+}
+
 static void mt76x2_dfs_detector_reset(struct mt76x2_dev *dev)
 {
 	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_sequence *seq, *tmp_seq;
 	int i;
 
 	/* reset hw detector */
@@ -172,6 +220,11 @@ static void mt76x2_dfs_detector_reset(struct mt76x2_dev *dev)
 		dfs_pd->event_rb[i].h_rb = 0;
 		dfs_pd->event_rb[i].t_rb = 0;
 	}
+
+	list_for_each_entry_safe(seq, tmp_seq, &dfs_pd->sequences, head) {
+		list_del_init(&seq->head);
+		mt76x2_dfs_seq_pool_put(dev, seq);
+	}
 }
 
 static bool mt76x2_dfs_check_chirp(struct mt76x2_dev *dev)
@@ -374,11 +427,145 @@ static void mt76x2_dfs_queue_event(struct mt76x2_dev *dev,
 					     MT_DFS_EVENT_BUFLEN);
 }
 
+static int mt76x2_dfs_create_sequence(struct mt76x2_dev *dev,
+				      struct mt76x2_dfs_event *event,
+				      u16 cur_len)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_sw_detector_params *sw_params;
+	u32 width_delta, with_sum, factor, cur_pri;
+	struct mt76x2_dfs_sequence seq, *seq_p;
+	struct mt76x2_dfs_event_rb *event_rb;
+	struct mt76x2_dfs_event *cur_event;
+	int i, j, end, pri;
+
+	event_rb = event->engine == 2 ? &dfs_pd->event_rb[1]
+				      : &dfs_pd->event_rb[0];
+
+	i = mt76_decr(event_rb->t_rb, MT_DFS_EVENT_BUFLEN);
+	end = mt76_decr(event_rb->h_rb, MT_DFS_EVENT_BUFLEN);
+
+	while (i != end) {
+		cur_event = &event_rb->data[i];
+		with_sum = event->width + cur_event->width;
+
+		sw_params = &dfs_pd->sw_dpd_params;
+		switch (dev->dfs_pd.region) {
+		case NL80211_DFS_FCC:
+		case NL80211_DFS_JP:
+			if (with_sum < 600)
+				width_delta = 8;
+			else
+				width_delta = with_sum >> 3;
+			break;
+		case NL80211_DFS_ETSI:
+			if (event->engine == 2)
+				width_delta = with_sum >> 6;
+			else if (with_sum < 620)
+				width_delta = 24;
+			else
+				width_delta = 8;
+			break;
+		case NL80211_DFS_UNSET:
+		default:
+			return -EINVAL;
+		}
+
+		pri = event->ts - cur_event->ts;
+		if (abs(event->width - cur_event->width) > width_delta ||
+		    pri < sw_params->min_pri)
+			goto next;
+
+		if (pri > sw_params->max_pri)
+			break;
+
+		seq.pri = event->ts - cur_event->ts;
+		seq.first_ts = cur_event->ts;
+		seq.last_ts = event->ts;
+		seq.engine = event->engine;
+		seq.count = 2;
+
+		j = mt76_decr(i, MT_DFS_EVENT_BUFLEN);
+		while (j != end) {
+			cur_event = &event_rb->data[j];
+			cur_pri = event->ts - cur_event->ts;
+			factor = mt76x2_dfs_get_multiple(cur_pri, seq.pri,
+						sw_params->pri_margin);
+			if (factor > 0) {
+				seq.first_ts = cur_event->ts;
+				seq.count++;
+			}
+
+			j = mt76_decr(j, MT_DFS_EVENT_BUFLEN);
+		}
+		if (seq.count <= cur_len)
+			goto next;
+
+		seq_p = mt76x2_dfs_seq_pool_get(dev);
+		if (!seq_p)
+			return -ENOMEM;
+
+		*seq_p = seq;
+		INIT_LIST_HEAD(&seq_p->head);
+		list_add(&seq_p->head, &dfs_pd->sequences);
+next:
+		i = mt76_decr(i, MT_DFS_EVENT_BUFLEN);
+	}
+	return 0;
+}
+
+static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x2_dev *dev,
+					    struct mt76x2_dfs_event *event)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_sw_detector_params *sw_params;
+	struct mt76x2_dfs_sequence *seq, *tmp_seq;
+	u16 max_seq_len = 0;
+	u32 factor, pri;
+
+	sw_params = &dfs_pd->sw_dpd_params;
+	list_for_each_entry_safe(seq, tmp_seq, &dfs_pd->sequences, head) {
+		if (event->ts > seq->first_ts + MT_DFS_SEQUENCE_WINDOW) {
+			list_del_init(&seq->head);
+			mt76x2_dfs_seq_pool_put(dev, seq);
+			continue;
+		}
+
+		if (event->engine != seq->engine)
+			continue;
+
+		pri = event->ts - seq->last_ts;
+		factor = mt76x2_dfs_get_multiple(pri, seq->pri,
+						 sw_params->pri_margin);
+		if (factor > 0) {
+			seq->last_ts = event->ts;
+			seq->count++;
+			max_seq_len = max_t(u16, max_seq_len, seq->count);
+		}
+	}
+	return max_seq_len;
+}
+
+static bool mt76x2_dfs_check_detection(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_sequence *seq;
+
+	if (list_empty(&dfs_pd->sequences))
+		return false;
+
+	list_for_each_entry(seq, &dfs_pd->sequences, head) {
+		if (seq->count > MT_DFS_SEQUENCE_TH)
+			return true;
+	}
+	return false;
+}
+
 static void mt76x2_dfs_add_events(struct mt76x2_dev *dev)
 {
 	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	struct mt76x2_dfs_event event;
-	int i;
+	int i, seq_len;
 
 	/* disable debug mode */
 	mt76x2_dfs_set_capture_mode_ctrl(dev, false);
@@ -393,6 +580,9 @@ static void mt76x2_dfs_add_events(struct mt76x2_dev *dev)
 		if (!mt76x2_dfs_check_event(dev, &event))
 			continue;
 
+		seq_len = mt76x2_dfs_add_event_to_sequence(dev, &event);
+		mt76x2_dfs_create_sequence(dev, &event, seq_len);
+
 		mt76x2_dfs_queue_event(dev, &event);
 	}
 	mt76x2_dfs_set_capture_mode_ctrl(dev, true);
@@ -433,9 +623,19 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 
 	if (time_is_before_jiffies(dfs_pd->last_sw_check +
 				   MT_DFS_SW_TIMEOUT)) {
+		bool radar_detected;
+
 		dfs_pd->last_sw_check = jiffies;
 
 		mt76x2_dfs_add_events(dev);
+		radar_detected = mt76x2_dfs_check_detection(dev);
+		if (radar_detected) {
+			/* sw detector rx radar pattern */
+			ieee80211_radar_detected(dev->mt76.hw);
+			mt76x2_dfs_detector_reset(dev);
+
+			return;
+		}
 		mt76x2_dfs_check_event_window(dev);
 	}
 
@@ -472,6 +672,32 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	mt76x2_irq_enable(dev, MT_INT_GPTIMER);
 }
 
+static void mt76x2_dfs_init_sw_detector(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+
+	switch (dev->dfs_pd.region) {
+	case NL80211_DFS_FCC:
+		dfs_pd->sw_dpd_params.max_pri = MT_DFS_FCC_MAX_PRI;
+		dfs_pd->sw_dpd_params.min_pri = MT_DFS_FCC_MIN_PRI;
+		dfs_pd->sw_dpd_params.pri_margin = MT_DFS_PRI_MARGIN;
+		break;
+	case NL80211_DFS_ETSI:
+		dfs_pd->sw_dpd_params.max_pri = MT_DFS_ETSI_MAX_PRI;
+		dfs_pd->sw_dpd_params.min_pri = MT_DFS_ETSI_MIN_PRI;
+		dfs_pd->sw_dpd_params.pri_margin = MT_DFS_PRI_MARGIN << 2;
+		break;
+	case NL80211_DFS_JP:
+		dfs_pd->sw_dpd_params.max_pri = MT_DFS_JP_MAX_PRI;
+		dfs_pd->sw_dpd_params.min_pri = MT_DFS_JP_MIN_PRI;
+		dfs_pd->sw_dpd_params.pri_margin = MT_DFS_PRI_MARGIN;
+		break;
+	case NL80211_DFS_UNSET:
+	default:
+		break;
+	}
+}
+
 static void mt76x2_dfs_set_bbp_params(struct mt76x2_dev *dev)
 {
 	u32 data;
@@ -594,6 +820,7 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 
 	if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
 	    dev->dfs_pd.region != NL80211_DFS_UNSET) {
+		mt76x2_dfs_init_sw_detector(dev);
 		mt76x2_dfs_set_bbp_params(dev);
 		/* enable debug mode */
 		mt76x2_dfs_set_capture_mode_ctrl(dev, true);
@@ -618,6 +845,8 @@ void mt76x2_dfs_init_detector(struct mt76x2_dev *dev)
 {
 	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
+	INIT_LIST_HEAD(&dfs_pd->sequences);
+	INIT_LIST_HEAD(&dfs_pd->seq_pool);
 	dfs_pd->region = NL80211_DFS_UNSET;
 	dfs_pd->last_sw_check = jiffies;
 	tasklet_init(&dfs_pd->dfs_tasklet, mt76x2_dfs_tasklet,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
index 49a49e999fed..83d2ff0b7e1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
@@ -37,7 +37,17 @@
 #define MT_DFS_EVENT_LOOP		64
 #define MT_DFS_SW_TIMEOUT		(HZ / 20)
 #define MT_DFS_EVENT_WINDOW		(HZ / 5)
+#define MT_DFS_SEQUENCE_WINDOW		(200 * (1 << 20))
 #define MT_DFS_EVENT_TIME_MARGIN	2000
+#define MT_DFS_PRI_MARGIN		4
+#define MT_DFS_SEQUENCE_TH		6
+
+#define MT_DFS_FCC_MAX_PRI		((28570 << 1) + 1000)
+#define MT_DFS_FCC_MIN_PRI		(3000 - 2)
+#define MT_DFS_JP_MAX_PRI		((80000 << 1) + 1000)
+#define MT_DFS_JP_MIN_PRI		(28500 - 2)
+#define MT_DFS_ETSI_MAX_PRI		(133333 + 125000 + 117647 + 1000)
+#define MT_DFS_ETSI_MIN_PRI		(4500 - 20)
 
 struct mt76x2_radar_specs {
 	u8 mode;
@@ -73,6 +83,15 @@ struct mt76x2_dfs_event_rb {
 	int h_rb, t_rb;
 };
 
+struct mt76x2_dfs_sequence {
+	struct list_head head;
+	u32 first_ts;
+	u32 last_ts;
+	u32 pri;
+	u16 count;
+	u8 engine;
+};
+
 struct mt76x2_dfs_hw_pulse {
 	u8 engine;
 	u32 period;
@@ -81,6 +100,12 @@ struct mt76x2_dfs_hw_pulse {
 	u32 burst;
 };
 
+struct mt76x2_dfs_sw_detector_params {
+	u32 min_pri;
+	u32 max_pri;
+	u32 pri_margin;
+};
+
 struct mt76x2_dfs_engine_stats {
 	u32 hw_pattern;
 	u32 hw_pulse_discarded;
@@ -92,7 +117,12 @@ struct mt76x2_dfs_pattern_detector {
 	u8 chirp_pulse_cnt;
 	u32 chirp_pulse_ts;
 
+	struct mt76x2_dfs_sw_detector_params sw_dpd_params;
 	struct mt76x2_dfs_event_rb event_rb[2];
+
+	struct list_head sequences;
+	struct list_head seq_pool;
+
 	unsigned long last_sw_check;
 	u32 last_event_ts;
 
-- 
2.17.1
