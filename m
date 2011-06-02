Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62897 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1FBVrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 17:47:01 -0400
Received: by gxk21 with SMTP id 21so527686gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 14:47:00 -0700 (PDT)
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
Subject: [PATCH 0/6] NFC subsystem
Date: Thu,  2 Jun 2011 18:46:04 -0300
Message-Id: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org> (sfid-20110602_234707_516412_D2CAB75C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches implements the first part of the Near Field
Communication (NFC) subsystem.

A NFC subsystem is required to standardize the NFC device drivers
development and to create an unified userspace interface.

This implementation focus in one of the three NFC use cases: the tag
read/write. However the architecture was designed with the card
emulation and peer-to-peer use cases in mind.

The subsystem is divided in some parts. The 'core' is responsible for
providing the device driver interface. On the other side, it is also
responsible for providing an interface to the control operations and
low-level data exchange.

The control operations are available to userspace via generic netlink.
The most important operations are NFC_CMD_START_POLL and
NFC_CMD_STOP_POLL that control the polling for targets. The event
NFC_EVENT_TARGETS_FOUND is emitted to return polling results.

The low-level data exchange interface to userspace is provided by a
new socket family: PF_NFC. The NFC_SOCKPROTO_RAW uses SOCK_SEQPACKET
to perform raw communication with NFC targets. The address family
(AF_NFC) has the local device id, the NFC target id and the NFC
protocol as fields.

Further, the low-level data exchange interface provided by the core
can also be used to implement the LLCP protocol.

To test the implementation, we developed the NXP pn533 driver and an
user application example. The driver implementation is included in
this patch series. The user application example can be found at
http://code.openbossa.org.

Aloisio Almeida Jr (3):
  NFC: add NFC socket family
  NFC: pn533: add NXP pn533 nfc device driver
  NFC: add Documentation/networking/nfc.txt

Lauro Ramos Venancio (3):
  NFC: add nfc subsystem core
  NFC: add nfc generic netlink interface
  NFC: add the NFC socket raw protocol

 Documentation/networking/nfc.txt |  127 +++
 drivers/Kconfig                  |    2 -
 drivers/Makefile                 |    1 +
 drivers/nfc/Kconfig              |   24 +-
 drivers/nfc/Makefile             |    3 +
 drivers/nfc/pn533.c              | 1629 ++++++++++++++++++++++++++++++++++++++
 include/linux/nfc.h              |  136 ++++
 include/linux/socket.h           |    4 +-
 include/net/nfc.h                |  149 ++++
 net/Kconfig                      |    1 +
 net/Makefile                     |    1 +
 net/core/sock.c                  |    6 +-
 net/nfc/Kconfig                  |   24 +
 net/nfc/Makefile                 |    9 +
 net/nfc/af_nfc.c                 |   98 +++
 net/nfc/core.c                   |  403 ++++++++++
 net/nfc/netlink.c                |  446 +++++++++++
 net/nfc/nfc.h                    |  110 +++
 net/nfc/rawsock.c                |  351 ++++++++
 19 files changed, 3506 insertions(+), 18 deletions(-)
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

