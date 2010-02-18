Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50766 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab0BRL2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:23 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/22] wl1271: Fix beacon filter table configuration
Date: Thu, 18 Feb 2010 13:25:52 +0200
Message-Id: <1266492357-462-18-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon filter table configuration ACX structure had certain elements
reversed, resulting in firmware instability in regard of the feature. Fix
the structure.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index ac94a13..aeccc98 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -2,7 +2,7 @@
  * This file is part of wl1271
  *
  * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
- * Copyright (C) 2008-2009 Nokia Corporation
+ * Copyright (C) 2008-2010 Nokia Corporation
  *
  * Contact: Luciano Coelho <luciano.coelho@nokia.com>
  *
@@ -348,7 +348,7 @@ struct acx_beacon_filter_option {
  * ACXBeaconFilterEntry (not 221)
  * Byte Offset     Size (Bytes)    Definition
  * ===========     ============    ==========
- * 0				1               IE identifier
+ * 0               1               IE identifier
  * 1               1               Treatment bit mask
  *
  * ACXBeaconFilterEntry (221)
@@ -381,8 +381,8 @@ struct acx_beacon_filter_ie_table {
 	struct acx_header header;
 
 	u8 num_ie;
-	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
 	u8 pad[3];
+	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
 } __attribute__ ((packed));
 
 struct acx_conn_monit_params {
-- 
1.6.3.3

