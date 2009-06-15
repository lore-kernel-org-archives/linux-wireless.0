Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:7034 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751382AbZFOTeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:34:15 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/11 v2] iwmc3200wifi updates
Date: Mon, 15 Jun 2009 21:36:12 +0200
Message-Id: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here go some updates for the iwmc3200wifi driver.
Some of those patches are bug fixes and we'd like them to eventually make it
to 2.6.31. The rest are targeted at wireless-testing inclusion.
I tried to set an explicit subject line to let you clearly understand where
we'd like each of them to land, please let me know if that's not the case.

Changes:
v2: Removed patch #1 from the previous patch set.
With patch #3 (#2 on patch set v2), we are actually registering the netdev
_after_ the SDIO bus is really ready.

Samuel Ortiz (4):
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
 drivers/net/wireless/iwmc3200wifi/iwm.h      |   28 ++--
 drivers/net/wireless/iwmc3200wifi/main.c     |   89 ++++++--
 drivers/net/wireless/iwmc3200wifi/netdev.c   |   72 ++++---
 drivers/net/wireless/iwmc3200wifi/rx.c       |   27 ++-
 drivers/net/wireless/iwmc3200wifi/sdio.c     |   17 +-
 drivers/net/wireless/iwmc3200wifi/umac.h     |    2 +
 drivers/net/wireless/iwmc3200wifi/wext.c     |  305 +++-----------------------
 11 files changed, 443 insertions(+), 425 deletions(-)

