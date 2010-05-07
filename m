Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:17761 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0EGIjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 04:39:37 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 5/5] wl1271: Reduce PSM entry hang over period from 128 => 1 ms
Date: Fri,  7 May 2010 11:39:02 +0300
Message-Id: <1273221542-14283-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
References: <1273221542-14283-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently, we configure a 128ms hang over period for the PSM entry
(the firmware will remain active for 128ms after sending the null func for
PSM and getting an ack for it.) This is a huge power consumption issue, and
appears unnecessary. So, configure the value to 1 ms.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 62c11af..19393e2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -516,7 +516,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send)
 	ps_params->ps_mode = ps_mode;
 	ps_params->send_null_data = send;
 	ps_params->retries = 5;
-	ps_params->hang_over_period = 128;
+	ps_params->hang_over_period = 1;
 	ps_params->null_data_rate = cpu_to_le32(1); /* 1 Mbps */
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
-- 
1.6.3.3

