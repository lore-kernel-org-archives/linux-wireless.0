Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7431 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbcIOOaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:30:12 -0400
From: <c_mkenna@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <mkenna@codeaurora.org>,
        Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Subject: [PATCH] ath10k: Provide provision to get Transmit Power Control stats for 10.4
Date: Thu, 15 Sep 2016 20:00:19 +0530
Message-ID: <1473949819-29154-1-git-send-email-c_mkenna@qti.qualcomm.com> (sfid-20160915_163024_933248_F9DA02CB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

This patch helps to get the TPC stats for 10.4 fw variants.

Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 38993d7..44a1a8d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5391,6 +5391,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_PDEV_BSS_CHAN_INFO_EVENTID:
 		ath10k_wmi_event_pdev_bss_chan_info(ar, skb);
 		break;
+	case WMI_10_4_PDEV_TPC_CONFIG_EVENTID:
+		ath10k_wmi_event_pdev_tpc_config(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -8147,6 +8150,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.get_vdev_subtype = ath10k_wmi_10_4_op_get_vdev_subtype,
 	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 	.gen_echo = ath10k_wmi_op_gen_echo,
+	.gen_pdev_get_tpc_config = ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.7.9.5
