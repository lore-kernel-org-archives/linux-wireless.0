Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11307 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbGIIuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 04:50:50 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: free collected fw stats memory if .pull_fw_stats fails
Date: Thu, 9 Jul 2015 14:19:43 +0530
Message-ID: <1436431783-10691-2-git-send-email-rmani@qti.qualcomm.com> (sfid-20150709_105058_999634_FD80A97A)
In-Reply-To: <1436431783-10691-1-git-send-email-rmani@qti.qualcomm.com>
References: <1436431783-10691-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If .pull_fw_stats() fails for some reason while processing
fw stats event, collected pdev/vdev/peer stats just before
the failure should be freed. This is unlikely to happen,
just code review catch.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index edf6047..fc6852c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -321,7 +321,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	ret = ath10k_wmi_pull_fw_stats(ar, skb, &stats);
 	if (ret) {
 		ath10k_warn(ar, "failed to pull fw stats: %d\n", ret);
-		goto unlock;
+		goto free;
 	}
 
 	/* Stat data may exceed htc-wmi buffer limit. In such case firmware
@@ -384,7 +384,6 @@ free:
 	ath10k_debug_fw_stats_vdevs_free(&stats.vdevs);
 	ath10k_debug_fw_stats_peers_free(&stats.peers);
 
-unlock:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-- 
1.8.1.2

