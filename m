Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZHNAnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 20:43:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 00/25] wireless: cleanup and reorganize kconfig
Date: Thu, 13 Aug 2009 20:42:39 -0400
Message-Id: <1250210584-13374-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, here's a second iteration of this series, this time
I'm using a menu (config) which expands upon selection for
groups which have only a few drivers. For groups which do tend
to pollute your screen I've put them under their own menu
(menuconfig). At first I had each group with an appended
"wireless drivers support" but in the end that seemed too
odd so I removed it and now group drivers are pivoted by
the vendor driver.

I've kept rndis_wlan on its own although only currently
known chipsets which support it are Broadcom based.
I also don't expect old rndis_wlan users to know
that this is a broadcom driver for now so its better
to keep that apart.

Let me know if you like the color of the shed, its
understandable if you dislike it.

Luis R. Rodriguez (25):
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
  wl12xx: be consistent with the other group driver entries
  ath: be consistent with the other group driver entries

 drivers/net/wireless/Kconfig              |  455 +++++++++++++++++-----------
 drivers/net/wireless/ath/Kconfig          |    3 +-
 drivers/net/wireless/ath/ar9170/Kconfig   |    2 +-
 drivers/net/wireless/ath/ath5k/Kconfig    |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig    |    2 +-
 drivers/net/wireless/b43/Kconfig          |    2 +-
 drivers/net/wireless/b43legacy/Kconfig    |    2 +-
 drivers/net/wireless/hostap/Kconfig       |    3 +-
 drivers/net/wireless/ipw2x00/Kconfig      |    6 +-
 drivers/net/wireless/iwlwifi/Kconfig      |    2 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig |    2 +-
 drivers/net/wireless/orinoco/Kconfig      |    2 +-
 drivers/net/wireless/p54/Kconfig          |    2 +-
 drivers/net/wireless/rt2x00/Kconfig       |    2 +-
 drivers/net/wireless/wl12xx/Kconfig       |   10 +-
 drivers/net/wireless/zd1211rw/Kconfig     |    2 +-
 16 files changed, 299 insertions(+), 200 deletions(-)

