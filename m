Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751958AbdFJKw4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 06:52:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 10 Jun 2017 13:52:45 +0300
Message-Id: <20170610105246.26455-4-luca@coelho.fi> (sfid-20170610_125402_307261_5FD72BB9)
In-Reply-To: <20170610105246.26455-1-luca@coelho.fi>
References: <20170610105246.26455-1-luca@coelho.fi>
Subject: [PATCH 3/4] mac80211: don't send SMPS action frame in AP mode when not needed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

mac80211 allows to modify the SMPS state of an AP both,
when it is started, and after it has been started. Such a
change will trigger an action frame to all the peers that
are currently connected, and will be remembered so that
new peers will get notified as soon as they connect (since
the SMPS setting in the beacon may not be the right one).

This means that we need to remember the SMPS state
currently requested as well as the SMPS state that was
configured initially (and advertised in the beacon).
The former is bss->req_smps and the latter is
sdata->smps_mode.

Initially, the AP interface could only be started with
SMPS_OFF, which means that sdata->smps_mode was SMPS_OFF
always. Later, a nl80211 API was added to be able to start
an AP with a different AP mode. That code forgot to update
bss->req_smps and because of that, if the AP interface was
started with SMPS_DYNAMIC, we had:
   sdata->smps_mode = SMPS_DYNAMIC
   bss->req_smps = SMPS_OFF

That configuration made mac80211 think it needs to fire off
an action frame to any new station connecting to the AP in
order to let it know that the actual SMPS configuration is
SMPS_OFF.

Fix that by properly setting bss->req_smps in
ieee80211_start_ap.

Fixes: f69931748730 ("mac80211: set smps_mode according to ap params")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6980a936a437..f9eb2486d550 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -902,6 +902,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	default:
 		return -EINVAL;
 	}
+	sdata->u.ap.req_smps = sdata->smps_mode;
+
 	sdata->needed_rx_chains = sdata->local->rx_chains;
 
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
-- 
2.11.0
