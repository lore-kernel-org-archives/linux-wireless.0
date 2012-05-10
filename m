Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64514 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2EJCdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 22:33:15 -0400
Received: by yhmm54 with SMTP id m54so1006656yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 19:33:14 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: dmitry.tarnyagin@stericsson.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] cw1200: use round_up instead of open-coding it
Date: Wed,  9 May 2012 22:32:33 -0400
Message-Id: <1336617155-7455-1-git-send-email-me@bobcopeland.com> (sfid-20120510_043319_211698_C9D47D27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace a few instances of rounding (one of them buggy) with the
built-in kernel macro.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Hi Dmitry, these patches are compile-tested only, let me know if
there are any problems.

 drivers/staging/cw1200/bh.c  |    9 ++-------
 drivers/staging/cw1200/wsm.c |    6 +-----
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/cw1200/bh.c b/drivers/staging/cw1200/bh.c
index 427f3e2..edfb85d 100644
--- a/drivers/staging/cw1200/bh.c
+++ b/drivers/staging/cw1200/bh.c
@@ -400,9 +400,7 @@ rx:
 					priv->sbus_priv, read_len);
 #else /* CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES */
 			/* Platform's SDIO workaround */
-			alloc_len = read_len & ~(SDIO_BLOCK_SIZE - 1);
-			if (read_len & (SDIO_BLOCK_SIZE - 1))
-				alloc_len += SDIO_BLOCK_SIZE;
+			alloc_len = round_up(read_len, SDIO_BLOCK_SIZE);
 #endif /* CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES */
 
 			/* Check if not exceeding CW1200 capabilities */
@@ -537,10 +535,7 @@ tx:
 				* It is also supported by upper layer:
 				* there is always enough space at the
 				* end of the buffer. */
-				if (tx_len & (SDIO_BLOCK_SIZE - 1)) {
-					tx_len &= ~(SDIO_BLOCK_SIZE - 1);
-					tx_len += SDIO_BLOCK_SIZE;
-				}
+				tx_len = round_up(tx_len, SDIO_BLOCK_SIZE);
 #endif /* CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES */
 
 				/* Check if not exceeding CW1200
diff --git a/drivers/staging/cw1200/wsm.c b/drivers/staging/cw1200/wsm.c
index 3cf5370..b657568 100644
--- a/drivers/staging/cw1200/wsm.c
+++ b/drivers/staging/cw1200/wsm.c
@@ -1816,11 +1816,7 @@ static int wsm_buf_reserve(struct wsm_buf *buf, size_t extra_size)
 	size_t pos = buf->data - buf->begin;
 	size_t size = pos + extra_size;
 
-
-	if (size & (SDIO_BLOCK_SIZE - 1)) {
-		size &= SDIO_BLOCK_SIZE;
-		size += SDIO_BLOCK_SIZE;
-	}
+	size = round_up(size, SDIO_BLOCK_SIZE);
 
 	buf->begin = krealloc(buf->begin, size, GFP_KERNEL | GFP_DMA);
 	if (buf->begin) {
-- 
1.7.6

