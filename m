Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:36681 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752663AbdKHNgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 08:36:45 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 0/7] brcmfmac: firmware halt and scan cleanup
Date: Wed,  8 Nov 2017 14:36:30 +0100
Message-Id: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171108_143654_439299_576032C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is a resubmission. No changes were being made compared
to the previous series.

  * handling firmware halt indication.
  * cleanup scan related code.

The series applies to the master branch of the wireless-drivers-next
repository and is intended for v4.15 kernel.

Arend Van Spriel (6):
  brcmfmac: handle FWHALT mailbox indication
  brcmfmac: cleanup brcmf_cfg80211_escan() function
  brcmfmac: use msecs_to_jiffies() instead of calculation using HZ
  brcmfmac: get rid of brcmf_cfg80211_escan() function
  brcmfmac: get rid of struct brcmf_cfg80211_info::active_scan field
  brcmfmac: move configuration of probe request IEs

Franky Lin (1):
  brcmfmac: disable packet filtering in promiscuous mode

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 162 ++++-----------------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   2 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  38 +++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  14 +-
 6 files changed, 77 insertions(+), 151 deletions(-)

-- 
1.9.1
