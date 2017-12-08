Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44489 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752965AbdLHNcQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 08:32:16 -0500
From: Govind Singh <govinds@qti.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Populate RSC counter to firmware
Date: Fri,  8 Dec 2017 19:02:12 +0530
Message-Id: <1512739932-1577-1-git-send-email-govinds@qti.qualcomm.com> (sfid-20171208_143221_688279_0B039D88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Access Point (AP) re-transmits message 3 of 4 way handshake if
AP does not receive an appropriate response as acknowledgment.
As a result, the client may receive message 3 multiple times.
Each time it receives this message, it reinstalls the same
encryption key, and thereby reset the incremental transmit packet
number (nonce) and receive replay counter used by the encryption
protocol. By forcing nonce reuse in this manner, the encryption
protocol can be attacked, e.g., packets can be replayed, decrypted,
and/or forged.

Send RSC counter to FW in set key WMI command, so that FW can drop the
packet in PN check if received packet sequence no is less than current
RSC counter during group keys(GTK) exchange.

Tested on QCA6174 HW3.0 with firmware version RM.4.4.1.c1-00035-QCARMSWP-1.

Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 3 +++
 drivers/net/wireless/ath/ath10k/wmi.h     | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 06383e7..43f78e3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -226,6 +226,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		.macaddr = macaddr,
 	};
 
+	memcpy(arg.key_rsc_counter, key->rx_pn, IEEE80211_MAX_PN_LEN);
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
 	switch (key->cipher) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7616c1c..e7148f0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1849,6 +1849,9 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	if (arg->macaddr)
 		ether_addr_copy(cmd->peer_macaddr.addr, arg->macaddr);
 
+	memcpy(&cmd->key_rsc_counter, &arg->key_rsc_counter,
+	       WMI_MAX_RSC_LEN);
+
 	ptr += sizeof(*tlv);
 	ptr += sizeof(*cmd);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c02b21c..4849787 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4752,6 +4752,7 @@ struct wmi_key_seq_counter {
 #define WMI_CIPHER_CKIP     0x6
 #define WMI_CIPHER_AES_CMAC 0x7
 #define WMI_CIPHER_AES_GCM  0x8
+#define WMI_MAX_RSC_LEN     0x8
 
 struct wmi_vdev_install_key_cmd {
 	__le32 vdev_id;
@@ -4759,7 +4760,7 @@ struct wmi_vdev_install_key_cmd {
 	__le32 key_idx;
 	__le32 key_flags;
 	__le32 key_cipher; /* %WMI_CIPHER_ */
-	struct wmi_key_seq_counter key_rsc_counter;
+	u8 key_rsc_counter[WMI_MAX_RSC_LEN];
 	struct wmi_key_seq_counter key_global_rsc_counter;
 	struct wmi_key_seq_counter key_tsc_counter;
 	u8 wpi_key_rsc_counter[16];
@@ -4782,6 +4783,7 @@ struct wmi_vdev_install_key_arg {
 	u32 key_txmic_len;
 	u32 key_rxmic_len;
 	const void *key_data;
+	u8 key_rsc_counter[IEEE80211_MAX_PN_LEN];
 };
 
 /*
-- 
1.9.1
