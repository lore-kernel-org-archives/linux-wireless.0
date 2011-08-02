Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56162 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1HBHYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 03:24:30 -0400
Received: by wyg8 with SMTP id 8so2114464wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 00:24:29 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 2/2] wl12xx: Fix validation of pm_runtime_get_sync return value
Date: Tue,  2 Aug 2011 10:24:18 +0300
Message-Id: <1312269858-30434-2-git-send-email-ido@wizery.com> (sfid-20110802_092434_898436_31FC6CE6)
In-Reply-To: <1312269858-30434-1-git-send-email-ido@wizery.com>
References: <1312269858-30434-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
1.7.4.1

