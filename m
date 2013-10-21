Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45903 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3JURWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:43 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so6788244wgg.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:42 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 00/14] wlan: consolidate passive-scan and no-ibss flags
Date: Mon, 21 Oct 2013 19:22:24 +0200
Message-Id: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192245_566467_D29A993F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Johannes,

This series addresses consolidating passive-scan and no-ibss flags.
Since its crosses over drivers I'll let you guys decide what tree
this goes into.

Luis R. Rodriguez (14):
  cfg80211: consolidate passive-scan and no-ibss flags
  ath: consolidate no-ibss and passive scan to no-ir
  ath10k: consolidate no-ibss and passive scan to no-ir
  brcm80211: consolidate no-ibss and passive scan to no-ir
  ipw2x00: consolidate no-ibss and passive scan to no-ir
  mac80211_hwsim: consolidate no-ibss and passive scan to no-ir
  mwifiex: consolidate no-ibss and passive scan to no-ir
  iwlegacy: consolidate no-ibss and passive scan to no-ir
  rtlwifi: consolidate no-ibss and passive scan to no-ir
  mac80211: consolidate no-ibss and passive scan to no-ir
  ti: consolidate no-ibss and passive scan to no-ir
  cw1200: consolidate no-ibss and passive scan to no-ir
  iwlwifi: consolidate no-ibss and passive scan to no-ir
  cfg80211: remove internal passive-scan and no-ibss guards

 Documentation/networking/regulatory.txt            |  4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  4 +-
 drivers/net/wireless/ath/regd.c                    | 34 ++++-------
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  6 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  | 33 ++++-------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  | 66 +++++++++++-----------
 drivers/net/wireless/cw1200/scan.c                 | 10 ++--
 drivers/net/wireless/ipw2x00/ipw2100.c             |  8 +--
 drivers/net/wireless/ipw2x00/ipw2200.c             | 16 ++----
 drivers/net/wireless/iwlegacy/3945-mac.c           |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |  2 +-
 drivers/net/wireless/iwlegacy/common.c             |  4 +-
 drivers/net/wireless/iwlegacy/debug.c              |  8 +--
 drivers/net/wireless/iwlwifi/dvm/debugfs.c         |  8 +--
 drivers/net/wireless/iwlwifi/dvm/scan.c            |  2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c    |  4 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |  4 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |  4 +-
 drivers/net/wireless/mac80211_hwsim.c              |  4 +-
 drivers/net/wireless/mwifiex/cfg80211.c            | 14 ++---
 drivers/net/wireless/mwifiex/scan.c                |  4 +-
 drivers/net/wireless/rtlwifi/regd.c                | 48 +++++++---------
 drivers/net/wireless/ti/wl12xx/scan.c              |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |  2 +-
 drivers/net/wireless/ti/wlcore/main.c              |  3 +-
 drivers/net/wireless/ti/wlcore/scan.c              |  8 +--
 include/net/cfg80211.h                             |  9 ++-
 include/uapi/linux/nl80211.h                       | 30 ++++++----
 net/mac80211/scan.c                                | 10 ++--
 net/mac80211/tx.c                                  |  3 +-
 net/wireless/chan.c                                |  3 +-
 net/wireless/genregdb.awk                          |  7 ++-
 net/wireless/ibss.c                                |  4 +-
 net/wireless/mesh.c                                |  3 +-
 net/wireless/nl80211.c                             | 12 ++--
 net/wireless/reg.c                                 | 33 ++++-------
 37 files changed, 189 insertions(+), 231 deletions(-)

-- 
1.8.4.rc3

