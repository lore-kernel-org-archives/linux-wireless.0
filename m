Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60777 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2KZQGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:03 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so3516168wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:01 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/11] wlcore: don't stop fwlog if dbgpins are used
Date: Mon, 26 Nov 2012 18:05:42 +0200
Message-Id: <1353945950-3899-4-git-send-email-arik@wizery.com> (sfid-20121126_170636_905581_0A310BB2)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Due to a bug, the fw asserts on fw log stop when dbg-pins are used.
Don't stop the fw log in this case.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 475d0cd..49ff7ee 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -805,11 +805,13 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 
 	/*
 	 * Make sure the chip is awake and the logger isn't active.
-	 * Do not send a stop fwlog command if the fw is hanged.
+	 * Do not send a stop fwlog command if the fw is hanged or if
+	 * dbgpins are used (due to some fw bug).
 	 */
 	if (wl1271_ps_elp_wakeup(wl))
 		goto out;
-	if (!wl->watchdog_recovery)
+	if (!wl->watchdog_recovery &&
+	    wl->conf.fwlog.output != WL12XX_FWLOG_OUTPUT_DBG_PINS)
 		wl12xx_cmd_stop_fwlog(wl);
 
 	/* Read the first memory block address */
-- 
1.7.9.5

