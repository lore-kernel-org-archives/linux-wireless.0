Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20618 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbbKRGJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 01:09:03 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/16] staging: wilc1000: wilc_sdio_cmd53: pass struct wilc
Date: Wed, 18 Nov 2015 15:11:28 +0900
Message-ID: <1447827097-9436-8-git-send-email-glen.lee@atmel.com> (sfid-20151118_070906_909592_DFB8484C)
In-Reply-To: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
References: <1447827097-9436-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new function parameter struct wilc and use it instead of
global variable wilc_dev and pass wilc to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c |  4 ++--
 drivers/staging/wilc1000/linux_wlan_sdio.h |  2 +-
 drivers/staging/wilc1000/wilc_sdio.c       | 12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 6a38876..92633aa 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -61,9 +61,9 @@ int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd)
 }
 
 
-int wilc_sdio_cmd53(sdio_cmd53_t *cmd)
+int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
 {
-	struct sdio_func *func = container_of(wilc_dev->dev, struct sdio_func, dev);
+	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
 	int size, ret;
 
 	sdio_claim_host(func);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index d966bb9..8d276c6 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -2,7 +2,7 @@
 
 int wilc_sdio_init(void);
 int wilc_sdio_cmd52(struct wilc *wilc, sdio_cmd52_t *cmd);
-int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
+int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd);
 
 int wilc_sdio_enable_interrupt(struct wilc *);
 void wilc_sdio_disable_interrupt(struct wilc *);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 4d0ee69..a68a7a4 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -197,7 +197,7 @@ static int sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.buffer = (u8 *)&data;
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!wilc_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, write reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -260,7 +260,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block send...\n", addr);
 			goto _fail_;
 		}
@@ -281,7 +281,7 @@ static int sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes send...\n", addr);
 			goto _fail_;
 		}
@@ -324,7 +324,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 
 		cmd.block_size = g_sdio.block_size; /* johnny : prevent it from setting unexpected value */
 
-		if (!wilc_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53, read reg (%08x)...\n", addr);
 			goto _fail_;
 		}
@@ -391,7 +391,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], block read...\n", addr);
 			goto _fail_;
 		}
@@ -412,7 +412,7 @@ static int sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 			if (!sdio_set_func0_csa_address(wilc, addr))
 				goto _fail_;
 		}
-		if (!wilc_sdio_cmd53(&cmd)) {
+		if (!wilc_sdio_cmd53(wilc, &cmd)) {
 			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd53 [%x], bytes read...\n", addr);
 			goto _fail_;
 		}
-- 
1.9.1

