Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48166 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbbG1Itu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:49:50 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/21] staging: wilc1000: remove unnecessary inner braces
Date: Tue, 28 Jul 2015 17:47:35 +0900
Message-ID: <1438073261-28315-17-git-send-email-tony.cho@atmel.com> (sfid-20150728_110715_677777_E234B76C)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary inner braces.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 296203a..50be2a1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -686,23 +686,21 @@ static int sdio_read_size(uint32_t *size)
 	/**
 	 *      Read DMA count in words
 	 **/
-	{
-		cmd.read_write = 0;
-		cmd.function = 0;
-		cmd.raw = 0;
-		cmd.address = 0xf2;
-		cmd.data = 0;
-		g_sdio.sdio_cmd52(&cmd);
-		tmp = cmd.data;
+	cmd.read_write = 0;
+	cmd.function = 0;
+	cmd.raw = 0;
+	cmd.address = 0xf2;
+	cmd.data = 0;
+	g_sdio.sdio_cmd52(&cmd);
+	tmp = cmd.data;
 
-		/* cmd.read_write = 0; */
-		/* cmd.function = 0; */
-		/* cmd.raw = 0; */
-		cmd.address = 0xf3;
-		cmd.data = 0;
-		g_sdio.sdio_cmd52(&cmd);
-		tmp |= (cmd.data << 8);
-	}
+	/* cmd.read_write = 0; */
+	/* cmd.function = 0; */
+	/* cmd.raw = 0; */
+	cmd.address = 0xf3;
+	cmd.data = 0;
+	g_sdio.sdio_cmd52(&cmd);
+	tmp |= (cmd.data << 8);
 
 	*size = tmp;
 	return 1;
-- 
1.9.1

