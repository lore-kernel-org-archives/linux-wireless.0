Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34880 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaETWN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 18:13:29 -0400
Date: Wed, 21 May 2014 00:13:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.16] NFC update
Message-ID: <20140520221319.GA15540@zurbaran> (sfid-20140521_001333_589659_4ABDC64A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the NFC pull request for 3.16. We have:

- STMicroeectronics st21nfca support. The st21nfca is an HCI chipset and
  thus relies on the HCI stack. This submission provides support for tag
  redaer/writer mode (including Type 5) and device tree bindings.

- PM runtime support and a bunch of bug fixes for TI's trf7970a.

- Device tree support for NXP's pn544. Legacy platform data support is
  obviously kept intact.

- NFC Tag type 4B support to the NFC Digital stack.

- SOCK_RAW type support to the raw NFC socket, and allow NCI
  sniffing from that. This can be extended to report HCI frames and also
  proprietarry ones like e.g. the pn533 ones.

Thanks in advance for pulling those in.

The following changes since commit 321d03c86732e45f5f33ad0db5b68e2e1364acb9:

  Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild (2014-04-12 18:22:27 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git nfc-next-3.16-1

for you to fetch changes up to 7974728094d35f38775417a26d8f30ea3602496a:

  NFC: st21nfca: Add ISO15693 Reader/Writer support (2014-05-20 00:48:28 +0200)

----------------------------------------------------------------
Christophe Ricard (22):
      NFC: ST21NFCA: Add driver for STMicroelectronics ST21NFCA NFC Chip
      NFC: hci: Extend command execution delay
      NFC: hci: Add load_session HCI operand
      NFC: st21nfca: Implement load_session HCI hook
      NFC: st21nfca: Fix sparse: cast to restricted __be16
      NFC: hci: Fix sparse: cast to restricted __be16
      NFC: st21nfca: Fix warning: array subscript is above array bounds
      NFC: st21nfca: Remove sporadic wait_tab variable from functions.
      NFC: st21nfca: Add __packed to struct st21nfca_pipe_info
      NFC: st21nfca: st21nfca_hci_i2c_probe returns st21nfca_hci_probe result.
      NFC: st21nfca: Reworked st21nfca_request_resources
      NFC: st21nfca: Improve st21nfca initialization by handling reboot properly
      NFC: st21nfca: Remove few useless include
      NFC: st21nfca: Fix incorrect byte stuffing revocation
      NFC: st21nfca: Fix st21nfca_hci_remove_len_crc tail room handling
      NFC: st21nfca: Improved i2c Rx data correctness check
      NFC: st21nfca: Synchronize i2c Tx and Rx path
      NFC: st21nfca: Free buffer when a bad frame is detected
      NFC: dts: st21nfca: Add device-tree (Open Firmware) support to st21nfca
      NFC: dts: st21nfca_i2c: Add DTS Documentation
      NFC: st21nfca: Improve load_session
      NFC: st21nfca: Add ISO15693 Reader/Writer support

Clement Perrochaud (3):
      NFC: pn544: i2c: Add device-tree (Open Firmware) support to PN544
      NFC: pn544: i2c: Add DTS Documentation
      NFC: pn544_i2c: Fix null pointer exception when not using platform data

Hiren Tandel (3):
      NFC: NCI: No need to reverse ATR_RES Response
      NFC: Add RAW socket type support for SOCKPROTO_RAW
      NFC: NCI: Send all NCI frames to raw sockets

Mark A. Greer (18):
      NFC: trf7970a: Increase TRF7970A_WAIT_FOR_RX_DATA_TIMEOUT to 20 ms
      NFC: trf7970a: Only abort a command if one is active
      NFC: trf7970a: Clear 'NFC Target Detection Level' register
      NFC: trf7970a: Reset FIFO when 'End of TX' Interrupt Occurs
      NFC: trf7970a: Only write 'ISO Control' when its changing
      NFC: trf7970a: Set 'Modulator and SYS_CLK Control' after 'ISO Control'
      NFC: trf7970a: Allow different Modulator and SYS_CLK Control register values
      NFC: trf7970a: Set correct Vin voltage in Chip Status Control register
      NFC: trf7970a: Turn RF on after hardware is configured
      NFC: trf7970a: Add pm_runtime support
      NFC: trf7970a: Don't return value from trf7970a_switch_rf_on()
      NFC: trf7970a: Add 'autosuspend-delay' DTS property
      NFC: trf7970a: Document the 'autosuspend-delay' DTS property
      NFC: digital: Add macros for the ISO/IEC 14443-B Protocol
      NFC: digital: Add support for ISO/IEC 14443-B Protocol
      NFC: trf7970a: Add support for the ISO/IEC 14443-B and Type 4B tags
      NFC: digital: SENSF_RES excludes RD when SENSF_REQ RC is zero
      NFC: digital: Handle multiple SENSF_REQ frames

 .../devicetree/bindings/net/nfc/pn544.txt          |  35 +
 .../devicetree/bindings/net/nfc/st21nfca.txt       |  33 +
 .../devicetree/bindings/net/nfc/trf7970a.txt       |   2 +
 drivers/nfc/Kconfig                                |   1 +
 drivers/nfc/Makefile                               |   1 +
 drivers/nfc/pn544/i2c.c                            | 154 ++++-
 drivers/nfc/st21nfca/Kconfig                       |  23 +
 drivers/nfc/st21nfca/Makefile                      |   8 +
 drivers/nfc/st21nfca/i2c.c                         | 724 +++++++++++++++++++++
 drivers/nfc/st21nfca/st21nfca.c                    | 698 ++++++++++++++++++++
 drivers/nfc/st21nfca/st21nfca.h                    |  87 +++
 drivers/nfc/trf7970a.c                             | 252 +++++--
 include/linux/platform_data/st21nfca.h             |  32 +
 include/net/nfc/digital.h                          |   4 +
 include/net/nfc/hci.h                              |   1 +
 include/net/nfc/nfc.h                              |   3 +
 include/uapi/linux/nfc.h                           |  16 +-
 net/nfc/digital.h                                  |   1 +
 net/nfc/digital_core.c                             |  20 +-
 net/nfc/digital_technology.c                       | 230 ++++++-
 net/nfc/hci/command.c                              |   6 +-
 net/nfc/hci/core.c                                 |  47 +-
 net/nfc/llcp_commands.c                            |   2 +-
 net/nfc/llcp_core.c                                |  11 +-
 net/nfc/nci/core.c                                 |   9 +
 net/nfc/nci/ntf.c                                  |   7 +-
 net/nfc/nfc.h                                      |   6 +
 net/nfc/rawsock.c                                  |  94 ++-
 28 files changed, 2368 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st21nfca.txt
 create mode 100644 drivers/nfc/st21nfca/Kconfig
 create mode 100644 drivers/nfc/st21nfca/Makefile
 create mode 100644 drivers/nfc/st21nfca/i2c.c
 create mode 100644 drivers/nfc/st21nfca/st21nfca.c
 create mode 100644 drivers/nfc/st21nfca/st21nfca.h
 create mode 100644 include/linux/platform_data/st21nfca.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
