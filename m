Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47559C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 21:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A27213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 21:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="frj5ByXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfCLV2l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 17:28:41 -0400
Received: from [208.74.158.174] ([208.74.158.174]:33088 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfCLV2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 17:28:41 -0400
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 24E46114B55;
        Tue, 12 Mar 2019 14:28:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 24E46114B55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1552426120;
        bh=8O6OX6HUPBMrhhKS7ZLkA6MGzA5Zh1Sj5yfpKd9XHdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frj5ByXUc3pWJB21gqRZggbV7zIABdHUge8JErELRzxyHLoKZUtTIJzJ2vpxVJMKt
         9lB6qxCvSPeP+pBx0T1s2ao49lEYASO9Uaf7yhzLeFM6hFVaousqyzZeMjeQ37eJVO
         YlBUlCVQm7QR3GrlLTKTrGXQlICnv1Rt6AGKN3Wo=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] ath10k:  Support rx-sw-crypt of PMF blockack frames.
Date:   Tue, 12 Mar 2019 14:28:30 -0700
Message-Id: <20190312212830.9813-2-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190312212830.9813-1-greearb@candelatech.com>
References: <20190312212830.9813-1-greearb@candelatech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

In rx-sw-crypt mode, the firmware cannot decrypt any frames, including
blockack action frames when using PMF.  So, pass them up to the mac80211
stack so it can decrypt them and pass them back down so we can send the
decrypted frame back to the firmware for re-insertion.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  1 +
 drivers/net/wireless/ath/ath10k/core.h |  4 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 27 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 45 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h  | 10 ++++++
 5 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 929e0c059adc..75968d86e8bc 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -624,6 +624,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_CT_STA] = "CT-STA",
 	[ATH10K_FW_FEATURE_TXRATE2_CT] = "txrate2-CT",
 	[ATH10K_FW_FEATURE_BEACON_TX_CB_CT] = "beacon-cb-CT",
+	[ATH10K_FW_FEATURE_CONSUME_BLOCK_ACK_CT] = "wmi-block-ack-CT",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index a70771170007..4dada2e6e9d1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -950,6 +950,10 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_BEACON_TX_CB_CT = 50,
 
+	ATH10K_FW_FEATURE_RESERVED_CT = 51, /* reserved by out-of-tree feature */
+
+	ATH10K_FW_FEATURE_CONSUME_BLOCK_ACK_CT = 52, /* firmware can accept decrypted rx block-ack over WMI */
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 02a8efa2e783..0cca9f83f7e5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4990,6 +4990,32 @@ static int ath10k_start_scan(struct ath10k *ar,
 /* mac80211 callbacks */
 /**********************/
 
+static int ath10k_mac_consume_block_ack(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
+					struct sk_buff *skb)
+{
+	struct ath10k *ar = hw->priv;
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	struct ath10k_vif *arvif = (void *)vif->drv_priv;
+
+	/*ath10k_warn(ar, "mac-consume-ba called.\n");*/
+	if (!(test_bit(ATH10K_FW_FEATURE_CT_RXSWCRYPT,
+		       ar->running_fw->fw_file.fw_features) &&
+	      ar->request_nohwcrypt))
+		return -EINVAL; /* Not running swcrypt, don't need this */
+
+	if (ieee80211_is_action(mgmt->frame_control) &&
+		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
+		int rv = ath10k_wmi_consume_block_ack(ar, arvif, skb);
+		if (rv) {
+			ath10k_warn(ar, "consume-block-ack failed: %d\n", rv);
+		}
+		return rv;
+	}
+	return -EINVAL;
+}
+
+
 static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 			     struct ieee80211_tx_control *control,
 			     struct sk_buff *skb)
@@ -8958,6 +8984,7 @@ static const struct ieee80211_ops ath10k_ops = {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.sta_add_debugfs		= ath10k_sta_add_debugfs,
 #endif
+	.consume_block_ack		= ath10k_mac_consume_block_ack,
 };
 
 #define CHAN2G(_channel, _freq, _flags) { \
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index bebddf0effdf..59b0e0ead66a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -656,6 +656,7 @@ static struct wmi_cmd_map wmi_10_4_cmd_map = {
 	.sta_keepalive_cmd = WMI_CMD_UNSUPPORTED,
 	.echo_cmdid = WMI_10_4_ECHO_CMDID,
 	.pdev_utf_cmdid = WMI_10_4_PDEV_UTF_CMDID,
+	.pdev_consume_block_ack_cmdid = WMI_10_4_PDEV_CONSUME_BLOCK_ACK_CMDID_CT,
 	.dbglog_cfg_cmdid = WMI_10_4_DBGLOG_CFG_CMDID,
 	.pdev_qvit_cmdid = WMI_10_4_PDEV_QVIT_CMDID,
 	.pdev_ftm_intg_cmdid = WMI_CMD_UNSUPPORTED,
@@ -1662,6 +1663,40 @@ static const struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
 	.bw160 = WMI_10_2_PEER_160MHZ,
 };
 
+int ath10k_wmi_consume_block_ack(struct ath10k *ar, struct ath10k_vif *arvif, struct sk_buff *ba_skb)
+{
+	struct wmi_pdev_consume_block_ack *cmd;
+	int cmd_id = ar->wmi.cmd->pdev_consume_block_ack_cmdid;
+	struct sk_buff *wskb;
+	int ba_skb_len = ba_skb->len;
+	if (ba_skb_len > 200)
+		ba_skb_len = 200;
+
+	/*ath10k_warn(ar, "wmi consume block ack, vdev: %d  peer: %d  ba_skb->len: %d (%d)\n",
+		   arvif->vdev_id, arvif->peer_id, ba_skb->len, ba_skb_len);*/
+
+	if ((cmd_id == WMI_CMD_UNSUPPORTED) ||
+	    (! test_bit(ATH10K_FW_FEATURE_CONSUME_BLOCK_ACK_CT,
+			ar->running_fw->fw_file.fw_features)))
+		return -EOPNOTSUPP;
+
+	wskb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd) + round_up(ba_skb_len, 4));
+	if (!wskb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_pdev_consume_block_ack *)wskb->data;
+	cmd->vdev_id = __cpu_to_le32(arvif->vdev_id);
+	cmd->skb_len = __cpu_to_le16(ba_skb_len);
+	cmd->flags = __cpu_to_le16(0);
+
+	memcpy(cmd->skb_data, ba_skb->data, ba_skb_len);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi consume block ack, vdev: %d  peer: %d  ba_skb->len: %d (%d)\n",
+		   arvif->vdev_id, arvif->peer_id, ba_skb->len, ba_skb_len);
+
+	return ath10k_wmi_cmd_send(ar, wskb, cmd_id);
+}
+
 static bool ath10k_ok_skip_ch_reservation(struct ath10k *ar, u32 vdev_id)
 {
 	struct ath10k_vif *arvif;
@@ -2412,6 +2447,12 @@ static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
 static bool ath10k_wmi_rx_is_decrypted(struct ath10k *ar,
 				       struct ieee80211_hdr *hdr)
 {
+	/* If using rx-sw-crypt, it is not decrypted */
+	if (test_bit(ATH10K_FW_FEATURE_CT_RXSWCRYPT,
+		     ar->running_fw->fw_file.fw_features) &&
+	    ar->request_nohwcrypt)
+		return false;
+
 	if (!ieee80211_has_protected(hdr->frame_control))
 		return false;
 
@@ -2604,9 +2645,9 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_mac_handle_beacon(ar, skb);
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
-		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
+		   "event mgmt rx skb %pK len %d ftype %02x stype %02x decrypted: %d\n",
 		   skb, skb->len,
-		   fc & IEEE80211_FCTL_FTYPE, fc & IEEE80211_FCTL_STYPE);
+		   fc & IEEE80211_FCTL_FTYPE, fc & IEEE80211_FCTL_STYPE, ath10k_wmi_rx_is_decrypted(ar, hdr));
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx freq %d band %d snr %d chains: 0x%x(%d %d %d %d), rate_idx %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index b8d908ab4709..106ebbdff196 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -906,6 +906,7 @@ struct wmi_cmd_map {
 	u32 sta_keepalive_cmd;
 	u32 echo_cmdid;
 	u32 pdev_utf_cmdid;
+	u32 pdev_consume_block_ack_cmdid;
 	u32 dbglog_cfg_cmdid;
 	u32 pdev_qvit_cmdid;
 	u32 pdev_ftm_intg_cmdid;
@@ -1879,6 +1880,7 @@ enum wmi_10_4_cmd_id {
 	WMI_10_4_PDEV_SET_BRIDGE_MACADDR_CMDID,
 	WMI_10_4_ATF_GROUP_WMM_AC_CONFIG_REQUEST_CMDID,
 	WMI_10_4_RADAR_FOUND_CMDID,
+	WMI_10_4_PDEV_CONSUME_BLOCK_ACK_CMDID_CT = WMI_10_4_END_CMDID - 102, /* CT Specific Command ID */
 	WMI_10_4_PDEV_UTF_CMDID = WMI_10_4_END_CMDID - 1,
 };
 
@@ -6657,6 +6659,13 @@ struct wmi_10_1_peer_assoc_complete_cmd_ct {
 	struct wmi_ct_assoc_overrides overrides;
 } __packed;
 
+struct wmi_pdev_consume_block_ack {
+	__le32 vdev_id;
+	__le16 flags; /* currently unused, must be set to zero */
+	__le16 skb_len;
+	unsigned char skb_data[0]; /* skb contents are copied here, 200 bytes or less */
+};
+
 #define WMI_PEER_ASSOC_INFO0_MAX_MCS_IDX_LSB 0
 #define WMI_PEER_ASSOC_INFO0_MAX_MCS_IDX_MASK 0x0f
 #define WMI_PEER_ASSOC_INFO0_MAX_NSS_LSB 4
@@ -7657,6 +7666,7 @@ void ath10k_wmi_tpc_config_get_rate_code(u8 *rate_code, u16 *pream_table,
 					 u32 num_tx_chain);
 void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_wmi_stop_scan_work(struct work_struct *work);
+int ath10k_wmi_consume_block_ack(struct ath10k *ar, struct ath10k_vif *arvif, struct sk_buff *skb);
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 /* TODO:  Should really enable this all the time, not just when DEBUGFS is enabled. --Ben */
-- 
2.20.1

