Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35583 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab1CHASj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 19:18:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: break some functions into smaller ones
Date: Mon,  7 Mar 2011 16:21:35 -0800
Message-Id: <1299543697-15152-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

to avoid crap indentation they have

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c        |  387 ++++++++++--------------
 drivers/net/wireless/mwifiex/scan.c        |  467 ++++++++++++++++------------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  192 +++++-------
 3 files changed, 512 insertions(+), 534 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 49d1747..3317099 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -302,6 +302,109 @@ mwifiex_cmd_append_wapi_ie(struct mwifiex_private *priv, u8 **buffer)
 }
 
 /*
+ * This function appends rsn ie tlv for wpa/wpa2 security modes.
+ * It is called from the network join command preparation routine.
+ */
+static int mwifiex_append_rsn_ie_wpa_wpa2(struct mwifiex_private *priv,
+					  u8 **buffer)
+{
+	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
+	int rsn_ie_len;
+
+	if (!buffer || !(*buffer))
+		return 0;
+
+	rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) (*buffer);
+	rsn_ie_tlv->header.type = cpu_to_le16((u16) priv->wpa_ie[0]);
+	rsn_ie_tlv->header.type = cpu_to_le16(
+				 le16_to_cpu(rsn_ie_tlv->header.type) & 0x00FF);
+	rsn_ie_tlv->header.len = cpu_to_le16((u16) priv->wpa_ie[1]);
+	rsn_ie_tlv->header.len = cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
+							& 0x00FF);
+	if (le16_to_cpu(rsn_ie_tlv->header.len) <= (sizeof(priv->wpa_ie) - 2))
+		memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
+					le16_to_cpu(rsn_ie_tlv->header.len));
+	else
+		return -1;
+
+	rsn_ie_len = sizeof(rsn_ie_tlv->header) +
+					le16_to_cpu(rsn_ie_tlv->header.len);
+	*buffer += rsn_ie_len;
+
+	return rsn_ie_len;
+}
+
+/*
+ * This function appends rsn ie tlv for embedded supplicant.
+ * It is called from the network join command preparation routine.
+ */
+static int
+mwifiex_append_rsn_ie_ewpa(struct mwifiex_private *priv, u8 **buffer,
+			   struct mwifiex_bssdescriptor *bss_desc)
+{
+	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
+	int rsn_ie_len = 0;
+
+	if (!buffer || !(*buffer))
+		return 0;
+
+	rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) (*buffer);
+	if (bss_desc->bcn_wpa_ie) {
+		rsn_ie_tlv->header.type =
+			cpu_to_le16((u16) (*(bss_desc->bcn_wpa_ie))
+					.vend_hdr.element_id);
+		rsn_ie_tlv->header.type =
+			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
+					& 0x00FF);
+		rsn_ie_tlv->header.len =
+			cpu_to_le16((u16) (*(bss_desc->bcn_wpa_ie))
+					.vend_hdr.len);
+		rsn_ie_tlv->header.len =
+			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
+					& 0x00FF);
+		if (le16_to_cpu(rsn_ie_tlv->header.len)
+				<= (sizeof(priv->wpa_ie)))
+			memcpy(rsn_ie_tlv->rsn_ie, &((*(bss_desc->bcn_wpa_ie))
+					.vend_hdr.oui[0]),
+					le16_to_cpu(rsn_ie_tlv->header.len));
+		else
+			return -1;
+
+		rsn_ie_len += sizeof(rsn_ie_tlv->header) +
+					le16_to_cpu(rsn_ie_tlv->header.len);
+		*buffer += rsn_ie_len;
+	}
+	if (bss_desc->bcn_rsn_ie) {
+		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *)
+								(*buffer);
+		rsn_ie_tlv->header.type =
+				cpu_to_le16((u16) (*(bss_desc->bcn_rsn_ie))
+					.ieee_hdr.element_id);
+		rsn_ie_tlv->header.type =
+				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
+					& 0x00FF);
+		rsn_ie_tlv->header.len =
+				cpu_to_le16((u16) (*(bss_desc->bcn_rsn_ie))
+					.ieee_hdr.len);
+		rsn_ie_tlv->header.len =
+			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
+					& 0x00FF);
+		if (le16_to_cpu(rsn_ie_tlv->header.len)
+				<= (sizeof(priv->wpa_ie)))
+			memcpy(rsn_ie_tlv->rsn_ie,
+				&((*(bss_desc->bcn_rsn_ie)).data[0]),
+				le16_to_cpu(rsn_ie_tlv->header.len));
+		else
+			return -1;
+
+		rsn_ie_len += sizeof(rsn_ie_tlv->header) +
+				le16_to_cpu(rsn_ie_tlv->header.len);
+		buffer += rsn_ie_len;
+	}
+	return rsn_ie_len;
+}
+
+/*
  * This function prepares command for association.
  *
  * This sets the following parameters -
@@ -340,12 +443,12 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_ss_param_set *ss_tlv;
 	struct mwifiex_ie_types_rates_param_set *rates_tlv;
 	struct mwifiex_ie_types_auth_type *auth_tlv;
-	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
 	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u32 rates_size;
 	u16 tmp_cap;
 	u8 *pos;
+	int rsn_ie_len = 0;
 
 	bss_desc = (struct mwifiex_bssdescriptor *) data_buf;
 	pos = (u8 *) assoc;
@@ -457,98 +560,14 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	}
 
 	if (!priv->wps.session_enable) {
-		if ((priv->sec_info.wpa_enabled ||
-					priv->sec_info.wpa2_enabled)) {
-			rsn_ie_tlv =
-				(struct mwifiex_ie_types_rsn_param_set *) pos;
-			rsn_ie_tlv->header.type =
-				cpu_to_le16((u16) priv->wpa_ie[0]);
-			rsn_ie_tlv->header.type =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-						& 0x00FF);
-			rsn_ie_tlv->header.len =
-				cpu_to_le16((u16) priv->wpa_ie[1]);
-			rsn_ie_tlv->header.len =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-						& 0x00FF);
-			if (le16_to_cpu(rsn_ie_tlv->header.len)
-					<= (sizeof(priv->wpa_ie) - 2))
-				memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
-					le16_to_cpu(rsn_ie_tlv->header.len));
-			else
-				return -1;
-
-			pos += sizeof(rsn_ie_tlv->header)
-				+ le16_to_cpu(rsn_ie_tlv->header.len);
-		} else if (priv->sec_info.ewpa_enabled) {
-			rsn_ie_tlv =
-				(struct mwifiex_ie_types_rsn_param_set *) pos;
-			if (bss_desc->bcn_wpa_ie) {
-				rsn_ie_tlv->header.type =
-					cpu_to_le16(
-						(u16) (*(bss_desc->bcn_wpa_ie))
-							.vend_hdr.element_id);
-				rsn_ie_tlv->header.type =
-					cpu_to_le16(le16_to_cpu(
-							rsn_ie_tlv->header.type)
-							& 0x00FF);
-				rsn_ie_tlv->header.len =
-					cpu_to_le16(
-						(u16) (*(bss_desc->bcn_wpa_ie))
-						.vend_hdr.len);
-				rsn_ie_tlv->header.len =
-					cpu_to_le16(le16_to_cpu(
-							rsn_ie_tlv->header.len)
-							& 0x00FF);
-				if (le16_to_cpu(rsn_ie_tlv->header.len)
-						<= (sizeof(priv->wpa_ie)))
-					memcpy(rsn_ie_tlv->rsn_ie,
-						&((*(bss_desc->bcn_wpa_ie))
-							.vend_hdr.
-							oui[0]),
-							le16_to_cpu(
-							rsn_ie_tlv->header
-							.len));
-				else
-					return -1;
-
-				pos += sizeof(rsn_ie_tlv->header) +
-					le16_to_cpu(rsn_ie_tlv->header.len);
-			}
-			if (bss_desc->bcn_rsn_ie) {
-				rsn_ie_tlv = (struct
-					      mwifiex_ie_types_rsn_param_set
-					      *) pos;
-				rsn_ie_tlv->header.type =
-						cpu_to_le16(
-						(u16) (*(bss_desc->bcn_rsn_ie))
-						.ieee_hdr.element_id);
-				rsn_ie_tlv->header.type =
-					cpu_to_le16(le16_to_cpu(
-						rsn_ie_tlv->header.type)
-						& 0x00FF);
-				rsn_ie_tlv->header.len =
-						cpu_to_le16(
-						(u16) (*(bss_desc->bcn_rsn_ie))
-						.ieee_hdr.len);
-				rsn_ie_tlv->header.len =
-					cpu_to_le16(le16_to_cpu(
-						rsn_ie_tlv->header.len)
-						& 0x00FF);
-				if (le16_to_cpu(rsn_ie_tlv->header.len)
-						<= (sizeof(priv->wpa_ie)))
-					memcpy(rsn_ie_tlv->rsn_ie,
-						&((*(bss_desc->bcn_rsn_ie))
-						.data[0]),
-						le16_to_cpu(
-						rsn_ie_tlv->header.len));
-				else
-					return -1;
-
-				pos += sizeof(rsn_ie_tlv->header) +
-					le16_to_cpu(rsn_ie_tlv->header.len);
-			}
-		}
+		if (priv->sec_info.wpa_enabled || priv->sec_info.wpa2_enabled)
+			rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
+		else if (priv->sec_info.ewpa_enabled)
+			rsn_ie_len = mwifiex_append_rsn_ie_ewpa(priv, &pos,
+								bss_desc);
+
+		if (rsn_ie_len == -1)
+			return -1;
 	}
 
 	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info)
@@ -817,7 +836,7 @@ int
 mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *cmd, void *data_buf)
 {
-	int ret = 0;
+	int ret = 0, rsn_ie_len = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ad_hoc_start *adhoc_start =
 		&cmd->params.adhoc_start;
@@ -828,7 +847,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	uint16_t ht_cap_info;
 	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
 
-	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
 	struct mwifiex_ie_types_htcap *ht_cap;
 	struct mwifiex_ie_types_htinfo *ht_info;
 	/* wpa ie for WPA_NONE AES */
@@ -1038,27 +1056,10 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	}
 
 	if (priv->sec_info.wpa_enabled || priv->sec_info.ewpa_enabled) {
-		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) pos;
-		rsn_ie_tlv->header.type = cpu_to_le16((u16) priv->wpa_ie[0]);
-		rsn_ie_tlv->header.type =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-			& 0x00FF);
-		rsn_ie_tlv->header.len = cpu_to_le16((u16) priv->wpa_ie[1]);
-		rsn_ie_tlv->header.len =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-			& 0x00FF);
-		if (le16_to_cpu(rsn_ie_tlv->header.len)
-				<= (sizeof(priv->wpa_ie) - 2))
-			memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
-			       le16_to_cpu(rsn_ie_tlv->header.len));
-		else
+		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
+		if (rsn_ie_len == -1)
 			return -1;
-
-		pos += sizeof(rsn_ie_tlv->header)
-			    + le16_to_cpu(rsn_ie_tlv->header.len);
-		cmd_append_size +=
-			sizeof(rsn_ie_tlv->header)
-			    + le16_to_cpu(rsn_ie_tlv->header.len);
+		cmd_append_size += rsn_ie_len;
 	}
 
 	if (adapter->adhoc_11n_enabled) {
@@ -1147,13 +1148,12 @@ int
 mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			       struct host_cmd_ds_command *cmd, void *data_buf)
 {
-	int ret = 0;
+	int ret = 0, rsn_ie_len = 0;
 	struct host_cmd_ds_802_11_ad_hoc_join *adhoc_join =
 		&cmd->params.adhoc_join;
 	struct mwifiex_bssdescriptor *bss_desc =
 		(struct mwifiex_bssdescriptor *) data_buf;
 	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
-	struct mwifiex_ie_types_rsn_param_set *rsn_ie_tlv;
 	u32 cmd_append_size = 0;
 	u16 tmp_cap;
 	u32 i, rates_size = 0;
@@ -1266,88 +1266,14 @@ mwifiex_cmd_802_11_ad_hoc_join(struct mwifiex_private *priv,
 			sizeof(struct mwifiex_chan_scan_param_set);
 	}
 
-	if (priv->sec_info.wpa_enabled) {
-		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) pos;
-		rsn_ie_tlv->header.type = cpu_to_le16((u16) priv->wpa_ie[0]);
-		rsn_ie_tlv->header.type =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-			& 0x00FF);
-		rsn_ie_tlv->header.len = cpu_to_le16((u16) priv->wpa_ie[1]);
-		rsn_ie_tlv->header.len =
-			cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-			& 0x00FF);
-		if (le16_to_cpu(rsn_ie_tlv->header.len)
-			<= (sizeof(priv->wpa_ie) - 2))
-			memcpy(rsn_ie_tlv->rsn_ie, &priv->wpa_ie[2],
-			       le16_to_cpu(rsn_ie_tlv->header.len));
-		else
-			return -1;
-
-		pos += sizeof(rsn_ie_tlv->header)
-			+ le16_to_cpu(rsn_ie_tlv->header.len);
-		cmd_append_size +=
-			sizeof(rsn_ie_tlv->header)
-			+ le16_to_cpu(rsn_ie_tlv->header.len);
-	} else if (priv->sec_info.ewpa_enabled) {
-		rsn_ie_tlv = (struct mwifiex_ie_types_rsn_param_set *) pos;
-		if (bss_desc->bcn_wpa_ie) {
-			rsn_ie_tlv->header.type =
-				cpu_to_le16((u16) (*(bss_desc->bcn_wpa_ie))
-				.vend_hdr.element_id);
-			rsn_ie_tlv->header.type =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-				& 0x00FF);
-			rsn_ie_tlv->header.len =
-				cpu_to_le16((u16) (*(bss_desc->bcn_wpa_ie))
-				.vend_hdr.len);
-			rsn_ie_tlv->header.len =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-				& 0x00FF);
-			if (le16_to_cpu(rsn_ie_tlv->header.len)
-					<= (sizeof(priv->wpa_ie)))
-				memcpy(rsn_ie_tlv->rsn_ie,
-				       &((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-					 oui[0]),
-					le16_to_cpu(rsn_ie_tlv->header.len));
-			else
-				return -1;
-
-			pos += sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len);
-			cmd_append_size +=
-				sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len);
-		}
-		if (bss_desc->bcn_rsn_ie) {
-			rsn_ie_tlv =
-				(struct mwifiex_ie_types_rsn_param_set *) pos;
-			rsn_ie_tlv->header.type =
-				cpu_to_le16((u16) (*(bss_desc->bcn_rsn_ie))
-				.ieee_hdr.element_id);
-			rsn_ie_tlv->header.type =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.type)
-				& 0x00FF);
-			rsn_ie_tlv->header.len =
-				cpu_to_le16((u16) (*(bss_desc->bcn_rsn_ie))
-				.ieee_hdr.len);
-			rsn_ie_tlv->header.len =
-				cpu_to_le16(le16_to_cpu(rsn_ie_tlv->header.len)
-				& 0x00FF);
-			if (le16_to_cpu(rsn_ie_tlv->header.len)
-					<= (sizeof(priv->wpa_ie)))
-				memcpy(rsn_ie_tlv->rsn_ie,
-				       &((*(bss_desc->bcn_rsn_ie)).data[0])
-				       , le16_to_cpu(rsn_ie_tlv->header.len));
-			else
-				return -1;
-
-			pos += sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len);
-			cmd_append_size +=
-				sizeof(rsn_ie_tlv->header) +
-				le16_to_cpu(rsn_ie_tlv->header.len);
-		}
-	}
+	if (priv->sec_info.wpa_enabled)
+		rsn_ie_len = mwifiex_append_rsn_ie_wpa_wpa2(priv, &pos);
+	else if (priv->sec_info.ewpa_enabled)
+		rsn_ie_len = mwifiex_append_rsn_ie_ewpa(priv, &pos,
+							bss_desc);
+	if (rsn_ie_len == -1)
+		return -1;
+	cmd_append_size += rsn_ie_len;
 
 	if (ISSUPP_11NENABLED(priv->adapter->fw_cap_info))
 		cmd_append_size +=
@@ -1566,6 +1492,40 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 }
 
 /*
+ * This function deauthenticates/disconnects from infra network by sending
+ * deauthentication request.
+ */
+static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv,
+					struct mwifiex_wait_queue *wait,
+					u8 *mac)
+{
+	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
+	int ret = 0;
+	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
+
+	if (mac) {
+		if (!memcmp(mac, zero_mac, sizeof(zero_mac)))
+			memcpy((u8 *) &mac_address,
+			       (u8 *) &priv->curr_bss_params.bss_descriptor.
+			       mac_address, MWIFIEX_MAC_ADDR_LENGTH);
+		else
+			memcpy((u8 *) &mac_address, (u8 *) mac,
+			       MWIFIEX_MAC_ADDR_LENGTH);
+	} else {
+		memcpy((u8 *) &mac_address, (u8 *) &priv->curr_bss_params.
+		       bss_descriptor.mac_address, MWIFIEX_MAC_ADDR_LENGTH);
+	}
+
+	ret = mwifiex_prepare_cmd(priv, HostCmd_CMD_802_11_DEAUTHENTICATE,
+				  HostCmd_ACT_GEN_SET, 0, wait, &mac_address);
+
+	if (!ret && wait)
+		ret = -EINPROGRESS;
+
+	return ret;
+}
+
+/*
  * This function deauthenticates/disconnects from a BSS.
  *
  * In case of infra made, it sends deauthentication request, and
@@ -1574,38 +1534,11 @@ int mwifiex_adhoc_join(struct mwifiex_private *priv,
 int mwifiex_deauthenticate(struct mwifiex_private *priv,
 			   struct mwifiex_wait_queue *wait, u8 *mac)
 {
-	u8 mac_address[MWIFIEX_MAC_ADDR_LENGTH];
 	int ret = 0;
-	u8 zero_mac[] = { 0, 0, 0, 0, 0, 0 };
 
 	if (priv->media_connected) {
 		if (priv->bss_mode == MWIFIEX_BSS_MODE_INFRA) {
-			if (mac) {
-				if (!memcmp(mac, zero_mac, sizeof(zero_mac)))
-					memcpy((u8 *) &mac_address,
-					       (u8 *) &priv->
-					       curr_bss_params.bss_descriptor.
-					       mac_address,
-					       MWIFIEX_MAC_ADDR_LENGTH);
-				else
-					memcpy((u8 *) &mac_address,
-					       (u8 *) mac,
-					       MWIFIEX_MAC_ADDR_LENGTH);
-			} else {
-				memcpy((u8 *) &mac_address,
-				       (u8 *) &priv->curr_bss_params.
-				       bss_descriptor.mac_address,
-				       MWIFIEX_MAC_ADDR_LENGTH);
-			}
-
-			ret = mwifiex_prepare_cmd(priv,
-					HostCmd_CMD_802_11_DEAUTHENTICATE,
-					HostCmd_ACT_GEN_SET,
-					0, wait, &mac_address);
-
-			if (!ret && wait)
-				ret = -EINPROGRESS;
-
+			ret = mwifiex_deauthenticate_infra(priv, wait, mac);
 		} else if (priv->bss_mode == MWIFIEX_BSS_MODE_IBSS) {
 			ret = mwifiex_prepare_cmd(priv,
 					HostCmd_CMD_802_11_AD_HOC_STOP,
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index aa339db..bc8f73b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -319,6 +319,213 @@ done:
 }
 
 /*
+ * This function checks if ewpa is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_ewpa(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.ewpa_enabled) {
+		if (((bss_desc->bcn_wpa_ie) &&
+		     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
+		     WLAN_EID_WPA)) || ((bss_desc->bcn_rsn_ie) &&
+		     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id ==
+		     WLAN_EID_RSN))) {
+			return true;
+		}
+	}
+	return false;
+}
+
+/*
+ * This function checks if wapi is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_wapi(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wapi_enabled &&
+	    (bss_desc->bcn_wapi_ie &&
+	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
+			WLAN_EID_BSS_AC_ACCESS_DELAY))) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if driver is configured with no security mode and
+ * scanned network is compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_no_sec(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((!bss_desc->bcn_wpa_ie) ||
+		((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
+	    WLAN_EID_WPA))
+	    && ((!bss_desc->bcn_rsn_ie) ||
+		((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
+	    WLAN_EID_RSN))
+	    && priv->sec_info.encryption_mode ==
+	    MWIFIEX_ENCRYPTION_MODE_NONE && !bss_desc->privacy) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if static WEP is enabled in driver and scanned network
+ * is compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_static_wep(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_ENABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && bss_desc->privacy) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if wpa is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_wpa(struct mwifiex_private *priv,
+				      struct mwifiex_bssdescriptor *bss_desc,
+				      int index)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((bss_desc->bcn_wpa_ie) && ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
+						element_id == WLAN_EID_WPA))
+	   /*
+	    * Privacy bit may NOT be set in some APs like
+	    * LinkSys WRT54G && bss_desc->privacy
+	    */
+	 ) {
+		dev_dbg(priv->adapter->dev, "info: %s: WPA: index=%d"
+			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
+			"EncMode=%#x privacy=%#x\n", __func__, index,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).
+			vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).
+			ieee_hdr.element_id : 0,
+			(priv->sec_info.wep_status ==
+			MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+			(priv->sec_info.wpa_enabled) ? "e" : "d",
+			(priv->sec_info.wpa2_enabled) ? "e" : "d",
+			priv->sec_info.encryption_mode,
+			bss_desc->privacy);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if wpa2 is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_wpa2(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc,
+				       int index)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	   && !priv->sec_info.wpa_enabled && priv->sec_info.wpa2_enabled
+	   && ((bss_desc->bcn_rsn_ie) && ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+						element_id == WLAN_EID_RSN))
+	   /*
+	    * Privacy bit may NOT be set in some APs like
+	    * LinkSys WRT54G && bss_desc->privacy
+	    */
+	 ) {
+		dev_dbg(priv->adapter->dev, "info: %s: WPA2: index=%d"
+			" wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
+			"EncMode=%#x privacy=%#x\n", __func__, index,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).
+			vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).
+			ieee_hdr.element_id : 0,
+			(priv->sec_info.wep_status ==
+			MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
+			(priv->sec_info.wpa_enabled) ? "e" : "d",
+			(priv->sec_info.wpa2_enabled) ? "e" : "d",
+			priv->sec_info.encryption_mode,
+			bss_desc->privacy);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if adhoc AES is enabled in driver and scanned network is
+ * compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_adhoc_aes(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((!bss_desc->bcn_wpa_ie) || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
+		   element_id != WLAN_EID_WPA))
+	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+		   element_id != WLAN_EID_RSN))
+	    && priv->sec_info.encryption_mode ==
+	    MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+		return true;
+	}
+	return false;
+}
+
+/*
+ * This function checks if dynamic WEP is enabled in driver and scanned network
+ * is compatible with it.
+ */
+static bool
+mwifiex_is_network_compatible_for_dynamic_wep(struct mwifiex_private *priv,
+				       struct mwifiex_bssdescriptor *bss_desc,
+				       int index)
+{
+	if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
+	    && !priv->sec_info.wpa_enabled && !priv->sec_info.wpa2_enabled
+	    && ((!bss_desc->bcn_wpa_ie) || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
+		   element_id != WLAN_EID_WPA))
+	    && ((!bss_desc->bcn_rsn_ie) || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
+		   element_id != WLAN_EID_RSN))
+	    && priv->sec_info.encryption_mode !=
+	    MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+		dev_dbg(priv->adapter->dev, "info: %s: dynamic "
+			"WEP: index=%d wpa_ie=%#x wpa2_ie=%#x "
+			"EncMode=%#x privacy=%#x\n",
+			__func__, index,
+			(bss_desc->bcn_wpa_ie) ?
+			(*(bss_desc->bcn_wpa_ie)).
+			vend_hdr.element_id : 0,
+			(bss_desc->bcn_rsn_ie) ?
+			(*(bss_desc->bcn_rsn_ie)).
+			ieee_hdr.element_id : 0,
+			priv->sec_info.encryption_mode,
+			bss_desc->privacy);
+		return true;
+	}
+	return false;
+}
+
+/*
  * This function checks if a scanned network is compatible with the driver
  * settings.
  *
@@ -358,13 +565,8 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 		return index;
 	}
 
-	if ((bss_desc->bss_mode == mode) && priv->sec_info.ewpa_enabled) {
-		if (((bss_desc->bcn_wpa_ie) &&
-		     ((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id ==
-		     WLAN_EID_WPA)) ||
-		    ((bss_desc->bcn_rsn_ie) &&
-		     ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id ==
-		     WLAN_EID_RSN))) {
+	if (bss_desc->bss_mode == mode) {
+		if (mwifiex_is_network_compatible_for_ewpa(priv, bss_desc)) {
 			if (((priv->adapter->config_bands & BAND_GN ||
 			      priv->adapter->config_bands & BAND_AN) &&
 			     bss_desc->bcn_ht_cap)
@@ -387,76 +589,35 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 				}
 			}
 			return index;
-		} else {
+		} else if (priv->sec_info.ewpa_enabled) {
 			dev_dbg(adapter->dev,
 				"info: ewpa_enabled: ignore none WPA/WPA2 AP\n");
 			return -1;
 		}
 	}
 
-	if (priv->sec_info.wapi_enabled &&
-	    (bss_desc->bcn_wapi_ie &&
-	     ((*(bss_desc->bcn_wapi_ie)).ieee_hdr.element_id ==
-			WLAN_EID_BSS_AC_ACCESS_DELAY))) {
+	if (mwifiex_is_network_compatible_for_wapi(priv, bss_desc)) {
 		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
 		return index;
 	}
 
 	if (bss_desc->bss_mode == mode) {
-		if (priv->sec_info.wep_status == MWIFIEX_802_11_WEP_DISABLED
-		    && !priv->sec_info.wpa_enabled
-		    && !priv->sec_info.wpa2_enabled
-		    && ((!bss_desc->bcn_wpa_ie) ||
-			((*(bss_desc->bcn_wpa_ie)).vend_hdr.element_id !=
-		    WLAN_EID_WPA))
-		    && ((!bss_desc->bcn_rsn_ie) ||
-			((*(bss_desc->bcn_rsn_ie)).ieee_hdr.element_id !=
-		    WLAN_EID_RSN))
-		    && priv->sec_info.encryption_mode ==
-		    MWIFIEX_ENCRYPTION_MODE_NONE && !bss_desc->privacy) {
+		if (mwifiex_is_network_compatible_for_no_sec(priv, bss_desc)) {
 			/* No security */
 			return index;
-		} else if (priv->sec_info.wep_status ==
-			   MWIFIEX_802_11_WEP_ENABLED
-			   && !priv->sec_info.wpa_enabled
-			   && !priv->sec_info.wpa2_enabled
-			   && bss_desc->privacy) {
+		} else if (mwifiex_is_network_compatible_for_static_wep(priv,
+								bss_desc)) {
 			/* Static WEP enabled */
 			dev_dbg(adapter->dev, "info: Disable 11n in WEP mode.\n");
 			bss_desc->disable_11n = true;
 			return index;
-		} else if (priv->sec_info.wep_status ==
-			   MWIFIEX_802_11_WEP_DISABLED
-			   && priv->sec_info.wpa_enabled
-			   && !priv->sec_info.wpa2_enabled
-			   && ((bss_desc->bcn_wpa_ie)
-			       && ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-				   element_id == WLAN_EID_WPA))
-			   /*
-			    * Privacy bit may NOT be set in some APs like
-			    * LinkSys WRT54G && bss_desc->privacy
-			    */
-			) {
+		} else if (mwifiex_is_network_compatible_for_wpa(priv, bss_desc,
+								 index)) {
 			/* WPA enabled */
-			dev_dbg(adapter->dev, "info: %s: WPA: index=%d"
-			       " wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			       "EncMode=%#x privacy=%#x\n", __func__, index,
-			       (bss_desc->bcn_wpa_ie) ?
-			       (*(bss_desc->bcn_wpa_ie)).
-			       vend_hdr.element_id : 0,
-			       (bss_desc->bcn_rsn_ie) ?
-			       (*(bss_desc->bcn_rsn_ie)).
-			       ieee_hdr.element_id : 0,
-			       (priv->sec_info.wep_status ==
-				MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
-			       (priv->sec_info.wpa_enabled) ? "e" : "d",
-			       (priv->sec_info.wpa2_enabled) ? "e" : "d",
-			       priv->sec_info.encryption_mode,
-			       bss_desc->privacy);
 			if (((priv->adapter->config_bands & BAND_GN
 			      || priv->adapter->config_bands & BAND_AN)
-			     && bss_desc->bcn_ht_cap)
-			    && !mwifiex_is_wpa_oui_present(bss_desc,
+			      && bss_desc->bcn_ht_cap)
+			      && !mwifiex_is_wpa_oui_present(bss_desc,
 					CIPHER_SUITE_CCMP)) {
 
 				if (mwifiex_is_wpa_oui_present(bss_desc,
@@ -470,38 +631,13 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 				}
 			}
 			return index;
-		} else if (priv->sec_info.wep_status ==
-			   MWIFIEX_802_11_WEP_DISABLED
-			   && !priv->sec_info.wpa_enabled
-			   && priv->sec_info.wpa2_enabled
-			   && ((bss_desc->bcn_rsn_ie)
-			       && ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-				   element_id == WLAN_EID_RSN))
-			   /*
-			    * Privacy bit may NOT be set in some APs like
-			    * LinkSys WRT54G && bss_desc->privacy
-			    */
-			) {
+		} else if (mwifiex_is_network_compatible_for_wpa2(priv,
+							bss_desc, index)) {
 			/* WPA2 enabled */
-			dev_dbg(adapter->dev, "info: %s: WPA2: index=%d"
-			       " wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s "
-			       "EncMode=%#x privacy=%#x\n", __func__, index,
-			       (bss_desc->bcn_wpa_ie) ?
-			       (*(bss_desc->bcn_wpa_ie)).
-			       vend_hdr.element_id : 0,
-			       (bss_desc->bcn_rsn_ie) ?
-			       (*(bss_desc->bcn_rsn_ie)).
-			       ieee_hdr.element_id : 0,
-			       (priv->sec_info.wep_status ==
-			       MWIFIEX_802_11_WEP_ENABLED) ? "e" : "d",
-			       (priv->sec_info.wpa_enabled) ? "e" : "d",
-			       (priv->sec_info.wpa2_enabled) ? "e" : "d",
-			       priv->sec_info.encryption_mode,
-			       bss_desc->privacy);
 			if (((priv->adapter->config_bands & BAND_GN
 			      || priv->adapter->config_bands & BAND_AN)
-			     && bss_desc->bcn_ht_cap)
-			    && !mwifiex_is_rsn_oui_present(bss_desc,
+			      && bss_desc->bcn_ht_cap)
+			      && !mwifiex_is_rsn_oui_present(bss_desc,
 					CIPHER_SUITE_CCMP)) {
 
 				if (mwifiex_is_rsn_oui_present(bss_desc,
@@ -515,45 +651,13 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv, u32 index,
 				}
 			}
 			return index;
-		} else if (priv->sec_info.wep_status ==
-			   MWIFIEX_802_11_WEP_DISABLED
-			   && !priv->sec_info.wpa_enabled
-			   && !priv->sec_info.wpa2_enabled
-			   && ((!bss_desc->bcn_wpa_ie)
-			       || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-				   element_id != WLAN_EID_WPA))
-			   && ((!bss_desc->bcn_rsn_ie)
-			       || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-				   element_id != WLAN_EID_RSN))
-			   && priv->sec_info.encryption_mode ==
-			   MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+		} else if (mwifiex_is_network_compatible_for_adhoc_aes(priv,
+								bss_desc)) {
 			/* Ad-hoc AES enabled */
 			return index;
-		} else if (priv->sec_info.wep_status ==
-			   MWIFIEX_802_11_WEP_DISABLED
-			   && !priv->sec_info.wpa_enabled
-			   && !priv->sec_info.wpa2_enabled
-			   && ((!bss_desc->bcn_wpa_ie)
-			       || ((*(bss_desc->bcn_wpa_ie)).vend_hdr.
-				   element_id != WLAN_EID_WPA))
-			   && ((!bss_desc->bcn_rsn_ie)
-			       || ((*(bss_desc->bcn_rsn_ie)).ieee_hdr.
-				   element_id != WLAN_EID_RSN))
-			   && priv->sec_info.encryption_mode !=
-			   MWIFIEX_ENCRYPTION_MODE_NONE && bss_desc->privacy) {
+		} else if (mwifiex_is_network_compatible_for_dynamic_wep(priv,
+							bss_desc, index)) {
 			/* Dynamic WEP enabled */
-			dev_dbg(adapter->dev, "info: %s: dynamic "
-					"WEP: index=%d wpa_ie=%#x wpa2_ie=%#x "
-					"EncMode=%#x privacy=%#x\n",
-					__func__, index,
-					(bss_desc->bcn_wpa_ie) ?
-					(*(bss_desc->bcn_wpa_ie)).
-					vend_hdr.element_id : 0,
-					(bss_desc->bcn_rsn_ie) ?
-					(*(bss_desc->bcn_rsn_ie)).
-					ieee_hdr.element_id : 0,
-					priv->sec_info.encryption_mode,
-					bss_desc->privacy);
 			return index;
 		}
 
@@ -1655,6 +1759,49 @@ mwifiex_adjust_beacon_buffer_ptrs(struct mwifiex_private *priv,
 }
 
 /*
+ * This function updates the pointers used in beacon buffer for given bss
+ * descriptor to reflect shifts
+ *
+ * Following pointers are updated
+ *      - WPA IE pointer
+ *      - RSN IE pointer
+ *      - WAPI IE pointer
+ *      - HT capability IE pointer
+ *      - HT information IE pointer
+ *      - BSS coexistence 20/40 IE pointer
+ *      - Extended capability IE pointer
+ *      - Overlapping BSS scan parameter IE pointer
+ */
+static void
+mwifiex_update_beacon_buffer_ptrs(struct mwifiex_bssdescriptor *beacon)
+{
+	if (beacon->bcn_wpa_ie)
+		beacon->bcn_wpa_ie = (struct ieee_types_vendor_specific *)
+			(beacon->beacon_buf + beacon->wpa_offset);
+	if (beacon->bcn_rsn_ie)
+		beacon->bcn_rsn_ie = (struct ieee_types_generic *)
+			(beacon->beacon_buf + beacon->rsn_offset);
+	if (beacon->bcn_wapi_ie)
+		beacon->bcn_wapi_ie = (struct ieee_types_generic *)
+			(beacon->beacon_buf + beacon->wapi_offset);
+	if (beacon->bcn_ht_cap)
+		beacon->bcn_ht_cap = (struct ieee80211_ht_cap *)
+			(beacon->beacon_buf + beacon->ht_cap_offset);
+	if (beacon->bcn_ht_info)
+		beacon->bcn_ht_info = (struct ieee80211_ht_info *)
+			(beacon->beacon_buf + beacon->ht_info_offset);
+	if (beacon->bcn_bss_co_2040)
+		beacon->bcn_bss_co_2040 = (u8 *) (beacon->beacon_buf +
+			beacon->bss_co_2040_offset);
+	if (beacon->bcn_ext_cap)
+		beacon->bcn_ext_cap = (u8 *) (beacon->beacon_buf +
+			beacon->ext_cap_offset);
+	if (beacon->bcn_obss_scan)
+		beacon->bcn_obss_scan = (struct ieee_types_obss_scan_param *)
+			(beacon->beacon_buf + beacon->overlap_bss_offset);
+}
+
+/*
  * This function stores a beacon or probe response for a BSS returned
  * in the scan.
  *
@@ -1871,41 +2018,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 		}
 		/* Point the new entry to its permanent storage space */
 		new_beacon->beacon_buf = bcn_store;
-		if (new_beacon->bcn_wpa_ie)
-			new_beacon->bcn_wpa_ie =
-				(struct ieee_types_vendor_specific *)
-				(new_beacon->beacon_buf +
-				 new_beacon->wpa_offset);
-		if (new_beacon->bcn_rsn_ie)
-			new_beacon->bcn_rsn_ie = (struct ieee_types_generic *)
-				(new_beacon->beacon_buf +
-				 new_beacon->rsn_offset);
-		if (new_beacon->bcn_wapi_ie)
-			new_beacon->bcn_wapi_ie = (struct ieee_types_generic *)
-				(new_beacon->beacon_buf +
-				 new_beacon->wapi_offset);
-		if (new_beacon->bcn_ht_cap)
-			new_beacon->bcn_ht_cap = (struct ieee80211_ht_cap *)
-				(new_beacon->beacon_buf +
-				 new_beacon->ht_cap_offset);
-
-		if (new_beacon->bcn_ht_info)
-			new_beacon->bcn_ht_info = (struct ieee80211_ht_info *)
-				(new_beacon->beacon_buf +
-				 new_beacon->ht_info_offset);
-		if (new_beacon->bcn_bss_co_2040)
-			new_beacon->bcn_bss_co_2040 = (u8 *)
-				(new_beacon->beacon_buf +
-				 new_beacon->bss_co_2040_offset);
-		if (new_beacon->bcn_ext_cap)
-			new_beacon->bcn_ext_cap = (u8 *)
-				(new_beacon->beacon_buf +
-				 new_beacon->ext_cap_offset);
-		if (new_beacon->bcn_obss_scan)
-			new_beacon->bcn_obss_scan =
-				(struct ieee_types_obss_scan_param *)
-				(new_beacon->beacon_buf +
-				 new_beacon->overlap_bss_offset);
+		mwifiex_update_beacon_buffer_ptrs(new_beacon);
 	} else {
 		/*
 		 * No existing beacon data exists for this entry, check to see
@@ -1931,45 +2044,7 @@ mwifiex_ret_802_11_scan_store_beacon(struct mwifiex_private *priv,
 				(new_beacon->beacon_buf_size +
 				 SCAN_BEACON_ENTRY_PAD);
 
-			if (new_beacon->bcn_wpa_ie)
-				new_beacon->bcn_wpa_ie =
-					(struct ieee_types_vendor_specific *)
-					(new_beacon->beacon_buf +
-					 new_beacon->wpa_offset);
-			if (new_beacon->bcn_rsn_ie)
-				new_beacon->bcn_rsn_ie =
-					(struct ieee_types_generic *)
-					(new_beacon->beacon_buf +
-					 new_beacon->rsn_offset);
-			if (new_beacon->bcn_wapi_ie)
-				new_beacon->bcn_wapi_ie =
-					(struct ieee_types_generic *)
-					(new_beacon->beacon_buf +
-					 new_beacon->wapi_offset);
-			if (new_beacon->bcn_ht_cap)
-				new_beacon->bcn_ht_cap =
-					(struct ieee80211_ht_cap *)
-					(new_beacon->beacon_buf +
-					 new_beacon->ht_cap_offset);
-
-			if (new_beacon->bcn_ht_info)
-				new_beacon->bcn_ht_info =
-					(struct ieee80211_ht_info *)
-					(new_beacon->beacon_buf +
-					 new_beacon->ht_info_offset);
-			if (new_beacon->bcn_bss_co_2040)
-				new_beacon->bcn_bss_co_2040 =
-					(u8 *) (new_beacon->beacon_buf +
-					 new_beacon->bss_co_2040_offset);
-			if (new_beacon->bcn_ext_cap)
-				new_beacon->bcn_ext_cap =
-					(u8 *) (new_beacon->beacon_buf +
-					 new_beacon->ext_cap_offset);
-			if (new_beacon->bcn_obss_scan)
-				new_beacon->bcn_obss_scan =
-					(struct ieee_types_obss_scan_param *)
-					(new_beacon->beacon_buf +
-					 new_beacon->overlap_bss_offset);
+			mwifiex_update_beacon_buffer_ptrs(new_beacon);
 
 			/* Increment the end pointer by the size reserved */
 			adapter->bcn_buf_end +=
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 2ebd544..50788bb 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -638,15 +638,12 @@ static int mwifiex_ret_802_11_key_material(struct mwifiex_private *priv,
 }
 
 /*
- * This function handles the command response of set/get passphrase.
- *
- * Handling includes updating driver's private flag 'ewpa_query' (for action
- * SET) and retrieving passphrase (for action GET) for specified
- * SSID
+ * This function retrieves passphrase information for specified SSID from
+ * command response.
  */
-static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
-					     struct host_cmd_ds_command *resp,
-					     void *data_buf)
+static int mwifiex_get_passphrase_from_cmdresp(struct mwifiex_private *priv,
+					       struct host_cmd_ds_command *resp,
+					       void *data_buf)
 {
 	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
 		&resp->params.esupp_psk;
@@ -656,117 +653,90 @@ static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_ssid_param_set *pssid_tlv = NULL;
 	struct mwifiex_ie_types_bssid *pbssid_tlv = NULL;
 	u8 *tlv_buf = (u8 *)supplicant_pmk_resp->tlv_buffer;
-	u16 action = le16_to_cpu(supplicant_pmk_resp->action);
 	int  tlv_buf_len = 0;
 	u16 tlv;
 
 	tlv_buf_len = le16_to_cpu(resp->size) -
 			(sizeof(struct host_cmd_ds_802_11_supplicant_pmk) +
 			S_DS_GEN-1);
+	passphrase = (struct mwifiex_ds_passphrase *)data_buf;
+
+	while (tlv_buf_len > 0) {
+		tlv = (*tlv_buf) | (*(tlv_buf + 1) << 8);
+		if ((tlv != WLAN_EID_SSID) && (tlv != TLV_TYPE_BSSID)
+		    && (tlv != TLV_TYPE_PASSPHRASE) && (tlv != TLV_TYPE_PMK))
+			break;
+		switch (tlv) {
+		case WLAN_EID_SSID:
+			pssid_tlv =
+			      (struct mwifiex_ie_types_ssid_param_set *)tlv_buf;
+			memcpy(passphrase->ssid.ssid, pssid_tlv->ssid,
+				le16_to_cpu(pssid_tlv->header.len));
+			passphrase->ssid.ssid_len =
+				le16_to_cpu(pssid_tlv->header.len);
+			tlv_buf += le16_to_cpu(pssid_tlv->header.len) +
+				sizeof(struct mwifiex_ie_types_header);
+			tlv_buf_len -= (le16_to_cpu(pssid_tlv->header.len)
+				+ sizeof(struct mwifiex_ie_types_header));
+			break;
+		case TLV_TYPE_BSSID:
+			pbssid_tlv = (struct mwifiex_ie_types_bssid *)tlv_buf;
+			memcpy(&passphrase->bssid, pbssid_tlv->bssid,
+				MWIFIEX_MAC_ADDR_LENGTH);
+			tlv_buf += le16_to_cpu(pbssid_tlv->header.len) +
+				sizeof(struct mwifiex_ie_types_header);
+			tlv_buf_len -= (le16_to_cpu(pbssid_tlv->header.len) +
+				sizeof(struct mwifiex_ie_types_header));
+			break;
+		case TLV_TYPE_PASSPHRASE:
+			passphrase_tlv =
+				(struct mwifiex_ie_types_passphrase *)tlv_buf;
+			passphrase->psk_type = MWIFIEX_PSK_PASSPHRASE;
+			passphrase->psk.passphrase.passphrase_len =
+				le16_to_cpu(passphrase_tlv->header.len);
+			memcpy(passphrase->psk.passphrase.passphrase,
+				passphrase_tlv->passphrase,
+				le16_to_cpu(passphrase_tlv->header.len));
+			tlv_buf += le16_to_cpu(passphrase_tlv->header.len)
+				+  sizeof(struct mwifiex_ie_types_header);
+			tlv_buf_len -= (le16_to_cpu(passphrase_tlv->header.len)
+				+ sizeof(struct mwifiex_ie_types_header));
+			break;
+		case TLV_TYPE_PMK:
+			ppmk_tlv = (struct mwifiex_ie_types_pmk *)tlv_buf;
+			passphrase->psk_type = MWIFIEX_PSK_PMK;
+			memcpy(passphrase->psk.pmk.pmk, ppmk_tlv->pmk,
+				le16_to_cpu(ppmk_tlv->header.len));
+			tlv_buf += le16_to_cpu(ppmk_tlv->header.len)
+				+ sizeof(struct mwifiex_ie_types_header);
+			tlv_buf_len -= (le16_to_cpu(ppmk_tlv->header.len)
+				+ sizeof(struct mwifiex_ie_types_header));
+			break;
+
+		}
+	}
+return 0;
+}
+
+/*
+ * This function handles the command response of set/get passphrase.
+ *
+ * Handling includes updating driver's private flag 'ewpa_query' (for action
+ * SET) and retrieving passphrase (for action GET) for specified
+ * SSID
+ */
+static int mwifiex_ret_802_11_supplicant_pmk(struct mwifiex_private *priv,
+					     struct host_cmd_ds_command *resp,
+					     void *data_buf)
+{
+	struct host_cmd_ds_802_11_supplicant_pmk *supplicant_pmk_resp =
+		&resp->params.esupp_psk;
+	u16 action = le16_to_cpu(supplicant_pmk_resp->action);
+
 	if (data_buf) {
-		passphrase = (struct mwifiex_ds_passphrase *)data_buf;
 		if (action == HostCmd_ACT_GEN_GET) {
-			while (tlv_buf_len > 0) {
-				tlv = (*tlv_buf) | (*(tlv_buf + 1) << 8);
-				if ((tlv != WLAN_EID_SSID)
-						&& (tlv != TLV_TYPE_BSSID)
-						&& (tlv != TLV_TYPE_PASSPHRASE)
-						&& (tlv != TLV_TYPE_PMK))
-					break;
-				switch (tlv) {
-				case WLAN_EID_SSID:
-					pssid_tlv =
-						(struct
-						mwifiex_ie_types_ssid_param_set
-						*)tlv_buf;
-					memcpy(passphrase->ssid.ssid,
-						pssid_tlv->ssid,
-						le16_to_cpu(
-						pssid_tlv->header.len));
-					passphrase->ssid.ssid_len =
-						le16_to_cpu(
-						pssid_tlv->header.len);
-					tlv_buf += le16_to_cpu(
-						pssid_tlv->header.len) +
-						sizeof(
-						struct mwifiex_ie_types_header);
-					tlv_buf_len -=
-						(le16_to_cpu(pssid_tlv->header
-						.len)
-						+ sizeof(
-						struct mwifiex_ie_types_header)
-						);
-					break;
-				case TLV_TYPE_BSSID:
-					pbssid_tlv =
-					       (struct mwifiex_ie_types_bssid *)
-						tlv_buf;
-					memcpy(&passphrase->bssid,
-						pbssid_tlv->bssid,
-						MWIFIEX_MAC_ADDR_LENGTH);
-					tlv_buf += le16_to_cpu(
-						pbssid_tlv->header.len) +
-						sizeof(
-						struct mwifiex_ie_types_header);
-					tlv_buf_len -=
-						(le16_to_cpu(
-						pbssid_tlv->header.len)
-						+ sizeof(
-						struct mwifiex_ie_types_header)
-						);
-					break;
-				case TLV_TYPE_PASSPHRASE:
-					passphrase_tlv =
-					  (struct mwifiex_ie_types_passphrase *)
-						tlv_buf;
-					passphrase->psk_type =
-						MWIFIEX_PSK_PASSPHRASE;
-					passphrase->psk.passphrase
-						.passphrase_len =
-						le16_to_cpu(
-						passphrase_tlv->header.len);
-					memcpy(passphrase->psk
-						.passphrase.passphrase,
-						passphrase_tlv->passphrase,
-						le16_to_cpu(
-						passphrase_tlv->header.len));
-					tlv_buf +=
-						le16_to_cpu(
-						passphrase_tlv->header.len)
-						+  sizeof(
-						struct mwifiex_ie_types_header);
-					tlv_buf_len -=
-						(le16_to_cpu(
-						passphrase_tlv->header.len)
-						+ sizeof(
-						struct mwifiex_ie_types_header)
-						);
-					break;
-				case TLV_TYPE_PMK:
-					ppmk_tlv =
-						(struct mwifiex_ie_types_pmk *)
-						tlv_buf;
-					passphrase->psk_type =
-						MWIFIEX_PSK_PMK;
-					memcpy(passphrase->psk
-						.pmk.pmk, ppmk_tlv->pmk,
-						le16_to_cpu(
-						ppmk_tlv->header.len));
-					tlv_buf +=
-						le16_to_cpu(
-						ppmk_tlv->header.len)
-						+ sizeof(
-						struct mwifiex_ie_types_header);
-					tlv_buf_len -=
-						(le16_to_cpu(
-						ppmk_tlv->header.len)
-						+ sizeof(
-						struct mwifiex_ie_types_header)
-						);
-					break;
-
-				}
-			}
+			mwifiex_get_passphrase_from_cmdresp(priv, resp,
+							    data_buf);
 		} else if (action == HostCmd_ACT_GEN_SET) {
 			dev_dbg(priv->adapter->dev,
 				"info: Esupp PMK set: enable ewpa query\n");
-- 
1.7.0.2

