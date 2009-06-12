Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39091 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZFLLQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:58 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 22/33] wl12xx: enable ELP mode
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:39 +0300
Message-ID: <20090612111639.8877.31334.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

ELP mode is working now, let's enable it so that the firmware can sleep
and reduce power consumption.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/ps.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index fe5e2d1..f28f194 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -85,11 +85,7 @@ static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
 	if (enable) {
 		wl12xx_debug(DEBUG_PSM, "sleep auth psm/elp");
 
-		/*
-		 * FIXME: we should PSM_ELP, but because of firmware wakeup
-		 * problems let's use only PSM_PS
-		 */
-		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_PS);
+		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_ELP);
 		if (ret < 0)
 			return ret;
 

