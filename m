Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:37896 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0EHQZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:25:31 -0400
Received: by qyk13 with SMTP id 13so3449002qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:25:31 -0700 (PDT)
Date: Sat, 8 May 2010 18:25:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: [patch 7/9] wl1271: add missing spin_lock()
Message-ID: <20100508162517.GS27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should start the loop consistently with the "wl_lock" lock held.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3e4b9fb..b61cd10 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -466,6 +466,7 @@ static void wl1271_irq_work(struct work_struct *work)
 		intr = le32_to_cpu(wl->fw_status->intr);
 		if (!intr) {
 			wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
+			spin_lock_irqsave(&wl->wl_lock, flags);
 			continue;
 		}
 
