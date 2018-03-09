Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33739 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbeCINYQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 08:24:16 -0500
From: Andreas Christoforou <andreaschristofo@gmail.com>
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com,
        Andreas Christoforou <andreaschristofo@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: net: wireless: ath: ath9k: dfs: remove VLA usage
Date: Fri,  9 Mar 2018 15:23:53 +0200
Message-Id: <1520601833-4952-1-git-send-email-andreaschristofo@gmail.com> (sfid-20180309_142435_996203_EA57E825)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel would like to have all stack VLA usage removed.

This is the correct patch.

Signed-off-by: Andreas Christoforou <andreaschristofo@gmail.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 6fee9a4..eeb77f2 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -101,7 +101,7 @@ static bool ath9k_check_chirping(struct ath_softc *sc, u8 *data,
 				 int datalen, bool is_ctl, bool is_ext)
 {
 	int i;
-	int max_bin[FFT_NUM_SAMPLES];
+	int max_bin[NUM_DIFFS + 1];
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int prev_delta;
-- 
2.7.4
