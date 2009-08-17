Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666AbZHQR1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 13:27:31 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v5 00/33] wireless: kconfig updates
Date: Mon, 17 Aug 2009 13:26:59 -0400
Message-Id: <1250530052-14783-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is revision number 5 on the wireless kconfig updates, I apologize
for the spam but I had to rebase based on reviews on some earlier
patches. In this series I've removed the .ko references for modules
both in the commit logs and in the kconfig entries, I've also
made the changes pointed out in the TI kconfig, and left the comments
on the mac80211 and cfg80211 kconfig simpler based on johill's feedback.

I left out the patch that selects cfg80211 when you select mac80211
as there is an issue there that is still under review (building cfg80211
and mac80211 built-in but rfkill as a module).

Luis R. Rodriguez (33):
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
  wireless: mark prism54 as deprecated and mark for removal
  wireless: update top level wireless driver entry
  wireless: update wireless kconfig description
  wireless: update cfg80211 kconfig entry
  wireless: update reg debug kconfig entry
  wireless: update WIRELESS_EXT kconfig entry
  wireless: update mac80211 kconfig entry
  wireless: remove mac80211 rate selection extra menu

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
 drivers/net/wireless/wl12xx/Kconfig        |   17 +-
 drivers/net/wireless/zd1211rw/Kconfig      |    2 +-
 net/Kconfig                                |    8 +-
 net/mac80211/Kconfig                       |   24 +-
 net/wireless/Kconfig                       |   27 ++-
 20 files changed, 406 insertions(+), 255 deletions(-)

