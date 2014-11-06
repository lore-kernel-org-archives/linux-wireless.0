Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54499 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaKFHy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:27 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 00/21] make spectral code common for both ath9k drivers
Date: Thu,  6 Nov 2014 08:53:17 +0100
Message-Id: <1415260418-14321-1-git-send-email-linux@rempel-privat.de> (sfid-20141106_085554_456403_E3C55AB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- makes spectral scan code common for both ath9k and ath9k_htc.
- add spectral scan support to ath9k_htc.

Oleksij Rempel (21):
  ath9k: add struct ath_spec_scan_priv
  ath9k: move spectral_mode to ath_spec_scan_priv
  ath9k: move spec_config to ath_spec_scan_priv
  ath9k: use struct dentry by ath9k_spectral_init_debug
  ath9k: add ath_hw to ath_spec_scan_priv
  ath9k: remove all struct ath_softc dependencies from spectral code
  ath: add struct ath_ps_ops
  ath9k: add ath_ps_ops bindings
  ath9k: use ath_ps_ops in ath9k_spectral_scan_
  ath9k: use ath_common instead of ieee80211_hw in ath9k_spectral_scan_
  ath9k: make ath9k_spectral_scan_ do not depend on ath_softc
  ath9k: move ath9k_spectral_scan_ from main.c to spectral.c
  ath9k: move spectral.* to common-spectral.*
  ath9k: For AR9271 chipsets, set count = 0 for endless samples.
  ath9k_htc: fix rs_datalen conversation
  ath9k_htc: add ath_ps_ops bindings
  ath9k_htc: add struct ath_spec_scan_priv to ath9k_htc_priv
  ath9k_htc: set initial spec_config values
  ath9k_htc: trigger spectral scan on set_channel
  ath9k_htc: process rx spectral packets
  ath9k_htc: add spectral scan debug interface

 drivers/net/wireless/ath/ath.h                   |  11 +
 drivers/net/wireless/ath/ath9k/Makefile          |   6 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c      |   9 +-
 drivers/net/wireless/ath/ath9k/ath9k.h           |   7 +-
 drivers/net/wireless/ath/ath9k/channel.c         |   4 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c | 620 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-spectral.h | 154 ++++++
 drivers/net/wireless/ath/ath9k/common.h          |   1 +
 drivers/net/wireless/ath/ath9k/debug.c           |   4 +-
 drivers/net/wireless/ath/ath9k/htc.h             |   3 +
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c   |   6 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c    |  25 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c    |   4 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c    |  16 +-
 drivers/net/wireless/ath/ath9k/init.c            |  29 +-
 drivers/net/wireless/ath/ath9k/main.c            |  72 ---
 drivers/net/wireless/ath/ath9k/recv.c            |   2 +-
 drivers/net/wireless/ath/ath9k/spectral.c        | 543 --------------------
 drivers/net/wireless/ath/ath9k/spectral.h        | 145 ------
 19 files changed, 878 insertions(+), 783 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-spectral.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-spectral.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/spectral.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/spectral.h

-- 
1.9.1

