Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbcEFMHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 08:07:43 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: suppress warnings when getting wmi peer_rate_code_list event
Date: Fri, 6 May 2016 17:37:02 +0530
Message-ID: <1462536423-9903-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160506_140746_744539_8EEB856F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 10.4, fw sends WMI PEER_RATECODE_LIST_EVENTID after successful
peer_assoc cmd. As of now this event is not of much use and not
implemented. Change the debug level and messsage as appropriate
to suppress "Unknown eventid: 36898".

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 39a54a5..2a14b16 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5213,6 +5213,7 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_stopped(ar, skb);
 		break;
 	case WMI_10_4_WOW_WAKEUP_HOST_EVENTID:
+	case WMI_10_4_PEER_RATECODE_LIST_EVENTID:
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "received event id %d not implemented\n", id);
 		break;
-- 
1.9.1

