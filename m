Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1153C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 09:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 980DF2146E
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 09:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i7eAg9E7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IEdNfX/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfBSJzW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:55:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBSJzW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 04:55:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 53706608FD; Tue, 19 Feb 2019 09:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550570120;
        bh=bECfgQcxpfICBQnXC5JTPP9ymgO/2F1+ahMKDN99r6I=;
        h=From:To:Cc:Subject:Date:From;
        b=i7eAg9E7xBo3dimhjTFQdjOrR2hFrxd43wj2zpw4YiXvmx2RfZEb9avQVn3b6p01c
         KqIDoHBLcoTxp7xZO/DQ5qGcLCoz+LmhIftbjm9y6jWHi3ZOuFElJf5Q/poExI+R2k
         PPBrs3mqqm3GE7DD+oCt5B4qSoqsjbSncawS/I+c=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBFED608C6;
        Tue, 19 Feb 2019 09:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550570117;
        bh=bECfgQcxpfICBQnXC5JTPP9ymgO/2F1+ahMKDN99r6I=;
        h=From:To:Cc:Subject:Date:From;
        b=IEdNfX/U9AIwPEp/v1S/UsGoa5rnCD5sgNYiqF/qMzbTtETTQKN0g3Bf2ljmnmbun
         jXGLx8C9ezyyF78tO+Pl30Jz4nR5b7UvvFFiQ0Q3UlaYY6RfFAdbnbj6RbGkDINUK6
         cDR8yNaNijT4tqHLtXiplzZBhQ1MdZo48azvBfdE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBFED608C6
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Fill rx duration for each peer in fw_stats for WCN3990
Date:   Tue, 19 Feb 2019 15:25:10 +0530
Message-Id: <1550570110-32010-1-git-send-email-svishnoi@codeaurora.org>
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
 drivers/net/wireless/ath/ath10k/core.c    |  4 ++--
 drivers/net/wireless/ath/ath10k/core.h    |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 +++++++
 6 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a1b2aea..5ff9cf4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2315,8 +2315,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
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
index 2f43600..e786ce0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -200,7 +200,7 @@ struct ath10k_fw_stats_peer {
 	u32 peer_rssi;
 	u32 peer_tx_rate;
 	u32 peer_rx_rate; /* 10x only */
-	u32 rx_duration;
+	u64 rx_duration;
 };
 
 struct ath10k_fw_extd_stats_peer {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 84de6ec..80c35ad 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -24,6 +24,7 @@
 #include "wmi-tlv.h"
 #include "p2p.h"
 #include "testmode.h"
+#include <linux/bitfield.h>
 
 /***************/
 /* TLV helpers */
@@ -1289,6 +1290,7 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 {
 	const void **tb;
 	const struct wmi_tlv_stats_ev *ev;
+	u32 num_peer_stats_extd;
 	const void *data;
 	u32 num_pdev_stats;
 	u32 num_vdev_stats;
@@ -1296,6 +1298,7 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 	u32 num_bcnflt_stats;
 	u32 num_chan_stats;
 	size_t data_len;
+	u32 stats_id;
 	int ret;
 	int i;
 
@@ -1320,11 +1323,13 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
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
@@ -1389,6 +1394,28 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 
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
+				dst->rx_duration |= rx_duration_high <<
+						    WMI_TLV_PEER_RX_DURATION_SHIFT;
+			}
+		}
+
 		list_add_tail(&dst->list, &stats->peers);
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 4fba581..3165d95 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1875,6 +1875,22 @@ struct wmi_tlv_req_stats_cmd {
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
@@ -1968,6 +1984,10 @@ struct wmi_tlv_stats_ev {
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
index 704c71b..1c51341 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8315,7 +8315,7 @@ size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head)
 			"Peer TX rate", peer->peer_tx_rate);
 	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
 			"Peer RX rate", peer->peer_rx_rate);
-	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+	len += scnprintf(buf + len, buf_len - len, "%30s %llu\n",
 			"Peer RX duration", peer->rx_duration);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0e27878..b3aa696 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4545,6 +4545,13 @@ enum wmi_10_4_stats_id {
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

