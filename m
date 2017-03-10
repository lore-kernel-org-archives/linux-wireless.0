Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:46004 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933646AbdCJVR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 16:17:26 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/5] brcmfmac: only use fwsignal functionality for bcdc protocol
Date: Fri, 10 Mar 2017 21:17:01 +0000
Message-Id: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170310_221743_515446_BA6F864F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is rework in the driver getting fwsignal out of the way for
protocols that do not need it. For example PCIe devices do not need that
functionality. To summarize:

  * use fwsignal functionality only for bcdc protocol.

This series applies to the master branch of the wireless-drivers-next
repository. 

Franky Lin (5):
  brcmfmac: move brcmf_txflowblock to bcdc layer
  brcmfmac: move brcmf_txcomplete to bcdc layer
  brcmfmac: wrap brcmf_fws_add_interface into bcdc layer
  brcmfmac: wrap brcmf_fws_del_interface into bcdc layer
  brcmfmac: wrap brcmf_fws_reset_interface into bcdc layer

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 51 ++++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |  3 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  5 ---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 34 ++-------------
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  6 +--
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   | 27 ++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  8 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  7 +--
 8 files changed, 96 insertions(+), 45 deletions(-)

-- 
1.9.1
