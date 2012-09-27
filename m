Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37741 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab2I0Kio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:44 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 23/31] wlcore: Fix unbalanced interrupts enablement
Date: Thu, 27 Sep 2012 13:38:01 +0300
Message-Id: <1348742289-6587-24-git-send-email-luca@coelho.fi> (sfid-20120927_123922_306124_A3E8B68C)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The interrupt line is enabled by wl12xx_enable_interrupts and
wl18xx_enable_interrupts, but it will not be disabled in all failure
paths. Fix this.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl12xx/main.c |    9 ++++++++-
 drivers/net/wireless/ti/wl18xx/main.c |    7 +++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f49ce7c..630b4d4 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1184,9 +1184,16 @@ static int wl12xx_enable_interrupts(struct wl1271 *wl)
 	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK,
 			       WL1271_ACX_INTR_ALL & ~(WL12XX_INTR_MASK));
 	if (ret < 0)
-		goto out;
+		goto disable_interrupts;
 
 	ret = wlcore_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
+	if (ret < 0)
+		goto disable_interrupts;
+
+	return ret;
+
+disable_interrupts:
+	wlcore_disable_interrupts(wl);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index fa7e6ef..9bf2d87 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -811,6 +811,13 @@ static int wl18xx_enable_interrupts(struct wl1271 *wl)
 
 	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK,
 			       WL1271_ACX_INTR_ALL & ~intr_mask);
+	if (ret < 0)
+		goto disable_interrupts;
+
+	return ret;
+
+disable_interrupts:
+	wlcore_disable_interrupts(wl);
 
 out:
 	return ret;
-- 
1.7.10.4

