Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55728 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab3IIJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:25:00 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so3093312wid.15
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:24:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/13] wl12xx/wl18xx: update default fw logger's settings
Date: Mon,  9 Sep 2013 12:24:37 +0300
Message-Id: <1378718684-14430-6-git-send-email-eliad@wizery.com> (sfid-20130909_112507_752050_437A2EF3)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

update the fw logger mode to continuous, and output to dbgpins (uart).

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c | 4 ++--
 drivers/net/wireless/ti/wl18xx/main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f147e32..d94173c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -333,11 +333,11 @@ static struct wlcore_conf wl12xx_conf = {
 		.always                        = 0,
 	},
 	.fwlog = {
-		.mode                         = WL12XX_FWLOG_ON_DEMAND,
+		.mode                         = WL12XX_FWLOG_CONTINUOUS,
 		.mem_blocks                   = 2,
 		.severity                     = 0,
 		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
-		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
+		.output                       = WL12XX_FWLOG_OUTPUT_DBG_PINS,
 		.threshold                    = 0,
 	},
 	.rate = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index a02e0bf..aaea0cc 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -456,11 +456,11 @@ static struct wlcore_conf wl18xx_conf = {
 		.always                        = 0,
 	},
 	.fwlog = {
-		.mode                         = WL12XX_FWLOG_ON_DEMAND,
+		.mode                         = WL12XX_FWLOG_CONTINUOUS,
 		.mem_blocks                   = 2,
 		.severity                     = 0,
 		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
-		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
+		.output                       = WL12XX_FWLOG_OUTPUT_DBG_PINS,
 		.threshold                    = 0,
 	},
 	.rate = {
-- 
1.8.3.rc1.35.g9b79519

