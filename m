Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BCDC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5E24207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JCTRPT5K";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dZr7+y3L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfBVFeq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 00:34:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbfBVFeq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 00:34:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 288C760A76; Fri, 22 Feb 2019 05:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813685;
        bh=c9RCmFyOVkMSXbhs4ZxnwA4IrTqirJ5HNxzO3YUH3iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCTRPT5KJGO/4myGozIM9+KcV+Z44EnNMHQoal7l3UBWQtxIm1SSJwFbG9GPkyVLs
         l61KIWyHc2j6NlQFGhYth8trT835qJm3GMJbT8+qy8qV8BoiwlVWL4qKwIGqrGthTt
         IYOhDIdSCa+Gg+ifd+O3F+27tQSWH/WF5pYTx00c=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 87D1A60A97;
        Fri, 22 Feb 2019 05:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813682;
        bh=c9RCmFyOVkMSXbhs4ZxnwA4IrTqirJ5HNxzO3YUH3iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZr7+y3L2ygv/XN5tTX5LbZATWHSnqXv16oRbKSiWxzM7lAbBNUhm1xiu2duRX9dg
         aZdexvOB4xqM2FaHiFFZcTST5+5beAkBo8sqy8mTFFNWXZ7lmC93Jew4gnZFFkWqwj
         s0IsSJwpXB753CDpVuhkqXZ0YKz4j8pS53c68eno=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 87D1A60A97
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 9/9] ath10k: Add extended TID configuration support
Date:   Fri, 22 Feb 2019 11:02:34 +0530
Message-Id: <1550813554-11581-10-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch extend TID configuration support to configure
RTS_CTS control and TX rate limit. Tx rate limit is
similar to auto rate but it will be limited to the user
configured rate mask rather than the station's highest
supported rate mask. Here ext_tid_cfg_bitmap added
to notify the target which extended configuration
parameter has modified(here RTS_CTS).

WMI_10_4_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT service flag
introduced to advertise this support.

Testing:
	* Tested HW: QCA9984
	* Tested FW: 10.4-3.9.0.2-00021

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c |  4 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 48 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |  7 ++---
 drivers/net/wireless/ath/ath10k/wmi.h  | 20 ++++++++++++++
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ac2cf3f..248709d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2623,6 +2623,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		if (test_bit(WMI_SERVICE_REPORT_AIRTIME, ar->wmi.svc_map))
 			val |= WMI_10_4_REPORT_AIRTIME;
 
+		if (test_bit(WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+			     ar->wmi.svc_map))
+			val |= WMI_10_4_EXT_PEER_TID_CONFIGS_SUPPORT;
+
 		status = ath10k_mac_ext_resource_config(ar, val);
 		if (status) {
 			ath10k_err(ar,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5ba399f..eccda87 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2950,6 +2950,12 @@ static int ath10k_new_peer_tid_config(struct ath10k *ar,
 			arg.aggr_control = vif->ampdu[i];
 			arg.rate_ctrl = vif->rate_ctrl[i];
 			arg.rcode_flags = vif->rate_code[i];
+			if (vif->rtscts[i])
+				arg.ext_tid_cfg_bitmap =
+					WMI_EXT_TID_RTS_CTS_CONFIG;
+			else
+				arg.ext_tid_cfg_bitmap = 0;
+			arg.rtscts_ctrl = vif->rtscts[i];
 		}
 
 		if (vif->noack[i]) {
@@ -6559,6 +6565,10 @@ static int ath10k_mac_validate_rate_mask(struct ath10k *ar,
 
 	if (txrate_type == NL80211_TX_RATE_FIXED)
 		*rate_ctrl = WMI_TID_CONFIG_RATE_CONTROL_FIXED_RATE;
+	else if (txrate_type == NL80211_TX_RATE_LIMITED &&
+		 (test_bit(WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+			   ar->wmi.svc_map)))
+		*rate_ctrl = WMI_PEER_TID_CONFIG_RATE_UPPER_CAP;
 	else
 		return -EOPNOTSUPP;
 	return 0;
@@ -6625,6 +6635,14 @@ static int ath10k_mac_validate_rate_mask(struct ath10k *ar,
 			arg->rate_ctrl = 0;
 		}
 	}
+
+	if (changed & IEEE80211_TID_CONF_RTSCTS) {
+		if (tid_conf->rtscts)
+			arg->rtscts_ctrl = tid_conf->rtscts - 1;
+		else
+			arg->rtscts_ctrl = WMI_TID_CONFIG_RTSCTS_CONTROL_ENABLE;
+		arg->ext_tid_cfg_bitmap = WMI_EXT_TID_RTS_CTS_CONFIG;
+	}
 }
 
 static void ath10k_sta_tid_cfg_wk(struct work_struct *wk)
@@ -6699,6 +6717,18 @@ static void ath10k_sta_tid_cfg_wk(struct work_struct *wk)
 			}
 		}
 
+		if (changed & IEEE80211_TID_CONF_RTSCTS) {
+			if (sta->rtscts[i]) {
+				arg.rtscts_ctrl = 0;
+				arg.ext_tid_cfg_bitmap = 0;
+			} else {
+				arg.rtscts_ctrl = vif->rtscts[i] - 1;
+				arg.ext_tid_cfg_bitmap =
+					WMI_EXT_TID_RTS_CTS_CONFIG;
+				config_apply = true;
+			}
+		}
+
 		arg.tid = i;
 
 		if (config_apply) {
@@ -8375,6 +8405,13 @@ static int ath10k_mac_op_set_tid_config(struct ieee80211_hw *hw,
 				arg.rate_ctrl = 0;
 				arg.rcode_flags = 0;
 			}
+
+			if (changed & IEEE80211_TID_CONF_RTSCTS) {
+				sta->rtscts[arg.tid] =
+					tid_config->tid_conf[i].rtscts;
+				arg.rtscts_ctrl = 0;
+				arg.ext_tid_cfg_bitmap = 0;
+			}
 		} else {
 			arvif->tid_conf_changed[arg.tid] |= changed;
 
@@ -8391,6 +8428,10 @@ static int ath10k_mac_op_set_tid_config(struct ieee80211_hw *hw,
 				vif->rate_ctrl[arg.tid] = arg.rate_ctrl;
 				vif->rate_code[arg.tid] = arg.rcode_flags;
 			}
+
+			if (changed & IEEE80211_TID_CONF_RTSCTS)
+				vif->rtscts[arg.tid] =
+					tid_config->tid_conf[i].rtscts;
 		}
 	}
 
@@ -9137,6 +9178,13 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->ops->set_tid_config = NULL;
 		ar->hw->wiphy->flags &= ~WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT;
 	}
+
+	if (test_bit(WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT, ar->wmi.svc_map)) {
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_PER_TID_RTSCTS_CTRL);
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_PER_STA_RTSCTS_CTRL);
+	}
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 44b66f2..583c398 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8886,9 +8886,10 @@ static u32 ath10k_wmi_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	cmd->rcode_flags = cpu_to_le32(arg->rcode_flags);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi noack tid %d vdev id %d ack_policy %d aggr %u rate_ctrl %u rcflag %u retry_count %d mac_addr %pM\n",
-		   arg->tid, arg->vdev_id, arg->ack_policy, arg->aggr_control, arg->rate_ctrl,
-		   arg->rcode_flags, arg->retry_count, arg->peer_macaddr.addr);
+		   "wmi noack tid %d vdev id %d ack_policy %d aggr %u rate_ctrl %u rcflag %u retry_count %d rtscts %d ext_tid_cfg_bitmap %d mac_addr %pM\n",
+		   arg->tid, arg->vdev_id, arg->ack_policy, arg->aggr_control,
+		   arg->rate_ctrl, arg->rcode_flags, arg->retry_count, arg->rtscts_ctrl,
+		   arg->ext_tid_cfg_bitmap, arg->peer_macaddr.addr);
 	return skb;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 187c13e..21a328f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -201,6 +201,7 @@ enum wmi_service {
 	WMI_SERVICE_PER_PACKET_SW_ENCRYPT,
 	WMI_SERVICE_REPORT_AIRTIME,
 	WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
 
 	/* Remember to add the new value to wmi_service_name()! */
 
@@ -493,6 +494,7 @@ static inline char *wmi_service_name(enum wmi_service service_id)
 	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
 	SVCSTR(WMI_SERVICE_REPORT_AIRTIME);
 	SVCSTR(WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT);
+	SVCSTR(WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT);
 
 	case WMI_SERVICE_MAX:
 		return NULL;
@@ -822,6 +824,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_REPORT_AIRTIME, len);
 	SVCMAP(WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
 	       WMI_SERVICE_PEER_TID_CONFIGS_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+	       WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT, len);
 }
 
 #undef SVCMAP
@@ -7169,6 +7173,16 @@ enum wmi_tid_rate_ctrl_conf {
 	WMI_TID_CONFIG_RATE_CONTROL_AUTO,
 	WMI_TID_CONFIG_RATE_CONTROL_FIXED_RATE,
 	WMI_TID_CONFIG_RATE_CONTROL_DEFAULT_LOWEST_RATE,
+	WMI_PEER_TID_CONFIG_RATE_UPPER_CAP,
+};
+
+enum wmi_tid_rtscts_control_conf {
+	WMI_TID_CONFIG_RTSCTS_CONTROL_ENABLE,
+	WMI_TID_CONFIG_RTSCTS_CONTROL_DISABLE,
+};
+
+enum wmi_ext_tid_config_map {
+	WMI_EXT_TID_RTS_CTS_CONFIG = BIT(0),
 };
 
 struct wmi_per_peer_per_tid_cfg_arg {
@@ -7180,6 +7194,8 @@ struct wmi_per_peer_per_tid_cfg_arg {
 	u8 rate_ctrl;
 	u32 retry_count;
 	u32 rcode_flags;
+	u32 ext_tid_cfg_bitmap;
+	u32 rtscts_ctrl;
 };
 
 struct wmi_peer_per_tid_cfg_cmd {
@@ -7195,6 +7211,10 @@ struct wmi_peer_per_tid_cfg_cmd {
 	__le32 rate_control;
 	__le32 rcode_flags;
 	__le32 retry_count;
+	/* See enum wmi_ext_tid_config_map */
+	__le32 ext_tid_cfg_bitmap;
+	/* see enum wmi_tid_rtscts_control_conf */
+	__le32 rtscts_ctrl;
 } __packed;
 
 enum wmi_txbf_conf {
-- 
1.9.1

