Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58540 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaCXTX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 15:23:57 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 4/4 v2] ath10k:  invalid msdu-id logging
Date: Mon, 24 Mar 2014 12:20:44 -0700
Message-Id: <1395688844-24640-5-git-send-email-greearb@candelatech.com> (sfid-20140324_202359_391980_8FC3B112)
In-Reply-To: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
References: <1395688844-24640-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Make this message more obvious that it is a serious
problem (will cause tx flush issues, at least).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Add this to series, but ordering is not overly important.

 drivers/net/wireless/ath/ath10k/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 0541dd9..9be5974 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -58,7 +58,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
 
 	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
-		ath10k_warn("warning: msdu_id %d too big, ignoring\n",
+		ath10k_warn("error: msdu_id %d too big, ignoring\n",
 			    tx_done->msdu_id);
 		return;
 	}
-- 
1.7.11.7

