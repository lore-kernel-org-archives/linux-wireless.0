Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:46524 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943AbaCUKAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 06:00:23 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so2190885pab.40
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 03:00:23 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath10k: add the Rx rate in FW stats
Date: Fri, 21 Mar 2014 18:00:14 +0800
Message-Id: <1395396014-24631-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140321_110030_859961_B5313C9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW stats does provide the Rx rate information. Add this.
Tested with firmware 10.1.467.2-1.

Further investigation on firmware 999.999.0.636 indicates
that there is no Tx Rate and Rx Rate in the peer stats.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    1 +
 drivers/net/wireless/ath/ath10k/debug.c |    5 +++++
 drivers/net/wireless/ath/ath10k/wmi.h   |    1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ad209a6..ca4cdab 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -119,6 +119,7 @@ struct ath10k_peer_stat {
 	u8 peer_macaddr[ETH_ALEN];
 	u32 peer_rssi;
 	u32 peer_tx_rate;
+	u32 peer_rx_rate;
 };
 
 struct ath10k_target_stats {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f95defa..4662cb7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -257,6 +257,8 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 			s->peer_rssi = __le32_to_cpu(peer_stats->peer_rssi);
 			s->peer_tx_rate =
 				__le32_to_cpu(peer_stats->peer_tx_rate);
+			s->peer_rx_rate =
+				__le32_to_cpu(peer_stats->peer_rx_rate);
 
 			tmp += sizeof(struct wmi_peer_stats);
 		}
@@ -425,6 +427,9 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
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
index 084bcc5..2b2f0b7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2825,6 +2825,7 @@ struct wmi_peer_stats {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
 	__le32 peer_tx_rate;
+	__le32 peer_rx_rate;
 } __packed;
 
 struct wmi_vdev_create_cmd {
-- 
1.7.9.5

