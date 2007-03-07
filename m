Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38347 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965629AbXCGU1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 15:27:04 -0500
Message-ID: <45EF2015.8000802@lwfinger.net>
Date: Wed, 07 Mar 2007 14:27:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Problem with USB1.1 Host cores with the mb tree for bcm43xx_mac80211
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you have a BCM4311 and are seeing an oops that looks like this when loading bcm43xx_mac80211:

ssb: Switching to ChipCommon core, index 0
ssb: Switching to PCI-E core, index 3
ssb: Switching to USB 1.1 Host core, index 2

Unable to handle kernel NULL pointer dereference at 00000000000002d0 RIP:
 [<ffffffff8812fcfd>] :usbcore:usb_create_hcd+0x3b/0xe8
PGD 3e792067 PUD 3ed66067 PMD 0
Oops: 0002 [1] SMP
...

there is a temporary, unofficial patch at
ftp://lwfinger.dynalias.org/patches/mac80211_usb_problem.patch. Although it works, it attacks the
symptom, not the cause, and will never be adopted into the code. Once a proper fix is applied, it
will no longer be needed.

Larry
