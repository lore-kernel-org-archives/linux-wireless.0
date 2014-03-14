Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbaCNUGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 16:06:08 -0400
Date: Fri, 14 Mar 2014 21:05:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.15] NFC update
Message-ID: <20140314200536.GM27197@zurbaran> (sfid-20140314_210612_627012_A864C7C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the NFC pull request for 3.15. With this one we have:

- Support for ISO 15693 a.k.a. NFC vicinity a.k.a. Type 5 tags. ISO
  15693 are long range (1 - 2 meters) vicinity tags/cards. The kernel
  now supports those through the NFC netlink and digital APIs.

- Support for TI's trf7970a chipset. This chipset relies on the NFC
  digital layer and the driver currently supports type 2, 4A and 5 tags.

- Support for NXP's pn544 secure firmare download. The pn544 C3 chipsets
  relies on a different firmware download protocal than the C2 one. We
  now support both and use the right one depending on the version we
  detect at runtime.

- Support for 4A tags from the NFC digital layer.

- A bunch of cleanups and minor fixes from Axel Lin and Thierry Escande.

Thanks in advance for pulling those in.

The following changes since commit 35582ad9d342025653aaf28ed321bf5352488d7f:

  Staging: rtl8812ae: remove modules field of rate_control_ops (2014-02-13 15:23:23 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.15-1

for you to fetch changes up to 29e27dd86b5c4f8e6feb62d7b6a8491539ff1ef1:

  NFC: llcp: Use list_for_each_entry in nfc_llcp_find_local() (2014-03-14 20:19:08 +0100)

----------------------------------------------------------------
Arron Wang (2):
      NFC: pn544: Pass hardware variant information when downloading firmware
      NFC: pn544: i2c: Support PN544 C3 secure firmware download

Axel Lin (9):
      NFC: NCI: Use reinit_completion() at appropriate places
      NFC: port100: Convert to use USB_DEVICE macro
      NFC: pn533: Convert to use USB_DEVICE macro
      NFC: Use list_for_each_entry in nfc_find_se()
      NFC: digital: Use matching_[im|tm]_protocols to check with NFC protocols masks
      NFC: Use LIST_HEAD() at appropriate places
      NFC: Remove redundant test for dev->n_targets in nfc_find_target
      NFC: Move checking valid gb_len value to nfc_llcp_set_remote_gb
      NFC: llcp: Use list_for_each_entry in nfc_llcp_find_local()

Mark A. Greer (8):
      NFC: Add ISO/IEC 15693 header definitions
      NFC: digital: Add Digital Layer support for ISO/IEC 15693
      NFC: Add netlink support for ISO/IEC 15693
      NFC: digital: Rename Type V tags to Type 5 tags
      NFC: trf7970a: Add driver with ISO/IEC 14443 Type 2 Tag Support
      NFC: trf7970a: Add support for Type 4A Tags
      NFC: trf7970a: Add ISO/IEC 15693 and Type 5 tag Support
      NFC: trf7970a: Add DTS Documentation

Thierry Escande (6):
      NFC: port100: Fix possible buffer overflow
      NFC: digital: Add poll support for type 4A tag platform
      NFC: digital: Add ISO-DEP support for data exchange
      NFC: port100: Add support for type 4A tag platform
      NFC: digital: Add missing break in switch statement
      NFC: digital: Fix a possible memory leak

 .../devicetree/bindings/net/nfc/trf7970a.txt       |   34 +
 MAINTAINERS                                        |    1 +
 drivers/nfc/Kconfig                                |   12 +
 drivers/nfc/Makefile                               |    1 +
 drivers/nfc/pn533.c                                |   28 +-
 drivers/nfc/pn544/i2c.c                            |  194 ++-
 drivers/nfc/pn544/pn544.c                          |    2 +-
 drivers/nfc/pn544/pn544.h                          |    3 +-
 drivers/nfc/port100.c                              |   25 +-
 drivers/nfc/trf7970a.c                             | 1370 ++++++++++++++++++++
 include/net/nfc/digital.h                          |    7 +
 include/net/nfc/nfc.h                              |    3 +
 include/uapi/linux/nfc.h                           |    9 +-
 net/nfc/core.c                                     |   10 +-
 net/nfc/digital.h                                  |    6 +
 net/nfc/digital_core.c                             |   67 +-
 net/nfc/digital_technology.c                       |  247 +++-
 net/nfc/hci/llc.c                                  |    4 +-
 net/nfc/llcp_core.c                                |   16 +-
 net/nfc/nci/core.c                                 |    3 +-
 net/nfc/nci/spi.c                                  |    3 +-
 net/nfc/netlink.c                                  |    8 +
 22 files changed, 1985 insertions(+), 68 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
 create mode 100644 drivers/nfc/trf7970a.c


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
