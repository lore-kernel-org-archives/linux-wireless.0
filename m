Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43685 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab2EJJQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:59 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so250127wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:58 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 67/78] wlcore: print the interrupt status when recovery is triggered
Date: Thu, 10 May 2012 12:14:12 +0300
Message-Id: <1336641263-5761-68-git-send-email-arik@wizery.com> (sfid-20120510_111711_095664_7A639654)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

In some cases it may be useful for debugging to check what is the
status of the interrupt register when a hardware recovery happens.
Print the contents of REG_INTERRUPT_NO_CLEAR (aka. HINT_STS_RAW) when
recovery starts.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1d9c11c..ebbedbf 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -836,9 +836,11 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	/* change partitions momentarily so we can read the FW pc */
 	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
-	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
+	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x "
+		    "hint_sts: 0x%08x",
 		    wl->chip.fw_ver_str,
-		    wlcore_read_reg(wl, REG_PC_ON_RECOVERY));
+		    wlcore_read_reg(wl, REG_PC_ON_RECOVERY),
+		    wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR));
 	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	BUG_ON(bug_on_recovery &&
-- 
1.7.9.5

