Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39952 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab2AUWTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 17:19:48 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
	zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	george@znau.edu.ua, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/7] EHCI and OHCI for bcma and ssb
Date: Sat, 21 Jan 2012 23:19:20 +0100
Message-Id: <1327184367-8824-1-git-send-email-hauke@hauke-m.de> (sfid-20120121_232015_555706_075CCD58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds an EHCI and an OHCI driver for bcma and ssb 
based SoCs. These SoCs provide one device with two address spaces one 
for the OHCI and one for the EHCI part. The USB controllers are using 
the same interface as an PCI controller. This patch series is based on 
the mips Linux tree. It was in OpenWrt for some time and it was 
reviewed by George Kashperko recently.

Hauke Mehrtens (7):
  bcma: scan for extra address space
  bcma: add function to check every 10 us if a reg is set
  USB: OHCI: Add a generic platform device driver
  USB: EHCI: Add a generic platform device driver
  USB: Add driver for the bcma bus
  USB: Add driver for the ssb bus
  USB: OHCI: remove old SSB OHCI driver

 drivers/bcma/core.c              |   52 ++++---
 drivers/bcma/scan.c              |   18 ++-
 drivers/usb/host/Kconfig         |   57 ++++++--
 drivers/usb/host/Makefile        |    2 +
 drivers/usb/host/bcma-hcd.c      |  307 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci-hcd.c      |    5 +
 drivers/usb/host/ehci-platform.c |  211 ++++++++++++++++++++++++++
 drivers/usb/host/ohci-hcd.c      |   26 +---
 drivers/usb/host/ohci-platform.c |  193 ++++++++++++++++++++++++
 drivers/usb/host/ohci-ssb.c      |  260 --------------------------------
 drivers/usb/host/ssb-hcd.c       |  270 +++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma.h        |    4 +
 12 files changed, 1089 insertions(+), 316 deletions(-)
 create mode 100644 drivers/usb/host/bcma-hcd.c
 create mode 100644 drivers/usb/host/ehci-platform.c
 create mode 100644 drivers/usb/host/ohci-platform.c
 delete mode 100644 drivers/usb/host/ohci-ssb.c
 create mode 100644 drivers/usb/host/ssb-hcd.c

-- 
1.7.5.4

