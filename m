Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59639 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031019Ab2CPKZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 06:25:27 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Add ARP offload related statistic info in tgt_stats
Date: Fri, 16 Mar 2012 15:54:56 +0530
Message-ID: <1331893496-18098-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120316_112531_157022_A7DD22C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Firmware reports the below ARP offload related information
while sending the target statistic event to the host.

     * Number of ARP packets received.
     * Number of packets matched with the device IP addr.
     * Number of ARP response packet sent to the remote.

This patch adds the additional debug prints in debugfs
entry tgt_stats. It will be useful to know the ARP offload
execution status.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    6 ++++++
 drivers/net/wireless/ath/ath6kl/main.c  |    4 ++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 56e1cb1..31cdca1 100755
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -622,6 +622,12 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 			 "Num disconnects", tgt_stats->cs_discon_cnt);
 	len += scnprintf(buf + len, buf_len - len, "%20s %10d\n",
 			 "Beacon avg rssi", tgt_stats->cs_ave_beacon_rssi);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10d\n",
+			 "ARP pkt received", tgt_stats->arp_received);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10d\n",
+			 "ARP pkt matched", tgt_stats->arp_matched);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10d\n",
+			 "ARP pkt replied", tgt_stats->arp_replied);
 
 	if (len > buf_len)
 		len = buf_len;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index bd8388c..8c1b44a 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -756,6 +756,10 @@ static void ath6kl_update_target_stats(struct ath6kl_vif *vif, u8 *ptr, u32 len)
 	stats->wow_evt_discarded +=
 		le16_to_cpu(tgt_stats->wow_stats.wow_evt_discarded);
 
+	stats->arp_received = le32_to_cpu(tgt_stats->arp_stats.arp_received);
+	stats->arp_replied = le32_to_cpu(tgt_stats->arp_stats.arp_replied);
+	stats->arp_matched = le32_to_cpu(tgt_stats->arp_stats.arp_matched);
+
 	if (test_bit(STATS_UPDATE_PEND, &vif->flags)) {
 		clear_bit(STATS_UPDATE_PEND, &vif->flags);
 		wake_up(&ar->event_wq);
-- 
1.7.1

