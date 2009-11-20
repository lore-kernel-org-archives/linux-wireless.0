Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbZKTUFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:05 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/19]  iwlwifi updates 11/20/2009
Date: Fri, 20 Nov 2009 12:04:51 -0800
Message-Id: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes various fixes and cleanup. Driver is now able to do
single byte writes to treat registers with single-byte fields correctly
and not rely on execution order. A previous patch "iwlwifi:
separate led function from statistic notification" broke LEDs on 3945. This
is now fixed. Some more LED cleanup is also included. More work surrounding
SM PS is included. debugfs received some attention with files now having
correct permissions, all TX queue information can now be displayed, memory
for display of sram contents is now dynamically allocated, and if a user
did not specify the offset and length when dumping sram contents then the
entire data portion will be printed. It is now possible
to separate IO tracing to reduce amount of data. The pci ids of 5000 series
is updated to reflect what is in production. A uCode error log as well as
portion of the event log is now always printed when a problem occurs, user
does not need to set debug flags. Driver now informs uCode promptly when
disassociated to prevent uCode from sending data to AP.

"iwlwifi: no need to set use_rts_for_ht for BG device" fixes a merge
problem that is present in wireless-testing but not in wireless-next-2.6

Ben M Cahill (2):
  iwlwifi: Add iwl_write8()
  iwlagn: Use iwl_write8() for CSR_INT_COALESCING register

Jay Sternberg (1):
  iwlwifi: Tell the ucode immediately when association state changes

Johannes Berg (1):
  iwlwifi: separate IO tracing

Reinette Chatre (2):
  iwl3945: removed unused struct and definitions
  iwlwifi: no need to set use_rts_for_ht for BG device

Wey-Yi Guy (13):
  iwlwifi: control led while update tx/rx bytes counts
  iwlwifi: set sm_ps_mode as part of cfg parameters
  iwlwifi: reset led_tpt when clear tx/rx traffic byte counts
  iwlwifi: set read/write permission for debugfs files
  iwlwifi: increase tx_queue debugfs buffer size
  iwlwifi: dynamically allocate buffer for sram debugfs file
  iwlwifi: fix reserved2 field in iwl4965_addsta
  iwlwifi: update supported PCI_ID list for 5xx0 series
  iwlwifi: by default, dump entire sram data portion
  iwlwifi: dump error log when uCode error occurred
  iwlwifi: print limited number of event log when uCode error
  iwlwifi: change message for cmd queue full error
  iwlwifi: remove reset led_tpt from iwl_leds_init()

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   11 +--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   33 +++++-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |  174 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   76 ++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   22 +---
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  125 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 +--
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   21 +++-
 drivers/net/wireless/iwlwifi/iwl-io.h       |   20 +++
 drivers/net/wireless/iwlwifi/iwl-led.c      |    1 -
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 ++++++++++--
 20 files changed, 395 insertions(+), 204 deletions(-)

