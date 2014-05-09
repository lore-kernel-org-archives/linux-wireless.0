Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44351 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756503AbaEILMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:43 +0300
Message-Id: <1399633911-12788-1-git-send-email-luca@coelho.fi> (sfid-20140509_131220_753455_9A74B6C1)
Subject: [PATCH 0/8] mac80211/cfg80211/iwlwifi: a few channel-switch patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

These are a few channel-switch patches by Andrei that we have in our
internal tree.  I have rebased them for upstream.

--
Cheers,
Luca.

Andrei Otcheretianski (8):
  cfg80211: Add API to update CSA counters in mgmt frames
  mac80211: Update CSA counters in mgmt frames
  cfg80211: Support multiple CSA counters
  mac80211: Support multiple CSA counters
  iwlwifi: mvm: Add AP/GO channel switch support
  mac80211: Provide ieee80211_beacon_get_template API
  mac80211: Handle the CSA counters correctly
  iwlwifi: mvm: Use beacon_get_template instead of beacon_get

 drivers/net/wireless/iwlwifi/iwl-fw.h       |   2 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  15 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  44 ++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   2 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   2 +-
 include/net/cfg80211.h                      |  22 +++-
 include/net/mac80211.h                      |  64 ++++++++--
 include/uapi/linux/nl80211.h                |  19 ++-
 net/mac80211/cfg.c                          |  38 +++++-
 net/mac80211/ibss.c                         |   2 +-
 net/mac80211/ieee80211_i.h                  |   5 +-
 net/mac80211/main.c                         |   2 +
 net/mac80211/mesh.c                         |   2 +-
 net/mac80211/tx.c                           | 189 ++++++++++++++++++++--------
 net/wireless/core.c                         |   2 +
 net/wireless/nl80211.c                      |  87 ++++++++++---
 net/wireless/trace.h                        |  22 ++--
 17 files changed, 418 insertions(+), 101 deletions(-)

-- 
2.0.0.rc0

