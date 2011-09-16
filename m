Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4648 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab1IPT2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:21 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/19] staging: brcm80211: 6th reaction for mainline
 patch #2
Date: Fri, 16 Sep 2011 12:27:49 -0700
Message-ID: <1316201288-29635-1-git-send-email-frankyl@broadcom.com> (sfid-20110916_212826_330013_D3CFF70A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fullmac code clean up.

Arend van Spriel (4):
  staging: brcm80211: remove brcmfmac interface name override
  staging: brcm80211: remove for_each_bss() macro from brcmfmac driver
  staging: brcm80211: remove global variable from bcmsdh_sdmmc.c
  staging: brcm80211: remove static global variables from dhd_sdio.c

Franky Lin (8):
  staging: brcm80211: remove SOFTAP code from fullmac
  staging: brcm80211: remove fullmac module_param sd_f2_blocksize
  staging: brcm80211: remove fullmac module_param brcmf_deferred_tx
  staging: brcm80211: remove fullmac module_param for packet filter
    feature
  staging: brcm80211: remove global variable brcmf_roam from fullmac
  staging: brcm80211: remove global variable brcmf_radio_up from
    fullmac
  staging: brcm80211: remove _brcmf_sysioc_thread in fullmac
  staging: brcm80211: remove fullmac module_param for ARP offload
    feature

Roland Vossen (7):
  staging: brcm80211: simplified brcmf_proto_ioctl()
  staging: brcm80211: removed set_fs/get_fs/get_ds calls from
    brcmf_dev_ioctl()
  staging: brcm80211: fixed sparse endianness warnings on fullmac scan
    pars
  staging: brcm80211: fixed sparse endianness warnings on fullmac assoc
    pars
  staging: brcm80211: fixed sparse endianness warnings on fullmac scb
    pars
  staging: brcm80211: fixed sparse endianness warnings on fullmac
    ratespec
  staging: brcm80211: sparse endianness warnings on fullmac bss info

 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |    4 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   31 ++--
 drivers/staging/brcm80211/brcmfmac/dhd.h          |  118 ++++-------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   12 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   26 +--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  244 +++++----------------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h    |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  244 ++++++++-------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    7 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |  165 +++++++--------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    6 +-
 drivers/staging/brcm80211/brcmsmac/pub.h          |    7 +
 drivers/staging/brcm80211/include/defs.h          |    7 -
 13 files changed, 302 insertions(+), 571 deletions(-)


