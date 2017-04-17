Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34958 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932599AbdDQKHs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Apr 2017 06:07:48 -0400
From: Vincent Legoll <vincent.legoll@gmail.com>
To: linux-kernel@vger.kernel.org, zajec5@gmail.com,
        linux-wireless@vger.kernel.org
Cc: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] Make BCMA a menuconfig to ease disabling it all
Date: Mon, 17 Apr 2017 12:07:30 +0200
Message-Id: <20170417100730.3648-2-vincent.legoll@gmail.com> (sfid-20170417_120818_560761_AC7812F4)
In-Reply-To: <20170417100730.3648-1-vincent.legoll@gmail.com>
References: <CAEwRq=oz=8T489QZtjcHB03rv_mFY6WAyOUkgMTOrsJuDEPPdw@mail.gmail.com>
 <20170417100730.3648-1-vincent.legoll@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to get into the submenu to disable all BCMA-related config entries

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 drivers/bcma/Kconfig | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index b5c48a8..54f81c5 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -3,11 +3,8 @@ config BCMA_POSSIBLE
 	depends on HAS_IOMEM && HAS_DMA
 	default y
 
-menu "Broadcom specific AMBA"
-	depends on BCMA_POSSIBLE
-
-config BCMA
-	tristate "BCMA support"
+menuconfig BCMA
+	tristate "Broadcom specific AMBA"
 	depends on BCMA_POSSIBLE
 	help
 	  Bus driver for Broadcom specific Advanced Microcontroller Bus
@@ -117,5 +114,3 @@ config BCMA_DEBUG
 	  This turns on additional debugging messages.
 
 	  If unsure, say N
-
-endmenu
-- 
2.9.3
