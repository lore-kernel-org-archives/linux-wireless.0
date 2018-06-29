Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55359 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936124AbeF2LlL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:41:11 -0400
Received: by mail-wm0-f65.google.com with SMTP id v16-v6so1858975wmv.5
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 04:41:11 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: [PATCH v2 4/4] mt76x2: debugfs: add sw pulse statistics to dfs debugfs
Date: Fri, 29 Jun 2018 13:40:55 +0200
Message-Id: <1d83422de2b131ed841d65aaf5f5437b5867e581.1530260731.git.lorenzo.bianconi@redhat.com> (sfid-20180629_134117_456125_A772D912)
In-Reply-To: <cover.1530260731.git.lorenzo.bianconi@redhat.com>
References: <cover.1530260731.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sw pattern detector statistics to mt76x2 debugfs.
Moreover track down number of allocated sequence by the detector

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c |  8 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c     | 11 ++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h     |  7 +++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 3f86e01049f3..74725902e6dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -91,12 +91,20 @@ mt76x2_dfs_stat_read(struct seq_file *file, void *data)
 	struct mt76x2_dev *dev = file->private;
 	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
+	seq_printf(file, "allocated sequences:\t%d\n",
+		   dfs_pd->seq_stats.seq_pool_len);
+	seq_printf(file, "used sequences:\t\t%d\n",
+		   dfs_pd->seq_stats.seq_len);
+	seq_puts(file, "\n");
+
 	for (i = 0; i < MT_DFS_NUM_ENGINES; i++) {
 		seq_printf(file, "engine: %d\n", i);
 		seq_printf(file, "  hw pattern detected:\t%d\n",
 			   dfs_pd->stats[i].hw_pattern);
 		seq_printf(file, "  hw pulse discarded:\t%d\n",
 			   dfs_pd->stats[i].hw_pulse_discarded);
+		seq_printf(file, "  sw pattern detected:\t%d\n",
+			   dfs_pd->stats[i].sw_pattern);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index 38c1d5dc47ec..374cc655c11d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -165,6 +165,9 @@ static void mt76x2_dfs_seq_pool_put(struct mt76x2_dev *dev,
 	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	list_add(&seq->head, &dfs_pd->seq_pool);
+
+	dfs_pd->seq_stats.seq_pool_len++;
+	dfs_pd->seq_stats.seq_len--;
 }
 
 static
@@ -180,7 +183,11 @@ struct mt76x2_dfs_sequence *mt76x2_dfs_seq_pool_get(struct mt76x2_dev *dev)
 				       struct mt76x2_dfs_sequence,
 				       head);
 		list_del(&seq->head);
+		dfs_pd->seq_stats.seq_pool_len--;
 	}
+	if (seq)
+		dfs_pd->seq_stats.seq_len++;
+
 	return seq;
 }
 
@@ -555,8 +562,10 @@ static bool mt76x2_dfs_check_detection(struct mt76x2_dev *dev)
 		return false;
 
 	list_for_each_entry(seq, &dfs_pd->sequences, head) {
-		if (seq->count > MT_DFS_SEQUENCE_TH)
+		if (seq->count > MT_DFS_SEQUENCE_TH) {
+			dfs_pd->stats[seq->engine].sw_pattern++;
 			return true;
+		}
 	}
 	return false;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
index 83d2ff0b7e1f..693f421bf096 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
@@ -109,6 +109,12 @@ struct mt76x2_dfs_sw_detector_params {
 struct mt76x2_dfs_engine_stats {
 	u32 hw_pattern;
 	u32 hw_pulse_discarded;
+	u32 sw_pattern;
+};
+
+struct mt76x2_dfs_seq_stats {
+	u32 seq_pool_len;
+	u32 seq_len;
 };
 
 struct mt76x2_dfs_pattern_detector {
@@ -122,6 +128,7 @@ struct mt76x2_dfs_pattern_detector {
 
 	struct list_head sequences;
 	struct list_head seq_pool;
+	struct mt76x2_dfs_seq_stats seq_stats;
 
 	unsigned long last_sw_check;
 	u32 last_event_ts;
-- 
2.17.1
