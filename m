Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:35896 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZGPKfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 06:35:13 -0400
Received: by ewy26 with SMTP id 26so15529ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 03:35:12 -0700 (PDT)
Message-ID: <4A5F02C9.50505@gmail.com>
Date: Thu, 16 Jul 2009 12:36:57 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: kalle.valo@nokia.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] wl12xx: loop off by one.
References: <4A524E91.9040400@gmail.com>
In-Reply-To: <4A524E91.9040400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With `while (loop++ < INIT_LOOP)' `loop' becomes INIT_LOOP + 1 after
the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> with `while (loop++ < INIT_LOOP)' `loop' reaches -1 after the loop.
>
> Sorry, my brains are on vacation mode right now and I can't understand
> how loop can reach -1.

The confusion is my fault. The changelog should have as above. The patch
is correct though.

> Here's the code:

>    loop = 0;
>    while (loop++ < INIT_LOOP) {
>          ...
>    }
>
>    if (loop >= INIT_LOOP) {
>       wl1251_error("timeout waiting for the hardware to "
>                    "complete initialization");
>       return -EIO;
>    }

In the last iteration `loop' is `INIT_LOOP -1', the test occurs and then
the increment to `INIT_LOOP'. If just then the break occurs:
`if (interrupt & wl->chip.intr_init_complete)' evaluates to true, then
we error out, although there was no timeout. This could be very unlikely
to occur.

> Also the patch won't apply to wireless-testing because main.c is renamed
> to wl1251_main.c.

Ok, this is against your tree

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index d8a155d..b2ae71c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -247,7 +247,7 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		}
 	}
 
-	if (loop >= INIT_LOOP) {
+	if (loop > INIT_LOOP) {
 		wl1251_error("timeout waiting for the hardware to "
 			     "complete initialization");
 		return -EIO;
