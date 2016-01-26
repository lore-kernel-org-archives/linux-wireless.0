Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37858 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934265AbcAZKUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:20:18 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Kalle Valo <kvalo@adurom.com> Kalle Valo" <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2016-01-26
Date: Tue, 26 Jan 2016 10:19:08 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com> (sfid-20160126_112024_489342_95CD6887)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is the first round of fixes for 4.5.
Most of them are really trivial. The TPC stats one stands out a little bit.
It can fix traffic issues which are typically hard to debug.
Please pull and let me know if you have issues.

I also have a batch of patches for -next, but wireless-drivers-next.git doesn't
seem ready to accept new patches at this stage.

Thanks!

The following changes since commit aee3bfa3307cd0da2126bdc0ea359dabea5ee8f7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2016-01-12 18:57:02 -0800)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2016-01-26

for you to fetch changes up to a0d792850af3257d9b4b1dbf4e3df57994a481e7:

  iwlwifi: mvm: rs: fix TPC statistics handling (2016-01-25 14:42:11 +0200)

----------------------------------------------------------------
* Fix support for 3168 device
	+ NVM version
	+ firmware file name
	+ device IDs
* Fix a compilation warning in dvm calibration code
* Fix the TPC (reduced Tx Power) code. This fixes performance issues
* Device IDs for 8265

----------------------------------------------------------------
Gregory Greenman (1):
      iwlwifi: mvm: rs: fix TPC statistics handling

Johannes Berg (1):
      iwlwifi: dvm: calib.c: fix min() warning

Oren Givon (3):
      iwlwifi: add new 3168 series devices support
      iwlwifi: add device ID for 8265
      iwlwifi: update support for 3168 series firmware and NVM

 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      | 23 +++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 74 ++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  5 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  4 ++++
 6 files changed, 81 insertions(+), 35 deletions(-)

