Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35294 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbeCUMHE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 08:07:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-03-21
Date: Wed, 21 Mar 2018 13:06:54 +0100
Message-Id: <20180321120655.7354-1-johannes@sipsolutions.net> (sfid-20180321_130708_562164_12283593)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Another few fixes - one for hwsim, so not really all that interesting,
and two patches to work around an ath9k_htc problem.

Note that I pulled your net tree today, so you may need to be careful
to not fast-forward if you don't merge anything else before this.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 5f2fb802eee1df0810b47ea251942fe3fd36589a:

  ipv6: old_dport should be a __be16 in __ip6_datagram_connect() (2018-03-20 12:43:43 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-03-21

for you to fetch changes up to 60b01bcce97191f473fa869df2713143936d6ef4:

  ath9k_htc: use non-QoS NDP for AP probing (2018-03-21 13:01:55 +0100)

----------------------------------------------------------------
Two more fixes (in three patches):
 * ath9k_htc doesn't like QoS NDP frames, use regular ones
 * hwsim: set up wmediumd for radios created later

----------------------------------------------------------------
Andrew Zaborowski (1):
      mac80211_hwsim: Set wmediumd for new radios

Ben Caradoc-Davies (1):
      mac80211: add ieee80211_hw flag for QoS NDP support

Johannes Berg (1):
      ath9k_htc: use non-QoS NDP for AP probing

 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 1 +
 drivers/net/wireless/mac80211_hwsim.c         | 1 +
 include/net/mac80211.h                        | 4 ++++
 net/mac80211/debugfs.c                        | 1 +
 net/mac80211/mlme.c                           | 3 ++-
 5 files changed, 9 insertions(+), 1 deletion(-)
