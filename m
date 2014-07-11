Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44192 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGKABv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:01:51 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so279634wgh.35
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:01:49 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/14] wlcore/wl18xx/wl12xx: various fixes
Date: Fri, 11 Jul 2014 03:01:25 +0300
Message-Id: <1405036899-27396-1-git-send-email-eliad@wizery.com> (sfid-20140711_020154_891125_A99C0B4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset contains various fixes for the wlcore
drivers family, along with basic definitions for
smart config commands/events.

Arik Nemtsov (2):
  wlcore: don't switch channels on disconnected STA vifs
  wl18xx: change the number of WLAN addrs per chip

Eliad Peller (12):
  wlcore: save seq num only between recoveries
  wlcore: user smaller sqn padding for GEM
  wl18xx: fix last tx rate calculation
  wlcore: use correct LAA bit
  wlcore: add smart config definitions
  wlcore/wl18xx: add smart config commands
  wlcore: handle smart config vendor commands
  wlcore/wl18xx: handle smart config events
  wlcore: increase max roc duration to 30 seconds
  wlcore: register vendor commands
  wl18xx: make sure fw_status->priv exists before deref
  wlcore/wl18xx/wl12xx: convert bitmaps to unsigned longs

 drivers/net/wireless/ti/wl12xx/main.c       |   2 +-
 drivers/net/wireless/ti/wl18xx/cmd.c        |  89 +++++++++++++
 drivers/net/wireless/ti/wl18xx/cmd.h        |  19 ++-
 drivers/net/wireless/ti/wl18xx/event.c      |  65 +++++++++
 drivers/net/wireless/ti/wl18xx/event.h      |   2 +
 drivers/net/wireless/ti/wl18xx/main.c       |  34 +++--
 drivers/net/wireless/ti/wl18xx/tx.c         |   7 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h     |   2 +-
 drivers/net/wireless/ti/wlcore/Makefile     |   2 +-
 drivers/net/wireless/ti/wlcore/cmd.c        |  12 +-
 drivers/net/wireless/ti/wlcore/cmd.h        |   3 +
 drivers/net/wireless/ti/wlcore/debugfs.c    |   2 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h     |  27 ++++
 drivers/net/wireless/ti/wlcore/main.c       | 103 +++++++++++----
 drivers/net/wireless/ti/wlcore/tx.c         |   2 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c | 197 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/vendor_cmd.h |  45 +++++++
 drivers/net/wireless/ti/wlcore/wlcore.h     |   8 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h   |  20 +--
 19 files changed, 583 insertions(+), 58 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wlcore/vendor_cmd.c
 create mode 100644 drivers/net/wireless/ti/wlcore/vendor_cmd.h

-- 
1.8.5.1.109.g3d252a9

