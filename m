Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:32924 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbbIDQRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 12:17:31 -0400
Received: by lbcjc2 with SMTP id jc2so14058382lbc.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2015 09:17:29 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC] Monitor interface for rtl8188eu
Date: Fri,  4 Sep 2015 18:17:18 +0200
Message-Id: <1441383439-27007-1-git-send-email-jsitnicki@gmail.com> (sfid-20150904_181734_904956_91E851F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch is intended as a debugging aid for people working on the
rtl8188eu driver. I'm posting it as an RFC in case it turns out useful
for others.

(Although I hope it won't be useful for long, if the recently proposed
rtl8xxxu driver stands up to its name. ;-)

The latest version of the patch will be maintained at:

https://github.com/jsitnicki/linux.git branch rtl8188eu-monitor-iface

I started working on it because debug logs from rtl8188eu driver got
me nowhere when I wanted to see what was "going in and out".  It has
reached a working state where you can use TShark/Wireshark to analyze
the flow of 802.11 frames:

  modprobe r8188eu monitor_enable=1
  ip link set mon0 up
  tshark -i mon0

I've been testing it against v4.2, with hardware encryption, and only
with CCMP (AES) cipher in use, but it should work with any. Feedback
is welcome.

Cheers,
Jakub


Jakub Sitnicki (1):
  staging: rtl8188eu: Introduce monitor interface for IEEE 802.11 frames

 drivers/staging/rtl8188eu/Makefile             |   1 +
 drivers/staging/rtl8188eu/core/rtw_recv.c      |  14 ++
 drivers/staging/rtl8188eu/core/rtw_xmit.c      |   4 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c |   4 +
 drivers/staging/rtl8188eu/include/drv_types.h  |   2 +
 drivers/staging/rtl8188eu/include/mon.h        |  36 +++++
 drivers/staging/rtl8188eu/os_dep/mon.c         | 194 +++++++++++++++++++++++++
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |   5 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c    |  10 ++
 9 files changed, 270 insertions(+)
 create mode 100644 drivers/staging/rtl8188eu/include/mon.h
 create mode 100644 drivers/staging/rtl8188eu/os_dep/mon.c

-- 
2.1.0

