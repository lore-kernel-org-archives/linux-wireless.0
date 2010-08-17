Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42138 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0HQTrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 15:47:23 -0400
Received: by ewy23 with SMTP id 23so3304186ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 12:47:22 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/4] wl1251: fix event handling mechanism
Date: Tue, 17 Aug 2010 22:46:53 +0300
Message-Id: <1282074415-6168-3-git-send-email-notasas@gmail.com>
In-Reply-To: <1282074415-6168-1-git-send-email-notasas@gmail.com>
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case both A and B events occured simultaneously, current code
would only process A and clear both interrupts. Make it process both
events instead.

Based on wl1271 patches by Juuso Oikarinen:
1fd2794f36913992798184c464fe8f85753b13e0
13f2dc52c69bcca074cd12d4806953b2af45c386

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 6d31c85..51474b6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -293,14 +293,14 @@ static void wl1251_irq_work(struct work_struct *work)
 			wl1251_tx_complete(wl);
 		}
 
-		if (intr & (WL1251_ACX_INTR_EVENT_A |
-			    WL1251_ACX_INTR_EVENT_B)) {
-			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT (0x%x)",
-				     intr);
-			if (intr & WL1251_ACX_INTR_EVENT_A)
-				wl1251_event_handle(wl, 0);
-			else
-				wl1251_event_handle(wl, 1);
+		if (intr & WL1251_ACX_INTR_EVENT_A) {
+			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT_A");
+			wl1251_event_handle(wl, 0);
+		}
+
+		if (intr & WL1251_ACX_INTR_EVENT_B) {
+			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT_B");
+			wl1251_event_handle(wl, 1);
 		}
 
 		if (intr & WL1251_ACX_INTR_INIT_COMPLETE)
-- 
1.5.6.3

