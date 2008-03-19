Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbYCSXtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 19:49:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/7] iwlwifi-2.6: RX status translation to old scheme
Date: Wed, 19 Mar 2008 16:41:42 -0700
Message-Id: <1205970106-22196-4-git-send-email-reinette.chatre@intel.com> (sfid-20080319_235021_038717_FBE7D853)
In-Reply-To: <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
References: <1205970106-22196-1-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-2-git-send-email-reinette.chatre@intel.com>
 <1205970106-22196-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds translation for the RX status of an incoming packet.
The incoming status has to be translated to the old scheme in order to know
if the decryption has been done, MIC failure has occured, TTAK is valid etc...
This translation is mandatory for all RX packets when using 5300 and for
all HT packets using 4965.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    9 +++
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   66 ++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |    6 ++
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 085d813..1d82f10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -890,6 +890,10 @@ struct iwl4965_rx_frame_hdr {
 #define RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
 #define RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
 #define RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_ERR	(0x7 << 8)
+
+#define RX_RES_STATUS_STATION_FOUND	(1<<6)
+#define RX_RES_STATUS_NO_STATION_INFO_MISMATCH	(1<<7)
 
 #define RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
 #define RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
@@ -897,6 +901,11 @@ struct iwl4965_rx_frame_hdr {
 #define RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
 #define RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
 
+#define RX_MPDU_RES_STATUS_ICV_OK	(0x20)
+#define RX_MPDU_RES_STATUS_MIC_OK	(0x40)
+#define RX_MPDU_RES_STATUS_TTAK_OK	(1 << 7)
+#define RX_MPDU_RES_STATUS_DEC_DONE_MSK	(0x800)
+
 struct iwl4965_rx_frame_end {
 	__le32 status;
 	__le64 timestamp;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5fe42ae..376968f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3401,6 +3401,65 @@ static void iwl_update_rx_stats(struct iwl_priv *priv, u16 fc, u16 len)
 	priv->rx_stats[idx].bytes += len;
 }
 
+static u32 iwl4965_translate_rx_status(u32 decrypt_in)
+{
+	u32 decrypt_out = 0;
+
+	if ((decrypt_in & RX_RES_STATUS_STATION_FOUND) ==
+					RX_RES_STATUS_STATION_FOUND)
+		decrypt_out |= (RX_RES_STATUS_STATION_FOUND |
+				RX_RES_STATUS_NO_STATION_INFO_MISMATCH);
+
+	decrypt_out |= (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK);
+
+	/* packet was not encrypted */
+	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
+					RX_RES_STATUS_SEC_TYPE_NONE)
+		return decrypt_out;
+
+	/* packet was encrypted with unknown alg */
+	if ((decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) ==
+					RX_RES_STATUS_SEC_TYPE_ERR)
+		return decrypt_out;
+
+	/* decryption was not done in HW */
+	if ((decrypt_in & RX_MPDU_RES_STATUS_DEC_DONE_MSK) !=
+					RX_MPDU_RES_STATUS_DEC_DONE_MSK)
+		return decrypt_out;
+
+	switch (decrypt_in & RX_RES_STATUS_SEC_TYPE_MSK) {
+
+	case RX_RES_STATUS_SEC_TYPE_CCMP:
+		/* alg is CCM: check MIC only */
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_MIC_OK))
+			/* Bad MIC */
+			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
+		else
+			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
+
+		break;
+
+	case RX_RES_STATUS_SEC_TYPE_TKIP:
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_TTAK_OK)) {
+			/* Bad TTAK */
+			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
+			break;
+		}
+		/* fall through if TTAK OK */
+	default:
+		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
+			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
+		else
+			decrypt_out |= RX_RES_STATUS_DECRYPT_OK;
+		break;
+	};
+
+	IWL_DEBUG_RX("decrypt_in:0x%x  decrypt_out = 0x%x\n",
+					decrypt_in, decrypt_out);
+
+	return decrypt_out;
+}
+
 static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 				       int include_phy,
 				       struct iwl4965_rx_mem_buffer *rxb,
@@ -3414,6 +3473,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	__le32 *rx_end;
 	unsigned int skblen;
 	u32 ampdu_status;
+	u32 ampdu_status_legacy;
 
 	if (!include_phy && priv->last_phy_res[0])
 		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
@@ -3450,6 +3510,12 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	ampdu_status = le32_to_cpu(*rx_end);
 	skblen = ((u8 *) rx_end - (u8 *) & pkt->u.raw[0]) + sizeof(u32);
 
+	if (!include_phy) {
+		/* New status scheme, need to translate */
+		ampdu_status_legacy = ampdu_status;
+		ampdu_status = iwl4965_translate_rx_status(ampdu_status);
+	}
+
 	/* start from MAC */
 	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt);
 	skb_put(rxb->skb, len);	/* end where data ends */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3d1f43a..9d4cd8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2848,6 +2848,12 @@ void iwl4965_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
 	IWL_DEBUG_RX("decrypt_res:0x%x\n", decrypt_res);
 	switch (decrypt_res & RX_RES_STATUS_SEC_TYPE_MSK) {
 	case RX_RES_STATUS_SEC_TYPE_TKIP:
+		/* The uCode has got a bad phase 1 Key, pushes the packet.
+		 * Decryption will be done in SW. */
+		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
+		    RX_RES_STATUS_BAD_KEY_TTAK)
+			break;
+
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_ICV_MIC)
 			stats->flag |= RX_FLAG_MMIC_ERROR;
-- 
1.5.3.4

