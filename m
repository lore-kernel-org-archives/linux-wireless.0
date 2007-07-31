Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48225 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbXGaSeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:21 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121186ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:21 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/24] rt2x00: Big rt2x00 cleanup
Date: Tue, 31 Jul 2007 20:37:31 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.31395.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From a402c9e7e3c485c12265d0b3b127bcb5942b5400 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Mon, 30 Jul 2007 13:50:34 +0200
Subject: [PATCH 17/24] rt2x00: Big rt2x00 cleanup

This cleans up quite a lot of code,
the main goal was to achieve a better readability
and to have a overall better coding style.

Some highlights:
  - rt2x00.h is split into several header files
  - config handling is now in a new .c file
  - Include cleanup

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/Makefile         |    2 +-
 drivers/net/wireless/rt2400pci.c      |  228 ++++++-----
 drivers/net/wireless/rt2500pci.c      |  230 ++++++-----
 drivers/net/wireless/rt2500usb.c      |  202 +++++-----
 drivers/net/wireless/rt2x00.h         |  725 +++++++--------------------------
 drivers/net/wireless/rt2x00config.c   |  174 ++++++++
 drivers/net/wireless/rt2x00debug.c    |   84 ++--
 drivers/net/wireless/rt2x00debug.h    |   35 +--
 drivers/net/wireless/rt2x00dev.c      |  264 +++++--------
 drivers/net/wireless/rt2x00dev.h      |   61 ---
 drivers/net/wireless/rt2x00firmware.c |   37 +-
 drivers/net/wireless/rt2x00firmware.h |   43 --
 drivers/net/wireless/rt2x00lib.h      |  140 ++++---
 drivers/net/wireless/rt2x00mac.c      |  125 ++++---
 drivers/net/wireless/rt2x00pci.c      |   48 ++-
 drivers/net/wireless/rt2x00pci.h      |   27 +-
 drivers/net/wireless/rt2x00reg.h      |  270 ++++++++++++
 drivers/net/wireless/rt2x00rfkill.c   |   39 +-
 drivers/net/wireless/rt2x00rfkill.h   |   62 ---
 drivers/net/wireless/rt2x00ring.h     |  242 +++++++++++
 drivers/net/wireless/rt2x00usb.c      |   35 ++-
 drivers/net/wireless/rt2x00usb.h      |   27 +-
 drivers/net/wireless/rt61pci.c        |  206 +++++-----
 drivers/net/wireless/rt73usb.c        |  194 +++++-----
 24 files changed, 1820 insertions(+), 1680 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00config.c
 delete mode 100644 drivers/net/wireless/rt2x00dev.h
 delete mode 100644 drivers/net/wireless/rt2x00firmware.h
 create mode 100644 drivers/net/wireless/rt2x00reg.h
 delete mode 100644 drivers/net/wireless/rt2x00rfkill.h
 create mode 100644 drivers/net/wireless/rt2x00ring.h

---

http://mendiosus.nl/rt2x00/0017-rt2x00-Big-rt2x00-cleanup.patch
