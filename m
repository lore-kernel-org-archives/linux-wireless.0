Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab2K0Nwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:47 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqkT8010559
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:46 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqkpH014304
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:46 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 4/6] wl12xx: ignore some of the firmware version fields
Date: Tue, 27 Nov 2012 15:51:59 +0200
Message-ID: <1354024321-20635-5-git-send-email-coelho@ti.com> (sfid-20121127_145251_266864_DB4BD1D0)
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware type and the project number fields in the firmware
version number, cannot be checked as if they increase sequentially,
because the former is the firmware type and the latter is an internal
project number.  There's no guarantee that these numbers will remain
incremental, so use WLCORE_FW_VER_IGNORE.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 634ad00..310df52 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -32,16 +32,16 @@
 
 /* minimum FW required for driver for wl127x */
 #define WL127X_CHIP_VER		6
-#define WL127X_IFTYPE_VER	3
+#define WL127X_IFTYPE_VER	WLCORE_FW_VER_IGNORE
 #define WL127X_MAJOR_VER	10
-#define WL127X_SUBTYPE_VER	2
+#define WL127X_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
 #define WL127X_MINOR_VER	115
 
 /* minimum FW required for driver for wl128x */
 #define WL128X_CHIP_VER		7
-#define WL128X_IFTYPE_VER	3
+#define WL128X_IFTYPE_VER	WLCORE_FW_VER_IGNORE
 #define WL128X_MAJOR_VER	10
-#define WL128X_SUBTYPE_VER	2
+#define WL128X_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
 #define WL128X_MINOR_VER	115
 
 #define WL12XX_AGGR_BUFFER_SIZE	(4 * PAGE_SIZE)
-- 
1.7.10.4

