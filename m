Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:60761 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751251AbdILIsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 04:48:22 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH for-4.14 0/2] brcmfmac: scan related fixes
Date: Tue, 12 Sep 2017 10:47:52 +0200
Message-Id: <1505206074-28781-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170912_104825_765450_9B5D56CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two patches related to scanning functionality in the driver. The first
patch addresses a security vulnerability in firmware notification
handling. The second one fixes a reported API issue in which the driver
ignored a passive scan request from user-space.

The patches apply to the master branch of the wireless-drivers
repository.

Arend van Spriel (2):
  brcmfmac: add length check in brcmf_cfg80211_escan_handler()
  brcmfmac: setup passive scan if requested by user-space

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 37 +++++++++++-----------
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  5 +++
 2 files changed, 24 insertions(+), 18 deletions(-)

-- 
1.9.1
