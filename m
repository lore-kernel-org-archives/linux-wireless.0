Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36203 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbbIRGNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 02:13:16 -0400
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH] Monitor interface for rtl8188eu
Date: Fri, 18 Sep 2015 08:12:59 +0200
Message-Id: <1442556780-12098-1-git-send-email-jsitnicki@gmail.com> (sfid-20150918_081347_407341_8674D390)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This was previously posted as a RFC[1] to linux-wireless.  Following
Larry Finger's suggestion[2] I'm resending it as a proposed patch.

This patch is intended as a debugging aid for people working on the
rtl8188eu driver.  I started working on it because debug logs from
rtl8188eu driver got me nowhere when I wanted to see what was "going
in and out".  It has reached a working state where you can use
TShark/Wireshark to analyze the flow of 802.11 frames:

  modprobe r8188eu monitor_enable=1
  ip link set mon0 up
  tshark -i mon0

I've been testing it against recent staging-next (6dd19f1), in managed
mode, with hardware encryption, and only with CCMP (AES) cipher in
use, but it should work with any.

Performance implications? A throughput test ran with iperf for 20
minutes before and after the changes (with monitor inferace enabled
and up) showed:

before: 43.0 Mbits/sec
after:  41.6 Mbits/sec

[1] https://lkml.kernel.org/g/1441383439-27007-1-git-send-email-jsitnicki@gmail.com 
[2] https://github.com/lwfinger/rtl8188eu/issues/73#issuecomment-138588729

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

