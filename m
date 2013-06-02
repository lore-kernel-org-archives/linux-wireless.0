Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:44226
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751722Ab3FBNxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 09:53:09 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 2/3] cw1200:  Reference correct 'powerup' GPIO signal.
Date: Sun,  2 Jun 2013 09:53:02 -0400
Message-Id: <1370181183-11424-2-git-send-email-pizza@shaftnet.org> (sfid-20130602_155328_272187_F23D6BFE)
In-Reply-To: <1370181183-11424-1-git-send-email-pizza@shaftnet.org>
References: <1370181183-11424-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sdio.c | 2 +-
 drivers/net/wireless/cw1200/cw1200_spi.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index d5bdbeb..a725693 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -194,7 +194,7 @@ static int cw1200_sdio_off(const struct cw1200_platform_data_sdio *pdata)
 static int cw1200_sdio_on(const struct cw1200_platform_data_sdio *pdata)
 {
 	const struct resource *reset = pdata->reset;
-	const struct resource *powerup = pdata->reset;
+	const struct resource *powerup = pdata->powerup;
 
 	/* Ensure I/Os are pulled low */
 	if (reset) {
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index d77848a..c4ddee8 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -286,7 +286,7 @@ static int cw1200_spi_off(const struct cw1200_platform_data_spi *pdata)
 static int cw1200_spi_on(const struct cw1200_platform_data_spi *pdata)
 {
 	const struct resource *reset = pdata->reset;
-	const struct resource *powerup = pdata->reset;
+	const struct resource *powerup = pdata->powerup;
 
 	/* Ensure I/Os are pulled low */
 	if (reset) {
-- 
1.8.2.1

