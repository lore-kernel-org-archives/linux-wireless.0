Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55287 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbZKRPsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:48:08 -0500
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 2/2] rfkill: Add constant for RFKILL_TYPE_FM radio devices
Date: Wed, 18 Nov 2009 16:48:01 +0100
Message-Id: <1258559281-20935-2-git-send-email-marcel@holtmann.org>
In-Reply-To: <1258559281-20935-1-git-send-email-marcel@holtmann.org>
References: <1258559281-20935-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 include/linux/rfkill.h |    2 ++
 net/rfkill/core.c      |    4 +++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index a75e9e5..97059d0 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -36,6 +36,7 @@
  * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
  * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
  * @RFKILL_TYPE_GPS: switch is on a GPS device.
+ * @RFKILL_TYPE_FM: switch is on a FM radio device.
  * @NUM_RFKILL_TYPES: number of defined rfkill types
  */
 enum rfkill_type {
@@ -46,6 +47,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
+	RFKILL_TYPE_FM,
 	NUM_RFKILL_TYPES,
 };
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index ba2efb9..09f4e16 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -592,11 +592,13 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "wwan";
 	case RFKILL_TYPE_GPS:
 		return "gps";
+	case RFKILL_TYPE_FM:
+		return "fm";
 	default:
 		BUG();
 	}
 
-	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_GPS + 1);
+	BUILD_BUG_ON(NUM_RFKILL_TYPES != RFKILL_TYPE_FM + 1);
 }
 
 static ssize_t rfkill_type_show(struct device *dev,
-- 
1.6.3.3

