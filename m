Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4183 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbaFPQiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:21 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 06/25] wil6210: more debug info for vring
Date: Mon, 16 Jun 2014 19:37:04 +0300
Message-ID: <1402936643-31819-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190456_986676_87E7C27D)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

print used/available counters on debugfs;
print to dmesg when Tx vring becomes empty

This aids with performance investigation

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 9 +++++++--
 drivers/net/wireless/ath/wil6210/txrx.c    | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 4fb3375..d90aa28 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -72,11 +72,16 @@ static int wil_vring_debugfs_show(struct seq_file *s, void *data)
 		if (vring->va) {
 			int cid = wil->vring2cid_tid[i][0];
 			int tid = wil->vring2cid_tid[i][1];
+			u32 swhead = vring->swhead;
+			u32 swtail = vring->swtail;
+			int used = (vring->size + swhead - swtail)
+				   % vring->size;
+			int avail = vring->size - used - 1;
 			char name[10];
 			snprintf(name, sizeof(name), "tx_%2d", i);
 
-			seq_printf(s, "\n%pM CID %d TID %d\n",
-				   wil->sta[cid].addr, cid, tid);
+			seq_printf(s, "\n%pM CID %d TID %d [%3d|%3d]\n",
+				   wil->sta[cid].addr, cid, tid, used, avail);
 			wil_print_vring(s, wil, name, vring, '_', 'H');
 		}
 	}
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 0784ef3..c08d041 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1132,6 +1132,10 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 			done++;
 		}
 	}
+
+	if (wil_vring_is_empty(vring))
+		wil_dbg_txrx(wil, "Ring[%2d] empty\n", ringid);
+
 	if (wil_vring_avail_tx(vring) > wil_vring_wmark_high(vring))
 		netif_tx_wake_all_queues(wil_to_ndev(wil));
 
-- 
1.9.1

