Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3146 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab1GEUGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 16:06:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 00/21] staging: brcm80211: mostly fullmac cleanup
 patches
Date: Tue, 5 Jul 2011 22:05:56 +0200
Message-ID: <1309896377-4425-1-git-send-email-arend@broadcom.com> (sfid-20110705_220659_391863_65EA8EF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series are patches from the series 'more code cleanup and bug fixed' that
failed to apply.

Arend van Spriel (5):
  staging: brcm80211: rename function variables
  staging: brcm80211: rename dhd_bus structure and functions
  staging: brcm80211: rename structures and variables in wl_cfg80211.c
  staging: brcm80211: rename pointer conversion macros in wl_cfg80211.h
  staging: brcm80211: rename external function in wl_cfg80211.c

Roland Vossen (16):
  staging: brcm80211: removed last occurrences of bcmsdh/BCMSDH
  staging: brcm80211: sdh related code cleanup
  staging: brcm80211: removed brcmf_sdioh_interrupt_pending()
  staging: brcm80211: removed brcmf_sdioh_reset()
  staging: brcm80211: removed brcmf_sdioh_start() and
    brcmf_sdioh_stop()
  staging: brcm80211: removed file sdiovar.h
  staging: brcm80211: further cleaned fullmac header files
  staging: brcm80211: removed last typedefs from fullmac
  staging: brcm80211: removed unused code and definitions from fullmac
  staging: brcm80211: fullmac register access macro's take u32 instead
    of pointers
  staging: brcm80211: replaced macro R_SDREG by function r_sdreg()
  staging: brcm80211: replaced macro W_SDREG by function w_sdreg()
  staging: brcm80211: got rid of redundant member 'regs' of struct
    dhd_bus
  staging: brcm80211: removed last amd64 compiler warnings
  staging: brcm80211: W_REG macro cleanup in fullmac SDIO
  staging: brcm80211: removed unused definitions from dhd_sdio.c

 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |  131 ++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  403 +++----
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |   83 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   91 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |  138 ---
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   32 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |  104 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |   32 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |  123 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   32 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  140 +--
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |    5 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      | 1262 ++++++++++---------
 drivers/staging/brcm80211/brcmfmac/dngl_stats.h    |    4 +-
 drivers/staging/brcm80211/brcmfmac/sbsdio.h        |   96 --
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |  153 +--
 drivers/staging/brcm80211/brcmfmac/sdiovar.h       |   38 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   | 1301 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |  140 +--
 19 files changed, 1926 insertions(+), 2382 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sdiovar.h

-- 
1.7.4.1


