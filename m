Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52346 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2KVTDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:03:22 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3048333eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:03:21 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 07/14] wlcore: update acx enum
Date: Thu, 22 Nov 2012 18:06:17 +0200
Message-Id: <1353600384-32462-8-git-send-email-eliad@wizery.com> (sfid-20121122_200340_040974_B57EE521)
In-Reply-To: <1353600384-32462-1-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update the acx enum to the new fw api.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: keep the 18xx-specific ACXs in wl18xx/acx.h (thanks Luca!)

 drivers/net/wireless/ti/wl18xx/acx.c |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.h |    8 +++++++-
 drivers/net/wireless/ti/wlcore/acx.h |    1 -
 3 files changed, 8 insertions(+), 3 deletions(-)

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
index e2609a6..394d125 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -26,7 +26,13 @@
 #include "../wlcore/acx.h"
 
 enum {
-	ACX_CLEAR_STATISTICS		 = 0x0047,
+	ACX_NS_IPV6_FILTER		 = 0x0050,
+	ACX_PEER_HT_OPERATION_MODE_CFG	 = 0x0051,
+	ACX_CSUM_CONFIG			 = 0x0052,
+	ACX_SIM_CONFIG			 = 0x0053,
+	ACX_CLEAR_STATISTICS		 = 0x0054,
+	ACX_AUTO_RX_STREAMING		 = 0x0055,
+	ACX_PEER_CAP			 = 0x0056
 };
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index d03215d..126536c 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -1025,7 +1025,6 @@ enum {
 	ACX_CONFIG_HANGOVER              = 0x0042,
 	ACX_FEATURE_CFG                  = 0x0043,
 	ACX_PROTECTION_CFG               = 0x0044,
-	ACX_CHECKSUM_CONFIG              = 0x0045,
 };
 
 
-- 
1.7.6.401.g6a319

