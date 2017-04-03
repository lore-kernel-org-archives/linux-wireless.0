Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59496 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdDCL0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 07:26:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2017-04-03
Date: Mon, 03 Apr 2017 14:26:10 +0300
Message-ID: <87a87xohpp.fsf@kamboji.qca.qualcomm.com> (sfid-20170403_132714_003987_7EB08CFC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here few really small fixes. I'm hoping this to be the last pull request
for 4.11.

Please let me if there are any problems.

Kalle

The following changes since commit 6be3b6cce1e225f189b68b4e84fc711d19b4277b:

  ath10k: fix incorrect wlan_mac_base in qca6174_regs (2017-03-20 17:11:31 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2017-04-03

for you to fetch changes up to d77facb88448cdeaaa3adba5b9704a48ac2ac8d6:

  brcmfmac: use local iftype avoiding use-after-free of virtual interface (2017-03-30 19:43:51 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.11

iwlwifi

* an RCU fix
* a fix for a potential out-of-bounds access crash
* a fix for IBSS which has been broken since DQA was enabled

rtlwifi

* fix scheduling while atomic regression

brcmfmac

* fix use-after-free bug found by KASAN

----------------------------------------------------------------
Arend Van Spriel (1):
      brcmfmac: use local iftype avoiding use-after-free of virtual interface

Dan Carpenter (1):
      iwlwifi: mvm: writing zero bytes to debugfs causes a crash

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2017-03-29' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Larry Finger (1):
      rtlwifi: Fix scheduling while atomic splat

Liad Kaufman (1):
      iwlwifi: mvm: support ibss in dqa mode

Sara Sharon (1):
      iwlwifi: mvm: fix accessing fw_id_to_mac_id

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 8 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c       | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c      | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           | 9 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c            | 7 +++++--
 drivers/net/wireless/realtek/rtlwifi/base.c            | 6 ++++--
 7 files changed, 25 insertions(+), 12 deletions(-)
