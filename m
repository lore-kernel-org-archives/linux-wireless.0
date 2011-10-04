Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1167 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab1JDVTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 00/26] various cleanup changes for brcmfmac and brcmsmac
Date: Tue, 4 Oct 2011 23:18:46 +0200
Message-ID: <1317763152-17607-1-git-send-email-arend@broadcom.com> (sfid-20111004_231940_777647_EBB4021A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Third attempt as the mailer somehow did not sent these outside the
Broadcom intranet. Another series of cleanup changes based on community
feedback received on the mainline patch (v2) as sent August 25, 2011.

This series is to be applied to the staging-next branch. There are no
pending patches that this series depend on.

Alwin Beukers (15):
  staging: brcm80211: fixed checkpatch warnings
  staging: brcm80211: removed accessor functions for band type and
    etheraddress.
  staging: brcm80211: fixed function returns
  staging: brcm80211: made NULL ethernet address const
  staging: brcm80211: removed empty brcms_c_reset_bmac_done callback
    function
  staging: brcm80211: decreased indentation level of
    brcms_c_wme_setparams function
  staging: brcm80211: removed redundant code from brcms_c_set_gmode
  staging: brcm80211: cleanup of shared memory related wrapper
    functions
  staging: brcm80211: cleanup of transmit buffer size related wrapper
    function
  staging: brcm80211: cleanup of several wrapper functions
  staging: brcm80211: removed unneeded call to
    brcms_b_tx_fifo_suspended
  staging: brcm80211: removed synchronisation of wlc->machwcap field
  staging: brcm80211: remove brcms_b_dotxstatus wrapper function
  staging: brcm80211: combined if statements
  staging: brcm80211: remove N mode validation function

Arend van Spriel (4):
  staging: brcm80211: remove setting ssn to zero upon AMPDU_TX_START
  staging: brcm80211: remove filtering of received frames
  staging: brcm80211: remove brcmu_bprintf and related functions
  staging: brcm80211: replace brcmu_bitcount with hweight8

Franky Lin (3):
  staging: brcm80211: clean up rtnl_lock in fullmac
  staging: brcm80211: remove fullmac module_param for intr/poll mode
  staging: brcm80211: stop using assigned thread priority in fullmac

Roland Vossen (4):
  staging: brcm80211: cleaned up struct brcms_bss_cfg
  staging: brcm80211: fullmac: fixed double #include
  staging: brcm80211: softmac: added event tracing
  staging: brcm80211: smac: fix for 64 bit systems

 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    3 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   72 +---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   25 +-
 drivers/staging/brcm80211/brcmsmac/Makefile        |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   14 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |   14 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |    4 +-
 .../brcm80211/brcmsmac/brcms_trace_events.c        |   23 +
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   92 ++++
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   19 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    2 +
 drivers/staging/brcm80211/brcmsmac/main.c          |  525 ++++----------------
 drivers/staging/brcm80211/brcmsmac/main.h          |   50 +--
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |    7 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |    3 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |   10 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |    1 -
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h  |    4 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |   34 --
 drivers/staging/brcm80211/include/brcmu_utils.h    |   15 -
 21 files changed, 252 insertions(+), 671 deletions(-)
 create mode 100644 drivers/staging/brcm80211/brcmsmac/brcms_trace_events.c
 create mode 100644 drivers/staging/brcm80211/brcmsmac/brcms_trace_events.h

-- 
1.7.4.1


