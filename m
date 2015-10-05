Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56848 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbbJELbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 07:31:11 -0400
Message-ID: <1444044666.27220.5.camel@coelho.fi> (sfid-20151005_133115_114660_F09DFF2A)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: egrumbach@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 05 Oct 2015 14:31:06 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2015-10-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Here's a pull request for 4.3.  There are 8 patches, including a fix
for a kernel panic, some serious PN programming issues, a thermal
monitor fix and some new vendor IDs.

Let me know if there are any issues.

Luca.

The following changes since commit dd5cdb48edfd34401799056a9acf61078d773f90:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2015-09-03 08:08:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-10-05

for you to fetch changes up to dbf73d4a8bb8f4e1d1f3edd3be825692279e2ef3:

  iwlwifi: mvm: flush fw_dump_wk when mvm fails to start (2015-10-05 14:04:16 +0300)

----------------------------------------------------------------
* some fixes for PN key programming when entering D3;
* fix for CSA when the AP is stopped during a channel switch;
* fix firmware name for 3160 devices;
* add some new PCI IDs for 7265 devices;
* fix CT-kill entry;
* fix kernel panic when a sysassert occurs in the init ucode flow;

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: flush fw_dump_wk when mvm fails to start

Arik Nemtsov (1):
      iwlwifi: mvm: init card correctly on ctkill exit check

Avraham Stern (1):
      iwlwifi: mvm: clear csa countdown when AP is stopped

Johannes Berg (4):
      iwlwifi: mvm: fix D3 CCMP TX PN assignment
      iwlwifi: dvm: fix D3 firmware PN programming
      iwlwifi: mvm: fix D3 firmware PN programming
      iwlwifi: fix firmware filename for 3160

Luca Coelho (1):
      iwlwifi: pci: add a few more PCI subvendor IDs for the 7265 series

 drivers/net/wireless/iwlwifi/dvm/lib.c      |  2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 27 +++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/fw.c       |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  5 +++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  1 +
 drivers/net/wireless/iwlwifi/pcie/drv.c     |  5 +++++
 8 files changed, 27 insertions(+), 20 deletions(-)
