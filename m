Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:56022 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753577Ab1HVUUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 16:20:03 -0400
Received: by mail-bw0-f51.google.com with SMTP id r19so4071000bka.38
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 13:20:01 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ido@wizery.com
Subject: [PATCH RESEND 3.1 2/2] wl12xx: Fix validation of pm_runtime_get_sync return value
Date: Mon, 22 Aug 2011 23:19:49 +0300
Message-Id: <1314044389-30649-3-git-send-email-coelho@ti.com> (sfid-20110822_222010_121108_4203F214)
In-Reply-To: <1314044389-30649-1-git-send-email-coelho@ti.com>
References: <1314044389-30649-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

wl1271_sdio_power_on checks if the return value of pm_runtime_get_sync
is non-zero, and if so bails out.
However, pm_runtime_get_sync can return a positive number which does not
suggest an error has occurred. This is problematic for two reasons:

1. The function will needlessly bail out without decrementing back the
   runtime PM reference counter.
2. wl1271_power_on only checks if wl1271_power_on return value is
   negative. This means that wl1271_power_on will continue even if
   wl1271_sdio_power_on bailed out. As a result, sdio transactions will
   be initiated without properly enabling the sdio function and claiming
   the host. This could even lead to a kernel panic.

Fix this by only checking that the return value of pm_runtime_get_sync
is non-negative.

Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 5cf18c2..fb1fd5a 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -164,7 +164,7 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 	/* If enabled, tell runtime PM not to power off the card */
 	if (pm_runtime_enabled(&func->dev)) {
 		ret = pm_runtime_get_sync(&func->dev);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	} else {
 		/* Runtime PM is disabled: power up the card manually */
-- 
1.7.1

