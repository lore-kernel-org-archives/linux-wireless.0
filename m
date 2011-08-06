Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56749 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1HFKz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 06:55:59 -0400
Received: by iye16 with SMTP id 16so5329995iye.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2011 03:55:58 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/2] rtlwifi: Remove raw reads and writes
Date: Sat,  6 Aug 2011 05:55:17 -0500
Message-Id: <1312628119-12640-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110806_125604_297055_8DFB04AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtlwifi is built for the sh4 architecture, build errors of the following
type occur.

    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:290: error: implicit declaration of function 'outl': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:295: error: implicit declaration of function 'outb': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:300: error: implicit declaration of function 'inb': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:305: error: implicit declaration of function 'inw': 4 errors in 2 logs


John,

This is 3.2 material, unless some user reports a build failure for some
architecture that actually runs one of the PCIe drivers.

Larry
---

Larry Finger (2):
  rtlwifi: Eliminate raw reads and writes from PCIe portion
  rtlwifi: Remove raw read/write routines from header

 drivers/net/wireless/rtlwifi/pci.c |   37 +++++++++--------------------------
 drivers/net/wireless/rtlwifi/pci.h |   26 --------------------------
 2 files changed, 10 insertions(+), 53 deletions(-)

-- 
1.7.3.4

