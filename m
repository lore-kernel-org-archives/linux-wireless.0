Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40750 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbeEWJsF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 05:48:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-05-23
Date: Wed, 23 May 2018 11:47:57 +0200
Message-Id: <20180523094758.8892-1-johannes@sipsolutions.net> (sfid-20180523_114857_158962_5F13B356)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Just another handful of fixes as we wind down towards the
merge window.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 6caf9fb3bda17df59de4ed6ed4950c43ca1361e3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2018-05-17 23:33:52 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-05-23

for you to fetch changes up to fed4825096cfbbfd654cb292ab6eb193911aef01:

  mac80211_hwsim: Fix radio dump for radio idx 0 (2018-05-22 10:24:17 +0200)

----------------------------------------------------------------
A handful of fixes:
 * hwsim radio dump wasn't working for the first radio
 * mesh was updating statistics incorrectly
 * a netlink message allocation was possibly too short
 * wiphy name limit was still too long
 * in certain cases regdb query could find a NULL pointer

----------------------------------------------------------------
Andrew Zaborowski (1):
      mac80211_hwsim: Fix radio dump for radio idx 0

Bob Copeland (1):
      mac80211: mesh: fix premature update of rc stats

Dedy Lansky (1):
      nl80211: fix nlmsg allocation in cfg80211_ft_event

Eric Biggers (1):
      cfg80211: further limit wiphy names to 64 bytes

Haim Dreyfuss (1):
      cfg80211: fix NULL pointer derference when querying regdb

 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 include/uapi/linux/nl80211.h          | 2 +-
 net/mac80211/mesh_plink.c             | 8 ++++----
 net/wireless/nl80211.c                | 3 ++-
 net/wireless/reg.c                    | 3 +++
 5 files changed, 12 insertions(+), 8 deletions(-)
