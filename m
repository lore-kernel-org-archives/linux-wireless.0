Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49280 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab2FPT05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:26:57 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4227687wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:26:57 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/3] wl1251: always report beacon loss to the stack
Date: Sat, 16 Jun 2012 22:26:47 +0300
Message-Id: <1339874808-9991-3-git-send-email-notasas@gmail.com> (sfid-20120616_212739_253254_4BE55FC9)
In-Reply-To: <1339874808-9991-1-git-send-email-notasas@gmail.com>
References: <1339874808-9991-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always report beacon loss to the stack, not only when in powersave
state. This is because there's possibility that the driver disables
PSM before it handles old BSS_LOSE_EVENT, so beacon loss has to be
reported.

Patch based on old maemo patch by:
Janne Ylalehto <janne.ylalehto@nokia.com>
Juuso Oikarinen <juuso.oikarinen@nokia.com>
Luciano Coelho <luciano.coelho@nokia.com>
Yuri Ershov <ext-yuri.ershov@nokia.com>

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index 9f15cca..5ec50a4 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -76,8 +76,7 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		}
 	}
 
-	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID &&
-	    wl->station_mode != STATION_ACTIVE_MODE) {
+	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
-- 
1.7.0.4

