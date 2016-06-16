Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47262 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbcFPMxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 08:53:11 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Enable beacon loss detection support for 10.4
Date: Thu, 16 Jun 2016 18:24:44 +0530
Message-ID: <1466081684-8074-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160616_145315_237467_1D228F20)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable beacon loss detection support for 10.4 by handling
roam event. With this change QCA99X0 station is able to
detect beacon loss when the AP is powered off

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6279ab4..4dd35f1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5257,6 +5257,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_PEER_STA_KICKOUT_EVENTID:
 		ath10k_wmi_event_peer_sta_kickout(ar, skb);
 		break;
+	case WMI_10_4_ROAM_EVENTID:
+		ath10k_wmi_event_roam(ar, skb);
+		break;
 	case WMI_10_4_HOST_SWBA_EVENTID:
 		ath10k_wmi_event_host_swba(ar, skb);
 		break;
@@ -7903,6 +7906,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.pull_phyerr = ath10k_wmi_10_4_op_pull_phyerr_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
 	.get_txbf_conf_scheme = ath10k_wmi_10_4_txbf_conf_scheme,
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
-- 
1.9.1

