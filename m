Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFVB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 16:01:28 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCH 0/4] Add support for off-channel powersave state in mac80211
Date: Wed,  6 Feb 2013 15:01:14 -0600
Message-Id: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com> (sfid-20130206_220134_053974_F21FF2D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

As promised, here are the patches which add the off-channel powesave
state. At a high level, the changes are:

 * Expand the PS configuration flag to be 2 bits and add helper
   functions for reading and setting the modes
 * Change the terminology around PS states, i.e. disabled -> awake and
   enabled -> doze
 * Add the off-channel PS state and put it to use
 * Minor driver updates based on these changes
 * Update brcmsmac to utilize the off-channel PS state

I've made every attempt to keep things functionally equivalent for every
driver except for brcmsmac. That said, I've only been able to test on
brcmsmac and ath9k, plus a basic sanity check with iwlwifi.

Thanks,
Seth


Seth Forshee (4):
  mac80211: Convert PS configuration from a binary flag to a set of
    modes
  mac80211: Indicate hardware support for doze state rather than
    powersave
  mac80211: Add off-channel PS state
  brcmsmac: Add support for off-channel powersave

 drivers/net/wireless/adm8211.c                     |    3 +-
 drivers/net/wireless/at76c50x-usb.c                |    3 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |    3 +-
 drivers/net/wireless/ath/ath5k/base.c              |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/carl9170/fw.c             |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |    5 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 drivers/net/wireless/b43/main.c                    |    3 +-
 drivers/net/wireless/b43legacy/main.c              |    3 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   18 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    1 +
 drivers/net/wireless/iwlegacy/3945-mac.c           |    3 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.c           |    3 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |    2 +-
 drivers/net/wireless/libertas_tf/main.c            |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |    5 +-
 drivers/net/wireless/mwl8k.c                       |    3 +-
 drivers/net/wireless/p54/fwio.c                    |    2 +-
 drivers/net/wireless/p54/main.c                    |    2 +-
 drivers/net/wireless/p54/txrx.c                    |    3 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    3 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    3 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    3 +-
 drivers/net/wireless/rtlwifi/base.c                |    2 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                  |    4 +-
 drivers/net/wireless/ti/wl1251/main.c              |   10 +-
 drivers/net/wireless/ti/wlcore/main.c              |    5 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    3 +-
 include/net/mac80211.h                             |  128 +++++++++++++-------
 net/mac80211/cfg.c                                 |    2 +-
 net/mac80211/debugfs.c                             |    2 +-
 net/mac80211/ieee80211_i.h                         |    7 ++
 net/mac80211/mlme.c                                |   31 ++---
 net/mac80211/offchannel.c                          |   40 +++---
 net/mac80211/tx.c                                  |    4 +-
 net/mac80211/util.c                                |    2 +-
 51 files changed, 227 insertions(+), 143 deletions(-)

