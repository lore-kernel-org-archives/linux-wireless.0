Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57738 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388391AbeGXIcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:32:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2018-07-24
Date: Tue, 24 Jul 2018 09:25:57 +0200
Message-Id: <20180724072558.15099-1-johannes@sipsolutions.net> (sfid-20180724_092734_496889_BDF7D0A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Also have a few changes for -next, figured I should get this
out too.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit c47078d6a33fd78d882200cdaacbcfcd63318234:

  tcp: remove redundant SOCK_DONE checks (2018-07-08 17:14:58 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-davem-2018-07-24

for you to fetch changes up to 133bf90dbb8b873286f8ec2e81ba26e863114b8c:

  mac80211: restrict delayed tailroom needed decrement (2018-07-24 09:21:12 +0200)

----------------------------------------------------------------
Only a few things:
 * HE (802.11ax) support in HWSIM
 * bypass TXQ with NDP frames as they're special
 * convert ahash -> shash in lib80211 TKIP
 * avoid playing with tailroom counter defer unless
   needed to avoid issues in some cases

----------------------------------------------------------------
Ilan Peer (1):
      mac80211_hwsim: Add support for HE

Johannes Berg (1):
      mac80211: don't put null-data frames on the normal TXQ

Kees Cook (1):
      wireless/lib80211: Convert from ahash to shash

Manikanta Pubbisetty (1):
      mac80211: restrict delayed tailroom needed decrement

 drivers/net/wireless/mac80211_hwsim.c | 123 ++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c                    |   2 +-
 net/mac80211/key.c                    |  24 ++++---
 net/mac80211/tx.c                     |   2 +-
 net/wireless/lib80211_crypt_tkip.c    |  55 ++++++++-------
 5 files changed, 170 insertions(+), 36 deletions(-)
