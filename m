Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60876 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab3KZOKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 09:10:44 -0500
Received: by mail-ea0-f172.google.com with SMTP id q10so3589251ead.31
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 06:10:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/3] ath10k: fix Tx status clearing
Date: Tue, 26 Nov 2013 14:57:40 +0100
Message-Id: <1385474260-22385-4-git-send-email-michal.kazior@tieto.com> (sfid-20131126_151050_991152_11E5D2F0)
In-Reply-To: <1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
 <1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Too much of tx info was being cleared. This caused
issues in some setups with tx frame status
reporting.

This should fix some cases of stations not being
able to associate to ath10k AP.

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

