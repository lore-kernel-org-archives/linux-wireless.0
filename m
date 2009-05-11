Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbZEKJZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 05:25:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 0/5] mac80211 suspend cleanups/helpers
Date: Mon, 11 May 2009 05:24:59 -0400
Message-Id: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first two are probably patch ready but it'd be nice if someone can
test adm8211. The rest are stuff to be able to use WoW. This still
doesn't add the driver APIs for WoW but it at least lets us pass information
during suspend so we can be aware of what to do internally.

The ath9k WoW stuff now has the device stuff for sleep. We also enable
link and beacon miss events as otherwise you won't be able to remotely
wake the device up if you can't talk to it. I still have no luck, will
try tomorrow with some other cards.

Luis R. Rodriguez (5):
  ath9k: do not stop the queues in driver stop
  adm8211: remove uneeded code during suspend/resume
  mac80211: fix idle trigger upon resume
  mac80211: add a struct for info upon device stop
  ath9k: Add Wake-on-Wireless-LAN support

 drivers/net/wireless/adm8211.c              |   14 +-
 drivers/net/wireless/at76c50x-usb.c         |    3 +-
 drivers/net/wireless/ath/ar9170/main.c      |    3 +-
 drivers/net/wireless/ath/ath5k/base.c       |    6 +-
 drivers/net/wireless/ath/ath9k/Makefile     |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   19 +
 drivers/net/wireless/ath/ath9k/debug.c      |   51 +++
 drivers/net/wireless/ath/ath9k/debug.h      |    4 +
 drivers/net/wireless/ath/ath9k/hw.c         |   22 ++
 drivers/net/wireless/ath/ath9k/hw.h         |   21 +
 drivers/net/wireless/ath/ath9k/initvals.h   |   31 ++
 drivers/net/wireless/ath/ath9k/main.c       |   26 ++-
 drivers/net/wireless/ath/ath9k/pci.c        |   87 +++++
 drivers/net/wireless/ath/ath9k/reg.h        |  154 ++++++++
 drivers/net/wireless/ath/ath9k/wow.c        |  543 +++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.c             |    3 +-
 drivers/net/wireless/b43legacy/main.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +-
 drivers/net/wireless/libertas_tf/main.c     |    3 +-
 drivers/net/wireless/mac80211_hwsim.c       |    3 +-
 drivers/net/wireless/mwl8k.c                |    3 +-
 drivers/net/wireless/p54/p54common.c        |    3 +-
 drivers/net/wireless/rt2x00/rt2x00.h        |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    3 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    3 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    3 +-
 drivers/net/wireless/wl12xx/main.c          |    3 +-
 drivers/net/wireless/zd1211rw/zd_mac.c      |    3 +-
 include/net/mac80211.h                      |   39 ++-
 net/mac80211/driver-ops.h                   |    5 +-
 net/mac80211/ieee80211_i.h                  |    2 +
 net/mac80211/iface.c                        |   23 +-
 net/mac80211/pm.c                           |    4 +-
 net/mac80211/util.c                         |   39 ++
 35 files changed, 1093 insertions(+), 46 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c

