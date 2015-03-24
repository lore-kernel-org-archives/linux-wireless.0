Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36162 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbCXMqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:46:00 -0400
Received: by labe2 with SMTP id e2so83003724lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:45:58 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5 7/7] ath10k: allocate fw resources for iface combinations
Date: Tue, 24 Mar 2015 12:43:13 +0000
Message-Id: <1427200993-7550-8-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134609_970807_AC94657E)
In-Reply-To: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of 3 vdevs wasn't enough to handle the
worst case for interface combinations in practice.

wpa_supplicant may need up to 4 vifs to have 2
vifs actually connected, i.e. p2pdev + client + 2x
p2p (either p2p client or p2p go).

This fixes worst case warning:

  Free vdev map is empty, no more interfaces allowed.

This keeps the ability to associate 32 stations in
AP mode at the cost of not being able to guarantee
that under all circumstances, i.e. some
combinations may consume additional fw peer
entries for internal purposes leaving less
resource for stations in AP mode.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h      | 6 ++----
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 34fcb6d5786d..1e9a781a45b4 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -280,11 +280,9 @@ enum ath10k_hw_rate_cck {
 #define TARGET_10_2_DMA_BURST_SIZE		1
 
 /* Target specific defines for WMI-TLV firmware */
-#define TARGET_TLV_NUM_VDEVS			3
+#define TARGET_TLV_NUM_VDEVS			4
 #define TARGET_TLV_NUM_STATIONS			32
-#define TARGET_TLV_NUM_PEERS			((TARGET_TLV_NUM_STATIONS) + \
-						 (TARGET_TLV_NUM_VDEVS) + \
-						 2)
+#define TARGET_TLV_NUM_PEERS			35
 #define TARGET_TLV_NUM_TDLS_VDEVS		1
 #define TARGET_TLV_NUM_TIDS			((TARGET_TLV_NUM_PEERS) * 2)
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 73cf3d00c2d0..f42ff9d97b00 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1318,8 +1318,8 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_peers = __cpu_to_le32(TARGET_TLV_NUM_PEERS);
 
 	if (test_bit(WMI_SERVICE_RX_FULL_REORDER, ar->wmi.svc_map)) {
-		cfg->num_offload_peers = __cpu_to_le32(3);
-		cfg->num_offload_reorder_bufs = __cpu_to_le32(3);
+		cfg->num_offload_peers = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
+		cfg->num_offload_reorder_bufs = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
 	} else {
 		cfg->num_offload_peers = __cpu_to_le32(0);
 		cfg->num_offload_reorder_bufs = __cpu_to_le32(0);
@@ -1336,8 +1336,8 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->rx_timeout_pri[3] = __cpu_to_le32(0x28);
 	cfg->rx_decap_mode = __cpu_to_le32(1);
 	cfg->scan_max_pending_reqs = __cpu_to_le32(4);
-	cfg->bmiss_offload_max_vdev = __cpu_to_le32(3);
-	cfg->roam_offload_max_vdev = __cpu_to_le32(3);
+	cfg->bmiss_offload_max_vdev = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
+	cfg->roam_offload_max_vdev = __cpu_to_le32(TARGET_TLV_NUM_VDEVS);
 	cfg->roam_offload_max_ap_profiles = __cpu_to_le32(8);
 	cfg->num_mcast_groups = __cpu_to_le32(0);
 	cfg->num_mcast_table_elems = __cpu_to_le32(0);
-- 
2.1.4

