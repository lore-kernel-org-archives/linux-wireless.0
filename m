Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46196 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2EOOJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:18 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj8so2859247wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:17 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Igal Chernobelsky <igalc@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/10] wlcore: modify bss loss parameters
Date: Tue, 15 May 2012 17:08:57 +0300
Message-Id: <1337090940-13750-7-git-send-email-arik@wizery.com> (sfid-20120515_160922_807975_1447D62A)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Modify default parameters to reduce firmware BSS lose
probability in congested environment.

[Applied to 18xx configuration as well - Arik]

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    4 ++--
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 7e65ee3..08bec7f 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -227,8 +227,8 @@ static struct wlcore_conf wl12xx_conf = {
 				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
 			},
 		},
-		.synch_fail_thold            = 10,
-		.bss_lose_timeout            = 100,
+		.synch_fail_thold            = 12,
+		.bss_lose_timeout            = 400,
 		.beacon_rx_timeout           = 10000,
 		.broadcast_timeout           = 20000,
 		.rx_broadcast_in_ps          = 1,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c5ec94b..10a0ba1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -350,8 +350,8 @@ static struct wlcore_conf wl18xx_conf = {
 				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
 			},
 		},
-		.synch_fail_thold            = 10,
-		.bss_lose_timeout            = 100,
+		.synch_fail_thold            = 12,
+		.bss_lose_timeout            = 400,
 		.beacon_rx_timeout           = 10000,
 		.broadcast_timeout           = 20000,
 		.rx_broadcast_in_ps          = 1,
-- 
1.7.9.5

