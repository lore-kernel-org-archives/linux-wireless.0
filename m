Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbbHDU7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/37] iwlwifi: mvm: Enable Rx Checksum hw
Date: Tue,  4 Aug 2015 23:43:17 +0300
Message-Id: <1438721007-23283-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225926_524933_F0404B03)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

TCP software implementation on the host requires extensive computing
power.  Offloading even some of the TCP/IP stack to the NIC might save
a significant overhead. In order to enable this feature on our hw,
we need to configure it first. Once done, we mark this capability,
to be advertised later to the OS via ieee80211_register_hw.
The driver Rx indications for TCP Checksum is integrated within the
standard Rx status. The driver responds to those indications as follows:
If the frame was tested by hw and checksum ok report CHECKSUM_UNNECESSARY.
Otherwise, report CHECKSUM_NONE.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-8000.c     |  1 +
 drivers/net/wireless/iwlwifi/iwl-config.h   |  2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h  |  2 ++
 drivers/net/wireless/iwlwifi/iwl-prph.h     |  3 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   | 31 +++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/fw.c       |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 ++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 10 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/rx.c       | 17 ++++++++++++++++
 9 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 0de5751..7caea69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -154,6 +154,7 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,		\
 	.d0i3 = true,							\
+	.features = NETIF_F_RXCSUM,					\
 	.non_shared_ant = ANT_A,					\
 	.dccm_offset = IWL8260_DCCM_OFFSET,				\
 	.dccm_len = IWL8260_DCCM_LEN,					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 08c14af..939fa22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -297,6 +297,7 @@ struct iwl_pwr_tx_backoff {
  *	mode set
  * @d0i3: device uses d0i3 instead of d3
  * @nvm_hw_section_num: the ID of the HW NVM section
+ * @features: hw features, any combination of feature_whitelist
  * @pwr_tx_backoffs: translation table between power limits and backoffs
  * @max_rx_agg_size: max RX aggregation size of the ADDBA request/response
  * @max_tx_agg_size: max TX aggregation size of the ADDBA request/response
@@ -348,6 +349,7 @@ struct iwl_cfg {
 	bool no_power_up_nic_in_init;
 	const char *default_nvm_file_B_step;
 	const char *default_nvm_file_C_step;
+	netdev_features_t features;
 	unsigned int max_rx_agg_size;
 	bool disable_dummy_notification;
 	unsigned int max_tx_agg_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 884825c..926e456 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -297,6 +297,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switching
  * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
  * @IWL_UCODE_TLV_CAPA_DC2DC_SUPPORT: supports DC2DC Command
+ * @IWL_UCODE_TLV_CAPA_CSUM_SUPPORT: supports TCP Checksum Offload
  * @IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS: support radio and beacon statistics
  * @IWL_UCODE_TLV_CAPA_BT_COEX_PLCR: enabled BT Coex packet level co-running
  * @IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC: ucode supports LAR updates with different
@@ -320,6 +321,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		= (__force iwl_ucode_tlv_capa_t)13,
 	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)18,
 	IWL_UCODE_TLV_CAPA_DC2DC_CONFIG_SUPPORT		= (__force iwl_ucode_tlv_capa_t)19,
+	IWL_UCODE_TLV_CAPA_CSUM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)21,
 	IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS		= (__force iwl_ucode_tlv_capa_t)22,
 	IWL_UCODE_TLV_CAPA_BT_COEX_PLCR			= (__force iwl_ucode_tlv_capa_t)28,
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index a846904..cd98b9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -292,6 +292,9 @@
 
 /*********************** END TX SCHEDULER *************************************/
 
+/* tcp checksum offload */
+#define RX_EN_CSUM		(0x00a00d88)
+
 /* Oscillator clock */
 #define OSC_CLK				(0xa04068)
 #define OSC_CLK_FORCE_CONTROL		(0x8)
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 2bc33fa..4e29c11 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1085,10 +1085,33 @@ struct iwl_rx_phy_info {
 	__le16 frame_time;
 } __packed;
 
+/*
+ * TCP offload Rx assist info
+ *
+ * bits 0:3 - reserved
+ * bits 4:7 - MIC CRC length
+ * bits 8:12 - MAC header length
+ * bit 13 - Padding indication
+ * bit 14 - A-AMSDU indication
+ * bit 15 - Offload enabled
+ */
+enum iwl_csum_rx_assist_info {
+	CSUM_RXA_RESERVED_MASK	= 0x000f,
+	CSUM_RXA_MICSIZE_MASK	= 0x00f0,
+	CSUM_RXA_HEADERLEN_MASK	= 0x1f00,
+	CSUM_RXA_PADD		= BIT(13),
+	CSUM_RXA_AMSDU		= BIT(14),
+	CSUM_RXA_ENA		= BIT(15)
+};
+
+/**
+ * struct iwl_rx_mpdu_res_start - phy info
+ * @assist: see CSUM_RX_ASSIST_ above
+ */
 struct iwl_rx_mpdu_res_start {
 	__le16 byte_count;
-	__le16 reserved;
-} __packed;
+	__le16 assist;
+} __packed; /* _RX_MPDU_RES_START_API_S_VER_2 */
 
 /**
  * enum iwl_rx_phy_flags - to parse %iwl_rx_phy_info phy_flags
@@ -1141,6 +1164,8 @@ enum iwl_rx_phy_flags {
  * @RX_MPDU_RES_STATUS_EXT_IV_BIT_CMP:
  * @RX_MPDU_RES_STATUS_KEY_ID_CMP_BIT:
  * @RX_MPDU_RES_STATUS_ROBUST_MNG_FRAME: this frame is an 11w management frame
+ * @RX_MPDU_RES_STATUS_CSUM_DONE: checksum was done by the hw
+ * @RX_MPDU_RES_STATUS_CSUM_OK: checksum found no errors
  * @RX_MPDU_RES_STATUS_HASH_INDEX_MSK:
  * @RX_MPDU_RES_STATUS_STA_ID_MSK:
  * @RX_MPDU_RES_STATUS_RRF_KILL:
@@ -1170,6 +1195,8 @@ enum iwl_mvm_rx_status {
 	RX_MPDU_RES_STATUS_EXT_IV_BIT_CMP		= BIT(13),
 	RX_MPDU_RES_STATUS_KEY_ID_CMP_BIT		= BIT(14),
 	RX_MPDU_RES_STATUS_ROBUST_MNG_FRAME		= BIT(15),
+	RX_MPDU_RES_STATUS_CSUM_DONE			= BIT(16),
+	RX_MPDU_RES_STATUS_CSUM_OK			= BIT(17),
 	RX_MPDU_RES_STATUS_HASH_INDEX_MSK		= (0x3F0000),
 	RX_MPDU_RES_STATUS_STA_ID_MSK			= (0x1f000000),
 	RX_MPDU_RES_STATUS_RRF_KILL			= BIT(29),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index e905c07..ebda61bc6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -752,6 +752,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 			goto error;
 	}
 
+	if (iwl_mvm_is_csum_supported(mvm) &&
+	    mvm->cfg->features & NETIF_F_RXCSUM)
+		iwl_trans_write_prph(mvm->trans, RX_EN_CSUM, 0x3);
+
 	/* allow FW/transport low power modes if not during restart */
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 45e9913..4264c52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -649,6 +649,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
 
+	hw->netdev_features |= mvm->cfg->features;
+	if (!iwl_mvm_is_csum_supported(mvm))
+		hw->netdev_features &= ~NETIF_F_RXCSUM;
+
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret)
 		iwl_mvm_leds_exit(mvm);
@@ -1651,6 +1655,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
+	mvmvif->features |= hw->netdev_features;
+
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
 		goto out_release;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 767880b..c1f84ec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -357,6 +357,7 @@ struct iwl_mvm_vif_bf_data {
  *	# of received beacons accumulated over FW restart, and the current
  *	average signal of beacons retrieved from the firmware
  * @csa_failed: CSA failed to schedule time event, report an error later
+ * @features: hw features active for this vif
  */
 struct iwl_mvm_vif {
 	struct iwl_mvm *mvm;
@@ -437,6 +438,9 @@ struct iwl_mvm_vif {
 	/* Indicates that CSA countdown may be started */
 	bool csa_countdown;
 	bool csa_failed;
+
+	/* TCP Checksum Offload */
+	netdev_features_t features;
 };
 
 static inline struct iwl_mvm_vif *
@@ -943,6 +947,12 @@ static inline bool iwl_mvm_bt_is_rrc_supported(struct iwl_mvm *mvm)
 		IWL_MVM_BT_COEX_RRC;
 }
 
+static inline bool iwl_mvm_is_csum_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_capa(&mvm->fw->ucode_capa,
+			   IWL_UCODE_TLV_CAPA_CSUM_SUPPORT);
+}
+
 extern const u8 iwl_mvm_ac_to_tx_fifo[];
 
 struct iwl_rate_info {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 73054dd..6574614 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -61,6 +61,7 @@
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
+#include <linux/skbuff.h>
 #include "iwl-trans.h"
 #include "mvm.h"
 #include "fw-api.h"
@@ -234,6 +235,19 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
+			    struct sk_buff *skb,
+			    u32 status)
+{
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
+
+	if (mvmvif->features & NETIF_F_RXCSUM &&
+	    status & RX_MPDU_RES_STATUS_CSUM_DONE &&
+	    status & RX_MPDU_RES_STATUS_CSUM_OK)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+}
+
 /*
  * iwl_mvm_rx_rx_mpdu - REPLY_RX_MPDU_CMD handler
  *
@@ -362,6 +376,9 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		}
 	}
 
+	if (sta && ieee80211_is_data(hdr->frame_control))
+		iwl_mvm_rx_csum(sta, skb, rx_pkt_status);
+
 	rcu_read_unlock();
 
 	/* set the preamble flag if appropriate */
-- 
2.1.4

