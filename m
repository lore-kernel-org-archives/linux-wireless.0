Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab0AOVnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/9] iwlwifi updates for 2.6.34
Date: Fri, 15 Jan 2010 13:43:32 -0800
Message-Id: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few patches are in the statistics area. There will now be more accurate
accumulate statistics. Two patches also increase the amount of statistics
information available. Some code cleanup is done to use macros instead of
constant values, also reworked some return codes so that a calling function
does not have to do any interpretation.

A hardware bug is now worked around in the driver. This is not a candidate
for earlier kernels since even though an interrupt is lost in this case the
data received will be handled in next interrupt. A new addition to iwlwifi
debugging is to print out the contents of flow handler registers when
firmware error occurs.

We also update the copyright year to 2010.

These patches are also available from wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Reinette Chatre (1):
  iwlwifi: update copyright year to 2010

Wey-Yi Guy (8):
  iwlwifi: fix clear statistics counter command
  iwlwifi: format and show statistics counter from uCode
  iwlwifi: add num_of_sos_stats to statistics counter
  iwlwifi: correct return code for log_event
  iwlwifi: set interrupt coalescing timer range and default
  iwlwifi: software w/a for h/w bug cause Rx bit get clear
  iwlwifi: display flowhandler register when sw error or on-demand
  iwlwifi: remove extra statistics request from debugfs

 drivers/net/wireless/iwlwifi/iwl-1000.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   11 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   81 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |  928 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   19 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h       |   23 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   27 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +-
 47 files changed, 770 insertions(+), 443 deletions(-)

