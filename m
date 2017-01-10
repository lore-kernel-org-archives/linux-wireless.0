Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40291 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933162AbdAJPbY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 10:31:24 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix wifi connectivity and warning in Rx with channel 169
Date: Tue, 10 Jan 2017 21:01:58 +0530
Message-ID: <1484062318-13476-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170110_163147_795316_FADB6E93)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

In countries where basic operation of channel 169 is allowed,
this fixes the below WARN_ON_ONCE in Rx and fixes the station
connectivity failure in channel 169 as the packet is dropped
in the driver as the current check limits to channel 165. As of
now all the packets beyond channel 165 is dropped, fix this
by extending the range to channel 169.

Call trace:

drivers/net/wireless/ath/ath10k/wmi.c:1505
ath10k_wmi_event_mgmt_rx+0x278/0x440 [ath10k_core]()
Call Trace:
 [<c158f812>] ? printk+0x2d/0x2f
 [<c105a182>] warn_slowpath_common+0x72/0xa0
 [<f8b67b58>] ? ath10k_wmi_event_mgmt_rx+0x278/0x440

 [<f8b67b58>] ? ath10k_wmi_event_mgmt_rx+0x278/0x440

 [<c105a1d2>] warn_slowpath_null+0x22/0x30
 [<f8b67b58>] ath10k_wmi_event_mgmt_rx+0x278/0x440

 [<f8b0e72b>] ? ath10k_pci_sleep+0x8b/0xb0 [ath10k_pci]
 [<f8b6ac63>] ath10k_wmi_10_2_op_rx+0xf3/0x3b0

 [<f8b6495e>] ath10k_wmi_process_rx+0x1e/0x60

 [<f8b5f077>] ath10k_htc_rx_completion_handler+0x347/0x4d0 [ath10k_core]
 [<f8b11dc3>] ? ath10k_ce_completed_recv_next+0x53/0x70 [ath10k_pci]
 [<f8b0f921>] ath10k_pci_ce_recv_data+0x171/0x1d0 [ath10k_pci]
 [<f8b0ec69>] ? ath10k_pci_write32+0x39/0x80 [ath10k_pci]
 [<f8b120bc>] ath10k_ce_per_engine_service+0x5c/0xa0 [ath10k_pci]
 [<f8b1215f>] ath10k_ce_per_engine_service_any+0x5f/0x70 [ath10k_pci]
 [<c1060dc0>] ? local_bh_enable_ip+0x90/0x90
 [<f8b1048b>] ath10k_pci_tasklet+0x1b/0x50 [ath10k_pci]

Fixes: 34c30b0a5e97 ("ath10k: enable advertising support for channel 169, 5Ghz")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 50d6ee6..d30a68c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2319,7 +2319,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	 */
 	if (channel >= 1 && channel <= 14) {
 		status->band = NL80211_BAND_2GHZ;
-	} else if (channel >= 36 && channel <= 165) {
+	} else if (channel >= 36 && channel <= 169) {
 		status->band = NL80211_BAND_5GHZ;
 	} else {
 		/* Shouldn't happen unless list of advertised channels to
-- 
1.9.1
