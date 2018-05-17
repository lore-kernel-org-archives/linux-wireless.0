Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42782 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752014AbeEQSuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 14:50:44 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 5/5] wlcore: sdio: Warn about runtime PM suspend errors
Date: Thu, 17 May 2018 11:50:29 -0700
Message-Id: <20180517185029.71716-6-tony@atomide.com> (sfid-20180517_205056_572403_0B85D771)
In-Reply-To: <20180517185029.71716-1-tony@atomide.com>
References: <20180517185029.71716-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We may get -EBUSY from runtime PM and that most likely means some
earlier wlcore command did not complete yet and further calls may
fail. Let's add a warning to make it easier to track down and fix
such issues in wlcore code.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -188,6 +188,13 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 		return error;
 	}
 
+	if (error == -EBUSY) {
+		dev_warn(&card->dev,
+			 "%s: wlcore write did not yet complete?\n",
+			__func__);
+		dump_stack();
+	}
+
 	return 0;
 }
 
-- 
2.17.0
