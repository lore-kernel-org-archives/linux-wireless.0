Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F380AC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 16:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6239223CB
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 16:14:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WaK60/se";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O8nJ2weJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6239223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388439AbeKPCXW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 21:23:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387922AbeKPCXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 21:23:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 40CA360452; Thu, 15 Nov 2018 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542298494;
        bh=0LS4hG5nPVtFPqd+LqswSxkyLV/VlNMkAd0QGpj8xRQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WaK60/seACg956F3VdyI7s2TQPEmkjLDh7fHSC8gNHqN4JWY1BcaB6TwcrXDeIxPv
         UkruAxc82t5XJHCaKMmg4OBxgI+UOgmUL85BWCBtJEm0OOxlvsBBZmpBMNV5yuqWtk
         8YiGVWwXmpunHALJKZNzXqtT3dOuZ2miYTBSt0VI=
Received: from vnaralas-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mpubbise@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 159ED6028D;
        Thu, 15 Nov 2018 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542298493;
        bh=0LS4hG5nPVtFPqd+LqswSxkyLV/VlNMkAd0QGpj8xRQ=;
        h=From:To:Cc:Subject:Date:From;
        b=O8nJ2weJLSm9RxMs7z9DkROiQKNFKRm0PWc1BHFrwzGZptwHF+IP6PSR8ILuMuAsE
         TXkxbkUkfdr4FEQZxxJMpRNlJM/Bh7oSzWuMrZXohmJXHmgrI1gZ3e/nt5s85d4IpS
         Si9vBHcwoKuCfaNbWwst59rQ/IGNvKBPjHGzURpE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 159ED6028D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mpubbise@codeaurora.org
From:   Manikanta Pubbisetty <mpubbise@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] ath10k: report tx airtime provided by fw
Date:   Thu, 15 Nov 2018 21:44:43 +0530
Message-Id: <1542298483-15879-1-git-send-email-mpubbise@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If supported, update transmit airtime in mac80211 with the airtime
values reported by the firmware. TX airtime of the PPDU is reported
via HTT data TX completion indication message.

A new service flag 'WMI_SERVICE_REPORT_AIRTIME' is added to advertise
the firmware support. For firmwares which do not support this feature,
TX airtime is calculated in the driver using TX bitrate.

Hardwares tested : QCA9984
Firmwares tested : 10.4-3.6.1-00841

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
* Changes are made on top of Rajkumar's changes for ATF

 drivers/net/wireless/ath/ath10k/core.c   |  3 ++
 drivers/net/wireless/ath/ath10k/htt.h    | 21 ++++++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 52 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.c    |  6 +++-
 drivers/net/wireless/ath/ath10k/txrx.c   |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h    | 42 ++++++++++++++++++++++++++
 6 files changed, 121 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index adf2b13..ce2338b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2599,6 +2599,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 			     ar->wmi.svc_map))
 			val |= WMI_10_4_TX_DATA_ACK_RSSI;
 
+		if (test_bit(WMI_SERVICE_REPORT_AIRTIME, ar->wmi.svc_map))
+			val |= WMI_10_4_REPORT_AIRTIME;
+
 		status = ath10k_mac_ext_resource_config(ar, val);
 		if (status) {
 			ath10k_err(ar,
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index a76f7c9..e2d40ab 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -564,6 +564,7 @@ struct htt_mgmt_tx_completion {
 #define HTT_RX_INDICATION_INFO0_EXT_TID_LSB   (0)
 #define HTT_RX_INDICATION_INFO0_FLUSH_VALID   (1 << 5)
 #define HTT_RX_INDICATION_INFO0_RELEASE_VALID (1 << 6)
+#define HTT_RX_INDICATION_INFO0_PPDU_DURATION BIT(7)
 
 #define HTT_RX_INDICATION_INFO1_FLUSH_START_SEQNO_MASK   0x0000003F
 #define HTT_RX_INDICATION_INFO1_FLUSH_START_SEQNO_LSB    0
@@ -576,7 +577,10 @@ struct htt_mgmt_tx_completion {
 #define HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES_MASK     0xFF000000
 #define HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES_LSB      24
 
-#define HTT_TX_CMPL_FLAG_DATA_RSSI BIT(0)
+#define HTT_TX_CMPL_FLAG_DATA_RSSI		BIT(0)
+#define HTT_TX_CMPL_FLAG_PPID_PRESENT		BIT(1)
+#define HTT_TX_CMPL_FLAG_PA_PRESENT		BIT(2)
+#define HTT_TX_CMPL_FLAG_PPDU_DURATION_PRESENT	BIT(3)
 
 struct htt_rx_indication_hdr {
 	u8 info0; /* %HTT_RX_INDICATION_INFO0_ */
@@ -866,6 +870,21 @@ struct htt_data_tx_completion {
 	__le16 msdus[0]; /* variable length based on %num_msdus */
 } __packed;
 
+#define HTT_TX_PPDU_DUR_INFO0_PEER_ID_MASK	GENMASK(15, 0)
+#define HTT_TX_PPDU_DUR_INFO0_TID_MASK		GENMASK(20, 16)
+
+struct htt_data_tx_ppdu_dur {
+	__le32 info0; /* HTT_TX_PPDU_DUR_INFO0_ */
+	__le32 tx_duration; /* in usecs */
+} __packed;
+
+#define HTT_TX_COMPL_PPDU_DUR_INFO0_NUM_ENTRIES_MASK	GENMASK(7, 0)
+
+struct htt_data_tx_compl_ppdu_dur {
+	__le32 info0; /* HTT_TX_COMPL_PPDU_DUR_INFO0_ */
+	struct htt_data_tx_ppdu_dur ppdu_dur[0];
+} __packed;
+
 struct htt_tx_compl_ind_base {
 	u32 hdr;
 	u16 payload[1/*or more*/];
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0f775be..3b55f8a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2003,8 +2003,12 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 	int status = MS(resp->data_tx_completion.flags, HTT_DATA_TX_STATUS);
 	__le16 msdu_id, *msdus;
 	bool rssi_enabled = false;
-	u8 msdu_count = 0;
+	u8 msdu_count = 0, num_airtime_records, tid;
 	int i;
+	struct htt_data_tx_compl_ppdu_dur *ppdu_info;
+	struct ath10k_peer *peer;
+	u16 ppdu_info_offset = 0, peer_id;
+	u32 tx_duration;
 
 	switch (status) {
 	case HTT_DATA_TX_STATUS_NO_ACK:
@@ -2028,12 +2032,12 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 		   resp->data_tx_completion.num_msdus);
 
 	msdu_count = resp->data_tx_completion.num_msdus;
+	msdus = resp->data_tx_completion.msdus;
 
 	if (resp->data_tx_completion.flags2 & HTT_TX_CMPL_FLAG_DATA_RSSI)
 		rssi_enabled = true;
 
 	for (i = 0; i < msdu_count; i++) {
-		msdus = resp->data_tx_completion.msdus;
 		msdu_id = msdus[i];
 		tx_done.msdu_id = __le16_to_cpu(msdu_id);
 
@@ -2065,6 +2069,50 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 			ath10k_txrx_tx_unref(htt, &tx_done);
 		}
 	}
+
+	if (!(resp->data_tx_completion.flags2 & HTT_TX_CMPL_FLAG_PPDU_DURATION_PRESENT))
+		return;
+
+	ppdu_info_offset = (msdu_count & 0x01) ? msdu_count + 1 : msdu_count;
+
+	if (rssi_enabled)
+		ppdu_info_offset += ppdu_info_offset;
+
+	if (resp->data_tx_completion.flags2 &
+	    (HTT_TX_CMPL_FLAG_PPID_PRESENT | HTT_TX_CMPL_FLAG_PA_PRESENT))
+		ppdu_info_offset += 2;
+
+	ppdu_info = (struct htt_data_tx_compl_ppdu_dur *)&msdus[ppdu_info_offset];
+	num_airtime_records = FIELD_GET(HTT_TX_COMPL_PPDU_DUR_INFO0_NUM_ENTRIES_MASK,
+					__le32_to_cpu(ppdu_info->info0));
+
+	for (i = 0; i < num_airtime_records; i++) {
+		struct htt_data_tx_ppdu_dur *ppdu_dur;
+		u32 info0;
+
+		ppdu_dur = &ppdu_info->ppdu_dur[i];
+		info0 = __le32_to_cpu(ppdu_dur->info0);
+
+		peer_id = FIELD_GET(HTT_TX_PPDU_DUR_INFO0_PEER_ID_MASK,
+				    info0);
+		rcu_read_lock();
+		spin_lock_bh(&ar->data_lock);
+
+		peer = ath10k_peer_find_by_id(ar, peer_id);
+		if (!peer) {
+			spin_unlock_bh(&ar->data_lock);
+			rcu_read_unlock();
+			continue;
+		}
+
+		tid = FIELD_GET(HTT_TX_PPDU_DUR_INFO0_TID_MASK, info0);
+		tx_duration = __le32_to_cpu(ppdu_dur->tx_duration);
+
+		ieee80211_sta_register_airtime(peer->sta, tid, tx_duration, 0);
+
+		spin_unlock_bh(&ar->data_lock);
+		rcu_read_unlock();
+	}
 }
 
 static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 428730f..7694abb 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3967,6 +3967,9 @@ static u16 ath10k_mac_update_airtime(struct ath10k *ar,
 	if (!txq || !txq->sta)
 		return airtime;
 
+	if (test_bit(WMI_SERVICE_REPORT_AIRTIME, ar->wmi.svc_map))
+		return airtime;
+
 	spin_lock_bh(&ar->data_lock);
 	arsta = (struct ath10k_sta *)txq->sta->drv_priv;
 
@@ -8615,7 +8618,8 @@ int ath10k_mac_register(struct ath10k *ar)
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
 
-	if (ath10k_peer_stats_enabled(ar))
+	if (ath10k_peer_stats_enabled(ar) ||
+	    test_bit(WMI_SERVICE_REPORT_AIRTIME, ar->wmi.svc_map))
 		wiphy_ext_feature_set(ar->hw->wiphy,
 				      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	/*
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 8e7c416..134e1c5 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,7 +95,7 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
-	if (txq && txq->sta)
+	if (txq && txq->sta && skb_cb->airtime_est)
 		ieee80211_sta_register_airtime(txq->sta, txq->tid,
 					       skb_cb->airtime_est, 0);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 58e33ab..f41d654 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -205,6 +205,14 @@ enum wmi_service {
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
 	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT,
+	WMI_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS,
+	WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
+	WMI_SERVICE_PEER_CHWIDTH_CHANGE,
+	WMI_SERVICE_RX_FILTER_OUT_COUNT,
+	WMI_SERVICE_RTT_RESPONDER_ROLE,
+	WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+	WMI_SERVICE_REPORT_AIRTIME,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -359,6 +367,14 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
 	WMI_10_4_SERVICE_VDEV_BCN_RATE_CONTROL,
 	WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	WMI_10_4_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT,
+	WMI_10_4_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS,
+	WMI_10_4_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
+	WMI_10_4_SERVICE_PEER_CHWIDTH_CHANGE,
+	WMI_10_4_SERVICE_RX_FILTER_OUT_COUNT,
+	WMI_10_4_SERVICE_RTT_RESPONDER_ROLE,
+	WMI_10_4_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+	WMI_10_4_SERVICE_REPORT_AIRTIME,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -474,6 +490,14 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
+	SVCSTR(WMI_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT);
+	SVCSTR(WMI_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS);
+	SVCSTR(WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT);
+	SVCSTR(WMI_SERVICE_PEER_CHWIDTH_CHANGE);
+	SVCSTR(WMI_SERVICE_RX_FILTER_OUT_COUNT);
+	SVCSTR(WMI_SERVICE_RTT_RESPONDER_ROLE);
+	SVCSTR(WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT);
+	SVCSTR(WMI_SERVICE_REPORT_AIRTIME);
 	default:
 		return NULL;
 	}
@@ -786,6 +810,22 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
 	SVCMAP(WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
 	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT,
+	       WMI_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS,
+	       WMI_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS, len);
+	SVCMAP(WMI_10_4_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
+	       WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_PEER_CHWIDTH_CHANGE,
+	       WMI_SERVICE_PEER_CHWIDTH_CHANGE, len);
+	SVCMAP(WMI_10_4_SERVICE_RX_FILTER_OUT_COUNT,
+	       WMI_SERVICE_RX_FILTER_OUT_COUNT, len);
+	SVCMAP(WMI_10_4_SERVICE_RTT_RESPONDER_ROLE,
+	       WMI_SERVICE_RTT_RESPONDER_ROLE, len);
+	SVCMAP(WMI_10_4_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT,
+	       WMI_SERVICE_EXT_PEER_TID_CONFIGS_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_REPORT_AIRTIME,
+	       WMI_SERVICE_REPORT_AIRTIME, len);
 }
 
 #undef SVCMAP
@@ -2956,6 +2996,8 @@ enum wmi_10_4_feature_mask {
 	WMI_10_4_TDLS_CONN_TRACKER_IN_HOST_MODE = BIT(11),
 	WMI_10_4_TDLS_EXPLICIT_MODE_ONLY	= BIT(12),
 	WMI_10_4_TX_DATA_ACK_RSSI               = BIT(16),
+	WMI_10_4_EXT_PEER_TID_CONFIGS_SUPPORT	= BIT(17),
+	WMI_10_4_REPORT_AIRTIME			= BIT(18),
 
 };
 
-- 
2.7.4

