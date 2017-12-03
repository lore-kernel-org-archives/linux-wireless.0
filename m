Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:42609 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbdLCVTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Dec 2017 16:19:40 -0500
From: Vincent Legoll <vincent.legoll@gmail.com>
To: m@bues.ch, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] Make SSB a menuconfig to ease disabling it all
Date: Sun,  3 Dec 2017 22:19:21 +0100
Message-Id: <20171203211921.20233-2-vincent.legoll@gmail.com> (sfid-20171203_222001_090928_F97ACB66)
In-Reply-To: <20171203211921.20233-1-vincent.legoll@gmail.com>
References: <20171203211921.20233-1-vincent.legoll@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to get into the submenu to disable all SSB-related config entries

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 drivers/ssb/Kconfig | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d8e4219c2324..f48a2ee587a4 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -3,10 +3,7 @@ config SSB_POSSIBLE
 	depends on HAS_IOMEM && HAS_DMA
 	default y
 
-menu "Sonics Silicon Backplane"
-	depends on SSB_POSSIBLE
-
-config SSB
+menuconfig SSB
 	tristate "Sonics Silicon Backplane support"
 	depends on SSB_POSSIBLE
 	help
@@ -21,6 +18,8 @@ config SSB
 
 	  If unsure, say N.
 
+if SSB
+
 # Common SPROM support routines
 config SSB_SPROM
 	bool
@@ -185,4 +184,4 @@ config SSB_DRIVER_GPIO
 
 	  If unsure, say N
 
-endmenu
+endif # SSB
-- 
2.11.0
