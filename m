Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:41346 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0EHQ0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:26:05 -0400
Received: by qyk13 with SMTP id 13so3449708qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:26:04 -0700 (PDT)
Date: Sat, 8 May 2010 18:25:51 +0200
From: Dan Carpenter <error27@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: [patch 8/9] wl1271: fix notifier interface supported test
Message-ID: <20100508162551.GT27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "(wl == NULL)" test doesn't work here because "wl" is always
non-null.  The intent of the code is to return if the interface
was not supported by the driver.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b61cd10..55aa813 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -852,7 +852,7 @@ static int wl1271_dev_notify(struct notifier_block *me, unsigned long what,
 		if (wl == wl_temp)
 			break;
 	}
-	if (wl == NULL)
+	if (wl != wl_temp)
 		return NOTIFY_DONE;
 
 	/* Get the interface IP address for the device. "ifa" will become
