Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:52720 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3KVNaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:30:21 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so518483eaj.29
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:30:20 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: fix Tx status clearing
Date: Fri, 22 Nov 2013 14:26:59 +0100
Message-Id: <1385126819-15311-4-git-send-email-michal.kazior@tieto.com> (sfid-20131122_143048_969165_9923CBB4)
In-Reply-To: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Too much of tx info was being cleared. This caused
issues in some setups.

Reported-By: Matti Laakso <malaakso@elisanet.fi>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index d476b2c..2282980 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -75,7 +75,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	ath10k_report_offchan_tx(htt->ar, msdu);
 
 	info = IEEE80211_SKB_CB(msdu);
-	memset(info, 0, sizeof(*info));
+	memset(&info->status, 0, sizeof(info->status));
 
 	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
-- 
1.8.4.rc3

