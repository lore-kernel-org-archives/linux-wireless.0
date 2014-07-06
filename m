Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37356 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGFJgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:35 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so14477997wib.6
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:34 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/40] iwlwifi: mvm: remove unused flags from TX command
Date: Sun,  6 Jul 2014 12:35:45 +0300
Message-Id: <1404639376-3792-9-git-send-email-egrumbach@gmail.com> (sfid-20140706_113641_135109_99BECD5E)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These flags are not used by the firmware anyway.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h | 16 ++--------------
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  1 -
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index bdd6ff6..d6073f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -69,10 +69,8 @@
  * @TX_CMD_FLG_ACK: expect ACK from receiving station
  * @TX_CMD_FLG_STA_RATE: use RS table with initial index from the TX command.
  *	Otherwise, use rate_n_flags from the TX command
- * @TX_CMD_FLG_BA: this frame is a block ack
  * @TX_CMD_FLG_BAR: this frame is a BA request, immediate BAR is expected
  *	Must set TX_CMD_FLG_ACK with this flag.
- * @TX_CMD_FLG_TXOP_PROT: protect frame with full TXOP protection
  * @TX_CMD_FLG_VHT_NDPA: mark frame is NDPA for VHT beamformer sequence
  * @TX_CMD_FLG_HT_NDPA: mark frame is NDPA for HT beamformer sequence
  * @TX_CMD_FLG_CSI_FDBK2HOST: mark to send feedback to host (only if good CRC)
@@ -82,12 +80,10 @@
  * @TX_CMD_FLG_SEQ_CTL: set if FW should override the sequence control.
  *	Should be set for mgmt, non-QOS data, mcast, bcast and in scan command
  * @TX_CMD_FLG_MORE_FRAG: this frame is non-last MPDU
- * @TX_CMD_FLG_NEXT_FRAME: this frame includes information of the next frame
  * @TX_CMD_FLG_TSF: FW should calculate and insert TSF in the frame
  *	Should be set for beacons and probe responses
  * @TX_CMD_FLG_CALIB: activate PA TX power calibrations
  * @TX_CMD_FLG_KEEP_SEQ_CTL: if seq_ctl is set, don't increase inner seq count
- * @TX_CMD_FLG_AGG_START: allow this frame to start aggregation
  * @TX_CMD_FLG_MH_PAD: driver inserted 2 byte padding after MAC header.
  *	Should be set for 26/30 length MAC headers
  * @TX_CMD_FLG_RESP_TO_DRV: zero this if the response should go only to FW
@@ -103,7 +99,6 @@ enum iwl_tx_flags {
 	TX_CMD_FLG_PROT_REQUIRE		= BIT(0),
 	TX_CMD_FLG_ACK			= BIT(3),
 	TX_CMD_FLG_STA_RATE		= BIT(4),
-	TX_CMD_FLG_BA			= BIT(5),
 	TX_CMD_FLG_BAR			= BIT(6),
 	TX_CMD_FLG_TXOP_PROT		= BIT(7),
 	TX_CMD_FLG_VHT_NDPA		= BIT(8),
@@ -113,11 +108,9 @@ enum iwl_tx_flags {
 	TX_CMD_FLG_BT_DIS		= BIT(12),
 	TX_CMD_FLG_SEQ_CTL		= BIT(13),
 	TX_CMD_FLG_MORE_FRAG		= BIT(14),
-	TX_CMD_FLG_NEXT_FRAME		= BIT(15),
 	TX_CMD_FLG_TSF			= BIT(16),
 	TX_CMD_FLG_CALIB		= BIT(17),
 	TX_CMD_FLG_KEEP_SEQ_CTL		= BIT(18),
-	TX_CMD_FLG_AGG_START		= BIT(19),
 	TX_CMD_FLG_MH_PAD		= BIT(20),
 	TX_CMD_FLG_RESP_TO_DRV		= BIT(21),
 	TX_CMD_FLG_CCMP_AGG		= BIT(22),
@@ -191,8 +184,6 @@ enum iwl_tx_flags {
  * struct iwl_tx_cmd - TX command struct to FW
  * ( TX_CMD = 0x1c )
  * @len: in bytes of the payload, see below for details
- * @next_frame_len: same as len, but for next frame (0 if not applicable)
- *	Used for fragmentation and bursting, but not in 11n aggregation.
  * @tx_flags: combination of TX_CMD_FLG_*
  * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
  *	cleared. Combination of RATE_MCS_*
@@ -210,8 +201,6 @@ enum iwl_tx_flags {
  * @data_retry_limit: max attempts to send the data packet
  * @tid_spec: TID/tspec
  * @pm_frame_timeout: PM TX frame timeout
- * @driver_txop: duration od EDCA TXOP, in 32-usec units. Set this if not
- *	specified by HCCA protocol
  *
  * The byte count (both len and next_frame_len) includes MAC header
  * (24/26/30/32 bytes)
@@ -241,8 +230,7 @@ struct iwl_tx_cmd {
 	u8 initial_rate_index;
 	u8 reserved2;
 	u8 key[16];
-	__le16 next_frame_flags;
-	__le16 reserved3;
+	__le32 reserved3;
 	__le32 life_time;
 	__le32 dram_lsb_ptr;
 	u8 dram_msb_ptr;
@@ -250,7 +238,7 @@ struct iwl_tx_cmd {
 	u8 data_retry_limit;
 	u8 tid_tspec;
 	__le16 pm_frame_timeout;
-	__le16 driver_txop;
+	__le16 reserved4;
 	u8 payload[0];
 	struct ieee80211_hdr hdr[0];
 } __packed; /* TX_CMD_API_S_VER_3 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 4f7cff5..fa87a4b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -131,7 +131,6 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	    !is_multicast_ether_addr(ieee80211_get_DA(hdr)))
 		tx_flags |= TX_CMD_FLG_PROT_REQUIRE;
 
-	tx_cmd->driver_txop = 0;
 	tx_cmd->tx_flags = cpu_to_le32(tx_flags);
 	/* Total # bytes to be transmitted */
 	tx_cmd->len = cpu_to_le16((u16)skb->len);
-- 
1.8.3.2

