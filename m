Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:42235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbcBOL6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 06:58:02 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Kalle Valo <kvalo@adurom.com> Kalle Valo" <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-2016-02-16
Date: Mon, 15 Feb 2016 11:57:38 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com> (sfid-20160215_181514_645568_F5C19387)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a pull request for 4.5. Apart from my RF-Kill fix, the patches are
really small. My RF-Kill patch needed to move code around to avoid adding
a forward declaration and on the way there were a few very trivial code style
fixes, that were needed to make checkpatch happy.

Let me know if you have issues, thanks!


The following changes since commit 69c7fda40921c125eeeef6a827f6270ac6aa1baa:

  iwlwifi: mvm: rs: fix TPC statistics handling (2016-01-26 16:03:35 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2016-02-15

for you to fetch changes up to 20aa99bbddae74bded68338f9ba200ccae02858b:

  iwlwifi: pcie: fix erroneous return value (2016-02-15 13:38:31 +0200)

----------------------------------------------------------------
These are a few fixes for the current cycle.
3 out of the 5 patches fix a bugzilla.

* fix a race that users reported when we try to load the firmware
  and the hardware rfkill interrupt triggers at the same time.
* Luca fixes a very visible bug in scheduled scan: our firmware
  doesn't support scheduled scan with no profile configured and
  the supplicant sometimes requests such scheduled scans.
* build system fix
* firmware name update for 8265
* typo fix in return value

----------------------------------------------------------------
Anton Protopopov (1):
      iwlwifi: pcie: fix erroneous return value

Emmanuel Grumbach (2):
      iwlwifi: dvm: remove a wrong dependency on m
      iwlwifi: pcie: fix RF-Kill vs. firmware load race

Luca Coelho (1):
      iwlwifi: mvm: don't allow sched scans without matches to be started

Oren Givon (1):
      iwlwifi: fix name of ucode loaded for 8265 series

 drivers/net/wireless/intel/iwlwifi/Kconfig         |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  42 ++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   9 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 188 ++++++++++++++++++++++++------------------
 7 files changed, 164 insertions(+), 94 deletions(-)

