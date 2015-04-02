Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbbDBGm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:29 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/31] iwlwifi: fix spelling errors
Date: Thu,  2 Apr 2015 09:41:16 +0300
Message-Id: <1427956879-11725-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090418_779433_A1D8A8F1)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Fix spelling error across the driver.
Modified only comments and prints.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h        |  2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c           |  2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h           |  2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c   |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h            |  2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |  2 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-phy-db.c        |  2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h         | 12 ++++++------
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h     |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h    |  2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   | 14 +++++++-------
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  2 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c            |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c           |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.h           |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/time-event.c    |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.h    |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  4 ++--
 21 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index bbed8fc..07e999a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -228,7 +228,7 @@ struct iwl_pwr_tx_backoff {
 
 /**
  * struct iwl_cfg
- * @name: Offical name of the device
+ * @name: Official name of the device
  * @fw_name_pre: Firmware filename prefix. The api version and extension
  *	(.ucode) will be added to filename before loading from disk. The
  *	filename is constructed as fw_name_pre<api>.ucode.
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index b8e5690..7783ac8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -145,7 +145,7 @@ static struct iwlwifi_opmode_table {
 #define IWL_DEFAULT_SCAN_CHANNELS 40
 
 /*
- * struct fw_sec: Just for the image parsing proccess.
+ * struct fw_sec: Just for the image parsing process.
  * For the fw storage we are using struct fw_desc.
  */
 struct fw_sec {
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 67a3a24..cda746b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -123,7 +123,7 @@ struct iwl_cfg;
  * starts the driver: fetches the firmware. This should be called by bus
  * specific system flows implementations. For example, the bus specific probe
  * function should do bus related operations only, and then call to this
- * function. It returns the driver object or %NULL if an error occured.
+ * function. It returns the driver object or %NULL if an error occurred.
  */
 struct iwl_drv *iwl_drv_start(struct iwl_trans *trans,
 			      const struct iwl_cfg *cfg);
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
index 25d0105..219ca8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
@@ -248,7 +248,7 @@ static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
 	otpgp = iwl_read32(trans, CSR_OTP_GP_REG);
 	if (otpgp & CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK) {
 		/* stop in this case */
-		/* set the uncorrectable OTP ECC bit for acknowledgement */
+		/* set the uncorrectable OTP ECC bit for acknowledgment */
 		iwl_set_bit(trans, CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_ECC_UNCORR_STATUS_MSK);
 		IWL_ERR(trans, "Uncorrectable OTP ECC error, abort OTP read\n");
@@ -256,7 +256,7 @@ static int iwl_read_otp_word(struct iwl_trans *trans, u16 addr,
 	}
 	if (otpgp & CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK) {
 		/* continue in this case */
-		/* set the correctable OTP ECC bit for acknowledgement */
+		/* set the correctable OTP ECC bit for acknowledgment */
 		iwl_set_bit(trans, CSR_OTP_GP_REG,
 			    CSR_OTP_GP_REG_ECC_CORR_STATUS_MSK);
 		IWL_ERR(trans, "Correctable OTP ECC error, continue read\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 1f7f15e..d45dc02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -445,7 +445,7 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 #define RX_LOW_WATERMARK 8
 
 /**
- * struct iwl_rb_status - reseve buffer status
+ * struct iwl_rb_status - reserve buffer status
  * 	host memory mapped FH registers
  * @closed_rb_num [0:11] - Indicates the index of the RB which was closed
  * @closed_fr_num [0:11] - Indicates the index of the RX Frame which was closed
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index 8b926ec..3765285 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -183,7 +183,7 @@ struct iwl_fw_error_dump_info {
  * struct iwl_fw_error_dump_fw_mon - FW monitor data
  * @fw_mon_wr_ptr: the position of the write pointer in the cyclic buffer
  * @fw_mon_base_ptr: base pointer of the data
- * @fw_mon_cycle_cnt: number of wrap arounds
+ * @fw_mon_cycle_cnt: number of wraparounds
  * @reserved: for future use
  * @data: captured data
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 823938e..cc789cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -191,7 +191,7 @@ struct iwl_ucode_capa {
  * enum iwl_ucode_tlv_flag - ucode API flags
  * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
  *	was a separate TLV but moved here to save space.
- * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
+ * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behavior on hidden SSID,
  *	treats good CRC threshold as a boolean
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
  * @IWL_UCODE_TLV_FLAGS_P2P: This uCode image supports P2P.
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 17de6d4..ce1cdd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -94,7 +94,7 @@ struct iwl_cfg;
  * The operational mode has a very simple life cycle.
  *
  *	1) The driver layer (iwl-drv.c) chooses the op_mode based on the
- *	   capabilities advertized by the fw file (in TLV format).
+ *	   capabilities advertised by the fw file (in TLV format).
  *	2) The driver layer starts the op_mode (ops->start)
  *	3) The op_mode registers mac80211
  *	4) The op_mode is governed by mac80211
@@ -116,7 +116,7 @@ struct iwl_cfg;
  *	May sleep
  * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
  *	HCMD this Rx responds to. Can't sleep.
- * @napi_add: NAPI initialisation. The transport is fully responsible for NAPI,
+ * @napi_add: NAPI initialization. The transport is fully responsible for NAPI,
  *	but the higher layers need to know about it (in particular mac80211 to
  *	to able to call the right NAPI RX functions); this function is needed
  *	to eventually call netif_napi_add() with higher layer involvement.
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index e893c6e..a105455 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -125,7 +125,7 @@ struct iwl_phy_db_chg_txp {
 } __packed;
 
 /*
- * phy db - Receieve phy db chunk after calibrations
+ * phy db - Receive phy db chunk after calibrations
  */
 struct iwl_calib_res_notif_phy_db {
 	__le16 type;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 11ac5c5..6dfed12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -77,10 +77,10 @@
 /**
  * DOC: Transport layer - what is it ?
  *
- * The tranport layer is the layer that deals with the HW directly. It provides
+ * The transport layer is the layer that deals with the HW directly. It provides
  * an abstraction of the underlying HW to the upper layer. The transport layer
  * doesn't provide any policy, algorithm or anything of this kind, but only
- * mechanisms to make the HW do something.It is not completely stateless but
+ * mechanisms to make the HW do something. It is not completely stateless but
  * close to it.
  * We will have an implementation for each different supported bus.
  */
@@ -111,10 +111,10 @@
 /**
  * DOC: Host command section
  *
- * A host command is a commaned issued by the upper layer to the fw. There are
+ * A host command is a command issued by the upper layer to the fw. There are
  * several versions of fw that have several APIs. The transport layer is
  * completely agnostic to these differences.
- * The transport does provide helper functionnality (i.e. SYNC / ASYNC mode),
+ * The transport does provide helper functionality (i.e. SYNC / ASYNC mode),
  */
 #define SEQ_TO_QUEUE(s)	(((s) >> 8) & 0x1f)
 #define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
@@ -195,7 +195,7 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  * @CMD_WANT_SKB: Not valid with CMD_ASYNC. The caller needs the buffer of
  *	the response. The caller needs to call iwl_free_resp when done.
  * @CMD_HIGH_PRIO: The command is high priority - it goes to the front of the
- *	command queue, but after other high priority commands. valid only
+ *	command queue, but after other high priority commands. Valid only
  *	with CMD_ASYNC.
  * @CMD_SEND_IN_IDLE: The command should be sent even when the trans is idle.
  * @CMD_MAKE_TRANS_IDLE: The command response should mark the trans as idle.
@@ -582,7 +582,7 @@ enum iwl_d0i3_mode {
  * @cfg - pointer to the configuration
  * @status: a bit-mask of transport status flags
  * @dev - pointer to struct device * that represents the device
- * @hw_id: a u32 with the ID of the device / subdevice.
+ * @hw_id: a u32 with the ID of the device / sub-device.
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
  * @pm_support: set to true in start_hw if link pm is supported
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 6d3bea5..d7658d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -132,7 +132,7 @@ struct iwl_proto_offload_cmd_common {
  * @solicited_node_ipv6_addr: broken -- solicited node address exists
  *	for each target address
  * @target_ipv6_addr: our target addresses
- * @ndp_mac_addr: neighbor soliciation response MAC address
+ * @ndp_mac_addr: neighbor solicitation response MAC address
  */
 struct iwl_proto_offload_cmd_v1 {
 	struct iwl_proto_offload_cmd_common common;
@@ -150,7 +150,7 @@ struct iwl_proto_offload_cmd_v1 {
  * @solicited_node_ipv6_addr: broken -- solicited node address exists
  *	for each target address
  * @target_ipv6_addr: our target addresses
- * @ndp_mac_addr: neighbor soliciation response MAC address
+ * @ndp_mac_addr: neighbor solicitation response MAC address
  */
 struct iwl_proto_offload_cmd_v2 {
 	struct iwl_proto_offload_cmd_common common;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
index aabaedd..f3f3ee0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
@@ -255,7 +255,7 @@ struct iwl_mac_data_p2p_dev {
 /**
  * enum iwl_mac_filter_flags - MAC context filter flags
  * @MAC_FILTER_IN_PROMISC: accept all data frames
- * @MAC_FILTER_IN_CONTROL_AND_MGMT: pass all mangement and
+ * @MAC_FILTER_IN_CONTROL_AND_MGMT: pass all management and
  *	control frames to the host
  * @MAC_FILTER_ACCEPT_GRP: accept multicast frames
  * @MAC_FILTER_DIS_DECRYPT: don't decrypt unicast frames
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index a5fbbd6..4f81dcf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -103,7 +103,7 @@ struct iwl_ssid_ie {
  * @SCAN_COMP_STATUS_ERR_COEX: medium was lost ot WiMax
  * @SCAN_COMP_STATUS_P2P_ACTION_OK: P2P public action frame TX was successful
  *	(not an error!)
- * @SCAN_COMP_STATUS_ITERATION_END: indicates end of one repeatition the driver
+ * @SCAN_COMP_STATUS_ITERATION_END: indicates end of one repetition the driver
  *	asked for
  * @SCAN_COMP_STATUS_ERR_ALLOC_TE: scan could not allocate time events
 */
@@ -187,11 +187,11 @@ enum scan_framework_client {
  * struct iwl_scan_offload_cmd - SCAN_REQUEST_FIXED_PART_API_S_VER_6
  * @scan_flags:		see enum iwl_scan_flags
  * @channel_count:	channels in channel list
- * @quiet_time:		dwell time, in milisiconds, on quiet channel
+ * @quiet_time:		dwell time, in milliseconds, on quiet channel
  * @quiet_plcp_th:	quiet channel num of packets threshold
  * @good_CRC_th:	passive to active promotion threshold
  * @rx_chain:		RXON rx chain.
- * @max_out_time:	max TUs to be out of assoceated channel
+ * @max_out_time:	max TUs to be out of associated channel
  * @suspend_time:	pause scan this TUs when returning to service channel
  * @flags:		RXON flags
  * @filter_flags:	RXONfilter
@@ -232,7 +232,7 @@ enum iwl_scan_offload_channel_flags {
  *	see enum iwl_scan_offload_channel_flags.
  * __le16 channel_number: channel number 1-13 etc.
  * __le16 iter_count: repetition count for the channel.
- * __le32 iter_interval: interval between two innteration on one channel.
+ * __le32 iter_interval: interval between two iterations on one channel.
  * u8 active_dwell.
  * u8 passive_dwell.
  */
@@ -275,8 +275,8 @@ enum iwl_scan_offload_band_selection {
 /**
  * iwl_scan_offload_profile - SCAN_OFFLOAD_PROFILE_S
  * @ssid_index:		index to ssid list in fixed part
- * @unicast_cipher:	encryption olgorithm to match - bitmap
- * @aut_alg:		authentication olgorithm to match - bitmap
+ * @unicast_cipher:	encryption algorithm to match - bitmap
+ * @aut_alg:		authentication algorithm to match - bitmap
  * @network_type:	enum iwl_scan_offload_network_type
  * @band_selection:	enum iwl_scan_offload_band_selection
  * @client_bitmap:	clients waiting for match - enum scan_framework_client
@@ -748,7 +748,7 @@ enum iwl_umac_scan_general_flags {
  * @flags:		bitmap - 0-19:	directed scan to i'th ssid.
  * @channel_num:	channel number 1-13 etc.
  * @iter_count:		repetition count for the channel.
- * @iter_interval:	interval between two scan interations on one channel.
+ * @iter_interval:	interval between two scan iterations on one channel.
  */
 struct iwl_scan_channel_cfg_umac {
 	__le32 flags;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2b7e6cb..629b8c7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -349,7 +349,7 @@ struct iwl_mvm_vif_bf_data {
  * @bcast_sta: station used for broadcast packets. Used by the following
  *  vifs: P2P_DEVICE, GO and AP.
  * @beacon_skb: the skb used to hold the AP/GO beacon template
- * @smps_requests: the SMPS requests of differents parts of the driver,
+ * @smps_requests: the SMPS requests of different parts of the driver,
  *	combined on update to yield the overall request to mac80211.
  * @beacon_stats: beacon statistics, containing the # of received beacons,
  *	# of received beacons accumulated over FW restart, and the current
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 192b74b..e68a475 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -67,7 +67,7 @@
 #include "fw-api.h"
 #include "mvm.h"
 
-/* Maps the driver specific channel width definition to the the fw values */
+/* Maps the driver specific channel width definition to the fw values */
 u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->width) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index e00b454..c1c8c56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3221,7 +3221,7 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 	lq_cmd->agg_frame_cnt_limit = mvmsta->max_agg_bufsize;
 
 	/*
-	 * In case of low latency, tell the firwmare to leave a frame in the
+	 * In case of low latency, tell the firmware to leave a frame in the
 	 * Tx Fifo so that it can start a transaction in the same TxOP. This
 	 * basically allows the firmware to send bursts.
 	 */
@@ -3722,7 +3722,7 @@ void iwl_mvm_rate_control_unregister(void)
 
 /**
  * iwl_mvm_tx_protection - Gets LQ command, change it to enable/disable
- * Tx protection, according to this rquest and previous requests,
+ * Tx protection, according to this request and previous requests,
  * and send the LQ command.
  * @mvmsta: The station
  * @enable: Enable Tx protection?
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 231e7dd..1845b79 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1714,8 +1714,8 @@ void iwl_mvm_sta_modify_disable_tx_ap(struct iwl_mvm *mvm,
 	mvm_sta->disable_tx = disable;
 
 	/*
-	 * Tell mac80211 to start/stop queueing tx for this station,
-	 * but don't stop queueing if there are still pending frames
+	 * Tell mac80211 to start/stop queuing tx for this station,
+	 * but don't stop queuing if there are still pending frames
 	 * for this station.
 	 */
 	if (disable || !atomic_read(&mvm->pending_frames[mvm_sta->sta_id]))
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index d8f48975..748f5dc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -150,7 +150,7 @@ struct iwl_mvm_vif;
  * DOC: station table - AP Station in STA mode
  *
  * %iwl_mvm_vif includes the index of the AP station in the fw's STA table:
- * %ap_sta_id. To get the point to the coresponsding %ieee80211_sta,
+ * %ap_sta_id. To get the point to the corresponding %ieee80211_sta,
  * &fw_id_to_mac_id can be used. Due to the way the fw works, we must not remove
  * the AP station from the fw before setting the MAC context as unassociated.
  * Hence, %fw_id_to_mac_id[%ap_sta_id] will be NULLed when the AP station is
@@ -209,14 +209,14 @@ struct iwl_mvm_vif;
  * When a trigger frame is received, mac80211 tells the driver to send frames
  * from the AMPDU queues or sends frames to non-aggregation queues itself,
  * depending on which ACs are delivery-enabled and what TID has frames to
- * transmit. Note that mac80211 has all the knowledege since all the non-agg
+ * transmit. Note that mac80211 has all the knowledge since all the non-agg
  * frames are buffered / filtered, and the driver tells mac80211 about agg
  * frames). The driver needs to tell the fw to let frames out even if the
  * station is asleep. This is done by %iwl_mvm_sta_modify_sleep_tx_count.
  *
  * When we receive a frame from that station with PM bit unset, the driver
  * needs to let the fw know that this station isn't asleep any more. This is
- * done by %iwl_mvm_sta_modify_ps_wake in response to mac80211 signalling the
+ * done by %iwl_mvm_sta_modify_ps_wake in response to mac80211 signaling the
  * station's wakeup.
  *
  * For a GO, the Service Period might be cut short due to an absence period
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index a32f612..bd51959 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -119,7 +119,7 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk)
 
 	/*
 	 * Flush the offchannel queue -- this is called when the time
-	 * event finishes or is cancelled, so that frames queued for it
+	 * event finishes or is canceled, so that frames queued for it
 	 * won't get stuck on the queue and be transmitted in the next
 	 * time event.
 	 * We have to send the command asynchronously since this cannot
@@ -778,7 +778,7 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 	 * Iterate over the list of aux roc time events and find the time
 	 * event that is associated with a BSS interface.
 	 * This assumes that a BSS interface can have only a single time
-	 * event at any given time and this time event coresponds to a ROC
+	 * event at any given time and this time event corresponds to a ROC
 	 * request
 	 */
 	list_for_each_entry(te_data, &mvm->aux_roc_te_list, list) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index 6f6b35d..de4fbc6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -147,7 +147,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
  * @vif: the virtual interface for which the session is issued
  *
  * This functions cancels the session protection which is an act of good
- * citizenship. If it is not needed any more it should be cancelled because
+ * citizenship. If it is not needed any more it should be canceled because
  * the other bindings wait for the medium during that time.
  * This funtions doesn't sleep.
  */
@@ -162,7 +162,7 @@ int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
 				struct iwl_device_cmd *cmd);
 
 /**
- * iwl_mvm_start_p2p_roc - start remain on channel for p2p device functionlity
+ * iwl_mvm_start_p2p_roc - start remain on channel for p2p device functionality
  * @mvm: the mvm component
  * @vif: the virtual interface for which the roc is requested. It is assumed
  * that the vif type is NL80211_IFTYPE_P2P_DEVICE
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 593a810..54e3556 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -122,7 +122,7 @@ int iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u8 id,
 }
 
 /*
- * We assume that the caller set the status to the sucess value
+ * We assume that the caller set the status to the success value
  */
 int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 			    u32 *status)
@@ -737,7 +737,7 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init)
 }
 
 /**
- * iwl_mvm_update_smps - Get a requst to change the SMPS mode
+ * iwl_mvm_update_smps - Get a request to change the SMPS mode
  * @req_type: The part of the driver who call for a change.
  * @smps_requests: The request to change the SMPS mode.
  *
-- 
1.9.1

