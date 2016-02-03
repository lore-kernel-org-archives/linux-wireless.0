Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13313 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbcBCPiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 10:38:25 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: Fix updating peer stats rx duration
Date: Wed, 3 Feb 2016 21:07:42 +0530
Message-ID: <1454513863-2703-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160203_163830_015835_DD31C385)
In-Reply-To: <1454513863-2703-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1454513863-2703-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

We are not updating peer stats rx_duration periodically
unless the user one polls for fw_stats, this is because
we discard the update event since pdev list is empty. Fix
this by updating rx duration periodically irrepective of checks
for pdev list (irrespective of ping-pong response)

Fixes: 856e7c3 ("ath10k: add debugfs support for Per STA total rx duration")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 8d4148a..d80a44e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -348,6 +348,9 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	 */
 
 	peer_stats_svc = test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map);
+	if (peer_stats_svc)
+		ath10k_sta_update_rx_duration(ar, &stats.peers);
+
 	if (ar->debug.fw_stats_done && !peer_stats_svc) {
 		ath10k_warn(ar, "received unsolicited stats update event\n");
 		goto free;
@@ -384,9 +387,6 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 			goto free;
 		}
 
-		if (peer_stats_svc)
-			ath10k_sta_update_rx_duration(ar, &stats.peers);
-
 		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
 		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
 	}
-- 
1.7.9.5

