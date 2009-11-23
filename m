Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41142 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbZKWVXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:02 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 1/8] wl1271: Decrease BET consecutive terminated beacons value to 10
Date: Mon, 23 Nov 2009 23:22:12 +0200
Message-Id: <1259011339-28149-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Decrease the consecutive terminated beacons value for BET from 100 to 10.
According to the vendor, 10 will give a more reliable connection and more
reliable detection of connection problems.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 00ddcc2..43fdd45 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -222,7 +222,7 @@ static struct conf_drv_settings default_conf = {
 			.snr_pkt_avg_weight  = 10
 		},
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
-		.bet_max_consecutive         = 100,
+		.bet_max_consecutive         = 10,
 		.psm_entry_retries           = 3
 	},
 	.init = {
-- 
1.6.3.3

