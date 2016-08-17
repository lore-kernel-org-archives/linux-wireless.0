Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58601 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbcHQL22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 07:28:28 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: suppress warnings when getting wmi WDS peer event id
Date: Wed, 17 Aug 2016 16:58:00 +0530
Message-ID: <1471433280-15237-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160817_132833_664520_10AFD8AA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

'WMI_10_4_WDS_PEER_EVENTID' is not yet handled/implemented for WDS mode,
as of nowsuppress the warning message "Unknown eventid: 36903"

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
found this issue while running ath10k WDS AP -> ath10k WDS STA UDP traffic

 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6279ab4..a380616 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5274,6 +5274,7 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_10_4_WOW_WAKEUP_HOST_EVENTID:
 	case WMI_10_4_PEER_RATECODE_LIST_EVENTID:
+	case WMI_10_4_WDS_PEER_EVENTID:
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "received event id %d not implemented\n", id);
 		break;
-- 
1.9.1
