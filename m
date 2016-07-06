Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41229 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbcGFPfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 11:35:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2016-07-06
Date: Wed,  6 Jul 2016 17:34:59 +0200
Message-Id: <1467819300-29764-1-git-send-email-johannes@sipsolutions.net> (sfid-20160706_173522_250436_E973354F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

And here's another set of new things. This is the last one I'll send
since I'll be away for a bit.

Let me know if there's any problem.

Thanks,
johannes



The following changes since commit ee58b57100ca953da7320c285315a95db2f7053d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2016-06-30 05:03:36 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2016-07-06

for you to fetch changes up to 7d27a0ba7adc8ef30c2aae7592fce4c162aee4df:

  cfg80211: Add mesh peer AID setting API (2016-07-06 15:04:52 +0200)

----------------------------------------------------------------
One more set of new features:
 * beacon report (for radio measurement) support in cfg80211/mac80211
 * hwsim: allow wmediumd in namespaces
 * mac80211: extend 160MHz workaround to CSA IEs
 * mesh: properly encrypt group-addressed privacy action frames
 * mesh: allow setting peer AID
 * first steps for MU-MIMO monitor mode
 * along with various other cleanups and improvements

----------------------------------------------------------------
Arnd Bergmann (1):
      nl80211: improve nl80211_parse_mesh_config type checking

Aviya Erenfeld (1):
      nl80211: Add API to support VHT MU-MIMO air sniffer

Avraham Stern (2):
      nl80211: support beacon report scanning
      mac80211: Add support for beacon report radio measurement

Bob Copeland (1):
      mac80211: use common cleanup for user/!user_mpm

Dan Carpenter (1):
      mac80211: silence an uninitialized variable warning

Ilan Peer (1):
      mac80211_hwsim: Add radar bandwidths to the P2P Device combination

Johannes Berg (4):
      mac80211: agg-rx: refuse ADDBA Request with timeout update
      mac80211_hwsim: use signed net namespace ID
      mac80211: report failure to start (partial) scan as scan abort
      mac80211: parse wide bandwidth channel switch IE with workaround

Martin Willi (1):
      mac80211_hwsim: Allow wmediumd to attach to radios created in its netns

Masashi Honma (3):
      wireless: Use macro instead of number
      mac80211: Encrypt "Group addressed privacy" action frames
      cfg80211: Add mesh peer AID setting API

Michal Kazior (1):
      mac80211: fix fq lockdep warnings

 drivers/net/wireless/ath/ath10k/mac.c              |  14 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  17 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   5 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   6 +-
 drivers/net/wireless/ath/wil6210/main.c            |  12 +-
 drivers/net/wireless/ath/wil6210/p2p.c             |   6 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   8 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   5 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   6 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  37 ++++-
 drivers/net/wireless/intersil/orinoco/scan.c       |  12 +-
 drivers/net/wireless/mac80211_hwsim.c              | 130 +++++++++++-----
 drivers/net/wireless/marvell/libertas/cfg.c        |  11 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  12 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   6 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  12 +-
 drivers/net/wireless/rndis_wlan.c                  |  10 +-
 drivers/net/wireless/st/cw1200/scan.c              |   6 +-
 drivers/net/wireless/ti/wl1251/event.c             |   6 +-
 drivers/net/wireless/ti/wl1251/main.c              |   6 +-
 drivers/net/wireless/ti/wlcore/main.c              |  11 +-
 drivers/net/wireless/ti/wlcore/scan.c              |   5 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  11 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  |  12 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   5 +-
 include/linux/ieee80211.h                          |  32 +++-
 include/net/cfg80211.h                             |  52 ++++++-
 include/net/mac80211.h                             |   5 +-
 include/uapi/linux/nl80211.h                       |  76 +++++++++
 net/mac80211/agg-rx.c                              |  18 +++
 net/mac80211/cfg.c                                 |   1 +
 net/mac80211/ieee80211_i.h                         |   1 +
 net/mac80211/mesh.c                                |  20 +--
 net/mac80211/mesh_plink.c                          |  16 +-
 net/mac80211/rx.c                                  |   7 +-
 net/mac80211/scan.c                                |  42 ++++-
 net/mac80211/spectmgmt.c                           |  45 ++----
 net/mac80211/tdls.c                                |   1 +
 net/mac80211/tx.c                                  |  10 +-
 net/wireless/core.c                                |   4 +-
 net/wireless/core.h                                |  12 ++
 net/wireless/nl80211.c                             | 173 +++++++++++++++++----
 net/wireless/scan.c                                |  18 ++-
 net/wireless/trace.h                               |  33 +++-
 46 files changed, 744 insertions(+), 205 deletions(-)
