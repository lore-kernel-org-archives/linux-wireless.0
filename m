Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47559 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab1IMIq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 04:46:28 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Sep 2011 10:45:59 +0200
Subject: [PATCH v2 0/4] NFC: NCI protocol implementation
Message-ID: <AC090B9732AB2B4DB7FF476E907FE660013226A269@dnce02.ent.ti.com> (sfid-20110913_104632_216710_062F5AC5)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches implements the first part of the NFC Controller 
Interface protocol.

The NCI is a standard communication protocol between an NFC Controller (NFCC) 
and a Device Host (DH), defined by the NFC Forum.

The NCI protocol implementation is chip independent and responsible for:
	- Reset, initialization and configuration of the NFC controller
	- Sending commands/data to the NFC controller
	- Receiving responses/notifications/data from the NFC controller
	- Flow control for Control and Data Messages
	- Segmentation and reassembly for Control and Data Messages
	- An addressing scheme for NFC Execution Environments (NFCEE),
		e.g. secure element
	- An addressing scheme for Remote NFC Endpoints (NFCEE or RF targets) 
		(via logical connections)

The NCI protocol is added to the NFC subsystem below the NFC core:

+--------------------------------------+
|              USER SPACE              |
+--------------------------------------+
     ^                        ^
     | low-level              | control
     | data exchange          | operations
     |                        |
     |                        v
     |                  +-----------+
     | AF_NFC           |  netlink  |
     | socket           +-----------+
     | raw                    ^
     |                        |
     v                        v
+---------+             +-----------+
| rawsock | <---------> | NFC core  |
+---------+             +-----------+
                              ^
                              |
                              v
                        +-----------+
                        | NCI core  |
                        +-----------+
                              ^
                              |
                              v
                        +-----------+
                        |  driver   |
                        +-----------+

The driver will register itself to the NCI core, and in turn the NCI core will 
register itself to the NFC core.

Two new control operations were added (via generic netlink):
	- Dev_up, which turn on the NFC controller (this operation may take a 
		few seconds, as it can download new FW to the NFC controller)
	- Dev_down, which turn off the NFC controller

The nfc.h file was moved from include/net to include/net/nfc,
since 2 new header files were added to the new include/net/nfc folder.

To test the implementation, we developed the NFC TI Shared Transport driver 
and tested it with the user application example (provided by Lauro/Aloisio).
The driver implementation is included in this patch series.

Ilan Elias (4):
  NFC: Add dev_up and dev_down control operations
  NFC: move nfc.h from include/net to include/net/nfc
  NFC: basic NCI protocol implementation
  NFC: driver for TI shared transport

 MAINTAINERS                 |    2 +-
 drivers/nfc/Kconfig         |   11 +
 drivers/nfc/Makefile        |    1 +
 drivers/nfc/nfcwilink.c     |  342 +++++++++++++++++++
 drivers/nfc/pn533.c         |    4 +-
 include/linux/nfc.h         |    6 +
 include/net/nfc/nci.h       |  313 +++++++++++++++++
 include/net/nfc/nci_core.h  |  183 ++++++++++
 include/net/{ => nfc}/nfc.h |    4 +
 net/nfc/Kconfig             |    2 +
 net/nfc/Makefile            |    1 +
 net/nfc/core.c              |   77 +++++
 net/nfc/nci/Kconfig         |   10 +
 net/nfc/nci/Makefile        |    7 +
 net/nfc/nci/core.c          |  790 +++++++++++++++++++++++++++++++++++++++++++
 net/nfc/nci/data.c          |  245 +++++++++++++
 net/nfc/nci/lib.c           |   94 +++++
 net/nfc/nci/ntf.c           |  258 ++++++++++++++
 net/nfc/nci/rsp.c           |  226 ++++++++++++
 net/nfc/netlink.c           |   56 +++
 net/nfc/nfc.h               |    6 +-
 21 files changed, 2635 insertions(+), 3 deletions(-)
 create mode 100644 drivers/nfc/nfcwilink.c
 create mode 100644 include/net/nfc/nci.h
 create mode 100644 include/net/nfc/nci_core.h
 rename include/net/{ => nfc}/nfc.h (97%)
 create mode 100644 net/nfc/nci/Kconfig
 create mode 100644 net/nfc/nci/Makefile
 create mode 100644 net/nfc/nci/core.c
 create mode 100644 net/nfc/nci/data.c
 create mode 100644 net/nfc/nci/lib.c
 create mode 100644 net/nfc/nci/ntf.c
 create mode 100644 net/nfc/nci/rsp.c