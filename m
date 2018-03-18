Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:45085 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbeCRHuS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 03:50:18 -0400
Received: by mail-pf0-f196.google.com with SMTP id l27so1296100pfk.12
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2018 00:50:18 -0700 (PDT)
Date: Sun, 18 Mar 2018 15:50:14 +0800
From: Kenneth Lu <kuohsianglu@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: remove variables which set but not used
Message-ID: <20180318075014.GA26784@blackstone> (sfid-20180318_085352_930119_84C084FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable buf_len and num_vdev_stats are bging assigned but never read.
These are redundant and can be remove.

Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc218..da9552d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2308,7 +2308,6 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	u32 phy_mode;
 	u32 snr;
 	u32 rate;
-	u32 buf_len;
 	u16 fc;
 	int ret;
 
@@ -2320,7 +2319,6 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	}
 
 	channel = __le32_to_cpu(arg.channel);
-	buf_len = __le32_to_cpu(arg.buf_len);
 	rx_status = __le32_to_cpu(arg.status);
 	snr = __le32_to_cpu(arg.snr);
 	phy_mode = __le32_to_cpu(arg.phy_mode);
@@ -2708,14 +2706,13 @@ static int ath10k_wmi_main_op_pull_fw_stats(struct ath10k *ar,
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
@@ -2763,14 +2760,13 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
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
@@ -2824,7 +2820,6 @@ static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
 	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats;
 	u32 num_pdev_ext_stats;
-	u32 num_vdev_stats;
 	u32 num_peer_stats;
 	int i;
 
@@ -2833,7 +2828,6 @@ static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
 	for (i = 0; i < num_pdev_stats; i++) {
@@ -2903,7 +2897,6 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
 	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats;
 	u32 num_pdev_ext_stats;
-	u32 num_vdev_stats;
 	u32 num_peer_stats;
 	int i;
 
@@ -2912,7 +2905,6 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 
 	for (i = 0; i < num_pdev_stats; i++) {
@@ -2991,7 +2983,6 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	const struct wmi_10_2_stats_event *ev = (void *)skb->data;
 	u32 num_pdev_stats;
 	u32 num_pdev_ext_stats;
-	u32 num_vdev_stats;
 	u32 num_peer_stats;
 	u32 num_bcnflt_stats;
 	u32 stats_id;
@@ -3002,7 +2993,6 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 
 	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 	num_bcnflt_stats = __le32_to_cpu(ev->num_bcnflt_stats);
 	stats_id = __le32_to_cpu(ev->stats_id);
-- 
2.7.4
