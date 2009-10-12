Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:64851 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZJLMNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:13:22 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/16] wl1271: enable HW_AVAILABLE interrupt to fix ELP
Date: Mon, 12 Oct 2009 15:08:45 +0300
Message-Id: <1255349337-9776-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to listen to HW_AVAILABLE interrupts when using ELP with firmware
revision 6.1.0.0.241.  Add WL1271_ACX_INTR_HW_AVAILABLE to the interrupts that
are enabled by default.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 0c2a107..07256d2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -61,8 +61,9 @@
 					    WL1271_ACX_INTR_HW_AVAILABLE  | \
 					    WL1271_ACX_INTR_DATA)
 
-#define WL1271_INTR_MASK                   (WL1271_ACX_INTR_EVENT_A |	\
-					    WL1271_ACX_INTR_EVENT_B | \
+#define WL1271_INTR_MASK                   (WL1271_ACX_INTR_EVENT_A      | \
+					    WL1271_ACX_INTR_EVENT_B      | \
+					    WL1271_ACX_INTR_HW_AVAILABLE | \
 					    WL1271_ACX_INTR_DATA)
 
 /* Target's information element */
-- 
1.5.6.5

