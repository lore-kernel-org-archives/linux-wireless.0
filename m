Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50785 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaCUWkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 18:40:07 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] ath10k:  add the Rx rate in FW stats
Date: Fri, 21 Mar 2014 15:39:20 -0700
Message-Id: <1395441560-6028-1-git-send-email-greearb@candelatech.com> (sfid-20140321_234012_896966_6AD56297)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

FW stats does provide the Rx rate information. Add this.
Tested with firmware 10x firmware.

Increase buffer size so more peers can be shown.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Re-work Chun-Yeow's patch to hopefully be backwards compat
     with pre 10.x firmware.  I tested on modified 10x firmware.

 drivers/net/wireless/ath/ath10k/core.h  |  1 +
 drivers/net/wireless/ath/ath10k/debug.c | 24 +++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h   |  9 ++++++++-
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a58e6de..2487a23 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -119,6 +119,7 @@ struct ath10k_peer_stat {
 	u8 peer_macaddr[ETH_ALEN];
 	u32 peer_rssi;
 	u32 peer_tx_rate;
+	u32 peer_rx_rate; /* 10x only */
 };
 
 struct ath10k_target_stats {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f535cdd..dec47df 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -242,13 +242,13 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	}
 
 	if (num_peer_stats) {
-		struct wmi_peer_stats *peer_stats;
+		struct wmi_peer_stats_10x *peer_stats;
 		struct ath10k_peer_stat *s;
 
 		stats->peers = num_peer_stats;
 
 		for (i = 0; i < num_peer_stats; i++) {
-			peer_stats = (struct wmi_peer_stats *)tmp;
+			peer_stats = (struct wmi_peer_stats_10x *)tmp;
 			s = &stats->peer_stat[i];
 
 			WMI_MAC_ADDR_TO_CHAR_ARRAY(&peer_stats->peer_macaddr,
@@ -256,8 +256,15 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 			s->peer_rssi = __le32_to_cpu(peer_stats->peer_rssi);
 			s->peer_tx_rate =
 				__le32_to_cpu(peer_stats->peer_tx_rate);
-
-			tmp += sizeof(struct wmi_peer_stats);
+			if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
+				     ar->fw_features)) {
+				s->peer_rx_rate =
+					__le32_to_cpu(peer_stats->peer_rx_rate);
+				tmp += sizeof(struct wmi_peer_stats_10x);
+
+			} else {
+				tmp += sizeof(struct wmi_peer_stats_old);
+			}
 		}
 	}
 
@@ -286,7 +293,7 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	struct ath10k *ar = file->private_data;
 	struct ath10k_target_stats *fw_stats;
 	char *buf = NULL;
-	unsigned int len = 0, buf_len = 2500;
+	unsigned int len = 0, buf_len = 8000;
 	ssize_t ret_cnt = 0;
 	int i;
 	int ret;
@@ -418,8 +425,8 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 			 "MPDU errors (FCS, MIC, ENC)", fw_stats->mpdu_errs);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s\n",
-			 "ath10k PEER stats");
+	len += scnprintf(buf + len, buf_len - len, "%30s (%d)\n",
+			 "ath10k PEER stats", fw_stats->peers);
 	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
 				 "=================");
 
@@ -432,6 +439,9 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
 				 "Peer TX rate",
 				 fw_stats->peer_stat[i].peer_tx_rate);
+		len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+				 "Peer RX rate",
+				 fw_stats->peer_stat[i].peer_rx_rate);
 		len += scnprintf(buf + len, buf_len - len, "\n");
 	}
 	spin_unlock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c11f49a..0ab78a6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2853,12 +2853,19 @@ struct wmi_vdev_stats {
  * peer statistics.
  * TODO: add more stats
  */
-struct wmi_peer_stats {
+struct wmi_peer_stats_old {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
 	__le32 peer_tx_rate;
 } __packed;
 
+struct wmi_peer_stats_10x {
+	struct wmi_mac_addr peer_macaddr;
+	__le32 peer_rssi;
+	__le32 peer_tx_rate;
+	__le32 peer_rx_rate;
+} __packed;
+
 struct wmi_vdev_create_cmd {
 	__le32 vdev_id;
 	__le32 vdev_type;
-- 
1.7.11.7

