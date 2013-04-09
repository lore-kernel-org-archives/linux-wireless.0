Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48669 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936502Ab3DIA6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 20:58:08 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, marcel@holtmann.org, gustavo@padovan.org,
	johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
	champion_chen@realsil.com.cn
Subject: [RFC/RFT PATCH 0/2 V2] Adding a new bluetooth driver to the kernel
Date: Mon,  8 Apr 2013 19:57:46 -0500
Message-Id: <1365469068-4548-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130409_025821_452499_0FF8F0DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches supply the code needed to operate the bluetooth portion of
the Realtek RTL8723AE chip. Much of the necessary code is already present
in btusb, thus that driver is changed to export the necessary routines.
The second patch implements the routines that differ from the standard
driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Larry Finger (2):
  btusb: Modify code for use with a similar driver
  rtk_btusb: A new driver for the Bluetooth portion of the Realtek
    RTL8723AE chip

 drivers/bluetooth/Kconfig     |  10 +
 drivers/bluetooth/Makefile    |   1 +
 drivers/bluetooth/btusb.c     |  79 +---
 drivers/bluetooth/btusb.h     |  88 ++++
 drivers/bluetooth/rtk_btusb.c | 974 ++++++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/rtk_btusb.h | 102 +++++
 6 files changed, 1194 insertions(+), 60 deletions(-)
 create mode 100644 drivers/bluetooth/btusb.h
 create mode 100644 drivers/bluetooth/rtk_btusb.c
 create mode 100644 drivers/bluetooth/rtk_btusb.h

-- 
1.8.1.4

