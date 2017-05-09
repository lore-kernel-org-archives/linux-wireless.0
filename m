Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:62377 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752006AbdEIH2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 03:28:07 -0400
Subject: [PATCH 2/3] ath9k: Replace four seq_printf() calls by seq_putc()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <03575993-754d-924c-9736-2a8d19e98fa5@users.sourceforge.net>
Message-ID: <1498ba8a-8776-6380-f791-669f4440cc12@users.sourceforge.net> (sfid-20170509_092919_126369_B488D252)
Date: Tue, 9 May 2017 09:28:00 +0200
MIME-Version: 1.0
In-Reply-To: <03575993-754d-924c-9736-2a8d19e98fa5@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 8 May 2017 22:04:47 +0200

Four single characters (line breaks) should be put into a sequence.
Thus use the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ath/ath9k/debug.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 981b38a1e352..0d215598193c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -421,7 +421,7 @@ static int read_file_dma(struct seq_file *file, void *data)
 
 	for (i = 0; i < ATH9K_NUM_DMA_DEBUG_REGS; i++) {
 		if (i % 4 == 0)
-			seq_puts(file, "\n");
+			seq_putc(file, '\n');
 
 		val[i] = REG_READ_D(ah, AR_DMADBG_0 + (i * sizeof(u32)));
 		seq_printf(file, "%d: %08x ", i, val[i]);
@@ -702,8 +702,7 @@ static int read_file_misc(struct seq_file *file, void *data)
 	if (rxfilter & ATH9K_RX_FILTER_CONTROL_WRAPPER)
 		seq_puts(file, " CONTROL_WRAPPER");
 
-	seq_puts(file, "\n");
-
+	seq_putc(file, '\n');
 	reg = sc->sc_ah->imask;
 
 	seq_printf(file, "INTERRUPT-MASK: 0x%x", reg);
@@ -723,8 +722,7 @@ static int read_file_misc(struct seq_file *file, void *data)
 	if (reg & ATH9K_INT_BB_WATCHDOG)
 		seq_puts(file, " BB_WATCHDOG");
 
-	seq_puts(file, "\n");
-
+	seq_putc(file, '\n');
 	i = 0;
 	ath_for_each_chanctx(sc, ctx) {
 		if (list_empty(&ctx->vifs))
@@ -981,7 +979,7 @@ static int read_file_dump_nfcal(struct seq_file *file, void *data)
 		seq_printf(file, " %d\t %d\t %d\t\t", i, h[i].privNF, nread);
 		for (j = 0; j < nread; j++)
 			seq_printf(file, " %d", h[i].nfCalBuffer[j]);
-		seq_puts(file, "\n");
+		seq_putc(file, '\n');
 	}
 
 	return 0;
-- 
2.12.2
