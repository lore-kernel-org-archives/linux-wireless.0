Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36656 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754352AbdAIXBI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 18:01:08 -0500
Received: by mail-oi0-f65.google.com with SMTP id u143so18619396oif.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 15:01:08 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 0/3] rtlwifi: Patches for proper operation on big-endian hardware
Date: Mon,  9 Jan 2017 17:00:55 -0600
Message-Id: <20170109230058.22758-1-Larry.Finger@lwfinger.net> (sfid-20170110_000112_535298_27EDDB3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although these drivers do not have any Sparse messages indication
problems with endian operations, there are two places where the
information being processed is little endian, but was being processed
in cpu order. The first of these is in downloading firmware. Rather
than do a double conversion for BE hosts, I converted the firmware
download routines to send bytes rather than 32-bit quantities. The
number of I/O operations in increased, but firmware download is usually
done only once.

A second problem is that the USB driver requires that the descriptors
be checksummed before transmission to the device so that critical info
such as DMA addresses are not garbled in transmission. The original
code was calculating the checksum in cpu order.

There is also a third change that causes the USB driver rtl8192cu to use
the same set of macros to read and write the descriptors. This change was
no necessary; however, it simplifies the code, and did identify an endian
problem in the macros. Using identical macros for PCI- and USB-based
hardware increases the likelihood that the PCI devices will work with BE
hardware. At the moment, we do not have such hardware for testing.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>


Larry Finger (3):
  rtlwifi: Download firmware as bytes rather than as dwords
  rtlwifi: rtl8192cu: Calculate descriptor checksum correctly for BE
  rtlwifi: rtl8192cu: Convert driver to use common macros

 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  45 ++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |   4 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |  67 +----
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |  70 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.h   | 272 ++++++++++-----------
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    |  70 +-----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  68 +-----
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |  69 +-----
 .../realtek/rtlwifi/rtl8723com/fw_common.h         |   6 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  67 +----
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  29 +--
 12 files changed, 222 insertions(+), 549 deletions(-)

-- 
2.10.2
