Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52080 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab2KVTbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:31:51 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3325786eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:31:50 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/13] wlcore: update acx enum
Date: Thu, 22 Nov 2012 14:05:21 +0200
Message-Id: <1353585928-28666-7-git-send-email-eliad@wizery.com> (sfid-20121122_203221_880153_30625DD0)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update the acx enum to the new fw api.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/acx.c |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.h |    4 ----
 drivers/net/wireless/ti/wlcore/acx.h |   10 +++++++++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.c b/drivers/net/wireless/ti/wl18xx/acx.c
index 72840e2..adff9cd 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.c
+++ b/drivers/net/wireless/ti/wl18xx/acx.c
@@ -75,7 +75,7 @@ int wl18xx_acx_set_checksum_state(struct wl1271 *wl)
 
 	acx->checksum_state = CHECKSUM_OFFLOAD_ENABLED;
 
-	ret = wl1271_cmd_configure(wl, ACX_CHECKSUM_CONFIG, acx, sizeof(*acx));
+	ret = wl1271_cmd_configure(wl, ACX_CSUM_CONFIG, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("failed to set Tx checksum state: %d", ret);
 		goto out;
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index e2609a6..67733a1 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -25,10 +25,6 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/acx.h"
 
-enum {
-	ACX_CLEAR_STATISTICS		 = 0x0047,
-};
-
 /* numbers of bits the length field takes (add 1 for the actual number) */
 #define WL18XX_HOST_IF_LEN_SIZE_FIELD 15
 
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index d03215d..7833d17 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -1025,7 +1025,15 @@ enum {
 	ACX_CONFIG_HANGOVER              = 0x0042,
 	ACX_FEATURE_CFG                  = 0x0043,
 	ACX_PROTECTION_CFG               = 0x0044,
-	ACX_CHECKSUM_CONFIG              = 0x0045,
+
+	/* start of 18xx specific acxs */
+	ACX_NS_IPV6_FILTER               = 0x0050,
+	ACX_PEER_HT_OPERATION_MODE_CFG   = 0x0051,
+	ACX_CSUM_CONFIG                  = 0x0052,
+	ACX_SIM_CONFIG                   = 0x0053,
+	ACX_CLEAR_STATISTICS             = 0x0054,
+	ACX_AUTO_RX_STREAMING            = 0x0055,
+	ACX_PEER_CAP                     = 0x0056
 };
 
 
-- 
1.7.6.401.g6a319

