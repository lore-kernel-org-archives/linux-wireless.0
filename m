Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922C6C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 07:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5C4218D0
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 07:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JUaUHGrw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c1o/3LKy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfB0HOC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:14:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfB0HOC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 02:14:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A83EB60F3F; Wed, 27 Feb 2019 07:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551251640;
        bh=0CYJiBePT/Hx0464dXLexswNmJIgAoVg+NVdAB2tMk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUaUHGrwDdxVY/rGR/a7knk5U3VEH2KzEMoM4vMRW74bc5QqqP/fvhta4mMSQ4O9+
         y1pqQ9qBd+9IC2VMMBWptNkOYLg6+HVpIQybEVNXcFfgq7Y5sOP8i6qrthHgymOifj
         RnaUcIFL1JcuPwosByN6w/mSie6Lxafi3I1U02WA=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3962C60A0A;
        Wed, 27 Feb 2019 07:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551251639;
        bh=0CYJiBePT/Hx0464dXLexswNmJIgAoVg+NVdAB2tMk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1o/3LKyE4nSTvpjcYFi3V0aZ7iXmGIQfNvlg57v4Md++lP476UG0brzO+70guOEp
         l2uARS3DXDNHd4MftfzxtgAXafutpVw4KpOvOA+qcfDAxYhcgPnNVkRPnn6bCVx5df
         dszvNA4vNTgQ7M14tLoK3uggXAeIglEqXvowQMDw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3962C60A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Add support for per peer HTT tx stats for WCN3990
Date:   Wed, 27 Feb 2019 12:43:48 +0530
Message-Id: <1551251628-22518-3-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551251628-22518-1-git-send-email-svishnoi@codeaurora.org>
References: <1551251628-22518-1-git-send-email-svishnoi@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The firmware sends peer stats to the host driver if the firmware
advertises WMI_SERVICE_PEER_STATS service and the host driver
indicates the WMI_RSRC_CFG_FLAG_TX_PEER_STATS capability in the
host capab flag in wmi init cmd.

When peer stats are enabled, firmware sends one HTT event
HTT_TLV_T2H_MSG_TYPE_PEER_STATS for every four PPDUs transmitted.
HTT msg payload has tag followed by length followed by
success pkts/bytes, failed pkts/bytes, retry pkts/bytes and rate
info per ppdu.

Parse peer stats sent by the firmware in tlv format and update the
tx rate information and tx_stats debugfs entry per STA.

To get the tx_stats:
echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/enable_extd_tx_stats
cat /sys/kernel/debug/ieee80211/phyX/net:wlanX/stations/xx:xx:xx:xx:xx:xx/tx_stats

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/htt.c     |   2 +
 drivers/net/wireless/ath/ath10k/htt.h     |  64 ++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 136 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/hw.c      |  45 +++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      |  34 ++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   3 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  33 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   3 -
 8 files changed, 312 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index d235ff3..828e76d 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -89,6 +89,8 @@
 	[HTT_TLV_T2H_MSG_TYPE_RX_OFLD_PKT_ERR] =
 		HTT_T2H_MSG_TYPE_RX_OFLD_PKT_ERR,
 	[HTT_TLV_T2H_MSG_TYPE_TEST] = HTT_T2H_MSG_TYPE_TEST,
+	[HTT_TLV_T2H_MSG_TYPE_PEER_STATS] =
+				HTT_T2H_MSG_TYPE_PEER_STATS,
 };
 
 static const enum htt_t2h_msg_type htt_10_4_t2h_msg_types[] = {
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 0ab29bd..2c2b1c7 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -449,6 +449,12 @@ enum htt_tlv_t2h_msg_type {
 	HTT_TLV_T2H_MSG_TYPE_WDI_IPA_OP_RESPONSE       = 0x14,
 	HTT_TLV_T2H_MSG_TYPE_CHAN_CHANGE               = 0x15,
 	HTT_TLV_T2H_MSG_TYPE_RX_OFLD_PKT_ERR           = 0x16,
+	HTT_TLV_T2H_MSG_TYPE_PEER_MAP_V2	       = 0x1e,
+	HTT_TLV_T2H_MSG_TYPE_PEER_UNMAP_V2	       = 0x1f,
+	HTT_TLV_T2H_MSG_TYPE_MONITOR_MAC_HEADER_IND    = 0x20,
+	HTT_TLV_T2H_MSG_TYPE_FLOW_POOL_RESIZE	       = 0x21,
+	HTT_TLV_T2H_MSG_TYPE_CFR_DUMP_COMPL_IND	       = 0x22,
+	HTT_TLV_T2H_MSG_TYPE_PEER_STATS		       = 0x23,
 	HTT_TLV_T2H_MSG_TYPE_TEST,
 	/* keep this last */
 	HTT_TLV_T2H_NUM_MSGS
@@ -1604,6 +1610,63 @@ struct htt_channel_change {
 	__le32 phymode;
 } __packed;
 
+#define HTT_TAG_ADDR_MASK	GENMASK(11, 0)
+#define HTT_LEN_ADDR_MASK	GENMASK(23, 12)
+#define HTT_LEN_ADDR_LSB	12
+
+struct htt_tlv_msg {
+	/* BIT [11 : 0]   :- tag
+	 * BIT [23 : 12]   :- length
+	 * BIT [31 : 24]   :- reserved
+	 */
+	__le32 tag_length;
+	u8 payload[0];
+};
+
+struct htt_tlv {
+	__le16 reserved1;
+	u8 reserved2;
+	u8 payload[0];
+};
+
+#define HTT_TX_STATS_IS_AMPDU_MASK		GENMASK(0, 0)
+#define HTT_TX_STATS_BA_ACK_FAILED_MASK		GENMASK(2, 1)
+#define HTT_TX_STATS_BW_MASK			GENMASK(5, 3)
+#define HTT_TX_STATS_GI_MASK			GENMASK(6, 6)
+#define HTT_TX_STATS_SKIPPED_RATE_CTRL_MASK	GENMASK(7, 7)
+
+enum htt_tx_stats_valid_bitmap {
+	HTT_TX_STATS_VALID,
+	HTT_TX_STATS_SUCCESS_BYTES,
+	HTT_TX_STATS_RETRY_BYTES,
+	HTT_TX_STATS_FAILED_BYTES,
+	HTT_TX_STATS_RATECODE,
+	HTT_TX_STATS_IS_AMPDU,
+	HTT_TX_STATS_BA_ACK_FAILED,
+	HTT_TX_STATS_BW,
+	HTT_TX_STATS_GI,
+	HTT_TX_STATS_SKIPPED_RATE_CTRL,
+	HTT_TX_STATS_PEER_ID,
+	HTT_TX_STATS_SUCCESS_PKTS,
+	HTT_TX_STATS_RETRY_PKTS,
+	HTT_TX_STATS_FAILED_PKTS,
+	HTT_TX_STATS_TX_DURATION,
+};
+
+struct htt_tlv_per_peer_tx_stats_ind {
+	__le32	succ_bytes;
+	__le32  retry_bytes;
+	__le32  failed_bytes;
+	u8	ratecode;
+	u8	flags;
+	__le16	peer_id;
+	__le16  succ_pkts;
+	__le16	retry_pkts;
+	__le16	failed_pkts;
+	__le16	tx_duration;
+	__le32  valid_bitmap;
+} __packed;
+
 struct htt_per_peer_tx_stats_ind {
 	__le32	succ_bytes;
 	__le32  retry_bytes;
@@ -1699,6 +1762,7 @@ struct htt_resp {
 		struct htt_tx_mode_switch_ind tx_mode_switch_ind;
 		struct htt_channel_change chan_change;
 		struct htt_peer_tx_stats peer_tx_stats;
+		struct htt_tlv tlv;
 	};
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index c7a2411..b3bbc8f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -3039,11 +3039,12 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 	lockdep_assert_held(&ar->data_lock);
 
 	txrate.flags = ATH10K_HW_PREAMBLE(peer_stats->ratecode);
-	txrate.bw = ATH10K_HW_BW(peer_stats->flags);
+	txrate.bw = ath10k_get_bw(&ar->hw_params, peer_stats->flags);
 	txrate.nss = ATH10K_HW_NSS(peer_stats->ratecode);
 	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
-	sgi = ATH10K_HW_GI(peer_stats->flags);
-	skip_auto_rate = ATH10K_FW_SKIPPED_RATE_CTRL(peer_stats->flags);
+	sgi = ath10k_get_gi(&ar->hw_params, peer_stats->flags);
+	skip_auto_rate = ath10k_get_skipped_rate_ctrl(&ar->hw_params,
+						      peer_stats->flags);
 
 	/* Firmware's rate control skips broadcast/management frames,
 	 * if host has configure fixed rates and in some other special cases.
@@ -3146,6 +3147,133 @@ static inline s8 ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 rate)
 static void ath10k_htt_fetch_peer_stats_tlv(struct ath10k *ar,
 					    struct sk_buff *skb)
 {
+	struct ath10k_per_peer_tx_stats *p_tx_stats = &ar->peer_tx_stats;
+	struct htt_resp *resp = (struct htt_resp *)skb->data;
+	struct htt_tlv_per_peer_tx_stats_ind *tx_stats;
+	const struct htt_tlv_msg *tlv;
+	unsigned long valid_bitmap;
+	struct ieee80211_sta *sta;
+	struct ath10k_sta *arsta;
+	struct ath10k_peer *peer;
+	u16 tlv_tag, tlv_len;
+	void *begin, *ptr;
+	int peer_id, len;
+
+	begin = resp->tlv.payload;
+	ptr = begin;
+	len = skb->len - sizeof(struct htt_tlv);
+
+	while (len > 0) {
+		if (len < sizeof(*tlv)) {
+			ath10k_dbg(ar, ATH10K_DBG_HTT,
+				   "HTT tlv parse failure at byte %zd (%d bytes left, %zu expected)\n",
+				   ptr - begin, len, sizeof(*tlv));
+			return;
+		}
+
+		tlv = (struct htt_tlv_msg *)ptr;
+		tlv_tag = HTT_TAG_ADDR_MASK & __le32_to_cpu(tlv->tag_length);
+		tlv_len = MS(__le32_to_cpu(tlv->tag_length), HTT_LEN_ADDR);
+		ptr += sizeof(*tlv);
+		len -= sizeof(*tlv);
+
+		if (tlv_len > len) {
+			ath10k_dbg(ar, ATH10K_DBG_HTT,
+				   "HTT tlv parse failure of tag %hu at byte %zd (%d bytes left, %hu expected)\n",
+				   tlv_tag, ptr - begin, len, tlv_len);
+			return;
+		}
+
+		tx_stats = (struct htt_tlv_per_peer_tx_stats_ind *)ptr;
+		valid_bitmap = __le32_to_cpu(tx_stats->valid_bitmap);
+
+		if (test_bit(HTT_TX_STATS_VALID, &valid_bitmap)) {
+			if (test_bit(HTT_TX_STATS_PEER_ID, &valid_bitmap)) {
+				peer_id = __le16_to_cpu(tx_stats->peer_id);
+			} else {
+				ath10k_dbg(ar, ATH10K_DBG_HTT, "Peer id is not received, ignoring\n");
+				goto next;
+			}
+
+			rcu_read_lock();
+			spin_lock_bh(&ar->data_lock);
+			peer = ath10k_peer_find_by_id(ar, peer_id);
+			if (!peer) {
+				ath10k_warn(ar, "Invalid peer id %d peer stats buffer\n",
+					    peer_id);
+				spin_unlock_bh(&ar->data_lock);
+				rcu_read_unlock();
+				return;
+			}
+
+			sta = peer->sta;
+			arsta = (struct ath10k_sta *)sta->drv_priv;
+			p_tx_stats->flags = 0;
+
+			if (test_bit(HTT_TX_STATS_SUCCESS_BYTES, &valid_bitmap))
+				p_tx_stats->succ_bytes =
+					__le32_to_cpu(tx_stats->succ_bytes);
+
+			if (test_bit(HTT_TX_STATS_RETRY_BYTES, &valid_bitmap))
+				p_tx_stats->retry_bytes =
+					__le32_to_cpu(tx_stats->retry_bytes);
+
+			if (test_bit(HTT_TX_STATS_FAILED_BYTES, &valid_bitmap))
+				p_tx_stats->failed_bytes =
+					__le32_to_cpu(tx_stats->failed_bytes);
+
+			if (test_bit(HTT_TX_STATS_RATECODE, &valid_bitmap))
+				p_tx_stats->ratecode = tx_stats->ratecode;
+
+			if (test_bit(HTT_TX_STATS_IS_AMPDU, &valid_bitmap))
+				p_tx_stats->flags |= tx_stats->flags &
+						     HTT_TX_STATS_IS_AMPDU_MASK;
+
+			if (test_bit(HTT_TX_STATS_BA_ACK_FAILED, &valid_bitmap))
+				p_tx_stats->flags |= tx_stats->flags &
+						HTT_TX_STATS_BA_ACK_FAILED_MASK;
+
+			if (test_bit(HTT_TX_STATS_BW, &valid_bitmap))
+				p_tx_stats->flags |= tx_stats->flags &
+						     HTT_TX_STATS_BW_MASK;
+
+			if (test_bit(HTT_TX_STATS_GI, &valid_bitmap))
+				p_tx_stats->flags |= tx_stats->flags &
+						     HTT_TX_STATS_GI_MASK;
+
+			if (test_bit(HTT_TX_STATS_SKIPPED_RATE_CTRL,
+				     &valid_bitmap))
+				p_tx_stats->flags |= tx_stats->flags &
+					HTT_TX_STATS_SKIPPED_RATE_CTRL_MASK;
+
+			if (test_bit(HTT_TX_STATS_SUCCESS_PKTS, &valid_bitmap))
+				p_tx_stats->succ_pkts =
+					__le16_to_cpu(tx_stats->succ_pkts);
+
+			if (test_bit(HTT_TX_STATS_RETRY_PKTS, &valid_bitmap))
+				p_tx_stats->retry_pkts =
+					__le16_to_cpu(tx_stats->retry_pkts);
+
+			if (test_bit(HTT_TX_STATS_FAILED_PKTS, &valid_bitmap))
+				p_tx_stats->failed_pkts =
+					__le16_to_cpu(tx_stats->failed_pkts);
+
+			if (test_bit(HTT_TX_STATS_TX_DURATION, &valid_bitmap))
+				p_tx_stats->duration =
+					__le16_to_cpu(tx_stats->tx_duration);
+
+			ath10k_update_per_peer_tx_stats(ar, sta, p_tx_stats);
+
+			spin_unlock_bh(&ar->data_lock);
+			rcu_read_unlock();
+		} else {
+			ath10k_dbg(ar, ATH10K_DBG_HTT, "received invalid bitmap 0x%lx for tag %hu at byte %zd\n",
+				   valid_bitmap, tlv_tag, ptr - begin);
+		}
+next:
+		ptr += tlv_len;
+		len -= tlv_len;
+	}
 }
 
 static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
@@ -3438,7 +3566,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_htt_rx_tx_mode_switch_ind(ar, skb);
 		break;
 	case HTT_T2H_MSG_TYPE_PEER_STATS:
-		ath10k_htt_fetch_peer_stats(ar, skb);
+		htt->rx_ops->htt_fetch_peer_stats(ar, skb);
 		break;
 	case HTT_T2H_MSG_TYPE_EN_STATS:
 	default:
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index eeaee8e..54b2735 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -1100,8 +1100,26 @@ int ath10k_hw_diag_fast_download(struct ath10k *ar,
 	return ret;
 }
 
+static int ath10k_hw_bw(u8 flags)
+{
+	return FIELD_GET(ATH10K_HW_BW_MASK, flags);
+}
+
+static int ath10k_hw_gi(u8 flags)
+{
+	return FIELD_GET(ATH10K_HW_GI_MASK, flags);
+}
+
+static int ath10k_hw_skipped_rate_ctrl(u8 flags)
+{
+	return FIELD_GET(ATH10K_HW_SKIPPED_RATE_CTRL_MASK, flags);
+}
+
 const struct ath10k_hw_ops qca988x_ops = {
 	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
+	.get_bw = ath10k_hw_bw,
+	.get_gi = ath10k_hw_gi,
+	.get_skipped_rate_ctrl = ath10k_hw_skipped_rate_ctrl,
 };
 
 static int ath10k_qca99x0_rx_desc_get_l3_pad_bytes(struct htt_rx_desc *rxd)
@@ -1119,11 +1137,36 @@ static bool ath10k_qca99x0_rx_desc_msdu_limit_error(struct htt_rx_desc *rxd)
 const struct ath10k_hw_ops qca99x0_ops = {
 	.rx_desc_get_l3_pad_bytes = ath10k_qca99x0_rx_desc_get_l3_pad_bytes,
 	.rx_desc_get_msdu_limit_error = ath10k_qca99x0_rx_desc_msdu_limit_error,
+	.get_bw = ath10k_hw_bw,
+	.get_gi = ath10k_hw_gi,
+	.get_skipped_rate_ctrl = ath10k_hw_skipped_rate_ctrl,
 };
 
 const struct ath10k_hw_ops qca6174_ops = {
 	.set_coverage_class = ath10k_hw_qca988x_set_coverage_class,
 	.enable_pll_clk = ath10k_hw_qca6174_enable_pll_clock,
+	.get_bw = ath10k_hw_bw,
+	.get_gi = ath10k_hw_gi,
+	.get_skipped_rate_ctrl = ath10k_hw_skipped_rate_ctrl,
 };
 
-const struct ath10k_hw_ops wcn3990_ops = {};
+static int ath10k_hw_wcn3990_bw(u8 flags)
+{
+	return FIELD_GET(ATH10K_HW_WCN3990_BW_BIT_MASK, flags);
+}
+
+static int ath10k_hw_wcn3990_gi(u8 flags)
+{
+	return FIELD_GET(ATH10K_HW_WCN3990_GI_MASK, flags);
+}
+
+static int ath10k_hw_wcn3990_skipped_rate_ctrl(u8 flags)
+{
+	return FIELD_GET(ATH10K_HW_WCN3990_SKIPPED_RATE_CTRL_MASK, flags);
+}
+
+const struct ath10k_hw_ops wcn3990_ops = {
+	.get_bw = ath10k_hw_wcn3990_bw,
+	.get_gi = ath10k_hw_wcn3990_gi,
+	.get_skipped_rate_ctrl = ath10k_hw_wcn3990_skipped_rate_ctrl,
+};
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index de7dc01..737e4f7 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -159,6 +159,13 @@ enum qca9377_chip_id_rev {
 
 #define REG_DUMP_COUNT_QCA988X 60
 
+#define ATH10K_HW_BW_MASK				GENMASK(4, 3)
+#define ATH10K_HW_GI_MASK				GENMASK(5, 5)
+#define ATH10K_HW_SKIPPED_RATE_CTRL_MASK		GENMASK(6, 6)
+#define ATH10K_HW_WCN3990_BW_BIT_MASK			GENMASK(5, 3)
+#define ATH10K_HW_WCN3990_GI_MASK			GENMASK(6, 6)
+#define ATH10K_HW_WCN3990_SKIPPED_RATE_CTRL_MASK	GENMASK(7, 7)
+
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
@@ -616,6 +623,9 @@ struct ath10k_hw_ops {
 	void (*set_coverage_class)(struct ath10k *ar, s16 value);
 	int (*enable_pll_clk)(struct ath10k *ar);
 	bool (*rx_desc_get_msdu_limit_error)(struct htt_rx_desc *rxd);
+	int (*get_bw)(u8 flags);
+	int (*get_gi)(u8 flags);
+	int (*get_skipped_rate_ctrl)(u8 flags);
 };
 
 extern const struct ath10k_hw_ops qca988x_ops;
@@ -643,6 +653,30 @@ struct ath10k_hw_ops {
 	return false;
 }
 
+static inline int
+ath10k_get_bw(struct ath10k_hw_params *hw, u8 flags)
+{
+	if (hw->hw_ops->get_bw)
+		return hw->hw_ops->get_bw(flags);
+	return 0;
+}
+
+static inline int
+ath10k_get_gi(struct ath10k_hw_params *hw, u8 flags)
+{
+	if (hw->hw_ops->get_gi)
+		return hw->hw_ops->get_gi(flags);
+	return 0;
+}
+
+static inline int
+ath10k_get_skipped_rate_ctrl(struct ath10k_hw_params *hw, u8 flags)
+{
+	if (hw->hw_ops->get_skipped_rate_ctrl)
+		return hw->hw_ops->get_skipped_rate_ctrl(flags);
+	return 0;
+}
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 9b2ed0e..b700fe1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1706,6 +1706,9 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->num_ocb_schedules = __cpu_to_le32(0);
 	cfg->host_capab = __cpu_to_le32(WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL);
 
+	if (ath10k_peer_stats_enabled(ar))
+		cfg->host_capab |= __cpu_to_le32(WMI_RSRC_CFG_FLAG_TX_PEER_STATS);
+
 	ath10k_wmi_put_host_mem_chunks(ar, chunks);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv init\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 03d02ed..d5a090f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -13,6 +13,7 @@
 #define WMI_TLV_PDEV_PARAM_UNSUPPORTED 0
 #define WMI_TLV_VDEV_PARAM_UNSUPPORTED 0
 #define WMI_TLV_MGMT_TX_FRAME_MAX_LEN	64
+#define WMI_RSRC_CFG_FLAG_TX_PEER_STATS          BIT(21)
 
 enum wmi_tlv_grp_id {
 	WMI_TLV_GRP_START = 0x3,
@@ -1384,6 +1385,36 @@ enum wmi_tlv_service {
 	WMI_TLV_SERVICE_AP_TWT = 153,
 	WMI_TLV_SERVICE_GMAC_OFFLOAD_SUPPORT = 154,
 	WMI_TLV_SERVICE_SPOOF_MAC_SUPPORT = 155,
+	WMI_TLV_SERVICE_PEER_TID_CONFIGS_SUPPORT = 156,
+	WMI_TLV_SERVICE_VDEV_SWRETRY_PER_AC_CONFIG_SUPPORT = 157,
+	WMI_TLV_SERVICE_DUAL_BEACON_ON_SINGLE_MAC_SCC_SUPPORT = 158,
+	WMI_TLV_SERVICE_DUAL_BEACON_ON_SINGLE_MAC_MCC_SUPPORT = 159,
+	WMI_TLV_SERVICE_MOTION_DET = 160,
+	WMI_TLV_SERVICE_INFRA_MBSSID = 161,
+	WMI_TLV_SERVICE_OBSS_SPATIAL_REUSE = 162,
+	WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT = 163,
+	WMI_TLV_SERVICE_NAN_DBS_SUPPORT = 164,
+	WMI_TLV_SERVICE_NDI_DBS_SUPPORT = 165,
+	WMI_TLV_SERVICE_NAN_SAP_SUPPORT = 166,
+	WMI_TLV_SERVICE_NDI_SAP_SUPPORT = 167,
+	WMI_TLV_SERVICE_CFR_CAPTURE_SUPPORT = 168,
+	WMI_TLV_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1 = 169,
+	WMI_TLV_SERVICE_ESP_SUPPORT = 170,
+	WMI_TLV_SERVICE_PEER_CHWIDTH_CHANGE = 171,
+	WMI_TLV_SERVICE_WLAN_HPCS_PULSE = 172,
+	WMI_TLV_SERVICE_PER_VDEV_CHAINMASK_CONFIG_SUPPORT = 173,
+	WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI = 174,
+	WMI_TLV_SERVICE_NAN_DISABLE_SUPPORT = 175,
+	WMI_TLV_SERVICE_HTT_H2T_NO_HTC_HDR_LEN_IN_MSG_LEN = 176,
+	WMI_TLV_SERVICE_COEX_SUPPORT_UNEQUAL_ISOLATION = 177,
+	WMI_TLV_SERVICE_HW_DB2DBM_CONVERSION_SUPPORT = 178,
+	WMI_TLV_SERVICE_SUPPORT_EXTEND_ADDRESS = 179,
+	WMI_TLV_SERVICE_BEACON_RECEPTION_STATS = 180,
+	WMI_TLV_SERVICE_FETCH_TX_PN = 181,
+	WMI_TLV_SERVICE_PEER_UNMAP_RESPONSE_SUPPORT = 182,
+	WMI_TLV_SERVICE_TX_PER_PEER_AMPDU_SIZE = 183,
+	WMI_TLV_SERVICE_BSS_COLOR_SWITCH_COUNT = 184,
+	WMI_TLV_SERVICE_PEER_STATS = 185,
 
 	WMI_TLV_MAX_EXT_SERVICE = 256,
 };
@@ -1557,6 +1588,8 @@ enum wmi_tlv_service {
 	SVCMAP(WMI_TLV_SERVICE_THERM_THROT,
 	       WMI_SERVICE_THERM_THROT,
 	       WMI_TLV_MAX_SERVICE);
+	SVCMAP(WMI_TLV_SERVICE_PEER_STATS,
+	       WMI_SERVICE_PEER_STATS, WMI_TLV_MAX_SERVICE);
 }
 
 #undef SVCMAP
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 39a6568..e89066b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5043,13 +5043,10 @@ enum wmi_rate_preamble {
 #define ATH10K_HW_PREAMBLE(rate)	(((rate) >> 6) & 0x3)
 #define ATH10K_HW_MCS_RATE(rate)	((rate) & 0xf)
 #define ATH10K_HW_LEGACY_RATE(rate)	((rate) & 0x3f)
-#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)
-#define ATH10K_HW_GI(flags)		(((flags) >> 5) & 0x1)
 #define ATH10K_HW_RATECODE(rate, nss, preamble) \
 	(((preamble) << 6) | ((nss) << 4) | (rate))
 #define ATH10K_HW_AMPDU(flags)		((flags) & 0x1)
 #define ATH10K_HW_BA_FAIL(flags)	(((flags) >> 1) & 0x3)
-#define ATH10K_FW_SKIPPED_RATE_CTRL(flags)	(((flags) >> 6) & 0x1)
 
 #define ATH10K_VHT_MCS_NUM	10
 #define ATH10K_BW_NUM		4
-- 
1.9.1

