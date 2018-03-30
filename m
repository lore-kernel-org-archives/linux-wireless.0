Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.154]:21793 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752431AbeC3S6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 14:58:37 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 98F54400CA1C3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2018 13:34:03 -0500 (CDT)
Date: Fri, 30 Mar 2018 13:34:01 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ath9k: dfs: remove accidental use of stack VLA
Message-ID: <20180330183401.GA16758@embeddedgus> (sfid-20180330_205841_369934_438630D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to enabling -Wvla, remove accidental use of stack VLA.

This avoids an accidental stack VLA (since the compiler thinks
the value of FFT_NUM_SAMPLES can change, even when marked
"const"). This just replaces it with a #define.

Also, fixed as part of the directive to remove all VLAs from
the kernel: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 6fee9a4..c8844f5 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -41,7 +41,7 @@ static const int BIN_DELTA_MAX		= 10;
 
 /* we need at least 3 deltas / 4 samples for a reliable chirp detection */
 #define NUM_DIFFS 3
-static const int FFT_NUM_SAMPLES	= (NUM_DIFFS + 1);
+#define FFT_NUM_SAMPLES		(NUM_DIFFS + 1)
 
 /* Threshold for difference of delta peaks */
 static const int MAX_DIFF		= 2;
@@ -114,7 +114,7 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
 
 		ath_dbg(common, DFS, "HT40: datalen=%d, num_fft_packets=%d\n",
 			datalen, num_fft_packets);
-		if (num_fft_packets < (FFT_NUM_SAMPLES)) {
+		if (num_fft_packets < FFT_NUM_SAMPLES) {
 			ath_dbg(common, DFS, "not enough packets for chirp\n");
 			return false;
 		}
@@ -136,7 +136,7 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
 			return false;
 		ath_dbg(common, DFS, "HT20: datalen=%d, num_fft_packets=%d\n",
 			datalen, num_fft_packets);
-		if (num_fft_packets < (FFT_NUM_SAMPLES)) {
+		if (num_fft_packets < FFT_NUM_SAMPLES) {
 			ath_dbg(common, DFS, "not enough packets for chirp\n");
 			return false;
 		}
-- 
2.7.4
