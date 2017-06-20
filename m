Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdFTNkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 09:40:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2017-06-20
Date: Tue, 20 Jun 2017 16:39:59 +0300
Message-ID: <877f06ydzk.fsf@kamboji.qca.qualcomm.com> (sfid-20170620_154030_266406_C8B80311)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull request to net tree, few important fixes still I would
like to have in 4.12. Please let me know if there are any problems.

Kalle

The following changes since commit dc89481bb4c9af0700423e21c8371379d3d943b1:

  Merge tag 'iwlwifi-for-kalle-2017-06-05' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2017-06-05 22:21:25 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2017-06-20

for you to fetch changes up to 35abcd4f9f303ac4f10f99b3f7e993e5f2e6fa37:

  brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2() (2017-06-16 11:52:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.12

Two important fixes for brcmfmac. The rest of the brcmfmac patches are
either code preparation and fixing a new build warning.

brcmfmac

* fix a NULL pointer dereference during resume

* fix a NULL pointer dereference with USB devices, a regression from
  v4.12-rc1

----------------------------------------------------------------
Arend Van Spriel (5):
      brcmfmac: add parameter to pass error code in firmware callback
      brcmfmac: use firmware callback upon failure to load
      brcmfmac: unbind all devices upon failure in firmware callback
      brcmfmac: fix brcmf_fws_add_interface() for USB devices
      brcmfmac: fix uninitialized warning in brcmf_usb_probe_phase2()

 .../broadcom/brcm80211/brcmfmac/firmware.c         | 35 +++++++++++-----------
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  4 +--
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 17 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 18 +++++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  9 +++---
 6 files changed, 49 insertions(+), 36 deletions(-)
