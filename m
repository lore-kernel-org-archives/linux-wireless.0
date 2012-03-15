Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55989 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761064Ab2COWut (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 18:50:49 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v5 0/4] USB: OHCI/EHCI: generic platform driver
Date: Thu, 15 Mar 2012 23:49:55 +0100
Message-Id: <1331851799-5968-1-git-send-email-hauke@hauke-m.de> (sfid-20120315_235057_915812_B87586E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This EHCI/OHCI platform driver should replace the simple EHCI and OHCI 
platform drivers. It was developed to be used for the USB core of the 
Broadcom SoCs supported by ssb and bcma, but it should also work for 
other devices.

Drivers like ehci-ath79.c, ehci-xls.c and ehci-ixp4xx.c should be 
relative easy be ported to this EHCI driver.
And drivers like ohci-ath79.c, ohci-ppc-soc.c, ohci-sh.c and ohci-xls.c 
should be easy be ported to the this OHCI driver.

I am unable to test the suspend and resume part, as my SoC does not 
support this, but most of the platform driver do not support 
suspend/resume too. The code here should work, but was never runtime 
tested.

This also contains patches adding USB support for the SoCs based on ssb 
and bcma and converts the ath79 code to use the generic usb driver.

This patch series is based on the usb tree and should go through it to Linus.

v5:
   * removed the patches already applied to usb/usb-next
   * rebase onto usb/usb-next

v4:
   * handle error when searching for a bridge on bcma
   * leave old Kconfig options and mark them deprecated and select the
     new driver

v3:
   * add patches for bcma and ssb usb driver again
   * add patch to convert ath79 to use the generic platform driver

v2:
   * split include/linux/usb/hci_driver.h into include/linux
     /usb/ehci_pdriver.h and include/linux/usb/ohci_pdriver.h
   * remove flags from include/linux/usb/{e,o}ehci_pdriver.h
   * add kernel doc
   * add some more options into the structs to activate hardware quirks.

Hauke Mehrtens (4):
  bcma: scan for extra address space
  USB: Add driver for the bcma bus
  USB: Add driver for the ssb bus
  USB: OHCI: remove old SSB OHCI driver

 drivers/bcma/scan.c         |   19 +++-
 drivers/usb/host/Kconfig    |   31 ++++-
 drivers/usb/host/Makefile   |    2 +
 drivers/usb/host/bcma-hcd.c |  334 +++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c |   21 +---
 drivers/usb/host/ohci-ssb.c |  260 ---------------------------------
 drivers/usb/host/ssb-hcd.c  |  279 ++++++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma.h   |    1 +
 8 files changed, 665 insertions(+), 282 deletions(-)
 create mode 100644 drivers/usb/host/bcma-hcd.c
 delete mode 100644 drivers/usb/host/ohci-ssb.c
 create mode 100644 drivers/usb/host/ssb-hcd.c

-- 
1.7.5.4

