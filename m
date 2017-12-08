Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753937AbdLHOcW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 09:32:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2017-12-08
Date: Fri, 08 Dec 2017 16:32:16 +0200
Message-ID: <87k1xxqoi7.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_153304_560065_7D4A6D6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

this is a pull request to net tree for 4.15, more info in the signed tag
below. All small fixes and not really expecting any problems, but please
let me know if you have any.

Kalle

The following changes since commit f859b4af1c52493ec21173ccc73d0b60029b5b88:

  sit: update frag_off info (2017-11-30 10:25:41 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2017-12-08

for you to fetch changes up to a41886f56b7bbb88e6a23b5d738a94f2632142a4:

  Merge tag 'iwlwifi-for-kalle-2017-12-05' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2017-12-07 15:50:34 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.15

Second set of fixes for 4.15. This time a lot of iwlwifi patches and
two brcmfmac patches. Most important here are the MIC and IVC fixes
for iwlwifi to unbreak 9000 series.

iwlwifi

* fix rate-scaling to not start lowest possible rate

* fix the TX queue hang detection for AP/GO modes

* fix the TX queue hang timeout in monitor interfaces

* fix packet injection

* remove a wrong error message when dumping PCI registers

* fix race condition with RF-kill

* tell mac80211 when the MIC has been stripped (9000 series)

* tell mac80211 when the IVC has been stripped (9000 series)

* add 2 new PCI IDs, one for 9000 and one for 22000

* fix a queue hang due during a P2P Remain-on-Channel operation

brcmfmac

* fix a race which sometimes caused a crash during sdio unbind

* fix a kernel-doc related build error

----------------------------------------------------------------
Andy Shevchenko (1):
      brcmfmac: Avoid build error with make W=1

Arend Van Spriel (1):
      brcmfmac: change driver unbind order of the sdio function devices

David Spinadel (1):
      iwlwifi: mvm: enable RX offloading with TKIP and WEP

Emmanuel Grumbach (3):
      iwlwifi: mvm: don't use transmit queue hang detection when it is not possible
      iwlwifi: mvm: fix the TX queue hang timeout for MONITOR vif type
      iwlwifi: mvm: fix packet injection

Ihab Zhaika (1):
      iwlwifi: add new cards for 9260 and 22000 series

Johannes Berg (1):
      iwlwifi: mvm: flush queue before deleting ROC

Kalle Valo (2):
      Merge tag 'iwlwifi-for-kalle-2017-11-28' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2017-12-05' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Sara Sharon (3):
      iwlwifi: pcie: fix erroneous "Read failed message"
      iwlwifi: fix access to prph when transport is stopped
      iwlwifi: mvm: mark MIC stripped MPDUs

Shaul Triebitz (1):
      iwlwifi: mvm: set correct chains in Rx status

 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |  4 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  2 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 18 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 53 ++++++++++++++++------
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 24 +++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 13 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  2 +
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |  6 +++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 10 ++++
 15 files changed, 122 insertions(+), 27 deletions(-)

-- 
Kalle Valo
