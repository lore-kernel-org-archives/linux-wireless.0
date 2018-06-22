Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35516 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933878AbeFVSnc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:43:32 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
Date: Fri, 22 Jun 2018 20:43:18 +0200
Message-Id: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180622_204347_330242_E762E733)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here a couple of patches in preparation of monitor mode support. It
is mostly about querying firmware for support. While at it I stumbled
upon the fact that 160MHz was not completely implemented in the driver
so there is a patch for that as well.

The first two patches are actually some changes to the patches that
Rafal submitted. So this series depend on:

[V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]

These apply to the master branch of the wireless-drivers-next repository.

[1] https://patchwork.kernel.org/patch/10474799/

Arend van Spriel (6):
  brcmfmac: remove fallback mechanism for BRCMF_FEAT_MONITOR
  brcmfmac: rename BRCMF_FEAT_MONITOR_FMT_RADIOTAP to
    BRCMF_FEAT_RADIOTAP
  brcmfmac: fix for proper support of 160MHz bandwidth
  brcmfmac: increase buffer for obtaining firmware capabilities
  brcmfmac: add new feature flags for monitor mode operation
  brcmfmac: fallback mechanism to determine monitor mode features

 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 43 +++++++++-------------
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  6 +--
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 21 +++++++++++
 .../net/wireless/broadcom/brcm80211/brcmutil/d11.c | 34 ++++++++++++++++-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |  2 +
 6 files changed, 77 insertions(+), 31 deletions(-)

-- 
1.9.1
