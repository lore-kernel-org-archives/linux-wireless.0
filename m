Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:33288 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbeICQfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 12:35:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: pull-request: mac80211 2018-09-03
Date: Mon,  3 Sep 2018 14:15:45 +0200
Message-Id: <20180903121546.27673-1-johannes@sipsolutions.net> (sfid-20180903_141604_430542_42638ACE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

This time around for mac80211 I have a larger than usual number of
fixes, in part because Luca dumped our (Intel's) patches out after
quite a while - we'll try to make sure this doesn't happen again.

Shortlog below, as usual, each fix is pretty self-contained but it
adds up to quite a bit overall.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit ec0c96714e7ddeda4eccaa077f5646a0fd6e371f:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-08-11 11:22:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2018-09-03

for you to fetch changes up to c6e57b3896fc76299913b8cfd82d853bee8a2c84:

  mac80211: shorten the IBSS debug messages (2018-09-03 10:41:27 +0200)

----------------------------------------------------------------
Here are quite a large number of fixes, notably:
 * various A-MSDU building fixes (currently only affects mt76)
 * syzkaller & spectre fixes in hwsim
 * TXQ vs. teardown fix that was causing crashes
 * embed WMM info in reg rule, bad code here had been causing crashes
 * one compilation issue with fix from Arnd (rfkill-gpio includes)
 * fixes for a race and bad data during/after channel switch
 * nl80211: a validation fix, attribute type & unit fixes
along with other small fixes.

----------------------------------------------------------------
Arnd Bergmann (1):
      rfkill-gpio: include linux/mod_devicetable.h

Arunk Khandavalli (1):
      cfg80211: nl80211_update_ft_ies() to validate NL80211_ATTR_IE

Dan Carpenter (1):
      cfg80211: fix a type issue in ieee80211_chandef_to_operating_class()

Danek Duvall (2):
      mac80211: correct use of IEEE80211_VHT_CAP_RXSTBC_X
      mac80211_hwsim: correct use of IEEE80211_VHT_CAP_RXSTBC_X

Dreyfuss, Haim (1):
      mac80211: fix WMM TXOP calculation

Emmanuel Grumbach (4):
      mac80211: don't update the PM state of a peer upon a multicast frame
      mac80211: fix a race between restart and CSA flows
      mac80211: don't Tx a deauth frame if the AP forbade Tx
      mac80211: shorten the IBSS debug messages

Haim Dreyfuss (2):
      nl80211: Fix nla_put_u8 to u16 for NL80211_WMMR_TXOP
      nl80211: Pass center frequency in kHz instead of MHz

Ilan Peer (1):
      mac80211: Fix station bandwidth setting after channel switch

Jinbum Park (1):
      mac80211_hwsim: Fix possible Spectre-v1 for hwsim_world_regdom_custom

Johannes Berg (3):
      mac80211_hwsim: require at least one channel
      cfg80211: remove division by size of sizeof(struct ieee80211_wmm_rule)
      mac80211: always account for A-MSDU header changes

Lorenzo Bianconi (2):
      mac80211: do not convert to A-MSDU if frag/subframe limited
      mac80211: fix an off-by-one issue in A-MSDU max_subframe computation

Sara Sharon (1):
      mac80211: avoid kernel panic when building AMSDU from non-linear SKB

Stanislaw Gruszka (1):
      cfg80211: make wmm_rule part of the reg_rule structure

Toke Høiland-Jørgensen (1):
      mac80211: Run TXQ teardown code before de-registering interfaces

Yuan-Chi Pang (1):
      mac80211: mesh: fix HWMP sequence numbering to follow standard

 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 50 ++----------
 drivers/net/wireless/mac80211_hwsim.c              | 12 ++-
 include/net/cfg80211.h                             |  4 +-
 include/net/regulatory.h                           |  4 +-
 net/mac80211/ibss.c                                | 22 +++---
 net/mac80211/main.c                                | 28 +++++--
 net/mac80211/mesh_hwmp.c                           |  4 +
 net/mac80211/mlme.c                                | 70 ++++++++++++++++-
 net/mac80211/rx.c                                  |  1 +
 net/mac80211/tx.c                                  | 54 +++++++------
 net/mac80211/util.c                                | 11 ++-
 net/rfkill/rfkill-gpio.c                           |  1 +
 net/wireless/nl80211.c                             | 15 ++--
 net/wireless/reg.c                                 | 91 ++++------------------
 net/wireless/util.c                                |  2 +-
 15 files changed, 182 insertions(+), 187 deletions(-)
