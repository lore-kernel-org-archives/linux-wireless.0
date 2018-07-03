Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752948AbeGCKyM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 06:54:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-07-03
Date: Tue, 03 Jul 2018 13:54:07 +0300
Message-ID: <87tvpgr3n4.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_125430_131917_8F64DAC0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

this is the first pull request to net tree for 4.18, more info below and
please let me know if you have any problems.

Kalle

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-07-03

for you to fetch changes up to 4fa9433f950a3df0c180be37f14efe033198aa24:

  Merge ath-current from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-06-29 13:29:17 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.18

First set of fixes for 4.18 and for numerous drivers. Something to mention
about is the wcn36xx fix which makes it possible to compile with gcc older than
4.4 (though I'm not sure if we even support those anymore).

qtnfmac

* coverity fix for a new commit in v4.18-rc1

rtlwifi

* fix kernel oops during driver removal

* fix firmware image corruption for rtl8821ae

brcmfmac

* fix crash if there's no firmware image

mwifiex

* a revert and a better fix for a new commit v4.18-rc1

mt7601u

* fix a recent regression about unnecessary warning about avg_rssi

wcn36xx

* convert testmode.c to plain ASCII

ath10k

* fix a firmware crash during bandwidth change

----------------------------------------------------------------
Ganapathi Bhat (2):
      Revert "mwifiex: handle race during mwifiex_usb_disconnect"
      mwifiex: handle race during mwifiex_usb_disconnect

Geert Uytterhoeven (1):
      wcn36xx: Remove Unicode Byte Order Mark from testcode

Gustavo A. R. Silva (1):
      qtnfmac: fix NULL pointer dereference

Kalle Valo (1):
      Merge ath-current from git://git.kernel.org/.../kvalo/ath.git

Michael Trimarchi (1):
      brcmfmac: stop watchdog before detach and free everything

Ping-Ke Shih (2):
      rtlwifi: Fix kernel Oops "Fw download fail!!"
      rtlwifi: rtl8821ae: fix firmware is not ready to run

Ryan Hsu (1):
      ath10k: update the phymode along with bandwidth change request

Stanislaw Gruszka (1):
      mt7601u: remove warning when avg_rssi is zero

Xinming Hu (1):
      MAINTAINERS: update Xinming's email address

 MAINTAINERS                                             |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c                   | 16 ++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h                   |  1 +
 drivers/net/wireless/ath/wcn36xx/testmode.c             |  2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |  7 +++++++
 drivers/net/wireless/marvell/mwifiex/usb.c              |  7 ++-----
 drivers/net/wireless/mediatek/mt7601u/phy.c             |  6 ++++--
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c       |  3 +--
 drivers/net/wireless/realtek/rtlwifi/base.c             | 17 ++++++++++-------
 drivers/net/wireless/realtek/rtlwifi/base.h             |  2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c             |  3 +--
 drivers/net/wireless/realtek/rtlwifi/pci.c              |  2 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c               |  4 ++--
 drivers/net/wireless/realtek/rtlwifi/usb.c              |  2 +-
 14 files changed, 47 insertions(+), 27 deletions(-)
