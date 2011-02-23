Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50023 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab1BWNZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:25:27 -0500
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p1NDPR3D013875
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 07:25:27 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id p1NDPQ6j028885
	for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 07:25:26 -0600 (CST)
From: Sebastien Jan <s-jan@ti.com>
To: Luciano Coelho <coelho@ti.com>, <linux-wireless@vger.kernel.org>
CC: Sebastien Jan <s-jan@ti.com>
Subject: [PATCH] WLAN: fix the path to the wl12xx firmwares
Date: Wed, 23 Feb 2011 14:25:16 +0100
Message-ID: <1298467516-9092-1-git-send-email-s-jan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Validated FW loading on a Ubuntu Natty alpha image, on a pandaboard
(embedding a WL1271).

Signed-off-by: Sebastien Jan <s-jan@ti.com>
---

Applies on a 2.6.38-rc5 kernel

 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9050dd9..8ceb6a0 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -112,8 +112,8 @@ extern u32 wl12xx_debug_level;
 				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
 				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
 
-#define WL1271_FW_NAME "wl1271-fw.bin"
-#define WL1271_NVS_NAME "wl1271-nvs.bin"
+#define WL1271_FW_NAME "ti-connectivity/wl1271-fw.bin"
+#define WL1271_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
 
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
-- 
1.7.1

