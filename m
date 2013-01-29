Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3A2Xrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:47:48 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 0/7] Improvements to software scanning
Date: Tue, 29 Jan 2013 17:47:28 -0600
Message-Id: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com> (sfid-20130130_004752_498998_37FF4DF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes a number of problems observed during software
scanning, as described in [1].

The first four patches implement improved queue handling during
off-channel operation and add some needed flushing of the hardware
queues, as suggested by Johannes in [2]. This includes adding a new
queue stop reason of off-channel operation, a transmit path for frames
which do need to be transmitted when off-channel, and some improvements
in error handling.

The last three fix a problem specific to brcmsmac (and likely b43,
though I don't have hardware for testing b43). Broadcom hardware
actively clears the PM bit in frame control whenever the hardware is not
configured correctly, and since wireless drivers have no knowledge of
off-channel powersave such configuration cannot be done. The patches
expand the driver powersave configuration with an off-channel state and
update brcmsmac to make use of it.

Johannes: I have a couple of comments/questions for you related to these
patches.

First, in the patches I've added an offchan_tx_ok argument to the tx
operations, but this seems a little awkward to me since it has to be
propogated down through a fairly deep call stack. The alternative idea
that occurred to me is to use a tx control flag, but that seems to be
pretty crowded. Any thoughts?

Second, I attempted to test these patches with iwlwifi (Centrino
Advanced-N 6235) to verify that I didn't break anything for drivers with
hw scanning. My standard test for this involves running iperf while
triggering nearly continuous scans, but I'm seeing lots of problems
running a tcp iperf test even with unpatched 3.8-rc4. iperf with udp
does fine in either direction. I haven't had time to do any kind of
debugging yet, but I thought you'd want to know.

Thanks,
Seth

[1] http://marc.info/?l=linux-wireless&m=135766865110986&w=2
[2] http://marc.info/?l=linux-wireless&m=135838252227053&w=2


Seth Forshee (7):
  mac80211: Return a status for tx operations
  mac80211: Fix tx queue handling during scans
  mac80211: Improve error handling for off-channel operation
  mac80211: Add flushes before going off-channel
  mac80211: Expand powersave configuration flag to be two bits
  mac80211: Add off-channel powersave state
  brcmsmac: Add support for off-channel powersave

 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |    2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   15 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    9 ++
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 +
 drivers/net/wireless/iwlwifi/dvm/power.c           |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |    2 +-
 drivers/net/wireless/p54/fwio.c                    |    2 +-
 drivers/net/wireless/p54/txrx.c                    |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    3 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    3 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                  |    4 +-
 drivers/net/wireless/ti/wl1251/main.c              |    7 +-
 drivers/net/wireless/ti/wlcore/main.c              |    6 +-
 include/net/mac80211.h                             |  125 +++++++++++++++----
 net/mac80211/agg-tx.c                              |    4 +-
 net/mac80211/cfg.c                                 |    2 +-
 net/mac80211/ht.c                                  |    2 +-
 net/mac80211/ieee80211_i.h                         |   72 ++++++++---
 net/mac80211/mlme.c                                |   32 ++---
 net/mac80211/offchannel.c                          |  114 +++++++++--------
 net/mac80211/scan.c                                |   44 +++++--
 net/mac80211/sta_info.c                            |    2 +-
 net/mac80211/tx.c                                  |  131 +++++++++++---------
 net/mac80211/util.c                                |   13 +-
 34 files changed, 400 insertions(+), 225 deletions(-)

