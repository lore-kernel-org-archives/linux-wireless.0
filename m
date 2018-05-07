Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43781 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752036AbeEGJjw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 05:39:52 -0400
Received: by mail-pg0-f65.google.com with SMTP id k11-v6so18703826pgo.10
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2018 02:39:51 -0700 (PDT)
Date: Mon, 7 May 2018 17:39:48 +0800
From: Kenneth Lu <kuohsianglu@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath10k: remove variables which set but not used
Message-ID: <20180507093948.GA7905@blackstone> (sfid-20180507_114002_358196_BD23FB75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable buf_len and num_vdev_stats are bging assigned but never read.
These are redundant and can be remove.

Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
---
Changes in v2:
Fixed compile failed in function 'ath10k_wmi_10_4_op_pull_fw_stats'
error: 'num_vdev_stats' undeclared
---
 drivers/net/wireless/ath/ath10k/wmi.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index bb8e9e2..46fb96e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2318,7 +2318,6 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	u32 phy_mode;
 	u32 snr;
 	u32 rate;
-	u32 buf_len;
 	u16 fc;
 	int ret;
 
@@ -2330,7 +2329,6 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	}
 
 	channel = __le32_to_cpu(arg.channel);
-	buf_len = __le32_to_cpu(arg.buf_len);
 	rx_status = __le32_to_cpu(arg.status);
 	snr = __le32_to_cpu(arg.snr);
 	phy_mode = __le32_to_cpu(arg.phy_mode);
@@ -2740,14 +2738,13 @@ static int ath10k_wmi_main_op_pull_fw_stats(struct ath10k *ar,
 					    struct ath10k_fw_stats *stats)
 {
 	const struct wmi_stats_event *ev = (void *)skb->data;
-	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
+	u32 num_pdev_stats, num_peer_stats;
 	int i;
 
 	if (!skb_pull(skb, sizeof(*ev)))
 		return -EPROTO;
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
 	for (i = 0; i < num_pdev_stats; i++) {
@@ -2795,14 +2792,13 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 					   struct ath10k_fw_stats *stats)
 {
 	const struct wmi_stats_event *ev = (void *)skb->data;
-	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
+	u32 num_pdev_stats, num_peer_stats;
 	int i;
 
 	if (!skb_pull(skb, sizeof(*ev)))
 		return -EPROTO;
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
 	for (i = 0; i < num_pdev_stats; i++) {
@@ -2856,7 +2852,6 @@ static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
 	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats;
 	u32 num_pdev_ext_stats;
-	u32 num_vdev_stats;
 	u32 num_peer_stats;
 	int i;
 
@@ -2865,7 +2860,6 @@ static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
 	for (i = 0; i < num_pdev_stats; i++) {
@@ -2935,7 +2929,6 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
 	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats;
 	u32 num_pdev_ext_stats;
-	u32 num_vdev_stats;
 	u32 num_peer_stats;
 	int i;
 
@@ -2944,7 +2937,6 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
 	for (i = 0; i < num_pdev_stats; i++) {
-- 
2.7.4
