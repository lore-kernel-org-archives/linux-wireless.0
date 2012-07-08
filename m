Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:44341 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab2GHHXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:48 -0400
Received: by lbbgm6 with SMTP id gm6so7365845lbb.33
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:45 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 5/8] wl12xx/wl18xx: use a dynamic PS timeout of 1.5sec
Date: Sun,  8 Jul 2012 10:23:28 +0300
Message-Id: <1341732211-25871-6-git-send-email-coelho@ti.com> (sfid-20120708_092352_320936_8ADA98C7)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

It seems some parties have bad user experience when smaller values
are used. This should have little implications for power consumption,
since traffic is bursty in nature.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index da261cf..3d6c71b 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -242,7 +242,7 @@ static struct wlcore_conf wl12xx_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
-		.dynamic_ps_timeout          = 200,
+		.dynamic_ps_timeout          = 1500,
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 341e878..23f100a3 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -369,7 +369,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
-		.dynamic_ps_timeout          = 200,
+		.dynamic_ps_timeout          = 1500,
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
-- 
1.7.10

