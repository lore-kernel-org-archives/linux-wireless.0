Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49390 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751907AbdIHJNG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 05:13:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  8 Sep 2017 12:12:46 +0300
Message-Id: <20170908091256.25279-1-luca@coelho.fi> (sfid-20170908_111310_915089_60117B15)
Subject: [PATCH 00/10] iwlwifi: fixes intended for 4.14 2017-09-08
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here is my first batch of fixes intended for 4.14.  Since it is very
early in the release process, I was a bit liberal with the fixes I'm
sending, but they all fix real issues.

These are the fixes:

* A couple of bugzilla bugs related to multicast handling;
* Two fixes for WoWLAN bugs that were causing queue hangs and
  re-initialization problems;
* Two fixes for potential uninitialized variable use reported by Dan
  Carpenter in relation to a recently introduced patch;
* A fix for buffer reordering in the newly supported 9000 device
  family;
* Fix a race when starting aggregation;
* Small fix for a recent patch to wake mac80211 queues;
* Send non-bufferable management frames in the generic queue so they
  are not sent on queues that are under power-save;

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Avraham Stern (2):
  iwlwifi: mvm: send all non-bufferable frames on the probe queue
  iwlwifi: mvm: wake the correct mac80211 queue

David Spinadel (1):
  iwlwifi: mvm: Flush non STA TX queues

Luca Coelho (4):
  iwlwifi: mvm: use IWL_HCMD_NOCOPY for MCAST_FILTER_CMD
  iwlwifi: mvm: handle FIF_ALLMULTI when setting multicast addresses
  iwlwifi: mvm: initialize status in iwl_mvm_add_int_sta_common()
  iwlwifi: mvm: set status before calling iwl_mvm_send_cmd_status()

Matt Chen (1):
  iwlwifi: mvm: fix wowlan resume failed to load INIT ucode

Naftali Goldstein (1):
  iwlwifi: mvm: change state when queueing agg start work

Sara Sharon (1):
  iwlwifi: mvm: fix reorder buffer for 9000 devices

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 62 +++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  7 +--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  8 +--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 10 ++--
 9 files changed, 80 insertions(+), 17 deletions(-)

-- 
2.14.1
