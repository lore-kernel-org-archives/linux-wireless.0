Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35061 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbbLOMaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 07:30:24 -0500
Message-ID: <1450182621.3356.12.camel@sipsolutions.net> (sfid-20151215_133044_900533_628EAFA7)
Subject: pull-request: mac80211 2015-12-15
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 15 Dec 2015 13:30:21 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

After going through my patch queue, I have another set of fixes that I
think is still appropriate for the current cycle.

Two of my own restart changes there are fairly big but for the most
part just move code around so it can be called in a slightly different
order.

Let me know if there are any issues.

Thanks,
johannes


The following changes since commit c1df932c0574c13ab3ce72e969c9647ff3aaad68:

  mac80211: fix off-channel mgmt-tx uninitialized variable usage (2015-12-02 22:27:53 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-12-15

for you to fetch changes up to cf1e05c63642ce65821a6277adfc2157f7334c9d:

  mac80211: handle width changes from opmode notification IE in beacon (2015-12-15 13:16:47 +0100)

----------------------------------------------------------------
Another set of fixes:
 * memory leak fixes (from Ola)
 * operating mode notification spec compliance fix (from Eyal)
 * copy rfkill names in case pointer becomes invalid (myself)
 * two hardware restart fixes (myself)
 * get rid of "limiting TX power" log spam (myself)

----------------------------------------------------------------
Eyal Shapira (1):
      mac80211: handle width changes from opmode notification IE in beacon

Johannes Berg (4):
      rfkill: copy the name into the rfkill struct
      mac80211: run scan completed work on reconfig failure
      mac80211: reprogram in interface order
      mac80211: suppress unchanged "limiting TX power" messages

Ola Olsson (3):
      nl80211: fix a few memory leaks in reg.c
      nl80211: Fix potential memory leak in nl80211_set_wowlan
      nl80211: Fix potential memory leak in nl80211_connect

 net/mac80211/cfg.c         |   3 +-
 net/mac80211/ieee80211_i.h |   4 +-
 net/mac80211/mlme.c        |  17 ++++---
 net/mac80211/rx.c          |   3 +-
 net/mac80211/util.c        | 113 +++++++++++++++++++++++++--------------------
 net/mac80211/vht.c         |  10 ++--
 net/rfkill/core.c          |   6 +--
 net/wireless/nl80211.c     |   5 +-
 net/wireless/reg.c         |   5 +-
 9 files changed, 92 insertions(+), 74 deletions(-)
