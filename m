Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54979 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZJ2LUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 07:20:49 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juha_motorsportcom@luukku.com
Subject: [PATCH] wl1271: fix init loop timeout
Date: Thu, 29 Oct 2009 13:20:04 +0200
Message-Id: <1256815204-12046-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check after the loop which checks whether the initialization timed-out
was wrong.  If the initialization would succeed exactly in the 20000th time
(the value set for INIT_LOOP), the driver would bail out and claim that
initialization failed.

Reported-by: Juha Leppanen <juha_motorsportcom@luukku.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index ba4a2b4..8678bea 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -380,7 +380,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		}
 	}
 
-	if (loop >= INIT_LOOP) {
+	if (loop > INIT_LOOP) {
 		wl1271_error("timeout waiting for the hardware to "
 			     "complete initialization");
 		return -EIO;
-- 
1.5.6.5

