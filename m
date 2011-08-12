Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3103 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1HLNfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:14 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/14] staging: brcm80211: brcmfmac driver cleanup
Date: Fri, 12 Aug 2011 15:34:47 +0200
Message-ID: <1313156101-16817-1-git-send-email-arend@broadcom.com> (sfid-20110812_154257_195763_87FE65E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several cleanup patches to reduce code for the brcmfmac driver and
get rid of a remaining checkpatch warning. The driver sources should
be clear from checkpatch issue now.

This series applies to staging-next and depends on the following patch set:

Message-ID: <1312811946-16713-1-git-send-email-arend@broadcom.com>

Arend van Spriel (1):
  staging: brcm80211: use wait queues instead of semaphores in
    wl_cfg80211.c

Franky Lin (13):
  staging: brcm80211: remove iovar IOV_BLOCKSIZE in brcmfmac
  staging: brcm80211: remove struct sdioh_info from brcmfmac
  staging: brcm80211: remove global var gInstance from brcmfmac
  staging: brcm80211: remove wext traces in fullmac
  staging: brcm80211: absorb brcmf_sdioh_iovar_op into
    brcmf_sdcard_iovar_op
  staging: brcm80211: absorb brcmf_sdioh_interrupt_register into
    brcmf_sdcard_intr_reg
  staging: brcm80211: absorb brcmf_sdioh_interrupt_deregister into
    brcmf_sdcard_intr_dereg
  staging: brcm80211: absorb brcmf_sdioh_abort into brcmf_sdcard_abort
  staging: brcm80211: remove dead code from dhd_sdio.c
  staging: brcm80211: remove wrapper functions in bcmsdh_sdmmc.c
  staging: brcm80211: remove unused parameter from data interface in
    fullmac
  staging: brcm80211: remove dead SDTEST code from fullmac
  staging: brcm80211: remove unused func parameter in wl_cfg80211 of
    fullmac

 drivers/staging/brcm80211/Kconfig                 |    2 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |  197 +++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  555 ++++------------
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   37 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  744 ++-------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   80 +--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   74 ++-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    5 +-
 8 files changed, 409 insertions(+), 1285 deletions(-)

-- 
1.7.4.1


