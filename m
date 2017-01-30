Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:36185 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752951AbdA3NDj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 08:03:39 -0500
Received: by mail-wj0-f196.google.com with SMTP id kq3so7675774wjc.3
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2017 05:03:38 -0800 (PST)
From: Iain Hunter <drhunter95@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Iain Hunter <i-hunter1@ti.com>
Subject: [PATCH] wlcore: let AP support allmulticast for MDNS. It can be enabled by bringing up the interface with ip command with the argument allmulticast on
Date: Mon, 30 Jan 2017 12:54:17 +0000
Message-Id: <20170130125417.6188-1-i-hunter1@ti.com> (sfid-20170130_140631_283039_AD197125)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let AP support allmulticast for MDNS.
It can be enabled by bringing up the interface with ip command with the argument allmulticast on

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
