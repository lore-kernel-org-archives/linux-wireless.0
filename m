Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3AQWI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 17:08:56 -0500
Message-ID: <1358460559.4653.6.camel@jlt4.sipsolutions.net> (sfid-20130117_230859_855029_47D7487F)
Subject: pull-request: mac80211 2013-01-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 23:09:19 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please pull my mac80211 tree. 

I have a few small fixes for you:
 * some mesh frames would cause encryption warnings -- fixes from Bob
 * scanning would pretty much break an association if we transmitted
   anything to the AP while scanning -- fix from Stanislaw
 * mode injection was broken by channel contexts -- fix from Felix
 * FT roaming was broken: hardware crypto would get disabled by it

Let me know if there are any problems.

Thanks,
johannes


The following changes since commit 09b1426e7fcec510aba55a761da5004e47a11ce3:

  mac80211: fix maximum MTU (2013-01-03 13:00:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 8680451f38a64bd270233b3c0eeb7c45f2b5efe3:

  mac80211: add encrypt headroom to PERR frames (2013-01-16 23:24:51 +0100)

----------------------------------------------------------------
Bob Copeland (2):
      mac80211: set NEED_TXPROCESSING for PERR frames
      mac80211: add encrypt headroom to PERR frames

Felix Fietkau (1):
      mac80211: fix monitor mode injection

Johannes Berg (1):
      mac80211: fix FT roaming

Stanislaw Gruszka (1):
      mac80211: synchronize scan off/on-channel and PS states

 net/mac80211/cfg.c         | 12 +++++++++++-
 net/mac80211/ieee80211_i.h |  6 ++----
 net/mac80211/mesh_hwmp.c   |  5 ++++-
 net/mac80211/offchannel.c  | 19 +++++++------------
 net/mac80211/scan.c        | 15 +++++----------
 net/mac80211/tx.c          |  9 ++++++---
 6 files changed, 35 insertions(+), 31 deletions(-)


