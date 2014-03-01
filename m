Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52908 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaCAUQh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:37 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
Date: Sat,  1 Mar 2014 21:15:43 +0100
Message-Id: <1393704966-13985-1-git-send-email-linux@rempel-privat.de> (sfid-20140301_211641_524191_F187745D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next patch set. It removes only easy duplicats of beacon code. Other parts of
need deeper rework to make it compatible with ath9k.

Oleksij Rempel (23):
  ath9k: move struct ath_beacon_config to common
  ath9k_htc: use common ath_beacon_config
  ath9k_htc: move beaconq to struct htc_beacon
  ath9k_htc: use ath_beacon_conf.enable_beacon
  ath9k: move sc_flags to ath_common
  ath9k_htc: use common->op_flags
  ath9k_htc: add ATH_OP_PRIM_STA_VIF
  ath9k: remove unused bc_tstamp
  ath9k_htc: sync beacon slot code with ath9k
  ath9k: remove unused beacon_qi
  ath9k|ath9k_htc: move IEEE80211_MS_TO_TU to common
  ath9k-common: add nexttbtt and intval to ath_beacon_config
  ath9k: move ath9k_beacon_config_sta to common-beacon
  ath9k_htc: use ath9k_cmn_beacon_config_sta
  ath9k: move ath9k_beacon_config_adhoc to common
  ath9k_htc: add ath9k_htc_beacon_init (but not use it)
  ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_ap
  ath9k_htc: use ath9k_htc_beacon_init in ath9k_htc_beacon_config_adhoc
  ath9k_htc: use ath9k_cmn_beacon_config_adhoc
  ath9k: move ath9k_beacon_config_ap common
  ath9k: remove unused ath9k_get_next_tbtt
  ath9k_htc: use ath9k_cmn_beacon_config_ap
  ath9k_htc: move DEFAULT_SWBA_RESPONSE check to ath9k_htc_beacon_init

 drivers/net/wireless/ath/ath.h                  |  10 +
 drivers/net/wireless/ath/ath9k/Makefile         |   3 +-
 drivers/net/wireless/ath/ath9k/ahb.c            |   7 +-
 drivers/net/wireless/ath/ath9k/ath9k.h          |  22 ---
 drivers/net/wireless/ath/ath9k/beacon.c         | 165 ++--------------
 drivers/net/wireless/ath/ath9k/common-beacon.c  | 180 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-beacon.h  |  26 +++
 drivers/net/wireless/ath/ath9k/common.h         |  14 ++
 drivers/net/wireless/ath/ath9k/debug.c          |   2 +-
 drivers/net/wireless/ath/ath9k/htc.h            |  25 +--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 252 ++++++------------------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  53 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   3 +-
 drivers/net/wireless/ath/ath9k/link.c           |  16 +-
 drivers/net/wireless/ath/ath9k/main.c           |  45 +++--
 drivers/net/wireless/ath/ath9k/mci.c            |   2 +-
 drivers/net/wireless/ath/ath9k/pci.c            |   8 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |   9 +-
 19 files changed, 413 insertions(+), 439 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.h

-- 
1.9.0

