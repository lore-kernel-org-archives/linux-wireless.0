Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40183 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1HYPJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:48 -0400
Received: by wyg24 with SMTP id 24so1744420wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 08:09:47 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] wl12xx: add module_param to trigger BUG() on recovery
Date: Thu, 25 Aug 2011 18:10:59 +0300
Message-Id: <1314285060-5088-3-git-send-email-eliad@wizery.com> (sfid-20110825_172047_458585_E6EC8EE7)
In-Reply-To: <1314285060-5088-1-git-send-email-eliad@wizery.com>
References: <1314285060-5088-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Crashing on recovery is useful for debugging, as a JTAG
can be connected in order to investigate the current fw state.
(otherwise, a reconfiguration will occur)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bde8402..8324d90 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -362,6 +362,7 @@ static struct conf_drv_settings default_conf = {
 };
 
 static char *fwlog_param;
+static bool bug_on_recovery;
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues);
@@ -1213,6 +1214,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
 		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
 
+	BUG_ON(bug_on_recovery);
+
 	/*
 	 * Advance security sequence number to overcome potential progress
 	 * in the firmware during recovery. This doens't hurt if the network is
@@ -4776,6 +4779,9 @@ module_param_named(fwlog, fwlog_param, charp, 0);
 MODULE_PARM_DESC(keymap,
 		 "FW logger options: continuous, ondemand, dbgpins or disable");
 
+module_param(bug_on_recovery, bool, S_IRUSR | S_IWUSR);
+MODULE_PARM_DESC(bug_on_recovery, "BUG() on fw recovery");
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.7.6.401.g6a319

