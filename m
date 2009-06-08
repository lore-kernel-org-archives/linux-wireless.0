Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:52957 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZFHKbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 06:31:16 -0400
Message-ID: <4A2CE86F.9040209@tuffmail.co.uk>
Date: Mon, 08 Jun 2009 11:31:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Mattia Dongili <malattia@linux.it>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux acpi <linux-acpi@vger.kernel.org>
Subject: [PATCH] sony-laptop: no need to unblock rfkill on load
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The re-written rfkill core ensures rfkill devices are initialized to
the system default state.  The core calls set_block after registration
so the driver shouldn't need to.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---

This patch applies on top of the rfkill rewrite in the wireless-testing tree.

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index aec0b27..c1b21a4 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1114,7 +1114,6 @@ static int sony_nc_setup_rfkill(struct acpi_device *device,
 		return err;
 	}
 	sony_rfkill_devices[nc_type] = rfk;
-	sony_nc_rfkill_set((void *)nc_type, false);
 	return err;
 }
 

