Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33942 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933177AbeF2Hs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:48:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-06-29
Date: Fri, 29 Jun 2018 09:48:51 +0200
Message-Id: <20180629074852.20096-1-johannes@sipsolutions.net> (sfid-20180629_094906_744764_8F25C54C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

For the current release, I have a few fixes. No sense waiting
for more, and most of these have been around for a while.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 4205c88eaf17b5f3ee30032d68df55cd5d9077a1:

  net: stmmac: Set DMA buffer size in HW (2018-06-28 22:24:25 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-06-29

for you to fetch changes up to 95bca62fb723a121954fc7ae5473bb2c1f0d5986:

  nl80211: check nla_parse_nested() return values (2018-06-29 09:44:51 +0200)

----------------------------------------------------------------
Just three fixes:
 * fix HT operation in mesh mode
 * disable preemption in control frame TX
 * check nla_parse_nested() return values
   where missing (two places)

----------------------------------------------------------------
Bob Copeland (1):
      nl80211: relax ht operation checks for mesh

Denis Kenzior (1):
      mac80211: disable BHs/preemption in ieee80211_tx_control_port()

Johannes Berg (1):
      nl80211: check nla_parse_nested() return values

 net/mac80211/tx.c      |  2 ++
 net/wireless/nl80211.c | 35 ++++++++++++++---------------------
 2 files changed, 16 insertions(+), 21 deletions(-)
