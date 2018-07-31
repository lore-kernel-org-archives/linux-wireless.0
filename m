Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731652AbeGaOVV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 10:21:21 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 00/14] Add mt76x0 driver
Date: Tue, 31 Jul 2018 14:40:50 +0200
Message-Id: <1533040864-9026-1-git-send-email-sgruszka@redhat.com> (sfid-20180731_144114_820153_7DA757CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x0 driver for MT7610U based USB dongles. Currently driver
support only STA mode.

mt76x0 is based on Jakub's mt7601u driver already included
in the kernel. I would like the driver be integrated as part
of mt76 (instead of separate driver in mediatek dir like mt7601u)
to utilize mt76 code for adding support for MT76x0 PCIe devices
in further development.

To do not collide with current mt76x2u work from Lorenzo, I did not
remove some code duplication. This will be done in the future as well
as add support for MT76x0 PCIe devices (i.e. MT7630E).

My and Lorenzo integration efforts can be traced here:
https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2

mt7610u.bin file will be posted to linux-firmware tree as 
Sean Wang at Mediatek gave us permission to do so.

Patches has to be applied on top of mt76x2u:
https://marc.info/?l=linux-wireless&m=153302456826820&w=2

v2 -> v3
 - fixup monitor mode config
 - declare some functions static (reported by kbuild test)
 - change firmware location and add "u" suffix
 - fix MCU intialization after system reboot

v1 -> v2:
 - add missed mac.c file!
 - fix uninitialized variables reported by kbuild test
 - fix rate estimation
 - check for skb allocation

Stanislaw Gruszka (14):
  mt76x0: core files
  mt76x0: mac files
  mt76x0: usb files
  mt76x0: mcu files
  mt76x0: phy files
  mt76x0: init files
  mt76x0: eeprom files
  mt76x0: trace and debugfs files
  mt76x0: dma and tx files
  mt76x0: main file
  mt76: add more states
  mt76: Kconfig and Makefile for mt76x0 driver
  mt76x0: disable HW before probe
  mt76x0: load firmware from mediatek subdir

 drivers/net/wireless/mediatek/mt76/Kconfig         |    7 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    1 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |    7 +
 drivers/net/wireless/mediatek/mt76/mt76x0/core.c   |   34 +
 .../net/wireless/mediatek/mt76/mt76x0/debugfs.c    |  166 ++++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  522 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h    |  126 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  445 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |  149 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  720 ++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |  282 ++++++
 .../wireless/mediatek/mt76/mt76x0/initvals_phy.h   |  772 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  660 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  154 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  403 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |  656 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h    |  101 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  336 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 1008 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h    |   81 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h   |  651 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c  |   21 +
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |  366 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  270 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  381 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h    |   61 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c   |   42 +
 28 files changed, 8424 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c

-- 
1.9.3
