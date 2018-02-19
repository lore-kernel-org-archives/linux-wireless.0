Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47981 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932169AbeBSXOd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:33 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/8] brcmfmac: cleanup and some rework
Date: Tue, 20 Feb 2018 00:14:17 +0100
Message-Id: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001444_718247_1403B2DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is intended for 4.17 and includes following:

 * rework bus layer attach code.
 * remove duplicate variable declaration.

These patches apply to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (8):
  brcmfmac: move brcmf_bus_preinit() call just after changing bus state
  brcmfmac: move allocation of control rx buffer to
    brcmf_sdio_bus_preinit()
  brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()
  brcmfmac: usb: call brcmf_usb_up() during brcmf_bus_preinit()
  brcmfmac: move brcmf_attach() function in core.c
  brcmfmac: remove brcmf_bus_started() from bus api
  brcmfmac: change log level for some low-level sdio functions
  brcmfmac: remove duplicate pointer variable from
    brcmf_sdio_firmware_callback()

 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   1 -
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   3 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 119 ++++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  20 +---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  95 ++++++++--------
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  35 ++----
 6 files changed, 117 insertions(+), 156 deletions(-)

-- 
1.9.1
