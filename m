Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:36429 "EHLO
        mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932952AbcISLKL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:11 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/9] brcmfmac: coverity fixes
Date: Mon, 19 Sep 2016 12:09:50 +0100
Message-Id: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131032_223211_337CE8FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series consist of:
* fixes for several issues found by Coverity.
* ignore 802.11d configuration if not supported in firmware.
* remove worker from netdev callback.

This is intended for 4.9 and applies to the master branch of
the wireless-drivers-next repository.

Arend van Spriel (4):
  brcmfmac: rework pointer trickery in brcmf_proto_bcdc_query_dcmd()
  brcmfmac: fix memory leak in brcmf_flowring_add_tdls_peer()
  brcmfmac: initialize variable in brcmf_sdiod_regrl()
  brcmfmac: remove worker from .ndo_set_mac_address() callback

Hante Meuleman (5):
  brcmfmac: ignore 11d configuration errors
  brcmfmac: remove unnecessary null pointer check
  brcmfmac: fix clearing entry IPv6 address
  brcmfmac: fix out of bound access on clearing wowl wake indicator
  brcmfmac: simplify mapping of auth type

 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 41 +++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 49 +++++++++-------------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 -
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  8 +++-
 6 files changed, 47 insertions(+), 57 deletions(-)

-- 
1.9.1
