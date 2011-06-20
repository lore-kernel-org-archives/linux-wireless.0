Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56988 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FTRvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 13:51:50 -0400
Received: by yxi11 with SMTP id 11so2178645yxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 10:51:49 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [RFC][PATCH v2 0/7] NFC subsystem
Date: Mon, 20 Jun 2011 14:50:05 -0300
Message-Id: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110620_195153_187956_B7AAA7BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v2 includes (1) changes on the 'targets_found' report and (2) addition of
support to report dump consistency.

Due to the size limit of netlink messages, now NFC_EVENT_TARGETS_FOUND only
informs that new targets were found in a specific device. The userspace must
call NFC_CMD_GET_TARGET netlink command to get such list.

In order to inform an eventual dump inconsistency to userspace, generation
counters are being used internally. For each message to be sent in a dump,
genl_dump_check_consistent() is called to check if the current message comes
from a newer generation than previous messages. In that case, the message is
flagged with NLM_F_DUMP_INTR.

The function genl_dump_check_consistent() and the flag NLM_F_DUMP_INTR were
added by Johannes Berg's patch, which was just sent to netdev and wireless
kernel lists. As a reference, I added the Johannes's patch at the beggining of
this patch series. That's the reason to flag this patch series as RFC.

Aloisio Almeida Jr (3):
  NFC: add NFC socket family
  NFC: pn533: add NXP pn533 nfc device driver
  NFC: add Documentation/networking/nfc.txt

Johannes Berg (1):
  netlink: advertise incomplete dumps

Lauro Ramos Venancio (3):
  NFC: add nfc subsystem core
  NFC: add nfc generic netlink interface
  NFC: add the NFC socket raw protocol

 Documentation/networking/nfc.txt |  127 +++
 drivers/Kconfig                  |    2 -
 drivers/Makefile                 |    1 +
 drivers/nfc/Kconfig              |   24 +-
 drivers/nfc/Makefile             |    3 +
 drivers/nfc/pn533.c              | 1630 ++++++++++++++++++++++++++++++++++++++
 include/linux/netlink.h          |    2 +
 include/linux/nfc.h              |  125 +++
 include/linux/socket.h           |    4 +-
 include/net/genetlink.h          |   32 +
 include/net/netlink.h            |   24 +
 include/net/nfc.h                |  152 ++++
 net/Kconfig                      |    1 +
 net/Makefile                     |    1 +
 net/core/sock.c                  |    6 +-
 net/netlink/af_netlink.c         |    2 +
 net/nfc/Kconfig                  |   24 +
 net/nfc/Makefile                 |    9 +
 net/nfc/af_nfc.c                 |   98 +++
 net/nfc/core.c                   |  438 ++++++++++
 net/nfc/netlink.c                |  537 +++++++++++++
 net/nfc/nfc.h                    |  110 +++
 net/nfc/rawsock.c                |  351 ++++++++
 23 files changed, 3685 insertions(+), 18 deletions(-)
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
1.7.4.1

