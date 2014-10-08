Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34552 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754401AbaJHGtQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 02:49:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Wed,  8 Oct 2014 09:48:33 +0300
Message-Id: <1412750920-15392-1-git-send-email-luca@coelho.fi> (sfid-20141008_084924_515515_4EE77E2E)
Subject: [PATCH v2 0/7] mac80211: some more channel switch work
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Hi,

A few minor changes in v2:

  * add WARN_ON to make sure csa_active is set in
    ieee80211_chswitch_post_beacon() [Michal];
  * remove stray empty line [Michal];
  * s/vifos/vif/ in a mac80211.h declaration (no clue where the "os"
    came from :P);

---8<---

These patches contain some more channel switch work.  They have been
in use in our internal tree for some time now and are mostly adding
small details needed by the iwlmvm driver.  There's also a nice
improvement to a long-time TODO, where we wait for a beacon on the new
channel before we start transmitting again (in BSS station/P2P client
mode).

One slightly controversial change is the one that allows channel
switches with multiple channel contexts.  The problem is not with
mult-context itself, but the handling of drivers that offload the
channel switch and have, so far, not received any information about
the vif that is switching (so the assumption was that all vifs would
have to switch).

Please review.

--
Cheers,
Luca.

Luciano Coelho (7):
  nl80211: sanity check the channel switch counter value
  mac80211: add device_timestamp to the ieee80211_channel_switch struct
  mac80211: add extended channel switching capability if the driver
    supports CSA
  mac80211: add pre_channel_switch driver operation
  mac80211: add post_channel_switch driver operation
  mac80211: wait for the first beacon on the new channel after CSA
  mac80211: allow channel switch with multiple channel contexts

 drivers/net/wireless/iwlegacy/4965-mac.c    |   2 +-
 drivers/net/wireless/iwlegacy/4965.h        |   5 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |   1 +
 drivers/net/wireless/ti/wlcore/main.c       |  23 ++----
 include/linux/ieee80211.h                   |   5 ++
 include/net/mac80211.h                      |  17 +++++
 net/mac80211/cfg.c                          |  18 ++++-
 net/mac80211/driver-ops.h                   |  41 ++++++++++-
 net/mac80211/ieee80211_i.h                  |   5 ++
 net/mac80211/iface.c                        |   2 +
 net/mac80211/main.c                         |  20 ++---
 net/mac80211/mlme.c                         | 110 ++++++++++++++++++----------
 net/mac80211/trace.h                        |  50 ++++++++++++-
 net/wireless/nl80211.c                      |  10 ++-
 14 files changed, 237 insertions(+), 72 deletions(-)

-- 
2.1.1

