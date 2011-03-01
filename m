Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47376 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab1CAUgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:43 -0500
Received: by wwe15 with SMTP id 15so4909349wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 0/9] add WoW support
Date: Tue,  1 Mar 2011 22:36:35 +0200
Message-Id: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds Wake-On-Wireless support for cfg80211/mac80211,
and some basic usage of it by wl12xx (i'll later split it to 2 patchsets).

It is mostly based on a previous patchset by 
Luis R. Rodriguez <lrodriguez@atheros.com> which can be found here:
http://marc.info/?l=linux-wireless&m=124761732817865

The usual way to trigger a wakeup, is by some kind of magic packet.
However, since the development was done with wl12xx, which doesn't
support a real WoW trigger, we use a psuedo-trigger - 
NL80211_WOW_TRIGGER_ANYTHING, which basically means that we will
wake up on ANY irq the fw issues.
This way, there is no need for any special WoW support from the
device, rather than staying up while the system is being suspended.

This is still a work in progress, so i'd be happy for your comments.

Eliad Peller (8):
  mac80211: add WoW param to suspend/resume functions
  mac80211: add WoW param to .start/.stop callbacks
  mac80211: don't remove/add interfaces when WoW is enabled
  wl12xx_sdio: set interrupt as wake_up interrupt
  wl12xx_sdio: set MMC_PM_KEEP_POWER flag on suspend
  wl12xx: save wl->wow_enabled on suspend
  wl12xx: prevent scheduling while suspending (WoW enabled)
  wl12xx_sdio: declare support for NL80211_WOW_TRIGGER_ANYTHING trigger

Luis R. Rodriguez (1):
  cfg80211: add WoW support

 drivers/net/wireless/wl12xx/main.c   |   45 ++++++++++++++++++--
 drivers/net/wireless/wl12xx/sdio.c   |   72 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    7 +++-
 include/linux/nl80211.h              |   42 ++++++++++++++++++
 include/net/cfg80211.h               |   31 ++++++++++++-
 include/net/mac80211.h               |   19 ++++++---
 net/mac80211/cfg.c                   |    8 ++--
 net/mac80211/debugfs.c               |    4 +-
 net/mac80211/driver-ops.h            |   14 ++++---
 net/mac80211/driver-trace.h          |   47 ++++++++++++++++++---
 net/mac80211/ieee80211_i.h           |   20 ++++++---
 net/mac80211/iface.c                 |    8 ++--
 net/mac80211/main.c                  |    2 +-
 net/mac80211/pm.c                    |   64 ++++++++++++++++------------
 net/mac80211/util.c                  |   70 +++++++++++++++++++------------
 net/wireless/core.h                  |    3 +
 net/wireless/nl80211.c               |   78 ++++++++++++++++++++++++++++++++++
 net/wireless/sysfs.c                 |    4 +-
 18 files changed, 435 insertions(+), 103 deletions(-)

