Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:44615 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaHUMs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 08:48:57 -0400
Subject: [PATCH v8 0/4] ath10k: firmware crash dump
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Aug 2014 15:48:50 +0300
Message-ID: <20140821124705.27159.67898.stgit@potku.adurom.net> (sfid-20140821_144901_367085_75032B5B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And yet another version of firmware crash dumps. Now I dropped all dumps except
firmware registers and tested all the features myself.

v8:

* ATH10K_FW_CRASH_DUMP_REGDUMP -> ATH10K_FW_CRASH_DUMP_REGISTERS

* drop storing of dbglogs in patch 2

* drop patches adding stack and BSS dumps as they are still untested

* fix endian issue with the register dump

v7:

* really send "ath10k: print more driver info when firmware crashes",
  I had accidentally dropped it in previous series

* add ATH10K_FW_CRASH_DUMP_VERSION (Michal)

* remove extra newline (Michal)

* fix unprotected access of crashed_since_read in
  ath10k_fw_crash_dump_open() (Michal)

* take data_lock only once in ath10k_build_dump_file() (Michal)

* use vzalloc() instead of vmalloc() and memset() in
  ath10k_build_dump_file()

* fix memory leak in ath10k_debug_create() (Michal)

* always use little endian in the dump file and drop endian field from
  the dump file (Michal)

* print uuid in LE format

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

---

Ben Greear (1):
      ath10k: provide firmware crash info via debugfs

Kalle Valo (3):
      ath10k: add ath10k_pci_diag_* helpers
      ath10k: rename ath10k_pci_hif_dump_area() to ath10k_pci_fw_crashed_dump()
      ath10k: print more driver info when firmware crashes


 drivers/net/wireless/ath/ath10k/core.c  |   17 --
 drivers/net/wireless/ath/ath10k/core.h  |   13 ++
 drivers/net/wireless/ath/ath10k/debug.c |  267 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |   16 ++
 drivers/net/wireless/ath/ath10k/hw.h    |    2 
 drivers/net/wireless/ath/ath10k/pci.c   |  104 +++++++++---
 drivers/net/wireless/ath/ath10k/pci.h   |    3 
 7 files changed, 373 insertions(+), 49 deletions(-)

