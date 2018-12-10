Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE75C5CFFE
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8749B2082F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 18:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o2t/m5WK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G3uoXvNS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8749B2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbeLJSeD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 13:34:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42344 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbeLJSeC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 13:34:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F39A261341; Mon, 10 Dec 2018 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466841;
        bh=hGerwc4V1jOqWkLQ0Pu91q/8OFMGBcPozdN2GfkqJzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2t/m5WKy4qUwv5k8GUdQtlRh6jM8zFrtxrrr3CA+PpfjV1IXK8cr+9P/33uISe8f
         +bkPzNCr8wFiI6zvK48z9bTrd/WnENvf/NjFLucpS4RoAd1xkvNM4OwWVSo4IlKyf7
         PH8s+DzYrjRaU5LBlOIRuPQYu4X+cZ/os4y+NH4k=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4797D6151F;
        Mon, 10 Dec 2018 18:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544466839;
        bh=hGerwc4V1jOqWkLQ0Pu91q/8OFMGBcPozdN2GfkqJzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3uoXvNSKN1U2n6Axv6QjKKOMbJEQhiyUr7ku+N/PFF47ds9xLDDGH4ZmugUybxKs
         h/A8ix2ANZMrVJnc1Fqcf62u3JPFSmeSWoWRlgQPpKA70vaYKDHLA3lKCLnPB0L+Qs
         70+UnsV2NX85CwgcOnBU8ZGYehynL+qQanY7idcs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4797D6151F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH v3 3/3] ath10k: Add support to configure BB timing over wmi
Date:   Tue, 11 Dec 2018 00:01:31 +0530
Message-Id: <1544466691-11821-4-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
References: <1544466691-11821-1-git-send-email-bperumal@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add wmi configuration cmd to configure base band(BB) power amplifier(PA)
off timing values in hardware. The default PA off timings were fine tuned
to make proper DFS radar detection in QCA reference design. If ODM uses
different PA in their design, then the same default PA off timing values
cannot be used, it requires different settling time to detect radar pulses
very sooner and avoid radar detection problems. In that case it provides
provision to select proper PA off timing values based on the PA hardware used.
The PA component is part of FEM hardware and new device tree entry
"ext-fem-name" is used to indentify the FEM hardware. And this wmi configuration
cmd is enabled via wmi service flag "WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT".

Other way is to apply these values through calibration data, but recalibration
of all boards out there might not be feasible.

This change tested on firmware ver 10.2.4-1.0-00042 in QCA988X chipset.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 47 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 20 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 23 +++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 26 +++++++++++++++++
 4 files changed, 116 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1db2a30..5a1c9b6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -22,6 +22,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <linux/acpi.h>
+#include <linux/of.h>
 
 #include "hif.h"
 #include "core.h"
@@ -4637,11 +4638,44 @@ static int ath10k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 	return ret;
 }
 
+static int __ath10k_fetch_bb_timing_dt(struct ath10k *ar,
+				       struct wmi_bb_timing_cfg_arg *bb_timing)
+{
+	struct device_node *node;
+	const char *fem_name;
+	int ret;
+
+	node = ar->dev->of_node;
+	if (!node)
+		return -ENOENT;
+
+	ret = of_property_read_string_index(node, "ext-fem-name", 0, &fem_name);
+	if (ret)
+		return -ENOENT;
+
+	/*
+	 * If external Front End module used in hardware, then default base band timing
+	 * parameter cannot be used since they were fine tuned for reference hardware,
+	 * so choosing different value suitable for that external FEM.
+	 */
+	if (!strcmp("microsemi-lx5586", fem_name)) {
+		bb_timing->bb_tx_timing = 0x00;
+		bb_timing->bb_xpa_timing = 0x0101;
+	} else {
+		return -ENOENT;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot bb_tx_timing 0x%x bb_xpa_timing 0x%x\n",
+		   bb_timing->bb_tx_timing, bb_timing->bb_xpa_timing);
+	return 0;
+}
+
 static int ath10k_start(struct ieee80211_hw *hw)
 {
 	struct ath10k *ar = hw->priv;
 	u32 param;
 	int ret = 0;
+	struct wmi_bb_timing_cfg_arg bb_timing = {0};
 
 	/*
 	 * This makes sense only when restarting hw. It is harmless to call
@@ -4796,6 +4830,19 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
 	}
 
+	if (test_bit(WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT, ar->wmi.svc_map)) {
+		ret = __ath10k_fetch_bb_timing_dt(ar, &bb_timing);
+		if (!ret) {
+			ret = ath10k_wmi_pdev_bb_timing(ar, &bb_timing);
+			if (ret) {
+				ath10k_warn(ar,
+					    "failed to set bb timings: %d\n",
+					    ret);
+				goto err_core_stop;
+			}
+		}
+	}
+
 	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 7978a77..0466307 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -219,6 +219,9 @@ struct wmi_ops {
 	struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
 	struct sk_buff *(*gen_pdev_get_tpc_table_cmdid)(struct ath10k *ar,
 							u32 param);
+	struct sk_buff *(*gen_bb_timing)
+			(struct ath10k *ar,
+			 const struct wmi_bb_timing_cfg_arg *arg);
 
 };
 
@@ -1576,4 +1579,21 @@ struct wmi_ops {
 				   ar->wmi.cmd->radar_found_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_bb_timing(struct ath10k *ar,
+			  const struct wmi_bb_timing_cfg_arg *arg)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_bb_timing)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_bb_timing(ar, arg);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->set_bb_timing_cmdid);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 659513b..a1e8695 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -539,6 +539,7 @@
 		WMI_10_2_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
 	.pdev_get_tpc_table_cmdid = WMI_CMD_UNSUPPORTED,
 	.radar_found_cmdid = WMI_CMD_UNSUPPORTED,
+	.set_bb_timing_cmdid = WMI_10_2_PDEV_SET_BB_TIMING_CONFIG_CMDID,
 };
 
 /* 10.4 WMI cmd track */
@@ -8839,6 +8840,27 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	return 0;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_2_4_op_gen_bb_timing(struct ath10k *ar,
+				   const struct wmi_bb_timing_cfg_arg *arg)
+{
+	struct wmi_pdev_bb_timing_cfg_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_pdev_bb_timing_cfg_cmd *)skb->data;
+	cmd->bb_tx_timing = __cpu_to_le32(arg->bb_tx_timing);
+	cmd->bb_xpa_timing = __cpu_to_le32(arg->bb_xpa_timing);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi pdev bb_tx_timing 0x%x bb_xpa_timing 0x%x\n",
+		   arg->bb_tx_timing, arg->bb_xpa_timing);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -9112,6 +9134,7 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_pdev_enable_adaptive_cca =
 		ath10k_wmi_op_gen_pdev_enable_adaptive_cca,
 	.get_vdev_subtype = ath10k_wmi_10_2_4_op_get_vdev_subtype,
+	.gen_bb_timing = ath10k_wmi_10_2_4_op_gen_bb_timing,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 58e33ab..5e18dc0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -205,6 +205,7 @@ enum wmi_service {
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
 	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -244,6 +245,9 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_PEER_STATS,
 	WMI_10X_SERVICE_RESET_CHIP,
 	WMI_10X_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
+	WMI_10X_SERVICE_VDEV_BCN_RATE_CONTROL,
+	WMI_10X_SERVICE_PER_PACKET_SW_ENCRYPT,
+	WMI_10X_SERVICE_BB_TIMING_CONFIG_SUPPORT,
 };
 
 enum wmi_main_service {
@@ -568,6 +572,8 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_RESET_CHIP, len);
 	SVCMAP(WMI_10X_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	       WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, len);
+	SVCMAP(WMI_10X_SERVICE_BB_TIMING_CONFIG_SUPPORT,
+	       WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
@@ -986,6 +992,7 @@ struct wmi_cmd_map {
 	u32 pdev_wds_entry_list_cmdid;
 	u32 tdls_set_offchan_mode_cmdid;
 	u32 radar_found_cmdid;
+	u32 set_bb_timing_cmdid;
 };
 
 /*
@@ -1601,6 +1608,8 @@ enum wmi_10_2_cmd_id {
 	WMI_10_2_SET_LTEU_CONFIG_CMDID,
 	WMI_10_2_SET_CCA_PARAMS,
 	WMI_10_2_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
+	WMI_10_2_FWTEST_CMDID,
+	WMI_10_2_PDEV_SET_BB_TIMING_CONFIG_CMDID,
 	WMI_10_2_PDEV_UTF_CMDID = WMI_10_2_END_CMDID - 1,
 };
 
@@ -7153,6 +7162,23 @@ struct wmi_pdev_chan_info_req_cmd {
 	__le32 reserved;
 } __packed;
 
+/* bb timing register configurations */
+struct wmi_bb_timing_cfg_arg {
+	/* Tx_end to pa off timing */
+	u32 bb_tx_timing;
+
+	/* Tx_end to external pa off timing */
+	u32 bb_xpa_timing;
+};
+
+struct wmi_pdev_bb_timing_cfg_cmd {
+	/* Tx_end to pa off timing */
+	__le32 bb_tx_timing;
+
+	/* Tx_end to external pa off timing */
+	__le32 bb_xpa_timing;
+} __packed;
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.9.1

