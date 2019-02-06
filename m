Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F93C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9BD02073D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D1zi108m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dzxuGqpn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfBFMOw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:14:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfBFMOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 07:14:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B3EC260907; Wed,  6 Feb 2019 12:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455290;
        bh=djcq2IIx4WLrwIUyzy6FYU1KIvSXJ0OE126f1ySzxNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1zi108mA84VgxLQt4GRmSvUm0PRSMQeJ9vitU4T7vHrsWhDA/F7K0DP2Cshe5xqx
         V1UJG47gaIe5RSOJvmu/u18U5KJ/T9Iy0gbs20IgH+b4smruhtbDDhtaAnCV4mBHvZ
         yZMeS+WziVx0SEMs5AhOp+kTTqF436ZjQyyWn5Uo=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D11D608CE;
        Wed,  6 Feb 2019 12:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455288;
        bh=djcq2IIx4WLrwIUyzy6FYU1KIvSXJ0OE126f1ySzxNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzxuGqpnPsBf8mumQAmDow7VuI26gQRkItv1gTtjaiUPRWg3GEBiOih8GpIz4r/zR
         RupaMn8N3VXqrCXVLr96exWztYQF/uQfeDAjJ2VUCbJebOlI+hkeQzOlyoq4UDJ73j
         AfJnSVR+s1Qy5KFu+uOCNy4DOlwAnQKrHEz6RXHU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3D11D608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 2/3] ath10k: Disable interface pause wow config for integrated chipset
Date:   Wed,  6 Feb 2019 17:44:32 +0530
Message-Id: <20190206121433.11606-3-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190206121433.11606-1-govinds@codeaurora.org>
References: <20190206121433.11606-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

wow pause iface config controls the PCI D0/D3-WOW cases for pcie
bus state. Firmware does not expects WOW_IFACE_PAUSE_ENABLED config
for bus/link that cannot be suspended ex:snoc and does not trigger
common subsystem shutdown.
Disable interface pause wow config for integrated chipset(WCN3990)
for correct WOW configuration in the firmware.

Testing:
    Tested on WCN3990 HW.
    Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c     |  5 +++--
 drivers/net/wireless/ath/ath10k/core.h     |  2 ++
 drivers/net/wireless/ath/ath10k/coredump.c |  2 +-
 drivers/net/wireless/ath/ath10k/debug.c    |  4 ++--
 drivers/net/wireless/ath/ath10k/htc.c      |  6 +++---
 drivers/net/wireless/ath/ath10k/htt_rx.c   | 10 +++++-----
 drivers/net/wireless/ath/ath10k/htt_tx.c   |  6 +++---
 drivers/net/wireless/ath/ath10k/pci.c      |  3 ++-
 drivers/net/wireless/ath/ath10k/txrx.c     |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  |  2 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h  |  7 +++++++
 11 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2bdb632b7b1a..01ad53f3c569 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2955,8 +2955,9 @@ static void ath10k_core_register_work(struct work_struct *work)
 int ath10k_core_register(struct ath10k *ar,
 			 const struct ath10k_bus_params *bus_params)
 {
-	ar->chip_id = bus_params->chip_id;
-	ar->dev_type = bus_params->dev_type;
+	ar->bus_param.chip_id = bus_params->chip_id;
+	ar->bus_param.dev_type = bus_params->dev_type;
+	ar->bus_param.link_can_suspend = bus_params->link_can_suspend;
 	queue_work(ar->workqueue, &ar->register_work);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d14a4f928218..2f43326decf6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -921,6 +921,7 @@ enum ath10k_dev_type {
 struct ath10k_bus_params {
 	u32 chip_id;
 	enum ath10k_dev_type dev_type;
+	bool link_can_suspend;
 };
 
 struct ath10k {
@@ -1189,6 +1190,7 @@ struct ath10k {
 	enum ath10k_radar_confirmation_state radar_conf_state;
 	struct ath10k_radar_found_info last_radar_info;
 	struct work_struct radar_confirmation_work;
+	struct ath10k_bus_params bus_param;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index eadae2f9206b..bf84e999466f 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1167,7 +1167,7 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 	dump_data->version = cpu_to_le32(ATH10K_FW_CRASH_DUMP_VERSION);
 
 	guid_copy(&dump_data->guid, &crash_data->guid);
-	dump_data->chip_id = cpu_to_le32(ar->chip_id);
+	dump_data->chip_id = cpu_to_le32(ar->bus_param.chip_id);
 	dump_data->bus_type = cpu_to_le32(0);
 	dump_data->target_version = cpu_to_le32(ar->target_version);
 	dump_data->fw_version_major = cpu_to_le32(ar->fw_version_major);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 02988fc378a1..9f2534d6b56f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -58,7 +58,7 @@ void ath10k_debug_print_hwfw_info(struct ath10k *ar)
 	ath10k_info(ar, "%s target 0x%08x chip_id 0x%08x sub %04x:%04x",
 		    ar->hw_params.name,
 		    ar->target_version,
-		    ar->chip_id,
+		    ar->bus_param.chip_id,
 		    ar->id.subsystem_vendor, ar->id.subsystem_device);
 
 	ath10k_info(ar, "kconfig debug %d debugfs %d tracing %d dfs %d testmode %d\n",
@@ -625,7 +625,7 @@ static ssize_t ath10k_read_chip_id(struct file *file, char __user *user_buf,
 	size_t len;
 	char buf[50];
 
-	len = scnprintf(buf, sizeof(buf), "0x%08x\n", ar->chip_id);
+	len = scnprintf(buf, sizeof(buf), "0x%08x\n", ar->bus_param.chip_id);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 28daed5981a1..7654a21323ce 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -53,7 +53,7 @@ static inline void ath10k_htc_restore_tx_skb(struct ath10k_htc *htc,
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 
-	if (htc->ar->dev_type != ATH10K_DEV_TYPE_HL)
+	if (htc->ar->bus_param.dev_type != ATH10K_DEV_TYPE_HL)
 		dma_unmap_single(htc->ar->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 	skb_pull(skb, sizeof(struct ath10k_htc_hdr));
 }
@@ -138,7 +138,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	ath10k_htc_prepare_tx_skb(ep, skb);
 
 	skb_cb->eid = eid;
-	if (ar->dev_type != ATH10K_DEV_TYPE_HL) {
+	if (ar->bus_param.dev_type != ATH10K_DEV_TYPE_HL) {
 		skb_cb->paddr = dma_map_single(dev, skb->data, skb->len,
 					       DMA_TO_DEVICE);
 		ret = dma_mapping_error(dev, skb_cb->paddr);
@@ -161,7 +161,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	return 0;
 
 err_unmap:
-	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type != ATH10K_DEV_TYPE_HL)
 		dma_unmap_single(dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
 err_credits:
 	if (ep->tx_credit_flow_enabled) {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 984b0458d077..519cb118344f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -265,7 +265,7 @@ int ath10k_htt_rx_ring_refill(struct ath10k *ar)
 	struct ath10k_htt *htt = &ar->htt;
 	int ret;
 
-	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 		return 0;
 
 	spin_lock_bh(&htt->rx_ring.lock);
@@ -282,7 +282,7 @@ int ath10k_htt_rx_ring_refill(struct ath10k *ar)
 
 void ath10k_htt_rx_free(struct ath10k_htt *htt)
 {
-	if (htt->ar->dev_type == ATH10K_DEV_TYPE_HL)
+	if (htt->ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 		return;
 
 	del_timer_sync(&htt->rx_ring.refill_retry_timer);
@@ -576,7 +576,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	size_t size;
 	struct timer_list *timer = &htt->rx_ring.refill_retry_timer;
 
-	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 		return 0;
 
 	htt->rx_confused = false;
@@ -2960,7 +2960,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_RX_IND:
-		if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 			return ath10k_htt_rx_proc_rx_ind_hl(htt,
 							    &resp->rx_ind_hl,
 							    skb);
@@ -3256,7 +3256,7 @@ void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
 
-	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 		htt->rx_ops = &htt_rx_ops_hl;
 	else if (ar->hw_params.target_64bit)
 		htt->rx_ops = &htt_rx_ops_64;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index ad05ab714c9b..fd6f9d453c2e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -495,7 +495,7 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
 	if (htt->tx_mem_allocated)
 		return 0;
 
-	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 		return 0;
 
 	ret = ath10k_htt_tx_alloc_buf(htt);
@@ -1177,7 +1177,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	return 0;
 
 err_unmap_msdu:
-	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type != ATH10K_DEV_TYPE_HL)
 		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 err_free_txdesc:
 	dev_kfree_skb_any(txdesc);
@@ -1714,7 +1714,7 @@ void ath10k_htt_set_tx_ops(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
 
-	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL)
 		htt->tx_ops = &htt_tx_ops_hl;
 	else if (ar->hw_params.target_64bit)
 		htt->tx_ops = &htt_tx_ops_64;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 01b4edb00e9e..edbaa0cb57a9 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2284,7 +2284,7 @@ static int ath10k_pci_get_num_banks(struct ath10k *ar)
 		return 1;
 	case QCA6164_2_1_DEVICE_ID:
 	case QCA6174_2_1_DEVICE_ID:
-		switch (MS(ar->chip_id, SOC_CHIP_ID_REV)) {
+		switch (MS(ar->bus_param.chip_id, SOC_CHIP_ID_REV)) {
 		case QCA6174_HW_1_0_CHIP_ID_REV:
 		case QCA6174_HW_1_1_CHIP_ID_REV:
 		case QCA6174_HW_2_1_CHIP_ID_REV:
@@ -3637,6 +3637,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	bus_params.dev_type = ATH10K_DEV_TYPE_LL;
+	bus_params.link_can_suspend = true;
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 	if (bus_params.chip_id == 0xffffffff) {
 		ath10k_err(ar, "failed to get chip id\n");
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 23606b6972d0..f13d88906b5a 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,7 +95,7 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
-	if (ar->dev_type != ATH10K_DEV_TYPE_HL)
+	if (ar->bus_param.dev_type != ATH10K_DEV_TYPE_HL)
 		dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	ath10k_report_offchan_tx(htt->ar, msdu);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ad4114a88170..a06e58dc8501 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3259,6 +3259,8 @@ ath10k_wmi_tlv_op_gen_wow_enable(struct ath10k *ar)
 	cmd = (void *)tlv->value;
 
 	cmd->enable = __cpu_to_le32(1);
+	if (!ar->bus_param.link_can_suspend)
+		cmd->pause_iface_config = WOW_IFACE_PAUSE_DISABLED;
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow enable\n");
 	return skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index e07e9907e355..c7adc4a3a5b4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1998,8 +1998,15 @@ struct wmi_tlv_set_quiet_cmd {
 	__le32 enabled;
 } __packed;
 
+enum wmi_tlv_wow_interface_cfg {
+	WOW_IFACE_PAUSE_ENABLED,
+	WOW_IFACE_PAUSE_DISABLED
+};
+
 struct wmi_tlv_wow_enable_cmd {
 	__le32 enable;
+	__le32 pause_iface_config;
+	__le32 flags;
 } __packed;
 
 struct wmi_tlv_wow_host_wakeup_ind {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

