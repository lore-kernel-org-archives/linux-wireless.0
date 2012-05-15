Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2EOOJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:09 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so2512825wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/10] wlcore: fix dynamic_ps_timeout time regression
Date: Tue, 15 May 2012 17:08:53 +0300
Message-Id: <1337090940-13750-3-git-send-email-arik@wizery.com> (sfid-20120515_160915_478095_20474A9B)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In patch d7b63b9fc7ee73e75a4c7fdb899 we have raised the dynamic
PS timeout to 200ms to improve user experience. Re-apply the change,
since it was reverted in the wlcore split.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 29902c1..7e65ee3 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -238,7 +238,7 @@ static struct wlcore_conf wl12xx_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
-		.dynamic_ps_timeout          = 40,
+		.dynamic_ps_timeout          = 200,
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index d7e48db..c5ec94b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -361,7 +361,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.psm_entry_retries           = 8,
 		.psm_exit_retries            = 16,
 		.psm_entry_nullfunc_retries  = 3,
-		.dynamic_ps_timeout          = 40,
+		.dynamic_ps_timeout          = 200,
 		.forced_ps                   = false,
 		.keep_alive_interval         = 55000,
 		.max_listen_interval         = 20,
-- 
1.7.9.5

