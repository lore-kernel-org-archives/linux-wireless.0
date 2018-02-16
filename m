Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:44272 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754363AbeBPPMA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:00 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/12] staging: wilc1000: remove unnecessary comments to avoid line over 80 char issue
Date: Fri, 16 Feb 2018 20:41:38 +0530
Message-ID: <1518793909-15573-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161204_415872_124F0AA1)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue reported by checkpatch.pl script by
removing unnecessary comments.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index bb65b37..6ce9c94 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -405,7 +405,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.increment = 1;
 		cmd.count = 4;
 		cmd.buffer = (u8 *)&data;
-		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
+		cmd.block_size = g_sdio.block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
@@ -489,7 +489,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.count = nleft;
 		cmd.buffer = buf;
 
-		cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
+		cmd.block_size = block_size;
 
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
@@ -543,7 +543,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.count = 4;
 		cmd.buffer = (u8 *)data;
 
-		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
+		cmd.block_size = g_sdio.block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret) {
 			dev_err(&func->dev,
@@ -629,7 +629,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 		cmd.count = nleft;
 		cmd.buffer = buf;
 
-		cmd.block_size = block_size; /* johnny : prevent it from setting unexpected value */
+		cmd.block_size = block_size;
 
 		if (addr > 0) {
 			if (!sdio_set_func0_csa_address(wilc, addr))
-- 
2.7.4
