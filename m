Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34675 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbbALTmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 14:42:08 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/8] ath10k:  add wmi-id to htc credits debugging.
Date: Mon, 12 Jan 2015 11:41:43 -0800
Message-Id: <1421091709-19891-2-git-send-email-greearb@candelatech.com> (sfid-20150112_204238_106594_33F56034)
In-Reply-To: <1421091709-19891-1-git-send-email-greearb@candelatech.com>
References: <1421091709-19891-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This helps when trying to figure out exactly which commands
are consuming credits when trying to debug wmi credit hangs.
---
 drivers/net/wireless/ath/ath10k/htc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index d56e7f6..16b939a 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -137,9 +137,18 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 			goto err_pull;
 		}
 		ep->tx_credits -= credits;
-		ath10k_dbg(ar, ATH10K_DBG_HTC,
-			   "htc ep %d consumed %d credits (total %d)\n",
-			   eid, credits, ep->tx_credits);
+		if (eid == ar->wmi.eid) {
+			struct wmi_cmd_hdr* hdr;
+			hdr = (struct wmi_cmd_hdr*)(skb->data + sizeof(struct ath10k_htc_hdr));
+			ath10k_dbg(ar, ATH10K_DBG_HTC,
+				   "htc ep %d consumed %d credits (total %d, wmi-cmd 0x%x)\n",
+				   eid, credits, ep->tx_credits, __le32_to_cpu(hdr->cmd_id));
+		}
+		else {
+			ath10k_dbg(ar, ATH10K_DBG_HTC,
+				   "htc ep %d consumed %d credits (total %d)\n",
+				   eid, credits, ep->tx_credits);
+		}
 		spin_unlock_bh(&htc->tx_lock);
 	}
 
-- 
1.7.11.7

