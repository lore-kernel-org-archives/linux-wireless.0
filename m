Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56621 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZGYArg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 20:47:36 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211/drivers: add new mac80211 workqueue API
Date: Fri, 24 Jul 2009 20:47:30 -0400
Message-Id: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set move the mac80211 workqueue struct privately into mac80211
and exposes it only through helpers. We do this to aid proper suspend
support, these could eventually be extended for further sanity
checkings or considerations.

We also fix two initial warnings we hit with this, one on mac80211, the
other on ath9k.

Luis R. Rodriguez (3):
  mac80211: redefine usage of the mac80211 workqueue
  mac80211: do not queue work after suspend in the dynamic ps timer
  ath9k: cancel xmit poll work at stop() callback

 drivers/net/wireless/at76c50x-usb.c         |   12 +++---
 drivers/net/wireless/ath/ar9170/led.c       |   11 +++--
 drivers/net/wireless/ath/ar9170/main.c      |   28 +++++++-----
 drivers/net/wireless/ath/ath9k/main.c       |   17 ++++---
 drivers/net/wireless/ath/ath9k/virtual.c    |   17 ++++----
 drivers/net/wireless/ath/ath9k/xmit.c       |    2 +-
 drivers/net/wireless/b43/main.c             |    8 ++--
 drivers/net/wireless/b43/phy_common.c       |    2 +-
 drivers/net/wireless/b43/pio.c              |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    8 ++--
 drivers/net/wireless/p54/led.c              |    5 +-
 drivers/net/wireless/p54/main.c             |    2 +-
 drivers/net/wireless/p54/p54spi.c           |    4 +-
 drivers/net/wireless/p54/txrx.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00link.c    |    8 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.c |   10 ++--
 include/net/mac80211.h                      |   61 +++++++++++++++++++++++----
 net/mac80211/ibss.c                         |    6 +-
 net/mac80211/ieee80211_i.h                  |    6 +++
 net/mac80211/iface.c                        |    4 +-
 net/mac80211/main.c                         |    8 ++--
 net/mac80211/mesh.c                         |   10 ++--
 net/mac80211/mesh_hwmp.c                    |    4 +-
 net/mac80211/mlme.c                         |   50 ++++++++++------------
 net/mac80211/pm.c                           |    4 +-
 net/mac80211/scan.c                         |    8 ++--
 net/mac80211/tx.c                           |    2 +-
 net/mac80211/util.c                         |   49 +++++++++++++++++++++
 31 files changed, 231 insertions(+), 125 deletions(-)

