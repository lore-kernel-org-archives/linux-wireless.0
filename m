Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbZGOAWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/5] wireless: add wow support
Date: Tue, 14 Jul 2009 20:21:55 -0400
Message-Id: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds Wake-on-Wireless support for wireless with
initial support for ath9k. No event reporting is done yet,
we'll leave that for later once we figure out a unified
method for all devices (including non-wireless).

If you are not familiar with WoW you are encouraged to read:

http://wireless.kernel.org/en/users/Documentation/WoW

Please note not all laptops/desktops will have support for
allowing WoW. You will need proper BIOS support, also not
all cards have it enabled.

Luis R. Rodriguez (5):
  ath9k: do not stop the queues in driver stop
  adm8211: remove uneeded code during suspend/resume
  cfg80211: add WoW support
  mac80211: add WoW support
  ath9k: Add Wake-on-Wireless-LAN support

 drivers/net/wireless/adm8211.c              |   19 +-
 drivers/net/wireless/at76c50x-usb.c         |    3 +-
 drivers/net/wireless/ath/ar9170/main.c      |    2 +-
 drivers/net/wireless/ath/ath5k/base.c       |    4 +-
 drivers/net/wireless/ath/ath9k/Makefile     |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   18 +
 drivers/net/wireless/ath/ath9k/debug.c      |    1 -
 drivers/net/wireless/ath/ath9k/hw.c         |   22 ++
 drivers/net/wireless/ath/ath9k/hw.h         |   21 ++
 drivers/net/wireless/ath/ath9k/initvals.h   |   31 ++
 drivers/net/wireless/ath/ath9k/main.c       |   27 ++-
 drivers/net/wireless/ath/ath9k/pci.c        |  102 ++++++
 drivers/net/wireless/ath/ath9k/reg.h        |  154 ++++++++
 drivers/net/wireless/ath/ath9k/wow.c        |  511 +++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.c             |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/net/wireless/libertas_tf/main.c     |    2 +-
 drivers/net/wireless/mac80211_hwsim.c       |    2 +-
 drivers/net/wireless/mwl8k.c                |    2 +-
 drivers/net/wireless/p54/main.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1251_main.c   |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |    2 +-
 include/linux/nl80211.h                     |   46 +++
 include/net/cfg80211.h                      |   26 ++-
 include/net/mac80211.h                      |   17 +-
 net/mac80211/cfg.c                          |    5 +-
 net/mac80211/debugfs.c                      |    2 +-
 net/mac80211/driver-ops.h                   |    6 +-
 net/mac80211/driver-trace.h                 |    6 +-
 net/mac80211/ieee80211_i.h                  |   12 +-
 net/mac80211/iface.c                        |    6 +-
 net/mac80211/pm.c                           |   31 ++-
 net/mac80211/util.c                         |   14 +
 net/wireless/core.h                         |    3 +
 net/wireless/nl80211.c                      |  116 ++++++
 net/wireless/sysfs.c                        |    2 +-
 42 files changed, 1172 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c

