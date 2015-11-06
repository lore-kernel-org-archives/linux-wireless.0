Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47677 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032934AbbKFJjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:44 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/26] staging: wilc1000: change parameter type of hif_init
Date: Fri, 6 Nov 2015 18:40:22 +0900
Message-ID: <1446802823-22598-26-git-send-email-glen.lee@atmel.com> (sfid-20151106_110756_053921_B81B0DBA)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes parameter type wilc_wlan_inp_t with struct wilc and
modify it's related code. Pass wilc to the functions as well.
wilc will be used in later patch.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 3 ++-
 drivers/staging/wilc1000/wilc_spi.c  | 3 ++-
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++++--
 drivers/staging/wilc1000/wilc_wlan.h | 4 ++--
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index a5307a7..8aacf55 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -11,6 +11,7 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 #include "linux_wlan_sdio.h"
+#include "wilc_wfi_netdevice.h"
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
@@ -550,7 +551,7 @@ static int sdio_sync(void)
 	return 1;
 }
 
-static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
+static int sdio_init(struct wilc *wilc, wilc_debug_func func)
 {
 	sdio_cmd52_t cmd;
 	int loop;
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 5a6bbfd..3741836 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -11,6 +11,7 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 #include "linux_wlan_spi.h"
+#include "wilc_wfi_netdevice.h"
 
 typedef struct {
 	wilc_debug_func dPrint;
@@ -945,7 +946,7 @@ static int wilc_spi_sync(void)
 	return 1;
 }
 
-static int wilc_spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
+static int wilc_spi_init(struct wilc *wilc, wilc_debug_func func)
 {
 	u32 reg;
 	u32 chipid;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 2ce5870..9d257b0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1655,6 +1655,10 @@ _fail_:
 int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 {
 	int ret = 0;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
@@ -1663,14 +1667,14 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	       sizeof(wilc_wlan_io_func_t));
 
 #ifdef WILC_SDIO
-	if (!hif_sdio.hif_init(inp, wilc_debug)) {
+	if (!hif_sdio.hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
 	}
 	memcpy((void *)&g_wlan.hif_func, &hif_sdio,
 	       sizeof(struct wilc_hif_func));
 #else
-	if (!hif_spi.hif_init(inp, wilc_debug)) {
+	if (!hif_spi.hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
 	}
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index ff4872f..64fd019 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -235,9 +235,9 @@ struct rxq_entry_t {
  *      Host IF Structure
  *
  ********************************************/
-
+struct wilc;
 struct wilc_hif_func {
-	int (*hif_init)(wilc_wlan_inp_t *, wilc_debug_func);
+	int (*hif_init)(struct wilc *, wilc_debug_func);
 	int (*hif_deinit)(void *);
 	int (*hif_read_reg)(u32, u32 *);
 	int (*hif_write_reg)(u32, u32);
-- 
1.9.1

