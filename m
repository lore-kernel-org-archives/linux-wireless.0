Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36166 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933760AbZJMJuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:03 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 21/22] wl1271: make sure PS is disabled in PLT
Date: Tue, 13 Oct 2009 12:47:58 +0300
Message-Id: <1255427279-1224-22-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We cannot be in PS mode when running PLT tests, so we need to make sure we're
in active mode.  Also, we need to clear up the rx_counter when we stop PLT,
otherwise it could cause problems when entering PLT again.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index dfa08a1..7b8d279 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -774,6 +774,11 @@ int wl1271_plt_start(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_irq_disable;
 
+	/* Make sure power saving is disabled */
+	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+	if (ret < 0)
+		goto out_irq_disable;
+
 	goto out;
 
 out_irq_disable:
@@ -807,6 +812,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	wl1271_power_off(wl);
 
 	wl->state = WL1271_STATE_OFF;
+	wl->rx_counter = 0;
 
 out:
 	mutex_unlock(&wl->mutex);
-- 
1.5.6.5

