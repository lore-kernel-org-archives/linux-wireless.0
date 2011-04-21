Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4651 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1DULCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:02:21 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 0/3] staging: brcm80211: logging code clean up
Date: Thu, 21 Apr 2011 13:02:02 +0200
Message-ID: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Difference with v2,v1 patches: added reference counting of device object by
adding get_device() and put_device() calls. Patch is based on the latest
staging-next so should apply.

v1 patch comment (still valid):
Improved code readability by getting rid of proprietary log functions like
WL_NONE and WL_ERROR. More logging code cleanup changes in the pipeline, but
I would first like to get some feedback of the community on this patch.

Roland Vossen (3):
  staging: brcm80211: replaced WL_NONE with no_printk
  staging: brcm80211: making device object accessible from wlc and phy
  staging: brcm80211: replaced WL_ERROR with dev_err in two files.

 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h        |    2 -
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |  273 +++++++++++---------
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    8 +-
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    7 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    3 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    8 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    2 +-
 14 files changed, 178 insertions(+), 146 deletions(-)


