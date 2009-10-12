Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52664 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZJLMTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:19:11 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/16] wl1271: Enable ELP
Date: Mon, 12 Oct 2009 15:08:51 +0300
Message-Id: <1255349337-9776-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The new firmware has fixed a firmware crash problem related to ELP entry.
Enable ELP to conserve power.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_ps.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index 5580e53..fb821c9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -39,12 +39,7 @@ void wl1271_elp_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	/*
-	 * FIXME: below, by means of the "true", ELP has been disabled for now
-	 * to work around a firmware bug. To be enabled upon receiving a new
-	 * firmware version.
-	 */
-	if (true || wl->elp || !wl->psm)
+	if (wl->elp || !wl->psm)
 		goto out;
 
 	wl1271_debug(DEBUG_PSM, "chip to elp");
-- 
1.5.6.5

