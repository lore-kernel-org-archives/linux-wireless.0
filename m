Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52154 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3EJHeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 03:34:22 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <levipearson@gmail.com>, <hashcode0f@gmail.com>
Subject: [PATCH] wl12xx: fix minimum required firmware version for wl127x multirole
Date: Fri, 10 May 2013 10:32:57 +0300
Message-ID: <1368171177-13682-1-git-send-email-coelho@ti.com> (sfid-20130510_093426_151722_D4998316)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a typo in commit 8675f9 (wlcore/wl12xx/wl18xx: verify
multi-role and single-role fw versions), which was causing the
multirole firmware for wl127x (WiLink6) to be rejected.  The actual
minimum version needed for wl127x multirole is 6.5.7.0.42.

Reported-by: Levi Pearson <levipearson@gmail.com>
Reported-by: Michael Scott <hashcode0f@gmail.com>
Cc: stable@kernel.org # 3.9+
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 222d035..139da4d 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -41,7 +41,7 @@
 #define WL127X_IFTYPE_MR_VER	5
 #define WL127X_MAJOR_MR_VER	7
 #define WL127X_SUBTYPE_MR_VER	WLCORE_FW_VER_IGNORE
-#define WL127X_MINOR_MR_VER	115
+#define WL127X_MINOR_MR_VER	42
 
 /* FW chip version for wl128x */
 #define WL128X_CHIP_VER		7
-- 
1.7.10.4

