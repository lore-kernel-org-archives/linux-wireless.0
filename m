Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43220 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752159AbdHIHHP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:07:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  9 Aug 2017 10:07:04 +0300
Message-Id: <20170809070706.14862-1-luca@coelho.fi> (sfid-20170809_090719_226745_A8711E27)
Subject: [PATCH 0/2] iwlwifi: one more fix intended for 4.13 2017-08-09
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

This is the mac80211+iwlwifi fix we talked about earlier.  As I
mentioned, the iwlwifi patch fixes a severe degradation of throughput
in the 9000 device series, due to a BA-session getting stuck and the
lack of future aggregation.  The mac80211 patch adds a new callback
that allows us to solve this problem.

As agreed, I'm planning to apply this to my tree and send a
pull-request containing both patches.

Please review and let me know if there are any issues.

Cheers,
Luca.


Naftali Goldstein (2):
  mac80211: add api to start ba session timer expired flow
  iwlwifi: mvm: send delba upon rx ba session timeout

 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  4 ++--
 include/net/mac80211.h                       | 15 +++++++++++++++
 net/mac80211/agg-rx.c                        | 22 +++++++++++++++++++++-
 3 files changed, 38 insertions(+), 3 deletions(-)

-- 
2.13.2
