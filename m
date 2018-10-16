Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22DDC5ACCA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCA42098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:43:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nTXoGbpF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Sm0wE2SZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DCA42098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbeJQCev (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 22:34:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51946 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbeJQCev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 22:34:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0B2E7612F8; Tue, 16 Oct 2018 18:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715384;
        bh=82m2gsDQbZXrDpXY1XyFC5VJxW+ZGNw7dplweqRPZKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTXoGbpFCBLR8dtpew+ccjfGTcf735hj9LMkVh5OReCE5gcokGgMLPRDLcCAy87t9
         GchAUSW12wykzuYGWiz7PzyERFsR2eGMcNcdCX03YWDGuNr7zPK8VtoB/2d0ac1S7L
         t2efNePCreH9e7alZGRdeYDQpUZUo4RAHNhxLWYw=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7328A61322;
        Tue, 16 Oct 2018 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715381;
        bh=82m2gsDQbZXrDpXY1XyFC5VJxW+ZGNw7dplweqRPZKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sm0wE2SZgkIAg34Y5TEMvdyAcnIpV5r2CYie/oj4HbmdDImsAlgGLYSaGOu7lVWHa
         jNan7+zxUtzgnoF+tseKWx8gXe/ucrr2jBgBrqVYDhnEL7ciSSwlCtKKppoV6234e2
         k5NRNRJkF3HWuT4enHqBCbe4IQo+tFzrBURpB+1c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7328A61322
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 5/6] ath10k: Add wmi command support for station specific TID config
Date:   Wed, 17 Oct 2018 00:11:10 +0530
Message-Id: <1539715271-14325-6-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
References: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds WMI interface to support station specific
TID configuration like setting noack policy. Host needs to send
station's MAC address, ack policy and TID info to target through
WMI_10_4_PER_PEER_PER_TID_CONFIG_CMDID.

WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT flag is added to advertise
this support.

Testing:
   * Tested HW: QCA9888
   * Tested FW: 10.4-3.5.1-00052

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 19 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 29 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 50 +++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 7978a77..65be00e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -219,6 +219,8 @@ struct wmi_ops {
 	struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
 	struct sk_buff *(*gen_pdev_get_tpc_table_cmdid)(struct ath10k *ar,
 							u32 param);
+	struct sk_buff *(*gen_per_peer_per_tid_cfg)(struct ath10k *ar,
+				const struct wmi_per_peer_per_tid_cfg_arg *arg);
 
 };
 
@@ -1576,4 +1578,21 @@ struct wmi_ops {
 				   ar->wmi.cmd->radar_found_cmdid);
 }
 
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
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 25e8fa7..14fdc94 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -750,6 +750,7 @@
 	.tdls_peer_update_cmdid = WMI_10_4_TDLS_PEER_UPDATE_CMDID,
 	.tdls_set_offchan_mode_cmdid = WMI_10_4_TDLS_SET_OFFCHAN_MODE_CMDID,
 	.radar_found_cmdid = WMI_10_4_RADAR_FOUND_CMDID,
+	.per_peer_per_tid_config_cmdid = WMI_10_4_PER_PEER_PER_TID_CONFIG_CMDID,
 };
 
 /* MAIN WMI VDEV param map */
@@ -8744,6 +8745,33 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
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
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi noack tid %d vdev id %d ack_policy %d aggr %u rate %u mac_addr %pM\n",
+		   arg->tid, arg->vdev_id, arg->ack_policy, arg->aggr_control, arg->rate_ctrl, arg->peer_macaddr.addr);
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_op_gen_echo(struct ath10k *ar, u32 value)
 {
 	struct wmi_echo_cmd *cmd;
@@ -9128,6 +9156,7 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_pdev_get_tpc_table_cmdid =
 			ath10k_wmi_10_4_op_gen_pdev_get_tpc_table_cmdid,
 	.gen_radar_found = ath10k_wmi_10_4_gen_radar_found,
+	.gen_per_peer_per_tid_cfg = ath10k_wmi_10_4_gen_per_peer_per_tid_cfg,
 
 	/* shared with 10.2 */
 	.pull_echo_ev = ath10k_wmi_op_pull_echo_ev,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index f7badd0..d3571b6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -205,6 +205,7 @@ enum wmi_service {
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
 	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -474,6 +475,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
+	SVCSTR(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT);
 	default:
 		return NULL;
 	}
@@ -786,6 +788,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
 	SVCMAP(WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
 	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	       WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, len);
 }
 
 #undef SVCMAP
@@ -986,6 +990,7 @@ struct wmi_cmd_map {
 	u32 pdev_wds_entry_list_cmdid;
 	u32 tdls_set_offchan_mode_cmdid;
 	u32 radar_found_cmdid;
+	u32 per_peer_per_tid_config_cmdid;
 };
 
 /*
@@ -1825,6 +1830,8 @@ enum wmi_10_4_cmd_id {
 	WMI_10_4_PDEV_SET_BRIDGE_MACADDR_CMDID,
 	WMI_10_4_ATF_GROUP_WMM_AC_CONFIG_REQUEST_CMDID,
 	WMI_10_4_RADAR_FOUND_CMDID,
+	WMI_10_4_PEER_CFR_CAPTURE_CMDID,
+	WMI_10_4_PER_PEER_PER_TID_CONFIG_CMDID,
 	WMI_10_4_PDEV_UTF_CMDID = WMI_10_4_END_CMDID - 1,
 };
 
@@ -7053,6 +7060,49 @@ struct wmi_tdls_peer_event {
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
+	enum wmi_tid_rate_ctrl_conf rate_ctrl;
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
+	__le32 rcode_rcflags;
+	__le32 sw_retry_threshold;
+} __packed;
+
 enum wmi_txbf_conf {
 	WMI_TXBF_CONF_UNSUPPORTED,
 	WMI_TXBF_CONF_BEFORE_ASSOC,
-- 
1.9.1

