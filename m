Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46502 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcF0Ipg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 04:45:36 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 2/3] ath10k: handle testmode events for 10.2 and 10.4 based firmware
Date: Mon, 27 Jun 2016 14:20:50 +0530
Message-ID: <1467017450-7552-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160627_104539_342675_59A7CA13)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Currently testmode events for 10.x firmware are processed from
10.1 wmi event processing. This patch is used to handle testmode
events in 10.2 and 10.4 based firmware.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6279ab4..72b5483 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5095,6 +5095,7 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10_2_event_id id;
+	bool consumed;
 
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
@@ -5104,6 +5105,18 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
+	consumed = ath10k_tm_event_wmi(ar, id, skb);
+
+	/* Ready event must be handled normally also in UTF mode so that we
+	 * know the UTF firmware has booted, others we are just bypass WMI
+	 * events to testmode.
+	 */
+	if (consumed && id != WMI_10_2_READY_EVENTID) {
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			   "wmi testmode consumed 0x%x\n", id);
+		goto out;
+	}
+
 	switch (id) {
 	case WMI_10_2_MGMT_RX_EVENTID:
 		ath10k_wmi_event_mgmt_rx(ar, skb);
@@ -5219,6 +5232,7 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_10_4_event_id id;
+	bool consumed;
 
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
@@ -5228,6 +5242,18 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 
 	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
+	consumed = ath10k_tm_event_wmi(ar, id, skb);
+
+	/* Ready event must be handled normally also in UTF mode so that we
+	 * know the UTF firmware has booted, others we are just bypass WMI
+	 * events to testmode.
+	 */
+	if (consumed && id != WMI_10_4_READY_EVENTID) {
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			   "wmi testmode consumed 0x%x\n", id);
+		goto out;
+	}
+
 	switch (id) {
 	case WMI_10_4_MGMT_RX_EVENTID:
 		ath10k_wmi_event_mgmt_rx(ar, skb);
-- 
1.7.9.5

