Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37324 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1KQSPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 13:15:07 -0500
Received: by ywt32 with SMTP id 32so1410397ywt.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 10:15:05 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] Miscellaneous patches for rtlwifi and rtl8192cu
Date: Thu, 17 Nov 2011 12:14:41 -0600
Message-Id: <1321553685-31154-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111117_191517_708081_5FBB24F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches include the following:

1. Addition of USB retries for rtl8192cu.
2. Change USB firmware upload to device to use block writes, not one dword at a time.
3. Fix usage of rtl8192cu on big-endian platforms.
4. Simplify interrupt routine for PCI devices.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

All of these are 3.3 material.

Thanks, Larry
--- 

George (1):
  rtlwifi: rtl8192cu: Allow retries for USB I/O

Larry Finger (3):
  rtlwifi: rtl8192cu: Change firmware upload to use block writes
  rtlwifi: rtl8192cu: Fix endianian issues
  rtlwifi: Remove redundant code from PCI interrupt

 drivers/net/wireless/rtlwifi/base.c               |    6 +-
 drivers/net/wireless/rtlwifi/base.h               |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                |    3 -
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |   60 ++++++++++++++++----
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h |   23 ++++----
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |    9 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c      |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                |   56 ++++++++++++++++---
 drivers/net/wireless/rtlwifi/wifi.h               |    7 ++-
 10 files changed, 123 insertions(+), 46 deletions(-)

-- 
1.7.7

