Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab1GHJDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 05:03:46 -0400
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>
Subject: [PATCH] staging: brcm80211: Fix module parameter permissions
Date: Fri, 8 Jul 2011 11:03:44 +0200
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107081103.44726.jdelvare@suse.de> (sfid-20110708_110350_174680_09CCCD4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The third parameter of module_param is supposed to represent sysfs
file permissions. A value of "1" makes no sense.

I am changing it to "0" to align with the other module parameters in
this driver.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.0-rc6.orig/drivers/staging/brcm80211/brcmfmac/dhd_linux.c	2011-05-30 20:45:16.000000000 +0200
+++ linux-3.0-rc6/drivers/staging/brcm80211/brcmfmac/dhd_linux.c	2011-07-08 10:14:52.000000000 +0200
@@ -300,7 +300,7 @@ module_param(dhd_pkt_filter_init, uint,
 
 /* Pkt filter mode control */
 uint dhd_master_mode = true;
-module_param(dhd_master_mode, uint, 1);
+module_param(dhd_master_mode, uint, 0);
 
 /* Watchdog thread priority, -1 to use kernel timer */
 int dhd_watchdog_prio = 97;

-- 
Jean Delvare
Suse L3
