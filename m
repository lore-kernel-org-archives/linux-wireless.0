Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39339 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZIYJSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 05:18:20 -0400
Received: by bwz6 with SMTP id 6so1888310bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 02:18:23 -0700 (PDT)
Message-ID: <4ABC8ADD.3090803@tuffmail.co.uk>
Date: Fri, 25 Sep 2009 10:18:21 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mattia Dongili <malattia@linux.it>,
	Norbert Preining <preining@logic.at>
Subject: [PATCH] [RFT] sony-laptop: re-read the rfkill state when resuming
 from suspend
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this, the hard-blocked state will be reported incorrectly if
the hardware switch is changed while the laptop is suspended.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
--

Again, this is from code inspection only.  Since suspend/resume can
be tricky, please test that this change works (and is necessary).


diff a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1044,6 +1044,9 @@ static int sony_nc_resume(struct acpi_device *device)
 			sony_backlight_update_status(sony_backlight_device) < 0)
 		printk(KERN_WARNING DRV_PFX "unable to restore brightness level\n");
 
+	/* re-read rfkill state */
+	sony_nc_rfkill_update();
+
 	return 0;
 }
 


