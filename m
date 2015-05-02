Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:13609 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbbEBNBp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2015 09:01:45 -0400
From: moorray3@wp.pl
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 0/2] add mt7601u driver
Date: Sat,  2 May 2015 15:01:28 +0200
Message-Id: <1430571690-9054-1-git-send-email-moorray3@wp.pl> (sfid-20150502_150152_483090_8B9BE170)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

This miniseries adds support for the simplest of MediaTek Wi-Fi
devices.  MT7601U is a single stream bgn chip with no bells or whistles.
My driver is partially based on Felix's mt76 but IMHO it doesn't
make sense to merge the two right now because MT7601U is a design
somewhere between old Ralink devices and new Mediatek chips.  There
wouldn't be all that much code sharing with the devices mt76 supports.
Situation may obviously change when someone decides to extend m76 with
support for the more recent USB dongles.

The driver supports only station mode.  I'm hoping to add AP support
when time allows.

This driver sat on GitHub for quite a while and got some testing there.
If anyone is interested in full git history and such here's a link:

http://github.com/kuba-moo/mt7601u

I split the submission into the build things and meta data (kconfig,
Makefiles, MAINTAINERS update etc.) and the actual code to make the
reviewing a little easier.

Jakub Kicinski (2):
  add mt7601u driver
  add mt7601u kbuild and others

 MAINTAINERS                                        |    6 +
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/mediatek/Kconfig              |   10 +
 drivers/net/wireless/mediatek/Makefile             |    1 +
 drivers/net/wireless/mediatek/mt7601u/Kconfig      |    6 +
 drivers/net/wireless/mediatek/mt7601u/Makefile     |    9 +
 drivers/net/wireless/mediatek/mt7601u/core.c       |   73 ++
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |  172 +++
 drivers/net/wireless/mediatek/mt7601u/dma.c        |  440 +++++++
 drivers/net/wireless/mediatek/mt7601u/dma.h        |  129 ++
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |  414 +++++++
 drivers/net/wireless/mediatek/mt7601u/eeprom.h     |  151 +++
 drivers/net/wireless/mediatek/mt7601u/init.c       |  628 ++++++++++
 drivers/net/wireless/mediatek/mt7601u/initvals.h   |  164 +++
 .../net/wireless/mediatek/mt7601u/initvals_phy.h   |  291 +++++
 drivers/net/wireless/mediatek/mt7601u/mac.c        |  571 +++++++++
 drivers/net/wireless/mediatek/mt7601u/mac.h        |  178 +++
 drivers/net/wireless/mediatek/mt7601u/main.c       |  413 +++++++
 drivers/net/wireless/mediatek/mt7601u/mcu.c        |  534 +++++++++
 drivers/net/wireless/mediatek/mt7601u/mcu.h        |   94 ++
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h    |  386 ++++++
 drivers/net/wireless/mediatek/mt7601u/phy.c        | 1251 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt7601u/regs.h       |  636 ++++++++++
 drivers/net/wireless/mediatek/mt7601u/trace.c      |   21 +
 drivers/net/wireless/mediatek/mt7601u/trace.h      |  397 +++++++
 drivers/net/wireless/mediatek/mt7601u/tx.c         |  328 +++++
 drivers/net/wireless/mediatek/mt7601u/usb.c        |  331 ++++++
 drivers/net/wireless/mediatek/mt7601u/usb.h        |   77 ++
 drivers/net/wireless/mediatek/mt7601u/util.c       |   42 +
 drivers/net/wireless/mediatek/mt7601u/util.h       |   77 ++
 31 files changed, 7833 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/core.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/initvals.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/initvals_phy.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/mt7601u.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/usb.h
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt7601u/util.h

-- 
2.1.0

