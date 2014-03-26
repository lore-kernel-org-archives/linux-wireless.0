Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60174 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbaCZT4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:56:11 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so2053465eek.6
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:56:10 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 00/20] rtl8180: add support for rtl8187se
Date: Wed, 26 Mar 2014 20:57:17 +0100
Message-Id: <1395863837-4272-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205617_446331_18461F32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set contains all the modifications/adds that finally
make rtl8187se work with rtl8180 driver

Andrea Merello (20):
  rtl818x: add registers for rtl8187se
  rtl8180: add rtl8187se chip type
  rtl8180: add rtl8187se fields to TX descriptor
  rtl8180: add basic rate configuration support for rtl8187se
  rtl8180: support for rtl8187se RX descriptors
  rtl8180: add ISR for rtl8187se
  rtl8180: introduce functions to enable/disable ints and add support
    for rtl8187se
  rtl8180: don't write MAR registers for rtl8187se
  rtl8180: add TX queue mapping and support for rtl8187se
  rtl8180: config carbus register for rtl8187se
  rtl8180: add rtl8187se params to eeprom reading
  rtl8180: introduce functions for setting ANAPARAM 2 and 3 params
  rtl8180: add RF code for rtl8225 zebra v4
  rtl8180: add rtl8187se HW initialization
  rtl8180: add ERP configuration for rtl8187se
  rtl8180: make sure RTL818X_MSR_ENEDCA is set for rtl8187se
  rtl8180: add WMM parameters configuration for rtl8187se
  rtl8180: detect rtl8187se card
  rtl8180: enable rtl8187se support
  rtl818x: Update Kconfig for rtl8187se

 drivers/net/wireless/rtl818x/Kconfig             |   4 +-
 drivers/net/wireless/rtl818x/rtl8180/Makefile    |   2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c       | 637 +++++++++++++++++++++--
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h   |  59 ++-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c   |   1 +
 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c | 475 +++++++++++++++++
 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h |  61 +++
 drivers/net/wireless/rtl818x/rtl818x.h           | 266 ++++++++--
 8 files changed, 1389 insertions(+), 116 deletions(-)
 create mode 100644 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c
 create mode 100644 drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h

-- 
1.8.3.2

