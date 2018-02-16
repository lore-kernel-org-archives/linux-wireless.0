Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28895 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754383AbeBPPMG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:06 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 03/12] staging: wilc1000: fix line over 80 characters in sdio_clear_int_ext()
Date: Fri, 16 Feb 2018 20:41:40 +0530
Message-ID: <1518793909-15573-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161210_328165_E43FE9E4)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue found by checkpatch.pl script by
modifying the comment description.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 27ec90e..a088999 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -913,8 +913,11 @@ static int sdio_clear_int_ext(struct wilc *wilc, u32 val)
 		return 1;
 	}
 	if (g_sdio.irq_gpio) {
-		/* see below. has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
-		/* Cannot clear multiple interrupts. Must clear each interrupt individually */
+		/* has_thrpt_enh2 uses register 0xf8 to clear interrupts. */
+		/*
+		 * Cannot clear multiple interrupts.
+		 * Must clear each interrupt individually.
+		 */
 		u32 flags;
 
 		flags = val & (BIT(MAX_NUM_INT) - 1);
-- 
2.7.4
