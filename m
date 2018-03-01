Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34134 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965286AbeCAAxd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 19:53:33 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Clear rx status enc_flags
Date: Wed, 28 Feb 2018 16:53:27 -0800
Message-Id: <1519865607-3602-1-git-send-email-greearb@candelatech.com> (sfid-20180301_015337_221374_426F7745)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, rx rate encodings are wrong as SGI flag may be set
when it should not be.  Maybe other issues as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 83eb7b2..8446dfc 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -901,6 +901,7 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		status->rate_idx = 0;
 		status->nss = 0;
 		status->encoding = RX_ENC_LEGACY;
+		status->enc_flags = 0;
 		status->bw = RATE_INFO_BW_20;
 		status->flag &= ~RX_FLAG_MACTIME_END;
 		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
-- 
2.4.11
