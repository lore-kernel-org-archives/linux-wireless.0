Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36839 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbeDXX5z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 19:57:55 -0400
Received: by mail-pg0-f67.google.com with SMTP id i6so12010156pgv.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2018 16:57:55 -0700 (PDT)
Date: Tue, 24 Apr 2018 16:57:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>,
        Rosen Penev <rosenp@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3] ath9k: dfs: Remove VLA usage
Message-ID: <20180424235752.GA37317@beast> (sfid-20180425_015817_606792_BCB40F23)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the quest to remove all stack VLA usage from the kernel[1], this
redefines FFT_NUM_SAMPLES as a #define instead of const int, which still
triggers gcc's VLA checking pass.

[1] https://lkml.org/lkml/2018/3/7/621

Co-developed-by: Andreas Christoforou <andreaschristofo@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3: replace FFT_NUM_SAMPLES as a #define (Joe)
---
 drivers/net/wireless/ath/ath9k/dfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 6fee9a464cce..e6e56a925121 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -40,8 +40,8 @@ static const int BIN_DELTA_MIN		= 1;
 static const int BIN_DELTA_MAX		= 10;
 
 /* we need at least 3 deltas / 4 samples for a reliable chirp detection */
-#define NUM_DIFFS 3
-static const int FFT_NUM_SAMPLES	= (NUM_DIFFS + 1);
+#define NUM_DIFFS	3
+#define FFT_NUM_SAMPLES	(NUM_DIFFS + 1)
 
 /* Threshold for difference of delta peaks */
 static const int MAX_DIFF		= 2;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
