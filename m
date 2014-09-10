Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16132 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaIJNf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:28 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/22] wil6210: fix for memory corruption while insmod
Date: Wed, 10 Sep 2014 16:34:37 +0300
Message-ID: <1410356091-19219-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153536_777385_E46CA60A)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

After setting interrupt handler, driver enabled interrupts.
This caused stale (old) HW interrupts to fire before driver is
fully initialized.
The fix is to enable interrupts only when driver is fully initialized
and after FW/HW reset (to prevent any stale interrupts)

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 331d0dc..58ddcc9 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -538,12 +538,7 @@ int wil6210_init_irq(struct wil6210_priv *wil, int irq)
 					  wil6210_thread_irq,
 					  wil->n_msi ? 0 : IRQF_SHARED,
 					  WIL_NAME, wil);
-	if (rc)
-		return rc;
-
-	wil6210_enable_irq(wil);
-
-	return 0;
+	return rc;
 }
 
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq)
-- 
1.9.1

