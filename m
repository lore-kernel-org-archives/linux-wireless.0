Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34359 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbcCRCWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:22:09 -0400
Received: by mail-pf0-f169.google.com with SMTP id x3so145786888pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:22:09 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 04/19] wl1251: use to_delayed_work()
Date: Fri, 18 Mar 2016 13:22:03 +1100
Message-Id: <78647c02da62c57860d2b78e1f0bb1fb9fda1341.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032213_369653_6BB1A4D6)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Geliang Tang <geliangtang@163.com>

Use to_delayed_work() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
[Update commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/ti/wl1251/ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/ps.c b/drivers/net/wireless/ti/wl1251/ps.c
index b9e27b9..fa01b0a 100644
--- a/drivers/net/wireless/ti/wl1251/ps.c
+++ b/drivers/net/wireless/ti/wl1251/ps.c
@@ -32,7 +32,7 @@ void wl1251_elp_work(struct work_struct *work)
 	struct delayed_work *dwork;
 	struct wl1251 *wl;
 
-	dwork = container_of(work, struct delayed_work, work);
+	dwork = to_delayed_work(work);
 	wl = container_of(dwork, struct wl1251, elp_work);
 
 	wl1251_debug(DEBUG_PSM, "elp work");
-- 
2.7.0

