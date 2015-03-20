Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34775 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbCTLAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 07:00:45 -0400
Received: by lbbsy1 with SMTP id sy1so72588084lbb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 04:00:43 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v4 3/6] ath10k: store max tdls vdevs that fw can handle
Date: Fri, 20 Mar 2015 12:02:56 +0100
Message-Id: <1426849379-7562-4-git-send-email-marek.puzyniak@tieto.com> (sfid-20150320_120047_878236_54EF520C)
In-Reply-To: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently number of tdls vdevs supported by firmware
is hardcoded. For future usage it is stored in ath10k
structure based on defined value.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c    | 1 +
 drivers/net/wireless/ath/ath10k/core.h    | 1 +
 drivers/net/wireless/ath/ath10k/hw.h      | 1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 +-
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c0e454b..47a3c55 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -971,6 +971,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_num_peers = TARGET_TLV_NUM_PEERS;
 		ar->max_num_stations = TARGET_TLV_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_TLV_NUM_VDEVS;
+		ar->max_num_tdls_vdevs = TARGET_TLV_NUM_TDLS_VDEVS;
 		ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b07d883..7d4f9c9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -638,6 +638,7 @@ struct ath10k {
 	int max_num_peers;
 	int max_num_stations;
 	int max_num_vdevs;
+	int max_num_tdls_vdevs;
 
 	struct work_struct offchan_tx_work;
 	struct sk_buff_head offchan_tx_queue;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7f04645..3ae2dbf 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -261,6 +261,7 @@ struct ath10k_pktlog_hdr {
 #define TARGET_TLV_NUM_PEERS			((TARGET_TLV_NUM_STATIONS) + \
 						 (TARGET_TLV_NUM_VDEVS) + \
 						 2)
+#define TARGET_TLV_NUM_TDLS_VDEVS		1
 #define TARGET_TLV_NUM_TIDS			((TARGET_TLV_NUM_PEERS) * 2)
 #define TARGET_TLV_NUM_MSDU_DESC		(1024 + 32)
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index a65e11b..80e882b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1271,7 +1271,7 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->gtk_offload_max_vdev = __cpu_to_le32(2);
 	cfg->num_msdu_desc = __cpu_to_le32(TARGET_TLV_NUM_MSDU_DESC);
 	cfg->max_frag_entries = __cpu_to_le32(2);
-	cfg->num_tdls_vdevs = __cpu_to_le32(1);
+	cfg->num_tdls_vdevs = __cpu_to_le32(TARGET_TLV_NUM_TDLS_VDEVS);
 	cfg->num_tdls_conn_table_entries = __cpu_to_le32(0x20);
 	cfg->beacon_tx_offload_max_vdev = __cpu_to_le32(2);
 	cfg->num_multicast_filter_entries = __cpu_to_le32(5);
-- 
2.1.4

