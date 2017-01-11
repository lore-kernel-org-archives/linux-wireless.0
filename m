Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27109 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764150AbdAKQN6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:13:58 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 10/12] wil6210: report association ID (AID) per station in debugfs
Date: Wed, 11 Jan 2017 18:12:46 +0200
Message-Id: <1484151168-894-11-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170111_171427_256368_6888B852)
In-Reply-To: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add reporting of the association ID (AID) for each station
as part of the stations file in the debugfs.
Valid AID values are 1-254. 0 is reported if the AID
is unknown or not reported by firmware.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 4 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 +
 drivers/net/wireless/ath/wil6210/wmi.c     | 5 +++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 1b7f6fe..c8396e0 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1379,6 +1379,7 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		struct wil_sta_info *p = &wil->sta[i];
 		char *status = "unknown";
+		u8 aid = 0;
 
 		switch (p->status) {
 		case wil_sta_unused:
@@ -1389,9 +1390,10 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 			break;
 		case wil_sta_connected:
 			status = "connected";
+			aid = p->aid;
 			break;
 		}
-		seq_printf(s, "[%d] %pM %s\n", i, p->addr, status);
+		seq_printf(s, "[%d] %pM %s AID %d\n", i, p->addr, status, aid);
 
 		if (p->status == wil_sta_connected) {
 			spin_lock_bh(&p->tid_rx_lock);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 5640fb0..995a69c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -523,6 +523,7 @@ struct wil_sta_info {
 	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(WIL_STA_TID_NUM)];
 	struct wil_tid_crypto_rx tid_crypto_rx[WIL_STA_TID_NUM];
 	struct wil_tid_crypto_rx group_crypto_rx;
+	u8 aid; /* 1-254; 0 if unknown/not reported */
 };
 
 enum {
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 7f13b09..d255d53 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -495,8 +495,8 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 	}
 
 	ch = evt->channel + 1;
-	wil_info(wil, "Connect %pM channel [%d] cid %d\n",
-		 evt->bssid, ch, evt->cid);
+	wil_info(wil, "Connect %pM channel [%d] cid %d aid %d\n",
+		 evt->bssid, ch, evt->cid, evt->aid);
 	wil_hex_dump_wmi("connect AI : ", DUMP_PREFIX_OFFSET, 16, 1,
 			 evt->assoc_info, len - sizeof(*evt), true);
 
@@ -604,6 +604,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 	}
 
 	wil->sta[evt->cid].status = wil_sta_connected;
+	wil->sta[evt->cid].aid = evt->aid;
 	set_bit(wil_status_fwconnected, wil->status);
 	wil_update_net_queues_bh(wil, NULL, false);
 
-- 
1.9.1
