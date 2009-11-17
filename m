Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18010 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZKQQuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:50:15 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 13/16] wl1251: Fix regression in IRQ loop handling
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:46 +0200
Message-ID: <20091117164945.2236.93041.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In some cases, the IRQ loop handler could acknowledge an interrupt to
the chipset, but not service it.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index dad010d..2e1c10f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -308,9 +308,11 @@ static void wl1251_irq_work(struct work_struct *work)
 			wl1251_debug(DEBUG_IRQ,
 				     "WL1251_ACX_INTR_INIT_COMPLETE");
 
-		intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+		if (--ctr == 0)
+			break;
 
-	} while (intr && --ctr);
+		intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+	} while (intr);
 
 out_sleep:
 	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));

