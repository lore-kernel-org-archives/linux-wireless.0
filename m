Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476ADC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 06:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 004A320836
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 06:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F0n2V0Pq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W1ZABNB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfBSGJv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 01:09:51 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54574 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSGJu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 01:09:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 078076085F; Tue, 19 Feb 2019 06:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550556589;
        bh=B7JyCuC1xTDB95mv42N1bHrMHgNNolYjWBLmZa+9WJM=;
        h=From:To:Cc:Subject:Date:From;
        b=F0n2V0PqYdiHohbPQnTd4BDGQn+L0wclgfg5hgzuI6SwibSy3jTZ4uGfbHJZky2eZ
         QTplq2V0BtWoUhV1GXrZZHA/3qqwZL1zd2sQcHEjFLjahmKdIjpYj8/UrDQkC6biMu
         sHt7Kcgd0UHA/Gp3H79QNEWoh3mQROekFf3ol8Fk=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C70B60247;
        Tue, 19 Feb 2019 06:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550556587;
        bh=B7JyCuC1xTDB95mv42N1bHrMHgNNolYjWBLmZa+9WJM=;
        h=From:To:Cc:Subject:Date:From;
        b=W1ZABNB+6VfpGTzNEkeHiwKi8zKnZzsg/fkI2AM8AdZoVuFJQHDeaGehlo87Ht8+s
         7258NQtD/zWKjaI3BkAg6uoxyCKjoWIam7D/YD7/EVu8Y91AuyLkoVTNluzDC1M7Gk
         spPOvzrnGUYJRIggnuvUkXqhpAWhcLv3BnJi5diQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2C70B60247
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Add peer param map for tlv and non-tlv
Date:   Tue, 19 Feb 2019 11:39:36 +0530
Message-Id: <1550556576-19803-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The peer param id for PEER_PARAM_USE_FIXED_PWR
is different for tlv and non-tlv firmware. This
causes incorrect peer param to be set by the driver
to the firmware(tlv/non-tlv).

Create seperate peer param map for tlv and non-tlv
firmware and attach the peer param id based on the
firmware type during the init.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
This change is dependent on the below patchset
ath10k: add support for controlling tx power to a station (https://patchwork.kernel.org/patch/9562405/)
---
 drivers/net/wireless/ath/ath10k/core.h        |  1 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c         | 16 ++++++++--------
 drivers/net/wireless/ath/ath10k/wmi-tlv.c     | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h     | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c         | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h         | 19 +++++++++++++++++++
 7 files changed, 84 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2f43600..5be2d5d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -180,6 +180,7 @@ struct ath10k_wmi {
 	struct wmi_cmd_map *cmd;
 	struct wmi_vdev_param_map *vdev_param;
 	struct wmi_pdev_param_map *pdev_param;
+	struct wmi_peer_param_map *peer_param;
 	const struct wmi_ops *ops;
 	const struct wmi_peer_flags_map *peer_flags;
 
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 4778a45..a887f71 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -441,7 +441,7 @@ ath10k_dbg_sta_write_peer_debug_trigger(struct file *file,
 	}
 
 	ret = ath10k_wmi_peer_set_param(ar, arsta->arvif->vdev_id, sta->addr,
-					WMI_PEER_DEBUG, peer_debug_trigger);
+					ar->wmi.peer_param->debug, peer_debug_trigger);
 	if (ret) {
 		ath10k_warn(ar, "failed to set param to trigger peer tid logs for station ret: %d\n",
 			    ret);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bce2698..dece2b0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2744,7 +2744,7 @@ static int ath10k_setup_peer_smps(struct ath10k *ar, struct ath10k_vif *arvif,
 		return -EINVAL;
 
 	return ath10k_wmi_peer_set_param(ar, arvif->vdev_id, addr,
-					 WMI_PEER_SMPS_STATE,
+					 ar->wmi.peer_param->smps_state,
 					 ath10k_smps_map[smps]);
 }
 
@@ -2901,7 +2901,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	 * poked with peer param command.
 	 */
 	ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, arvif->bssid,
-					WMI_PEER_DUMMY_VAR, 1);
+					ar->wmi.peer_param->dummy_var, 1);
 	if (ret) {
 		ath10k_warn(ar, "failed to poke peer %pM param for ps workaround on vdev %i: %d\n",
 			    arvif->bssid, arvif->vdev_id, ret);
@@ -6189,7 +6189,7 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (sta && sta->tdls)
 		ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-					  WMI_PEER_AUTHORIZE, 1);
+					  ar->wmi.peer_param->authorize, 1);
 
 exit:
 	mutex_unlock(&ar->conf_mutex);
@@ -6280,7 +6280,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 			   sta->addr, bw, mode);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-						WMI_PEER_PHYMODE, mode);
+						ar->wmi.peer_param->phymode, mode);
 		if (err) {
 			ath10k_warn(ar, "failed to update STA %pM peer phymode %d: %d\n",
 				    sta->addr, mode, err);
@@ -6288,7 +6288,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 		}
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-						WMI_PEER_CHAN_WIDTH, bw);
+						ar->wmi.peer_param->chan_width, bw);
 		if (err)
 			ath10k_warn(ar, "failed to update STA %pM peer bw %d: %d\n",
 				    sta->addr, bw, err);
@@ -6299,7 +6299,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 			   sta->addr, nss);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-						WMI_PEER_NSS, nss);
+						ar->wmi.peer_param->nss, nss);
 		if (err)
 			ath10k_warn(ar, "failed to update STA %pM nss %d: %d\n",
 				    sta->addr, nss, err);
@@ -6310,7 +6310,7 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 			   sta->addr, smps);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-						WMI_PEER_SMPS_STATE, smps);
+						ar->wmi.peer_param->smps_state, smps);
 		if (err)
 			ath10k_warn(ar, "failed to update STA %pM smps %d: %d\n",
 				    sta->addr, smps, err);
@@ -6384,7 +6384,7 @@ static int ath10k_sta_set_txpwr(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-					WMI_PEER_USE_FIXED_PWR, txpwr);
+					ar->wmi.peer_param->use_fixed_power, txpwr);
 	if (ret) {
 		ath10k_warn(ar, "failed to set tx power for station ret: %d\n",
 			    ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 5d05bff..13f9084 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -4077,6 +4077,24 @@ static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
 	.arp_dstaddr = WMI_PDEV_PARAM_UNSUPPORTED,
 };
 
+static struct wmi_peer_param_map wmi_tlv_peer_param_map = {
+	.smps_state = WMI_TLV_PEER_SMPS_STATE,
+	.ampdu = WMI_TLV_PEER_AMPDU,
+	.authorize = WMI_TLV_PEER_AUTHORIZE,
+	.chan_width = WMI_TLV_PEER_CHAN_WIDTH,
+	.nss = WMI_TLV_PEER_NSS,
+	.use_4addr = WMI_TLV_PEER_USE_4ADDR,
+	.membership = WMI_TLV_PEER_MEMBERSHIP,
+	.user_pos = WMI_TLV_PEER_USERPOS,
+	.crit_proto_hint_enabled = WMI_TLV_PEER_CRIT_PROTO_HINT_ENABLED,
+	.tx_fail_cnt_thr = WMI_TLV_PEER_TX_FAIL_CNT_THR,
+	.set_hw_retry_cts2s = WMI_TLV_PEER_SET_HW_RETRY_CTS2S,
+	.ibss_atim_win_len = WMI_TLV_PEER_IBSS_ATIM_WINDOW_LENGTH,
+	.phymode = WMI_TLV_PEER_PHYMODE,
+	.use_fixed_power = WMI_TLV_PEER_USE_FIXED_PWR,
+	.dummy_var = WMI_TLV_PEER_DUMMY_VAR,
+};
+
 static struct wmi_vdev_param_map wmi_tlv_vdev_param_map = {
 	.rts_threshold = WMI_TLV_VDEV_PARAM_RTS_THRESHOLD,
 	.fragmentation_threshold = WMI_TLV_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
@@ -4265,6 +4283,7 @@ void ath10k_wmi_tlv_attach(struct ath10k *ar)
 	ar->wmi.cmd = &wmi_tlv_cmd_map;
 	ar->wmi.vdev_param = &wmi_tlv_vdev_param_map;
 	ar->wmi.pdev_param = &wmi_tlv_pdev_param_map;
+	ar->wmi.peer_param = &wmi_tlv_peer_param_map;
 	ar->wmi.ops = &wmi_tlv_ops;
 	ar->wmi.peer_flags = &wmi_tlv_peer_flags_map;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 4fba581..8d50808 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -533,6 +533,24 @@ enum wmi_tlv_vdev_param {
 	WMI_TLV_VDEV_PARAM_IBSS_PS_1RX_CHAIN_IN_ATIM_WINDOW_ENABLE,
 };
 
+enum wmi_tlv_peer_param {
+	WMI_TLV_PEER_SMPS_STATE = 0x1, /* see %wmi_peer_smps_state */
+	WMI_TLV_PEER_AMPDU      = 0x2,
+	WMI_TLV_PEER_AUTHORIZE  = 0x3,
+	WMI_TLV_PEER_CHAN_WIDTH = 0x4,
+	WMI_TLV_PEER_NSS        = 0x5,
+	WMI_TLV_PEER_USE_4ADDR  = 0x6,
+	WMI_TLV_PEER_MEMBERSHIP = 0x7,
+	WMI_TLV_PEER_USERPOS = 0x8,
+	WMI_TLV_PEER_CRIT_PROTO_HINT_ENABLED = 0x9,
+	WMI_TLV_PEER_TX_FAIL_CNT_THR = 0xa,
+	WMI_TLV_PEER_SET_HW_RETRY_CTS2S = 0xb,
+	WMI_TLV_PEER_IBSS_ATIM_WINDOW_LENGTH = 0xc,
+	WMI_TLV_PEER_PHYMODE = 0xd,
+	WMI_TLV_PEER_USE_FIXED_PWR = 0xe,
+	WMI_TLV_PEER_DUMMY_VAR = 0xff,
+};
+
 enum wmi_tlv_peer_flags {
 	WMI_TLV_PEER_AUTH = 0x00000001,
 	WMI_TLV_PEER_QOS = 0x00000002,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 704c71b..35f9f90 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -753,6 +753,19 @@ static struct wmi_cmd_map wmi_10_4_cmd_map = {
 	.radar_found_cmdid = WMI_10_4_RADAR_FOUND_CMDID,
 };
 
+static struct wmi_peer_param_map wmi_peer_param_map = {
+	.smps_state = WMI_PEER_SMPS_STATE,
+	.ampdu = WMI_PEER_AMPDU,
+	.authorize = WMI_PEER_AUTHORIZE,
+	.chan_width = WMI_PEER_CHAN_WIDTH,
+	.nss = WMI_PEER_NSS,
+	.use_4addr = WMI_PEER_USE_4ADDR,
+	.use_fixed_power = WMI_PEER_USE_FIXED_PWR,
+	.debug = WMI_PEER_DEBUG,
+	.phymode = WMI_PEER_PHYMODE,
+	.dummy_var = WMI_PEER_DUMMY_VAR,
+};
+
 /* MAIN WMI VDEV param map */
 static struct wmi_vdev_param_map wmi_vdev_param_map = {
 	.rts_threshold = WMI_VDEV_PARAM_RTS_THRESHOLD,
@@ -9300,6 +9313,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.cmd = &wmi_10_4_cmd_map;
 		ar->wmi.vdev_param = &wmi_10_4_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10_4_pdev_param_map;
+		ar->wmi.peer_param = &wmi_peer_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
@@ -9308,6 +9322,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.ops = &wmi_10_2_4_ops;
 		ar->wmi.vdev_param = &wmi_10_2_4_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10_2_4_pdev_param_map;
+		ar->wmi.peer_param = &wmi_peer_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
@@ -9316,6 +9331,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.ops = &wmi_10_2_ops;
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
+		ar->wmi.peer_param = &wmi_peer_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
@@ -9324,6 +9340,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.ops = &wmi_10_1_ops;
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
+		ar->wmi.peer_param = &wmi_peer_param_map;
 		ar->wmi.peer_flags = &wmi_10x_peer_flags_map;
 		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
@@ -9332,6 +9349,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.ops = &wmi_ops;
 		ar->wmi.vdev_param = &wmi_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_pdev_param_map;
+		ar->wmi.peer_param = &wmi_peer_param_map;
 		ar->wmi.peer_flags = &wmi_peer_flags_map;
 		ar->wmi_key_cipher = wmi_key_cipher_suites;
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 9b5a7ec..23666ca 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5083,6 +5083,25 @@ enum wmi_rate_preamble {
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
 
+struct wmi_peer_param_map {
+	u32 smps_state;
+	u32 ampdu;
+	u32 authorize;
+	u32 chan_width;
+	u32 nss;
+	u32 use_4addr;
+	u32 membership;
+	u32 use_fixed_power;
+	u32 user_pos;
+	u32 crit_proto_hint_enabled;
+	u32 tx_fail_cnt_thr;
+	u32 set_hw_retry_cts2s;
+	u32 ibss_atim_win_len;
+	u32 debug;
+	u32 phymode;
+	u32 dummy_var;
+};
+
 struct wmi_vdev_param_map {
 	u32 rts_threshold;
 	u32 fragmentation_threshold;
-- 
2.7.4

