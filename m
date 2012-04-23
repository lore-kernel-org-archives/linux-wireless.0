Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4249 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab2DWVZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:25:15 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3.4 V2 0/2] brcm80211: two fullmac bug fix for 3.4
Date: Mon, 23 Apr 2012 14:24:51 -0700
Message-ID: <1335216293-19419-1-git-send-email-frankyl@broadcom.com> (sfid-20120423_232529_438732_9E8B77E1)
In-Reply-To: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
References: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two bug fix patches for brcmfmac aim for 3.4. One corrects a wrong SDIO function register write access behavior. The other one fixes an issue than dpc could miss completion events in heavy loading system.

V2: Rework "brcm80211: fmac: fix SDIO function 0 register r/w issue" based on remark from Florian and Johannes.

Thanks,
Franky

Franky Lin (2):
  brcm80211: fmac: fix SDIO function 0 register r/w issue
  brcm80211: fmac: fix missing completion events issue

 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    8 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   63 ++++++++++++++++----
 2 files changed, 58 insertions(+), 13 deletions(-)

-- 
1.7.5.4


