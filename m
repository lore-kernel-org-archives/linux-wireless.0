Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52161 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaKDI5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 03:57:31 -0500
Message-ID: <1415091441.2064.0.camel@sipsolutions.net> (sfid-20141104_095746_858781_5E2941BF)
Subject: pull-request: mac80211 2014-11-04
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 04 Nov 2014 09:57:21 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here are a few more fixes for 3.18, I hope that's not a problem.

johannes

---

The following changes since commit 11b2357d5dbce999803e9055f8c09829a8a87db4:

  mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats (2014-10-20 16:37:01 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-11-04

for you to fetch changes up to b8fff407a180286aa683d543d878d98d9fc57b13:

  mac80211: fix use-after-free in defragmentation (2014-11-03 14:28:50 +0100)

----------------------------------------------------------------
This contains another small set of fixes for 3.18, these are all
over the place and most of the bugs are old, one even dates back
to the original mac80211 we merged into the kernel.

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: flush keys for AP mode on ieee80211_do_stop

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Junjie Mao (1):
      mac80211_hwsim: release driver when ieee80211_register_hw fails

Luciano Coelho (2):
      mac80211: use secondary channel offset IE also beacons during CSA
      mac80211: schedule the actual switch of the station before CSA count 0

 drivers/net/wireless/mac80211_hwsim.c |  4 +++-
 net/mac80211/ibss.c                   |  2 +-
 net/mac80211/ieee80211_i.h            |  3 +--
 net/mac80211/iface.c                  | 18 ++++++++++++------
 net/mac80211/mesh.c                   |  2 +-
 net/mac80211/mlme.c                   |  5 +++--
 net/mac80211/rx.c                     | 14 +++++++-------
 net/mac80211/spectmgmt.c              | 18 ++++++------------
 8 files changed, 34 insertions(+), 32 deletions(-)


