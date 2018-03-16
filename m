Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:45700 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751783AbeCPKLe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:11:34 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 00/12] brcmfmac: data structure and firmware loading rework
Date: Fri, 16 Mar 2018 11:11:13 +0100
Message-Id: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180316_111243_681137_A3BFBE91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is intended for 4.17 containing the following:

  * use wiphy_priv() for storing main driver instance.
  * add driver debugfs entries under wiphy debugfsdir.
  * rework firmware loading module.
  * rework clm_blob loading.

The patches apply to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (12):
  brcmfmac: do not convert linux error to firmware error string
  brcmfmac: use brcmf_chip_name() to store name in revinfo
  brcmfmac: use brcmf_chip_name() for consistency
  brcmfmac: allocate struct brcmf_pub instance using wiphy_new()
  brcmfmac: use wiphy debugfs dir entry
  brcmfmac: derive firmware filenames from basename mapping
  brcmfmac: pass struct in brcmf_fw_get_firmwares()
  brcmfmac: introduce brcmf_fw_alloc_request() function
  brcmfmac: add extension to .get_fwname() callbacks
  brcmfmac: get rid of brcmf_fw_map_chip_to_name()
  brcmfmac: get rid of brcmf_fw_get_full_name()
  brcmfmac: add kerneldoc for struct brcmf_bus::msgbuf

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |   6 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  88 ++++----
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  71 ++----
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  48 ++--
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |  42 +---
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |  17 --
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   3 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   7 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 242 ++++++++++++++-------
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  82 ++++---
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |   3 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  11 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 157 +++++++------
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 151 ++++++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  96 +++++---
 24 files changed, 618 insertions(+), 470 deletions(-)

--
1.9.1
