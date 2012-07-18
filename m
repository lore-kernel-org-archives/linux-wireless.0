Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:50750 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab2GRMN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:57 -0400
Received: by lbok6 with SMTP id k6so2322104lbo.4
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:55 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 09/14] wl18xx: disable calibrator based fem detect
Date: Wed, 18 Jul 2012 15:13:28 +0300
Message-Id: <1342613613-917-10-git-send-email-coelho@ti.com> (sfid-20120718_141413_380732_8F20F53D)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

bip calibration is not required in wl18xx. Therefore we
disable also auto fem (using calibrator fem detect) mode.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index fb284de..2b9398c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1148,6 +1148,12 @@ static int wl18xx_plt_init(struct wl1271 *wl)
 {
 	int ret;
 
+	/* calibrator based auto/fem detect not supported for 18xx */
+	if (wl->plt_mode == PLT_FEM_DETECT) {
+		wl1271_error("wl18xx_plt_init: PLT FEM_DETECT not supported");
+		return -EINVAL;
+	}
+
 	ret = wlcore_write32(wl, WL18XX_SCR_PAD8, WL18XX_SCR_PAD8_PLT);
 	if (ret < 0)
 		return ret;
-- 
1.7.10.4

