Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZHNU0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:26:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v4 00/34] wireless: update/re-arrange kconfigs
Date: Fri, 14 Aug 2009 16:25:25 -0400
Message-Id: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the 4th iteration of this series (3rd one was
just some two small updates). I made a change which did require
rebasing the others so just sending a new series. This is also
now rebased on today's wireless testing.

This series incorporates the changes made by Gabor and Luciano.

I've also expanded this and updated the net/wireless/Kconfig,
net/mac80211/Kconfig, the top level description for Wireless LAN
and made some more changes talked about on IRC for prism54.ko.

The only other thing left which I feel could use some updating
is the rate control selection for mac80211. I am able to select
only minstrel as the default. I believe this should not even be
visible if that is the default. Also did we really plan for
PID to be only selectable if embedded? IIRC I was able to build
it last only when selecting embedded. Anyway we can enhance
this if needed later.

Holger asked for a uni-bomb patch, here it is, for your convenience:

http://bombadil.infradead.org/~mcgrof/patches/wireless/2009/08/08-14-wireless-kconfig-all.patch

You can just git am that one file on top of today's wireless-testing.

Luis R. Rodriguez (34):
  wireless: move iwmc3200wifi closer to the other intel drivers
  wireless: group intel wireless drivers on kconfig
  wireless: move MWL8K right below libertas on kconfig
  wireless: group Marvell wireless in kconfig
  wireless: move p54 and prism54 drivers closer on kconfig
  wireless: group Conexant / STEricsson drivers in kconfig
  wireless: move zd1211rw option closer to old ZyDAS on kconfig
  wireless: group ZyDAS wireless drivers in kconfig
  wireless: group Realtek wireless on kconfig
  wireless: group Broadcom drivers on kconfig
  wireless: clarify rndis_wlan is not broadcom specific
  wireless: group Atmel wireless together on kconfig
  wireless: move AIRO_CS closer to AIRO_CS
  wireless: group Cisco together on kconfig
  wireless: move group drivers together
  wireless: organize group drivers alphabetically
  wireless: remove IEEE 802.11 description on hostapd
  wireless: move mac80211_hwsim to top level wireless driver menu
  wireless: organize individual drivers alphabetically
  wireless: simplify WLAN_PRE80211 entries
  wireless: simplify WLAN_80211 entries
  wireless: remove "Wireless" from rndis kconfig entry
  wireless: downgrade TI driver from menuconfig to config
  wireless: Update TI kconfig description
  wireless: make ath consistent with the other groups
  wireless: update top level wireless driver entry
  wireless: update wireless kconfig description
  wireless: update cfg80211 kconfig entry
  wireless: update reg debug kconfig entry
  wireless: update WIRELESS_EXT kconfig entry
  wireless: update mac80211 kconfig entry
  wireless: make mac80211 select cfg80211
  wireless: remove mac80211 rate selection extra menu
  wireless: mark prism54.ko as deprecated and mark for removal

 Documentation/feature-removal-schedule.txt |   29 ++
 drivers/net/wireless/Kconfig               |  522 ++++++++++++++++------------
 drivers/net/wireless/ath/Kconfig           |    3 +-
 drivers/net/wireless/ath/ar9170/Kconfig    |    2 +-
 drivers/net/wireless/ath/ath5k/Kconfig     |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig     |    2 +-
 drivers/net/wireless/b43/Kconfig           |    2 +-
 drivers/net/wireless/b43legacy/Kconfig     |    2 +-
 drivers/net/wireless/hostap/Kconfig        |    3 +-
 drivers/net/wireless/ipw2x00/Kconfig       |    6 +-
 drivers/net/wireless/iwlwifi/Kconfig       |    2 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    2 +-
 drivers/net/wireless/orinoco/Kconfig       |    2 +-
 drivers/net/wireless/p54/Kconfig           |    2 +-
 drivers/net/wireless/rt2x00/Kconfig        |    2 +-
 drivers/net/wireless/wl12xx/Kconfig        |   13 +-
 drivers/net/wireless/zd1211rw/Kconfig      |    2 +-
 net/Kconfig                                |    8 +-
 net/mac80211/Kconfig                       |   32 ++-
 net/wireless/Kconfig                       |   32 ++-
 20 files changed, 414 insertions(+), 256 deletions(-)

