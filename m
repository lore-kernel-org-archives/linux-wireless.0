Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51998 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933845AbeF3InE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 04:43:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
        ilan.peer@intel.com, johannes@sipsolutions.net,
        liad.kaufman@intel.com, sara.sharon@intel.com,
        shaul.triebitz@intel.com, Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Jun 2018 11:42:49 +0300
Message-Id: <20180630084253.30660-1-luca@coelho.fi> (sfid-20180630_104311_804717_D8922042)
Subject: [PATCH v2 0/4] iwlwifi: updates intended for v4.19 2018-06-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Here's v2 of the patches I sent out Tuesday.  It fixes some bitfield.h
warnings reported by kbuildbot in .../iwlwifi/fw/api/rx.h.

There is still one compiler warning in this series, but that's
actually a bug in bitfield.h itself.  Johannes has sent a fix for
that[1] but it has not been applied yet.

These patches implement 802.11ax in the iwlwifi driver.  They are a
combination of over 40 patches from our internal tree and represent
the result of an evolution from the first drafts up to version D2.0.

This is exceptionally based on mac80211-next/master as of today,
commit a42177505869 ("mac80211: use BIT_ULL for NL80211_STA_INFO_*
attribute types"), because Johannes sent a pull request with the
changes I need yesterday, but DaveM hasn't pulled it yet.  Hopefully
that will happen soon, and then I'll ask you to pull from Dave's tree
so the dependencies will all be in before I send the pull request.

The only change this time:

* Implement 802.11ax D2.0;

Many people worked on the original patches in the internal tree, so
I'll name them here (rather than having many s-o-b tags in the actual
patches):

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Ilan Peer <ilan.peer@intel.com>
Johannes Berg <johannes.berg@intel.com>
Liad Kaufman <liad.kaufman@intel.com>
Sara Sharon <sara.sharon@intel.com>
Shaul Triebitz <shaul.triebitz@intel.com>

As usual, I'm pushing this to a pending branch, for kbuild bot, and
will send a pull-request later.

Please review.

Cheers,
Luca.


Luca Coelho (4):
  iwlwifi: fw: add FW APIs for HE
  iwlwifi: add support for IEEE802.11ax
  iwlwifi: add module parameter to disable 802.11ax
  iwlwifi: mvm: add radiotap data for HE

 .../wireless/intel/iwlwifi/fw/api/datapath.h  |   5 +
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 172 +++++++++++
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   |   4 +-
 .../net/wireless/intel/iwlwifi/fw/api/rs.h    |  36 ++-
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  53 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |   4 +
 .../wireless/intel/iwlwifi/iwl-modparams.h    |   4 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 103 +++++++
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   4 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 198 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   1 +
 .../net/wireless/intel/iwlwifi/mvm/rs-fw.c    |  44 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  39 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h   |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 281 +++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h  |   6 +-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |   2 +-
 19 files changed, 950 insertions(+), 37 deletions(-)

-- 
2.18.0
