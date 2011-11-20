Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KTH51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:27 -0500
Received: by bke11 with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:26 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 00/13] ath5k: A few updates + cleanups + kerneldoc
Date: Sun, 20 Nov 2011 09:56:15 +0200
Message-Id: <1321775788-12520-1-git-send-email-mickflemm@gmail.com> (sfid-20111120_085731_466033_D4028F55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches includes some stability fixes related to interrupt
handling, an updated version of a calibration-related patch I posted some
time ago but never submited here and a new module parameter to disable
GPIO based rfkill switch (we had a few bug reports on that recently).

It also adds kernel doc on all ath5k_hw_* functions and structs (needs
some more work but it should be fine, I reviewed the output, spell-ckecked
it etc) and a few minor fixes and optimizations.

Nick Kossifidis (13):
  ath5k: Switch from read-and-clear to write-to-clear method when handling
  PISR/SISR registers.
  ath5k: Maintain PISR snapshot
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
 drivers/net/wireless/ath/ath5k/ath5k.h    |  566 +++++++++++++------
 drivers/net/wireless/ath/ath5k/attach.c   |   16 +-
 drivers/net/wireless/ath/ath5k/base.c     |  277 +++++++---
 drivers/net/wireless/ath/ath5k/caps.c     |   27 +-
 drivers/net/wireless/ath/ath5k/desc.c     |  217 ++++++--
 drivers/net/wireless/ath/ath5k/desc.h     |  124 +++--
 drivers/net/wireless/ath/ath5k/dma.c      |  380 ++++++++-----
 drivers/net/wireless/ath/ath5k/gpio.c     |   81 +++-
 drivers/net/wireless/ath/ath5k/initvals.c |   75 ++-
 drivers/net/wireless/ath/ath5k/pci.c      |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c      |  222 +++++---
 drivers/net/wireless/ath/ath5k/phy.c      |  852 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath5k/qcu.c      |  136 ++++--
 drivers/net/wireless/ath/ath5k/reg.h      |   21 +-
 drivers/net/wireless/ath/ath5k/reset.c    |  230 ++++++--
 drivers/net/wireless/ath/ath5k/rfbuffer.h |   59 ++-
 drivers/net/wireless/ath/ath5k/rfgain.h   |   22 +-
 20 files changed, 2457 insertions(+), 977 deletions(-)

-- 
1.7.8.rc1

