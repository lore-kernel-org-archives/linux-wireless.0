Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59087 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab2I2Sg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:36:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] ssb: add attribute to indicate a parallel flash is available
Date: Sat, 29 Sep 2012 20:36:18 +0200
Message-Id: <1348943778-23079-3-git-send-email-hauke@hauke-m.de> (sfid-20120929_203631_767526_062E726B)
In-Reply-To: <1348943778-23079-1-git-send-email-hauke@hauke-m.de>
References: <1348943778-23079-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_mipscore.c       |    2 ++
 include/linux/ssb/ssb_driver_mips.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index dcad2c4..b918ba9 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -192,6 +192,7 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 
 	/* When there is no chipcommon on the bus there is 4MB flash */
 	if (!bus->chipco.dev) {
+		mcore->pflash.present = true;
 		mcore->pflash.buswidth = 2;
 		mcore->pflash.window = SSB_FLASH1;
 		mcore->pflash.window_size = SSB_FLASH1_SZ;
@@ -206,6 +207,7 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 		break;
 	case SSB_CHIPCO_FLASHT_PARA:
 		pr_debug("Found parallel flash\n");
+		mcore->pflash.present = true;
 		mcore->pflash.window = SSB_FLASH2;
 		mcore->pflash.window_size = SSB_FLASH2_SZ;
 		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
diff --git a/include/linux/ssb/ssb_driver_mips.h b/include/linux/ssb/ssb_driver_mips.h
index 5d057db..07a9c7a 100644
--- a/include/linux/ssb/ssb_driver_mips.h
+++ b/include/linux/ssb/ssb_driver_mips.h
@@ -14,6 +14,7 @@ struct ssb_serial_port {
 };
 
 struct ssb_pflash {
+	bool present;
 	u8 buswidth;
 	u32 window;
 	u32 window_size;
-- 
1.7.9.5

