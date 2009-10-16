Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbZJPFUi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 01:20:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/16] iwmc3200wifi: Improve rx debug
Date: Fri, 16 Oct 2009 13:18:50 +0800
Message-Id: <1255670340-22565-7-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-5-git-send-email-yi.zhu@intel.com>
 <1255670340-22565-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We display the correct DROP/RELEASE string for each rx packets, and when
it's dropped we also display the reason.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 813e1b3..a6b1811 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -423,7 +423,9 @@ static int iwm_ntf_rx_ticket(struct iwm_priv *iwm, u8 *buf,
 			if (IS_ERR(ticket_node))
 				return PTR_ERR(ticket_node);
 
-			IWM_DBG_RX(iwm, DBG, "TICKET RELEASE(%d)\n",
+			IWM_DBG_RX(iwm, DBG, "TICKET %s(%d)\n",
+				   ticket->action ==  IWM_RX_TICKET_RELEASE ?
+				   "RELEASE" : "DROP",
 				   ticket->id);
 			list_add_tail(&ticket_node->node, &iwm->rx_tickets);
 
@@ -1458,7 +1460,8 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 		}
 		break;
 	case IWM_RX_TICKET_DROP:
-		IWM_DBG_RX(iwm, DBG, "DROP packet\n");
+		IWM_DBG_RX(iwm, DBG, "DROP packet: 0x%x\n",
+			   le16_to_cpu(ticket_node->ticket->flags));
 		kfree_skb(packet->skb);
 		break;
 	default:
-- 
1.6.0.4

