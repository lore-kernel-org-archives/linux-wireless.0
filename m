Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18615 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756244Ab0ESBbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:31:52 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-086912710
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:31:51 +0900 (JST)
Subject: [PATCH v2 00/20] pending ath5k + antenna patches
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:30:39 +0900
Message-ID: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are all my pending ath5k patches + the antenna support for cfg80211
rebased against 2.6.34 and based on the previous patch i sent for stable
("ath5k: consistently use rx_bufsize for RX DMA"). 

Also i'd like to note that there are quite a few ath5k patches which haven't
made it into linux-next yet. It would be great to get them into 2.6.35...

thanks,
bruno

---

Bruno Randolf (20):
      ath5k: add debugfs file for queue debugging
      ath5k: wake queues on reset
      ath5k: initialize calibration timers
      ath5k: move noise floor calibration into tasklet
      ath5k: Stop queues only for NF calibration
      ath5k: run NF calibration only every 60 seconds
      ath5k: remove ATH_TRACE macro
      ath5k: clarify logic when to enable spur mitigation filter
      ath5k: use ath5k_softc as driver data
      ath5k: add sysfs files for ANI parameters
      ath5k: always calculate ANI listen time
      ath5k: print error message if ANI levels are out of range
      cfg80211: Add nl80211 antenna configuration
      mac80211: Add antenna configuration
      ath5k: Add support for antenna configuration
      ath5k: remove setting ANI and antenna thru debugfs files
      ath5k: fix NULL pointer in antenna configuration
      ath5k: update AR5K_PHY_RESTART_DIV_GC values to match masks
      ath5k: new function for setting the antenna switch table
      ath5k: no need to save/restore the default antenna


 drivers/net/wireless/ath/ath5k/Makefile |    1 
 drivers/net/wireless/ath/ath5k/ani.c    |   20 +++--
 drivers/net/wireless/ath/ath5k/ath5k.h  |    7 ++
 drivers/net/wireless/ath/ath5k/attach.c |    2 -
 drivers/net/wireless/ath/ath5k/base.c   |   89 ++++++++++++++++--------
 drivers/net/wireless/ath/ath5k/caps.c   |    7 --
 drivers/net/wireless/ath/ath5k/debug.c  |  107 ++++++++++++++++++++---------
 drivers/net/wireless/ath/ath5k/debug.h  |    9 --
 drivers/net/wireless/ath/ath5k/desc.c   |    7 --
 drivers/net/wireless/ath/ath5k/dma.c    |   13 ---
 drivers/net/wireless/ath/ath5k/eeprom.c |    1 
 drivers/net/wireless/ath/ath5k/gpio.c   |    7 --
 drivers/net/wireless/ath/ath5k/pcu.c    |   24 ------
 drivers/net/wireless/ath/ath5k/phy.c    |   89 ++++++++++++++----------
 drivers/net/wireless/ath/ath5k/qcu.c    |    9 --
 drivers/net/wireless/ath/ath5k/reset.c  |   64 +++--------------
 drivers/net/wireless/ath/ath5k/sysfs.c  |  116 +++++++++++++++++++++++++++++++
 include/linux/nl80211.h                 |   12 +++
 include/net/cfg80211.h                  |    3 +
 include/net/mac80211.h                  |    2 +
 net/mac80211/cfg.c                      |   16 ++++
 net/mac80211/driver-ops.h               |   23 ++++++
 net/mac80211/driver-trace.h             |   50 +++++++++++++
 net/wireless/nl80211.c                  |  116 +++++++++++++++++++++++++++++++
 24 files changed, 554 insertions(+), 240 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/sysfs.c

-- 
Signature
