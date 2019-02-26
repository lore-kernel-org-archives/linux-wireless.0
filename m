Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6FBC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50EA8213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="crxK2UNZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NapQwhhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfBZJxY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:53:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfBZJxY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:53:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 78EBB60E3E; Tue, 26 Feb 2019 09:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551174802;
        bh=yZb01wDDgkYfdFHpo25sfQt3Vby12pzTJmMK3tOgn6M=;
        h=From:To:Cc:Subject:Date:From;
        b=crxK2UNZY/xI/Pl/kB7HYqB/Dy+WjBoJP7+SRVv/Qjx/1xaiSLpkfQzq0u3XLBMy1
         3AtzJLy0Y0ZTgKbL7PhDDI+xhQIyvu+68vipmCSbIJqi2/asrstOSNJgs4cg3Dzi+N
         YqJ9LFVaDR74MszJFuXp3JMykHdUEMWWXQOatm0U=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5DCAE6087A;
        Tue, 26 Feb 2019 09:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551174801;
        bh=yZb01wDDgkYfdFHpo25sfQt3Vby12pzTJmMK3tOgn6M=;
        h=From:To:Cc:Subject:Date:From;
        b=NapQwhhuNQJ63S44DoB5P0WqRuFgMyHLlQypQf14m7ATUsmHMY+bRU1eeUGkcQXrA
         f8NhZK2aYsUc6/LYg+ZW/1fLBgOEZmcytLE6UT7IqQfst3vq0C178G8KBxOZOG2ZxZ
         qCvBdKYtWDulvWOQW+gs+jhnZuOHyhbyz+rxxahw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5DCAE6087A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH v2] ath10k: Fill rx duration for each peer in fw_stats for WCN3990
Date:   Tue, 26 Feb 2019 15:23:16 +0530
Message-Id: <1551174796-25264-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, rx_duration for each peer is not getting populated in
fw_stats debugfs entry for WCN3990.

WCN3990 firmware sends rx duration for each peer as part of
peer_extd_stats in WMI_UPDATE_STATS_EVENT. To enable peer_extd_stats,
firmware expects host to send fw_stats_req_mask with flag
WMI_TLV_PEER_STATS_EXTD set in WMI_REQUEST_STATS_CMD.

Send fw_stats_req_mask with flag WMI_TLV_PEER_STATS_EXTD set in
WMI_REQUEST_STATS_CMD and parse the peer_extd_stats in
WMI_UPDATE_STATS_EVENT to populate the rx_duration of each peer
in fw_stats debugfs entry.

Currently the driver handles 32-bit rx_duration, but the rx_duration
for WCN3990 can be upto 63 bit. The firmware sends rx_duration split
into two 32-bit fields, with the upper 32-bits being valid only if its
MSB is set. This change handles the 63-bit rx_duration obtained from
WCN3990 and maintain the backward compatibility.

To get the rx_duration of each connected peer :
cat /sys/kernel/debug/ieee80211/phyX/ath10k/fw_stats

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
---
Changes from v1:
-Fixed the Kbuild bot warning (left shift count >= width of type [-Wshift-count-overflow])
---
 drivers/net/wireless/ath/ath10k/core.c    |  4 ++--
 drivers/net/wireless/ath/ath10k/core.h    |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 +++++++
 6 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index ac2cf3f..8afa3be 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2304,8 +2304,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		else
 			ar->htt.max_num_pending_tx = TARGET_TLV_NUM_MSDU_DESC;
 		ar->wow.max_num_patterns = TARGET_TLV_NUM_WOW_PATTERNS;
-		ar->fw_stats_req_mask = WMI_STAT_PDEV | WMI_STAT_VDEV |
-			WMI_STAT_PEER;
+		ar->fw_stats_req_mask = WMI_TLV_STAT_PDEV | WMI_TLV_STAT_VDEV |
+			WMI_TLV_STAT_PEER | WMI_TLV_STAT_PEER_EXTD;
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		ar->wmi.mgmt_max_num_pending_tx = TARGET_TLV_MGMT_NUM_MSDU_DESC;
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 27ec555..e08a17b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -189,7 +189,7 @@ struct ath10k_fw_stats_peer {
 	u32 peer_rssi;
 	u32 peer_tx_rate;
 	u32 peer_rx_rate; /* 10x only */
-	u32 rx_duration;
+	u64 rx_duration;
 };
 
 struct ath10k_fw_extd_stats_peer {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index fc62174..9b2ed0e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -13,6 +13,7 @@
 #include "wmi-tlv.h"
 #include "p2p.h"
 #include "testmode.h"
+#include <linux/bitfield.h>
 
 /***************/
 /* TLV helpers */
@@ -1278,6 +1279,7 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 {
 	const void **tb;
 	const struct wmi_tlv_stats_ev *ev;
+	u32 num_peer_stats_extd;
 	const void *data;
 	u32 num_pdev_stats;
 	u32 num_vdev_stats;
@@ -1285,6 +1287,7 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 	u32 num_bcnflt_stats;
 	u32 num_chan_stats;
 	size_t data_len;
+	u32 stats_id;
 	int ret;
 	int i;
 
@@ -1309,11 +1312,13 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
 	num_bcnflt_stats = __le32_to_cpu(ev->num_bcnflt_stats);
 	num_chan_stats = __le32_to_cpu(ev->num_chan_stats);
+	stats_id = __le32_to_cpu(ev->stats_id);
+	num_peer_stats_extd = __le32_to_cpu(ev->num_peer_stats_extd);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi tlv stats update pdev %i vdev %i peer %i bcnflt %i chan %i\n",
+		   "wmi tlv stats update pdev %i vdev %i peer %i bcnflt %i chan %i peer_extd %i\n",
 		   num_pdev_stats, num_vdev_stats, num_peer_stats,
-		   num_bcnflt_stats, num_chan_stats);
+		   num_bcnflt_stats, num_chan_stats, num_peer_stats_extd);
 
 	for (i = 0; i < num_pdev_stats; i++) {
 		const struct wmi_pdev_stats *src;
@@ -1378,6 +1383,28 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 
 		ath10k_wmi_pull_peer_stats(&src->old, dst);
 		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
+
+		if (stats_id & WMI_TLV_STAT_PEER_EXTD) {
+			const struct wmi_tlv_peer_stats_extd *extd;
+			unsigned long rx_duration_high;
+
+			extd = data + sizeof(*src) * (num_peer_stats - i - 1)
+			       + sizeof(*extd) * i;
+
+			dst->rx_duration = __le32_to_cpu(extd->rx_duration);
+			rx_duration_high = __le32_to_cpu
+						(extd->rx_duration_high);
+
+			if (test_bit(WMI_TLV_PEER_RX_DURATION_HIGH_VALID_BIT,
+				     &rx_duration_high)) {
+				rx_duration_high =
+					FIELD_GET(WMI_TLV_PEER_RX_DURATION_HIGH_MASK,
+						  rx_duration_high);
+				dst->rx_duration |= (u64)rx_duration_high <<
+						    WMI_TLV_PEER_RX_DURATION_SHIFT;
+			}
+		}
+
 		list_add_tail(&dst->list, &stats->peers);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index af4cb0e..03d02ed 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1864,6 +1864,22 @@ struct wmi_tlv_req_stats_cmd {
 	struct wmi_mac_addr peer_macaddr;
 } __packed;
 
+#define WMI_TLV_PEER_RX_DURATION_HIGH_VALID_BIT	31
+#define WMI_TLV_PEER_RX_DURATION_HIGH_MASK	GENMASK(30, 0)
+#define WMI_TLV_PEER_RX_DURATION_SHIFT		32
+
+struct wmi_tlv_peer_stats_extd {
+	struct wmi_mac_addr peer_macaddr;
+	__le32 rx_duration;
+	__le32 peer_tx_bytes;
+	__le32 peer_rx_bytes;
+	__le32 last_tx_rate_code;
+	__le32 last_tx_power;
+	__le32 rx_mc_bc_cnt;
+	__le32 rx_duration_high;
+	__le32 reserved[2];
+} __packed;
+
 struct wmi_tlv_vdev_stats {
 	__le32 vdev_id;
 	__le32 beacon_snr;
@@ -1957,6 +1973,10 @@ struct wmi_tlv_stats_ev {
 	__le32 num_peer_stats;
 	__le32 num_bcnflt_stats;
 	__le32 num_chan_stats;
+	__le32 num_mib_stats;
+	__le32 pdev_id;
+	__le32 num_bcn_stats;
+	__le32 num_peer_stats_extd;
 } __packed;
 
 struct wmi_tlv_p2p_noa_ev {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 97e5b2e..8fb043e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8304,7 +8304,7 @@ size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head)
 			"Peer TX rate", peer->peer_tx_rate);
 	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
 			"Peer RX rate", peer->peer_rx_rate);
-	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+	len += scnprintf(buf + len, buf_len - len, "%30s %llu\n",
 			"Peer RX duration", peer->rx_duration);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d9b646f..39a6568 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4534,6 +4534,13 @@ enum wmi_10_4_stats_id {
 	WMI_10_4_STAT_VDEV_EXTD		= BIT(4),
 };
 
+enum wmi_tlv_stats_id {
+	WMI_TLV_STAT_PDEV	= BIT(0),
+	WMI_TLV_STAT_VDEV	= BIT(1),
+	WMI_TLV_STAT_PEER	= BIT(2),
+	WMI_TLV_STAT_PEER_EXTD  = BIT(10),
+};
+
 struct wlan_inst_rssi_args {
 	__le16 cfg_retry_count;
 	__le16 retry_count;
-- 
1.9.1

