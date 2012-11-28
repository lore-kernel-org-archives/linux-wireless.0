Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36268 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2K1Jm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:42:57 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384742wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:42:56 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/20] wl12xx/wl18xx: update default fw logger's settings
Date: Wed, 28 Nov 2012 11:42:30 +0200
Message-Id: <1354095769-8724-2-git-send-email-arik@wizery.com> (sfid-20121128_104304_036776_2CB49F40)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

update the fw logger mode to continuous, and output to dbgpins (uart).

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    4 ++--
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 9ac042b..0218edd 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -331,11 +331,11 @@ static struct wlcore_conf wl12xx_conf = {
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
index 53f4ba8..3f9504c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -453,11 +453,11 @@ static struct wlcore_conf wl18xx_conf = {
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
1.7.9.5

