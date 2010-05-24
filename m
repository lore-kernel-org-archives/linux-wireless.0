Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:26038 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0EXIS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:18:59 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 5/6] wl1271: Use proper rates for PSM entry/exit null-funcs for 5GHz
Date: Mon, 24 May 2010 11:18:19 +0300
Message-Id: <1274689100-14785-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

A fixed 1 mbps rate was used for the PSM entry/exit null-func frames. Fix this
by using the basic rates instead.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 5a3ff93..d477929 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -511,7 +511,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send)
 	ps_params->send_null_data = send;
 	ps_params->retries = 5;
 	ps_params->hang_over_period = 1;
-	ps_params->null_data_rate = cpu_to_le32(1); /* 1 Mbps */
+	ps_params->null_data_rate = cpu_to_le32(wl->basic_rate_set);
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params), 0);
-- 
1.6.3.3

