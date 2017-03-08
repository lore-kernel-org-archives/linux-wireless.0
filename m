Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751136AbdCHOgb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 09:36:31 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Daniel Mentz <danielmentz@google.com>
Subject: [PATCH 2/3] mwifiex: Use accessors routines for unaligned values
Date: Wed, 8 Mar 2017 19:17:08 +0530
Message-ID: <1488980829-6075-3-git-send-email-gbhat@marvell.com> (sfid-20170308_153728_871460_E724C184)
In-Reply-To: <1488980829-6075-1-git-send-email-gbhat@marvell.com>
References: <1488980829-6075-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Mentz <danielmentz@google.com>

Synopsys' ARCompact architecture does not support loading from or
storing values to unaligned memory locations. We saw a series of
misaligned access exceptions on ARC. To work around this issue, we bulk
replaced le16_to_cpu and le32_to_cpu with get_unaligned_le16 and
get_unaligned_le32, respectively. We also added le16_unaligned_add_cpu
which is similar to le16_add_cpu but works with unaligned values.

Signed-off-by: Daniel Mentz <danielmentz@google.com>
---
 drivers/net/wireless/marvell/mwifiex/11h.c     |  3 ++-
 drivers/net/wireless/marvell/mwifiex/ie.c      | 15 +++++++------
 drivers/net/wireless/marvell/mwifiex/main.h    |  2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c    | 26 +++++++++++++---------
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 30 +++++++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/util.h    |  5 +++++
 6 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index 43dccd5..366eb49 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -153,7 +153,8 @@ int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_CHAN_REPORT_REQUEST);
 	cmd->size = cpu_to_le16(S_DS_GEN);
-	le16_add_cpu(&cmd->size, sizeof(struct host_cmd_ds_chan_rpt_req));
+	le16_unaligned_add_cpu(&cmd->size,
+			       sizeof(struct host_cmd_ds_chan_rpt_req));
 
 	cr_req->chan_desc.start_freq = cpu_to_le16(MWIFIEX_A_BAND_START_FREQ);
 	cr_req->chan_desc.chan_num = radar_params->chandef->chan->hw_value;
diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index c488c30..922e3d6 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -131,9 +131,10 @@
 			       sizeof(struct mwifiex_ie));
 		}
 
-		le16_add_cpu(&ie_list->len,
-			     le16_to_cpu(priv->mgmt_ie[index].ie_length) +
-			     MWIFIEX_IE_HDR_SIZE);
+		le16_unaligned_add_cpu(&ie_list->len,
+				       le16_to_cpu(
+					    priv->mgmt_ie[index].ie_length) +
+				       MWIFIEX_IE_HDR_SIZE);
 		input_len -= tlv_len + MWIFIEX_IE_HDR_SIZE;
 	}
 
@@ -172,21 +173,21 @@
 		      le16_to_cpu(beacon_ie->ie_length);
 		memcpy(pos, beacon_ie, len);
 		pos += len;
-		le16_add_cpu(&ap_custom_ie->len, len);
+		le16_unaligned_add_cpu(&ap_custom_ie->len, len);
 	}
 	if (pr_ie) {
 		len = sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE +
 		      le16_to_cpu(pr_ie->ie_length);
 		memcpy(pos, pr_ie, len);
 		pos += len;
-		le16_add_cpu(&ap_custom_ie->len, len);
+		le16_unaligned_add_cpu(&ap_custom_ie->len, len);
 	}
 	if (ar_ie) {
 		len = sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE +
 		      le16_to_cpu(ar_ie->ie_length);
 		memcpy(pos, ar_ie, len);
 		pos += len;
-		le16_add_cpu(&ap_custom_ie->len, len);
+		le16_unaligned_add_cpu(&ap_custom_ie->len, len);
 	}
 
 	ret = mwifiex_update_autoindex_ies(priv, ap_custom_ie);
@@ -242,7 +243,7 @@ static int mwifiex_update_vs_ie(const u8 *ies, int ies_len,
 		vs_ie = (struct ieee_types_header *)vendor_ie;
 		memcpy(ie->ie_buffer + le16_to_cpu(ie->ie_length),
 		       vs_ie, vs_ie->len + 2);
-		le16_add_cpu(&ie->ie_length, vs_ie->len + 2);
+		le16_unaligned_add_cpu(&ie->ie_length, vs_ie->len + 2);
 		ie->mgmt_subtype_mask = cpu_to_le16(mask);
 		ie->ie_index = cpu_to_le16(MWIFIEX_AUTO_IDX_MASK);
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5c82972..f1cb875 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1359,7 +1359,7 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
  */
 static inline bool mwifiex_is_skb_mgmt_frame(struct sk_buff *skb)
 {
-	return (le32_to_cpu(*(__le32 *)skb->data) == PKT_TYPE_MGMT);
+	return (get_unaligned_le32(skb->data) == PKT_TYPE_MGMT);
 }
 
 /* This function retrieves channel closed for operation by Channel
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 1816916..8cd1234 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -691,8 +691,9 @@ enum cipher_suite {
 
 			/* Increment the TLV header length by the size
 			   appended */
-			le16_add_cpu(&chan_tlv_out->header.len,
-				     sizeof(chan_tlv_out->chan_scan_param));
+			le16_unaligned_add_cpu(&chan_tlv_out->header.len,
+					       sizeof(
+						chan_tlv_out->chan_scan_param));
 
 			/*
 			 * The tlv buffer length is set to the number of bytes
@@ -859,6 +860,7 @@ enum cipher_suite {
 	*scan_current_only = false;
 
 	if (user_scan_in) {
+		u8 tmpaddr[ETH_ALEN];
 
 		/* Default the ssid_filter flag to TRUE, set false under
 		   certain wildcard conditions and qualified by the existence
@@ -883,8 +885,10 @@ enum cipher_suite {
 		       user_scan_in->specific_bssid,
 		       sizeof(scan_cfg_out->specific_bssid));
 
+		memcpy(tmpaddr, scan_cfg_out->specific_bssid, ETH_ALEN);
+
 		if (adapter->ext_scan &&
-		    !is_zero_ether_addr(scan_cfg_out->specific_bssid)) {
+		    !is_zero_ether_addr(tmpaddr)) {
 			bssid_tlv =
 				(struct mwifiex_ie_types_bssid_list *)tlv_pos;
 			bssid_tlv->header.type = cpu_to_le16(TLV_TYPE_BSSID);
@@ -947,8 +951,9 @@ enum cipher_suite {
 		 *  truncate scan results.  That is not an issue with an SSID
 		 *  or BSSID filter applied to the scan results in the firmware.
 		 */
+		memcpy(tmpaddr, scan_cfg_out->specific_bssid, ETH_ALEN);
 		if ((i && ssid_filter) ||
-		    !is_zero_ether_addr(scan_cfg_out->specific_bssid))
+		    !is_zero_ether_addr(tmpaddr))
 			*filtered_scan = true;
 
 		if (user_scan_in->scan_chan_gap) {
@@ -1742,7 +1747,7 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 
 	if (*bytes_left >= sizeof(beacon_size)) {
 		/* Extract & convert beacon size from command buffer */
-		beacon_size = le16_to_cpu(*(__le16 *)(*bss_info));
+		beacon_size = get_unaligned_le16((*bss_info));
 		*bytes_left -= sizeof(beacon_size);
 		*bss_info += sizeof(beacon_size);
 	}
@@ -2369,8 +2374,9 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 			temp_chan = chan_list_tlv->chan_scan_param + chan_idx;
 
 			/* Increment the TLV header length by size appended */
-			le16_add_cpu(&chan_list_tlv->header.len,
-				     sizeof(chan_list_tlv->chan_scan_param));
+			le16_unaligned_add_cpu(&chan_list_tlv->header.len,
+					       sizeof(
+					       chan_list_tlv->chan_scan_param));
 
 			temp_chan->chan_number =
 				bgscan_cfg_in->chan_list[chan_idx].chan_number;
@@ -2407,8 +2413,8 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 			mwifiex_bgscan_create_channel_list(priv, bgscan_cfg_in,
 							   chan_list_tlv->
 							   chan_scan_param);
-		le16_add_cpu(&chan_list_tlv->header.len,
-			     chan_num *
+		le16_unaligned_add_cpu(&chan_list_tlv->header.len,
+				       chan_num *
 			     sizeof(chan_list_tlv->chan_scan_param[0]));
 	}
 
@@ -2432,7 +2438,7 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 	/* Append vendor specific IE TLV */
 	mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_BGSCAN, &tlv_pos);
 
-	le16_add_cpu(&cmd->size, tlv_pos - bgscan_config->tlv);
+	le16_unaligned_add_cpu(&cmd->size, tlv_pos - bgscan_config->tlv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 2f1f4d1..cf9121e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -126,12 +126,12 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
 		snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_GET);
 		snmp_mib->buf_size = cpu_to_le16(MAX_SNMP_BUF_SIZE);
-		le16_add_cpu(&cmd->size, MAX_SNMP_BUF_SIZE);
+		le16_unaligned_add_cpu(&cmd->size, MAX_SNMP_BUF_SIZE);
 	} else if (cmd_action == HostCmd_ACT_GEN_SET) {
 		snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 		snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
 		*((__le16 *) (snmp_mib->value)) = cpu_to_le16(*ul_temp);
-		le16_add_cpu(&cmd->size, sizeof(u16));
+		le16_unaligned_add_cpu(&cmd->size, sizeof(u16));
 	}
 
 	mwifiex_dbg(priv->adapter, CMD,
@@ -1357,8 +1357,9 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 			    subsc_evt_cfg->bcn_l_rssi_cfg.evt_freq);
 
 		pos += sizeof(struct mwifiex_ie_types_rssi_threshold);
-		le16_add_cpu(&cmd->size,
-			     sizeof(struct mwifiex_ie_types_rssi_threshold));
+		le16_unaligned_add_cpu(&cmd->size,
+				       sizeof(
+				       struct mwifiex_ie_types_rssi_threshold));
 	}
 
 	if (event_bitmap & BITMASK_BCN_RSSI_HIGH) {
@@ -1378,8 +1379,9 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 			    subsc_evt_cfg->bcn_h_rssi_cfg.evt_freq);
 
 		pos += sizeof(struct mwifiex_ie_types_rssi_threshold);
-		le16_add_cpu(&cmd->size,
-			     sizeof(struct mwifiex_ie_types_rssi_threshold));
+		le16_unaligned_add_cpu(&cmd->size,
+				       sizeof(
+				       struct mwifiex_ie_types_rssi_threshold));
 	}
 
 	return 0;
@@ -1683,14 +1685,15 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 					       sizeof(u8) + sizeof(u8));
 
 		/* Add the rule length to the command size*/
-		le16_add_cpu(&cmd->size, le16_to_cpu(rule->header.len) +
-			     sizeof(struct mwifiex_ie_types_header));
+		le16_unaligned_add_cpu(&cmd->size,
+				       le16_to_cpu(rule->header.len) +
+				       sizeof(struct mwifiex_ie_types_header));
 
 		rule = (void *)((u8 *)rule->params + length);
 	}
 
 	/* Add sizeof action, num_of_rules to total command length */
-	le16_add_cpu(&cmd->size, sizeof(u16) + sizeof(u16));
+	le16_unaligned_add_cpu(&cmd->size, sizeof(u16) + sizeof(u16));
 
 	return 0;
 }
@@ -1708,7 +1711,7 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_TDLS_CONFIG);
 	cmd->size = cpu_to_le16(S_DS_GEN);
 	tdls_config->tdls_action = cpu_to_le16(cmd_action);
-	le16_add_cpu(&cmd->size, sizeof(tdls_config->tdls_action));
+	le16_unaligned_add_cpu(&cmd->size, sizeof(tdls_config->tdls_action));
 
 	switch (cmd_action) {
 	case ACT_TDLS_CS_ENABLE_CONFIG:
@@ -1735,7 +1738,7 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 		return -ENOTSUPP;
 	}
 
-	le16_add_cpu(&cmd->size, len);
+	le16_unaligned_add_cpu(&cmd->size, len);
 	return 0;
 }
 
@@ -1759,7 +1762,8 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_TDLS_OPER);
 	cmd->size = cpu_to_le16(S_DS_GEN);
-	le16_add_cpu(&cmd->size, sizeof(struct host_cmd_ds_tdls_oper));
+	le16_unaligned_add_cpu(&cmd->size,
+			       sizeof(struct host_cmd_ds_tdls_oper));
 
 	tdls_oper->reason = 0;
 	memcpy(tdls_oper->peer_mac, oper->peer_mac, ETH_ALEN);
@@ -1861,7 +1865,7 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 		return -ENOTSUPP;
 	}
 
-	le16_add_cpu(&cmd->size, config_len);
+	le16_unaligned_add_cpu(&cmd->size, config_len);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/util.h b/drivers/net/wireless/marvell/mwifiex/util.h
index b541d66..c386992 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.h
+++ b/drivers/net/wireless/marvell/mwifiex/util.h
@@ -93,4 +93,9 @@ static inline dma_addr_t MWIFIEX_SKB_DMA_ADDR(struct sk_buff *skb)
 int mwifiex_debug_info_to_buffer(struct mwifiex_private *priv, char *buf,
 				 struct mwifiex_debug_info *info);
 
+static inline void le16_unaligned_add_cpu(__le16 *var, u16 val)
+{
+	put_unaligned_le16(get_unaligned_le16(var) + val, var);
+}
+
 #endif /* !_MWIFIEX_UTIL_H_ */
-- 
1.9.1
