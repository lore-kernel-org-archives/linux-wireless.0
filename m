Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46910 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727577AbeIEJeo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:34:44 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Sep 2018 08:06:05 +0300
Message-Id: <20180905050614.23273-1-luca@coelho.fi> (sfid-20180905_070629_959046_FC3D09D4)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [RESEND PATCH v2 0/9] cfg80211/mac80211: reworked patches from our internal tree 2018-08-31
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

[I'm resending this set again due to the corrupted X-SA headers in the
previous attempts.  I have now removed all the X-SA headers and
hopefully it will work fine.  Please let me know if you still have
issues with it.]

I'm resending the patches that came out corrupted, excluding patch 22
that was already in and with 19 and 20 reworked.

I've left 9 and 12 out for now, because they still need to be reworked
according to your comments.

Please review.

Cheers,
Luca.


Andrei Otcheretianski (3):
  cfg80211: reg: Init wiphy_idx in regulatory_hint_core()
  mac80211: Always report TX status
  mac80211: Don't wake up from PS for offchannel TX

Naftali Goldstein (1):
  mac80211: fix saving a few HE values

Sara Sharon (3):
  mac80211: add an option for station management TXQ
  mac80211: allow AMSDU size limitation per-TID
  mac80211: add an option for drivers to check if packets can be
    aggregated

Shaul Triebitz (2):
  mac80211: support reporting 0-length PSDU in radiotap
  wireless: align to draft 11ax D3.0

 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 51 ++++++++----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 -
 drivers/net/wireless/mac80211_hwsim.c         | 18 ++---
 include/linux/ieee80211.h                     | 72 ++++++++++-------
 include/net/ieee80211_radiotap.h              |  6 ++
 include/net/mac80211.h                        | 21 +++++
 net/mac80211/debugfs.c                        |  1 +
 net/mac80211/debugfs_sta.c                    | 77 +++++++++++++------
 net/mac80211/driver-ops.h                     | 10 +++
 net/mac80211/mlme.c                           | 17 ++--
 net/mac80211/rx.c                             | 12 ++-
 net/mac80211/status.c                         |  7 +-
 net/mac80211/tx.c                             | 25 +++++-
 net/wireless/reg.c                            |  1 +
 14 files changed, 227 insertions(+), 95 deletions(-)

-- 
2.18.0
