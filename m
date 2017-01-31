Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34617 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdAaKsu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 05:48:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id c85so83070622wmi.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2017 02:48:50 -0800 (PST)
From: Iain Hunter <drhunter95@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@aurora.org, Iain Hunter <i-hunter1@ti.com>
Subject: [PATCH] wlcore: disable multicast filter in AP mode
Date: Tue, 31 Jan 2017 10:48:40 +0000
Message-Id: <20170131104840.10366-1-i-hunter1@ti.com> (sfid-20170131_114923_668801_2B366CE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable AP support for allmulticast for MDNS It can be enabled by bringing

up the interface with ip command with argument allmulticast on  
Signed-off-by: Iain Hunter <i-hunter1@ti.com>
---
PATCH v2: resumbitting to handle error return value
 drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3241e9eba73..4fabbb486e7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3281,6 +3281,21 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
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
+ 			if (*total & FIF_ALLMULTI) {
+				ret = wl1271_acx_group_address_tbl(wl, wlvif,
+								   false,
+								   NULL, 0);
+			    if (ret < 0)
+				   goto out_sleep;
+                }
+           }
 	}
 
 	/*
-- 
2.11.0
