Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbeCXLDV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 07:03:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-03-24
Date: Sat, 24 Mar 2018 13:03:13 +0200
Message-ID: <87sh8prb0u.fsf@kamboji.qca.qualcomm.com> (sfid-20180324_120339_230077_C8A2A739)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

This is a pull request to the net tree for 4.16. I'm not planning to
send anything more in this cycle for 4.16, unless something really major
comes up.

Please let me know if you have any problems.

Kalle

The following changes since commit 87de1201ddaa39d4f3fafa9f35ac143e582517e6:

  Merge branch 'erspan-fixes' (2018-03-09 13:03:57 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git =
tags/wireless-drivers-for-davem-2018-03-24

for you to fetch changes up to 9b9322db5c5a1917a66c71fe47c3848a9a31227e:

  brcmfmac: Fix check for ISO3166 code (2018-03-20 12:07:58 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.16

Some fixes for 4.16, only for iwlwifi and brcmfmac this time. All
pretty small.

iwlwifi

* fix an issue with the multicast queue

* fix IGTK handling

* fix some missing return value checks

* add support for a HW workaround for issues on some platforms

* a couple of fixes for channel-switch

* a few fixes for the aggregation handling code

brcmfmac

* drop Inter-Access Point Protocol packets by default

* fix check for ISO3166 regulatory code

----------------------------------------------------------------
Andrei Otcheretianski (2):
      iwlwifi: mvm: Increase session protection time after CS
      iwlwifi: mvm: Move unused phy's to a default channel

Avraham Stern (3):
      iwlwifi: mvm: clear tx queue id when unreserving aggregation queue
      iwlwifi: mvm: make sure internal station has a valid id
      iwlwifi: mvm: fix array out of bounds reference

Beni Lev (1):
      iwlwifi: mvm: Correctly set IGTK for AP

Emmanuel Grumbach (1):
      iwlwifi: mvm: set the correct tid when we flush the MCAST sta

Johannes Berg (1):
      iwlwifi: mvm: fix error checking for multi/broadcast sta

Kalle Valo (2):
      Merge tag 'iwlwifi-for-kalle-2018-03-16' of git://git.kernel.org/.../=
iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2018-03-19' of git://git.kernel.org/.../=
iwlwifi/iwlwifi-fixes

Luca Coelho (1):
      iwlwifi: add shared clock PHY config flag for some devices

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: drop Inter-Access Point Protocol packets by default

Stefan Wahren (1):
      brcmfmac: Fix check for ISO3166 code

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  5 ++
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 57 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      | 62 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  | 21 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 74 ++++++++++--------=
----
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 15 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 10 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 38 +++++------
 15 files changed, 225 insertions(+), 82 deletions(-)
