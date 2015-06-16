Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60015 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbbFPFsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:48:36 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 10/10] ath10k: handle 10.4 fw wmi ready event
Date: Tue, 16 Jun 2015 11:15:23 +0530
Message-ID: <1434433523-8357-11-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_080350_635463_E8D43A01)
In-Reply-To: <1434433523-8357-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434433523-8357-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reuse existing function ath10k_wmi_op_pull_rdy_ev()
to parse WMI_10_4_READY_EVENTID and handle the same
event in ath10k_wmi_10_4_op_rx().

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e5d948e..8d4ff3e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4252,6 +4252,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_mgmt_rx(ar, skb);
 		/* mgmt_rx() owns the skb now! */
 		return;
+	case WMI_10_4_READY_EVENTID:
+		ath10k_wmi_event_ready(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -6184,6 +6187,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.map_svc = wmi_10_4_svc_map,
 	.pull_mgmt_rx = ath10k_wmi_10_4_op_pull_mgmt_rx_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
+	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
 };
 
-- 
1.8.1.2

