Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40586 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbcAMPsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:48:18 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 5/7] ath10k: Provision to support periodic peer stats update
Date: Wed, 13 Jan 2016 21:16:32 +0530
Message-ID: <1452699994-5078-6-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164820_944658_5D57645D)
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable support for periodic peer stats update when peer stats
service is enabled. The host to update the peer stats received
from the firmware periodically, since firmware will reset this to zero
after sometime (due to memory constraints)

While enabling periodic peer / vdev stats cleanup the existing
list in debugfs if max limit is reached, so that the new stats is
updated.

Ideally speaking based on 'Michal Kazior's' suggestion
we need to completely move to periodic update of all the stats making
the 'ping - pong' method obselete. This requires a bit of re-work and
some testing as well, also confirmation regarding backward comptability
for various firmware and chipsets. Hence allow periodic update only
for peer_stats.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 4fb1e0e..3b8da81 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -347,7 +347,8 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 	 *     delivered which is treated as end-of-data and is itself discarded
 	 */
 
-	if (ar->debug.fw_stats_done) {
+	if (ar->debug.fw_stats_done &&
+	    !test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
 		ath10k_warn(ar, "received unsolicited stats update event\n");
 		goto free;
 	}
@@ -372,11 +373,13 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 			/* Although this is unlikely impose a sane limit to
 			 * prevent firmware from DoS-ing the host.
 			 */
+			ath10k_fw_stats_peers_free(&ar->debug.fw_stats.peers);
 			ath10k_warn(ar, "dropping fw peer stats\n");
 			goto free;
 		}
 
 		if (num_vdevs >= BITS_PER_LONG) {
+			ath10k_fw_stats_vdevs_free(&ar->debug.fw_stats.vdevs);
 			ath10k_warn(ar, "dropping fw vdev stats\n");
 			goto free;
 		}
-- 
1.7.9.5

