Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43296 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbZJMJto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:44 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 01/22] wl1271: Workaround for reference clock setting on boot.
Date: Tue, 13 Oct 2009 12:47:38 +0300
Message-Id: <1255427279-1224-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

If the 38.4MHz reference clock is configured to the firmware, it crashes
on boot. Configuring an experimental 38.4MHz in XTAL mode allows the
firmware to boot, and everything appears to work.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index e45af07..9abe062 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -196,7 +196,14 @@ static int wl1271_init_general_parms(struct wl1271 *wl)
 
 	gen_parms->id = TEST_CMD_INI_FILE_GENERAL_PARAM;
 
-	gen_parms->ref_clk = REF_CLK_38_4_E;
+	/*
+	 * FIXME: The firmware crashes on boot with REF_CLK_38_4_E as clock.
+	 *        according to TI engineers, ref clk 5 is an unofficial
+	 *        38.4 XTAL clock config, which seems to boot the device.
+	 *        Restore correct value once the real problem source is
+	 *        identified.
+	 */
+	gen_parms->ref_clk = 5; /* REF_CLK_38_4_E; */
 	/* FIXME: magic numbers */
 	gen_parms->settling_time = 5;
 	gen_parms->clk_valid_on_wakeup = 0;
-- 
1.5.6.5

