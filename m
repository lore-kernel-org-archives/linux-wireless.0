Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DC7C10F00
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5664C20652
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bzq0NgOU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o0m07ysK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbfCFSDW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:03:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54246 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730675AbfCFSDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 13:03:21 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC5F461197; Wed,  6 Mar 2019 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895400;
        bh=ZmjNcNiBk9Y5tU+QyayO0rHxeodncPLmGuMsROdqDB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bzq0NgOUfPSmA9ywuyLasAtLZUYRkleXhCGTXs/fTtlIlkUeoMPmsL1QgMcDDhArF
         3Le6rMvtdfY4MBJbqUtNz14Qt/iCyMkV8jT/TPU2sFqilOFBhS//RpLuHsb8cQmxbT
         I6GYlRTkliBKY4rMzT6GSWOn0tjDONR0MTJHjwaA=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D25C61195;
        Wed,  6 Mar 2019 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895390;
        bh=ZmjNcNiBk9Y5tU+QyayO0rHxeodncPLmGuMsROdqDB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0m07ysKBBJaaNidR6eE4db3e2gm/P4y5bpAha0xX9zNdPG/inYED4WOSdZ0BMeot
         lg3ik7xfACFh6hqiiDk5+lII8A3sa8Ds7Rti6OIAZ6sJpcmAX6uI0WZSmP89aOzKWs
         KZk2tO0Xgh2thANuseFdfduiZFT185AxrCL1o9xU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D25C61195
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv3 7/9] ath10k: Add wmi command support for station specific TID config
Date:   Wed,  6 Mar 2019 23:30:49 +0530
Message-Id: <1551895251-22941-8-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
References: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds WMI interface to configure station specific
TID configuration . Host needs to send station's MAC address
along with TID number and its configuration to target through
WMI_10_4_PER_PEER_PER_TID_CONFIG_CMDID.

WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT flag is added to advertise
this support.

Testing:
   * Tested HW: QCA9888
   * Tested FW: 10.4-3.5.1-00052

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 19 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 32 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 52 +++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 1491c25..796badf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -216,6 +216,8 @@ struct wmi_ops {
 	struct sk_buff *(*gen_bb_timing)
 			(struct ath10k *ar,
 			 const struct wmi_bb_timing_cfg_arg *arg);
+	struct sk_buff *(*gen_per_peer_per_tid_cfg)(struct ath10k *ar,
+				const struct wmi_per_peer_per_tid_cfg_arg *arg);
 
 };
 
@@ -1616,4 +1618,21 @@ struct wmi_ops {
 	return ath10k_wmi_cmd_send(ar, skb,
 				   ar->wmi.cmd->set_bb_timing_cmdid);
 }
+
+static inline int
+ath10k_wmi_set_per_peer_per_tid_cfg(struct ath10k *ar,
+				const struct wmi_per_peer_per_tid_cfg_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_per_peer_per_tid_cfg)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_per_peer_per_tid_cfg(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->per_peer_per_tid_config_cmdid);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 52f1752..895b7b17 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -740,6 +740,7 @@
 	.tdls_peer_update_cmdid = WMI_10_4_TDLS_PEER_UPDATE_CMDID,
 	.tdls_set_offchan_mode_cmdid = WMI_10_4_TDLS_SET_OFFCHAN_MODE_CMDID,
 	.radar_found_cmdid = WMI_10_4_RADAR_FOUND_CMDID,
+	.per_peer_per_tid_config_cmdid = WMI_10_4_PER_PEER_PER_TID_CONFIG_CMDID,
 };
 
 /* MAIN WMI VDEV param map */
@@ -8880,6 +8881,36 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 }
 
 static struct sk_buff *
+ath10k_wmi_10_4_gen_per_peer_per_tid_cfg(struct ath10k *ar,
+				const struct wmi_per_peer_per_tid_cfg_arg *arg)
+{
+	struct wmi_peer_per_tid_cfg_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	memset(skb->data, 0, sizeof(*cmd));
+
+	cmd = (struct wmi_peer_per_tid_cfg_cmd *)skb->data;
+	cmd->vdev_id = cpu_to_le32(arg->vdev_id);
+	ether_addr_copy(cmd->peer_macaddr.addr, arg->peer_macaddr.addr);
+	cmd->tid = cpu_to_le32(arg->tid);
+	cmd->ack_policy = cpu_to_le32(arg->ack_policy);
+	cmd->aggr_control = cpu_to_le32(arg->aggr_control);
+	cmd->rate_control = cpu_to_le32(arg->rate_ctrl);
+	cmd->retry_count = cpu_to_le32(arg->retry_count);
+	cmd->rcode_flags = cpu_to_le32(arg->rcode_flags);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi noack tid %d vdev id %d ack_policy %d aggr %u rate_ctrl %u rcflag %u retry_count %d mac_addr %pM\n",
+		   arg->tid, arg->vdev_id, arg->ack_policy, arg->aggr_control, arg->rate_ctrl,
+		   arg->rcode_flags, arg->retry_count, arg->peer_macaddr.addr);
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_op_gen_echo(struct ath10k *ar, u32 value)
 {
 	struct wmi_echo_cmd *cmd;
@@ -9288,6 +9319,7 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_pdev_get_tpc_table_cmdid =
 			ath10k_wmi_10_4_op_gen_pdev_get_tpc_table_cmdid,
 	.gen_radar_found = ath10k_wmi_10_4_gen_radar_found,
+	.gen_per_peer_per_tid_cfg = ath10k_wmi_10_4_gen_per_peer_per_tid_cfg,
 
 	/* shared with 10.2 */
 	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a1a558b..5932f41 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -200,6 +200,7 @@ enum wmi_service {
 	WMI_SERVICE_RTT_RESPONDER_ROLE,
 	WMI_SERVICE_PER_PACKET_SW_ENCRYPT,
 	WMI_SERVICE_REPORT_AIRTIME,
+	WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT,
 
 	/* Remember to add the new value to wmi_service_name()! */
 
@@ -491,6 +492,7 @@ static inline char *wmi_service_name(enum wmi_service service_id)
 	SVCSTR(WMI_SERVICE_RTT_RESPONDER_ROLE);
 	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
 	SVCSTR(WMI_SERVICE_REPORT_AIRTIME);
+	SVCSTR(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT);
 
 	case WMI_SERVICE_MAX:
 		return NULL;
@@ -818,6 +820,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_PER_PACKET_SW_ENCRYPT, len);
 	SVCMAP(WMI_10_4_SERVICE_REPORT_AIRTIME,
 	       WMI_SERVICE_REPORT_AIRTIME, len);
+	SVCMAP(WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	       WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, len);
 }
 
 #undef SVCMAP
@@ -1019,6 +1023,7 @@ struct wmi_cmd_map {
 	u32 tdls_set_offchan_mode_cmdid;
 	u32 radar_found_cmdid;
 	u32 set_bb_timing_cmdid;
+	u32 per_peer_per_tid_config_cmdid;
 };
 
 /*
@@ -1860,6 +1865,8 @@ enum wmi_10_4_cmd_id {
 	WMI_10_4_PDEV_SET_BRIDGE_MACADDR_CMDID,
 	WMI_10_4_ATF_GROUP_WMM_AC_CONFIG_REQUEST_CMDID,
 	WMI_10_4_RADAR_FOUND_CMDID,
+	WMI_10_4_PEER_CFR_CAPTURE_CMDID,
+	WMI_10_4_PER_PEER_PER_TID_CONFIG_CMDID,
 	WMI_10_4_PDEV_UTF_CMDID = WMI_10_4_END_CMDID - 1,
 };
 
@@ -7156,6 +7163,51 @@ struct wmi_tdls_peer_event {
 	__le32 vdev_id;
 } __packed;
 
+enum wmi_tid_aggr_control_conf {
+	WMI_TID_CONFIG_AGGR_CONTROL_IGNORE,
+	WMI_TID_CONFIG_AGGR_CONTROL_ENABLE,
+	WMI_TID_CONFIG_AGGR_CONTROL_DISABLE,
+};
+
+enum wmi_noack_tid_conf {
+	WMI_NOACK_TID_CONFIG_IGNORE_ACK_POLICY,
+	WMI_PEER_TID_CONFIG_ACK,
+	WMI_PEER_TID_CONFIG_NOACK,
+};
+
+enum wmi_tid_rate_ctrl_conf {
+	WMI_TID_CONFIG_RATE_CONTROL_IGNORE,
+	WMI_TID_CONFIG_RATE_CONTROL_AUTO,
+	WMI_TID_CONFIG_RATE_CONTROL_FIXED_RATE,
+	WMI_TID_CONFIG_RATE_CONTROL_DEFAULT_LOWEST_RATE,
+};
+
+struct wmi_per_peer_per_tid_cfg_arg {
+	u32 vdev_id;
+	struct wmi_mac_addr peer_macaddr;
+	u32 tid;
+	enum wmi_noack_tid_conf ack_policy;
+	enum wmi_tid_aggr_control_conf aggr_control;
+	u8 rate_ctrl;
+	u32 retry_count;
+	u32 rcode_flags;
+};
+
+struct wmi_peer_per_tid_cfg_cmd {
+	__le32 vdev_id;
+	struct wmi_mac_addr peer_macaddr;
+	__le32 tid;
+
+	/* see enum wmi_noack_tid_conf */
+	__le32 ack_policy;
+	/* see enum wmi_tid_aggr_control_conf */
+	__le32 aggr_control;
+	/* see enum wmi_tid_rate_ctrl_conf */
+	__le32 rate_control;
+	__le32 rcode_flags;
+	__le32 retry_count;
+} __packed;
+
 enum wmi_txbf_conf {
 	WMI_TXBF_CONF_UNSUPPORTED,
 	WMI_TXBF_CONF_BEFORE_ASSOC,
-- 
1.9.1

