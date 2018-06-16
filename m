Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35321 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932439AbeFPP4g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Jun 2018 11:56:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id j15-v6so8563214wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2018 08:56:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mt76x2: dfs: add sw event ring buffer
Date: Sat, 16 Jun 2018 17:56:19 +0200
Message-Id: <20180616155621.30539-3-lorenzo.bianconi@redhat.com> (sfid-20180616_175640_009981_97169EC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce sw event ring buffer to queue DFS pulses loaded from the hw.
Radar pulses will be used in DFS sw detector

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   | 140 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x2_dfs.h   |  23 +++
 2 files changed, 160 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index f936dc9a5476..3117569c26d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -159,6 +159,21 @@ static void mt76x2_dfs_set_capture_mode_ctrl(struct mt76x2_dev *dev,
 	mt76_wr(dev, MT_BBP(DFS, 36), data);
 }
 
+static void mt76x2_dfs_detector_reset(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	int i;
+
+	/* reset hw detector */
+	mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
+
+	/* reset sw detector */
+	for (i = 0; i < ARRAY_SIZE(dfs_pd->event_rb); i++) {
+		dfs_pd->event_rb[i].h_rb = 0;
+		dfs_pd->event_rb[i].t_rb = 0;
+	}
+}
+
 static bool mt76x2_dfs_check_chirp(struct mt76x2_dev *dev)
 {
 	bool ret = false;
@@ -295,6 +310,118 @@ static bool mt76x2_dfs_check_hw_pulse(struct mt76x2_dev *dev,
 	return ret;
 }
 
+static bool mt76x2_dfs_fetch_event(struct mt76x2_dev *dev,
+				   struct mt76x2_dfs_event *event)
+{
+	u32 i, data[4];
+
+	for (i = 0; i < ARRAY_SIZE(data); i++) {
+		/* 1st: DFS_R37[31]: 0 (engine 0) - 1 (engine 2)
+		 * 2nd: DFS_R37[21:0]: pulse time
+		 * 3rd: DFS_R37[11:0]: pulse width
+		 * 3rd: DFS_R37[25:16]: phase
+		 * 4th: DFS_R37[12:0]: current pwr
+		 * 4th: DFS_R37[21:16]: pwr stable counter
+		 *
+		 * 1st: DFS_R37[31:0] set to 0xffffffff means no event detected
+		 */
+		data[i] = mt76_rr(dev, MT_BBP(DFS, 37));
+	}
+
+	if (data[0] == GENMASK(31, 0))
+		return false;
+
+	event->engine = (data[0] & BIT(31)) ? 2 : 0;
+	event->ts = data[1] & GENMASK(21, 0);
+	event->width = data[2] & GENMASK(11, 0);
+
+	return true;
+}
+
+static bool mt76x2_dfs_check_event(struct mt76x2_dev *dev,
+				   struct mt76x2_dfs_event *event)
+{
+	if (event->engine == 2) {
+		struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+		struct mt76x2_dfs_event_rb *event_buff = &dfs_pd->event_rb[1];
+		u16 last_event_idx;
+		u32 delta_ts;
+
+		last_event_idx = mt76_decr(event_buff->t_rb,
+					   MT_DFS_EVENT_BUFLEN);
+		delta_ts = event->ts - event_buff->data[last_event_idx].ts;
+		if (delta_ts < MT_DFS_EVENT_TIME_MARGIN &&
+		    event_buff->data[last_event_idx].width >= 200)
+			return false;
+	}
+	return true;
+}
+
+static void mt76x2_dfs_queue_event(struct mt76x2_dev *dev,
+				   struct mt76x2_dfs_event *event)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_event_rb *event_buff;
+
+	/* add radar event to ring buffer */
+	event_buff = event->engine == 2 ? &dfs_pd->event_rb[1]
+					: &dfs_pd->event_rb[0];
+	event_buff->data[event_buff->t_rb] = *event;
+	event_buff->data[event_buff->t_rb].fetch_ts = jiffies;
+
+	event_buff->t_rb = mt76_incr(event_buff->t_rb, MT_DFS_EVENT_BUFLEN);
+	if (event_buff->t_rb == event_buff->h_rb)
+		event_buff->h_rb = mt76_incr(event_buff->h_rb,
+					     MT_DFS_EVENT_BUFLEN);
+}
+
+static void mt76x2_dfs_add_events(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_event event;
+	int i;
+
+	/* disable debug mode */
+	mt76x2_dfs_set_capture_mode_ctrl(dev, false);
+	for (i = 0; i < MT_DFS_EVENT_LOOP; i++) {
+		if (!mt76x2_dfs_fetch_event(dev, &event))
+			break;
+
+		if (dfs_pd->last_event_ts > event.ts)
+			mt76x2_dfs_detector_reset(dev);
+		dfs_pd->last_event_ts = event.ts;
+
+		if (!mt76x2_dfs_check_event(dev, &event))
+			continue;
+
+		mt76x2_dfs_queue_event(dev, &event);
+	}
+	mt76x2_dfs_set_capture_mode_ctrl(dev, true);
+}
+
+static void mt76x2_dfs_check_event_window(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x2_dfs_event_rb *event_buff;
+	struct mt76x2_dfs_event *event;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dfs_pd->event_rb); i++) {
+		event_buff = &dfs_pd->event_rb[i];
+
+		while (event_buff->h_rb != event_buff->t_rb) {
+			event = &event_buff->data[event_buff->h_rb];
+
+			/* sorted list */
+			if (time_is_after_jiffies(event->fetch_ts +
+						  MT_DFS_EVENT_WINDOW))
+				break;
+			event_buff->h_rb = mt76_incr(event_buff->h_rb,
+						     MT_DFS_EVENT_BUFLEN);
+		}
+	}
+}
+
 static void mt76x2_dfs_tasklet(unsigned long arg)
 {
 	struct mt76x2_dev *dev = (struct mt76x2_dev *)arg;
@@ -305,6 +432,14 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	if (test_bit(MT76_SCANNING, &dev->mt76.state))
 		goto out;
 
+	if (time_is_before_jiffies(dfs_pd->last_sw_check +
+				   MT_DFS_SW_TIMEOUT)) {
+		dfs_pd->last_sw_check = jiffies;
+
+		mt76x2_dfs_add_events(dev);
+		mt76x2_dfs_check_event_window(dev);
+	}
+
 	engine_mask = mt76_rr(dev, MT_BBP(DFS, 1));
 	if (!(engine_mask & 0xf))
 		goto out;
@@ -326,9 +461,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 		/* hw detector rx radar pattern */
 		dfs_pd->stats[i].hw_pattern++;
 		ieee80211_radar_detected(dev->mt76.hw);
-
-		/* reset hw detector */
-		mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
+		mt76x2_dfs_detector_reset(dev);
 
 		return;
 	}
@@ -487,6 +620,7 @@ void mt76x2_dfs_init_detector(struct mt76x2_dev *dev)
 	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	dfs_pd->region = NL80211_DFS_UNSET;
+	dfs_pd->last_sw_check = jiffies;
 	tasklet_init(&dfs_pd->dfs_tasklet, mt76x2_dfs_tasklet,
 		     (unsigned long)dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
index 8dbc783cc6bc..56f09eb5d6d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
@@ -33,6 +33,12 @@
 #define MT_DFS_PKT_END_MASK		0
 #define MT_DFS_CH_EN			0xf
 
+/* sw detector params */
+#define MT_DFS_EVENT_LOOP		64
+#define MT_DFS_SW_TIMEOUT		(HZ / 20)
+#define MT_DFS_EVENT_WINDOW		(HZ / 5)
+#define MT_DFS_EVENT_TIME_MARGIN	2000
+
 struct mt76x2_radar_specs {
 	u8 mode;
 	u16 avg_len;
@@ -50,6 +56,19 @@ struct mt76x2_radar_specs {
 	u16 pwr_jmp;
 };
 
+struct mt76x2_dfs_event {
+	unsigned long fetch_ts;
+	u32 ts;
+	u16 width;
+	u8 engine;
+};
+
+#define MT_DFS_EVENT_BUFLEN		256
+struct mt76x2_dfs_event_rb {
+	struct mt76x2_dfs_event data[MT_DFS_EVENT_BUFLEN];
+	int h_rb, t_rb;
+};
+
 struct mt76x2_dfs_hw_pulse {
 	u8 engine;
 	u32 period;
@@ -69,6 +88,10 @@ struct mt76x2_dfs_pattern_detector {
 	u8 chirp_pulse_cnt;
 	u32 chirp_pulse_ts;
 
+	struct mt76x2_dfs_event_rb event_rb[2];
+	unsigned long last_sw_check;
+	u32 last_event_ts;
+
 	struct mt76x2_dfs_engine_stats stats[MT_DFS_NUM_ENGINES];
 	struct tasklet_struct dfs_tasklet;
 };
-- 
2.17.1
