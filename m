Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33480 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1KYSkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:40:51 -0500
Received: by eaak14 with SMTP id k14so988570eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:40:50 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 00/12] ath5k: A few updates + cleanups + kerneldoc
Date: Fri, 25 Nov 2011 20:40:19 +0200
Message-Id: <1322246431-10825-1-git-send-email-mickflemm@gmail.com> (sfid-20111125_194054_783874_1F236AEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches includes some stability fixes related to interrupt
handling, an updated version of a calibration-related patch I posted some
time ago but never submited here and a new module parameter to disable
GPIO based rfkill switch (we had a few bug reports on that recently).

It also adds kernel doc on all ath5k_hw_* functions and structs (needs
some more work but it should be fine, I reviewed the output, spell-ckecked
it etc) and a few minor fixes and optimizations.

v2: Adress comments from Adrian, Felix, Jiri and Bob. Thanks a lot for the
review !

Nick Kossifidis (12):
  ath5k: Switch from read-and-clear to write-to-clear method when
    handling PISR/SISR registers
  ath5k: Add TXNOFRM to INT_TX_ALL
  ath5k: Cleanups v1
  ath5k: Calibration re-work
  ath5k: Use usleep_range where possible
  ath5k: Cleanups v2 + add kerneldoc on all hw functions
  ath5k: We always do full calibration on AR5210
  ath5k: Add a module parameter to disable hw rf kill switch
  ath5k: MRR support and 2GHz radio override belong in ah_capabilities
  ath5k: ath5k_ani_period_restart only touches struct ath5k_ani_state
  ath5k: Renumber hw queue ids
  ath5k: Optimize ath5k_cw_validate

 drivers/net/wireless/ath/ath5k/ahb.c      |    4 +-
 drivers/net/wireless/ath/ath5k/ani.c      |   91 ++--
 drivers/net/wireless/ath/ath5k/ani.h      |   32 +-
 drivers/net/wireless/ath/ath5k/ath5k.h    |  569 +++++++++++++------
 drivers/net/wireless/ath/ath5k/attach.c   |   16 +-
 drivers/net/wireless/ath/ath5k/base.c     |  287 +++++++----
 drivers/net/wireless/ath/ath5k/caps.c     |   27 +-
 drivers/net/wireless/ath/ath5k/desc.c     |  217 ++++++--
 drivers/net/wireless/ath/ath5k/desc.h     |  124 +++--
 drivers/net/wireless/ath/ath5k/dma.c      |  370 ++++++++-----
 drivers/net/wireless/ath/ath5k/gpio.c     |   81 +++-
 drivers/net/wireless/ath/ath5k/initvals.c |   75 ++-
 drivers/net/wireless/ath/ath5k/pci.c      |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c      |  222 +++++---
 drivers/net/wireless/ath/ath5k/phy.c      |  853 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath5k/qcu.c      |  143 ++++--
 drivers/net/wireless/ath/ath5k/reg.h      |   27 +-
 drivers/net/wireless/ath/ath5k/reset.c    |  230 ++++++--
 drivers/net/wireless/ath/ath5k/rfbuffer.h |   59 ++-
 drivers/net/wireless/ath/ath5k/rfgain.h   |   22 +-
 20 files changed, 2465 insertions(+), 986 deletions(-)

-- 
1.7.8.rc3

