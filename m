Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62444 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZGSIsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 04:48:32 -0400
Received: by ewy26 with SMTP id 26so1704873ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 01:48:30 -0700 (PDT)
Message-ID: <4A62DDDC.5090100@tuffmail.co.uk>
Date: Sun, 19 Jul 2009 09:48:28 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Troy Moure <twmoure@szypr.net>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] acer-wmi: fix rfkill conversion
References: <alpine.LFD.2.00.0906171135080.3376@troy-laptop>
In-Reply-To: <alpine.LFD.2.00.0906171135080.3376@troy-laptop>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/17/09, Troy Moure <twmoure@szypr.net> wrote:
> Commit 19d337dff95cbf76ed ("rfkill: rewrite") incorrectly reversed
> the meaning of 'state' in acer_rfkill_update() when it changed
> rfkill_force_state() to rfkill_set_sw_state().  Fix it.
>
> Signed-off-by: Troy Moure <twmoure@szypr.net>
> ---
> This fixes the rfkill switch on my Acer laptop, which was behaving
> backwards (the state reported in the logs was the opposite of the
> state indicated by the LED).

I think there's another reversal error that you didn't notice :-).  I found that acer-wmi disables the wireless when it is loaded.

The core tries to initialize the wireless to enabled, but the polarity is wrong in acer_rfkill_set().  It ends up disabling the wireless instead.

Here's a patch for it.

--->
>From 75953366b4958a77019729662a997f5d361a7529 Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Sun, 19 Jul 2009 09:29:21 +0100
Subject: [PATCH] acer-wmi: fix rfkill conversion

Fix another polarity error introduced by the rfkill rewrite,
this time in acer_rfkill_set().

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index be2fd6f..fb45f5e 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -973,7 +973,7 @@ static int acer_rfkill_set(void *data, bool blocked)
 {
 	acpi_status status;
 	u32 cap = (unsigned long)data;
-	status = set_u32(!!blocked, cap);
+	status = set_u32(!blocked, cap);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
 	return 0;
-- 
1.6.3.2
