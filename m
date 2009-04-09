Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:41375 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761769AbZDIPho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 11:37:44 -0400
Message-ID: <49DE1638.8060906@lwfinger.net> (sfid-20090409_173748_662227_9CC12D31)
Date: Thu, 09 Apr 2009 10:37:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Another regression in 2.6.30-rc1
Content-Type: multipart/mixed;
 boundary="------------020807010307060604090709"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020807010307060604090709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If you are implementing kernel 2.6.30-rc1 from wireless-testing, there is a
regression that will hit you if you have the ACPI battery routines enabled. The
symptom is an oops on boot with the line "> BUG: unable to handle kernel NULL
pointer dereference at (null)". The patch for this, which comes from
2.6.30-rc1-git1 in Linus's tree, is as follows:

==============================================

commit 5d38258ec026921a7b266f4047ebeaa75db358e5
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Tue Apr 7 10:55:38 2009 +0200

    ACPI battery: fix async boot oops

    > BUG: unable to handle kernel NULL pointer dereference at (null)

    What happens is that the battery module's init sections are being freed
    before the async callback (which was marked __init) has run. This theory
    is supported by the fact that the bad RIP value is a vmalloc address.

    The immediate fix is to make this a non-init call.

    (A better long-term fix is of course to wait with init-section unloading
    until a module's async initcalls have been run, which would allow us to
    discard this function which is still only run once, after all. Perhaps a
    new async_initcall() function for the async/module API, if this is needed
    for other modules in the future?)

    Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
    Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
    Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>
    Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b0de631..3c7d894 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -903,7 +903,7 @@ static struct acpi_driver acpi_battery_driver = {
 		},
 };

-static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
+static void acpi_battery_init_async(void *unused, async_cookie_t cookie)
 {
 	if (acpi_disabled)
 		return;


----

Larry

--------------020807010307060604090709
Content-Type: text/plain;
 name="battery_init_async"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="battery_init_async"

commit 5d38258ec026921a7b266f4047ebeaa75db358e5
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Tue Apr 7 10:55:38 2009 +0200

    ACPI battery: fix async boot oops
    
    > BUG: unable to handle kernel NULL pointer dereference at (null)
    
    What happens is that the battery module's init sections are being freed
    before the async callback (which was marked __init) has run. This theory
    is supported by the fact that the bad RIP value is a vmalloc address.
    
    The immediate fix is to make this a non-init call.
    
    (A better long-term fix is of course to wait with init-section unloading
    until a module's async initcalls have been run, which would allow us to
    discard this function which is still only run once, after all. Perhaps a
    new async_initcall() function for the async/module API, if this is needed
    for other modules in the future?)
    
    Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
    Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
    Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>
    Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b0de631..3c7d894 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -903,7 +903,7 @@ static struct acpi_driver acpi_battery_driver = {
 		},
 };
 
-static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
+static void acpi_battery_init_async(void *unused, async_cookie_t cookie)
 {
 	if (acpi_disabled)
 		return;


--------------020807010307060604090709--
