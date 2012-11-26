Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2KZQGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:10 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2233462wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:10 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/11] wlcore: mask out CCK rates when starting GO
Date: Mon, 26 Nov 2012 18:05:46 +0200
Message-Id: <1353945950-3899-8-git-send-email-arik@wizery.com> (sfid-20121126_170616_238612_3318BEAE)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

mask out CCK rates from the AP's local rates
when the interace is p2p interface (GO).

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 65f071d..fc508ee 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -591,6 +591,8 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 
 	supported_rates = CONF_TX_ENABLED_RATES | CONF_TX_MCS_RATES |
 		wlcore_hw_ap_get_mimo_wide_rate_mask(wl, wlvif);
+	if (wlvif->p2p)
+		supported_rates &= ~CONF_TX_CCK_RATES;
 
 	wl1271_debug(DEBUG_CMD, "cmd role start ap with supported_rates 0x%08x",
 		     supported_rates);
-- 
1.7.9.5

