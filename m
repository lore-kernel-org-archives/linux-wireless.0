Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37317 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbbAWPdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 10:33:18 -0500
Message-ID: <1422027188.2728.37.camel@sipsolutions.net> (sfid-20150123_163331_453529_0914EEB9)
Subject: pull-request: mac80211 2015-01-23
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Date: Fri, 23 Jan 2015 16:33:08 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

I have a few more fixes that seemed relevant for the current cycle and
low enough impact to merge at this point.

However, I can live with all of this going to -next as well since most
are difficult to hit in practice.

johannes


The following changes since commit 20658702e08ecd693236b443837d28863b93e872:

  cfg80211: fix deadlock during reg chan check (2015-01-07 14:53:46 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-01-23

for you to fetch changes up to 0fa7b39131576dd1baa6ca17fca53c65d7f62249:

  nl80211: fix per-station group key get/del and memory leak (2015-01-23 11:21:02 +0100)

----------------------------------------------------------------
Another set of last-minute fixes:
 * fix station double-removal when suspending while associating
 * fix the HT (802.11n) header length calculation
 * fix the CCK radiotap flag used for monitoring, a pretty
   old regression but a simple one-liner
 * fix per-station group-key handling

----------------------------------------------------------------
Fred Chou (1):
      mac80211: correct header length calculation

Johannes Berg (1):
      nl80211: fix per-station group key get/del and memory leak

Luciano Coelho (1):
      mac80211: only roll back station states for WDS when suspending

Mathy Vanhoef (1):
      mac80211: properly set CCK flag in radiotap

 net/mac80211/pm.c      | 29 +++++++++++++++--------------
 net/mac80211/rx.c      |  2 +-
 net/wireless/nl80211.c |  9 ++++-----
 net/wireless/util.c    |  6 ++++++
 4 files changed, 26 insertions(+), 20 deletions(-)


