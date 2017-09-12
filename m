Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:44617 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751286AbdILJWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 05:22:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/7] brcmfmac: scan code cleanup and more
Date: Tue, 12 Sep 2017 11:22:16 +0200
Message-Id: <1505208143-30166-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_112251_093648_F4E2153D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has following changes:
 * cleanup scanning code.
 * deal with FWHALT indication.
 * fix for promiscuous mode.

The patches apply to master branch of wireless-drivers-next
repository.

Arend van Spriel (6):
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
