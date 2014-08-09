Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:37561 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaHISHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 14:07:54 -0400
Subject: [PATCH v6 0/8] ath10k: firmware crash dump
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 09 Aug 2014 21:07:48 +0300
Message-ID: <20140809180552.29215.58612.stgit@potku.adurom.net> (sfid-20140809_200757_320787_7A63C1BD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next version of ath10k firmware crash dump feature, based on Ben's patches but
heavily modified.

v6:

* fix vzalloc(sizeof(ar->debug.fw_crash_data)), fixes the crash I saw (Ben)

* "Target Register Dump" -> "firmware register dump"

* add ath10k_print_driver_info()

* take timestamp at crash time instead of crash-dump-gather time (Ben)

* fix locking comment in struct ath10k::fw (Ben)

* move "crash_data->crashed_since_read = true" to
  ath10k_debug_get_new_few_crash_data()

* ath10k_pci_hif_dump_area() holds the lock all the time so that we
  can guarantee that changes to ath10k_fw_crash_data are atomic

* take data_lock earlier in ath10k_build_dump_file() so that all
  access to crash_data is protected

* rename debugfs file fw_crash_dump

* fw_crash_dump debugfs files returns -ENODATA if there's no new
  crash dump

* store bss addresses and lengths as u32 in struct ath10k::fw

v5:

* dump_data->tv_sec and tv_nsec to 64 bits (because long can be 32 bits
  on some platforms)

* fix long lines

* renamed ath10k_dbg_save_fw_dbg_buffer() to ath10k_debug_dbglog_add()

* add helpers for ath10k_pci_diag* functions

* refactor and rename ath10k_pci_hif_dump_area()

* latest crash dump is always stored (instead of the oldest unread)

* add ath10k_debug_get_fw_crash_data()

* move fw_r?m_bss_* fields to ar->fw

* struct ath10k_fw_crash_data is allocated with vmalloc()

* atomic allocation in ath10k_pci_dump_bss() is bad, fix that by using vmalloc
  in module initialisation

* separate FW IE entries for BSS regions

* don't use ath10k_err()

* simplify locking and memory allocation for FW IE handling

* add uuid

* move struct ath10k_dump_file_data and enum ath10k_fw_error_dump_type to debug.c

* function and variable naming, using ath10k_fw_crash_ prefix etc

* change warning and debug messages to follow ath10k style

* add ath10k_debug_get_new_fw_crash_data() to avoid ifdefs in pci.c

TODO for the future:

* atomic allocation in ath10k_pci_dump_dbglog() is bad. Should we
  allocate a big buffer with vmalloc and use that?

* dynamic allocation for BSS buffers


---

Ben Greear (5):
      ath10k: provide firmware crash info via debugfs
      ath10k: save firmware debug log messages
      ath10k: save firmware stack upon firmware crash
      ath10k: dump exception stack contents on firmware crash
      ath10k: save firmware RAM and ROM BSS sections on crash

Kalle Valo (3):
      ath10k: add ath10k_pci_diag_* helpers
      ath10k: rename ath10k_pci_hif_dump_area() to ath10k_pci_firmware_crashed()
      ath10k: print more driver info when firmware crashes


 drivers/net/wireless/ath/ath10k/core.c  |   71 +++++-
 drivers/net/wireless/ath/ath10k/core.h  |   45 ++++
 drivers/net/wireless/ath/ath10k/debug.c |  341 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   23 ++
 drivers/net/wireless/ath/ath10k/hw.h    |   36 +++
 drivers/net/wireless/ath/ath10k/pci.c   |  257 +++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/pci.h   |    3 
 drivers/net/wireless/ath/ath10k/wmi.c   |   10 +
 8 files changed, 743 insertions(+), 43 deletions(-)

