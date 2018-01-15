Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35506 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbeAOKv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 05:51:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-01-15
Date: Mon, 15 Jan 2018 11:51:53 +0100
Message-Id: <20180115105154.9727-1-johannes@sipsolutions.net> (sfid-20180115_115211_473148_CDCE48F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

I know this comes last minute, so if it doesn't make it then
I guess we can live with that, but I got the earliest of the
patches here on Wednesday last week, and that was the most
uninteresting one - the others didn't come in until Saturday.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 8155aedf512edd3f88ef19f7cacf476ace7d1322:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2018-01-14 11:01:33 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-01-15

for you to fetch changes up to 59b179b48ce2a6076448a44531242ac2b3f6cef2:

  cfg80211: check dev_set_name() return value (2018-01-15 11:35:06 +0100)

----------------------------------------------------------------
More fixes:
 * hwsim:
    - properly flush deletion works at module unload
    - validate # of channels passed from userspace
 * cfg80211:
    - fix RCU locking regression
    - initialize on-stack channel data for nl80211 event
    - check dev_set_name() return value

----------------------------------------------------------------
Benjamin Beichler (1):
      mac80211_hwsim: add workqueue to wait for deferred radio deletion on mod unload

Dominik Brodowski (1):
      nl80211: take RCU read lock when calling ieee80211_bss_get_ie()

Johannes Berg (3):
      cfg80211: fully initialize old channel for event
      mac80211_hwsim: validate number of different channels
      cfg80211: check dev_set_name() return value

 drivers/net/wireless/mac80211_hwsim.c | 17 +++++++++++++++--
 include/net/cfg80211.h                |  2 ++
 net/wireless/core.c                   |  8 +++++++-
 net/wireless/core.h                   |  2 --
 net/wireless/nl80211.c                | 11 +++++++----
 net/wireless/reg.c                    |  3 +--
 6 files changed, 32 insertions(+), 11 deletions(-)
