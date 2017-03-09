Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37611 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752887AbdCIIkZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:40:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v298biwY027733
        for <linux-wireless@vger.kernel.org>; Thu, 9 Mar 2017 00:40:24 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2933c9042b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 00:40:24 -0800
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Devidas Puranik <devidas@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2 3/3] mwifiex: fix for unaligned reads
Date: Thu, 9 Mar 2017 14:06:17 +0530
Message-ID: <1489048577-11293-4-git-send-email-gbhat@marvell.com> (sfid-20170309_094038_747295_0FE0D165)
In-Reply-To: <1489048577-11293-1-git-send-email-gbhat@marvell.com>
References: <1489048577-11293-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Devidas Puranik <devidas@marvell.com>

Using the accessor function e.g. get_unaligned_le32 instead of
le32_to_cpu to avoid the unaligned access. This is for the
architectures that don't handle the unaligned memory access

Signed-off-by: Devidas Puranik <devidas@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  4 +--
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 37 ++++++++++------------
 drivers/net/wireless/marvell/mwifiex/sdio.c        | 23 ++++++++------
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 19 +++++------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  4 +--
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |  8 ++---
 drivers/net/wireless/marvell/mwifiex/tdls.c        | 10 +++---
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |  6 ++--
 9 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 25a7475..0c3b217 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -242,7 +242,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	mwifiex_dbg(adapter, CMD,
 		    "cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
 		    cmd_code,
-		    le16_to_cpu(*(__le16 *)((u8 *)host_cmd + S_DS_GEN)),
+		    get_unaligned_le16((u8 *)host_cmd + S_DS_GEN),
 		    cmd_size, le16_to_cpu(host_cmd->seq_num));
 	mwifiex_dbg_dump(adapter, CMD_D, "cmd buffer:", host_cmd, cmd_size);
 
@@ -286,7 +286,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 			(adapter->dbg.last_cmd_index + 1) % DBG_CMD_NUM;
 	adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index] = cmd_code;
 	adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index] =
-			le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN));
+			get_unaligned_le16((u8 *)host_cmd + S_DS_GEN);
 
 	/* Clear BSS_NO_BITS from HostCmd */
 	cmd_code &= HostCmd_CMD_ID_MASK;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a0d9180..1ee5189 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -119,7 +119,7 @@ static int mwifiex_read_reg_byte(struct mwifiex_adapter *adapter,
  */
 static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 {
-	u32 *cookie_addr;
+	u32 cookie_value;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
@@ -127,11 +127,11 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 		return true;
 
 	if (card->sleep_cookie_vbase) {
-		cookie_addr = (u32 *)card->sleep_cookie_vbase;
+		cookie_value = get_unaligned_le32(card->sleep_cookie_vbase);
 		mwifiex_dbg(adapter, INFO,
 			    "info: ACCESS_HW: sleep cookie=0x%x\n",
-			    *cookie_addr);
-		if (*cookie_addr == FW_AWAKE_COOKIE)
+			    cookie_value);
+		if (cookie_value == FW_AWAKE_COOKIE)
 			return true;
 	}
 
@@ -447,7 +447,7 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 					    sizeof(sleep_cookie),
 					    PCI_DMA_FROMDEVICE);
 		buffer = cmdrsp->data;
-		sleep_cookie = READ_ONCE(*(u32 *)buffer);
+		sleep_cookie = get_unaligned_le32(buffer);
 
 		if (sleep_cookie == MWIFIEX_DEF_SLEEP_COOKIE) {
 			mwifiex_dbg(adapter, INFO,
@@ -1049,6 +1049,7 @@ static int mwifiex_pcie_delete_cmdrsp_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	u32 tmp;
 
 	card->sleep_cookie_vbase = pci_alloc_consistent(card->dev, sizeof(u32),
 						     &card->sleep_cookie_pbase);
@@ -1058,11 +1059,12 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 		return -ENOMEM;
 	}
 	/* Init val of Sleep Cookie */
-	*(u32 *)card->sleep_cookie_vbase = FW_AWAKE_COOKIE;
+	tmp = FW_AWAKE_COOKIE;
+	put_unaligned(tmp, card->sleep_cookie_vbase);
 
 	mwifiex_dbg(adapter, INFO,
 		    "alloc_scook: sleep cookie=0x%x\n",
-		    *((u32 *)card->sleep_cookie_vbase));
+		    get_unaligned(card->sleep_cookie_vbase));
 
 	return 0;
 }
@@ -1223,7 +1225,6 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 	dma_addr_t buf_pa;
 	struct mwifiex_pcie_buf_desc *desc = NULL;
 	struct mwifiex_pfu_buf_desc *desc2 = NULL;
-	__le16 *tmp;
 
 	if (!(skb->data && skb->len)) {
 		mwifiex_dbg(adapter, ERROR,
@@ -1244,10 +1245,8 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 
 		adapter->data_sent = true;
 		payload = skb->data;
-		tmp = (__le16 *)&payload[0];
-		*tmp = cpu_to_le16((u16)skb->len);
-		tmp = (__le16 *)&payload[2];
-		*tmp = cpu_to_le16(MWIFIEX_TYPE_DATA);
+		put_unaligned_le16((u16)skb->len, payload + 0);
+		put_unaligned_le16(MWIFIEX_TYPE_DATA, payload + 2);
 
 		if (mwifiex_map_pci_memory(adapter, skb, skb->len,
 					   PCI_DMA_TODEVICE))
@@ -1376,7 +1375,6 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		(card->rxbd_rdptr & reg->rx_rollover_ind))) {
 		struct sk_buff *skb_data;
 		u16 rx_len;
-		__le16 pkt_len;
 
 		rd_index = card->rxbd_rdptr & reg->rx_mask;
 		skb_data = card->rx_buf_list[rd_index];
@@ -1393,8 +1391,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		/* Get data length from interface header -
 		 * first 2 bytes for len, next 2 bytes is for type
 		 */
-		pkt_len = *((__le16 *)skb_data->data);
-		rx_len = le16_to_cpu(pkt_len);
+		rx_len = get_unaligned_le16(skb_data->data);
 		if (WARN_ON(rx_len <= INTF_HEADER_LEN ||
 			    rx_len > MWIFIEX_RX_DATA_BUF_SIZE)) {
 			mwifiex_dbg(adapter, ERROR,
@@ -1601,8 +1598,8 @@ static int mwifiex_pcie_init_fw_port(struct mwifiex_adapter *adapter)
 
 	adapter->cmd_sent = true;
 
-	*(__le16 *)&payload[0] = cpu_to_le16((u16)skb->len);
-	*(__le16 *)&payload[2] = cpu_to_le16(MWIFIEX_TYPE_CMD);
+	put_unaligned_le16((u16)skb->len, &payload[0]);
+	put_unaligned_le16(MWIFIEX_TYPE_CMD, &payload[2]);
 
 	if (mwifiex_map_pci_memory(adapter, skb, skb->len, PCI_DMA_TODEVICE))
 		return -1;
@@ -1694,7 +1691,6 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 	struct sk_buff *skb = card->cmdrsp_buf;
 	int count = 0;
 	u16 rx_len;
-	__le16 pkt_len;
 
 	mwifiex_dbg(adapter, CMD,
 		    "info: Rx CMD Response\n");
@@ -1714,8 +1710,7 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		card->cmd_buf = NULL;
 	}
 
-	pkt_len = *((__le16 *)skb->data);
-	rx_len = le16_to_cpu(pkt_len);
+	rx_len = get_unaligned_le16(skb->data);
 	skb_put(skb, MWIFIEX_UPLD_SIZE - skb->len);
 	skb_trim(skb, rx_len);
 
@@ -1856,7 +1851,7 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		desc = card->evtbd_ring[rdptr];
 		memset(desc, 0, sizeof(*desc));
 
-		event = *(u32 *) &skb_cmd->data[INTF_HEADER_LEN];
+		event = get_unaligned_le32(&skb_cmd->data[INTF_HEADER_LEN]);
 		adapter->event_cause = event;
 		/* The first 4bytes will be the event transfer header
 		   len is 2 bytes followed by type which is 2 bytes */
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a4b356d..9f7cabf 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -943,7 +943,7 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
-	nb = le16_to_cpu(*(__le16 *) (buffer));
+	nb = get_unaligned_le16((buffer));
 	if (nb > npayload) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: invalid packet, nb=%d npayload=%d\n",
@@ -951,7 +951,7 @@ static int mwifiex_sdio_card_to_host(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
-	*type = le16_to_cpu(*(__le16 *) (buffer + 2));
+	*type = get_unaligned_le16((buffer + 2));
 
 	return ret;
 }
@@ -1139,7 +1139,8 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 				    __func__, blk_num, blk_size, total_pkt_len);
 			break;
 		}
-		pkt_len = le16_to_cpu(*(__le16 *)(data + SDIO_HEADER_OFFSET));
+		pkt_len = get_unaligned_le16((data +
+					     SDIO_HEADER_OFFSET));
 		if ((pkt_len + SDIO_HEADER_OFFSET) > blk_size) {
 			mwifiex_dbg(adapter, ERROR,
 				    "%s: error in pkt_len,\t"
@@ -1172,10 +1173,11 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 				    struct sk_buff *skb, u32 upld_typ)
 {
 	u8 *cmd_buf;
-	__le16 *curr_ptr = (__le16 *)skb->data;
-	u16 pkt_len = le16_to_cpu(*curr_ptr);
+	u16 pkt_len;
 	struct mwifiex_rxinfo *rx_info;
 
+	pkt_len = get_unaligned_le16(skb->data);
+
 	if (upld_typ != MWIFIEX_TYPE_AGGR_DATA) {
 		skb_trim(skb, pkt_len);
 		skb_pull(skb, INTF_HEADER_LEN);
@@ -1235,7 +1237,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
 	case MWIFIEX_TYPE_EVENT:
 		mwifiex_dbg(adapter, EVENT,
 			    "info: --- Rx: Event ---\n");
-		adapter->event_cause = le32_to_cpu(*(__le32 *) skb->data);
+		adapter->event_cause = get_unaligned_le32(skb->data);
 
 		if ((skb->len > 0) && (skb->len  < MAX_EVENT_SIZE))
 			memcpy(adapter->event_body,
@@ -1392,8 +1394,8 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 			u32 *len_arr = card->mpa_rx.len_arr;
 
 			/* get curr PKT len & type */
-			pkt_len = le16_to_cpu(*(__le16 *) &curr_ptr[0]);
-			pkt_type = le16_to_cpu(*(__le16 *) &curr_ptr[2]);
+			pkt_len = get_unaligned_le16(&curr_ptr[0]);
+			pkt_type = get_unaligned_le16(&curr_ptr[2]);
 
 			/* copy pkt to deaggr buf */
 			skb_deaggr = mwifiex_alloc_dma_align_buf(len_arr[pind],
@@ -1874,8 +1876,9 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	/* Allocate buffer and copy payload */
 	blk_size = MWIFIEX_SDIO_BLOCK_SIZE;
 	buf_block_len = (pkt_len + blk_size - 1) / blk_size;
-	*(__le16 *)&payload[0] = cpu_to_le16((u16)pkt_len);
-	*(__le16 *)&payload[2] = cpu_to_le16(type);
+	put_unaligned_le16((u16)pkt_len, payload + 0);
+	put_unaligned_le16((u32)type, payload + 2);
+
 
 	/*
 	 * This is SDIO specific header
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index cf9121e..f6056ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -130,7 +130,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 	} else if (cmd_action == HostCmd_ACT_GEN_SET) {
 		snmp_mib->query_type = cpu_to_le16(HostCmd_ACT_GEN_SET);
 		snmp_mib->buf_size = cpu_to_le16(sizeof(u16));
-		*((__le16 *) (snmp_mib->value)) = cpu_to_le16(*ul_temp);
+		put_unaligned_le16(*ul_temp, snmp_mib->value);
 		le16_unaligned_add_cpu(&cmd->size, sizeof(u16));
 	}
 
@@ -138,7 +138,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		    "cmd: SNMP_CMD: Action=0x%x, OID=0x%x,\t"
 		    "OIDSize=0x%x, Value=0x%x\n",
 		    cmd_action, cmd_oid, le16_to_cpu(snmp_mib->buf_size),
-		    le16_to_cpu(*(__le16 *)snmp_mib->value));
+		    get_unaligned_le16(snmp_mib->value));
 	return 0;
 }
 
@@ -1400,7 +1400,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 		filter = &mef_entry->filter[i];
 		if (!filter->filt_type)
 			break;
-		*(__le32 *)stack_ptr = cpu_to_le32((u32)filter->repeat);
+		put_unaligned_le32((u32)filter->repeat, stack_ptr);
 		stack_ptr += 4;
 		*stack_ptr = TYPE_DNUM;
 		stack_ptr += 1;
@@ -1412,8 +1412,7 @@ static int mwifiex_cmd_reg_access(struct host_cmd_ds_command *cmd,
 		stack_ptr += 1;
 		*stack_ptr = TYPE_BYTESEQ;
 		stack_ptr += 1;
-
-		*(__le32 *)stack_ptr = cpu_to_le32((u32)filter->offset);
+		put_unaligned_le32((u32)filter->offset, stack_ptr);
 		stack_ptr += 4;
 		*stack_ptr = TYPE_DNUM;
 		stack_ptr += 1;
@@ -1787,7 +1786,7 @@ static int mwifiex_cmd_chan_region_cfg(struct mwifiex_private *priv,
 			return -ENODATA;
 		}
 
-		*(__le16 *)pos = cpu_to_le16(params->capability);
+		put_unaligned_le16(params->capability, pos);
 		config_len += sizeof(params->capability);
 
 		qos_info = params->uapsd_queues | (params->max_sp << 5);
@@ -2036,7 +2035,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_VERSION_EXT:
 		cmd_ptr->command = cpu_to_le16(cmd_no);
 		cmd_ptr->params.verext.version_str_sel =
-			(u8) (*((u32 *) data_buf));
+			(u8)(get_unaligned((u32 *)data_buf));
 		memcpy(&cmd_ptr->params, data_buf,
 		       sizeof(struct host_cmd_ds_version_ext));
 		cmd_ptr->size =
@@ -2047,7 +2046,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_MGMT_FRAME_REG:
 		cmd_ptr->command = cpu_to_le16(cmd_no);
 		cmd_ptr->params.reg_mask.action = cpu_to_le16(cmd_action);
-		cmd_ptr->params.reg_mask.mask = cpu_to_le32(*(u32 *)data_buf);
+		cmd_ptr->params.reg_mask.mask = cpu_to_le32(
+						get_unaligned((u32 *)data_buf));
 		cmd_ptr->size =
 			cpu_to_le16(sizeof(struct host_cmd_ds_mgmt_frame_reg) +
 				    S_DS_GEN);
@@ -2067,7 +2067,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	case HostCmd_CMD_P2P_MODE_CFG:
 		cmd_ptr->command = cpu_to_le16(cmd_no);
 		cmd_ptr->params.mode_cfg.action = cpu_to_le16(cmd_action);
-		cmd_ptr->params.mode_cfg.mode = cpu_to_le16(*(u16 *)data_buf);
+		cmd_ptr->params.mode_cfg.mode = cpu_to_le16(
+						get_unaligned((u16 *)data_buf));
 		cmd_ptr->size =
 			cpu_to_le16(sizeof(struct host_cmd_ds_p2p_mode_cfg) +
 				    S_DS_GEN);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 8548027..ab75da3 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -183,7 +183,7 @@ static int mwifiex_ret_802_11_snmp_mib(struct mwifiex_private *priv,
 		    "query_type = %#x, buf size = %#x\n",
 		    oid, query_type, le16_to_cpu(smib->buf_size));
 	if (query_type == HostCmd_ACT_GEN_GET) {
-		ul_temp = le16_to_cpu(*((__le16 *) (smib->value)));
+		ul_temp = get_unaligned_le16(smib->value);
 		if (data_buf)
 			*data_buf = ul_temp;
 		switch (oid) {
@@ -741,7 +741,7 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
 	struct host_cmd_ds_p2p_mode_cfg *mode_cfg = &resp->params.mode_cfg;
 
 	if (data_buf)
-		*((u16 *)data_buf) = le16_to_cpu(mode_cfg->mode);
+		put_unaligned_le16(le16_to_cpu(mode_cfg->mode), data_buf);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index d63d163..b5b7664 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -670,7 +670,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->dbg.num_event_deauth++;
 		if (priv->media_connected) {
 			reason_code =
-				le16_to_cpu(*(__le16 *)adapter->event_body);
+				get_unaligned_le16(adapter->event_body);
 			mwifiex_reset_connect_state(priv, reason_code, true);
 		}
 		break;
@@ -685,7 +685,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->dbg.num_event_disassoc++;
 		if (priv->media_connected) {
 			reason_code =
-				le16_to_cpu(*(__le16 *)adapter->event_body);
+				get_unaligned_le16(adapter->event_body);
 			mwifiex_reset_connect_state(priv, reason_code, true);
 		}
 		break;
@@ -695,7 +695,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		adapter->dbg.num_event_link_lost++;
 		if (priv->media_connected) {
 			reason_code =
-				le16_to_cpu(*(__le16 *)adapter->event_body);
+				get_unaligned_le16(adapter->event_body);
 			mwifiex_reset_connect_state(priv, reason_code, true);
 		}
 		break;
@@ -923,7 +923,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					      adapter->event_body);
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
-		ctrl = le16_to_cpu(*(__le16 *)adapter->event_body);
+		ctrl = get_unaligned_le16(adapter->event_body);
 		mwifiex_dbg(adapter, EVENT,
 			    "event: AMSDU_AGGR_CTRL %d\n", ctrl);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index df9704de0..e228c03 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -857,7 +857,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 	struct mwifiex_sta_node *sta_ptr;
 	u8 *peer, *pos, *end;
 	u8 i, action, basic;
-	__le16 cap = 0;
+	u16 cap = 0;
 	int ie_len = 0;
 
 	if (len < (sizeof(struct ethhdr) + 3))
@@ -879,7 +879,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 
 		pos = buf + sizeof(struct ethhdr) + 4;
 		/* payload 1+ category 1 + action 1 + dialog 1 */
-		cap = cpu_to_le16(*(u16 *)pos);
+		cap = get_unaligned_le16(pos);
 		ie_len = len - sizeof(struct ethhdr) - TDLS_REQ_FIX_LEN;
 		pos += 2;
 		break;
@@ -889,7 +889,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 			return;
 		/* payload 1+ category 1 + action 1 + dialog 1 + status code 2*/
 		pos = buf + sizeof(struct ethhdr) + 6;
-		cap = cpu_to_le16(*(u16 *)pos);
+		cap = get_unaligned_le16(pos);
 		ie_len = len - sizeof(struct ethhdr) - TDLS_RESP_FIX_LEN;
 		pos += 2;
 		break;
@@ -909,7 +909,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 	if (!sta_ptr)
 		return;
 
-	sta_ptr->tdls_cap.capab = cap;
+	sta_ptr->tdls_cap.capab = cpu_to_le16(cap);
 
 	for (end = pos + ie_len; pos + 1 < end; pos += 2 + pos[1]) {
 		if (pos + 2 + pos[1] > end)
@@ -969,7 +969,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 		case WLAN_EID_AID:
 			if (priv->adapter->is_hw_11ac_capable)
 				sta_ptr->tdls_cap.aid =
-					      le16_to_cpu(*(__le16 *)(pos + 2));
+					get_unaligned_le16((pos + 2));
 		default:
 			break;
 		}
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index d24eca3..e10b2a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -202,7 +202,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 			    "AP EVENT: event id: %#x\n", eventcause);
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
-		ctrl = le16_to_cpu(*(__le16 *)adapter->event_body);
+		ctrl = get_unaligned_le16(adapter->event_body);
 		mwifiex_dbg(adapter, EVENT,
 			    "event: AMSDU_AGGR_CTRL %d\n", ctrl);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index b1ab8da..0cd68ff 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -274,13 +274,13 @@ int mwifiex_debug_info_to_buffer(struct mwifiex_private *priv, char *buf,
 				val = *((u8 *)addr);
 				break;
 			case 2:
-				val = *((u16 *)addr);
+				val = get_unaligned((u16 *)addr);
 				break;
 			case 4:
-				val = *((u32 *)addr);
+				val = get_unaligned((u32 *)addr);
 				break;
 			case 8:
-				val = *((long long *)addr);
+				val = get_unaligned((long long *)addr);
 				break;
 			default:
 				val = -1;
-- 
1.9.1
