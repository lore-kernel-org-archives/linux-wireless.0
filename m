Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44840 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161909Ab2CSQPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 12:15:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH 5/9] ath6kl: add rx data padding support
Date: Mon, 19 Mar 2012 18:15:00 +0200
Message-Id: <1332173704-18877-6-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120319_171602_523647_B38B33C0)
In-Reply-To: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed when using USB.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    7 +++++++
 drivers/net/wireless/ath/ath6kl/wmi.h  |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 53d0334..5559c9b 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1287,6 +1287,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	struct wmi_data_hdr *dhdr;
 	int min_hdr_len;
 	u8 meta_type, dot11_hdr = 0;
+	u8 pad_before_data_start;
 	int status = packet->status;
 	enum htc_endpoint_id ept = packet->endpoint;
 	bool is_amsdu, prev_ps, ps_state = false;
@@ -1498,6 +1499,10 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	seq_no = wmi_data_hdr_get_seqno(dhdr);
 	meta_type = wmi_data_hdr_get_meta(dhdr);
 	dot11_hdr = wmi_data_hdr_get_dot11(dhdr);
+	pad_before_data_start =
+		(le16_to_cpu(dhdr->info3) >> WMI_DATA_HDR_PAD_BEFORE_DATA_SHIFT)
+			& WMI_DATA_HDR_PAD_BEFORE_DATA_MASK;
+
 	skb_pull(skb, sizeof(struct wmi_data_hdr));
 
 	switch (meta_type) {
@@ -1516,6 +1521,8 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		break;
 	}
 
+	skb_pull(skb, pad_before_data_start);
+
 	if (dot11_hdr)
 		status = ath6kl_wmi_dot11_hdr_remove(ar->wmi, skb);
 	else if (!is_amsdu)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 4092e3e..7989b33 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -182,6 +182,9 @@ enum wmi_data_hdr_flags {
 #define WMI_DATA_HDR_META_MASK      0x7
 #define WMI_DATA_HDR_META_SHIFT     13
 
+#define WMI_DATA_HDR_PAD_BEFORE_DATA_MASK               0xFF
+#define WMI_DATA_HDR_PAD_BEFORE_DATA_SHIFT              0x8
+
 /* Macros for operating on WMI_DATA_HDR (info3) field */
 #define WMI_DATA_HDR_IF_IDX_MASK    0xF
 
-- 
1.7.1

