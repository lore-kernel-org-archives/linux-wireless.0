Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48072 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3IIJZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:04 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so987171wid.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:25:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/13] wlcore: read fw panic log only in host mode
Date: Mon,  9 Sep 2013 12:24:39 +0300
Message-Id: <1378718684-14430-8-git-send-email-eliad@wizery.com> (sfid-20130909_112513_869664_947B862A)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Barak Bercovitz <barak@wizery.com>

Reading FW panic log is only supported in host mode (SDIO)

Signed-off-by: Barak Bercovitz <barak@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 58800ab..8639ea9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -943,7 +943,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 		goto out_unlock;
 
 	if (!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags)) {
-		wl12xx_read_fwlog_panic(wl);
+		if (wl->conf.fwlog.output == WL12XX_FWLOG_OUTPUT_HOST)
+			wl12xx_read_fwlog_panic(wl);
 		wlcore_print_recovery(wl);
 	}
 
-- 
1.8.3.rc1.35.g9b79519

