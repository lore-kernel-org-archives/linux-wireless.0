Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45081 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab0CKPpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 10:45:12 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so156999bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 07:45:11 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/4] wl1251: reduce eeprom read wait time
Date: Thu, 11 Mar 2010 17:45:07 +0200
Message-Id: <1268322307-16694-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4sec wait is way too pessimistic, TI driver uses 40ms here,
and testing shows that is ebough, so let's also use that.
While at it, add useful sounding comment from the TI driver.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_boot.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 28a8086..acb3341 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -496,7 +496,8 @@ int wl1251_boot(struct wl1251 *wl)
 	/* 2. start processing NVS file */
 	if (wl->use_eeprom) {
 		wl1251_reg_write32(wl, ACX_REG_EE_START, START_EEPROM_MGR);
-		msleep(4000);
+		/* Wait for EEPROM NVS burst read to complete */
+		msleep(40);
 		wl1251_reg_write32(wl, ACX_EEPROMLESS_IND_REG, USE_EEPROM);
 	} else {
 		ret = wl1251_boot_upload_nvs(wl);
-- 
1.6.3.3

