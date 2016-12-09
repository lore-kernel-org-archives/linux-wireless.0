Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:56364 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932978AbcLILeb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Dec 2016 06:34:31 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.10 0/2] brcmfmac: small fixes for after merge window
Date: Fri,  9 Dec 2016 11:34:12 +0000
Message-Id: <1481283254-17883-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161209_123448_298517_213EAC42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two issues found during more testing. The first patch fixes a memory leak
in error path. The second one fixes a regression introduced by a change
that currently sits in wireless-drivers-next.

These patches have been applied on top of wireless-drivers-next/master branch
so it can apply on wireless-drivers/master after the merge window (fingers
crossed).

Arend van Spriel (2):
  brcmfmac: fix memory leak in brcmf_cfg80211_attach()
  brcmfmac: fix uninitialized field in scheduled scan ssid configuration

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 +++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c      | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

--
1.9.1
