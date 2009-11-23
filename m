Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41192 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119AbZKWVXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:10 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] wl1271: Remove REF_CLK hack
Date: Mon, 23 Nov 2009 23:22:19 +0200
Message-Id: <1259011339-28149-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This hack was totally wrong and was "needed" because of a problem in the way
we were sending the GENERAL_PARMS command to the firmware.  Now that that
problem has been fixed, this hack can be removed.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 64d0526..b62c00f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -251,14 +251,7 @@ static struct conf_drv_settings default_conf = {
 		},
 		.sr_enable                   = 1,
 		.genparam                    = {
-			/*
-			 * FIXME: The correct value CONF_REF_CLK_38_4_E
-			 *        causes the firmware to crash on boot.
-			 *        The value 5 apparently is an
-			 *        unnoficial XTAL configuration of the
-			 *        same frequency, which appears to work.
-			 */
-			.ref_clk             = 5,
+			.ref_clk             = CONF_REF_CLK_38_4_E,
 			.settling_time       = 5,
 			.clk_valid_on_wakeup = 0,
 			.dc2dcmode           = 0,
-- 
1.6.3.3

