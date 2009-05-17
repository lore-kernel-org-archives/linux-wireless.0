Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:19955 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZEQXCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:02:44 -0400
Received: by ey-out-2122.google.com with SMTP id 9so920593eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:02:46 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 2/5] p54spi: cosmetic fixes: use even byte count in SPI write; drop unused interrupt status read
Date: Mon, 18 May 2009 03:02:32 +0400
Message-Id: <1242601355-3178-3-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
References: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
 <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
 <1242601355-3178-2-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When SPI write of odd length is requested, p54spi_write splits it
into two parts: one for all data, except the last byte, and one
for last byte and padding byte. Unfortunately, the length of
first part is not amended. It works because all meaningful bytes
have proper value and the last byte of odd length SPI write
transaction is ignored.

p54spi_work has dummy HOST_INTERRUPTS register read at the end.
Drop it, as its result is not used and it has no side effects.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index ff92bc3..3991977 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -82,7 +82,7 @@ static void p54spi_spi_write(struct p54s_priv *priv, u8 address,
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].tx_buf = buf;
-	t[1].len = len;
+	t[1].len = len & ~1;
 	spi_message_add_tail(&t[1], &m);
 
 	if (len % 2) {
@@ -527,11 +527,6 @@ static void p54spi_work(struct work_struct *work)
 	}
 
 	ret = p54spi_wq_tx(priv);
-	if (ret < 0)
-		goto out;
-
-	ints = p54spi_read32(priv, SPI_ADRS_HOST_INTERRUPTS);
-
 out:
 	mutex_unlock(&priv->mutex);
 }
-- 
1.6.0.6

