Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbZEMJVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:21:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC v2 0/5] WoW suport
Date: Wed, 13 May 2009 05:20:56 -0400
Message-Id: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's take II, this time with some cfg80211 and minimal mac80211 integration.
I'm not too sure on the parts needed on mac80211 yet so could use some help there.

Unfortunately it doesn't work yet :( but then again I haven't yet tested this
on another device. I'll do so eventually.

Luis R. Rodriguez (5):
  mac80211: fix idle trigger upon resume
  mac80211: inform devices when we are suspending on the stop callback
  cfg80211: add WoW support
  mac80211: add WoW support
  ath9k: Add Wake-on-Wireless-LAN support

 drivers/net/wireless/adm8211.c              |    2 +-
 drivers/net/wireless/at76c50x-usb.c         |    2 +-
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c       |    4 +-
 drivers/net/wireless/ath/ath9k/Makefile     |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   17 +
 drivers/net/wireless/ath/ath9k/debug.c      |    1 -
 drivers/net/wireless/ath/ath9k/debug.h      |    1 +
 drivers/net/wireless/ath/ath9k/hw.c         |   22 ++
 drivers/net/wireless/ath/ath9k/hw.h         |   21 +
 drivers/net/wireless/ath/ath9k/initvals.h   |   31 ++
 drivers/net/wireless/ath/ath9k/main.c       |   23 ++-
 drivers/net/wireless/ath/ath9k/pci.c        |  105 +++++
 drivers/net/wireless/ath/ath9k/reg.h        |  154 ++++++++
 drivers/net/wireless/ath/ath9k/wow.c        |  543 +++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.c             |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/libertas_tf/main.c     |    2 +-
 drivers/net/wireless/mac80211_hwsim.c       |    2 +-
 drivers/net/wireless/mwl8k.c                |    2 +-
 drivers/net/wireless/p54/p54common.c        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c          |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |    2 +-
 include/linux/nl80211.h                     |   37 ++
 include/net/cfg80211.h                      |   28 ++
 include/net/mac80211.h                      |   15 +-
 net/mac80211/cfg.c                          |   11 +
 net/mac80211/driver-ops.h                   |    2 +-
 net/mac80211/ieee80211_i.h                  |    2 +
 net/mac80211/iface.c                        |    4 +
 net/mac80211/pm.c                           |    8 +
 net/mac80211/util.c                         |    8 +
 net/wireless/nl80211.c                      |  121 ++++++
 39 files changed, 1166 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c

