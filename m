Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38443 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976Ab1F1SVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:21:40 -0400
Received: by ywe9 with SMTP id 9so191290ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 11:21:39 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	padovan@profusion.mobi, rdunlap@xenotime.net,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH v4 0/6] NFC subsystem
Date: Tue, 28 Jun 2011 15:20:40 -0300
Message-Id: <1309285246-8495-1-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110628_203940_898398_67783E62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This version includes the following changes:

 1. NFC_ERR(), NFC_INFO() and NFC_DBG() were created for message output in the
    subsystem. Device drivers still have to use dev_*() functions;
 2. Now using dynamic debug, NFC_DEBUG config was removed;
 3. core.c: nfc_targets_found(): kzmalloc()/memcpy() changed to kmemdup();
 4. An eventual error on sending NFC_EVENT_DEVICE_ADDED and
    NFC_EVENT_DEVICE_REMOVED messages will be ignored;
 5. Added the attribute 'packed' to initiator_data structs in pn533 driver. It
    fixes the felica polling loop;
 6. Fixes in the Documentation/networking/nfc.txt.

As Johannes Berg's patch (netlink: advertise incomplete dumps) is already on
wireless-next tree, I removed the tag 'RFC' from this patch series.

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
 drivers/nfc/pn533.c              | 1630 ++++++++++++++++++++++++++++++++++++++
 include/linux/nfc.h              |  126 +++
 include/linux/socket.h           |    4 +-
 include/net/nfc.h                |  152 ++++
 net/Kconfig                      |    1 +
 net/Makefile                     |    1 +
 net/core/sock.c                  |    6 +-
 net/nfc/Kconfig                  |   16 +
 net/nfc/Makefile                 |    7 +
 net/nfc/af_nfc.c                 |   98 +++
 net/nfc/core.c                   |  445 +++++++++++
 net/nfc/netlink.c                |  537 +++++++++++++
 net/nfc/nfc.h                    |  114 +++
 net/nfc/rawsock.c                |  351 ++++++++
 19 files changed, 3628 insertions(+), 18 deletions(-)
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

