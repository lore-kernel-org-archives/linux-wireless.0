Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62340 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0CRK1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:00 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 00/21] wl1271: another patch bomb from our internal repo
Date: Thu, 18 Mar 2010 12:26:25 +0200
Message-Id: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here's another set of patches that have been pending for a while in our
internal tree.  This is the last bomb and hopefully we'll be able to send them
more frequently from now on.

There are some SDIO fixes and improvements, some WMM and U-APSD stuff and the
usual bunch of general improvements and bugfixes.

Cheers,
Luca.

Juuso Oikarinen (10):
  wl1271: Fix configuration of the TX opportunity value
  wl1271: Fix SG configuration message structures
  wl1271: Add proper WLAN-BT co-ex configuration, and enable co-ex.
  wl1271: Move platform device registration from _spi to _main
  wl1271: Add sysfs file to control BT co-ex state
  wl1271: Fix MAC address handling
  wl1271: Remove deprecated interface config function
  wl1271: Update filters properly
  wl1271: Don't generate null func template for ad-hoc
  wl1271: Remove circular interlocking related to the inetaddr notifier
    chain

Kalle Valo (6):
  wl1271: enable WMM
  wl1271: get pspoll and nullfunc templates from mac80211
  wl1271: get probe request template from mac80211
  wl1271: create qos nullfunc template
  wl1271: fix ps scheme in wl1271_op_conf_tx()
  wl1271: enable U-APSD

Teemu Paasikivi (5):
  wl1271: Cleaned up wlan power on/off functions
  wl1271: Changed SDIO MMC host claiming
  wl1271: Added DEBUG_SDIO flag
  wl1271: Removed duplicate code from module remove function.
  wl1271: Changed platform_device to be dynamically allocated

 drivers/net/wireless/wl12xx/wl1271.h         |    7 +
 drivers/net/wireless/wl12xx/wl1271_acx.c     |   25 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h     |   68 +----
 drivers/net/wireless/wl12xx/wl1271_boot.c    |    8 +
 drivers/net/wireless/wl12xx/wl1271_cmd.c     |  218 ++++-------
 drivers/net/wireless/wl12xx/wl1271_cmd.h     |   12 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h    |  330 ++++++++++++++----
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |   12 +-
 drivers/net/wireless/wl12xx/wl1271_event.c   |    2 +
 drivers/net/wireless/wl12xx/wl1271_init.c    |    4 +-
 drivers/net/wireless/wl12xx/wl1271_io.h      |   13 +
 drivers/net/wireless/wl12xx/wl1271_main.c    |  496 ++++++++++++++++----------
 drivers/net/wireless/wl12xx/wl1271_sdio.c    |   74 ++---
 drivers/net/wireless/wl12xx/wl1271_spi.c     |   35 +--
 drivers/net/wireless/wl12xx/wl1271_tx.h      |    3 -
 15 files changed, 748 insertions(+), 559 deletions(-)

