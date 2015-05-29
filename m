Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37870 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbbE2LZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:25:17 -0400
Message-ID: <1432898714.2104.15.camel@sipsolutions.net> (sfid-20150529_132523_581856_6A992446)
Subject: pull-request: mac80211-next 2015-05-29
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 May 2015 13:25:14 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

It's been a while since I sent anything for -next, but with the merge
window getting closer I wanted to send a few more things, mostly fixes.
Of course I expect that tomorrow somebody will send an important fix,
but hey :-)

johannes


The following changes since commit 658358cec93a7130615cfc1d6843ab07e49625e6:

  mac80211: fix throughput LED trigger (2015-05-11 19:16:04 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2015-05-29

for you to fetch changes up to f7959e9c73200f2ae361d0d311aa501f2c6a05c7:

  net: rfkill: gpio: make better use of gpiod API (2015-05-29 13:13:45 +0200)

----------------------------------------------------------------
As we get closer to the merge window, here are a few
more things for -next:
 * disconnect TDLS stations on CSA to avoid issues
 * fix a memory leak introduced in a recent commit
 * switch rfkill and cfg80211 to PM ops
 * in an unlikely scenario, prevent a bookkeeping
   value to get corrupted leading to dropped packets
 * fix a crash in VLAN assignment
 * switch rfkill-gpio to more modern gpiod API
 * send disconnected event to userspace with proper
   local/remote indication

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: disconnect TDLS stations on STA CSA

Johannes Berg (3):
      mac80211: fix memory leak
      mac80211: add missing drv_priv description for TXQ struct
      cfg80211: properly send NL80211_ATTR_DISCONNECTED_BY_AP in disconnect

Lars-Peter Clausen (2):
      net: rfkill: Switch to PM ops
      cfg80211: Switch to PM ops

Michal Kazior (3):
      mac80211: check fast-xmit on station change
      mac80211: prevent possible crypto tx tailroom corruption
      cfg80211: ignore netif running state when changing iftype

Uwe Kleine-König (1):
      net: rfkill: gpio: make better use of gpiod API

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  4 ++--
 drivers/net/wireless/ath/wil6210/main.c            |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  4 ++--
 drivers/net/wireless/libertas/cfg.c                | 13 +++++------
 drivers/net/wireless/libertas/cfg.h                |  3 ++-
 drivers/net/wireless/libertas/cmd.h                |  3 ++-
 drivers/net/wireless/libertas/cmdresp.c            | 13 ++++++-----
 drivers/net/wireless/mwifiex/join.c                |  2 +-
 drivers/net/wireless/mwifiex/sta_event.c           |  2 +-
 drivers/net/wireless/rndis_wlan.c                  |  2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  2 +-
 drivers/staging/wlan-ng/cfg80211.c                 |  2 +-
 include/net/cfg80211.h                             |  4 +++-
 include/net/mac80211.h                             |  1 +
 net/mac80211/cfg.c                                 |  1 +
 net/mac80211/main.c                                |  7 +++++-
 net/mac80211/mlme.c                                | 26 ++++++++++++++++++++++
 net/mac80211/tdls.c                                |  6 +++++
 net/rfkill/core.c                                  | 12 +++++++---
 net/rfkill/rfkill-gpio.c                           | 24 +++++++++-----------
 net/wireless/core.h                                |  1 +
 net/wireless/sme.c                                 |  4 +++-
 net/wireless/sysfs.c                               | 14 +++++++-----
 net/wireless/util.c                                |  5 +++--
 24 files changed, 105 insertions(+), 52 deletions(-)


