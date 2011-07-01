Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1GAWcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:32:21 -0400
Received: by gyh3 with SMTP id 3so1472217gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 15:32:21 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com, joe@perches.com,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH v5 0/6] NFC subsystem
Date: Fri,  1 Jul 2011 19:31:32 -0300
Message-Id: <1309559498-600-1-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110702_003224_794185_72ABE7C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This version has only debug related changes.

 1. NFC_*() macros were renamed to nfc_*(). For err and info nfc_printk() is
    called. For dbg pr_debug() is called.
 2. nfc_dev_*() macros were created to be used by device drivers. These macros
    use dev_*().
 3. The macros does not have __func__ anymore.

Aloisio Almeida Jr (3):
  NFC: add NFC socket family
  NFC: pn533: add NXP pn533 nfc device driver
  NFC: add Documentation/networking/nfc.txt

Lauro Ramos Venancio (3):
  NFC: add nfc subsystem core
  NFC: add nfc generic netlink interface
  NFC: add the NFC socket raw protocol

 Documentation/networking/nfc.txt |  128 +++
 drivers/Kconfig                  |    2 -
 drivers/Makefile                 |    1 +
 drivers/nfc/Kconfig              |   24 +-
 drivers/nfc/Makefile             |    3 +
 drivers/nfc/pn533.c              | 1632 ++++++++++++++++++++++++++++++++++++++
 include/linux/nfc.h              |  126 +++
 include/linux/socket.h           |    4 +-
 include/net/nfc.h                |  156 ++++
 net/Kconfig                      |    1 +
 net/Makefile                     |    1 +
 net/core/sock.c                  |    6 +-
 net/nfc/Kconfig                  |   16 +
 net/nfc/Makefile                 |    7 +
 net/nfc/af_nfc.c                 |   98 +++
 net/nfc/core.c                   |  468 +++++++++++
 net/nfc/netlink.c                |  537 +++++++++++++
 net/nfc/nfc.h                    |  117 +++
 net/nfc/rawsock.c                |  354 +++++++++
 19 files changed, 3663 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/networking/nfc.txt
 create mode 100644 drivers/nfc/pn533.c
 create mode 100644 include/linux/nfc.h
 create mode 100644 include/net/nfc.h
 create mode 100644 net/nfc/Kconfig
 create mode 100644 net/nfc/Makefile
 create mode 100644 net/nfc/af_nfc.c
 create mode 100644 net/nfc/core.c
 create mode 100644 net/nfc/netlink.c
 create mode 100644 net/nfc/nfc.h
 create mode 100644 net/nfc/rawsock.c

-- 
1.7.5.4

