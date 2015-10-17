Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41460 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbJQF00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 01:26:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2015-10-17
Date: Sat, 17 Oct 2015 08:26:19 +0300
Message-ID: <878u72gj5w.fsf@kamboji.qca.qualcomm.com> (sfid-20151017_072710_674385_9050D56E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

few small fixes I would like to get to 4.3 still. Please let me know if
there are any problems.

Kalle

The following changes since commit 76d164f582150fd0259ec0fcbc485470bcd8033e:

  ath10k: fix DMA related firmware crashes on multiple devices (2015-09-26 20:48:25 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2015-10-17

for you to fetch changes up to de28a05ee28e36fa1fc68fcfc7c6cc1c6f7c270c:

  Merge tag 'iwlwifi-for-kalle-2015-10-05' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2015-10-07 11:12:01 +0300)

----------------------------------------------------------------

iwlwifi:

* mvm: flush fw_dump_wk when mvm fails to start
* mvm: init card correctly on ctkill exit check
* pci: add a few more PCI subvendor IDs for the 7265 series
* fix firmware filename for 3160
* mvm: clear csa countdown when AP is stopped
* mvm: fix D3 firmware PN programming
* dvm: fix D3 firmware PN programming
* mvm: fix D3 CCMP TX PN assignment

rtlwifi:

* rtl8821ae: Fix system lockups on boot

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

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2015-10-05' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Larry Finger (1):
      rtlwifi: rtl8821ae: Fix system lockups on boot

Luca Coelho (1):
      iwlwifi: pci: add a few more PCI subvendor IDs for the 7265 series

 drivers/net/wireless/iwlwifi/dvm/lib.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c     |    2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c       |   27 +++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/fw.c       |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    5 +++++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    1 +
 drivers/net/wireless/iwlwifi/pcie/drv.c     |    5 +++++
 drivers/net/wireless/rtlwifi/pci.h          |    2 ++
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c |   17 +++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/sw.c |    5 +++++
 drivers/net/wireless/rtlwifi/wifi.h         |    3 +++
 12 files changed, 54 insertions(+), 20 deletions(-)

-- 
Kalle Valo
