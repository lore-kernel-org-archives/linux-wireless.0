Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60540 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbZLKNl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:56 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 26/31] wl1271: Change rates configured for templates
Date: Fri, 11 Dec 2009 15:41:05 +0200
Message-Id: <1260538870-32297-27-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Previously a "firmware chooses" value was used for the rates of all control
message templates set to the firmware. This resulted in a too high rate to be
chosen to transmit those messages. Change this by configuring a fixed low rate
for the templates.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d7b1bb3..7a73aaa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -78,7 +78,8 @@ static struct conf_drv_settings default_conf = {
 	.tx = {
 		.tx_energy_detection         = 0,
 		.rc_conf                     = {
-			.enabled_rates       = CONF_TX_RATE_MASK_UNSPECIFIED,
+			.enabled_rates       = CONF_HW_BIT_RATE_1MBPS |
+					       CONF_HW_BIT_RATE_2MBPS,
 			.short_retry_limit   = 10,
 			.long_retry_limit    = 10,
 			.aflags              = 0
-- 
1.6.3.3

