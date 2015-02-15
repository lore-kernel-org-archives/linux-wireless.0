Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47089 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbbBOMDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 07:03:08 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Boris Sorochkin <boriss@codeaurora.org>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 6/9] wil6210: Fix division by zero in wil_vring_debugfs_show
Date: Sun, 15 Feb 2015 14:02:35 +0200
Message-Id: <1424001758-29529-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150215_130324_852108_962845F4)
In-Reply-To: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1424001758-29529-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Boris Sorochkin <boriss@codeaurora.org>

On some platforms get_cycles() implemented to allways return 0.
On such platforms "Division by zero" bug was triggered.

Signed-off-by: Boris Sorochkin <boriss@codeaurora.org>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index eb6de8c..fd59751 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -103,23 +103,30 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 				   % vring->size;
 			int avail = vring->size - used - 1;
 			char name[10];
+			char sidle[10];
 			/* performance monitoring */
 			cycles_t now = get_cycles();
 			uint64_t idle = txdata->idle * 100;
 			uint64_t total = now - txdata->begin;
 
-			do_div(idle, total);
+			if (total != 0) {
+				do_div(idle, total);
+				snprintf(sidle, sizeof(sidle), "%3d%%",
+					 (int)idle);
+			} else {
+				snprintf(sidle, sizeof(sidle), "N/A");
+			}
 			txdata->begin = now;
 			txdata->idle = 0ULL;
 
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
 			seq_printf(s,
-				   "\n%pM CID %d TID %d BACK([%d] %d TU A%s) [%3d|%3d] idle %3d%%\n",
-				   wil->sta[cid].addr, cid, tid,
-				   txdata->agg_wsize, txdata->agg_timeout,
-				   txdata->agg_amsdu ? "+" : "-",
-				   used, avail, (int)idle);
+				"\n%pM CID %d TID %d BACK([%d] %d TU A%s) [%3d|%3d] idle %s\n",
+				wil->sta[cid].addr, cid, tid,
+				txdata->agg_wsize, txdata->agg_timeout,
+				txdata->agg_amsdu ? "+" : "-",
+				used, avail, sidle);
 
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
-- 
2.1.0

