Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:3151 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbZFOPhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:37:20 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/12] iwmc3200wifi updates
Date: Mon, 15 Jun 2009 17:39:16 +0200
Message-Id: <cover.1245076752.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here go some updates for the iwmc3200wifi driver.
Some of those patches are bug fixes and we'd like them to eventually make it
to 2.6.31. The rest are targeted at wireless-testing inclusion.
I tried to set an explicit subject line to let you clearly understand where
we'd like each of them to land, please let me know if that's not the case.

Samuel Ortiz (5):
  iwmc3200wifi: fix sdio initialisation race
  iwmc3200wifi: invalidate keys when changing the BSSID
  iwmc3200wifi: handling wifi_if_ntfy responses
  iwmc3200wifi: cfg80211 key hooks implemetation
  iwmc3200wifi: cache keys when interface is down

Zhu Yi (7):
  iwmc3200wifi: check for iwm_priv_init error
  iwmc3200wifi: add iwm_if_add and iwm_if_remove
  iwmc3200wifi: fix potential kernel oops on module removal
  iwmc3200wifi: add a mutex to protect iwm_reset_worker
  iwmc3200wifi: change coexist periodic calibration flag
  iwmc3200wifi: remove select LIB80211 from Kconfig
  iwmc3200wifi: rfkill cleanup

 drivers/net/wireless/iwmc3200wifi/Kconfig    |    1 -
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |  204 +++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/commands.c |  116 +++++------
 drivers/net/wireless/iwmc3200wifi/commands.h |    7 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h      |   39 ++--
 drivers/net/wireless/iwmc3200wifi/main.c     |   95 ++++++---
 drivers/net/wireless/iwmc3200wifi/netdev.c   |   68 ++++--
 drivers/net/wireless/iwmc3200wifi/rx.c       |   27 ++-
 drivers/net/wireless/iwmc3200wifi/sdio.c     |   21 ++-
 drivers/net/wireless/iwmc3200wifi/umac.h     |    2 +
 drivers/net/wireless/iwmc3200wifi/wext.c     |  305 +++-----------------------
 11 files changed, 460 insertions(+), 425 deletions(-)

