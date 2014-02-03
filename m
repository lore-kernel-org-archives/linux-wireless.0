Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60367 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaBCU6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:50 -0500
Received: by mail-ee0-f41.google.com with SMTP id e51so1758944eek.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:49 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/62] iwlwifi: mvm: add basic bcast filtering implementation
Date: Mon,  3 Feb 2014 22:57:29 +0200
Message-Id: <1391461088-8082-23-git-send-email-egrumbach@gmail.com> (sfid-20140203_220007_707025_E40BE4B7)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Broadcast filtering allows dropping broadcast
frames that don't match the configured patterns.

Use predefined filters, and configure them for
each associated station vif.

There is no need to optimize and attach the same
filter to multiple vifs, as a following patch
will configure each filter to have per-vif unique
values.

Configure the bcast filtering on assoc changes.

Add a new IWLWIFI_BCAST_FILTERING Kconfig option
in order to enable broadcast filtering.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |   13 +++
 drivers/net/wireless/iwlwifi/iwl-fw.h       |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |   85 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  116 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    5 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    1 +
 6 files changed, 222 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 3eb2102..7fc9881 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -128,3 +128,16 @@ config IWLWIFI_DEVICE_TRACING
 	  If unsure, say Y so we can help you better when problems
 	  occur.
 endmenu
+
+config IWLWIFI_BCAST_FILTERING
+	bool "Enable broadcast filtering"
+	depends on IWLWIFI
+	help
+	  Say Y here to enable default bcast filtering configuration.
+
+	  Enabling broadcast filtering will drop any incoming wireless
+	  broadcast frames, except some very specific predefined
+	  patterns (e.g. incoming arp requests).
+
+	  If unsure, don't enable this option, as some programs might
+	  expect incoming broadcasts for their normal operations.
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 7263277..b0090e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -95,6 +95,7 @@
  * @IWL_UCODE_TLV_FLAGS_P2P_PS: P2P client power save is supported (only on a
  *	single bound interface).
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
+ * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
  * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
  */
 enum iwl_ucode_tlv_flag {
@@ -120,6 +121,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P_PS		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
+	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
 	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
 };
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 21ee59e..32844e3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -191,6 +191,7 @@ enum {
 	REPLY_DEBUG_CMD = 0xf0,
 	DEBUG_LOG_MSG = 0xf7,
 
+	BCAST_FILTER_CMD = 0xcf,
 	MCAST_FILTER_CMD = 0xd0,
 
 	/* D3 commands/notifications */
@@ -1156,6 +1157,90 @@ struct iwl_mcast_filter_cmd {
 	u8 addr_list[0];
 } __packed; /* MCAST_FILTERING_CMD_API_S_VER_1 */
 
+#define MAX_BCAST_FILTERS 8
+#define MAX_BCAST_FILTER_ATTRS 2
+
+/**
+ * enum iwl_mvm_bcast_filter_attr_offset - written by fw for each Rx packet
+ * @BCAST_FILTER_OFFSET_PAYLOAD_START: offset is from payload start.
+ * @BCAST_FILTER_OFFSET_IP_END: offset is from ip header end (i.e.
+ *	start of ip payload).
+ */
+enum iwl_mvm_bcast_filter_attr_offset {
+	BCAST_FILTER_OFFSET_PAYLOAD_START = 0,
+	BCAST_FILTER_OFFSET_IP_END = 1,
+};
+
+/**
+ * struct iwl_fw_bcast_filter_attr - broadcast filter attribute
+ * @offset_type:	&enum iwl_mvm_bcast_filter_attr_offset.
+ * @offset:	starting offset of this pattern.
+ * @val:		value to match - big endian (MSB is the first
+ *		byte to match from offset pos).
+ * @mask:	mask to match (big endian).
+ */
+struct iwl_fw_bcast_filter_attr {
+	u8 offset_type;
+	u8 offset;
+	__le16 reserved1;
+	__be32 val;
+	__be32 mask;
+} __packed; /* BCAST_FILTER_ATT_S_VER_1 */
+
+/**
+ * enum iwl_mvm_bcast_filter_frame_type - filter frame type
+ * @BCAST_FILTER_FRAME_TYPE_ALL: consider all frames.
+ * @BCAST_FILTER_FRAME_TYPE_IPV4: consider only ipv4 frames
+ */
+enum iwl_mvm_bcast_filter_frame_type {
+	BCAST_FILTER_FRAME_TYPE_ALL = 0,
+	BCAST_FILTER_FRAME_TYPE_IPV4 = 1,
+};
+
+/**
+ * struct iwl_fw_bcast_filter - broadcast filter
+ * @discard: discard frame (1) or let it pass (0).
+ * @frame_type: &enum iwl_mvm_bcast_filter_frame_type.
+ * @num_attrs: number of valid attributes in this filter.
+ * @attrs: attributes of this filter. a filter is considered matched
+ *	only when all its attributes are matched (i.e. AND relationship)
+ */
+struct iwl_fw_bcast_filter {
+	u8 discard;
+	u8 frame_type;
+	u8 num_attrs;
+	u8 reserved1;
+	struct iwl_fw_bcast_filter_attr attrs[MAX_BCAST_FILTER_ATTRS];
+} __packed; /* BCAST_FILTER_S_VER_1 */
+
+/**
+ * struct iwl_fw_bcast_mac - per-mac broadcast filtering configuration.
+ * @default_discard: default action for this mac (discard (1) / pass (0)).
+ * @attached_filters: bitmap of relevant filters for this mac.
+ */
+struct iwl_fw_bcast_mac {
+	u8 default_discard;
+	u8 reserved1;
+	__le16 attached_filters;
+} __packed; /* BCAST_MAC_CONTEXT_S_VER_1 */
+
+/**
+ * struct iwl_bcast_filter_cmd - broadcast filtering configuration
+ * @disable: enable (0) / disable (1)
+ * @max_bcast_filters: max number of filters (MAX_BCAST_FILTERS)
+ * @max_macs: max number of macs (NUM_MAC_INDEX_DRIVER)
+ * @filters: broadcast filters
+ * @macs: broadcast filtering configuration per-mac
+ */
+struct iwl_bcast_filter_cmd {
+	u8 disable;
+	u8 max_bcast_filters;
+	u8 max_macs;
+	u8 reserved1;
+	struct iwl_fw_bcast_filter filters[MAX_BCAST_FILTERS];
+	struct iwl_fw_bcast_mac macs[NUM_MAC_INDEX_DRIVER];
+} __packed; /* BCAST_FILTERING_HCMD_API_S_VER_1 */
+
 struct mvm_statistics_dbg {
 	__le32 burst_check;
 	__le32 burst_count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 5b9cfe1..08b8051 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -872,6 +872,121 @@ out:
 	*total_flags = 0;
 }
 
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+struct iwl_bcast_iter_data {
+	struct iwl_mvm *mvm;
+	struct iwl_bcast_filter_cmd *cmd;
+	u8 current_filter;
+};
+
+static void
+iwl_mvm_set_bcast_filter(struct ieee80211_vif *vif,
+			 const struct iwl_fw_bcast_filter *in_filter,
+			 struct iwl_fw_bcast_filter *out_filter)
+{
+	struct iwl_fw_bcast_filter_attr *attr;
+	int i;
+
+	memcpy(out_filter, in_filter, sizeof(*out_filter));
+
+	for (i = 0; i < ARRAY_SIZE(out_filter->attrs); i++) {
+		attr = &out_filter->attrs[i];
+
+		if (!attr->mask)
+			break;
+
+		out_filter->num_attrs++;
+	}
+}
+
+static void iwl_mvm_bcast_filter_iterator(void *_data, u8 *mac,
+					  struct ieee80211_vif *vif)
+{
+	struct iwl_bcast_iter_data *data = _data;
+	struct iwl_mvm *mvm = data->mvm;
+	struct iwl_bcast_filter_cmd *cmd = data->cmd;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_fw_bcast_mac *bcast_mac;
+	int i;
+
+	if (WARN_ON(mvmvif->id >= ARRAY_SIZE(cmd->macs)))
+		return;
+
+	bcast_mac = &cmd->macs[mvmvif->id];
+
+	/* enable filtering only for associated stations */
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->bss_conf.assoc)
+		return;
+
+	bcast_mac->default_discard = 1;
+
+	/* copy all configured filters */
+	for (i = 0; mvm->bcast_filters[i].attrs[0].mask; i++) {
+		/*
+		 * Make sure we don't exceed our filters limit.
+		 * if there is still a valid filter to be configured,
+		 * be on the safe side and just allow bcast for this mac.
+		 */
+		if (WARN_ON_ONCE(data->current_filter >=
+				 ARRAY_SIZE(cmd->filters))) {
+			bcast_mac->default_discard = 0;
+			bcast_mac->attached_filters = 0;
+			break;
+		}
+
+		iwl_mvm_set_bcast_filter(vif,
+					 &mvm->bcast_filters[i],
+					 &cmd->filters[data->current_filter]);
+
+		/* skip current filter if it contains no attributes */
+		if (!cmd->filters[data->current_filter].num_attrs)
+			continue;
+
+		/* attach the filter to current mac */
+		bcast_mac->attached_filters |=
+				cpu_to_le16(BIT(data->current_filter));
+
+		data->current_filter++;
+	}
+}
+
+static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif)
+{
+	/* initialize cmd to pass broadcasts on all vifs */
+	struct iwl_bcast_filter_cmd cmd = {
+		.disable = 0,
+		.max_bcast_filters = ARRAY_SIZE(cmd.filters),
+		.max_macs = ARRAY_SIZE(cmd.macs),
+	};
+	struct iwl_bcast_iter_data iter_data = {
+		.mvm = mvm,
+		.cmd = &cmd,
+	};
+
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING))
+		return 0;
+
+	/* if no filters are configured, do nothing */
+	if (!mvm->bcast_filters)
+		return 0;
+
+	/* configure and attach these filters for each associated sta vif */
+	ieee80211_iterate_active_interfaces(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_bcast_filter_iterator, &iter_data);
+
+	return iwl_mvm_send_cmd_pdu(mvm, BCAST_FILTER_CMD, CMD_SYNC,
+				    sizeof(cmd), &cmd);
+}
+#else
+static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
+						 struct ieee80211_vif *vif)
+{
+	return 0;
+}
+#endif
+
 static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_bss_conf *bss_conf,
@@ -944,6 +1059,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		}
 
 		iwl_mvm_recalc_multicast(mvm);
+		iwl_mvm_configure_bcast_filter(mvm, vif);
 
 		/* reset rssi values */
 		mvmvif->bf_data.ave_beacon_signal = 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 00bc4ce..2da17d1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -497,6 +497,11 @@ struct iwl_mvm {
 	/* rx chain antennas set through debugfs for the scan command */
 	u8 scan_rx_ant;
 
+#ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+	/* broadcast filters to configure for each associated station */
+	const struct iwl_fw_bcast_filter *bcast_filters;
+#endif
+
 	/* Internal station */
 	struct iwl_mvm_int_sta aux_sta;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index fdadfe9..24afbd6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -313,6 +313,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BT_PROFILE_NOTIFICATION),
 	CMD(BT_CONFIG),
 	CMD(MCAST_FILTER_CMD),
+	CMD(BCAST_FILTER_CMD),
 	CMD(REPLY_SF_CFG_CMD),
 	CMD(REPLY_BEACON_FILTERING_CMD),
 	CMD(REPLY_THERMAL_MNG_BACKOFF),
-- 
1.7.9.5

