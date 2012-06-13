Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2FMNwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:52:21 -0400
Message-ID: <1339595539.4519.42.camel@jlt3.sipsolutions.net> (sfid-20120613_155224_024594_44042E09)
Subject: pull-request: mac80211.git 2012-06-13
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 15:52:19 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please pull my mac80211.git tree to get the recent fixes for the stack
that are relevant for 3.5 still.

I've included David's fix for leaving a scan request dangling if we
abort a connection while polling it, a few kernel-doc fixes, Michal's
fix to interface validation and two fixes from Eliad, one to avoid a
possible deadlock and one to not call the driver unexpectedly.

Thanks,
johannes

-----

The following changes since commit 6aee4ca3d2217d3f76469e5ed576d62695f0912a:

  mac80211: add back channel change flag (2012-06-08 13:47:08 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 79543d8eecc0957ac6fe3ec1e2486ad31d4b67a3:

  mac80211: stop polling in disassociation (2012-06-13 10:17:55 +0200)

----------------------------------------------------------------
Ashok Nagarajan (1):
      mac80211: add missing kernel-doc

David Spinadel (1):
      mac80211: stop polling in disassociation

Eliad Peller (2):
      cfg80211: fix potential deadlock in regulatory
      mac80211: check sdata_running on ieee80211_set_bitrate_mask

Johannes Berg (1):
      mac80211: add some missing kernel-doc

Michal Kazior (1):
      cfg80211: check iface combinations only when iface is running

 include/net/mac80211.h  |    6 ++++++
 net/mac80211/cfg.c      |    3 +++
 net/mac80211/mlme.c     |    4 ++--
 net/mac80211/sta_info.h |    5 +++++
 net/wireless/reg.c      |    2 +-
 net/wireless/util.c     |    2 +-
 6 files changed, 18 insertions(+), 4 deletions(-)


