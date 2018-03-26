Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbeCZHem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 03:34:42 -0400
From: Sathishkumar Muruganandam <murugana@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: [PATCH] ath10k: Suppress "Unknown eventid: 36925" warnings
Date: Mon, 26 Mar 2018 13:04:01 +0530
Message-Id: <1522049641-19521-1-git-send-email-murugana@codeaurora.org> (sfid-20180326_093445_507275_A8AEF037)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW has Smart Logging feature enabled by default for detecting failures
and processing FATAL_CONDITION_EVENTID (36925 - 0x903D) back to host.

Since ath10k doesn't implement the Smart Logging and FATAL CONDITION
EVENT processing yet, suppressing the unknown event ID warning by moving
this under ATH10K_DBG_WMI.

Simulated the same issue by having associated STA powered off when
ping flood was running from AP backbone. This triggerd STA KICKOUT
in AP followed by FATAL CONDITION event 36925.

Issue was reproduced and verified in below DUT
------------------------------------------------
AP mode of OpenWRT QCA9984 running 6.0.8 with FW ver 10.4-3.5.3-00053

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 58dc2189ba49..ace181403739 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5531,6 +5531,7 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_WOW_WAKEUP_HOST_EVENTID:
 	case WMI_10_4_PEER_RATECODE_LIST_EVENTID:
 	case WMI_10_4_WDS_PEER_EVENTID:
+	case WMI_10_4_DEBUG_FATAL_CONDITION_EVENTID:
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "received event id %d not implemented\n", id);
 		break;
-- 
2.7.4
