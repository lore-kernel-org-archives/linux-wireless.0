Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61362 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1CFRXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 12:23:48 -0500
Received: by wwb22 with SMTP id 22so4390109wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 09:23:47 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 2/2] wl1251: fix elp_work race condition
Date: Sun,  6 Mar 2011 19:23:37 +0200
Message-Id: <1299432217-32139-3-git-send-email-notasas@gmail.com>
In-Reply-To: <1299432217-32139-1-git-send-email-notasas@gmail.com>
References: <1299432217-32139-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working on PS I've noticed elp_work is kicking rather often, and
sometimes the chip is put to sleep before 5ms delay expires. This
seems to happen because by the time wl1251_ps_elp_wakeup is called
elp_work might still be pending. After wakeup is done, the processing
may take some time, during which 5ms might expire and elp_work might
get scheduled. In this case, ss soon as 1st thread finishes work and
releases the mutex, elp_work will then put the device to sleep without
5ms delay. In addition 1st thread will queue additional elp_work
needlessly.

Fix this by cancelling work in wl1251_ps_elp_wakeup instead.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/ps.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/ps.c b/drivers/net/wireless/wl1251/ps.c
index 842155e..9cc5147 100644
--- a/drivers/net/wireless/wl1251/ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -58,7 +58,6 @@ void wl1251_ps_elp_sleep(struct wl1251 *wl)
 	unsigned long delay;
 
 	if (wl->psm) {
-		cancel_delayed_work(&wl->elp_work);
 		delay = msecs_to_jiffies(ELP_ENTRY_DELAY);
 		ieee80211_queue_delayed_work(wl->hw, &wl->elp_work, delay);
 	}
@@ -69,6 +68,9 @@ int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 	unsigned long timeout, start;
 	u32 elp_reg;
 
+	if (delayed_work_pending(&wl->elp_work))
+		cancel_delayed_work(&wl->elp_work);
+
 	if (!wl->elp)
 		return 0;
 
-- 
1.6.3.3

