Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9016 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbbJEG1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/18] staging: wilc1000: remove unused functions
Date: Mon, 5 Oct 2015 15:25:52 +0900
Message-ID: <1444026353-29024-17-git-send-email-tony.cho@atmel.com> (sfid-20151005_082756_274614_8DFD9F56)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused functions.
 - drivers/staging/wilc1000/linux_mon.c : WILC_WFI_mon_setup
 - drivers/staging/wilc1000/wilc_sdio.o : sdio_set_func0_csa_address_byte0

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 26 --------------------------
 drivers/staging/wilc1000/wilc_sdio.c | 22 ----------------------
 2 files changed, 48 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a943b23..bde4095 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -311,32 +311,6 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
 };
 
 /**
- *  @brief      WILC_WFI_mon_setup
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	12 JUL 2012
- *  @version	1.0
- */
-static void WILC_WFI_mon_setup(struct net_device *dev)
-{
-
-	dev->netdev_ops = &wilc_wfi_netdev_ops;
-	PRINT_INFO(CORECONFIG_DBG, "In Ethernet setup function\n");
-	ether_setup(dev);
-	dev->priv_flags |= IFF_NO_QUEUE;
-	dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	eth_zero_addr(dev->dev_addr);
-
-	{
-		unsigned char mac_add[] = {0x00, 0x50, 0xc2, 0x5e, 0x10, 0x8f};
-		memcpy(dev->dev_addr, mac_add, ETH_ALEN);
-	}
-
-}
-
-/**
  *  @brief      WILC_WFI_init_mon_interface
  *  @details
  *  @param[in]
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 6e28ca0..300c571 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -75,28 +75,6 @@ _fail_:
 	return 0;
 }
 
-static int sdio_set_func0_csa_address_byte0(u32 adr)
-{
-	sdio_cmd52_t cmd;
-
-	/**
-	 *      Review: BIG ENDIAN
-	 **/
-	cmd.read_write = 1;
-	cmd.function = 0;
-	cmd.raw = 0;
-	cmd.address = 0x10c;
-	cmd.data = (u8)adr;
-	if (!g_sdio.sdio_cmd52(&cmd)) {
-		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed cmd52, set 0x10c data...\n");
-		goto _fail_;
-	}
-
-	return 1;
-_fail_:
-	return 0;
-}
-
 static int sdio_set_func0_block_size(u32 block_size)
 {
 	sdio_cmd52_t cmd;
-- 
1.9.1

