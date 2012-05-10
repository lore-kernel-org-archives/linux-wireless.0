Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab2EJJRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:03 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:03 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 69/78] wlcore: use proper values for supported local rates
Date: Thu, 10 May 2012 12:14:14 +0300
Message-Id: <1336641263-5761-70-git-send-email-arik@wizery.com> (sfid-20120510_111718_726614_D4EF62B9)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We were setting all the rates bits when starting the AP role.  Instead
of doing this, we should set only the rates we really support
(eg. MIMO rates or wide-channel rates).  This commit changes that so
that we always use the default rates (basic rates + MCS0-7) and add
the values returned by the ap_get_mimo_wide_rate_mask operation.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 5c47560..5b14446 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -36,6 +36,7 @@
 #include "cmd.h"
 #include "event.h"
 #include "tx.h"
+#include "hw_ops.h"
 
 #define WL1271_CMD_FAST_POLL_COUNT       50
 
@@ -500,6 +501,7 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	struct wl12xx_cmd_role_start *cmd;
 	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+	u32 supported_rates;
 	int ret;
 
 	wl1271_debug(DEBUG_CMD, "cmd role start ap %d", wlvif->role_id);
@@ -550,7 +552,13 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		memcpy(cmd->ap.ssid, bss_conf->ssid, bss_conf->ssid_len);
 	}
 
-	cmd->ap.local_rates = cpu_to_le32(0xffffffff);
+	supported_rates = CONF_TX_AP_ENABLED_RATES | CONF_TX_MCS_RATES |
+		wlcore_hw_ap_get_mimo_wide_rate_mask(wl, wlvif);
+
+	wl1271_debug(DEBUG_CMD, "cmd role start ap with supported_rates 0x%08x",
+		     supported_rates);
+
+	cmd->ap.local_rates = cpu_to_le32(supported_rates);
 
 	switch (wlvif->band) {
 	case IEEE80211_BAND_2GHZ:
-- 
1.7.9.5

