Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2EJJPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:44 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:43 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 34/78] wl18xx: read FW pc on recovery
Date: Thu, 10 May 2012 12:13:39 +0300
Message-Id: <1336641263-5761-35-git-send-email-arik@wizery.com> (sfid-20120510_112226_900346_63245D39)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define the FW pc in the 18xx register translation table. This specific
register is only valid in the boot partition, so change the momentarily
change partitions. This doesn't damage 12xx cards, where the FW pc is
accessible via boot partition as well.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/main.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5214334..82403e3 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -549,7 +549,7 @@ static const int wl18xx_rtable[REG_TABLE_LEN] = {
 	[REG_EVENT_MAILBOX_PTR]		= WL18XX_REG_EVENT_MAILBOX_PTR,
 	[REG_INTERRUPT_TRIG]		= WL18XX_REG_INTERRUPT_TRIG_H,
 	[REG_INTERRUPT_MASK]		= WL18XX_REG_INTERRUPT_MASK,
-	[REG_PC_ON_RECOVERY]		= 0, /* TODO: where is the PC? */
+	[REG_PC_ON_RECOVERY]		= WL18XX_SCR_PAD4,
 	[REG_CHIP_ID_B]			= WL18XX_REG_CHIP_ID_B,
 	[REG_CMD_MBOX_ADDRESS]		= WL18XX_CMD_MBOX_ADDRESS,
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c98958f..cbe94ed 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -872,9 +872,12 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	wl12xx_read_fwlog_panic(wl);
 
+	/* change partitions momentarily so we can read the FW pc */
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
 		    wl->chip.fw_ver_str,
 		    wlcore_read_reg(wl, REG_PC_ON_RECOVERY));
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	BUG_ON(bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
-- 
1.7.9.5

