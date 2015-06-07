Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbbFGN4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:40 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 3/6] wil6210: add per-MCS Rx stats
Date: Sun,  7 Jun 2015 16:56:28 +0300
Message-Id: <1433685391-9026-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155648_820849_4678F6A9)
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide detailed statistics for the Rx frames per MCS
Statistics printed in "stations" debugfs entry

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 8 +++++++-
 drivers/net/wireless/ath/wil6210/txrx.c    | 2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 8f9c072..75219a1 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1360,7 +1360,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 {
 	struct wil6210_priv *wil = s->private;
-	int i, tid;
+	int i, tid, mcs;
 
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
@@ -1390,6 +1390,12 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 				}
 			}
 			spin_unlock_bh(&p->tid_rx_lock);
+			seq_puts(s, "Rx/MCS:");
+			for (mcs = 0; mcs < ARRAY_SIZE(p->stats.rx_per_mcs);
+			     mcs++)
+				seq_printf(s, " %lld",
+					   p->stats.rx_per_mcs[mcs]);
+			seq_puts(s, "\n");
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 0113dac..aa20af8 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -427,6 +427,8 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	cid = wil_rxdesc_cid(d);
 	stats = &wil->sta[cid].stats;
 	stats->last_mcs_rx = wil_rxdesc_mcs(d);
+	if (stats->last_mcs_rx < ARRAY_SIZE(stats->rx_per_mcs))
+		stats->rx_per_mcs[stats->last_mcs_rx]++;
 
 	/* use radiotap header only if required */
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ea0163c..c39369f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -464,6 +464,7 @@ enum wil_sta_status {
 };
 
 #define WIL_STA_TID_NUM (16)
+#define WIL_MCS_MAX (12) /* Maximum MCS supported */
 
 struct wil_net_stats {
 	unsigned long	rx_packets;
@@ -473,6 +474,7 @@ struct wil_net_stats {
 	unsigned long	tx_errors;
 	unsigned long	rx_dropped;
 	u16 last_mcs_rx;
+	u64 rx_per_mcs[WIL_MCS_MAX + 1];
 };
 
 /**
-- 
2.1.4

