Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32890 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbcGEMXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:07 +0300
Message-Id: <1467721394-8195-1-git-send-email-luca@coelho.fi> (sfid-20160705_142325_234148_69051442)
Subject: [PATCH 0/7] mac80211/cfg80211: a bunch of patches from our internal tree
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi Johannes,

These are some cfg80211/mac80211 patches that were pending upstreaming
in our internal tree (I think you know about them ;).

Please let me know if everything is okay.

There is a couple of checkpatch >80 chars line warnings, which I
decided to ignore, since fixing them would make things uglier.

One patch required changes in other drivers.  Those changes are
compile-tested only.

Cheers,
Luca.

Aviya Erenfeld (1):
  nl80211: Add API to support VHT MU-MIMO air sniffer

Avraham Stern (2):
  nl80211: Add info to scan results to support beacon report
  mac80211: Add support for beacon report radio measurement

Gregory Greenman (1):
  cfg80211: handle failed skb allocation

Ilan Peer (1):
  mac80211_hwsim: Add radar bandwidths to the P2P Device combination

Johannes Berg (2):
  mac80211: report failure to start (partial) scan as scan abort
  mac80211: parse wide bandwidth channel switch IE with workaround

 drivers/net/wireless/ath/ath10k/mac.c         | 14 ++++--
 drivers/net/wireless/ath/ath9k/channel.c      |  5 +-
 drivers/net/wireless/atmel/at76c50x-usb.c     |  5 +-
 drivers/net/wireless/intel/iwlegacy/common.c  |  6 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 37 +++++++++++---
 drivers/net/wireless/mac80211_hwsim.c         | 36 ++++++--------
 drivers/net/wireless/st/cw1200/scan.c         |  6 ++-
 drivers/net/wireless/ti/wl1251/event.c        |  6 ++-
 drivers/net/wireless/ti/wl1251/main.c         |  6 ++-
 drivers/net/wireless/ti/wlcore/main.c         | 11 ++++-
 drivers/net/wireless/ti/wlcore/scan.c         |  5 +-
 include/net/cfg80211.h                        | 50 ++++++++++++++++---
 include/net/mac80211.h                        |  5 +-
 include/uapi/linux/nl80211.h                  | 71 +++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h                    |  1 +
 net/mac80211/scan.c                           | 42 ++++++++++++++--
 net/mac80211/spectmgmt.c                      | 45 +++++++----------
 net/wireless/core.c                           |  4 +-
 net/wireless/core.h                           | 12 +++++
 net/wireless/nl80211.c                        | 63 ++++++++++++++++++++++++
 net/wireless/scan.c                           | 18 ++++---
 net/wireless/trace.h                          | 33 ++++++++++---
 net/wireless/util.c                           |  2 +
 24 files changed, 386 insertions(+), 103 deletions(-)

-- 
2.8.1

