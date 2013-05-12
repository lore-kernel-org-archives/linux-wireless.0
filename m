Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:43015 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3ELJfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 05:35:44 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so5313723wes.41
        for <linux-wireless@vger.kernel.org>; Sun, 12 May 2013 02:35:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] wlcore: hold jiffies in unsigned long
Date: Sun, 12 May 2013 12:35:30 +0300
Message-Id: <1368351331-6914-3-git-send-email-eliad@wizery.com> (sfid-20130512_113550_833381_C046C8EC)
In-Reply-To: <1368351331-6914-1-git-send-email-eliad@wizery.com>
References: <1368351331-6914-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

u32 can be incorrect (too small) for some architectures.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 9654577..98066d4 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -110,7 +110,7 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 	DECLARE_COMPLETION_ONSTACK(compl);
 	unsigned long flags;
 	int ret;
-	u32 start_time = jiffies;
+	unsigned long start_time = jiffies;
 	bool pending = false;
 
 	/*
-- 
1.8.1.2

