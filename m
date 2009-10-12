Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:47701 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZJLMKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:10:49 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 08/16] wl1271: RefClk configuration
Date: Mon, 12 Oct 2009 15:08:49 +0300
Message-Id: <1255349337-9776-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Updated RefClk configuration based on reference sources. Apparently this
change will improve RF performance.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   20 ++++++++++++++++++--
 drivers/net/wireless/wl12xx/wl1271_boot.h |    9 ++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 1a3084c..b586577 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -435,13 +435,29 @@ int wl1271_boot(struct wl1271 *wl)
 	int ret = 0;
 	u32 tmp, clk, pause;
 
-	if (REF_CLOCK == 0 || REF_CLOCK == 2)
-		/* ref clk: 19.2/38.4 */
+	if (REF_CLOCK == 0 || REF_CLOCK == 2 || REF_CLOCK == 4)
+		/* ref clk: 19.2/38.4/38.4-XTAL */
 		clk = 0x3;
 	else if (REF_CLOCK == 1 || REF_CLOCK == 3)
 		/* ref clk: 26/52 */
 		clk = 0x5;
 
+	if (REF_CLOCK != 0) {
+		u16 val;
+		/* Set clock type */
+		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
+		val &= FREF_CLK_TYPE_BITS;
+		val |= CLK_REQ_PRCM;
+		wl1271_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
+	} else {
+		u16 val;
+		/* Set clock polarity */
+		val = wl1271_top_reg_read(wl, OCP_REG_CLK_POLARITY);
+		val &= FREF_CLK_POLARITY_BITS;
+		val |= CLK_REQ_OUTN_SEL;
+		wl1271_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
+	}
+
 	wl1271_reg_write32(wl, PLL_PARAMETERS, clk);
 
 	pause = wl1271_reg_read32(wl, PLL_PARAMETERS);
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/wl1271_boot.h
index 4501653..412443e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.h
@@ -50,10 +50,17 @@ struct wl1271_static_data {
 #define WU_COUNTER_PAUSE_VAL 0x3FF
 #define WELP_ARM_COMMAND_VAL 0x4
 
-#define OCP_REG_POLARITY 0x0064
+#define OCP_REG_POLARITY     0x0064
+#define OCP_REG_CLK_TYPE     0x0448
+#define OCP_REG_CLK_POLARITY 0x0cb2
 
 #define CMD_MBOX_ADDRESS 0x407B4
 
 #define POLARITY_LOW BIT(1)
 
+#define FREF_CLK_TYPE_BITS     0xfffffe7f
+#define CLK_REQ_PRCM           0x100
+#define FREF_CLK_POLARITY_BITS 0xfffff8ff
+#define CLK_REQ_OUTN_SEL       0x700
+
 #endif
-- 
1.5.6.5

