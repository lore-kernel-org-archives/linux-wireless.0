Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.219]:24828 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751805AbdKCVBy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 17:01:54 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 3F82C175C2
        for <linux-wireless@vger.kernel.org>; Fri,  3 Nov 2017 15:14:28 -0500 (CDT)
Date: Fri, 3 Nov 2017 15:14:25 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] ath9k: dfs: use swap macro in ath9k_check_chirping
Message-ID: <20171103201425.GA26452@embeddedor.com> (sfid-20171103_220157_808203_D974E98A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of the swap macro and remove unnecessary variable temp.
This makes the code easier to read and maintain.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 40a397f..6fee9a4 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -123,11 +123,9 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
 			fft = (struct ath9k_dfs_fft_40 *) (data + 2);
 			ath_dbg(common, DFS, "fixing datalen by 2\n");
 		}
-		if (IS_CHAN_HT40MINUS(ah->curchan)) {
-			int temp = is_ctl;
-			is_ctl = is_ext;
-			is_ext = temp;
-		}
+		if (IS_CHAN_HT40MINUS(ah->curchan))
+			swap(is_ctl, is_ext);
+
 		for (i = 0; i < FFT_NUM_SAMPLES; i++)
 			max_bin[i] = ath9k_get_max_index_ht40(fft + i, is_ctl,
 							      is_ext);
-- 
2.7.4
