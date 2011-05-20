Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:54401 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934559Ab1ETIZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 04:25:34 -0400
Received: by mail-ey0-f178.google.com with SMTP id 25so1297736eya.37
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 01:25:32 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: change TX BA window size to 8
Date: Fri, 20 May 2011 11:25:25 +0300
Message-Id: <1305879925-10322-1-git-send-email-coelho@ti.com> (sfid-20110520_102539_447549_8C93353C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx firmware only supports window size of 8 frames in TX BA
sessions.  Currently we are configuring it to 64, which is not
supported and causes problems (ie. firmware crashes).

Fix this by changing the tx_ba_win_size configuration to 8.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 610be03..b854b5f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -326,7 +326,7 @@ static struct conf_drv_settings default_conf = {
 		},
 	},
 	.ht = {
-		.tx_ba_win_size = 64,
+		.tx_ba_win_size = 8,
 		.inactivity_timeout = 10000,
 	},
 	.mem_wl127x = {
-- 
1.7.1

