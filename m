Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38065 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab2EJJOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:30 -0400
Received: by wibhr2 with SMTP id hr2so243375wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 00/78] 18xx chip support
Date: Thu, 10 May 2012 12:13:05 +0300
Message-Id: <1336641263-5761-1-git-send-email-arik@wizery.com> (sfid-20120510_111435_493579_C44AA9A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds initial support for the 18xx chip family. The new
module uses wlcore for functionality common with the 12xx family.

Arik Nemtsov (28):
  wl18xx: create per-chip-family private storage
  wl18xx: set the number of Tx descriptors
  wl18xx: set normal/GEM Tx spare block counts
  wl18xx: implement hw op for calculating hw block count per packet
  wl18xx: implement hw op for setting blocks in hw_tx_desc
  wl18xx: implement hw op for setting frame length in tx_hw_desc
  wl18xx: define HW-rate translation elements/tables
  wl18xx: add fw_status private data
  wl18xx: set Rx block-size alignment quirk
  wl18xx: implement hw op for getting rx buffer data alignment
  wl18xx: implement hw op for getting rx packet data length
  wl18xx: implement immediate Tx completion
  wlcore/wl18xx: add hw op for setting Tx HW checksum
  wlcore/wl18xx: add hw op for Rx HW checksum
  wlcore: track current channel type per vif
  wl18xx: send channel type to FW on role start
  wl18xx: ipmlement ap_rate_mask hw op
  wlcore: support peer MIMO rates
  wlcore/wl18xx: enable MIMO/wide-chan rates in AP-mode rate config
  wl18xx: set HT capabilities
  wl18xx: add module param for overriding HT caps
  wl18xx: read FW pc on recovery
  wl18xx: disable FW log functionality
  wl18xx: implement hw op to read PG version
  wl18xx: init Tx-released index to 0 on HW init
  wl18xx: don't upload NVS to FW
  wl18xx: change board type enum according to new FW
  wlcore/wl12xx/18xx: split fw_status struct into two

Assaf Azulay (1):
  wl18xx: change default tcp_checksum to false

Luciano Coelho (49):
  wl18xx: add new module
  wlcore_sdio/wl18xx: use SDIO revision number to identify wl18xx chips
  wl18xx: add empty operations struct
  wl18xx: add partition table
  wl18xx: add register table
  wl18xx: add identify chip operation
  wl18xx: add some boot operations and hw-specific configurations
  wl18xx: add trigger command and ack event operations
  wl18xx: add hw_init operation
  wl18xx: add runtime configuration parameters
  wl18xx: add board type module argument
  wl18xx: translate and write the board type to SCR_PAD2
  wl18xx: read clock frequency and do top init accordingly
  wlcore: rename wl12xx.h to wlcore_i.h
  wlcore/wl12xx: move ref_clock and tcxo_clock elements to wl12xx
  wlcore/wl12xx: move rx_mem_pool_addr element to wl12xx
  wlcore/wl12xx: add plt_init op and move the code to wl12xx
  wl18xx: add plt_init operation
  wl18xx: change the low_band_component_type for HDK boards
  wl18xx: add number of antennas and dc2dc type as module params
  wl18xx: add module parameter to disable TCP checksum
  wl18xx: derive the MAC address from the BD_ADDR in fuse ROM
  wl18xx: add a module parameter to control 11a support
  wlcore: add module parameter to dump SDIO reads and writes
  wl18xx: copy the default configuration before checking the board_type
  wl18xx: changed default board_type to HDK
  wlcore: add space for private area when allocating fw_status
  wl18xx: change low_band_component_type value for COM8
  wlcore: reorder identify_chip and get_hw_info
  wl18xx: disable MCS_13 for wl18xx PG 1.0
  wlcore: update beacon and probe_resp templates when rates change
  wlcore: use all AP basic rates as default
  wlcore: abstract debugfs fw_stats to be handled by the lower drivers
  wlcore: add debugfs macro to help print fw statistics arrays
  wl12xx: implement fw status debugfs entries
  wl18xx: implement fw status debugfs entries
  wlcore: create private static_data area and add operation to parse it
  wl18xx: print the PHY firmware version from the private static data
  wlcore: print the interrupt status when recovery is triggered
  wl18xx: don't use MIMO when ht_mode is set to wide
  wlcore: use proper values for supported local rates
  wl18xx: add module parameter to force SISO 20MHz
  wl18xx: add power limit reference value to mac_and_phy settings
  wl18xx: export low/high band component values as module params
  wl18xx: export pwr_limit_reference_11_abg value as a module parameter
  wlcore/wl12xx/wl18xx: move lower driver debugfs to a subdir
  wlcore: increase aggregation buffer size by one page
  wl18xx: increase tx_ba_win_size to 64
  wl18xx: use new fw stats structures

 drivers/net/wireless/ti/Kconfig           |    1 +
 drivers/net/wireless/ti/Makefile          |    1 +
 drivers/net/wireless/ti/wl12xx/Makefile   |    2 +-
 drivers/net/wireless/ti/wl12xx/acx.h      |  223 +++++
 drivers/net/wireless/ti/wl12xx/cmd.c      |    8 +-
 drivers/net/wireless/ti/wl12xx/debugfs.c  |  243 ++++++
 drivers/net/wireless/ti/wl12xx/debugfs.h  |   28 +
 drivers/net/wireless/ti/wl12xx/main.c     |  164 +++-
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    8 +
 drivers/net/wireless/ti/wl18xx/Kconfig    |    6 +
 drivers/net/wireless/ti/wl18xx/Makefile   |    3 +
 drivers/net/wireless/ti/wl18xx/acx.c      |   83 ++
 drivers/net/wireless/ti/wl18xx/acx.h      |  241 ++++++
 drivers/net/wireless/ti/wl18xx/conf.h     |   53 ++
 drivers/net/wireless/ti/wl18xx/debugfs.c  |  309 +++++++
 drivers/net/wireless/ti/wl18xx/debugfs.h  |   28 +
 drivers/net/wireless/ti/wl18xx/io.c       |   60 ++
 drivers/net/wireless/ti/wl18xx/io.h       |   28 +
 drivers/net/wireless/ti/wl18xx/main.c     | 1282 +++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h      |  241 ++++++
 drivers/net/wireless/ti/wl18xx/tx.c       |  126 +++
 drivers/net/wireless/ti/wl18xx/tx.h       |   42 +
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |   87 ++
 drivers/net/wireless/ti/wlcore/acx.c      |    8 +-
 drivers/net/wireless/ti/wlcore/acx.h      |  227 +----
 drivers/net/wireless/ti/wlcore/boot.c     |   53 +-
 drivers/net/wireless/ti/wlcore/boot.h     |    1 +
 drivers/net/wireless/ti/wlcore/cmd.c      |   34 +-
 drivers/net/wireless/ti/wlcore/cmd.h      |   11 +-
 drivers/net/wireless/ti/wlcore/conf.h     |   16 +-
 drivers/net/wireless/ti/wlcore/debugfs.c  |  283 +------
 drivers/net/wireless/ti/wlcore/debugfs.h  |   87 ++
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   48 ++
 drivers/net/wireless/ti/wlcore/init.c     |    3 +
 drivers/net/wireless/ti/wlcore/main.c     |  362 ++++----
 drivers/net/wireless/ti/wlcore/rx.c       |   11 +-
 drivers/net/wireless/ti/wlcore/rx.h       |    7 +-
 drivers/net/wireless/ti/wlcore/sdio.c     |   35 +-
 drivers/net/wireless/ti/wlcore/tx.c       |   11 +-
 drivers/net/wireless/ti/wlcore/tx.h       |   26 +-
 drivers/net/wireless/ti/wlcore/wl12xx.h   |  507 ------------
 drivers/net/wireless/ti/wlcore/wlcore.h   |   42 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  508 ++++++++++++
 43 files changed, 4306 insertions(+), 1241 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl18xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/main.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/reg.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/wl18xx.h
 delete mode 100644 drivers/net/wireless/ti/wlcore/wl12xx.h
 create mode 100644 drivers/net/wireless/ti/wlcore/wlcore_i.h

-- 
1.7.9.5

