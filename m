Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbeECGBd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 02:01:33 -0400
From: Yu Wang <yyuwang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add quiet mode support for QCA6174/QCA9377
Date: Thu,  3 May 2018 14:01:25 +0800
Message-Id: <1525327285-15392-2-git-send-email-yyuwang@codeaurora.org> (sfid-20180503_080215_506531_84A61733)
In-Reply-To: <1525327285-15392-1-git-send-email-yyuwang@codeaurora.org>
References: <1525327285-15392-1-git-send-email-yyuwang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable thermal throttling for QCA6174 and QCA9377,
implement gen_pdev_set_quiet_mode for them.
With this change, quiet period for QCA6174/QCA9377 can
be also set/get via debugfs.
Usage:
To set quiet period:
 echo <period> > /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period
To get the current quiet period:
 cat /sys/kernel/debug/ieee80211/phyX/ath10k/quiet_period

This change has been verified with
QCA6174 hw3.2(fw: WLAN_RM.4.4.1-00102-QCARMSWP-1).

Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 33 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 16 +++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 01f4eb2..2e34a1f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3136,6 +3136,37 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 }
 
 static struct sk_buff *
+ath10k_wmi_tlv_op_gen_pdev_set_quiet_mode(struct ath10k *ar, u32 period,
+					  u32 duration, u32 next_offset,
+					  u32 enabled)
+{
+	struct wmi_tlv_set_quiet_cmd *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*tlv) + sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	tlv = (void *)skb->data;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_PDEV_SET_QUIET_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	/* vdev_id is not in use, set to 0 */
+	cmd->vdev_id = __cpu_to_le32(0);
+	cmd->period = __cpu_to_le32(period);
+	cmd->duration = __cpu_to_le32(duration);
+	cmd->next_start = __cpu_to_le32(next_offset);
+	cmd->enabled = __cpu_to_le32(enabled);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv quiet param: period %u duration %u enabled %d\n",
+		   period, duration, enabled);
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_tlv_op_gen_wow_enable(struct ath10k *ar)
 {
 	struct wmi_tlv_wow_enable_cmd *cmd;
@@ -3854,7 +3885,7 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_dbglog_cfg = ath10k_wmi_tlv_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
-	/* .gen_pdev_set_quiet_mode not implemented */
+	.gen_pdev_set_quiet_mode = ath10k_wmi_tlv_op_gen_pdev_set_quiet_mode,
 	.gen_pdev_get_temperature = ath10k_wmi_tlv_op_gen_pdev_get_temperature,
 	/* .gen_addba_clear_resp not implemented */
 	/* .gen_addba_send not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 954c50b..3e1e340 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1952,6 +1953,21 @@ struct wmi_tlv_wow_add_del_event_cmd {
 	__le32 event_bitmap;
 } __packed;
 
+/* Command to set/unset chip in quiet mode */
+struct wmi_tlv_set_quiet_cmd {
+	__le32 vdev_id;
+
+	/* in TUs */
+	__le32 period;
+
+	/* in TUs */
+	__le32 duration;
+
+	/* offset in TUs */
+	__le32 next_start;
+	__le32 enabled;
+} __packed;
+
 struct wmi_tlv_wow_enable_cmd {
 	__le32 enable;
 } __packed;
-- 
1.9.1
