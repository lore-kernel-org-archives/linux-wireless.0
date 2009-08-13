Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbZHMTbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:31:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/20] wireless: cleanup and organize drivers kconfig better
Date: Thu, 13 Aug 2009 15:31:29 -0400
Message-Id: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series consists of a lot of organizational changes on
the wireless drivers kconfig. We also do some cleanup towards the
end to help simplify the individual kconfig entries. Hope is to
help users compiling their kernels find their drivers as quickly
as possible. It also makes it easier to understand which driver
are for what vendor chipsets as some of vendor drivers were
completely scattered apart.

This might be some sort of OCD kicking in.

Luis R. Rodriguez (20):
  wireless: group intel wireless drivers on kconfig
  wireless: move MWL8K right below Libertas on kconfig
  wireless: move Marvell wireless under a kconfig option
  wireless: move p54 and prism54 drivers closeer on kconfig
  wireless: group conexant / STEricsson wireless drivers in kconfig
  wireless: move zd1211rw option closer to old ZyDAS on kconfig
  wireless: group ZyDAS wireless drivers in kconfig
  wireless: group Realtek wireless on kconfig
  wireless: move bcm drivers above rndis wlan driver
  wireless: group Broadcom wireless drivers on kconfig
  wireless: group Atmel wireless together on kconfig
  wireless: move AIRO_CS closer to AIRO_CS
  wireless: group Cisco wireless together on kconfig
  wireless: move drivers with menuconfigs together on kconfig
  wireless: organize group drivers alphabetically
  wireless: remove IEEE 802.11 description on hostapd
  wireless: move mac80211_hwsim to top level wireless driver menu
  wireless: organize individual drivers alphabetically
  wireless: simplify WLAN_PRE80211 entries
  wireless: simplify WLAN_80211 entries

 drivers/net/wireless/Kconfig              |  450 +++++++++++++++++------------
 drivers/net/wireless/ath/Kconfig          |    1 -
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
 drivers/net/wireless/wl12xx/Kconfig       |    2 +-
 drivers/net/wireless/zd1211rw/Kconfig     |    2 +-
 16 files changed, 287 insertions(+), 197 deletions(-)

