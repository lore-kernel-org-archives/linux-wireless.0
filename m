Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3475BC10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 18:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08C3820848
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 18:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfDNSm1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 14:42:27 -0400
Received: from hera.iit.uni-miskolc.hu ([193.6.5.4]:42010 "EHLO
        hera.iit.uni-miskolc.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfDNSm0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 14:42:26 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Apr 2019 14:42:23 EDT
Received: from localhost (localhost [127.0.0.1])
        by hera.iit.uni-miskolc.hu (Postfix) with ESMTP id 33C7B126;
        Sun, 14 Apr 2019 20:36:57 +0200 (CEST)
X-Virus-Scanned: Kamavis at iit.uni-miskolc.hu
Received: from hera.iit.uni-miskolc.hu ([127.0.0.1])
        by localhost (hera.iit.uni-miskolc.hu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t49Q4vYJgFuZ; Sun, 14 Apr 2019 20:36:50 +0200 (CEST)
Received: from titan.hitronhub.home (unknown [IPv6:2a02:8109:a180:2158:226:9eff:fe30:2af8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: szucst@iit.uni-miskolc.hu)
        by hera.iit.uni-miskolc.hu (Postfix) with ESMTPSA id 0B506127;
        Sun, 14 Apr 2019 20:36:47 +0200 (CEST)
From:   =?UTF-8?q?Tam=C3=A1s=20Sz=C5=B1cs?= <tszucs@protonmail.ch>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:MARVELL MWIFIEX WIRELESS
        DRIVER), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     Cathy Luo <cluo@marvell.com>, Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Hemantkumar Suthar <shemant@marvell.com>,
        =?UTF-8?q?Tam=C3=A1s=20Sz=C5=B1cs?= <tszucs@protonmail.ch>
Subject: [PATCH 1/1] mwifiex: add support for SD8987 chipset
Date:   Sun, 14 Apr 2019 20:36:41 +0200
Message-Id: <20190414183641.7539-2-tszucs@protonmail.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190414183641.7539-1-tszucs@protonmail.ch>
References: <20190414183641.7539-1-tszucs@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch adds support for Marvell 88W8987 chipset with SDIO interface.
Register offsets and supported feature flags are updated. The corresponding
firmware image file shall be "mrvl/sd8987_uapsta.bin".

Signed-off-by: Tamás Szűcs <tszucs@protonmail.ch>
---
 drivers/net/wireless/marvell/mwifiex/Kconfig |  4 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c  |  5 ++
 drivers/net/wireless/marvell/mwifiex/sdio.h  | 69 ++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/Kconfig b/drivers/net/wireless/marvell/mwifiex/Kconfig
index 524fd565cb2a..572d187a99f4 100644
--- a/drivers/net/wireless/marvell/mwifiex/Kconfig
+++ b/drivers/net/wireless/marvell/mwifiex/Kconfig
@@ -9,13 +9,13 @@ config MWIFIEX
 	  mwifiex.
 
 config MWIFIEX_SDIO
-	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/SD8977/SD8997"
+	tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797/SD8887/SD8897/SD8977/SD8987/SD8997"
 	depends on MWIFIEX && MMC
 	select FW_LOADER
 	select WANT_DEV_COREDUMP
 	---help---
 	  This adds support for wireless adapters based on Marvell
-	  8786/8787/8797/8887/8897/8997 chipsets with SDIO interface.
+	  8786/8787/8797/8887/8897/8977/8987/8997 chipsets with SDIO interface.
 
 	  If you choose to build it as a module, it will be called
 	  mwifiex_sdio.
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a85648342d15..32bf2baeba9a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -491,6 +491,8 @@ static void mwifiex_sdio_coredump(struct device *dev)
 #define SDIO_DEVICE_ID_MARVELL_8801   (0x9139)
 /* Device ID for SD8977 */
 #define SDIO_DEVICE_ID_MARVELL_8977   (0x9145)
+/* Device ID for SD8987 */
+#define SDIO_DEVICE_ID_MARVELL_8987   (0x9149)
 /* Device ID for SD8997 */
 #define SDIO_DEVICE_ID_MARVELL_8997   (0x9141)
 
@@ -511,6 +513,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8801},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8977),
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8977},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8987),
+		.driver_data = (unsigned long)&mwifiex_sdio_sd8987},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8997),
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8997},
 	{},
@@ -2731,4 +2735,5 @@ MODULE_FIRMWARE(SD8797_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8897_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8977_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8987_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 912de2cde8d9..f672bdf52cc1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -37,6 +37,7 @@
 #define SD8887_DEFAULT_FW_NAME "mrvl/sd8887_uapsta.bin"
 #define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
 #define SD8977_DEFAULT_FW_NAME "mrvl/sd8977_uapsta.bin"
+#define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
 #define SD8997_DEFAULT_FW_NAME "mrvl/sd8997_uapsta.bin"
 
 #define BLOCK_MODE	1
@@ -526,6 +527,58 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8887 = {
 				 0x68, 0x69, 0x6a},
 };
 
+static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
+	.start_rd_port = 0,
+	.start_wr_port = 0,
+	.base_0_reg = 0xF8,
+	.base_1_reg = 0xF9,
+	.poll_reg = 0x5C,
+	.host_int_enable = UP_LD_HOST_INT_MASK | DN_LD_HOST_INT_MASK |
+			CMD_PORT_UPLD_INT_MASK | CMD_PORT_DNLD_INT_MASK,
+	.host_int_rsr_reg = 0x4,
+	.host_int_status_reg = 0x0C,
+	.host_int_mask_reg = 0x08,
+	.status_reg_0 = 0xE8,
+	.status_reg_1 = 0xE9,
+	.sdio_int_mask = 0xff,
+	.data_port_mask = 0xffffffff,
+	.io_port_0_reg = 0xE4,
+	.io_port_1_reg = 0xE5,
+	.io_port_2_reg = 0xE6,
+	.max_mp_regs = 196,
+	.rd_bitmap_l = 0x10,
+	.rd_bitmap_u = 0x11,
+	.rd_bitmap_1l = 0x12,
+	.rd_bitmap_1u = 0x13,
+	.wr_bitmap_l = 0x14,
+	.wr_bitmap_u = 0x15,
+	.wr_bitmap_1l = 0x16,
+	.wr_bitmap_1u = 0x17,
+	.rd_len_p0_l = 0x18,
+	.rd_len_p0_u = 0x19,
+	.card_misc_cfg_reg = 0xd8,
+	.card_cfg_2_1_reg = 0xd9,
+	.cmd_rd_len_0 = 0xc0,
+	.cmd_rd_len_1 = 0xc1,
+	.cmd_rd_len_2 = 0xc2,
+	.cmd_rd_len_3 = 0xc3,
+	.cmd_cfg_0 = 0xc4,
+	.cmd_cfg_1 = 0xc5,
+	.cmd_cfg_2 = 0xc6,
+	.cmd_cfg_3 = 0xc7,
+	.fw_dump_host_ready = 0xcc,
+	.fw_dump_ctrl = 0xf9,
+	.fw_dump_start = 0xf1,
+	.fw_dump_end = 0xf8,
+	.func1_dump_reg_start = 0x10,
+	.func1_dump_reg_end = 0x17,
+	.func1_scratch_reg = 0xE8,
+	.func1_spec_reg_num = 13,
+	.func1_spec_reg_table = {0x08, 0x58, 0x5C, 0x5D, 0x60,
+				 0x61, 0x62, 0x64, 0x65, 0x66,
+				 0x68, 0x69, 0x6a},
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8786 = {
 	.firmware = SD8786_DEFAULT_FW_NAME,
 	.reg = &mwifiex_reg_sd87xx,
@@ -633,6 +686,22 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.can_ext_scan = true,
 };
 
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8987 = {
+	.firmware = SD8987_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd8987,
+	.max_ports = 32,
+	.mp_agg_pkt_limit = 16,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_MAX,
+	.supports_sdio_new_mode = true,
+	.has_control_mask = false,
+	.can_dump_fw = true,
+	.fw_dump_enh = true,
+	.can_auto_tdls = true,
+	.can_ext_scan = true,
+};
+
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
 	.firmware = SD8801_DEFAULT_FW_NAME,
 	.reg = &mwifiex_reg_sd87xx,
-- 
2.11.0

