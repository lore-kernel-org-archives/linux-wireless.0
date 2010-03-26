Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30750 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0CZKye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:34 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 06/24] wl1271: Configure clock-request drive mode to open-drain
Date: Fri, 26 Mar 2010 12:53:15 +0200
Message-Id: <1269600813-32145-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch configures the wl1271 chipset clock-request line to be
driver in open-drain mode instead of push-pull.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    8 ++++++--
 drivers/net/wireless/wl12xx/wl1271_boot.h |    7 +++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 41c6aff..4195298 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -451,11 +451,15 @@ int wl1271_boot(struct wl1271 *wl)
 
 	if (REF_CLOCK != 0) {
 		u16 val;
-		/* Set clock type */
+		/* Set clock type (open drain) */
 		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
 		val &= FREF_CLK_TYPE_BITS;
-		val |= CLK_REQ_PRCM;
 		wl1271_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
+
+		/* Set clock pull mode (no pull) */
+		val = wl1271_top_reg_read(wl, OCP_REG_CLK_PULL);
+		val |= NO_PULL;
+		wl1271_top_reg_write(wl, OCP_REG_CLK_PULL, val);
 	} else {
 		u16 val;
 		/* Set clock polarity */
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/wl1271_boot.h
index 412443e..95ecc52 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.h
@@ -53,10 +53,13 @@ struct wl1271_static_data {
 #define OCP_REG_POLARITY     0x0064
 #define OCP_REG_CLK_TYPE     0x0448
 #define OCP_REG_CLK_POLARITY 0x0cb2
+#define OCP_REG_CLK_PULL     0x0cb4
 
-#define CMD_MBOX_ADDRESS 0x407B4
 
-#define POLARITY_LOW BIT(1)
+#define CMD_MBOX_ADDRESS     0x407B4
+
+#define POLARITY_LOW         BIT(1)
+#define NO_PULL              (BIT(14) | BIT(15))
 
 #define FREF_CLK_TYPE_BITS     0xfffffe7f
 #define CLK_REQ_PRCM           0x100
-- 
1.6.3.3

