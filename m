Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34436 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750863AbdA3OvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 09:51:12 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so77645712wmi.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 06:49:46 -0800 (PST)
From: Iain Hunter <drhunter95@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@aurora.org, Iain Hunter <i-hunter1@ti.com>
Subject: [PATCH] wlcore: disable multicast filter in AP mode
Date: Mon, 30 Jan 2017 14:49:36 +0000
Message-Id: <20170130144936.6699-1-i-hunter1@ti.com> (sfid-20170130_155149_697635_D75A48D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable AP support allmulticast for MDNS. It can be enabled by bringing up 

the interface with ip command with the argument allmulticast on

Signed-off-by: Iain Hunter <i-hunter1@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3241e9eba73..1ab0561ab13 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3281,6 +3281,20 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 		}
+
+        /*
+         * If interface in AP mode and created with allmulticast then disable
+         * the firmware filters so that all multicast packets are passed
+         * This is mandatory for MDNS based discovery protocols 
+         */
+ 		if (wlvif->bss_type == BSS_TYPE_AP_BSS) {
+ 			if (*total & FIF_ALLMULTI)
+				ret = wl1271_acx_group_address_tbl(wl, wlvif,
+								   false,
+								   NULL, 0);
+              
+                }
+
 	}
 
 	/*
-- 
2.11.0
