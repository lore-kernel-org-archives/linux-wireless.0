Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7508 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbcCVWpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 18:45:39 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath10k: parse Rx MAC timestamp in mgmt frame for FW 10.4
Date: Tue, 22 Mar 2016 15:44:53 -0700
Message-ID: <20caae0068a19c546f87ef4a25e3651af92c02ab.1458686620.git.poh@qca.qualcomm.com> (sfid-20160322_234557_583423_09046EF3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check and parse Rx MAC timestamp when firmware sets its flag
to status variable.
10.4 firmware adds it in Rx beacon frame only at this moment.
Drivers and mac80211 may utilize it to detect such clockdrift
or beacon collision and use the result for beacon collision
avoidance.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---

v2:
 * Rebased. no code changes.

 drivers/net/wireless/ath/ath10k/wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9137566..9977876 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2191,6 +2191,8 @@ static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
 	struct wmi_10_4_mgmt_rx_hdr *ev_hdr;
 	size_t pull_len;
 	u32 msdu_len;
+	struct wmi_mgmt_rx_ext_info *ext_info;
+	u32 len;
 
 	ev = (struct wmi_10_4_mgmt_rx_event *)skb->data;
 	ev_hdr = &ev->hdr;
@@ -2211,6 +2213,13 @@ static int ath10k_wmi_10_4_op_pull_mgmt_rx_ev(struct ath10k *ar,
 	if (skb->len < msdu_len)
 		return -EPROTO;
 
+	if (le32_to_cpu(arg->status) & WMI_RX_STATUS_EXT_INFO) {
+		len = ALIGN(le32_to_cpu(arg->buf_len), 4);
+		ext_info = (struct wmi_mgmt_rx_ext_info *)(skb->data + len);
+		memcpy(&arg->ext_info, ext_info,
+		       sizeof(struct wmi_mgmt_rx_ext_info));
+	}
+
 	/* Make sure bytes added for padding are removed. */
 	skb_trim(skb, msdu_len);
 
-- 
1.9.1

