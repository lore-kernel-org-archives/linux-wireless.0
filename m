Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbbCPVXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 17:23:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 0/4] mac80211: inform the low level driver about events in mac80211
Date: Mon, 16 Mar 2015 23:23:33 +0200
Message-Id: <1426541017-10516-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150316_222346_779584_5A736C6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be useful to know what is happening in mac80211
from the low level driver without guessing from mac80211's
callbacks.
This can be used for error detection (too many deauths)
and trigger recovery / debug flows based on that
information.
Another possibility is to change parameters that are not
controlled by mac80211 based on this. For example, after
a few association failures, a device may change its BT
Coexist scheme or modify the time sharing between its
vifs.

I use these patches in iwlwifi for debug only (currently).
This allows me to collect firmware debug data upon
authentication failure / deauth Rx etc...

Emmanuel Grumbach (4):
  mac80211: convert rssi_callback() to event_callback()
  mac80211: notify the driver about authentication status
  mac80211: notify the driver about association status
  mac80211: notify the driver about deauth

 drivers/net/wireless/iwlwifi/dvm/mac80211.c    | 15 ++--
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  4 +-
 include/net/mac80211.h                         | 90 ++++++++++++++++++++---
 net/mac80211/driver-ops.h                      | 12 ++--
 net/mac80211/mlme.c                            | 99 ++++++++++++++++++++------
 net/mac80211/trace.h                           | 14 ++--
 8 files changed, 185 insertions(+), 53 deletions(-)

-- 
1.9.1

