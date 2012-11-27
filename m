Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33894 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706Ab2K0Nwt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:49 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqnwL005367
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:49 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqnDs014335
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:49 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 6/6] wl18xx: ignore irrelevant firmware version fields
Date: Tue, 27 Nov 2012 15:52:01 +0200
Message-ID: <1354024321-20635-7-git-send-email-coelho@ti.com> (sfid-20121127_145255_901176_2718BC67)
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For wl18xx, only the chip ID and the minor version number are
relevant.  Ignore the other numbers which are either not used or
relate to internal projects or internal branches.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 96a1e43..5d87bd3 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -26,9 +26,9 @@
 
 /* minimum FW required for driver */
 #define WL18XX_CHIP_VER		8
-#define WL18XX_IFTYPE_VER	2
-#define WL18XX_MAJOR_VER	0
-#define WL18XX_SUBTYPE_VER	0
+#define WL18XX_IFTYPE_VER	WLCORE_FW_VER_IGNORE
+#define WL18XX_MAJOR_VER	WLCORE_FW_VER_IGNORE
+#define WL18XX_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
 #define WL18XX_MINOR_VER	100
 
 #define WL18XX_CMD_MAX_SIZE          740
-- 
1.7.10.4

