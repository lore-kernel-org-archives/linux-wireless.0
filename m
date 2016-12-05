Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34163 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752332AbcLEVwy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 16:52:54 -0500
Received: by mail-wj0-f196.google.com with SMTP id xy5so41223240wjc.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 13:52:49 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 1/2] ath10k: add accounting for the extended peer statistics
Date: Mon,  5 Dec 2016 22:52:45 +0100
Message-Id: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com> (sfid-20161205_225259_675260_D6967200)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 10.4 firmware adds extended peer information to the
firmware's statistics payload. This additional info is
stored as a separate data field and the elements are
stored in their own "peers_extd" list.

These elements can pile up in the same way as the peer
information elements. This is because the
ath10k_wmi_10_4_op_pull_fw_stats() function tries to
pull the same amount (num_peer_stats) for every statistic
data unit.

Fixes: 4a49ae94a448faa ("ath10k: fix 10.4 extended peer stats update")
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 82a4c67f3672..4acd9eb65910 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -399,6 +399,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 			 * prevent firmware from DoS-ing the host.
 			 */
 			ath10k_fw_stats_peers_free(&ar->debug.fw_stats.peers);
+			ath10k_fw_extd_stats_peers_free(&ar->debug.fw_stats.peers_extd);
 			ath10k_warn(ar, "dropping fw peer stats\n");
 			goto free;
 		}
@@ -409,10 +410,12 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 			goto free;
 		}
 
+		if (!list_empty(&stats.peers))
+			list_splice_tail_init(&stats.peers_extd,
+					      &ar->debug.fw_stats.peers_extd);
+
 		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
 		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
-		list_splice_tail_init(&stats.peers_extd,
-				      &ar->debug.fw_stats.peers_extd);
 	}
 
 	complete(&ar->debug.fw_stats_complete);
-- 
2.11.0
