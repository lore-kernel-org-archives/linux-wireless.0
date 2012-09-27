Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:46683 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2I0Kig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:36 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>
Subject: [PATCH 01/31] wl18xx: update default phy configuration for pg2
Date: Thu, 27 Sep 2012 13:37:39 +0300
Message-Id: <1348742289-6587-2-git-send-email-luca@coelho.fi> (sfid-20120927_123841_897858_AA1E66C6)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

default switch configuration set to pg2 chips (rdl 1/2/3/4).
removed hacks for specific board types.
pg1.x boards are now supported only using module params
or specific conf files.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/main.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 99364d4..3c274eb 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -505,8 +505,8 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.rdl				= 0x01,
 		.auto_detect			= 0x00,
 		.dedicated_fem			= FEM_NONE,
-		.low_band_component		= COMPONENT_2_WAY_SWITCH,
-		.low_band_component_type	= 0x06,
+		.low_band_component		= COMPONENT_3_WAY_SWITCH,
+		.low_band_component_type	= 0x04,
 		.high_band_component		= COMPONENT_2_WAY_SWITCH,
 		.high_band_component_type	= 0x09,
 		.tcxo_ldo_voltage		= 0x00,
@@ -1428,18 +1428,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* HACK! Just for now we hardcode COM8 and HDK to 0x06 */
-	switch (priv->conf.phy.board_type) {
-	case BOARD_TYPE_HDK_18XX:
-	case BOARD_TYPE_COM8_18XX:
-		priv->conf.phy.low_band_component_type = 0x06;
-		break;
-	case BOARD_TYPE_FPGA_18XX:
-	case BOARD_TYPE_DVP_18XX:
-	case BOARD_TYPE_EVB_18XX:
-		priv->conf.phy.low_band_component_type = 0x05;
-		break;
-	default:
+	if (priv->conf.phy.board_type >= NUM_BOARD_TYPES) {
 		wl1271_error("invalid board type '%d'",
 			priv->conf.phy.board_type);
 		ret = -EINVAL;
-- 
1.7.10.4

